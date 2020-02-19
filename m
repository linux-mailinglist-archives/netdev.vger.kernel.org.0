Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E78164802
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 16:13:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727295AbgBSPNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 10:13:30 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34873 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbgBSPNK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 10:13:10 -0500
Received: by mail-wm1-f68.google.com with SMTP id b17so1066579wmb.0;
        Wed, 19 Feb 2020 07:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Bf+p51Y2acgWopilK4QyHatd9vkJ/jshO3U2ldalPpQ=;
        b=BEAumMoB7LUIk96KIseYLrawztknWGv2AQHU0ZbNirlVgI8FtmAnrWxiAO4yCmAUjZ
         7eZPVDKLwfLgiSjIg+nSNhKpkRxtSmDJ24ppuACyqb69YsgFk7OTGltjhzvQLWimNwmc
         L7SSar7MAg4JL/+pMtXmswkvHLZSTHW4S7EEo9pvQoVNHR/U2mUwC78b0k9blccN6XtY
         rmgD+PPOKgY1+i3VHQ8E/9dKayMS18clwLhIhMkxuwzAjq9SGb/U5OEY5jtXVUBS2oFL
         23KpbBgYEYE8o3DrwKfguGv4qYND+PDT6z4F2MP1HjaIKuKXzCTjo7qoxrWToxqEvSN7
         L7yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Bf+p51Y2acgWopilK4QyHatd9vkJ/jshO3U2ldalPpQ=;
        b=MCg0yyjzHLE32CeiXFkJMmgDYT4cACD0q+ofSjol6hQoK/BvhFBBv93v4Iu7l7Nxch
         T0D4IctmWU6AGu7sNCAMCFmOIwW3itztxSPzbWwmkMunC5C5QqtxpQg28qBcy4zXzXbu
         BJEcvO0ucBxuGKVQEbX7azadCf8w85ym13uB0xALGtRR/C12loK4M/+dIW0q1hm8OLBy
         w3vWd2SbiOPgfIyO03so2RNezbrAoAjlodoNeHmeSttFe9ldZfqARnLC7KxlSRhNxnV9
         Uf8Vn4EhWxy1XJZDyxWdOf2tOZH8A6ahCK6Uof0uqrgjesXSy5EFXbLu/k4VzAQ9gne3
         md1w==
X-Gm-Message-State: APjAAAWmB4UcA0RvsU7UUERPonPMfWpykQn18uWuyxqd7+CDgIBifIki
        m9r1FKLwkw7aj2a7hOY22qo=
X-Google-Smtp-Source: APXvYqzRCroxO4HiA10A9A3ZzB3u47+zIVOXhKAocWefpRL+4nGuDm0aeEt+OyKWQqHhXpMdzXH4rg==
X-Received: by 2002:a1c:688a:: with SMTP id d132mr11270577wmc.189.1582125187489;
        Wed, 19 Feb 2020 07:13:07 -0800 (PST)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id b13sm83137wrq.48.2020.02.19.07.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 07:13:07 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     shawnguo@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next/devicetree 2/5] net: dsa: felix: Use PHY_INTERFACE_MODE_INTERNAL instead of GMII
Date:   Wed, 19 Feb 2020 17:12:56 +0200
Message-Id: <20200219151259.14273-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200219151259.14273-1-olteanv@gmail.com>
References: <20200219151259.14273-1-olteanv@gmail.com>
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
---
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

