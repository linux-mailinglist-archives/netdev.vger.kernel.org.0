Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC55586627
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 17:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390136AbfHHPqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 11:46:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33754 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732760AbfHHPqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 11:46:52 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 876DD772C5;
        Thu,  8 Aug 2019 15:46:51 +0000 (UTC)
Received: from firesoul.localdomain (ovpn-200-48.brq.redhat.com [10.40.200.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6FAE6608AB;
        Thu,  8 Aug 2019 15:46:47 +0000 (UTC)
Received: from [10.10.10.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 9D5F73002D561;
        Thu,  8 Aug 2019 17:46:46 +0200 (CEST)
Subject: [bpf-next v2 PATCH 2/3] samples/bpf: make xdp_fwd more practically
 usable via devmap lookup
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     a.s.protopopov@gmail.com, dsahern@gmail.com,
        Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        ys114321@gmail.com, Jesper Dangaard Brouer <brouer@redhat.com>
Date:   Thu, 08 Aug 2019 17:46:46 +0200
Message-ID: <156527920658.20297.5634629362034006298.stgit@firesoul>
In-Reply-To: <156527914510.20297.12225832190052744019.stgit@firesoul>
References: <156527914510.20297.12225832190052744019.stgit@firesoul>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 08 Aug 2019 15:46:51 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This address the TODO in samples/bpf/xdp_fwd_kern.c, which points out
that the chosen egress index should be checked for existence in the
devmap. This can now be done via taking advantage of Toke's work in
commit 0cdbb4b09a06 ("devmap: Allow map lookups from eBPF").

This change makes xdp_fwd more practically usable, as this allows for
a mixed environment, where IP-forwarding fallback to network stack, if
the egress device isn't configured to use XDP.

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 samples/bpf/xdp_fwd_kern.c |   17 +++++++++++------
 samples/bpf/xdp_fwd_user.c |   36 +++++++++++++++++++++++++-----------
 2 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/samples/bpf/xdp_fwd_kern.c b/samples/bpf/xdp_fwd_kern.c
index e6ffc4ea06f4..a43d6953c054 100644
--- a/samples/bpf/xdp_fwd_kern.c
+++ b/samples/bpf/xdp_fwd_kern.c
@@ -104,13 +104,18 @@ static __always_inline int xdp_fwd_flags(struct xdp_md *ctx, u32 flags)
 
 	rc = bpf_fib_lookup(ctx, &fib_params, sizeof(fib_params), flags);
 
-	/* verify egress index has xdp support
-	 * TO-DO bpf_map_lookup_elem(&tx_port, &key) fails with
-	 *       cannot pass map_type 14 into func bpf_map_lookup_elem#1:
-	 * NOTE: without verification that egress index supports XDP
-	 *       forwarding packets are dropped.
-	 */
 	if (rc == 0) {
+		/* Verify egress index has been configured as TX-port.
+		 * (Note: User can still have inserted an egress ifindex that
+		 * doesn't support XDP xmit, which will result in packet drops).
+		 *
+		 * Note: lookup in devmap supported since 0cdbb4b09a0.
+		 * If not supported will fail with:
+		 *  cannot pass map_type 14 into func bpf_map_lookup_elem#1:
+		 */
+		if (!bpf_map_lookup_elem(&xdp_tx_ports, &fib_params.ifindex))
+			return XDP_PASS;
+
 		if (h_proto == htons(ETH_P_IP))
 			ip_decrease_ttl(iph);
 		else if (h_proto == htons(ETH_P_IPV6))
diff --git a/samples/bpf/xdp_fwd_user.c b/samples/bpf/xdp_fwd_user.c
index ba012d9f93dd..20951bc27477 100644
--- a/samples/bpf/xdp_fwd_user.c
+++ b/samples/bpf/xdp_fwd_user.c
@@ -27,14 +27,20 @@
 #include "libbpf.h"
 #include <bpf/bpf.h>
 
-
-static int do_attach(int idx, int fd, const char *name)
+static int do_attach(int idx, int prog_fd, int map_fd, const char *name)
 {
 	int err;
 
-	err = bpf_set_link_xdp_fd(idx, fd, 0);
-	if (err < 0)
+	err = bpf_set_link_xdp_fd(idx, prog_fd, 0);
+	if (err < 0) {
 		printf("ERROR: failed to attach program to %s\n", name);
+		return err;
+	}
+
+	/* Adding ifindex as a possible egress TX port */
+	err = bpf_map_update_elem(map_fd, &idx, &idx, 0);
+	if (err)
+		printf("ERROR: failed using device %s as TX-port\n", name);
 
 	return err;
 }
@@ -47,6 +53,9 @@ static int do_detach(int idx, const char *name)
 	if (err < 0)
 		printf("ERROR: failed to detach program from %s\n", name);
 
+	/* TODO: Remember to cleanup map, when adding use of shared map
+	 *  bpf_map_delete_elem((map_fd, &idx);
+	 */
 	return err;
 }
 
@@ -67,10 +76,10 @@ int main(int argc, char **argv)
 	};
 	const char *prog_name = "xdp_fwd";
 	struct bpf_program *prog;
+	int prog_fd, map_fd = -1;
 	char filename[PATH_MAX];
 	struct bpf_object *obj;
 	int opt, i, idx, err;
-	int prog_fd, map_fd;
 	int attach = 1;
 	int ret = 0;
 
@@ -103,8 +112,17 @@ int main(int argc, char **argv)
 			return 1;
 		}
 
-		if (bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd))
+		err = bpf_prog_load_xattr(&prog_load_attr, &obj, &prog_fd);
+		if (err) {
+			if (err == -22) {
+				printf("Does kernel support devmap lookup?\n");
+				/* If not, the error message will be:
+				 * "cannot pass map_type 14 into func
+				 * bpf_map_lookup_elem#1"
+				 */
+			}
 			return 1;
+		}
 
 		prog = bpf_object__find_program_by_title(obj, prog_name);
 		prog_fd = bpf_program__fd(prog);
@@ -119,10 +137,6 @@ int main(int argc, char **argv)
 			return 1;
 		}
 	}
-	if (attach) {
-		for (i = 1; i < 64; ++i)
-			bpf_map_update_elem(map_fd, &i, &i, 0);
-	}
 
 	for (i = optind; i < argc; ++i) {
 		idx = if_nametoindex(argv[i]);
@@ -138,7 +152,7 @@ int main(int argc, char **argv)
 			if (err)
 				ret = err;
 		} else {
-			err = do_attach(idx, prog_fd, argv[i]);
+			err = do_attach(idx, prog_fd, map_fd, argv[i]);
 			if (err)
 				ret = err;
 		}

