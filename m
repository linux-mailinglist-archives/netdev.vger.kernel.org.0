Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 358F126FB0B
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 12:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgIRK6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 06:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726440AbgIRK6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 06:58:16 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDA8C061788
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:15 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id i1so5704026edv.2
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 03:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v+26uBvU6tumwRNqNzFdC9/Kfd/Isq6Eu/czK8T9n9w=;
        b=rAoOPhiwsU0Fr0IqG2ni/gnPckGizpsmT2tWC93WDaBR53sUqwCFKDRte3iyjqgdiE
         /+Ydbet+1RPB4e5qDlePSZDo7QKeqqRVFZfpElrbDyTUr88ArSomMcbIfKj0i5LI+32Z
         xZOLiRFsFL+MXbgjtWrNaq64RmcKoMVZHvhVA2Sp/cG+a5/oOAiX7icgeamdPvzrs0sJ
         KGevlCJZCSTEoDVckzdWsG+sAN+Yyl9r/ZwbJBzk2ZToq8zMgwcwhIxcqtCufN4s6z0q
         Y+SJvOYBzBFWpKarHuMzRn5gqLpsbjgUc339qTwy2f0/0t5hD8+dY3qifUgMrGF39I06
         DEdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v+26uBvU6tumwRNqNzFdC9/Kfd/Isq6Eu/czK8T9n9w=;
        b=kSaIhGUJeTN7kYNS/rf1pL1GCZVqL5hPB+ZeaxTURc+nFVDgH2X60kYWq5735dzCxo
         O/cLMCaN6AUK9J38rVNrIiF/l0Yihk/KrMydLeMGD4YU4ncOcovzrwdNgbFpRu1g1YEB
         liurMs33JKeoG8rp6OM1rxtGDAdz8jnmuksVsZEmp+KwEC3Z4J7NsY10XH99KMYAhzD4
         jMBRqfU3XAhqGvdWL/eKzX+a21tJUHWAdpuawG26/qJSAdk27vH4Yn8VrQW4na6XGuLz
         F0Wt/nQIw+MDUBTPGl3mWTgKvfst9Nu0HEZYuLhjSQA/KiTLtw4eKD9KBWiz21vpQmU9
         FWGw==
X-Gm-Message-State: AOAM532ZVjPr6wfmkrX2wFilNNswh+QufkSB2ZFPHwx9YtTa0herK+l6
        YdC732FgxFw1Flx5OSw6ArZXr2DfI8k=
X-Google-Smtp-Source: ABdhPJw3P1eu+cGAAJyqPXda7XWWjjH8n/zWN0ZR06mBEiGKQoVnvGO8sfyYL6e1hvBcBtmIXwlDFw==
X-Received: by 2002:a50:bf47:: with SMTP id g7mr38101164edk.26.1600426694370;
        Fri, 18 Sep 2020 03:58:14 -0700 (PDT)
Received: from localhost.localdomain ([188.25.217.212])
        by smtp.gmail.com with ESMTPSA id k1sm1995086eji.20.2020.09.18.03.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2020 03:58:13 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     yangbo.lu@nxp.com, xiaoliang.yang_1@nxp.com,
        UNGLinuxDriver@microchip.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, kuba@kernel.org
Subject: [PATCH net-next 10/11] net: dsa: felix: move the PTP clock structure to felix_vsc9959.c
Date:   Fri, 18 Sep 2020 13:57:52 +0300
Message-Id: <20200918105753.3473725-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918105753.3473725-1-olteanv@gmail.com>
References: <20200918105753.3473725-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Not only does Sevile not have a PTP clock, but with separate modules,
this structure cannot even live in felix.c, due to the .owner =
THIS_MODULE assignment causing this link time error:

drivers/net/dsa/ocelot/felix.o:(.data+0x0): undefined reference to `__this_module'

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c         | 19 +------------------
 drivers/net/dsa/ocelot/felix.h         |  1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c | 18 ++++++++++++++++++
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index b523ea3a2e5f..fb1b3e117c78 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -538,23 +538,6 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	return 0;
 }
 
-static struct ptp_clock_info ocelot_ptp_clock_info = {
-	.owner		= THIS_MODULE,
-	.name		= "felix ptp",
-	.max_adj	= 0x7fffffff,
-	.n_alarm	= 0,
-	.n_ext_ts	= 0,
-	.n_per_out	= OCELOT_PTP_PINS_NUM,
-	.n_pins		= OCELOT_PTP_PINS_NUM,
-	.pps		= 0,
-	.gettime64	= ocelot_ptp_gettime64,
-	.settime64	= ocelot_ptp_settime64,
-	.adjtime	= ocelot_ptp_adjtime,
-	.adjfine	= ocelot_ptp_adjfine,
-	.verify		= ocelot_ptp_verify,
-	.enable		= ocelot_ptp_enable,
-};
-
 /* Hardware initialization done here so that we can allocate structures with
  * devm without fear of dsa_register_switch returning -EPROBE_DEFER and causing
  * us to allocate structures twice (leak memory) and map PCI memory twice
@@ -576,7 +559,7 @@ static int felix_setup(struct dsa_switch *ds)
 		return err;
 
 	if (ocelot->ptp) {
-		err = ocelot_init_timestamp(ocelot, &ocelot_ptp_clock_info);
+		err = ocelot_init_timestamp(ocelot, felix->info->ptp_caps);
 		if (err) {
 			dev_err(ocelot->dev,
 				"Timestamp initialization failed\n");
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 1d41eeda126e..d0b2043e0ccb 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -26,6 +26,7 @@ struct felix_info {
 	const struct vcap_props		*vcap;
 	int				switch_pci_bar;
 	int				imdio_pci_bar;
+	const struct ptp_clock_info	*ptp_caps;
 	int	(*mdio_bus_alloc)(struct ocelot *ocelot);
 	void	(*mdio_bus_free)(struct ocelot *ocelot);
 	void	(*phylink_validate)(struct ocelot *ocelot, int port,
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index b198fe9cb62b..38e0fba6bca8 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -719,6 +719,23 @@ static const struct vcap_props vsc9959_vcap_props[] = {
 	},
 };
 
+static const struct ptp_clock_info vsc9959_ptp_caps = {
+	.owner		= THIS_MODULE,
+	.name		= "felix ptp",
+	.max_adj	= 0x7fffffff,
+	.n_alarm	= 0,
+	.n_ext_ts	= 0,
+	.n_per_out	= OCELOT_PTP_PINS_NUM,
+	.n_pins		= OCELOT_PTP_PINS_NUM,
+	.pps		= 0,
+	.gettime64	= ocelot_ptp_gettime64,
+	.settime64	= ocelot_ptp_settime64,
+	.adjtime	= ocelot_ptp_adjtime,
+	.adjfine	= ocelot_ptp_adjfine,
+	.verify		= ocelot_ptp_verify,
+	.enable		= ocelot_ptp_enable,
+};
+
 #define VSC9959_INIT_TIMEOUT			50000
 #define VSC9959_GCB_RST_SLEEP			100
 #define VSC9959_SYS_RAMINIT_SLEEP		80
@@ -1169,6 +1186,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.num_tx_queues		= FELIX_NUM_TC,
 	.switch_pci_bar		= 4,
 	.imdio_pci_bar		= 0,
+	.ptp_caps		= &vsc9959_ptp_caps,
 	.mdio_bus_alloc		= vsc9959_mdio_bus_alloc,
 	.mdio_bus_free		= vsc9959_mdio_bus_free,
 	.phylink_validate	= vsc9959_phylink_validate,
-- 
2.25.1

