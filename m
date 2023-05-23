Return-Path: <netdev+bounces-4513-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92EF270D238
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 05:09:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4D344281197
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 03:09:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70E416FC7;
	Tue, 23 May 2023 03:07:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BB6BA50
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 03:07:45 +0000 (UTC)
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56D2C8F
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 20:07:43 -0700 (PDT)
X-QQ-mid: bizesmtp73t1684811257tbs3nrsd
Received: from localhost.localdomain ( [122.235.247.1])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 23 May 2023 11:07:35 +0800 (CST)
X-QQ-SSF: 01400000000000N0Z000000A0000000
X-QQ-FEAT: CR3LFp2JE4keLOj7WX5572cezqsW7p/jxbxg7UPEH1v7LawGi/Ak+P65EAovN
	aqS+IyjK1zSakOx4d22QhNGXN5ieGQaNy2vFMf54xq/8W6wBkFZC7xX0wcFZ4xC47F0GVif
	Bt/mQNIqCYBr4qvhFE/ksqGaHeaOP6+8/RBtUa5BOTuLQtBcl6ZhU6hLv5+M20d4b9qln7q
	4DDu5bqm73bcX+JeBL67EIhu47mh3qxYovLDt+wHykyOj+jxrc54F6wlBdX1r1oZPl5mZ0E
	ibZsc1mwtzYhDeheHmfMAoyWvsl5veA3ptNZ+t6lrJcf6S4+A1AIUrp/y+zmvN98Tv9qb3x
	/r5mg+mLRykh+EFmWY5Ph2jxTKF3c6f3gXhS06qcmvnXxTq37stJG58kNIgzjqFnYUOMGO2
	adIX0MRlbGI=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 411285511663280859
From: Mengyuan Lou <mengyuanlou@net-swift.com>
To: netdev@vger.kernel.org
Cc: jiawenwu@trustnetic.com,
	Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next v6 7/8] net: txgbe: Add netdev features support
Date: Tue, 23 May 2023 11:06:57 +0800
Message-Id: <20230523030658.17738-8-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230523030658.17738-1-mengyuanlou@net-swift.com>
References: <20230523030658.17738-1-mengyuanlou@net-swift.com>
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
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
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


