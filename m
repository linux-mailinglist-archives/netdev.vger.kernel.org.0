Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D6D26265F
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 06:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725897AbgIIEcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 00:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725772AbgIIEck (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 00:32:40 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F01C061573;
        Tue,  8 Sep 2020 21:32:40 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id s2so704955pjr.4;
        Tue, 08 Sep 2020 21:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZL1/dFPSyKDLoUtfW2I3TnJOQ1LLw3ZjlfPq0EZElIo=;
        b=vZS5kURLZDuYQhY8ACURTlu/876ye9UykjPe24ra2DbJiBluTLdsYqi/PI9bBneS2f
         GciINZgtJMKrtW/zCbRi+iH2+Z2+UXWmsV8LGcuPDpFy5RXiMCRjoEmYzL7Uyt9L9RFN
         CQz31RY1JXIEV3RKPCXRBfEa5q24zApCwaOpzkYsPaxaqNBt53Df7bdB2QkSiInZ8ErQ
         GpqxVLNIT2dXV//LS/OEex/JiF6QHxurKOzhFK+cYN2AmIBY3Ar5ib7lUI42WFndgVXw
         eB//Wvf/dckUoctehdKMCcwF9ucwhCV1XSceTCF28/X/sdD7LFFOqD4syilUrjTOdN1X
         vjWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZL1/dFPSyKDLoUtfW2I3TnJOQ1LLw3ZjlfPq0EZElIo=;
        b=ZA9Ke6lh+TdibPBzfr9ezkDFj/AEsKdbHf3ynP7lTm6QcyHSRbaCjbFkewVxqLtwyJ
         O8/S5Q999HJpYUZD40W7za50sDBeOqcGdQhzoYIezX+IoiPXcS2fWu04y/+hzI4i76g/
         il3vPUEzIziHK2HRyaX4W+cdHkhHKDvXF8LtFtuPA9j8AK94aQPz7IL3bMFU/kP0mFX9
         nBAUIJG320OZWbDyCmOGOhvL8tLjaWV0dOQKrtpK4oHAd2PXp8yKwQn7A9vwYZQXadGM
         hTjEvIBpSOoGijLIBtJiOXaE7KXYCki6eHS1VXxq9h6+qhDZu1kvhFyhWWlDTeWkMajL
         y6TQ==
X-Gm-Message-State: AOAM531DrJpfWOhL2L43g7f6nSI7JdlNTG2pQPDdGp4Nk0M4Nf/BFte/
        XrhgV1QlzaG1UARETwTznpGzIhi+ejA=
X-Google-Smtp-Source: ABdhPJzclGbvNrY8NUl/8c/ky2RgtEtE9sDRgdRO08HBwjGQYV7iY+8zWagTigmChSy6VxMcoM5EwA==
X-Received: by 2002:a17:90a:fe07:: with SMTP id ck7mr1974550pjb.20.1599625957983;
        Tue, 08 Sep 2020 21:32:37 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ih11sm638444pjb.51.2020.09.08.21.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 21:32:37 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next] net: dsa: b53: Report VLAN table occupancy via devlink
Date:   Tue,  8 Sep 2020 21:32:34 -0700
Message-Id: <20200909043235.4080900-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We already maintain an array of VLANs used by the switch so we can
simply iterate over it to report the occupancy via devlink.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 59 ++++++++++++++++++++++++++++++--
 drivers/net/dsa/b53/b53_priv.h   |  1 +
 drivers/net/dsa/bcm_sf2.c        |  8 ++++-
 3 files changed, 65 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 26fcff85d881..a1527665e817 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -977,6 +977,53 @@ int b53_get_sset_count(struct dsa_switch *ds, int port, int sset)
 }
 EXPORT_SYMBOL(b53_get_sset_count);
 
