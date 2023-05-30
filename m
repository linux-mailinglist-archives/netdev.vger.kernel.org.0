Return-Path: <netdev+bounces-6219-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F7337153AB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 04:29:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C81EA1C20B65
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 02:29:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F328A749E;
	Tue, 30 May 2023 02:27:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E889C46B4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 02:27:45 +0000 (UTC)
Received: from smtpbgau2.qq.com (smtpbgau2.qq.com [54.206.34.216])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7112A7
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 19:27:43 -0700 (PDT)
X-QQ-mid: bizesmtp68t1685413657tqxss40u
Received: from localhost.localdomain ( [183.159.96.128])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 30 May 2023 10:27:37 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: znfcQSa1hKaupTNJiQlGoG2mGamgWQIWUBn1PZVcOn2dDKUw/X08VznSy8767
	sA3ZIrDIgARv7XrEf7tuR+ChQo+7qw88r+N014E4DeONMBWzf8dCxkS1i3QmaxHqo9+2YNf
	7N8Kj6ubD8n4MV7sYaCdp4loqtyqWby8EJ+LW6nsJAJ7aHLfv35uken7w8ooiG+6k8A8huB
	XhXPfb/QjUx7Mfn5OxZNzdkvCxHIQMPB1BMfE4C+oWJMfMLZBjlMmAY5rId2D1i+Yg/I3NS
	uc/jkeHuv2QBmSsuiwnbkcnt8U8lqnrJf9s/pTQrTMsY5SoNUjvrxupQvSNhyKcVpjRcLW7
	9URkB6c4NdqXXFsWl8+jOJxOks/2Zj9/Mm7V1dCKOJ90SqtpU1nLHL00XQcP7tM20Q74/Pv
	/TNSrMQpnLaJ4Ly/1gaD6A==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 9973421316499342521
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [RESEND,PATCH net-next v7 8/8] net: txgbe: Implement vlan add and remove ops
Date: Tue, 30 May 2023 10:26:32 +0800
Message-Id: <20230530022632.17938-9-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230530022632.17938-1-mengyuanlou@net-swift.com>
References: <20230530022632.17938-1-mengyuanlou@net-swift.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:net-swift.com:qybglogicsvrgz:qybglogicsvrgz5a-3
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

txgbe add ndo_vlan_rx_add_vid and ndo_vlan_rx_kill_vid.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/txgbe/txgbe_main.c | 4 ++++
 drivers/net/ethernet/wangxun/txgbe/txgbe_type.h | 1 +
 2 files changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index bcc9c2959177..0f0d9fa1cde1 100644
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
 
@@ -495,6 +497,8 @@ static const struct net_device_ops txgbe_netdev_ops = {
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
2.40.1


