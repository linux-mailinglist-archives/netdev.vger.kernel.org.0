Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED5AD302EA9
	for <lists+netdev@lfdr.de>; Mon, 25 Jan 2021 23:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733189AbhAYWHV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 17:07:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733151AbhAYWGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 17:06:12 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C970EC0613ED
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:04:31 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id n6so17383803edt.10
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 14:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R80rKR8xhGvkhvxNcFZ5Dztn+Dx4q1giZJEP37pLBOc=;
        b=WniA88n4xprxNsLmUHlLmDiLKAYWv3Wfn54uhAQmu9E8urPlw+IHsCrssCthec+H1z
         ZqcPevzRq84qhSAibx+YfwdfE/giiokbS3YtCZ2znxM6Chybjg+1bapdRymL1GjP/V6Q
         SxLGYKfvvW8dDR6zpyy8/VoaU/O4EItZ9naENizKFYAHd+THTsnbrhcQqJ30SxXs6FLE
         dpstFvw2Rwi47SWNwnEaiq9g9a+4tY3IaXWt3XTpsRwnFzdmL9hjQVFhDBF+EUXRx+N8
         Xf969cMyj+NR8u0Ftd2Rs0FlE/HrRVxF/TUJXKbSW4vHlfvD29Ha/Loc69qv4i9GuAWZ
         iVJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R80rKR8xhGvkhvxNcFZ5Dztn+Dx4q1giZJEP37pLBOc=;
        b=JgEUlltX1RpjTmXs4rJFenfusk6B3GHELK8K+P15nvjIhtoBJixe25gp5u1QSkwTsv
         4j/ryTHU9L1MGx+1i8sLX9ldzFn4SbouT1PPkJ2Rq+ki5k+an0rybjPRUh8md5gOnL34
         WsLmRnC40ZRfT7+ryQXwP2Kuk6P2CoK19D57Cif6B8t6nLja2H0qVYHqhVS3quB4Hf83
         aMUWWuwYg9zMRhROsIhRG8DqjjFV5l3wvKp6sfPRlFVUBXV+FK4vkF3811wZtfLmstcy
         4YGIjErlu/I7BKknDZtT5WCFNcP9V1LstgHDSP+0coN6S/OyUwqxoKOlDXvSpvbjcEW3
         zi1A==
X-Gm-Message-State: AOAM530sCIVkGR0kDr3hz1rXSB5c+mR0K9D+LQdDQ1PZS1AfBH2ZiRUR
        RDNU1Po7fzz8nquESJUbBrU=
X-Google-Smtp-Source: ABdhPJxM7M98224JoBI90LsYR+MXRdNjAp9VxktFNLQlqgBg34ApRm1A5Z2E5Km4LUh4oA9LO6h7hQ==
X-Received: by 2002:a05:6402:524a:: with SMTP id t10mr2235068edd.270.1611612270529;
        Mon, 25 Jan 2021 14:04:30 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id s13sm1760555edi.92.2021.01.25.14.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 14:04:29 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v7 net-next 05/11] net: mscc: ocelot: don't use NPI tag prefix for the CPU port module
Date:   Tue, 26 Jan 2021 00:03:27 +0200
Message-Id: <20210125220333.1004365-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210125220333.1004365-1-olteanv@gmail.com>
References: <20210125220333.1004365-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Context: Ocelot switches put the injection/extraction frame header in
front of the Ethernet header. When used in NPI mode, a DSA master would
see junk instead of the destination MAC address, and it would most
likely drop the packets. So the Ocelot frame header can have an optional
prefix, which is just "ff:ff:ff:ff:ff:fe > ff:ff:ff:ff:ff:ff" padding
put before the actual tag (still before the real Ethernet header) such
that the DSA master thinks it's looking at a broadcast frame with a
strange EtherType.

