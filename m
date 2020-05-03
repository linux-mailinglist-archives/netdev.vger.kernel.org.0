Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31F71C2FEF
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 00:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729201AbgECWVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 May 2020 18:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729171AbgECWVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 May 2020 18:21:45 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F060C061A0F
        for <netdev@vger.kernel.org>; Sun,  3 May 2020 15:21:45 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u127so6726092wmg.1
        for <netdev@vger.kernel.org>; Sun, 03 May 2020 15:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lwKqbHAu7akpxgzXll//1km6QzeheKwbfiZz3W4GqJQ=;
        b=dcz3uTygqqGmsgqSJ3FFL54W1In/IA5NCXvTzJ7jMpbXOhY0p/GLrzcvEIpzYdV74k
         KcJ+rwW7E0iOxqnKcAvHF3iw89btrXkWvlapBfqMrODzFaPxMK8+yIdFZ6Bh7gXfBxAN
         Eroa1oQBsjgbc34v6VW2bo3VxnlSy9msP+kRt8J7u5in3+yj5yLeuG2WRaXAgy/Xcr0B
         5D8tv44aolDf0PhAVZ/yK6LXkLxNJBOeavw/DSsBC5c6O4dBeDaSiy9Wf4BQ5At+a9+M
         hHItphvAI4/4+nSfGewSAEfDYu7ZaV7U/nPzjj8zlKNlFUr0OL9gK8P/O0O8SppbPJIp
         Uk8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lwKqbHAu7akpxgzXll//1km6QzeheKwbfiZz3W4GqJQ=;
        b=RLq0qzDNgKayKUQKffklND2qRHx7+UlACpBB6nhukoI3KHWvHpbavR+6jDjpFUMQgM
         W3dRPeShcG+hNsl9BkQtWgnfDOG/iNVUL5+gjkI1fy/uYqBCmRx9oPb2rcdGnf12Bx0c
         ECbPTBNLHKCaZN1pfR8NfBi51VLwafnpyy66b+HQLyt6KGgk4O8PAvstNYSk8cEOTKQN
         ffOID/Yv42FlDxoKBUBvcFGL3AWXmjJ/RlMKlnGhlYl3xOAKE8U/Eu+kSM4SNCD8SvW8
         maBzypAUuE14h6WngtlEUfmm8kJZrU2ZoCORpC0KtEX/VJfWqttb0heOUJgSjpZcNXxO
         FVhw==
X-Gm-Message-State: AGi0PubvAmsNXIAA6ki3ZA7fxrR+uMy0wqgs1WHZpCL++QEb2oo2toCY
        wvx6ex0nG9edGhlIwnX/hH4=
X-Google-Smtp-Source: APiQypI0fy8KCMfeYFcOZs77yuuxeipZ6itD64DIpnJ2Bi9twhtZmnptfQRFYZfDQFlGjxrgq/RqZw==
X-Received: by 2002:a1c:4d17:: with SMTP id o23mr10696275wmh.47.1588544503826;
        Sun, 03 May 2020 15:21:43 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id i19sm15405847wrb.16.2020.05.03.15.21.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 May 2020 15:21:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     idosch@idosch.org, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, alexandre.belloni@bootlin.com,
        antoine.tenart@bootlin.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        claudiu.manoil@nxp.com, UNGLinuxDriver@microchip.com,
        alexandru.marginean@nxp.com, xiaoliang.yang_1@nxp.com,
        yangbo.lu@nxp.com, po.liu@nxp.com, jiri@mellanox.com,
        kuba@kernel.org
Subject: [PATCH net 1/2] net: dsa: ocelot: the MAC table on Felix is twice as large
Date:   Mon,  4 May 2020 01:20:26 +0300
Message-Id: <20200503222027.12991-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200503222027.12991-1-olteanv@gmail.com>
References: <20200503222027.12991-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

When running 'bridge fdb dump' on Felix, sometimes learnt and static MAC
addresses would appear, sometimes they wouldn't.

