Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01DC52634F1
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 19:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbgIIRto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 13:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgIIRtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 13:49:39 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EB8C061757;
        Wed,  9 Sep 2020 10:49:35 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id m5so2595279pgj.9;
        Wed, 09 Sep 2020 10:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vr8be9z5ve289rWYH4FMLgISuz5QCRzwF700gd1BO2s=;
        b=deFW1JQCJtN43zETrg87xyX00GC6XmUZm6gHSR8oVtoMk0dRAZk+bp/j2/8V/mAC6P
         JqbsxKqi7oWFaQFSiPur2nhwwhCMR9iPj5dPlk3Wo4GC04LXwE/MJMb/XZQzGwhpOhyM
         pO3EBmlURwpsdEtbmE/cem3eycFX9pU+Zhma9JwstuSJRPdBK1uFwy3EZe70qzbKXNxa
         OvzgBYShIB8J0FGsg0sAJvL+yizh/7K5yL6LfZqilLe8wdCle00BWtSL156cATJ15R5N
         XCfpArynh0vhidHx1G/2BqgQ4jKB+bF+BgUB2xtTWtjyf1cEt6ENgmrE5bONWbyolSsi
         zsww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vr8be9z5ve289rWYH4FMLgISuz5QCRzwF700gd1BO2s=;
        b=NYa5fM/ZP1/bkcPNsY0Y0t92Qx5L80yN+GeS/2soZpsZjF25LgzE0WqNRepinEr4QL
         JXlM3SJX2hKAW7ZgjIXnYg0INXtSqVemMZuEMR8mY4MG4YkiShJhVkUKi9AoePtddcqW
         mvyLN91sIxWhO9TEKgm1B9PBDBpiryquGCkEMlPmE9KJorkfmbVS9q4xpfC7wX0QAW0z
         i9Ep0Z8B6+kOE06ekvfQzlDCo9Kln7JCHCodfGo4mUxHHFcfyR+zz7aj8Ldzc3Yr340x
         KHBOD8/pS7iWyhRY9Ma6P4NBpoG+Iv1gUVKvkrmZdZ35Sl7bInbICivFA6hRUS7nQdPU
         hZzA==
X-Gm-Message-State: AOAM532gc89Z9NVn4GAvP/tgnpN8s1wB+0ca5cRHSeoTwSsM0cAvcOPw
        vhTdkqJFaX7tssD9nUnax+Lw+GtVJQo=
X-Google-Smtp-Source: ABdhPJx1xIZJXBh/EmG2Xo+Hxj8YeCTDmSbQ9oSQrzB6M55tmeV4EqlIR/AxDv60o0Z0rV4M2BocSA==
X-Received: by 2002:a17:902:ed13:b029:d0:89f1:9e32 with SMTP id b19-20020a170902ed13b02900d089f19e32mr2040378pld.14.1599673774771;
        Wed, 09 Sep 2020 10:49:34 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a20sm3254825pfa.59.2020.09.09.10.49.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 10:49:34 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     olteanv@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next v2] net: dsa: b53: Report VLAN table occupancy via devlink
Date:   Wed,  9 Sep 2020 10:49:31 -0700
Message-Id: <20200909174932.4138500-1-f.fainelli@gmail.com>
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
Changes in v2:

- make count u64
- correct typo: s/PARMA/PARAM/

 drivers/net/dsa/b53/b53_common.c | 60 ++++++++++++++++++++++++++++++--
 drivers/net/dsa/b53/b53_priv.h   |  1 +
 drivers/net/dsa/bcm_sf2.c        |  8 ++++-
 3 files changed, 66 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 26fcff85d881..6a5796c32721 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -977,6 +977,54 @@ int b53_get_sset_count(struct dsa_switch *ds, int port, int sset)
 }
 EXPORT_SYMBOL(b53_get_sset_count);
 
+enum b53_devlink_resource_id {
+	B53_DEVLINK_PARAM_ID_VLAN_TABLE,
+};
+
+static u64 b53_devlink_vlan_table_get(void *priv)
+{
+	struct b53_device *dev = priv;
+	struct b53_vlan *vl;
+	unsigned int i;
+	u64 count = 0;
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
+					    B53_DEVLINK_PARAM_ID_VLAN_TABLE,
+					    DEVLINK_RESOURCE_ID_PARENT_TOP,
+					    &size_params);
+	if (err)
+		goto out;
+
+	dsa_devlink_resource_occ_get_register(ds,
+					      B53_DEVLINK_PARAM_ID_VLAN_TABLE,
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
@@ -992,8 +1040,10 @@ static int b53_setup(struct dsa_switch *ds)
 	b53_reset_mib(dev);
 
 	ret = b53_apply_config(dev);
-	if (ret)
+	if (ret) {
 		dev_err(ds->dev, "failed to apply configuration\n");
+		return ret;
+	}
 
 	/* Configure IMP/CPU port, disable all other ports. Enabled
 	 * ports will be configured with .port_enable
@@ -1012,7 +1062,12 @@ static int b53_setup(struct dsa_switch *ds)
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
@@ -2141,6 +2196,7 @@ static int b53_get_max_mtu(struct dsa_switch *ds, int port)
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

