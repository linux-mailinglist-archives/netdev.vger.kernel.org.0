Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAD456F118B
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 07:59:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345179AbjD1F7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 01:59:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjD1F7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 01:59:12 -0400
Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246FA2735
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 22:59:06 -0700 (PDT)
X-QQ-mid: bizesmtp65t1682661474t97kz9ua
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 28 Apr 2023 13:57:52 +0800 (CST)
X-QQ-SSF: 01400000000000N0S000000A0000000
X-QQ-FEAT: ILHsT53NKPhuS8yINFS7s9u6tsqzh8V7MeewIfyt99EQwvdmbgHnGZGOptDlp
        b/DUIW335NpV7FtxJ0EHaD9c7h1DsrrvegO1aR06T5ndmZGJiehDfwoHOa0I30KuAd0V+p4
        ljQ0bZ71AZs0uEbgV1u6XCD3ksWNdted1ckSFgASROhXFNszEBLGhwCdXlLMQeG3JBSCost
        1RoQs0hQ83gREdYTpapBQKjvIoCIek6AlPJs24r6Pl/plkaaQ8mCvIZxCpwsMYW8qkMFrcl
        QOAsvbchsLR5Pmvft3onpsMa0WAHNO6xJ9vFi3CKLClVIxg9xf2Y3NyjJDOf0IlFH9SHGiv
        +JIVv+IKwSae0DYjFT8XdfXBCZUvIIBUVp3Ba0Ekga8f3VQwktfT4boSbzbX9lfOax5wDf8
        nTwcYvSf5Lw=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 9849711682203809023
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [RFC PATCH net-next v4 7/7] net: txgbe: Implement vlan add and remove ops
Date:   Fri, 28 Apr 2023 13:57:09 +0800
Message-Id: <20230428055709.66071-8-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230428055709.66071-1-mengyuanlou@net-swift.com>
References: <20230428055709.66071-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz6a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

txgbe add ndo_vlan_rx_add_vid and ndo_vlan_rx_kill_vid.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c | 4 ++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index be795d175aed..00b8a43a87e1 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -258,6 +258,7 @@ static void txgbe_reset(struct wx *wx)
 	if (err != 0)
 		wx_err(wx, "Hardware Error: %d\n", err);
 
+	wx_start_hw(wx);
 	/* do not flush user set addresses */
 	memcpy(old_addr, &wx->mac_table[0].addr, netdev->addr_len);
 	wx_flush_sw_mac_table(wx);
@@ -330,6 +331,7 @@ static int txgbe_sw_init(struct wx *wx)
 	wx->mac.max_tx_queues = TXGBE_SP_MAX_TX_QUEUES;
 	wx->mac.max_rx_queues = TXGBE_SP_MAX_RX_QUEUES;
 	wx->mac.mcft_size = TXGBE_SP_MC_TBL_SIZE;
+	wx->mac.vft_size = TXGBE_SP_VFT_TBL_SIZE;
 	wx->mac.rx_pb_size = TXGBE_SP_RX_PB_SIZE;
 	wx->mac.tx_pb_size = TXGBE_SP_TDB_PB_SZ;
 
@@ -494,6 +496,8 @@ static const struct net_device_ops txgbe_netdev_ops = {
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_mac_address    = wx_set_mac,
 	.ndo_get_stats64        = wx_get_stats64,
+	.ndo_vlan_rx_add_vid    = wx_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid   = wx_vlan_rx_kill_vid,
 };
 
 /**
diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
index 63a1c733718d..032972369965 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
@@ -77,6 +77,7 @@
 #define TXGBE_SP_MAX_RX_QUEUES  128
 #define TXGBE_SP_RAR_ENTRIES    128
 #define TXGBE_SP_MC_TBL_SIZE    128
+#define TXGBE_SP_VFT_TBL_SIZE   128
 #define TXGBE_SP_RX_PB_SIZE     512
 #define TXGBE_SP_TDB_PB_SZ      (160 * 1024) /* 160KB Packet Buffer */
 
-- 
2.40.0

