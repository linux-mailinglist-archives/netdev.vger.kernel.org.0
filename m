Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B263082D2
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 02:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbhA2BCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 20:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231485AbhA2BBd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 20:01:33 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1949C061786
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:37 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id rv9so10520836ejb.13
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 17:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cnsxHhdfo2BF9JDv2pmS9fePxY3nRqmkS4gBp1bBE30=;
        b=b77Ov9ACyuzSo/6TVy9fCmHTACEZWskud1kRYTd6FiZUF4D4tKZWJ9bmRTZRHQg/V+
         xy7RBb9mxFPSScpjmb8rPrzZ+k2IEkebjDdn6C+w6qGrnGiTAWLxUvoxSuEDIp1o39MZ
         EpUWWqV/UNh+geHLmpjEYYUN0oR0AsnYGx0ORsvvLu01UFbtxAreO+3nK5sEcgixmZr7
         duvVNes+pY5fGtVgJM61FOLrqp2e8pcvQmjfDxxCohGiPo7VHtXDoViQFalMpr9FTRx7
         IEc+SOVqN4Df4mYsYpJ81mTW3FH5oBaB8s1jJ6mCAOdjSnx7ixM4fewTNLRON2seFgXx
         LSig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cnsxHhdfo2BF9JDv2pmS9fePxY3nRqmkS4gBp1bBE30=;
        b=dwZHpxwbaZcwooZuvIQh5InK8gngINRG3e0XtaqI85gVd2L0sekoLlp3ypVSSpl3rE
         9YDZ2gOEd2bD5i+Ht9AWsQu1pdrnkNWbJo+bdHzPHDdiPU7s76Eccv01bmZO7G745THS
         FM5nHTNeXMlhDG6QdnxBEqmXQEnsnCA1cWxEiFGy2YXEtAwfeh4un2o2XAw+2lY8hhQE
         X7V9LSPiFj3SROSw8hcKNo2PjnBxSUpvtkg0qhRueCJSGUKKd9FSGxjt/PEOSIkA4HMp
         YnqbMYioJbk5o0cpzPo4HCIgF3UEIqnoOI7duZahC0c3LVzWlvVPbmaxbK9SbB1VGWRe
         whZQ==
X-Gm-Message-State: AOAM5337YafoInS6wkxVD0fG4/Q5CQ2O9vLOI+5zq3qrTJpU7gun0eAE
        wIlXAQ4S4UbugO7t94mi3n0=
X-Google-Smtp-Source: ABdhPJy/wqmItTcw4MfeMtijADO8z11aBwRhVMic3SnGvdLPlIZH2lWm/ooHMps6wlF/XvMzp6V2Bg==
X-Received: by 2002:a17:906:26ca:: with SMTP id u10mr2173981ejc.165.1611882035866;
        Thu, 28 Jan 2021 17:00:35 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id f22sm3049256eje.34.2021.01.28.17.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jan 2021 17:00:35 -0800 (PST)
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
Subject: [PATCH v8 net-next 05/11] net: mscc: ocelot: don't use NPI tag prefix for the CPU port module
Date:   Fri, 29 Jan 2021 03:00:03 +0200
Message-Id: <20210129010009.3959398-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210129010009.3959398-1-olteanv@gmail.com>
References: <20210129010009.3959398-1-olteanv@gmail.com>
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
Changes in v8:
None.

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

