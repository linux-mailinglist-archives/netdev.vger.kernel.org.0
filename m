Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71B9D274F70
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 05:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726770AbgIWDMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 23:12:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726773AbgIWDMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 23:12:05 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CE3C0613D0;
        Tue, 22 Sep 2020 20:12:05 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id u24so2668829pgi.1;
        Tue, 22 Sep 2020 20:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aMfMg44+07y4Ta/l8HD8ypVqfw7DPQQWSacNL9HEQjA=;
        b=AYjMYGR00907/cHGtgeFVcGfu5QYdje9a2OFjEjLn+3BIt6p3sgwI/Klsiz+IU+pxm
         0k0FtBm4C5L86Cct+bIWmogR+GrLXGK6yxpTf0OzQL4LypgnHKJvMEQDCKjgf/UWYO/G
         V+sWvj1Ysmc/9LBx1CHeVGFqQGm3TRSE3yTkGIvWSb5czpBJpHQy1/Hm1RM+8ow352u0
         aKZIkGsNb+Y/sCSCvju2i/tYwBkBFOgFcGN697ZqVY+xZTTg9QT6v/+5T29KgQhQPQwX
         Bgthzqlreejhh0pcdrkx2E4Wd+Gb/PWrI8OrNf9nMpU+o8mfM14sfkHnJDcnxQXi9ASO
         9qXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aMfMg44+07y4Ta/l8HD8ypVqfw7DPQQWSacNL9HEQjA=;
        b=NWQwrcU6r0nXdc5p6dbxdaN7QkMJg59H8J6v24M4MlTd6X731YK95j1UoDQdUC0z5f
         NItsEGg/fDwwCDN+jOC+3VLvXVDurfdUewddAae3imqie015NobnhZ8/jmdDsebkI8P/
         1euWIVS96FkmK0be5IlAlyZJGG4BeK2VIf3nSpJRwG5iuOQ2jWhwygcZgm3wpxaTPf6i
         xEBl3cs4n719R27Hg3dF2Gf2YSKm9vNA2EQfy8ifrqSPOATqPjeZjJvbO/5C27xroRpW
         j2eiV8eB/M657YbkYNkcG2Z9ZamYyqXZcS4DoNEwDiwtFHA2Pxx+cYYNvFYxmNXJcmVc
         eUxQ==
X-Gm-Message-State: AOAM530YtVhwuOlvYyLZ1Xo7ews268cCV8F0vOa+dlhZS/gPEeRk/X+N
        nMt/01gOajPNurGyz/4X6GD8+GjoJwbaJA==
X-Google-Smtp-Source: ABdhPJz26kCuYwm9+iy/G68i/5gzqqLOQB9DiGABKlIgX3orXwDnrjAC4SHebsjmfHoqa89hpsnT3w==
X-Received: by 2002:a62:5f02:0:b029:13c:1611:6536 with SMTP id t2-20020a625f020000b029013c16116536mr6590250pfb.8.1600830724151;
        Tue, 22 Sep 2020 20:12:04 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x185sm16520351pfc.188.2020.09.22.20.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 20:12:03 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        vladimir.oltean@nxp.com, olteanv@gmail.com, nikolay@nvidia.com
Subject: [PATCH net-next 2/2] net: dsa: b53: Configure VLANs while not filtering
Date:   Tue, 22 Sep 2020 20:11:55 -0700
Message-Id: <20200923031155.2832348-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200923031155.2832348-1-f.fainelli@gmail.com>
References: <20200923031155.2832348-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update the B53 driver to support VLANs while not filtering. This
requires us to enable VLAN globally within the switch upon driver
initial configuration (dev->vlan_enabled).

We also need to remove the code that dealt with PVID re-configuration in
b53_vlan_filtering() since that function worked under the assumption
that it would only be called to make a bridge VLAN filtering, or not
filtering, and we would attempt to move the port's PVID accordingly.

Now that VLANs are programmed all the time, even in the case of a
non-VLAN filtering bridge, we would be programming a default_pvid for
the bridged switch ports.

We need the DSA receive path to pop the VLAN tag if it is the bridge's
default_pvid because the CPU port is always programmed tagged in the
programmed VLANs. In order to do so we utilize the
dsa_untag_bridge_pvid() helper introduced in the commit before by
setting ds->untag_bridge_pvid to true.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 20 +++-----------------
 drivers/net/dsa/b53/b53_priv.h   |  1 -
 2 files changed, 3 insertions(+), 18 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 6a5796c32721..ce18ba0b74eb 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1377,23 +1377,6 @@ EXPORT_SYMBOL(b53_phylink_mac_link_up);
 int b53_vlan_filtering(struct dsa_switch *ds, int port, bool vlan_filtering)
 {
 	struct b53_device *dev = ds->priv;
-	u16 pvid, new_pvid;
-
-	b53_read16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port), &pvid);
-	if (!vlan_filtering) {
-		/* Filtering is currently enabled, use the default PVID since
-		 * the bridge does not expect tagging anymore
-		 */
-		dev->ports[port].pvid = pvid;
-		new_pvid = b53_default_pvid(dev);
-	} else {
-		/* Filtering is currently disabled, restore the previous PVID */
-		new_pvid = dev->ports[port].pvid;
-	}
-
-	if (pvid != new_pvid)
-		b53_write16(dev, B53_VLAN_PAGE, B53_VLAN_PORT_DEF_TAG(port),
-			    new_pvid);
 
 	b53_enable_vlan(dev, dev->vlan_enabled, vlan_filtering);
 
@@ -2619,6 +2602,9 @@ struct b53_device *b53_switch_alloc(struct device *base,
 	dev->priv = priv;
 	dev->ops = ops;
 	ds->ops = &b53_switch_ops;
+	ds->configure_vlan_while_not_filtering = true;
+	ds->untag_bridge_pvid = true;
+	dev->vlan_enabled = ds->configure_vlan_while_not_filtering;
 	mutex_init(&dev->reg_mutex);
 	mutex_init(&dev->stats_mutex);
 
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index c55c0a9f1b47..24893b592216 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -91,7 +91,6 @@ enum {
 struct b53_port {
 	u16		vlan_ctl_mask;
 	struct ethtool_eee eee;
-	u16		pvid;
 };
 
 struct b53_vlan {
-- 
2.25.1

