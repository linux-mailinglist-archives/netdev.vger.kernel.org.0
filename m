Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12853822C6
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 18:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbfHEQpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 12:45:33 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:40070 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729287AbfHEQpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 12:45:31 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id C6296C01D4;
        Mon,  5 Aug 2019 16:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1565023530; bh=0qzfDib/TkS1Pnuz9bteOYFmisi1Lcw2FF4Y8DcAjZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=eGqmVbSVDPu8ckUX66NOA/imFFRXZXoJigFiVbXz/MrszQONEBxo0MeUC/gRixpnO
         /I904RsggX/COfA8K0jazy2QwyGYdFsAVNbLU5zpiiDbrVDxx9jRxWTpvWDDOe9s/0
         X3dt9eI/kbpzu92yODMdped6BXQAejKgy2jGNPEAE1Q/poFrx84I9EVL0rrstvd9p0
         pPNd6D1ozP65mDouL+Wo+9QtVYT0GpGnPhzMjMYJ+IkyYphpi1lSK7ylU9GJEf/Rxt
         HlKvazufyE/jmMBv4XzCv+aU6Stq8lLGckeDd6P3lYycBCUI/pQIron4BKxcrWya8Z
         rK7l07GN5EgPQ==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id 90193A00AC;
        Mon,  5 Aug 2019 16:45:28 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 26/26] net: stmmac: selftests: Return proper error code to userspace
Date:   Mon,  5 Aug 2019 18:44:53 +0200
Message-Id: <5b217c7b110eb32183fd81c81b516d42228ac406.1565022597.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1565022597.git.joabreu@synopsys.com>
References: <cover.1565022597.git.joabreu@synopsys.com>
In-Reply-To: <cover.1565022597.git.joabreu@synopsys.com>
References: <cover.1565022597.git.joabreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can do better than just return 1 to userspace. Lets return a proper
Linux error code.

Signed-off-by: Jose Abreu <joabreu@synopsys.com>
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
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index a0da35b2b4c2..d40f6a109633 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -316,7 +316,7 @@ static int __stmmac_test_loopback(struct stmmac_priv *priv,
 		attr->timeout = STMMAC_LB_TIMEOUT;
 
 	wait_for_completion_timeout(&tpriv->comp, attr->timeout);
-	ret = !tpriv->ok;
+	ret = tpriv->ok ? 0 : -ETIMEDOUT;
 
 cleanup:
 	dev_remove_pack(&tpriv->pt);
@@ -477,7 +477,7 @@ static int stmmac_test_hfilt(struct stmmac_priv *priv)
 
 	/* Shall NOT receive packet */
 	ret = __stmmac_test_loopback(priv, &attr);
-	ret = !ret;
+	ret = ret ? 0 : -EINVAL;
 
 cleanup:
 	dev_mc_del(priv->dev, gd_addr);
@@ -509,7 +509,7 @@ static int stmmac_test_pfilt(struct stmmac_priv *priv)
 
 	/* Shall NOT receive packet */
 	ret = __stmmac_test_loopback(priv, &attr);
-	ret = !ret;
+	ret = ret ? 0 : -EINVAL;
 
 cleanup:
 	dev_uc_del(priv->dev, gd_addr);
@@ -559,7 +559,7 @@ static int stmmac_test_mcfilt(struct stmmac_priv *priv)
 
 	/* Shall NOT receive packet */
 	ret = __stmmac_test_loopback(priv, &attr);
-	ret = !ret;
+	ret = ret ? 0 : -EINVAL;
 
 cleanup:
 	dev_uc_del(priv->dev, uc_addr);
@@ -597,7 +597,7 @@ static int stmmac_test_ucfilt(struct stmmac_priv *priv)
 
 	/* Shall NOT receive packet */
 	ret = __stmmac_test_loopback(priv, &attr);
-	ret = !ret;
+	ret = ret ? 0 : -EINVAL;
 
 cleanup:
 	dev_mc_del(priv->dev, mc_addr);
@@ -696,7 +696,7 @@ static int stmmac_test_flowctrl(struct stmmac_priv *priv)
 	}
 
 	wait_for_completion_timeout(&tpriv->comp, STMMAC_LB_TIMEOUT);
-	ret = !tpriv->ok;
+	ret = tpriv->ok ? 0 : -ETIMEDOUT;
 
 cleanup:
 	dev_mc_del(priv->dev, paddr);
@@ -830,11 +830,11 @@ static int stmmac_test_vlanfilt(struct stmmac_priv *priv)
 			goto vlan_del;
 
 		wait_for_completion_timeout(&tpriv->comp, STMMAC_LB_TIMEOUT);
-		ret = !tpriv->ok;
+		ret = tpriv->ok ? 0 : -ETIMEDOUT;
 		if (ret && !i) {
 			goto vlan_del;
 		} else if (!ret && i) {
-			ret = -1;
+			ret = -EINVAL;
 			goto vlan_del;
 		} else {
 			ret = 0;
@@ -906,11 +906,11 @@ static int stmmac_test_dvlanfilt(struct stmmac_priv *priv)
 			goto vlan_del;
 
 		wait_for_completion_timeout(&tpriv->comp, STMMAC_LB_TIMEOUT);
-		ret = !tpriv->ok;
+		ret = tpriv->ok ? 0 : -ETIMEDOUT;
 		if (ret && !i) {
 			goto vlan_del;
 		} else if (!ret && i) {
-			ret = -1;
+			ret = -EINVAL;
 			goto vlan_del;
 		} else {
 			ret = 0;
@@ -995,7 +995,7 @@ static int stmmac_test_rxp(struct stmmac_priv *priv)
 	attr.src = addr;
 
 	ret = __stmmac_test_loopback(priv, &attr);
-	ret = !ret; /* Shall NOT receive packet */
+	ret = ret ? 0 : -EINVAL; /* Shall NOT receive packet */
 
 	cls_u32.command = TC_CLSU32_DELETE_KNODE;
 	stmmac_tc_setup_cls_u32(priv, priv, &cls_u32);
-- 
2.7.4

