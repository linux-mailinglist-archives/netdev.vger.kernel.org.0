Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4AF76EDA10
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233216AbjDYBvR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbjDYBvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:51:14 -0400
Received: from smtpbg156.qq.com (smtpbg156.qq.com [15.184.82.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E31DDAD25
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 18:51:07 -0700 (PDT)
X-QQ-mid: bizesmtp86t1682387459tv6m2ydj
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 25 Apr 2023 09:50:58 +0800 (CST)
X-QQ-SSF: 01400000000000N0S000000A0000000
X-QQ-FEAT: QityeSR92A0VkX3RufWepp91kHhsUXsJ0P2hlCu3tSjudbnsEdZtTiBiDYOrU
        ZeZ8llT3otCjxhuNzyYu3rVJyV3p6p5IwD9MeXvc7HXEt3LjnWfHkgC/8DAZs0o53hEgrJk
        tjFqpj6zwDRl14wnShZ1Y7jnhhda1YTfF0mp9Kbf5z9ZFuYfzZnt6vF65o4NO1JKv5aQ4oP
        9BRe4FBF8MpfcxPEItFdqFgjENtsJ0IFbmCKD3smp2FUNP1+psC6OnmAFtSN/z3/CH5xfUo
        uZebHdorq8lNaQ3keQU8cKdrPP5+2mrNcG0acxSArQdnw0/eXttUlTdkUA7NRkUI+9N77k7
        hD56flBY5qFf6w1xaMbENeRqg5596dwU+NsvI8DWrlH/PFtVXf6eZgCNMPJ2MHdQbO0xnue
        W5CBCW1/EDY=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 3015573418642143950
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, linyunsheng@huawei.com,
        Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next 7/7] net: txgbe: Implement vlan add and remove ops
Date:   Tue, 25 Apr 2023 09:50:11 +0800
Message-Id: <20230425015011.19980-8-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230425015011.19980-1-mengyuanlou@net-swift.com>
References: <20230425015011.19980-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz6a-1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
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

