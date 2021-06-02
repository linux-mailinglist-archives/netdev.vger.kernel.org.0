Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AC3E398955
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 14:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhFBMXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 08:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbhFBMXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 08:23:12 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B88C06174A
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 05:21:28 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id k7so3485386ejv.12
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 05:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CMWdB7rvvQ/3coL8TyN+mm7by/P5CborTbJdTitPRZc=;
        b=V5oVcoSXMX+uafwRYuu79wWo6JrAqUh1N/XVbgQo4xHMIT40tdHemUoOlFQEaOL7f2
         LPqPcRFkd/CFsVyz6l6aSKl3NWMHU70jHTVAzgrpEMyJp8t7ZgpAHOjy5RSo+1c30/rK
         vEfgKpB/JVa0X/qjCAbU0Hm+e/1AM1Yq4s+dbtFWL6pKmltuDrcbe+l8SFqPsZxogd++
         iu+zoyCNHSca6ogh0S8mIQPpevqIsc5fm31WK0EHgoAsuittY76AXjdtsG8ib9Ikdn7o
         tTHw1xR3C2Fx3Ipl2vpL8RY+V9I+iAUmzJI7j827VH9s1sKQMXToQ4aUvaQRI2Fkt2Hw
         cllg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CMWdB7rvvQ/3coL8TyN+mm7by/P5CborTbJdTitPRZc=;
        b=BhxRHcaScLdHu4FPp9o35y5c9srv49O/KqE8bRE2eYYlrmnvNYXTckwGoYb+KrHmnA
         4oJjjDav1WuxYsy0iKuTKZKcvavQxv9Nz26d1UXHoqXPKx7Vfl7hjs6pzBs5SE8fEU+D
         E+Pqo0l2ePYlzepvJNST2Gbk9/vGouKJKnVlWPD+EZdmv72DSjnwjWsw9OMMDMLEd3f2
         4k0hp2PIVVlgMRyNvEGGC1Vi34CXTeP1JGiQztEt2+B9rsKkGrib4M8BCNQrIYcPqvfp
         fQ+f7C27Kov2t7NAut1fjvG3V3FiInka3/sbJgTvT752Wk6+gVXQBad1xjvvcImugIY5
         lhng==
X-Gm-Message-State: AOAM531gVDqb1GfaQBOsb+vcl9F8GVBMVT0aTk03DfZYZdvm2ZD8kJnL
        EXCvIAqumAJrVSpjLdimRkY=
X-Google-Smtp-Source: ABdhPJyYlxdje1e9vcqnE7pGnaf3z453gKEDzgEq2Z4a1OmQtSRVhncUbj/vDfLMnx1nwMEf4mjOtw==
X-Received: by 2002:a17:906:f849:: with SMTP id ks9mr14212153ejb.402.1622636486897;
        Wed, 02 Jun 2021 05:21:26 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id gw7sm1448745ejb.5.2021.06.02.05.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 05:21:26 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Michael Walle <michael@walle.cc>, Po Liu <po.liu@nxp.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 1/2] net: enetc: manage ENETC_F_QBV in priv->active_offloads only when enabled
Date:   Wed,  2 Jun 2021 15:21:13 +0300
Message-Id: <20210602122114.2082344-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210602122114.2082344-1-olteanv@gmail.com>
References: <20210602122114.2082344-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

All the other flags in priv->active_offloads are managed dynamically,
except ENETC_F_QBV which is set statically based on the probed SI capability.

This change makes priv->active_offloads & ENETC_F_QBV track the presence
of a tc-taprio schedule on the port. Calling enetc_sched_speed_set()
from phylink_mac_link_up() is kept unconditional as long as Qbv is
supported at all on the port, because the tc-taprio offload does not
re-trigger another link mode resolve, so the scheduler needs to be
functional from the get go.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c  | 6 ++----
 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 6 ++++++
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 31274325159a..aced941e57e1 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -769,9 +769,6 @@ static void enetc_pf_netdev_setup(struct enetc_si *si, struct net_device *ndev,
 
 	ndev->priv_flags |= IFF_UNICAST_FLT;
 
-	if (si->hw_features & ENETC_SI_F_QBV)
-		priv->active_offloads |= ENETC_F_QBV;
-
 	if (si->hw_features & ENETC_SI_F_PSFP && !enetc_psfp_enable(priv)) {
 		priv->active_offloads |= ENETC_F_QCI;
 		ndev->features |= NETIF_F_HW_TC;
@@ -1022,7 +1019,8 @@ static void enetc_pl_mac_link_up(struct phylink_config *config,
 	int idx;
 
 	priv = netdev_priv(pf->si->ndev);
-	if (priv->active_offloads & ENETC_F_QBV)
+
+	if (pf->si->hw_features & ENETC_SI_F_QBV)
 		enetc_sched_speed_set(priv, speed);
 
 	if (!phylink_autoneg_inband(mode) &&
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 4577226d3c6a..23ac6e1551ca 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -69,6 +69,9 @@ static int enetc_setup_taprio(struct net_device *ndev,
 		enetc_wr(&priv->si->hw,
 			 ENETC_QBV_PTGCR_OFFSET,
 			 tge & (~ENETC_QBV_TGE));
+
+		priv->active_offloads &= ~ENETC_F_QBV;
+
 		return 0;
 	}
 
@@ -135,6 +138,9 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	dma_unmap_single(&priv->si->pdev->dev, dma, data_size, DMA_TO_DEVICE);
 	kfree(gcl_data);
 
+	if (!err)
+		priv->active_offloads |= ENETC_F_QBV;
+
 	return err;
 }
 
-- 
2.25.1

