Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB7422931E
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 10:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728574AbgGVIJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 04:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728053AbgGVIJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 04:09:12 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811D9C0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 01:09:12 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id ga4so1208254ejb.11
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 01:09:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yp8iZrzC/xGSGel2Rb0moBL4bZNrAm2To7IxF8pdZO8=;
        b=Zh1Du+p02OROcumOM9WrpIscseymlml9F2PO+ezqVn8bxISQ+QsCFOXyL/JpV1TPSK
         ZiWhEUwZqJD4U0uYCCJtGEIeY7FtuJk+BQijaKqdlg0J9wnbHw0d+aI/6oLMa2idKs8v
         ewXvm5nweY27kH0rouMhc5pMlQn4jrFjv21Pyk2sLH2eLen0ubQDoQouOktSMw/3rsRa
         qMe/VJHD6U1GpKHfSXw54l69avvHSrcNBVrAw9mAfQKtPzF29ovdr15NPbihCQ809XMM
         tFWjMWs+dRG/vMLJzpGkdcIEPQHliETopawqbXFca9GYH2/HoZ5UFEbUBCsQuy9h9yOh
         SDTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Yp8iZrzC/xGSGel2Rb0moBL4bZNrAm2To7IxF8pdZO8=;
        b=LEvxSQTQ51yv1oUn6WSzSncZgB0mS+wBI1IaGxpqyvEH5+BRRxcFKROx9/hySL1xT1
         v7gzj6lO5hNMlg0Uz+zXBNZW7EUgeeoTztFvEr4T/Z8kc4VEvjQd0rPcieaEozYj3h3j
         8lvZoTnYTHzvAdo0S25yWNZZRsM18N8/xDoIZQ5DaaflrGYTQv4++cZYt+k/iAZaISX+
         woG+ARTJh1SCi+T4va1qsSogPXBpR9U1ymOcnerGe+gEp3tnIsNBE7iOo5/w1pm9lrDS
         UICGkiqwrff4666hfI8+PEfRGkWBz9Ro2aQzmIe95zlKWiy61wcD4xii5Wi0HSe0MXVz
         razA==
X-Gm-Message-State: AOAM5337fmk7MtT7HjwcyeGNlE0TXNzr7CPHD01hPYcLJr4u7nVC13rC
        uegsRDJ9LOsYPYcEex1ACPE=
X-Google-Smtp-Source: ABdhPJztljHAcHHytFqc0MzlmPy9plkFT6b6UZoL6QgCXQlpIOI0RSiAhLedt20V3oGo+Dj9HkMmZw==
X-Received: by 2002:a17:906:2988:: with SMTP id x8mr4877049eje.141.1595405351155;
        Wed, 22 Jul 2020 01:09:11 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id p4sm18510545eji.123.2020.07.22.01.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2020 01:09:10 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, Bryan.Whitehead@microchip.com,
        Steen.Hegelund@microchip.com, Horatiu.Vultur@microchip.com,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next] net: mscc: ocelot: fix non-initialized CPU port on VSC7514
Date:   Wed, 22 Jul 2020 11:08:57 +0300
Message-Id: <20200722080857.2094067-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The VSC7514 is marketed as a 10-port switch, however it has 11 physical
ports (0->10) in the block diagram:
https://www.microsemi.com/product-directory/ethernet-switches/3992-vsc7514
(also in the device tree at arch/mips/boot/dts/mscc/ocelot.dtsi)

Additionally, by architecture it has one more entry in the analyzer
block, situated right after the physical ports, for the CPU port module.
This is not a physical port, it only represents a channel for frame
injection and extraction. That entry for the CPU port is at index 11 in
the analyzer.

When the register groups for QSYS_SWITCH_PORT_MODE, SYS_PORT_MODE and
SYS_PAUSE_CFG are declared to be replicated 11 times, the 11th entry in
the array of regfields is not initialized, so the CPU port module is not
initialized either.

The documentation of QSYS_SWITCH_PORT_MODE for VSC7514 also says that
this register group is replicated 12 times, so this patch is simply
reflecting that and not introducing any further inconsistency.

