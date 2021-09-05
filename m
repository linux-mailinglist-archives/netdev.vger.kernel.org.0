Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8935401109
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 19:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbhIER0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 13:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhIER0E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 13:26:04 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8379CC061575
        for <netdev@vger.kernel.org>; Sun,  5 Sep 2021 10:25:00 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id k13so8693519lfv.2
        for <netdev@vger.kernel.org>; Sun, 05 Sep 2021 10:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IGjYSK/IfQ/g9YQ9So/4/5YSriZBQIWsAdQ8yz4ld9Q=;
        b=GvwuhdGjwt8K6qFhFsFrbtMOSLOnlfjldtf+QtuUtU/MNUqNsSiSOB2U+yAh5N56OV
         UULgTezfXsOj47FHMyP203HXyYH2SdVYdDLFchkKlsBHfyqGbdlTN5mta4DxM8A7rtKe
         7kPAP+cLqrb/trBtK2Z6PfyhvD3sNN90g+w+4H9I3/+AVDWDsk4PZE3OIF3ld5OT9EOp
         cnIAa4WeM7T1znNZ7TkrjNtd+nAoBzkdKKNBosuWzSZ4c9FYOGIVxGAQTEk8fisBN/df
         rHO8yCf4TQuCy0N7qSISMHGVuMy7/qRGtXCnFAcDeeKfIfAQ8X0XDDtbe3y/Pv4ewNh+
         06Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IGjYSK/IfQ/g9YQ9So/4/5YSriZBQIWsAdQ8yz4ld9Q=;
        b=SNqKYoGPfdaVGQEswis8JyFfvpPNQNZQTmQ7SINvonM1P2UWuX8pmjiBJeH/Ys/5rS
         b+0DESqJBG0ZuQMfT+zMI1hMfFd6dLVdYuUHoTZYgIh37RWleGwvTUEzyFECSnjUXMgX
         EHF4TtmNsGjhlqCr0EE2/0i7h7gsS4YX0py1Fmq0YsNiG9bhvqNCD/pmW0sjNbP1eUgt
         L7cUA96UhMy9u2Rn7L6CzI33CEv0MjfSicmUJp1U5/0rPdypOpD9Pb+TP/vUYkIuFzdv
         HhOgy9t0ZjJwXP491wy/f5xkRNI3a2FxDWcxQO3G3rVlh72EKR0Yc3IuWJI7gdbh2/r4
         KM5w==
X-Gm-Message-State: AOAM530hMGnxoLSiXPrXhCCbRacRUXFgxELlUS+90Cb9QVu0vx5t66mE
        dpFVAQKJCkW5pTPM5g4tBc2dlG4eAXQ=
X-Google-Smtp-Source: ABdhPJygd7EG6ITRI9xsxB0D4T99unbFZg0Z3Cwzz81bQm1JtxJC/Z12KKWHbeRFDXTLrBCWIMpRbw==
X-Received: by 2002:a05:6512:ca:: with SMTP id c10mr6807482lfp.615.1630862698853;
        Sun, 05 Sep 2021 10:24:58 -0700 (PDT)
Received: from localhost.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id g24sm706336ljm.6.2021.09.05.10.24.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Sep 2021 10:24:58 -0700 (PDT)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] net: dsa: b53: Fix IMP port setup on BCM5301x
Date:   Sun,  5 Sep 2021 19:23:28 +0200
Message-Id: <20210905172328.26281-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

Broadcom's b53 switches have one IMP (Inband Management Port) that needs
to be programmed using its own designed register. IMP port may be
different than CPU port - especially on devices with multiple CPU ports.

For that reason it's required to explicitly note IMP port index and
check for it when choosing a register to use.

This commit fixes BCM5301x support. Those switches use CPU port 5 while
their IMP port is 8. Before this patch b53 was trying to program port 5
with B53_PORT_OVERRIDE_CTRL instead of B53_GMII_PORT_OVERRIDE_CTRL(5).

It may be possible to also replace "cpu_port" usages with
dsa_is_cpu_port() but that is out of the scope of thix BCM5301x fix.

Fixes: 967dd82ffc52 ("net: dsa: b53: Add support for Broadcom RoboSwitch")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/dsa/b53/b53_common.c | 28 +++++++++++++++++++++++++---
 drivers/net/dsa/b53/b53_priv.h   |  1 +
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 5646eb8afe38..604f54112665 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1144,7 +1144,7 @@ static void b53_force_link(struct b53_device *dev, int port, int link)
 	u8 reg, val, off;
 
 	/* Override the port settings */