Turns out, the MAC table has 4096 entries on VSC7514 (Ocelot) and 8192
entries on VSC9959 (Felix), so the existing code from the Ocelot common
library only dumped half of Felix's MAC table. They are both organized
as a 4-way set-associative TCAM, so we just need a single variable
indicating the correct number of rows.

Fixes: 56051948773e ("net: dsa: ocelot: add driver for Felix switch family")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c          | 1 +
 drivers/net/dsa/ocelot/felix.h          | 1 +
 drivers/net/dsa/ocelot/felix_vsc9959.c  | 1 +
 drivers/net/ethernet/mscc/ocelot.c      | 6 ++----
 drivers/net/ethernet/mscc/ocelot_regs.c | 1 +
 include/soc/mscc/ocelot.h               | 1 +
 6 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 6aaea95029a9..9aa6a3d7afd4 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -401,6 +401,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	ocelot->stats_layout	= felix->info->stats_layout;
 	ocelot->num_stats	= felix->info->num_stats;
 	ocelot->shared_queue_sz	= felix->info->shared_queue_sz;
+	ocelot->num_mact_rows	= felix->info->num_mact_rows;
 	ocelot->vcap		= felix->info->vcap;
 	ocelot->ops		= felix->info->ops;
 
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index ce723deb9b5f..6b0dedc24a18 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -16,6 +16,7 @@ struct felix_info {
 	const u32 *const		*map;
 	const struct ocelot_ops		*ops;
 	int				shared_queue_sz;
+	int				num_mact_rows;
 	const struct ocelot_stat_layout	*stats_layout;
 	unsigned int			num_stats;
 	int				num_ports;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index f0c566c1c355..f362c6b84235 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -1310,6 +1310,7 @@ struct felix_info felix_info_vsc9959 = {
 	.num_stats		= ARRAY_SIZE(vsc9959_stats_layout),
 	.vcap			= vsc9959_vcap_props,
 	.shared_queue_sz	= 128 * 1024,
+	.num_mact_rows		= 2048,
 	.num_ports		= 6,
 	.switch_pci_bar		= 4,
 	.imdio_pci_bar		= 0,
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 884d547307f8..186ac4cd2ce6 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1038,10 +1038,8 @@ int ocelot_fdb_dump(struct ocelot *ocelot, int port,
 {
 	int i, j;
 
-	/* Loop through all the mac tables entries. There are 1024 rows of 4
-	 * entries.
-	 */
-	for (i = 0; i < 1024; i++) {
+	/* Loop through all the mac tables entries. */
+	for (i = 0; i < ocelot->num_mact_rows; i++) {
 		for (j = 0; j < 4; j++) {
 			struct ocelot_mact_entry entry;
 			bool is_static;
diff --git a/drivers/net/ethernet/mscc/ocelot_regs.c b/drivers/net/ethernet/mscc/ocelot_regs.c
index 69d97cbe25d6..2be74b275685 100644
--- a/drivers/net/ethernet/mscc/ocelot_regs.c
+++ b/drivers/net/ethernet/mscc/ocelot_regs.c
@@ -436,6 +436,7 @@ int ocelot_chip_init(struct ocelot *ocelot, const struct ocelot_ops *ops)
 	ocelot->stats_layout = ocelot_stats_layout;
 	ocelot->num_stats = ARRAY_SIZE(ocelot_stats_layout);
 	ocelot->shared_queue_sz = 224 * 1024;
+	ocelot->num_mact_rows = 1024;
 	ocelot->ops = ops;
 
 	ret = ocelot_regfields_init(ocelot, ocelot_regfields);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index 8a9180b882fc..06e67f60e5f7 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -513,6 +513,7 @@ struct ocelot {
 	unsigned int			num_stats;
 
 	int				shared_queue_sz;
+	int				num_mact_rows;
 
 	struct net_device		*hw_bridge_dev;
 	u16				bridge_mask;
-- 
2.17.1