Fixes: 886e1387c73d ("net: mscc: ocelot: convert QSYS_SWITCH_PORT_MODE and SYS_PORT_MODE to regfields")
Fixes: 541132f0961a ("net: mscc: ocelot: convert SYS_PAUSE_CFG register access to regfield")
Reported-by: Bryan Whitehead <bryan.whitehead@microchip.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 28 +++++++++++-----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 0ead1ef11c6c..65408bc994c4 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -358,20 +358,20 @@ static const struct reg_field ocelot_regfields[REGFIELD_MAX] = {
 	[SYS_RESET_CFG_CORE_ENA] = REG_FIELD(SYS_RESET_CFG, 2, 2),
 	[SYS_RESET_CFG_MEM_ENA] = REG_FIELD(SYS_RESET_CFG, 1, 1),
 	[SYS_RESET_CFG_MEM_INIT] = REG_FIELD(SYS_RESET_CFG, 0, 0),
-	/* Replicated per number of ports (11), register size 4 per port */
-	[QSYS_SWITCH_PORT_MODE_PORT_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 14, 14, 11, 4),
-	[QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 11, 13, 11, 4),
-	[QSYS_SWITCH_PORT_MODE_YEL_RSRVD] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 10, 10, 11, 4),
-	[QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 9, 9, 11, 4),
-	[QSYS_SWITCH_PORT_MODE_TX_PFC_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 1, 8, 11, 4),
-	[QSYS_SWITCH_PORT_MODE_TX_PFC_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 0, 0, 11, 4),
-	[SYS_PORT_MODE_DATA_WO_TS] = REG_FIELD_ID(SYS_PORT_MODE, 5, 6, 11, 4),
-	[SYS_PORT_MODE_INCL_INJ_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 3, 4, 11, 4),
-	[SYS_PORT_MODE_INCL_XTR_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 1, 2, 11, 4),
-	[SYS_PORT_MODE_INCL_HDR_ERR] = REG_FIELD_ID(SYS_PORT_MODE, 0, 0, 11, 4),
-	[SYS_PAUSE_CFG_PAUSE_START] = REG_FIELD_ID(SYS_PAUSE_CFG, 10, 18, 11, 4),
-	[SYS_PAUSE_CFG_PAUSE_STOP] = REG_FIELD_ID(SYS_PAUSE_CFG, 1, 9, 11, 4),
-	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 11, 4),
+	/* Replicated per number of ports (12), register size 4 per port */
+	[QSYS_SWITCH_PORT_MODE_PORT_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 14, 14, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 11, 13, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_YEL_RSRVD] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 10, 10, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 9, 9, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_TX_PFC_ENA] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 1, 8, 12, 4),
+	[QSYS_SWITCH_PORT_MODE_TX_PFC_MODE] = REG_FIELD_ID(QSYS_SWITCH_PORT_MODE, 0, 0, 12, 4),
+	[SYS_PORT_MODE_DATA_WO_TS] = REG_FIELD_ID(SYS_PORT_MODE, 5, 6, 12, 4),
+	[SYS_PORT_MODE_INCL_INJ_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 3, 4, 12, 4),
+	[SYS_PORT_MODE_INCL_XTR_HDR] = REG_FIELD_ID(SYS_PORT_MODE, 1, 2, 12, 4),
+	[SYS_PORT_MODE_INCL_HDR_ERR] = REG_FIELD_ID(SYS_PORT_MODE, 0, 0, 12, 4),
+	[SYS_PAUSE_CFG_PAUSE_START] = REG_FIELD_ID(SYS_PAUSE_CFG, 10, 18, 12, 4),
+	[SYS_PAUSE_CFG_PAUSE_STOP] = REG_FIELD_ID(SYS_PAUSE_CFG, 1, 9, 12, 4),
+	[SYS_PAUSE_CFG_PAUSE_ENA] = REG_FIELD_ID(SYS_PAUSE_CFG, 0, 1, 12, 4),
 };
 
 static const struct ocelot_stat_layout ocelot_stats_layout[] = {
-- 
2.25.1

