Return-Path: <netdev+bounces-2635-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C079702C58
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:10:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BABC42811BB
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:10:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1692C8CA;
	Mon, 15 May 2023 12:09:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7923C8C0
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:09:20 +0000 (UTC)
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F69FB
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:09:18 -0700 (PDT)
X-QQ-mid: bizesmtp77t1684152552t4bskk20
Received: from localhost.localdomain ( [115.200.228.151])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 15 May 2023 20:09:11 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: PYCoNkl0TFIUZ4ttZgd7PxykntxughzcqmLH0BwgHH6ekjU4v+eFlidR1PSkO
	jDDxmu7z3tcAL5VnlbgqFbgVOdELrBKvM6QSy292lwrTbC6xl0THRH/G8FtVLeRPbJjXF1a
	IS+NepIv8BZQOqZjngKVRKzWbEUGZN8o2pwsB3vPIdHX+kJaqN71zP23mNyEoxd0/Fp6PGN
	ZfoQVMLS0tzWH7j6VTHMpFmO2AOs4HB5TYqWCeSAoOPXbndToimQ0rLX5W6JSNin1xR7nOs
	KZFkZTlzEGqJfiIfw/dpwF0go3rbLypG1p6Gk9Cv5nO+S0IHJOQnFvw0lF0FsDLEHOob/o2
	4C4MnAkm/eQn0EL09DWg6QiI0G2a80Qk78mVGVE44NFCzEvkK/vZXnrDAToY0LBJ87mt85o
	1gOs2TL4SJZvrQg39AEuGQ==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 11205105552046849386
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v5 6/8] net: ngbe: Implement vlan add and remove ops
Date: Mon, 15 May 2023 20:08:27 +0800
Message-Id: <20230515120829.74861-7-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515120829.74861-1-mengyuanlou@net-swift.com>
References: <20230515120829.74861-1-mengyuanlou@net-swift.com>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

ngbe add ndo_vlan_rx_add_vid and ndo_vlan_rx_kill_vid.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 3 +++
 drivers/net/ethernet/wangxun/ngbe/ngbe_type.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index f234c9c4b942..c99a5d3de72e 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -115,6 +115,7 @@ static int ngbe_sw_init(struct wx *wx)
 	wx->mac.max_rx_queues = NGBE_MAX_RX_QUEUES;
 	wx->mac.max_tx_queues = NGBE_MAX_TX_QUEUES;
 	wx->mac.mcft_size = NGBE_MC_TBL_SIZE;
+	wx->mac.vft_size = NGBE_SP_VFT_TBL_SIZE;
 	wx->mac.rx_pb_size = NGBE_RX_PB_SIZE;
 	wx->mac.tx_pb_size = NGBE_TDB_PB_SZ;
 
@@ -477,6 +478,8 @@ static const struct net_device_ops ngbe_netdev_ops = {
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_mac_address    = wx_set_mac,
 	.ndo_get_stats64        = wx_get_stats64,
+	.ndo_vlan_rx_add_vid    = wx_vlan_rx_add_vid,
+	.ndo_vlan_rx_kill_vid   = wx_vlan_rx_kill_vid,
 };
 
 /**
diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
index 373d5af628cd..b70eca397b67 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_type.h
@@ -136,6 +136,7 @@ enum NGBE_MSCA_CMD_value {
 #define NGBE_RAR_ENTRIES			32
 #define NGBE_RX_PB_SIZE				42
 #define NGBE_MC_TBL_SIZE			128
+#define NGBE_SP_VFT_TBL_SIZE			128
 #define NGBE_TDB_PB_SZ				(20 * 1024) /* 160KB Packet Buffer */
 
 /* TX/RX descriptor defines */
-- 
2.40.1


