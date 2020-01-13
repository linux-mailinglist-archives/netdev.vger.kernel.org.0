Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 159A41391B3
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 14:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgAMNDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 08:03:31 -0500
Received: from smtprelay-out1.synopsys.com ([149.117.87.133]:56794 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726985AbgAMNCx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 08:02:53 -0500
Received: from mailhost.synopsys.com (mdc-mailhost1.synopsys.com [10.225.0.209])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BD301C05CF;
        Mon, 13 Jan 2020 13:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1578920572; bh=kN5PiGdIWi7yxdqxRCTpBO3hPGrie9JabgsZPaL70oM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=lcLeFk4u1IVEmmuGgNiZJ61Kyqnw5eD9MSDOIOOzc2DKWmcI1WIBFaYFoKIGxM3V9
         0xCDWbDTZdQk5ZWTMHXEWA9b+bL339FSY18bA9HIoSlt01uXU4h7IweIbtoON3YTsn
         QMdoIz0kgcCLtvOlg+4gSLiCc/Rwx6nGffl6jnyD9XMS+fYoWIHI0WtrhD9GqbdrCY
         qgXhMXx5h7oxj1hvkt/NdG2Ya2YRXkJ4oeVrgt0uZGqnkGAPxczaBq2+zlNyJdgYB8
         J8xJWZJiDpgfJ5oCoI1Sqo4SdO80rG1YB3B2y1BWAToP1+tkFUK2cfz+yWnD+BWbtU
         E01fwDiYaYDSA==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 79240A0077;
        Mon, 13 Jan 2020 13:02:50 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 7/8] net: stmmac: selftests: Switch to dev_direct_xmit()
Date:   Mon, 13 Jan 2020 14:02:42 +0100
Message-Id: <f1318b009f65d5cc3e4a0b76b6e959951c3e8bc5.1578920367.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1578920366.git.Jose.Abreu@synopsys.com>
References: <cover.1578920366.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1578920366.git.Jose.Abreu@synopsys.com>
References: <cover.1578920366.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the upcoming commit for TBS selftest we will need to send a packet on
a specific Queue. As stmmac fallsback to netdev_pick_tx() on the select
Queue callback, we need to switch all selftests logic to
dev_direct_xmit() so that we can send the given SKB on a specific Queue.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 25 ++++++----------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index 13227909287c..d50ae59fe3d8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -339,8 +339,7 @@ static int __stmmac_test_loopback(struct stmmac_priv *priv,
 		goto cleanup;
 	}
 
-	skb_set_queue_mapping(skb, attr->queue_mapping);
-	ret = dev_queue_xmit(skb);
+	ret = dev_direct_xmit(skb, attr->queue_mapping);
 	if (ret)
 		goto cleanup;
 
@@ -926,8 +925,7 @@ static int __stmmac_test_vlanfilt(struct stmmac_priv *priv)
 			goto vlan_del;
 		}
 
-		skb_set_queue_mapping(skb, 0);
-		ret = dev_queue_xmit(skb);
+		ret = dev_direct_xmit(skb, 0);
 		if (ret)
 			goto vlan_del;
 
@@ -1018,8 +1016,7 @@ static int __stmmac_test_dvlanfilt(struct stmmac_priv *priv)
 			goto vlan_del;
 		}
 
-		skb_set_queue_mapping(skb, 0);
-		ret = dev_queue_xmit(skb);
+		ret = dev_direct_xmit(skb, 0);
 		if (ret)
 			goto vlan_del;
 
@@ -1286,8 +1283,7 @@ static int stmmac_test_vlanoff_common(struct stmmac_priv *priv, bool svlan)
 	__vlan_hwaccel_put_tag(skb, htons(proto), tpriv->vlan_id);
 	skb->protocol = htons(proto);
 
-	skb_set_queue_mapping(skb, 0);
-	ret = dev_queue_xmit(skb);
+	ret = dev_direct_xmit(skb, 0);
 	if (ret)
 		goto vlan_del;
 
@@ -1639,8 +1635,7 @@ static int stmmac_test_arpoffload(struct stmmac_priv *priv)
 	if (ret)
 		goto cleanup;
 
-	skb_set_queue_mapping(skb, 0);
-	ret = dev_queue_xmit(skb);
+	ret = dev_direct_xmit(skb, 0);
 	if (ret)
 		goto cleanup_promisc;
 
@@ -1869,7 +1864,6 @@ void stmmac_selftest_run(struct net_device *dev,
 {
 	struct stmmac_priv *priv = netdev_priv(dev);
 	int count = stmmac_selftest_get_count(priv);
-	int carrier = netif_carrier_ok(dev);
 	int i, ret;
 
 	memset(buf, 0, sizeof(*buf) * count);
@@ -1879,15 +1873,12 @@ void stmmac_selftest_run(struct net_device *dev,
 		netdev_err(priv->dev, "Only offline tests are supported\n");
 		etest->flags |= ETH_TEST_FL_FAILED;
 		return;
-	} else if (!carrier) {
+	} else if (!netif_carrier_ok(dev)) {
 		netdev_err(priv->dev, "You need valid Link to execute tests\n");
 		etest->flags |= ETH_TEST_FL_FAILED;
 		return;
 	}
 
-	/* We don't want extra traffic */
-	netif_carrier_off(dev);
-
 	/* Wait for queues drain */
 	msleep(200);
 
@@ -1942,10 +1933,6 @@ void stmmac_selftest_run(struct net_device *dev,
 			break;
 		}
 	}
-
-	/* Restart everything */
-	if (carrier)
-		netif_carrier_on(dev);
 }
 
 void stmmac_selftest_get_strings(struct stmmac_priv *priv, u8 *data)
-- 
2.7.4