+enum b53_devlink_resource_id {
+	B53_DEVLINK_PARMA_ID_VLAN_TABLE,
+};
+
+static u64 b53_devlink_vlan_table_get(void *priv)
+{
+	struct b53_device *dev = priv;
+	unsigned int i, count = 0;
+	struct b53_vlan *vl;
+
+	for (i = 0; i < dev->num_vlans; i++) {
+		vl = &dev->vlans[i];
+		if (vl->members)
+			count++;
+	}
+
+	return count;
+}
+
+int b53_setup_devlink_resources(struct dsa_switch *ds)
+{
+	struct devlink_resource_size_params size_params;
+	struct b53_device *dev = ds->priv;
+	int err;
+
+	devlink_resource_size_params_init(&size_params, dev->num_vlans,
+					  dev->num_vlans,
+					  1, DEVLINK_RESOURCE_UNIT_ENTRY);
+
+	err = dsa_devlink_resource_register(ds, "VLAN", dev->num_vlans,
+					    B53_DEVLINK_PARMA_ID_VLAN_TABLE,
+					    DEVLINK_RESOURCE_ID_PARENT_TOP,
+					    &size_params);
+	if (err)
+		goto out;
+
+	dsa_devlink_resource_occ_get_register(ds,
+					      B53_DEVLINK_PARMA_ID_VLAN_TABLE,
+					      b53_devlink_vlan_table_get, dev);
+
+	return 0;
+out:
+	dsa_devlink_resources_unregister(ds);
+	return err;
+}
+EXPORT_SYMBOL(b53_setup_devlink_resources);
+
 static int b53_setup(struct dsa_switch *ds)
 {
 	struct b53_device *dev = ds->priv;
@@ -992,8 +1039,10 @@ static int b53_setup(struct dsa_switch *ds)
 	b53_reset_mib(dev);
 
 	ret = b53_apply_config(dev);
-	if (ret)
+	if (ret) {
 		dev_err(ds->dev, "failed to apply configuration\n");
+		return ret;
+	}
 
 	/* Configure IMP/CPU port, disable all other ports. Enabled
 	 * ports will be configured with .port_enable
@@ -1012,7 +1061,12 @@ static int b53_setup(struct dsa_switch *ds)
 	 */
 	ds->vlan_filtering_is_global = true;
 
-	return ret;
+	return b53_setup_devlink_resources(ds);
+}
+
+static void b53_teardown(struct dsa_switch *ds)
+{
+	dsa_devlink_resources_unregister(ds);
 }
 
 static void b53_force_link(struct b53_device *dev, int port, int link)
@@ -2141,6 +2195,7 @@ static int b53_get_max_mtu(struct dsa_switch *ds, int port)
 static const struct dsa_switch_ops b53_switch_ops = {
 	.get_tag_protocol	= b53_get_tag_protocol,
 	.setup			= b53_setup,
+	.teardown		= b53_teardown,
 	.get_strings		= b53_get_strings,
 	.get_ethtool_stats	= b53_get_ethtool_stats,
 	.get_sset_count		= b53_get_sset_count,
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index e942c60e4365..c55c0a9f1b47 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -328,6 +328,7 @@ void b53_br_set_stp_state(struct dsa_switch *ds, int port, u8 state);
 void b53_br_fast_age(struct dsa_switch *ds, int port);
 int b53_br_egress_floods(struct dsa_switch *ds, int port,
 			 bool unicast, bool multicast);
+int b53_setup_devlink_resources(struct dsa_switch *ds);
 void b53_port_event(struct dsa_switch *ds, int port);
 void b53_phylink_validate(struct dsa_switch *ds, int port,
 			  unsigned long *supported,
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 3263e8a0ae67..723820603107 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -936,7 +936,12 @@ static int bcm_sf2_sw_setup(struct dsa_switch *ds)
 	b53_configure_vlan(ds);
 	bcm_sf2_enable_acb(ds);
 
-	return 0;
+	return b53_setup_devlink_resources(ds);
+}
+
+static void bcm_sf2_sw_teardown(struct dsa_switch *ds)
+{
+	dsa_devlink_resources_unregister(ds);
 }
 
 /* The SWITCH_CORE register space is managed by b53 but operates on a page +
@@ -1073,6 +1078,7 @@ static int bcm_sf2_sw_get_sset_count(struct dsa_switch *ds, int port,
 static const struct dsa_switch_ops bcm_sf2_ops = {
 	.get_tag_protocol	= b53_get_tag_protocol,
 	.setup			= bcm_sf2_sw_setup,
+	.teardown		= bcm_sf2_sw_teardown,
 	.get_strings		= bcm_sf2_sw_get_strings,
 	.get_ethtool_stats	= bcm_sf2_sw_get_ethtool_stats,
 	.get_sset_count		= bcm_sf2_sw_get_sset_count,
-- 
2.25.1

