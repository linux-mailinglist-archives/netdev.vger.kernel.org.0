Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1DE31BEAB
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 17:19:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhBOQPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 11:15:51 -0500
Received: from mga06.intel.com ([134.134.136.31]:36145 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232545AbhBOP6j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 10:58:39 -0500
IronPort-SDR: sC1i4taMBYKI08tw3OCaUXHoaPevqk3hVRXC7/718dcQ4zGXyTQe7g15ZqWTaZ0vGarOBvxwRK
 pFwjj0v7elNw==
X-IronPort-AV: E=McAfee;i="6000,8403,9896"; a="244189545"
X-IronPort-AV: E=Sophos;i="5.81,181,1610438400"; 
   d="scan'208";a="244189545"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2021 07:56:42 -0800
IronPort-SDR: lnJZbnkCSLwAm380QlsnwlEnpTVyIC6wiSy7H7SlWqT2UoGRmzx2n+yTij2jRJJKFQBaWAHX3s
 wlt4ogU18Ajw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,181,1610438400"; 
   d="scan'208";a="383413542"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by fmsmga008.fm.intel.com with ESMTP; 15 Feb 2021 07:56:40 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     daniel@iogearbox.net, ast@kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     andrii@kernel.org, toke@redhat.com, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, ciara.loftus@intel.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH bpf-next 3/3] samples: bpf: do not unload prog within xdpsock
Date:   Mon, 15 Feb 2021 16:46:38 +0100
Message-Id: <20210215154638.4627-4-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
References: <20210215154638.4627-1-maciej.fijalkowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the introduction of bpf_link in xsk's libbpf part, there's no
further need for explicit unload of prog on xdpsock's termination. When
process dies, the bpf_link's refcount will be decremented and resources
will be unloaded/freed under the hood in case when there are no more
active users.

While at it, don't dump stats on error path.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---
 samples/bpf/xdpsock_user.c | 55 ++++++++++----------------------------
 1 file changed, 14 insertions(+), 41 deletions(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index db0cb73513a5..96246313e342 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -96,7 +96,6 @@ static int opt_xsk_frame_size = XSK_UMEM__DEFAULT_FRAME_SIZE;
 static int opt_timeout = 1000;
 static bool opt_need_wakeup = true;
 static u32 opt_num_xsks = 1;
-static u32 prog_id;
 static bool opt_busy_poll;
 static bool opt_reduced_cap;
 
@@ -462,59 +461,37 @@ static void *poller(void *arg)
 	return NULL;
 }
 
-static void remove_xdp_program(void)
+static void int_exit(int sig)
 {
-	u32 curr_prog_id = 0;
-	int cmd = CLOSE_CONN;
-
-	if (bpf_get_link_xdp_id(opt_ifindex, &curr_prog_id, opt_xdp_flags)) {
-		printf("bpf_get_link_xdp_id failed\n");
-		exit(EXIT_FAILURE);
-	}
-	if (prog_id == curr_prog_id)
-		bpf_set_link_xdp_fd(opt_ifindex, -1, opt_xdp_flags);
-	else if (!curr_prog_id)
-		printf("couldn't find a prog id on a given interface\n");
-	else
-		printf("program on interface changed, not removing\n");
-
-	if (opt_reduced_cap) {
-		if (write(sock, &cmd, sizeof(int)) < 0) {
-			fprintf(stderr, "Error writing into stream socket: %s", strerror(errno));
-			exit(EXIT_FAILURE);
-		}
-	}
+	benchmark_done = true;
 }
 
-static void int_exit(int sig)
+static void __exit_with_error(int error, const char *file, const char *func,
+			      int line)
 {
-	benchmark_done = true;
+	fprintf(stderr, "%s:%s:%i: errno: %d/\"%s\"\n", file, func,
+		line, error, strerror(error));
+	exit(EXIT_FAILURE);
 }
 
+#define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, __LINE__)
+
 static void xdpsock_cleanup(void)
 {
 	struct xsk_umem *umem = xsks[0]->umem->umem;
-	int i;
+	int i, cmd = CLOSE_CONN;
 
 	dump_stats();
 	for (i = 0; i < num_socks; i++)
 		xsk_socket__delete(xsks[i]->xsk);
 	(void)xsk_umem__delete(umem);
-	remove_xdp_program();
-}
 
-static void __exit_with_error(int error, const char *file, const char *func,
-			      int line)
-{
-	fprintf(stderr, "%s:%s:%i: errno: %d/\"%s\"\n", file, func,
-		line, error, strerror(error));
-	dump_stats();
-	remove_xdp_program();
-	exit(EXIT_FAILURE);
+	if (opt_reduced_cap) {
+		if (write(sock, &cmd, sizeof(int)) < 0)
+			exit_with_error(errno);
+	}
 }
 
-#define exit_with_error(error) __exit_with_error(error, __FILE__, __func__, \
-						 __LINE__)
 static void swap_mac_addresses(void *data)
 {
 	struct ether_header *eth = (struct ether_header *)data;
@@ -880,10 +857,6 @@ static struct xsk_socket_info *xsk_configure_socket(struct xsk_umem_info *umem,
 	if (ret)
 		exit_with_error(-ret);
 
-	ret = bpf_get_link_xdp_id(opt_ifindex, &prog_id, opt_xdp_flags);
-	if (ret)
-		exit_with_error(-ret);
-
 	xsk->app_stats.rx_empty_polls = 0;
 	xsk->app_stats.fill_fail_polls = 0;
 	xsk->app_stats.copy_tx_sendtos = 0;
-- 
2.20.1

