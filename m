Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E902337838
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 16:42:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234372AbhCKPl5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 10:41:57 -0500
Received: from mga14.intel.com ([192.55.52.115]:42361 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234144AbhCKPll (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 10:41:41 -0500
IronPort-SDR: HqEnAtAa6MEdS01TPnLFZkB6Z6hCMwCtgXukmfKuurQ4TNmrMaI32HJ4v3h+uJ8nhvrPIsvqih
 coevsZezHriw==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="188050700"
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="188050700"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2021 07:41:25 -0800
IronPort-SDR: jw9Y/+ye/qJ324chQMOd2WBBAbiOK9jskpBl0t2cEY5r9v6EH4Y8+KS7cRxZABZ/25Xtp0fjy7
 6uySb58nvChQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,241,1610438400"; 
   d="scan'208";a="589253518"
Received: from ranger.igk.intel.com ([10.102.21.164])
  by orsmga005.jf.intel.com with ESMTP; 11 Mar 2021 07:41:22 -0800
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org, daniel@iogearbox.net,
        ast@kernel.org
Cc:     bjorn.topel@intel.com, magnus.karlsson@intel.com,
        ciara.loftus@intel.com, john.fastabend@gmail.com, toke@redhat.com,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next 07/17] samples: bpf: do not unload prog within xdpsock
Date:   Thu, 11 Mar 2021 16:29:00 +0100
Message-Id: <20210311152910.56760-8-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210311152910.56760-1-maciej.fijalkowski@intel.com>
References: <20210311152910.56760-1-maciej.fijalkowski@intel.com>
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
index 1e2a1105d0e6..aa696854be78 100644
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

