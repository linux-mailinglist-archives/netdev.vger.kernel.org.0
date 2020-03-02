Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 964F1175D3C
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 15:33:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727465AbgCBOdW convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 2 Mar 2020 09:33:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29299 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727053AbgCBOdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 09:33:21 -0500
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-2uJCSkYtMj2heJwRPlg6aA-1; Mon, 02 Mar 2020 09:33:17 -0500
X-MC-Unique: 2uJCSkYtMj2heJwRPlg6aA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9EA641021FD8;
        Mon,  2 Mar 2020 14:33:15 +0000 (UTC)
Received: from krava.redhat.com (ovpn-205-46.brq.redhat.com [10.40.205.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E781492D11;
        Mon,  2 Mar 2020 14:33:11 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Song Liu <song@kernel.org>
Subject: [PATCH 15/15] perf annotate: Add base support for bpf_image
Date:   Mon,  2 Mar 2020 15:31:54 +0100
Message-Id: <20200302143154.258569-16-jolsa@kernel.org>
In-Reply-To: <20200302143154.258569-1-jolsa@kernel.org>
References: <20200302143154.258569-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding the DSO_BINARY_TYPE__BPF_IMAGE dso binary type
to recognize bpf images that carry trampoline or dispatcher.

Upcoming patches will add support to read the image data,
store it within the BPF feature in perf.data and display
it for annotation purposes.

Currently we only display following message:

  # ./perf annotate bpf_trampoline_24456 --stdio
   Percent |      Source code & Disassembly of . for cycles (504  ...
  --------------------------------------------------------------- ...
           :       to be implemented

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/annotate.c | 20 ++++++++++++++++++++
 tools/perf/util/dso.c      |  1 +
 tools/perf/util/dso.h      |  1 +
 tools/perf/util/machine.c  | 11 +++++++++++
 tools/perf/util/symbol.c   |  1 +
 5 files changed, 34 insertions(+)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index ca73fb74ad03..d9e606e11936 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1843,6 +1843,24 @@ static int symbol__disassemble_bpf(struct symbol *sym __maybe_unused,
 }
 #endif // defined(HAVE_LIBBFD_SUPPORT) && defined(HAVE_LIBBPF_SUPPORT)
 
+static int
+symbol__disassemble_bpf_image(struct symbol *sym,
+			      struct annotate_args *args)
+{
+	struct annotation *notes = symbol__annotation(sym);
+	struct disasm_line *dl;
+
+	args->offset = -1;
+	args->line = strdup("to be implemented");
+	args->line_nr = 0;
+	dl = disasm_line__new(args);
+	if (dl)
+		annotation_line__add(&dl->al, &notes->src->source);
+
+	free(args->line);
+	return 0;
+}
+
 /*
  * Possibly create a new version of line with tabs expanded. Returns the
  * existing or new line, storage is updated if a new line is allocated. If
@@ -1942,6 +1960,8 @@ static int symbol__disassemble(struct symbol *sym, struct annotate_args *args)
 
 	if (dso->binary_type == DSO_BINARY_TYPE__BPF_PROG_INFO) {
 		return symbol__disassemble_bpf(sym, args);
+	} else if (dso->binary_type == DSO_BINARY_TYPE__BPF_IMAGE) {
+		return symbol__disassemble_bpf_image(sym, args);
 	} else if (dso__is_kcore(dso)) {
 		kce.kcore_filename = symfs_filename;
 		kce.addr = map__rip_2objdump(map, sym->start);
diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 91f21239608b..f338990e0fe6 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -191,6 +191,7 @@ int dso__read_binary_type_filename(const struct dso *dso,
 	case DSO_BINARY_TYPE__GUEST_KALLSYMS:
 	case DSO_BINARY_TYPE__JAVA_JIT:
 	case DSO_BINARY_TYPE__BPF_PROG_INFO:
+	case DSO_BINARY_TYPE__BPF_IMAGE:
 	case DSO_BINARY_TYPE__NOT_FOUND:
 		ret = -1;
 		break;
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index 2db64b79617a..9553a1fd9e8a 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -40,6 +40,7 @@ enum dso_binary_type {
 	DSO_BINARY_TYPE__GUEST_KCORE,
 	DSO_BINARY_TYPE__OPENEMBEDDED_DEBUGINFO,
 	DSO_BINARY_TYPE__BPF_PROG_INFO,
+	DSO_BINARY_TYPE__BPF_IMAGE,
 	DSO_BINARY_TYPE__NOT_FOUND,
 };
 
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 463ada5117f8..372ed147bed5 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -719,6 +719,12 @@ int machine__process_switch_event(struct machine *machine __maybe_unused,
 	return 0;
 }
 
+static int is_bpf_image(const char *name)
+{
+	return strncmp(name, "bpf_trampoline_", sizeof("bpf_trampoline_") - 1) ||
+	       strncmp(name, "bpf_dispatcher_", sizeof("bpf_dispatcher_") - 1);
+}
+
 static int machine__process_ksymbol_register(struct machine *machine,
 					     union perf_event *event,
 					     struct perf_sample *sample __maybe_unused)
@@ -743,6 +749,11 @@ static int machine__process_ksymbol_register(struct machine *machine,
 		map->end = map->start + event->ksymbol.len;
 		maps__insert(&machine->kmaps, map);
 		dso__set_loaded(dso);
+
+		if (is_bpf_image(event->ksymbol.name)) {
+			dso->binary_type = DSO_BINARY_TYPE__BPF_IMAGE;
+			dso__set_long_name(dso, "", false);
+		}
 	}
 
 	sym = symbol__new(map->map_ip(map, map->start),
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 3b379b1296f1..e6caec4b6054 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1537,6 +1537,7 @@ static bool dso__is_compatible_symtab_type(struct dso *dso, bool kmod,
 		return true;
 
 	case DSO_BINARY_TYPE__BPF_PROG_INFO:
+	case DSO_BINARY_TYPE__BPF_IMAGE:
 	case DSO_BINARY_TYPE__NOT_FOUND:
 	default:
 		return false;
-- 
2.24.1

