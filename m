Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D571D3A8E7C
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 03:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhFPBls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 21:41:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230371AbhFPBlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 21:41:47 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A6EC061574;
        Tue, 15 Jun 2021 18:39:41 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id m137so732351oig.6;
        Tue, 15 Jun 2021 18:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sLyjmM1Y7G245fiPe0zuYHMTwP0WkXpV/SXNgEyacXo=;
        b=Szjd1hqC0u93RuXCFpF1vCL9jM+ZyWZmKMZVbGykRBoipNboOFctRuIVDmKtNdnu92
         lsLguYkmuupKH9BEyaOCzAS7NKx2REXaXRWvcIREqi986jgNl2Rv4wSWVQL3iozkc7ce
         s6Say1gIw51YuAD7ci0KTeE2xTxM/muwVutwPqz+nWUAWiPQg10WgiMIVR6cZZCxA6TB
         tw4xRDOXNzsubBaVQHKUI+U4ZXXCqbsYTy+Cs9ytqz5rsvZ6ewCnLkeMhxo4ivU4saXO
         RHS3iJOqeHRTRp8nVl1YUTTBZTjXRI9GsR2vgBLbwnc9Za59Bqsu+TTGJ8BELQ5K1LCD
         BgTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sLyjmM1Y7G245fiPe0zuYHMTwP0WkXpV/SXNgEyacXo=;
        b=M/VCqAHPKH2qSeVVo2f3act5cwEvedczMeRx4dLJj6eI91vMutK5cL3Wo/0a1l5oEo
         xYvQ/fflFMnDQdTCZeFcI7Cus1u55rHrHrq4T+etpvWoPF1AqNqaOV7vBtA+kYYEADGK
         fC6rJoCmLcq4EmZbpSbN53+2HqZ20ETuLezc5pgUbdhkn1PBgqJCgJwdpk8/HBzfpW6r
         TA27DnahiHcJKQCl6O69FL1+V2b1lLUalULDJ4hliNZh8l2Pp1V2YvVDsJuac91o07kS
         lxW8y5sD4jgrDCHH9GmuRwU1pmNZGVm+o1H3bYvfhBwUS5W0AK3PH5Mxu1QawKjzlO5G
         2Jjg==
X-Gm-Message-State: AOAM5309D5Viqbkh4YOZQr/n5mnFiKxBolmm9QWOb1Mu+m/kHTZ01OyY
        aCkVIQgez8m1FyH/DfMSDNsoKu5gKSO+/YQ=
X-Google-Smtp-Source: ABdhPJzeOKX5bBK/zj9zBr6EK+2CtNt9oJqvaF5R0KRK2+RhCoKdpVJhbzGvJQLs486TWv9FY+BEiA==
X-Received: by 2002:aca:aad4:: with SMTP id t203mr1315813oie.149.1623807579843;
        Tue, 15 Jun 2021 18:39:39 -0700 (PDT)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id z23sm158063ooz.15.2021.06.15.18.39.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Jun 2021 18:39:39 -0700 (PDT)
From:   George McCollister <george.mccollister@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH net-next v2] net: dsa: xrs700x: forward HSR supervision frames
Date:   Tue, 15 Jun 2021 20:39:03 -0500
Message-Id: <20210616013903.41564-1-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Forward supervision frames between redunant HSR ports. This was broken
in the last commit.

Fixes: 1a42624aecba ("net: dsa: xrs700x: allow HSR/PRP supervision dupes for node_table")
Signed-off-by: George McCollister <george.mccollister@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes since v1:
- Fixed wrapping of Fixes tag.

 drivers/net/dsa/xrs700x/xrs700x.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index a79066174a77..130abb0f1438 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -337,7 +337,8 @@ static int xrs700x_port_add_bpdu_ipf(struct dsa_switch *ds, int port)
  * This is required to correctly populate the HSR/PRP node_table.
  * Leave the policy disabled, it will be enabled as needed.
  */
-static int xrs700x_port_add_hsrsup_ipf(struct dsa_switch *ds, int port)
+static int xrs700x_port_add_hsrsup_ipf(struct dsa_switch *ds, int port,
+				       int fwdport)
 {
 	struct xrs700x *priv = ds->priv;
 	unsigned int val = 0;
@@ -368,6 +369,9 @@ static int xrs700x_port_add_hsrsup_ipf(struct dsa_switch *ds, int port)
 	if (ret)
 		return ret;
 
+	if (fwdport >= 0)
+		val |= BIT(fwdport);
+
 	/* Allow must be set prevent duplicate discard */
 	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_FWD_ALLOW(port, 1), val);
 	if (ret)
@@ -405,10 +409,6 @@ static int xrs700x_port_setup(struct dsa_switch *ds, int port)
 		ret = xrs700x_port_add_bpdu_ipf(ds, port);
 		if (ret)
 			return ret;
-
-		ret = xrs700x_port_add_hsrsup_ipf(ds, port);
-		if (ret)
-			return ret;
 	}
 
 	return 0;
@@ -562,6 +562,7 @@ static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
 	struct net_device *slave;
 	int ret, i, hsr_pair[2];
 	enum hsr_version ver;
+	bool fwd = false;
 
 	ret = hsr_get_version(hsr, &ver);
 	if (ret)
@@ -607,6 +608,7 @@ static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
 	if (ver == HSR_V1) {
 		val &= ~BIT(partner->index);
 		val &= ~BIT(port);
+		fwd = true;
 	}
 	val &= ~BIT(dsa_upstream_port(ds, port));
 	regmap_write(priv->regmap, XRS_PORT_FWD_MASK(partner->index), val);
@@ -616,10 +618,19 @@ static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
 			    XRS_PORT_FORWARDING);
 	regmap_fields_write(priv->ps_forward, port, XRS_PORT_FORWARDING);
 
-	/* Enable inbound policy added by xrs700x_port_add_hsrsup_ipf()
-	 * which allows HSR/PRP supervision forwarding to the CPU port without
-	 * discarding duplicates.
+	/* Enable inbound policy which allows HSR/PRP supervision forwarding
+	 * to the CPU port without discarding duplicates. Continue to
+	 * forward to redundant ports when in HSR mode while discarding
+	 * duplicates.
 	 */
+	ret = xrs700x_port_add_hsrsup_ipf(ds, partner->index, fwd ? port : -1);
+	if (ret)
+		return ret;
+
+	ret = xrs700x_port_add_hsrsup_ipf(ds, port, fwd ? partner->index : -1);
+	if (ret)
+		return ret;
+
 	regmap_update_bits(priv->regmap,
 			   XRS_ETH_ADDR_CFG(partner->index, 1), 1, 1);
 	regmap_update_bits(priv->regmap, XRS_ETH_ADDR_CFG(port, 1), 1, 1);
-- 
2.11.0

