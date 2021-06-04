Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E6339BD21
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 18:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhFDQcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 12:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhFDQb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 12:31:58 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DDFC061766;
        Fri,  4 Jun 2021 09:29:59 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id t10-20020a05683022eab0290304ed8bc759so9588155otc.12;
        Fri, 04 Jun 2021 09:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=n5M/DfERH8t5HzVCATPHHQq5YkPCR7JWwjW1C7938Ek=;
        b=r8e7AHkhVs3q6ptTJraSRSvdlEymC1H8STjBRCNlJtQbn1Ff2OzVFbXNqTElXLYQla
         f4nSAvkwOjmchzUlBwGB9rcFtIxXaG4JCqjPjF3FvG8THsRwqiYOwYuCFxsauaQUn4oe
         u7RDYW5anR0QICQFMvt+E/WgHaaNlHeUniMSpCbtfHJ+HRcXY5uUTCOGVI1ROxG0Y7/9
         SzxrejSBTmOjQM59847KqgeTydrRKiOlKPArwNB3WV+mqs7omaswayIM9HY/cmAYGPlX
         hdddw4KYDOksNcJ6d/ux9cHpLB84dlJRvvLmLH7a6Em79SCq6Xn/Ceayng3Z6Ni5edD8
         F9Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=n5M/DfERH8t5HzVCATPHHQq5YkPCR7JWwjW1C7938Ek=;
        b=UnHxrxqivGMEHXPNH7JshqfHLXhfDN2862IxHi5LK3XAuTHP7GYq+WfSt2TmQtePmD
         bNlsKsCiUdBppt2xNqXUOKKlirKCdy0yVmiXzbYx2+aq4GCUNjx5bvmKzEitL7f1mNmB
         f6qgJJA7Jq6Px5/+SVExW+tH5lJXPAPPF3Loij7dtHMGYIb9aqqYQw/2Y/M/aBb0Lomo
         +PAUC8+Yyboow0fjcREhl/mArnjpXqWOR6uA5ttpbp0UotYaPWJv/40+IOT41tIh4bR+
         tPOPSDsGQRj664NWprcJiMCI14lszymDu/Em4V5xTkILaEn9zfGLEqAcpU58CGa27acM
         jaAw==
X-Gm-Message-State: AOAM530NPCptAYSNDCOv9rPNwxBo25kmpmFi1YawE/rf5KL3xwPyNYiu
        RiyEgY7mZE4jQkMsPvl6mdTCP7RVXh1q
X-Google-Smtp-Source: ABdhPJxDTNEVN56MzFznX3IiUYsBWct3H6zWwxBdShh9QHEeKypiQ+y/mJB+qADhmba3jaJ+l7qryg==
X-Received: by 2002:a9d:2287:: with SMTP id y7mr4238435ota.22.1622824198164;
        Fri, 04 Jun 2021 09:29:58 -0700 (PDT)
Received: from threadripper.novatech-llc.local ([216.21.169.52])
        by smtp.gmail.com with ESMTPSA id x10sm568913otp.39.2021.06.04.09.29.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Jun 2021 09:29:57 -0700 (PDT)
From:   George McCollister <george.mccollister@gmail.com>
To:     netdev@vger.kernel.org
Cc:     George McCollister <george.mccollister@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: dsa: xrs700x: allow HSR/PRP supervision dupes for node_table
Date:   Fri,  4 Jun 2021 11:29:22 -0500
Message-Id: <20210604162922.76954-1-george.mccollister@gmail.com>
X-Mailer: git-send-email 2.11.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an inbound policy filter which matches the HSR/PRP supervision
MAC range and forwards to the CPU port without discarding duplicates.
This is required to correctly populate time_in[A] and time_in[B] in the
HSR/PRP node_table. Leave the policy disabled by default and
enable/disable it when joining/leaving hsr.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
---
 drivers/net/dsa/xrs700x/xrs700x.c | 67 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/drivers/net/dsa/xrs700x/xrs700x.c b/drivers/net/dsa/xrs700x/xrs700x.c
index fde6e99274b6..a79066174a77 100644
--- a/drivers/net/dsa/xrs700x/xrs700x.c
+++ b/drivers/net/dsa/xrs700x/xrs700x.c
@@ -79,6 +79,9 @@ static const struct xrs700x_mib xrs700x_mibs[] = {
 	XRS700X_MIB(XRS_EARLY_DROP_L, "early_drop", tx_dropped),
 };
 
