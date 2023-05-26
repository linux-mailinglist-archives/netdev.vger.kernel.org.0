Return-Path: <netdev+bounces-5579-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A6B37122ED
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:04:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D9E371C2100C
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:04:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12B10101FD;
	Fri, 26 May 2023 09:03:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 093D1111A3
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:03:15 +0000 (UTC)
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78185119
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 02:03:12 -0700 (PDT)
X-QQ-mid: bizesmtp89t1685091784tdemj9zh
Received: from localhost.localdomain ( [125.120.148.168])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Fri, 26 May 2023 17:03:03 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: znfcQSa1hKa5cDnuRiYBZWgF0mRL/LDU0OXgt1yyWkSHnYJkYM3pCYJao2vFj
	1KbM3KAknRlmPqF7rEl3lWRSNinR1FLAw46Lzcmn/6xylt9FgeqsREPLlqWn7z07GTEYyHs
	C7PrNLid9PauZ7jLpJEaMBsTIzoq1tPm/n1nw1VU7LQE6dz1UCAUfNmkrSUoUIcY5fL6VwF
	hmiCXBy2vLL3a2B6kRL+Gljvb1WApt1Sb4Cq67AenHYPxpg9iOqEoEmBrg424LYZhJBehic
	7wAFFMRq/THbvFA/K3f17i1idnaXDsfV6TEyhnl0/JuQNv45UpelGGzgEnFomHqIw6HbOTW
	kRI+qD/uqcMPWu4lIFm7WDUXtiHyBckXWU9byzvoXhJ3lCRVjDl0jsc1+WXbnAYTVAXCtkx
	TbAq+an7pXYiQInfSZitaQ==
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 3560439683407533064
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v7 6/8] net: ngbe: Implement vlan add and remove ops
Date: Fri, 26 May 2023 17:02:28 +0800
Message-Id: <20230526090230.71487-7-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230526090230.71487-1-mengyuanlou@net-swift.com>
References: <20230526090230.71487-1-mengyuanlou@net-swift.com>
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


