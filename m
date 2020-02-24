Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFE0016A5E0
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 13:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgBXMQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 07:16:22 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35451 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727479AbgBXMQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 07:16:21 -0500
Received: by mail-wr1-f67.google.com with SMTP id w12so10130904wrt.2;
        Mon, 24 Feb 2020 04:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lM1noc9PUiQflnRBzTeWjbmtSkjL6gxjbFPi+jFFqU0=;
        b=S8Lbyh56/1VskdcEI+qgWBQPYwCDCse572fYomqSsOcJh0+4LdnBoY8HufRxn0Szf6
         rCUKTaAVwyzV7FzdFppwry61pm+TsKJqsMrHoLDS0h6TjAlfEAqmyxiZmTTIopjDdi9I
         7mH2uOVYgnWvWXD3xcuuOZlqOgkzWZJHahCr+Ccwjn89DhsG4jkdU28mD6O5Gr9/kWrP
         Q5pb0B7IIZWpvq7o4aezld5gSBv1REoaLhG+dckRoej6vbgahZ7SjFewKOQm+KPbLilg
         ARWWPTCEf7yO/01pIGzEwxNaIL9YDZ05MfoF13PLnkjlI2PWLLdYEtCY3hrRID2iLvhc
         tpQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lM1noc9PUiQflnRBzTeWjbmtSkjL6gxjbFPi+jFFqU0=;
        b=mmoJ8A4IBfQ+e0FxJrq5kBlWUBzsvcmxrMY+PO1jahQqPAVFveoqO7kyC74sDHyDsJ
         fwhgfQcO5pxTRA5LH0cAeSGlciukueg/yvNl+XAi54MBHKX2NImsqfrf6AmbrIH1ODS3
         XKJ+nPt4dwPvxeLspD/6TuhKA81wxbiesE3aWpr7xtl8oIiFLSfsyaY+8yWDd5OhpLvI
         DbMBmjpfLwOh81BbQX3pSKqbCVwWmiXCRLxgDOm3QIbYtqfMmJ1UDscyI+sIExH7milh
         dYeRYTR0eKRP5i78SJns0wWujfY5HUffVE0L0mN6q3C/OL622gCmhBwCJp/cniHBSTJo
         IgIw==
X-Gm-Message-State: APjAAAUHgd/boRPHavJn5MAhwnzjk7x6qg22WGccKgt2a7ChMn2K2mV/
        qPe869uoLWMsMwEpvMZAGdU=
X-Google-Smtp-Source: APXvYqwJ5vrY22lSnaNQzKaFnaK6lbzsxFmPE9kVbJl+7+h16gPt5kB7LhH3Lc9S78hDL5bSP1aANQ==
X-Received: by 2002:adf:f012:: with SMTP id j18mr66347461wro.314.1582546577911;
        Mon, 24 Feb 2020 04:16:17 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id a13sm8450456wrv.62.2020.02.24.04.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 04:16:17 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        michael@walle.cc, linux-kernel@vger.kernel.org
Subject: [PATCH v4 net-next 1/2] net: dsa: felix: Use PHY_INTERFACE_MODE_INTERNAL instead of GMII
Date:   Mon, 24 Feb 2020 14:15:33 +0200
Message-Id: <20200224121534.29679-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200224121534.29679-1-olteanv@gmail.com>
References: <20200224121534.29679-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

phy-mode = "gmii" is confusing because it may mean that the port
supports the 8-bit-wide parallel data interface pinout, which it
doesn't.

It may also be confusing because one of the "gmii" internal ports is
actually overclocked to run at 2.5Gbps (even though, yes, as far as the
switch MAC is concerned, it still thinks it's gigabit).

So use the phy-mode = "internal" property to describe the internal ports
inside the NXP LS1028A chip (the ones facing the ENETC). The change
should be fine, because the device tree bindings document is yet to be
introduced, and there are no stable DT blobs in use.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Tested-by: Michael Walle <michael@walle.cc>
---
Changes in v4:
None.

Changes in v3:
None.

Changes in v2:
Patch is new.

 drivers/net/dsa/ocelot/felix.c         | 3 +--
 drivers/net/dsa/ocelot/felix_vsc9959.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 3257962c147e..35124ef7e75b 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -176,8 +176,7 @@ static void felix_phylink_validate(struct dsa_switch *ds, int port,
 	phylink_set(mask, 100baseT_Full);
 	phylink_set(mask, 1000baseT_Full);
 
-	/* The internal ports that run at 2.5G are overclocked GMII */
-	if (state->interface == PHY_INTERFACE_MODE_GMII ||
+	if (state->interface == PHY_INTERFACE_MODE_INTERNAL ||
 	    state->interface == PHY_INTERFACE_MODE_2500BASEX ||
 	    state->interface == PHY_INTERFACE_MODE_USXGMII) {
 		phylink_set(mask, 2500baseT_Full);
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 2c812b481778..93800e81cdd4 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -955,8 +955,7 @@ static int vsc9959_prevalidate_phy_mode(struct ocelot *ocelot, int port,
 					phy_interface_t phy_mode)
 {
 	switch (phy_mode) {
-	case PHY_INTERFACE_MODE_GMII:
-		/* Only supported on internal to-CPU ports */
+	case PHY_INTERFACE_MODE_INTERNAL:
 		if (port != 4 && port != 5)
 			return -ENOTSUPP;
 		return 0;
-- 
2.17.1

