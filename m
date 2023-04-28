Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16B76F1188
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 07:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345357AbjD1F6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 01:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345321AbjD1F6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 01:58:04 -0400
Received: from smtpbg153.qq.com (smtpbg153.qq.com [13.245.218.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9BC630D5
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 22:57:59 -0700 (PDT)
X-QQ-mid: bizesmtp65t1682661470t97h2jyr
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 28 Apr 2023 13:57:48 +0800 (CST)
X-QQ-SSF: 01400000000000N0S000000A0000000
X-QQ-FEAT: iDzLjIm7mlY7ZMMfL2fvazkLqeCkq3qFN27KaC/X2S80csIPDbQqlksx5JS6/
        iIPYDl2ZKqF496KsGvGAn4Avpyb7EyFM2GO8lGG6XQjmmNQ8vgTVYe3oIxjMyRPIcDydDGF
        MfEZn3wgtFi6pfY8XRecb6YcVss8Ic1ZqGK8fJyU+1Md0Y27J0S1juTn5a0nR59H0M36Bi1
        MPLiwZvDXcEAp6zYEdmr17PXXaZqgqafgG1s43jccG980lKTNThSka2Ixn4EkNIt1DKsWaB
        2ynRQNYPYPBh073BhEdD7rMNPTjg2ba0HtA55QBo88erRAb6pIsPfgo2B1g1H5yA1xVWB2U
        w0XQfLqW7tgefKP5dLNQqHPm3f9w5xtM1nt+MzgIAvmCyQgW9kKsSfUZd4mohvu2XhQY4+H
        Ua9Ys4bhm7I=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 5605068190928646738
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [RFC PATCH net-next v4 6/7] net: txgbe add netdev features support
Date:   Fri, 28 Apr 2023 13:57:08 +0800
Message-Id: <20230428055709.66071-7-mengyuanlou@net-swift.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230428055709.66071-1-mengyuanlou@net-swift.com>
References: <20230428055709.66071-1-mengyuanlou@net-swift.com>
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

Add features and hw_features that ngbe can support.

Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
---
 .../net/ethernet/wangxun/txgbe/txgbe_main.c   | 20 ++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
index 5b8a121fb496..be795d175aed 100644
--- a/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
+++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_main.c
@@ -596,11 +596,25 @@ static int txgbe_probe(struct pci_dev *pdev,
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
2.40.0