-	if (port == dev->cpu_port) {
+	if (port == dev->imp_port) {
 		off = B53_PORT_OVERRIDE_CTRL;
 		val = PORT_OVERRIDE_EN;
 	} else {
@@ -1168,7 +1168,7 @@ static void b53_force_port_config(struct b53_device *dev, int port,
 	u8 reg, val, off;
 
 	/* Override the port settings */
-	if (port == dev->cpu_port) {
+	if (port == dev->imp_port) {
 		off = B53_PORT_OVERRIDE_CTRL;
 		val = PORT_OVERRIDE_EN;
 	} else {
@@ -1236,7 +1236,7 @@ static void b53_adjust_link(struct dsa_switch *ds, int port,
 	b53_force_link(dev, port, phydev->link);
 
 	if (is531x5(dev) && phy_interface_is_rgmii(phydev)) {
-		if (port == 8)
+		if (port == dev->imp_port)
 			off = B53_RGMII_CTRL_IMP;
 		else
 			off = B53_RGMII_CTRL_P(port);
@@ -2280,6 +2280,7 @@ struct b53_chip_data {
 	const char *dev_name;
 	u16 vlans;
 	u16 enabled_ports;
+	u8 imp_port;
 	u8 cpu_port;
 	u8 vta_regs[3];
 	u8 arl_bins;
@@ -2304,6 +2305,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 2,
 		.arl_buckets = 1024,
+		.imp_port = 5,
 		.cpu_port = B53_CPU_PORT_25,
 		.duplex_reg = B53_DUPLEX_STAT_FE,
 	},
@@ -2314,6 +2316,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 2,
 		.arl_buckets = 1024,
+		.imp_port = 5,
 		.cpu_port = B53_CPU_PORT_25,
 		.duplex_reg = B53_DUPLEX_STAT_FE,
 	},
@@ -2324,6 +2327,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2337,6 +2341,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2350,6 +2355,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS_9798,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2363,6 +2369,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x7f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS_9798,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2377,6 +2384,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.arl_bins = 4,
 		.arl_buckets = 1024,
 		.vta_regs = B53_VTA_REGS,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
 		.jumbo_pm_reg = B53_JUMBO_PORT_MASK,
@@ -2389,6 +2397,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0xff,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2402,6 +2411,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1ff,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2415,6 +2425,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0, /* pdata must provide them */
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS_63XX,
 		.duplex_reg = B53_DUPLEX_STAT_63XX,
@@ -2428,6 +2439,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2441,6 +2453,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1bf,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2454,6 +2467,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1bf,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2467,6 +2481,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2480,6 +2495,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1f,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT_25, /* TODO: auto detect */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2493,6 +2509,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1ff,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2506,6 +2523,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x103,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2520,6 +2538,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1bf,
 		.arl_bins = 4,
 		.arl_buckets = 256,
+		.imp_port = 8,
 		.cpu_port = 8, /* TODO: ports 4, 5, 8 */
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2533,6 +2552,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1ff,
 		.arl_bins = 4,
 		.arl_buckets = 1024,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2546,6 +2566,7 @@ static const struct b53_chip_data b53_switch_chips[] = {
 		.enabled_ports = 0x1ff,
 		.arl_bins = 4,
 		.arl_buckets = 256,
+		.imp_port = 8,
 		.cpu_port = B53_CPU_PORT,
 		.vta_regs = B53_VTA_REGS,
 		.duplex_reg = B53_DUPLEX_STAT_GE,
@@ -2571,6 +2592,7 @@ static int b53_switch_init(struct b53_device *dev)
 			dev->vta_regs[1] = chip->vta_regs[1];
 			dev->vta_regs[2] = chip->vta_regs[2];
 			dev->jumbo_pm_reg = chip->jumbo_pm_reg;
+			dev->imp_port = chip->imp_port;
 			dev->cpu_port = chip->cpu_port;
 			dev->num_vlans = chip->vlans;
 			dev->num_arl_bins = chip->arl_bins;
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 9bf8319342b0..5d068acf7cf8 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -123,6 +123,7 @@ struct b53_device {
 
 	/* used ports mask */
 	u16 enabled_ports;
+	unsigned int imp_port;
 	unsigned int cpu_port;
 
 	/* connect specific data */
-- 
2.26.2

