Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 832136EDA0D
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbjDYBvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232603AbjDYBvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:51:04 -0400
Received: from smtpbg151.qq.com (smtpbg151.qq.com [18.169.211.239])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C482BAF18
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 18:50:54 -0700 (PDT)
X-QQ-mid: bizesmtp86t1682387447tkfd529p
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 25 Apr 2023 09:50:39 +0800 (CST)
X-QQ-SSF: 01400000000000N0S000000A0000000
X-QQ-FEAT: 90EFqYDyPxCYy/CeysmqXhoFLLxy+kZrQ+x2Yo8+yxw8kZfnSg72eEuGgCTk5
        PKfXONWGzDpfhNtGDXbaCQvKzMUrKxog/6ow5T9Vv+6IMb6dHe/E+LmAHSO7MizkW+iGtRF
        mQQXVr1m1SW5KQhWeWtmKNYLtUhVC+caIbxpl3i4T9IBLe4gXq8TFNzErgPMqorBkS9lw3+
        YQgLZvkEjrYKKsZqByMEItZ70kCyYqHC/mkp9IJgI1WQiFJYuthqXhlWae2wXBHJ/VXmTZR
        1giEz7g3NfF3yAawflvK6rGlGtSOHud+m8ZddE8oqPnDLD9bQFA4UnDsqg3pS3+WI6NrDda
        Y1j7Y7jIsC2U27iSqfIrjTqGxAyld7nd0N/ZmemImAjO8oKyMYPc/Y619hfNIriut06tPcT
        y3vLzFybD00=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 13950346856107034751
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, linyunsheng@huawei.com,
        Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next 4/7] net: ngbe add netdev features support
Date:   Tue, 25 Apr 2023 09:50:08 +0800
Message-Id: <20230425015011.19980-5-mengyuanlou@net-swift.com>
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

