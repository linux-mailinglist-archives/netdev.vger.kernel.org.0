Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53CF16EC09F
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 16:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230501AbjDWOw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 10:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbjDWOwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 10:52:18 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDCF7E4C;
        Sun, 23 Apr 2023 07:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682261537; x=1713797537;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DSfAzSMf/l2Xaeaq4nN9qSmuEXyLXgaiESrEmDgD0Po=;
  b=GOd7x3CmzvNz3WSXG1CWhrEkNgMc0MI65JK0+jNhIyFpPX/cH60+odBN
   NW8qQOd8ytJp5yOSQJj0cw/4ltkEsIImF+SiFfpcZuMvwEcJ8BLx9BI1c
   JJrZPv/qyS1DGNWjrb4AkAgnSreG/XtUiXHHRyk2r3y1pGc2iqDRIekqF
   QTysGJCuHQgr+Lz8Hu4vPYmHl8HMkewLabgC6Bh7rtsjFagNAc+6FU3sc
   RUBOiWCnjY0DfV89G36jDBNk4PdlbWgk65QlcawUshhnrB6r7njFCK+T9
   w5evYAF+Y2LZGoPh27Yb23gjR7Q+MM5BRimgh5MNSGOPmqsD0jXf07fM/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="325890246"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="325890246"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 07:52:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="836680673"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="836680673"
Received: from unknown (HELO intel-71.bj.intel.com) ([10.238.154.71])
  by fmsmga001.fm.intel.com with ESMTP; 23 Apr 2023 07:52:05 -0700
From:   Zhu Yanjun <yanjun.zhu@intel.com>
To:     jgg@ziepe.ca, leon@kernel.org, zyjzyj2000@gmail.com,
        linux-rdma@vger.kernel.org, parav@nvidia.com,
        netdev@vger.kernel.org, rain.1986.08.12@gmail.com
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH rdma-next v4 4/8] RDMA/rxe: Implement dellink in rxe
Date:   Sun, 23 Apr 2023 22:48:18 +0800
Message-Id: <20230423144822.1797465-5-yanjun.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20230423144822.1797465-1-yanjun.zhu@intel.com>
References: <20230423144822.1797465-1-yanjun.zhu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@linux.dev>

When running "rdma link del" command, dellink function will be called.
If the sock refcnt is greater than the refcnt needed for udp tunnel,
the sock refcnt will be decreased by 1.

If equal, the last rdma link is removed. The udp tunnel will be
destroyed.

Tested-by: Rain River <rain.1986.08.12@gmail.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/infiniband/sw/rxe/rxe.c     | 12 +++++++++++-
 drivers/infiniband/sw/rxe/rxe_net.c | 17 +++++++++++++++--
 drivers/infiniband/sw/rxe/rxe_net.h |  1 +
 3 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index c15d3c5d7a6f..ac7e7b0a9dc9 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -168,10 +168,12 @@ void rxe_set_mtu(struct rxe_dev *rxe, unsigned int ndev_mtu)
 /* called by ifc layer to create new rxe device.
  * The caller should allocate memory for rxe by calling ib_alloc_device.
  */
+static struct rdma_link_ops rxe_link_ops;
 int rxe_add(struct rxe_dev *rxe, unsigned int mtu, const char *ibdev_name)
 {
 	rxe_init(rxe);
 	rxe_set_mtu(rxe, mtu);
+	rxe->ib_dev.link_ops = &rxe_link_ops;
 
 	return rxe_register_device(rxe, ibdev_name);
 }
@@ -208,9 +210,17 @@ static int rxe_newlink(const char *ibdev_name, struct net_device *ndev)
 	return err;
 }
 
-struct rdma_link_ops rxe_link_ops = {
+static int rxe_dellink(struct ib_device *dev)
+{
+	rxe_net_del(dev);
+
+	return 0;
+}
+
+static struct rdma_link_ops rxe_link_ops = {
 	.type = "rxe",
 	.newlink = rxe_newlink,
+	.dellink = rxe_dellink,
 };
 
 static int __init rxe_module_init(void)
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 1b98efa2cf66..6071533d67c8 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -533,6 +533,21 @@ int rxe_net_add(const char *ibdev_name, struct net_device *ndev)
 	return 0;
 }
 
+#define SK_REF_FOR_TUNNEL	2
+void rxe_net_del(struct ib_device *dev)
+{
+	if (refcount_read(&recv_sockets.sk6->sk->sk_refcnt) > SK_REF_FOR_TUNNEL)
+		__sock_put(recv_sockets.sk6->sk);
+	else
+		rxe_release_udp_tunnel(recv_sockets.sk6);
+
+	if (refcount_read(&recv_sockets.sk4->sk->sk_refcnt) > SK_REF_FOR_TUNNEL)
+		__sock_put(recv_sockets.sk4->sk);
+	else
+		rxe_release_udp_tunnel(recv_sockets.sk4);
+}
+#undef SK_REF_FOR_TUNNEL
+
 static void rxe_port_event(struct rxe_dev *rxe,
 			   enum ib_event_type event)
 {
@@ -692,8 +707,6 @@ int rxe_register_notifier(void)
 
 void rxe_net_exit(void)
 {
-	rxe_release_udp_tunnel(recv_sockets.sk6);
-	rxe_release_udp_tunnel(recv_sockets.sk4);
 	unregister_netdevice_notifier(&rxe_net_notifier);
 }
 
diff --git a/drivers/infiniband/sw/rxe/rxe_net.h b/drivers/infiniband/sw/rxe/rxe_net.h
index a222c3eeae12..f48f22f3353b 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.h
+++ b/drivers/infiniband/sw/rxe/rxe_net.h
@@ -17,6 +17,7 @@ struct rxe_recv_sockets {
 };
 
 int rxe_net_add(const char *ibdev_name, struct net_device *ndev);
+void rxe_net_del(struct ib_device *dev);
 
 int rxe_register_notifier(void);
 int rxe_net_init(void);
-- 
2.27.0