Unfortunately, a lesson learned in commit 69df578c5f4b ("net: mscc:
ocelot: eliminate confusion between CPU and NPI port") seems to have
been forgotten in the meanwhile.

The CPU port module and the NPI port have independent settings for the
length of the tag prefix. However, the driver is using the same variable
to program both of them.

There is no reason really to use any tag prefix with the CPU port
module, since that is not connected to any Ethernet port. So this patch
makes the inj_prefix and xtr_prefix variables apply only to the NPI
port (which the switchdev ocelot_vsc7514 driver does not use).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v7:
None.

Changes in v6:
None.

Changes in v5:
None.

Changes in v4:
Patch is new.

 drivers/net/dsa/ocelot/felix.c             |  8 ++++----
 drivers/net/ethernet/mscc/ocelot.c         | 12 ++++++------
 drivers/net/ethernet/mscc/ocelot_vsc7514.c |  2 --
 include/soc/mscc/ocelot.h                  |  4 ++--
 4 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 767cbdccdb3e..054e57dd4383 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -425,8 +425,8 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 	ocelot->num_mact_rows	= felix->info->num_mact_rows;
 	ocelot->vcap		= felix->info->vcap;
 	ocelot->ops		= felix->info->ops;
-	ocelot->inj_prefix	= OCELOT_TAG_PREFIX_SHORT;
-	ocelot->xtr_prefix	= OCELOT_TAG_PREFIX_SHORT;
+	ocelot->npi_inj_prefix	= OCELOT_TAG_PREFIX_SHORT;
+	ocelot->npi_xtr_prefix	= OCELOT_TAG_PREFIX_SHORT;
 	ocelot->devlink		= felix->ds->devlink;
 
 	port_phy_modes = kcalloc(num_phys_ports, sizeof(phy_interface_t),
@@ -541,9 +541,9 @@ static void felix_npi_port_init(struct ocelot *ocelot, int port)
 
 	/* NPI port Injection/Extraction configuration */
 	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_XTR_HDR,
-			    ocelot->xtr_prefix);
+			    ocelot->npi_xtr_prefix);
 	ocelot_fields_write(ocelot, port, SYS_PORT_MODE_INCL_INJ_HDR,
-			    ocelot->inj_prefix);
+			    ocelot->npi_inj_prefix);
 
 	/* Disable transmission of pause frames */
 	ocelot_fields_write(ocelot, port, SYS_PAUSE_CFG_PAUSE_ENA, 0);
diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 7352f58f9bc2..714165c2f85a 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1359,9 +1359,9 @@ void ocelot_port_set_maxlen(struct ocelot *ocelot, int port, size_t sdu)
 	if (port == ocelot->npi) {
 		maxlen += OCELOT_TAG_LEN;
 
-		if (ocelot->inj_prefix == OCELOT_TAG_PREFIX_SHORT)
+		if (ocelot->npi_inj_prefix == OCELOT_TAG_PREFIX_SHORT)
 			maxlen += OCELOT_SHORT_PREFIX_LEN;
-		else if (ocelot->inj_prefix == OCELOT_TAG_PREFIX_LONG)
+		else if (ocelot->npi_inj_prefix == OCELOT_TAG_PREFIX_LONG)
 			maxlen += OCELOT_LONG_PREFIX_LEN;
 	}
 
@@ -1391,9 +1391,9 @@ int ocelot_get_max_mtu(struct ocelot *ocelot, int port)
 	if (port == ocelot->npi) {
 		max_mtu -= OCELOT_TAG_LEN;
 
-		if (ocelot->inj_prefix == OCELOT_TAG_PREFIX_SHORT)
+		if (ocelot->npi_inj_prefix == OCELOT_TAG_PREFIX_SHORT)
 			max_mtu -= OCELOT_SHORT_PREFIX_LEN;
-		else if (ocelot->inj_prefix == OCELOT_TAG_PREFIX_LONG)
+		else if (ocelot->npi_inj_prefix == OCELOT_TAG_PREFIX_LONG)
 			max_mtu -= OCELOT_LONG_PREFIX_LEN;
 	}
 
@@ -1478,9 +1478,9 @@ static void ocelot_cpu_port_init(struct ocelot *ocelot)
 	ocelot_fields_write(ocelot, cpu, QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);
 	/* CPU port Injection/Extraction configuration */
 	ocelot_fields_write(ocelot, cpu, SYS_PORT_MODE_INCL_XTR_HDR,
-			    ocelot->xtr_prefix);
+			    OCELOT_TAG_PREFIX_NONE);
 	ocelot_fields_write(ocelot, cpu, SYS_PORT_MODE_INCL_INJ_HDR,
-			    ocelot->inj_prefix);
+			    OCELOT_TAG_PREFIX_NONE);
 
 	/* Configure the CPU port to be VLAN aware */
 	ocelot_write_gix(ocelot, ANA_PORT_VLAN_CFG_VLAN_VID(0) |
diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 30a38df08a21..407244fe5b17 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -1347,8 +1347,6 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	ocelot->num_flooding_pgids = 1;
 
 	ocelot->vcap = vsc7514_vcap_props;
-	ocelot->inj_prefix = OCELOT_TAG_PREFIX_NONE;
-	ocelot->xtr_prefix = OCELOT_TAG_PREFIX_NONE;
 	ocelot->npi = -1;
 
 	err = ocelot_init(ocelot);
diff --git a/include/soc/mscc/ocelot.h b/include/soc/mscc/ocelot.h
index cdc33fa05660..93c22627dedd 100644
--- a/include/soc/mscc/ocelot.h
+++ b/include/soc/mscc/ocelot.h
@@ -651,8 +651,8 @@ struct ocelot {
 
 	int				npi;
 
-	enum ocelot_tag_prefix		inj_prefix;
-	enum ocelot_tag_prefix		xtr_prefix;
+	enum ocelot_tag_prefix		npi_inj_prefix;
+	enum ocelot_tag_prefix		npi_xtr_prefix;
 
 	u32				*lags;
 
-- 
2.25.1

