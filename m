Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65F67128082
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 17:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbfLTQTq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 11:19:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25115 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727233AbfLTQTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 11:19:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576858785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=TmJnS3HCxwRtsAKDDX85SHeoQH/w6bXWYKPiA+1cU2w=;
        b=CFzV/ejPN87v6n3rftkCQ1BHmxykjA8Nhf8fJMJ+DxZ6W4LbxW1QgjBIQWyTV+fUgijqSu
        5pfAXIC+7jrUIFkNs1QJL7OUsEKXI+kzMrqgkmKBcBrXoxs1lYmqqOmWrmxZ3HIKTM3Da9
        hH+KMLxiZNuqUMCQoHIynkqPkEh2y9I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-289-qgGRdT4EP6Gl47I2-iiHAw-1; Fri, 20 Dec 2019 11:19:42 -0500
X-MC-Unique: qgGRdT4EP6Gl47I2-iiHAw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EDBE800D48;
        Fri, 20 Dec 2019 16:19:41 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 018811001DD8;
        Fri, 20 Dec 2019 16:19:38 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 859A430736C73;
        Fri, 20 Dec 2019 17:19:36 +0100 (CET)
Subject: [PATCH bpf] samples/bpf: xdp_redirect_cpu fix missing tracepoint
 attach
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        maciejromanfijalkowski@gmail.com,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?utf-8?b?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        andrii.nakryiko@gmail.com
Date:   Fri, 20 Dec 2019 17:19:36 +0100
Message-ID: <157685877642.26195.2798780195186786841.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sample xdp_redirect_cpu was converted to use libbpf, the
tracepoints used by this sample were not getting attached automatically
like with bpf_load.c. The BPF-maps was still getting loaded, thus
nobody notice that the tracepoints were not updating these maps.

This fix doesn't use the new skeleton code, as this bug was introduced
in v5.1 and stable might want to backport this. E.g. Red Hat QA uses
this sample as part of their testing.

Fixes: bbaf6029c49c ("samples/bpf: Convert XDP samples to libbpf usage")
Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 samples/bpf/xdp_redirect_cpu_user.c |   59 +++++++++++++++++++++++++++++++++--
 1 file changed, 55 insertions(+), 4 deletions(-)

diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redirect_cpu_user.c
index 72af628529b5..79a2fb7d16cb 100644
--- a/samples/bpf/xdp_redirect_cpu_user.c
+++ b/samples/bpf/xdp_redirect_cpu_user.c
@@ -16,6 +16,10 @@ static const char *__doc__ =
 #include <getopt.h>
 #include <net/if.h>
 #include <time.h>
+#include <linux/limits.h>
+
+#define __must_check
+#include <linux/err.h>
 
 #include <arpa/inet.h>
 #include <linux/if_link.h>
@@ -46,6 +50,10 @@ static int cpus_count_map_fd;
 static int cpus_iterator_map_fd;
 static int exception_cnt_map_fd;
 
+#define NUM_TP 5
+struct bpf_link *tp_links[NUM_TP] = { 0 };
+static int tp_cnt = 0;
+
 /* Exit return codes */
 #define EXIT_OK		0
 #define EXIT_FAIL		1
@@ -88,6 +96,10 @@ static void int_exit(int sig)
 			printf("program on interface changed, not removing\n");
 		}
 	}
+	/* Detach tracepoints */
+	while (tp_cnt)
+		bpf_link__destroy(tp_links[--tp_cnt]);
+
 	exit(EXIT_OK);
 }
 
@@ -588,23 +600,61 @@ static void stats_poll(int interval, bool use_separators, char *prog_name,
 	free_stats_record(prev);
 }
 
+static struct bpf_link * attach_tp(struct bpf_object *obj,
+				   const char *tp_category,
+				   const char* tp_name)
+{
+	struct bpf_program *prog;
+	struct bpf_link *link;
+	char sec_name[PATH_MAX];
+	int len;
+
+	len = snprintf(sec_name, PATH_MAX, "tracepoint/%s/%s",
+		       tp_category, tp_name);
+	if (len < 0)
+		exit(EXIT_FAIL);
+
+	prog = bpf_object__find_program_by_title(obj, sec_name);
+	if (!prog) {
+		fprintf(stderr, "ERR: finding progsec: %s\n", sec_name);
+		exit(EXIT_FAIL_BPF);
+	}
+
+	link = bpf_program__attach_tracepoint(prog, tp_category, tp_name);
+	if (IS_ERR(link))
+		exit(EXIT_FAIL_BPF);
+
+	return link;
+}
+
+static void init_tracepoints(struct bpf_object *obj) {
+	tp_links[tp_cnt++] = attach_tp(obj, "xdp", "xdp_redirect_err");
+	tp_links[tp_cnt++] = attach_tp(obj, "xdp", "xdp_redirect_map_err");
+	tp_links[tp_cnt++] = attach_tp(obj, "xdp", "xdp_exception");
+	tp_links[tp_cnt++] = attach_tp(obj, "xdp", "xdp_cpumap_enqueue");
+	tp_links[tp_cnt++] = attach_tp(obj, "xdp", "xdp_cpumap_kthread");
+}
+
 static int init_map_fds(struct bpf_object *obj)
 {
-	cpu_map_fd = bpf_object__find_map_fd_by_name(obj, "cpu_map");
-	rx_cnt_map_fd = bpf_object__find_map_fd_by_name(obj, "rx_cnt");
+	/* Maps updated by tracepoints */
 	redirect_err_cnt_map_fd =
 		bpf_object__find_map_fd_by_name(obj, "redirect_err_cnt");
+	exception_cnt_map_fd =
+		bpf_object__find_map_fd_by_name(obj, "exception_cnt");
 	cpumap_enqueue_cnt_map_fd =
 		bpf_object__find_map_fd_by_name(obj, "cpumap_enqueue_cnt");
 	cpumap_kthread_cnt_map_fd =
 		bpf_object__find_map_fd_by_name(obj, "cpumap_kthread_cnt");
+
+	/* Maps used by XDP */
+	rx_cnt_map_fd = bpf_object__find_map_fd_by_name(obj, "rx_cnt");
+	cpu_map_fd = bpf_object__find_map_fd_by_name(obj, "cpu_map");
 	cpus_available_map_fd =
 		bpf_object__find_map_fd_by_name(obj, "cpus_available");
 	cpus_count_map_fd = bpf_object__find_map_fd_by_name(obj, "cpus_count");
 	cpus_iterator_map_fd =
 		bpf_object__find_map_fd_by_name(obj, "cpus_iterator");
-	exception_cnt_map_fd =
-		bpf_object__find_map_fd_by_name(obj, "exception_cnt");
 
 	if (cpu_map_fd < 0 || rx_cnt_map_fd < 0 ||
 	    redirect_err_cnt_map_fd < 0 || cpumap_enqueue_cnt_map_fd < 0 ||
@@ -662,6 +712,7 @@ int main(int argc, char **argv)
 			strerror(errno));
 		return EXIT_FAIL;
 	}
+	init_tracepoints(obj);
 	if (init_map_fds(obj) < 0) {
 		fprintf(stderr, "bpf_object__find_map_fd_by_name failed\n");
 		return EXIT_FAIL;


