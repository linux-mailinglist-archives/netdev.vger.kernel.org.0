Return-Path: <netdev+bounces-2636-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB842702C5A
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:10:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9783D2812E8
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:10:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9E4EC8FC;
	Mon, 15 May 2023 12:09:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA94C8C0
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:09:24 +0000 (UTC)
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB8CFB
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:09:22 -0700 (PDT)
X-QQ-mid: bizesmtp77t1684152556tm0k60kc
Received: from localhost.localdomain ( [115.200.228.151])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 15 May 2023 20:09:15 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: IV30oiqrgAb4YJnV8d9FELA21rndCpocRnn94l82FGpreZ93HpBGZjugQJTjb
	5HQs3lPRFzBy7ka2ozwVi/5QR3ZDJvoHdkmMQhjLG4EmqqsDvv7KlJ9tmUVt8kYymcVAVyo
	F+U23SWcsozbrK+9S1ONvenmyR+tHomEKr4fuJPH089dXBlFNM+Y4jsKJmZBbWRr+S7wAgX
	RZcRjBxa9d80+97NJl6X739OqXz7+nSDYHINncQx13g3BEn3vBLk+pqCkMdp387hWFCFdAx
	jxVO7AWPOmxlGjcAkEWlEbnq8CSTU/5Cy/TnV0wkAQkWA8+2r50L9VNXkmnHpfSXEyT/CBk
	n66EGauvS4s9jy4hoYdIOC8M1ShspL1o0txwb3NaG1b7OUcL5iapk6VjDArApTkVUBhcY9V
	yVeD2vH7+5I=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 1890453446461890486
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v5 7/8] net: txgbe: Add netdev features support
Date: Mon, 15 May 2023 20:08:28 +0800
Message-Id: <20230515120829.74861-8-mengyuanlou@net-swift.com>
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

Add features and hw_features that ngbe can support.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 21 ++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 5b8a121fb496..bcc9c2959177 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -491,6 +491,7 @@ static const struct net_device_ops txgbe_netdev_ops = {
 	.ndo_change_mtu         = wx_change_mtu,
 	.ndo_start_xmit         = wx_xmit_frame,
 	.ndo_set_rx_mode        = wx_set_rx_mode,
+	.ndo_set_features       = wx_set_features,
 	.ndo_validate_addr      = eth_validate_addr,
 	.ndo_set_mac_address    = wx_set_mac,
 	.ndo_get_stats64        = wx_get_stats64,
@@ -596,11 +597,25 @@ static int txgbe_probe(struct pci_dev *pdev,
 		goto err_free_mac_table;
 	}
 
-	netdev->features |= NETIF_F_HIGHDMA;
-	netdev->features = NETIF_F_SG;
-
+	netdev->features = NETIF_F_SG |
+			   NETIF_F_TSO |
+			   NETIF_F_TSO6 |
+			   NETIF_F_RXHASH |
+			   NETIF_F_RXCSUM |
+			   NETIF_F_HW_CSUM;
+
+	netdev->gso_partial_features =  NETIF_F_GSO_ENCAP_ALL;
+	netdev->features |= netdev->gso_partial_features;
+	netdev->features |= NETIF_F_SCTP_CRC;
+	netdev->vlan_features |= netdev->features | NETIF_F_TSO_MANGLEID;
+	netdev->hw_enc_features |= netdev->vlan_features;
+	netdev->features |= NETIF_F_VLAN_FEATURES;
 	/* copy netdev features into list of user selectable features */
 	netdev->hw_features |= netdev->features | NETIF_F_RXALL;
+	netdev->hw_features |= NETIF_F_NTUPLE | NETIF_F_HW_TC;
+	netdev->features |= NETIF_F_HIGHDMA;
+	netdev->hw_features |= NETIF_F_GRO;
+	netdev->features |= NETIF_F_GRO;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
-- 
2.40.1


