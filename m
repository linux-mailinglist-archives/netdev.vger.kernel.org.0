Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977B856A32A
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 15:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235165AbiGGNIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 09:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234163AbiGGNIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 09:08:53 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F169C2AD1;
        Thu,  7 Jul 2022 06:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657199332; x=1688735332;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CRQwTIU46Zf+tRTgOEouZdo6fiCXwghgpIo4sXDIGQM=;
  b=OSgbIudo7evzdl0g2EdQCnltcROYeTu1DdgoqtEhSOTeHFTMw+2D1uEJ
   ANRraI3G4NKFeESffnW/9hnqWbltEo6At6aiNddHC8hCjYYizVF/isnnv
   QohZl8ajtSamnZLZtUVR7082yZWEcWYnsWh5DU4oOBjM5gxRdLrgQmY17
   pAD2DiSRggoy6wnPBQKZezTNhB2w1nnblRlqFA+6kkzA7pqbRAk9WW/wz
   aLXaoqjchYR6wZftdh5CsoYf9Ebgm2oP4NdT3mXjs4Z82B+Xw60Jc+nUP
   /RtPT6puJbPhlenMgmzC7G1oYPSPTd/RFsMW1FU7S2h6LiCGC+vJdvGZ8
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10400"; a="284044239"
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="284044239"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jul 2022 06:08:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,253,1650956400"; 
   d="scan'208";a="683304324"
Received: from boxer.igk.intel.com ([10.102.20.173])
  by FMSMGA003.fm.intel.com with ESMTP; 07 Jul 2022 06:08:50 -0700
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Subject: [PATCH v2 bpf-next] xsk: mark napi_id on sendmsg()
Date:   Thu,  7 Jul 2022 15:08:42 +0200
Message-Id: <20220707130842.49408-1-maciej.fijalkowski@intel.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When application runs in busy poll mode and does not receive a single
packet but only sends them, it is currently
impossible to get into napi_busy_loop() as napi_id is only marked on Rx
side in xsk_rcv_check(). In there, napi_id is being taken from
xdp_rxq_info carried by xdp_buff. From Tx perspective, we do not have
access to it. What we have handy is the xsk pool.

Xsk pool works on a pool of internal xdp_buff wrappers called
xdp_buff_xsk. AF_XDP ZC enabled drivers call xp_set_rxq_info() so each
of xdp_buff_xsk has a valid pointer to xdp_rxq_info of underlying queue.
Therefore, on Tx side, napi_id can be pulled from
xs->pool->heads[0].xdp.rxq->napi_id. Hide this pointer chase under
helper function, xsk_pool_get_napi_id().

Do this only for sockets working in ZC mode as otherwise rxq pointers
would not be initialized.

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
---

v2:
* target bpf-next instead of bpf and don't treat it as fix (Bjorn)
* hide pointer chasing under helper function (Bjorn)

 include/net/xdp_sock_drv.h | 14 ++++++++++++++
 net/xdp/xsk.c              |  5 ++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 4aa031849668..4277b0dcee05 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -44,6 +44,15 @@ static inline void xsk_pool_set_rxq_info(struct xsk_buff_pool *pool,
 	xp_set_rxq_info(pool, rxq);
 }
 
+static inline unsigned int xsk_pool_get_napi_id(struct xsk_buff_pool *pool)
+{
+#ifdef CONFIG_NET_RX_BUSY_POLL
+	return pool->heads[0].xdp.rxq->napi_id;
+#else
+	return 0;
+#endif
+}
+
 static inline void xsk_pool_dma_unmap(struct xsk_buff_pool *pool,
 				      unsigned long attrs)
 {
@@ -198,6 +207,11 @@ static inline void xsk_pool_set_rxq_info(struct xsk_buff_pool *pool,
 {
 }
 
+static inline unsigned int xsk_pool_get_napi_id(struct xsk_buff_pool *pool)
+{
+	return 0;
+}
+
 static inline void xsk_pool_dma_unmap(struct xsk_buff_pool *pool,
 				      unsigned long attrs)
 {
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 19ac872a6624..86a97da7e50b 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -637,8 +637,11 @@ static int __xsk_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len
 	if (unlikely(need_wait))
 		return -EOPNOTSUPP;
 
-	if (sk_can_busy_loop(sk))
+	if (sk_can_busy_loop(sk)) {
+		if (xs->zc)
+			__sk_mark_napi_id_once(sk, xsk_pool_get_napi_id(xs->pool));
 		sk_busy_loop(sk, 1); /* only support non-blocking sockets */
+	}
 
 	if (xs->zc && xsk_no_wakeup(sk))
 		return 0;
-- 
2.27.0

