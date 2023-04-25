Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCE06EDA0F
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbjDYBvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233224AbjDYBvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:51:13 -0400
Received: from smtpbg156.qq.com (smtpbg156.qq.com [15.184.82.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7410B9EF7
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 18:51:03 -0700 (PDT)
X-QQ-mid: bizesmtp86t1682387455tbgol9g6
Received: from localhost.localdomain ( [183.129.236.74])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 25 Apr 2023 09:50:54 +0800 (CST)
X-QQ-SSF: 01400000000000N0S000000A0000000
X-QQ-FEAT: dKvkn8qoLrEthdgFABjfoIKfYirX0Uydc8t/ueFe9PkgwbTYi1eubRCobs6qA
        iK2Zm8UPmw8vj7fvNBxKkCPZB8mlXxGdbUnEiSsAsXc9OfvS89+yX1eyxNFVtfiOmBpzxkB
        xW9wMpLxL3yeZ8QktgWkH6roRjJ1PYvfEcjuKuk5iU6EsE8zh/7FRMLcb7BJw1PhXmE9Rhr
        3HbQ79Gbf9NISQsJAZEWSsuyMAL0FLGmN7sRUjRlZ4dh7WvA7U+CITehmBqFgnavfn59/mO
        JDiGazoQmEAShwxOX8XS4kl2OTSKtC5YdznXfiMdtj1my3iZD147Aqi05MhRZHKh4vpCYY2
        QHWzb3WnLqxQgm6VXtf3Dn8IVggWQlN5fbGWGuyDZAhedm8Pej+DAzHRe2vH2YQVim+Kanw
        xqsG1Bjbjqo=
X-QQ-GoodBg: 2
X-BIZMAIL-ID: 3658545713674799089
From:   Mengyuan Lou <mengyuanlou@net-swift.com>
To:     netdev@vger.kernel.org
Cc:     jiawenwu@trustnetic.com, linyunsheng@huawei.com,
        Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: [PATCH net-next 6/7] net: txgbe add netdev features support
Date:   Tue, 25 Apr 2023 09:50:10 +0800
Message-Id: <20230425015011.19980-7-mengyuanlou@net-swift.com>
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