+static const u8 eth_hsrsup_addr[ETH_ALEN] = {
+	0x01, 0x15, 0x4e, 0x00, 0x01, 0x00};
+
 static void xrs700x_get_strings(struct dsa_switch *ds, int port,
 				u32 stringset, u8 *data)
 {
@@ -329,6 +332,50 @@ static int xrs700x_port_add_bpdu_ipf(struct dsa_switch *ds, int port)
 	return 0;
 }
 
+/* Add an inbound policy filter which matches the HSR/PRP supervision MAC
+ * range and forwards to the CPU port without discarding duplicates.
+ * This is required to correctly populate the HSR/PRP node_table.
+ * Leave the policy disabled, it will be enabled as needed.
+ */
+static int xrs700x_port_add_hsrsup_ipf(struct dsa_switch *ds, int port)
+{
+	struct xrs700x *priv = ds->priv;
+	unsigned int val = 0;
+	int i = 0;
+	int ret;
+
+	/* Compare 40 bits of the destination MAC address. */
+	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_CFG(port, 1), 40 << 2);
+	if (ret)
+		return ret;
+
+	/* match HSR/PRP supervision destination 01:15:4e:00:01:XX */
+	for (i = 0; i < sizeof(eth_hsrsup_addr); i += 2) {
+		ret = regmap_write(priv->regmap, XRS_ETH_ADDR_0(port, 1) + i,
+				   eth_hsrsup_addr[i] |
+				   (eth_hsrsup_addr[i + 1] << 8));
+		if (ret)
+			return ret;
+	}
+
+	/* Mirror HSR/PRP supervision to CPU port */
+	for (i = 0; i < ds->num_ports; i++) {
+		if (dsa_is_cpu_port(ds, i))
+			val |= BIT(i);
+	}
+
+	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_FWD_MIRROR(port, 1), val);
+	if (ret)
+		return ret;
+
+	/* Allow must be set prevent duplicate discard */
+	ret = regmap_write(priv->regmap, XRS_ETH_ADDR_FWD_ALLOW(port, 1), val);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int xrs700x_port_setup(struct dsa_switch *ds, int port)
 {
 	bool cpu_port = dsa_is_cpu_port(ds, port);
@@ -358,6 +405,10 @@ static int xrs700x_port_setup(struct dsa_switch *ds, int port)
 		ret = xrs700x_port_add_bpdu_ipf(ds, port);
 		if (ret)
 			return ret;
+
+		ret = xrs700x_port_add_hsrsup_ipf(ds, port);
+		if (ret)
+			return ret;
 	}
 
 	return 0;
@@ -565,6 +616,14 @@ static int xrs700x_hsr_join(struct dsa_switch *ds, int port,
 			    XRS_PORT_FORWARDING);
 	regmap_fields_write(priv->ps_forward, port, XRS_PORT_FORWARDING);
 
+	/* Enable inbound policy added by xrs700x_port_add_hsrsup_ipf()
+	 * which allows HSR/PRP supervision forwarding to the CPU port without
+	 * discarding duplicates.
+	 */
+	regmap_update_bits(priv->regmap,
+			   XRS_ETH_ADDR_CFG(partner->index, 1), 1, 1);
+	regmap_update_bits(priv->regmap, XRS_ETH_ADDR_CFG(port, 1), 1, 1);
+
 	hsr_pair[0] = port;
 	hsr_pair[1] = partner->index;
 	for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
@@ -611,6 +670,14 @@ static int xrs700x_hsr_leave(struct dsa_switch *ds, int port,
 			    XRS_PORT_FORWARDING);
 	regmap_fields_write(priv->ps_forward, port, XRS_PORT_FORWARDING);
 
+	/* Disable inbound policy added by xrs700x_port_add_hsrsup_ipf()
+	 * which allows HSR/PRP supervision forwarding to the CPU port without
+	 * discarding duplicates.
+	 */
+	regmap_update_bits(priv->regmap,
+			   XRS_ETH_ADDR_CFG(partner->index, 1), 1, 0);
+	regmap_update_bits(priv->regmap, XRS_ETH_ADDR_CFG(port, 1), 1, 0);
+
 	hsr_pair[0] = port;
 	hsr_pair[1] = partner->index;
 	for (i = 0; i < ARRAY_SIZE(hsr_pair); i++) {
-- 
2.11.0

