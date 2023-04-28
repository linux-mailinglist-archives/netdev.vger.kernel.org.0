Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE0B6F1186
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 07:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345071AbjD1F54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 01:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345203AbjD1F5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 01:57:52 -0400
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC85F2689
        for <netdev@vger.kernel.org>; Thu, 27 Apr 2023 22:57:49 -0700 (PDT)
X-QQ-mid: bizesmtp65t1682661462tl3770b9
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Fri, 28 Apr 2023 13:57:40 +0800 (CST)
X-QQ-SSF: 01400000000000N0S000000A0000000
X-QQ-FEAT: q+EIYT+FhZqPJfNqV/YsLcUlhhSjw4dF0aePs7ADlFZWP0BpEHH5RYnmU1aPY
        MQCVQ4hJOwJyfPdOmiZotPKBljj5rUZmdFdXl8DNXM5gCa4hg8w4OIlJ7alqEZxZZOie+iQ
        h5k/BgfgzBqg6HeG7CqDxSC8h+LSG4VtzbbtnzmM5DojYIfOCGq7nt3FPRIWnXEcDPJwdAv
        FDe1Jr/TL+JW2VFlfOZxyMTETRusWT4Ga5yRCVugaUkNH4H/6LXYhc3nEnpOpED2X/isRME
        kmeWx73hSExuxoX5+vDSpshs3PrwBZ7syA/6cwrAFRq8o1bxlQj70dZnXx6UNzMKpCtBM4F
        IiiKA5/tbMBdJ4EeeRJRQOrR5CQ4vS9ExhY6aS6RgVI2EvZusRWfMjx3U9rzMiudqh4DWRX
        a/TWFza10vU=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 5679340321751267816
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [RFC PATCH net-next v4 4/7] net: ngbe add netdev features support
Date:   Fri, 28 Apr 2023 13:57:06 +0800
Message-Id: <20230428055709.66071-5-mengyuanlou@net-swift.com>
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
 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
index df6b870aa871..793ebed925ef 100644
--- a/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
+++ b/drivers/net/ethernet/wangxun/ngbe/ngbe_main.c
@@ -551,12 +551,18 @@ static int ngbe_probe(struct pci_dev *pdev,
 	ngbe_set_ethtool_ops(netdev);
 	netdev->netdev_ops = &ngbe_netdev_ops;
 
-	netdev->features |= NETIF_F_HIGHDMA;
-	netdev->features = NETIF_F_SG;
-
+	netdev->features = NETIF_F_SG | NETIF_F_IP_CSUM |
+			   NETIF_F_TSO | NETIF_F_TSO6 |
+			   NETIF_F_RXHASH | NETIF_F_RXCSUM;
+	netdev->features |= NETIF_F_SCTP_CRC | NETIF_F_TSO_MANGLEID;
+	netdev->vlan_features |= netdev->features;
+	netdev->features |= NETIF_F_IPV6_CSUM | NETIF_F_VLAN_FEATURES;
 	/* copy netdev features into list of user selectable features */
-	netdev->hw_features |= netdev->features |
-			       NETIF_F_RXALL;
+	netdev->hw_features |= netdev->features | NETIF_F_RXALL;
+	netdev->hw_features |= NETIF_F_NTUPLE | NETIF_F_HW_TC;
+	netdev->features |= NETIF_F_HIGHDMA;
+	netdev->hw_features |= NETIF_F_GRO;
+	netdev->features |= NETIF_F_GRO;
 
 	netdev->priv_flags |= IFF_UNICAST_FLT;
 	netdev->priv_flags |= IFF_SUPP_NOFCS;
-- 
2.40.0

