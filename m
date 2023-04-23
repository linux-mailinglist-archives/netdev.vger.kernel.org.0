Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5A966EC0A3
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 16:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbjDWOwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 10:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230325AbjDWOwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 10:52:20 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570EF106;
        Sun, 23 Apr 2023 07:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682261539; x=1713797539;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=moN1ngKNVzYEcxVlG62AVEY/FosH4rEP6WkDsbZ2QdQ=;
  b=kh1yIRIiBm3rDKRdN/dq9OrKfrjx4mQw9TAkdMyeVbBlncuWepYCx/wy
   mtJWkvUWAySzFX/0pWBnWgJdw5bPd2Ky5AS1kVAzXfX4bPutAHZmGd3cF
   PdstSmE3nD7XtQAIFetlQCaac8YjNJbLf8Rw0xZtsYUXrs4gSqNNiYneD
   qTmjcgOG8Q4HnqBjCaO4a1o3c4KFniASi/OMP9yfQAbBXIvFIAUvjjHtu
   S3zH1muu8xNGz5jIziCMJ0UyTDBzp3Z7s/V0dUsLLJhKAaQY4CBlN4zxq
   7a94A4d2wyBe2wgzKpIHTRENvudu3Chepwmdv1i5p4ess3+YT12QGpmTs
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="325890274"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="325890274"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2023 07:52:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10689"; a="836680705"
X-IronPort-AV: E=Sophos;i="5.99,220,1677571200"; 
   d="scan'208";a="836680705"
Received: from unknown (HELO intel-71.bj.intel.com) ([10.238.154.71])
  by fmsmga001.fm.intel.com with ESMTP; 23 Apr 2023 07:52:15 -0700
From:   Zhu Yanjun <yanjun.zhu@intel.com>
To:     jgg@ziepe.ca, leon@kernel.org, zyjzyj2000@gmail.com,
        linux-rdma@vger.kernel.org, parav@nvidia.com,
        netdev@vger.kernel.org, rain.1986.08.12@gmail.com
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: [PATCH rdma-next v4 8/8] RDMA/rxe: Replace l_sk6 with sk6 in net namespace
Date:   Sun, 23 Apr 2023 22:48:22 +0800
Message-Id: <20230423144822.1797465-9-yanjun.zhu@intel.com>
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

The net namespace variable sk6 can be used. As such, l_sk6 can be
replaced with it.

Tested-by: Rain River <rain.1986.08.12@gmail.com>
Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
---
 drivers/infiniband/sw/rxe/rxe.c       |  1 -
 drivers/infiniband/sw/rxe/rxe_net.c   | 20 +-------------------
 drivers/infiniband/sw/rxe/rxe_verbs.h |  1 -
 3 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe.c b/drivers/infiniband/sw/rxe/rxe.c
index 96841c56ff3a..b1dfba2fdf15 100644
--- a/drivers/infiniband/sw/rxe/rxe.c
+++ b/drivers/infiniband/sw/rxe/rxe.c
@@ -75,7 +75,6 @@ static void rxe_init_device_param(struct rxe_dev *rxe)
 			rxe->ndev->dev_addr);
 
 	rxe->max_ucontext			= RXE_MAX_UCONTEXT;
-	rxe->l_sk6				= NULL;
 }
 
 /* initialize port attributes */
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 28d8171a36e8..812a0731bece 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -50,24 +50,6 @@ static struct dst_entry *rxe_find_route6(struct rxe_qp *qp,
 {
 	struct dst_entry *ndst;
 	struct flowi6 fl6 = { { 0 } };
-	struct rxe_dev *rdev;
-
-	rdev = rxe_get_dev_from_net(ndev);
-	if (!rdev->l_sk6) {
-		struct sock *sk;
-
-		rcu_read_lock();
-		sk = udp6_lib_lookup(dev_net(ndev), NULL, 0, &in6addr_any,
-				     htons(ROCE_V2_UDP_DPORT), 0);
-		rcu_read_unlock();
-		if (!sk) {
-			pr_info("file: %s +%d, error\n", __FILE__, __LINE__);
-			return (struct dst_entry *)sk;
-		}
-		__sock_put(sk);
-		rdev->l_sk6 = sk->sk_socket;
-	}
-
 
 	memset(&fl6, 0, sizeof(fl6));
 	fl6.flowi6_oif = ndev->ifindex;
@@ -76,7 +58,7 @@ static struct dst_entry *rxe_find_route6(struct rxe_qp *qp,
 	fl6.flowi6_proto = IPPROTO_UDP;
 
 	ndst = ipv6_stub->ipv6_dst_lookup_flow(dev_net(ndev),
-					       rdev->l_sk6->sk, &fl6,
+					       rxe_ns_pernet_sk6(dev_net(ndev)), &fl6,
 					       NULL);
 	if (IS_ERR(ndst)) {
 		rxe_dbg_qp(qp, "no route to %pI6\n", daddr);
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.h b/drivers/infiniband/sw/rxe/rxe_verbs.h
index 0aa3817770a5..26a20f088692 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.h
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.h
@@ -382,7 +382,6 @@ struct rxe_dev {
 
 	struct rxe_port		port;
 	struct crypto_shash	*tfm;
-	struct socket		*l_sk6;
 };
 
 static inline void rxe_counter_inc(struct rxe_dev *rxe, enum rxe_counters index)
-- 
2.27.0

