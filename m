Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73B721605FB
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 20:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728028AbgBPTb6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 16 Feb 2020 14:31:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41404 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727668AbgBPTbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 14:31:55 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-7nDvYxAmN4exEtzLaotL_Q-1; Sun, 16 Feb 2020 14:31:45 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D10801005516;
        Sun, 16 Feb 2020 19:31:42 +0000 (UTC)
Received: from krava.redhat.com (ovpn-204-28.brq.redhat.com [10.40.204.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8C6318AC5B;
        Sun, 16 Feb 2020 19:31:39 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/18] perf tools: Synthesize bpf_trampoline/dispatcher ksymbol event
Date:   Sun, 16 Feb 2020 20:30:03 +0100
Message-Id: <20200216193005.144157-17-jolsa@kernel.org>
In-Reply-To: <20200216193005.144157-1-jolsa@kernel.org>
References: <20200216193005.144157-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 7nDvYxAmN4exEtzLaotL_Q-1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Synthesize bpf images (trampolines/dispatchers) on start,
as ksymbol events from /proc/kallsyms. Having this perf
can recognize samples from those images and perf report
and top shows them correctly.

The rest of the ksymbol handling is already in place from
for the bpf programs monitoring, so only the initial state
was needed.

perf report output:

  # Overhead  Command     Shared Object                  Symbol

    12.37%  test_progs  [kernel.vmlinux]                 [k] entry_SYSCALL_64
    11.80%  test_progs  [kernel.vmlinux]                 [k] syscall_return_via_sysret
     9.63%  test_progs  bpf_prog_bcf7977d3b93787c_prog2  [k] bpf_prog_bcf7977d3b93787c_prog2
     6.90%  test_progs  bpf_trampoline_24456             [k] bpf_trampoline_24456
     6.36%  test_progs  [kernel.vmlinux]                 [k] memcpy_erms

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/bpf-event.c | 98 +++++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index a3207d900339..120ec547ae75 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -6,6 +6,9 @@
 #include <bpf/libbpf.h>
 #include <linux/btf.h>
 #include <linux/err.h>
+#include <linux/string.h>
+#include <internal/lib.h>
+#include <symbol/kallsyms.h>
 #include "bpf-event.h"
 #include "debug.h"
 #include "dso.h"
@@ -290,11 +293,87 @@ static int perf_event__synthesize_one_bpf_prog(struct perf_session *session,
 	return err ? -1 : 0;
 }
 
+struct kallsyms_parse {
+	union perf_event	*event;
+	perf_event__handler_t	 process;
+	struct machine		*machine;
+	struct perf_tool	*tool;
+};
+
+static int
+process_bpf_image(char *name, u64 addr, struct kallsyms_parse *data)
+{
+	struct machine *machine = data->machine;
+	union perf_event *event = data->event;
+	struct perf_record_ksymbol *ksymbol;
+	u32 size;
+
+	ksymbol = &event->ksymbol;
+
+	/*
+	 * The bpf image (trampoline/dispatcher) size is aligned to
+	 * page, while it starts little bit after the page boundary.
+	 */
+	size = page_size - (addr - PERF_ALIGN(addr, page_size));
+
+	*ksymbol = (struct perf_record_ksymbol) {
+		.header = {
+			.type = PERF_RECORD_KSYMBOL,
+			.size = offsetof(struct perf_record_ksymbol, name),
+		},
+		.addr      = addr,
+		.len       = size,
+		.ksym_type = PERF_RECORD_KSYMBOL_TYPE_BPF,
+		.flags     = 0,
+	};
+
+	strncpy(ksymbol->name, name, KSYM_NAME_LEN);
+	ksymbol->header.size += PERF_ALIGN(strlen(name) + 1, sizeof(u64));
+	memset((void *) event + event->header.size, 0, machine->id_hdr_size);
+	event->header.size += machine->id_hdr_size;
+
+	return perf_tool__process_synth_event(data->tool, event, machine,
+					      data->process);
+}
+
+static int
+kallsyms_process_symbol(void *data, const char *_name,
+			char type __maybe_unused, u64 start)
+{
+	char *module, *name;
+	unsigned long id;
+	int err = 0;
+
+	module = strchr(_name, '\t');
+	if (!module)
+		return 0;
+
+	/* We are going after [bpf] module ... */
+	if (strcmp(module + 1, "[bpf]"))
+		return 0;
+
+	name = memdup(_name, (module - _name) + 1);
+	if (!name)
+		return -ENOMEM;
+
+	name[module - _name] = 0;
+
+	/* .. and only for trampolines and dispatchers */
+	if ((sscanf(name, "bpf_trampoline_%lu", &id) == 1) ||
+	    (sscanf(name, "bpf_dispatcher_%lu", &id) == 1))
+		err = process_bpf_image(name, start, data);
+
+	free(name);
+	return err;
+}
+
 int perf_event__synthesize_bpf_events(struct perf_session *session,
 				      perf_event__handler_t process,
 				      struct machine *machine,
 				      struct record_opts *opts)
 {
+	const char *kallsyms_filename = "/proc/kallsyms";
+	struct kallsyms_parse arg;
 	union perf_event *event;
 	__u32 id = 0;
 	int err;
@@ -303,6 +382,8 @@ int perf_event__synthesize_bpf_events(struct perf_session *session,
 	event = malloc(sizeof(event->bpf) + KSYM_NAME_LEN + machine->id_hdr_size);
 	if (!event)
 		return -1;
+
+	/* Synthesize all the bpf programs in system. */
 	while (true) {
 		err = bpf_prog_get_next_id(id, &id);
 		if (err) {
@@ -335,6 +416,23 @@ int perf_event__synthesize_bpf_events(struct perf_session *session,
 			break;
 		}
 	}
+
+	/* Synthesize all the bpf images - trampolines/dispatchers. */
+	if (symbol_conf.kallsyms_name != NULL)
+		kallsyms_filename = symbol_conf.kallsyms_name;
+
+	arg = (struct kallsyms_parse) {
+		.event   = event,
+		.process = process,
+		.machine = machine,
+		.tool    = session->tool,
+	};
+
+	if (kallsyms__parse(kallsyms_filename, &arg, kallsyms_process_symbol)) {
+		pr_err("%s: failed to synthesize bpf images: %s\n",
+		       __func__, strerror(errno));
+	}
+
 	free(event);
 	return err;
 }
-- 
2.24.1

