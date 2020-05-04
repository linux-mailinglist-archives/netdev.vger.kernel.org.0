Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC82E1C39B4
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbgEDMoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728878AbgEDMoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:44:21 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 238D5C061A10
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 05:44:19 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u16so8847473wmc.5
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 05:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=zamKz/OEXE5VTT9xTFrE5unYHuyrJjhAH/AzuTBuV2A=;
        b=NSpNmB5iLmMcBmmtS5QEUdaCa/0IchQWYgtwkj453bw/k5DUMz8Gm0bVMLd02B0q4o
         oRiWcvvZxYyrxzkrPD49NYicgbRvBOgGJl9x75EET8J1aki5cZ6+IUqVWYxCsvd6hvDk
         aMcE8uALBin7A6a2qcufvo5PzylueirH2FilFegk8d8dhV/p1KYW8Gcs2ACAJpzwcMBU
         FkuZOcpJ5R2jHlkRD7lZvuD0KrrQyFS6tyxd2gjK2hJuy/44iVLVyed46SynjpFf67sd
         pjHiRJ4dHlhPRW+j7zCBDOdGN3AU5Ba2Crj03Scs2uu73fj81jjBNu2X1FPgDhbBYcqK
         XM3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=zamKz/OEXE5VTT9xTFrE5unYHuyrJjhAH/AzuTBuV2A=;
        b=P81L0h53peWE+d12vxZIFpnauL1SJA2npJhYGOFOPW56+Tf0Dr3CfePm5VuJNWm7Ff
         9SsgN66rTdmFNmjssmt9Ck2hEL810mCYLZMQsY0rexA0O2u6lC8laXOPbjUlLr6b3nyc
         xeYOIjTKKQUgvr/VE4HG+NAeNarqYFoqY+mumXk649hoAW+82xkPA1t1wFyen4Bz809X
         b7PHsIX4VISbOxfxM+ndWm4a9IihDg0noVf9yP4DnoD6+r7WkvD8bLC2aAkXeH6NAXQL
         r+mj3hsF7SWqqCZUTDhoFss0iixZfLwvnHdF2cTzdI+Gdo2OCxGyo4qRTZZ/zlrzKo6O
         J3Wg==
X-Gm-Message-State: AGi0PuZi8rBdx2azShxV558AzcRO0whfFVzRP3uoVzSVgT8+Bt8WTQm4
        iWTVWeqtNwjOT4C43uu1yuQ=
X-Google-Smtp-Source: APiQypIWdj71G4pQOkNoM65wd+BwgY3sj8Jo//4KecdcSHiuCZR+6tKL/XdHgEIUSOpQxQg3KJZ34w==
X-Received: by 2002:a7b:c181:: with SMTP id y1mr15474176wmi.83.1588596257723;
        Mon, 04 May 2020 05:44:17 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 32sm17343670wrg.19.2020.05.04.05.44.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 05:44:17 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        georg.waibel@sensor-technik.de, o.rempel@pengutronix.de,
        christian.herber@nxp.com
Subject: [RFC 2/6] net: dsa: sja1105: make HOSTPRIO a devlink param
Date:   Mon,  4 May 2020 15:43:21 +0300
Message-Id: <20200504124325.26758-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504124325.26758-1-olteanv@gmail.com>
References: <20200504124325.26758-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Unfortunately with this hardware, there is no way to transmit in-band
QoS hints with management frames (i.e. VLAN PCP is ignored). The traffic
class for these is fixed in the static config (which in turn requires a
reset to change).

The switch has 2 MAC filters for link-local management traffic. They are
hardcoded them in the driver to 01-80-C2-xx-xx-xx and 01-1B-19-xx-xx-xx
so that STP and PTP work by default. The switch checks the DMAC of
frames against these masks very early in the packet processing pipeline,
and if they match, they are trapped to the CPU.  In fact, the match is
so early that the analyzer module is bypassed and the frames do not get
classified to a TC based on any QoS classification rules. The hardware
designers recognized that this might be a problem, so they just invented
a knob called HOSTPRIO, which all frames that are trapped to the CPU get
assigned.  On xmit, the MAC filters are active on the CPU port as well.
So the switch wants to trap the link-local frames coming from the CPU
and redirect them to the CPU, which it won't do because it's configured
to avoid hairpinning. So it drops those frames when they come from the
CPU port, due to lack of valid destinations. So the hardware designers
invented another concept called "management routes" which are meant to
bypass the MAC filters (which themselves bypass L2 forwarding). You
pre-program a one-shot "management route" in the switch for a frame
matching a certain DMAC, then you send it, then the switch figures out
it matches this "management route" and properly sends it out the correct
front-panel port. The point is that on xmit, the switch uses HOSTPRIO
for the "management route" frames as well.

With the new ability to add time gates for individual traffic classes,
there is a real danger that the user might unknowingly turn off the
traffic class for PTP, BPDUs, LLDP etc. Also, users might have certain
use cases which require mapping link-local traffic to other TCs than 7.
This will become even more obvious when we add offload for tc-cbs, where
only 2 traffic classes per port support the SR class A and B timing
requirements.

So we need to manage this situation the best we can. There isn't any
knob in Linux for this, so create a driver-specific devlink param which
is a runtime u8. The default value is 7 (the highest priority traffic
class).

Patch is largely inspired by the mv88e6xxx ATU_hash devlink param
implementation.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Please ignore this patch for now, it is not conceptually part of the
series. I included it because it adds devlink plumbing to sja1105, and I
didn't want to rebase the next patches.

 .../networking/devlink-params-sja1105.txt     |  9 ++
 Documentation/networking/dsa/sja1105.rst      | 19 +++-
 MAINTAINERS                                   |  1 +
 drivers/net/dsa/sja1105/sja1105.h             |  1 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 94 +++++++++++++++++++
 5 files changed, 122 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/networking/devlink-params-sja1105.txt

diff --git a/Documentation/networking/devlink-params-sja1105.txt b/Documentation/networking/devlink-params-sja1105.txt
new file mode 100644
index 000000000000..5096a4cf923c
--- /dev/null
+++ b/Documentation/networking/devlink-params-sja1105.txt
@@ -0,0 +1,9 @@
+hostprio		[DEVICE, DRIVER-SPECIFIC]
+			Configure the traffic class which will be used for
+			management (link-local) traffic injected and trapped
+			to/from the CPU. This includes STP, PTP, LLDP etc, as
+			well as hardware-specific meta frames with RX
+			timestamps.  Higher is better as long as you care about
+			your PTP frames.
+			Configuration mode: runtime
+			Type: u8. 0-7 valid.
diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
index 64553d8d91cb..35d0643f1377 100644
--- a/Documentation/networking/dsa/sja1105.rst
+++ b/Documentation/networking/dsa/sja1105.rst
@@ -181,8 +181,23 @@ towards the switch, with the VLAN PCP bits set appropriately.
 Management traffic (having DMAC 01-80-C2-xx-xx-xx or 01-19-1B-xx-xx-xx) is the
 notable exception: the switch always treats it with a fixed priority and
 disregards any VLAN PCP bits even if present. The traffic class for management
-traffic has a value of 7 (highest priority) at the moment, which is not
-configurable in the driver.
+traffic is configurable through a driver-specific devlink param called
+``hostprio``, which by default has a value of 7 (highest priority)::
+
+    devlink dev param show
+    spi/spi0.1:
+      name hostprio type driver-specific
+        values:
+          cmode runtime value 7
+
+    devlink dev param set spi/spi0.1 name hostprio value 5 cmode runtime
+    [  389.903342] sja1105 spi0.1: Reset switch and programmed static config. Reason: Link-local traffic class
+
+    devlink dev param show
+    spi/spi0.1:
+      name hostprio type driver-specific
+        values:
+          cmode runtime value 5
 
 Below is an example of configuring a 500 us cyclic schedule on egress port
 ``swp5``. The traffic class gate for management traffic (7) is open for 100 us,
diff --git a/MAINTAINERS b/MAINTAINERS
index db7a6d462dff..c7c465a12935 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -12137,6 +12137,7 @@ M:	Vladimir Oltean <olteanv@gmail.com>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/net/dsa/sja1105
+F:	Documentation/networking/devlink-params-sja1105.txt
 
 NXP TDA998X DRM DRIVER
 M:	Russell King <linux@armlinux.org.uk>
diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index f925f6a231e2..2a21cab0888c 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -163,6 +163,7 @@ enum sja1105_reset_reason {
 	SJA1105_AGEING_TIME,
 	SJA1105_SCHEDULING,
 	SJA1105_BEST_EFFORT_POLICING,
+	SJA1105_HOSTPRIO,
 };
 
 int sja1105_static_config_reload(struct sja1105_private *priv,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index f75ceabb4bf9..8a444e6949fd 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1591,6 +1591,7 @@ static const char * const sja1105_reset_reasons[] = {
 	[SJA1105_AGEING_TIME] = "Ageing time",
 	[SJA1105_SCHEDULING] = "Time-aware scheduling",
 	[SJA1105_BEST_EFFORT_POLICING] = "Best-effort policing",
+	[SJA1105_HOSTPRIO] = "Link-local traffic class",
 };
 
 /* For situations where we need to change a setting at runtime that is only
@@ -2020,6 +2021,92 @@ static int sja1105_vlan_del(struct dsa_switch *ds, int port,
 	return 0;
 }
 
+static int sja1105_hostprio_get(struct sja1105_private *priv, u8 *hostprio)
+{
+	struct sja1105_general_params_entry *general_params;
+	struct sja1105_table *table;
+
+	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
+	general_params = table->entries;
+	*hostprio = general_params->hostprio;
+
+	return 0;
+}
+
+static int sja1105_hostprio_set(struct sja1105_private *priv, u8 hostprio)
+{
+	struct sja1105_general_params_entry *general_params;
+	struct sja1105_table *table;
+
+	if (hostprio >= SJA1105_NUM_TC)
+		return -ERANGE;
+
+	table = &priv->static_config.tables[BLK_IDX_GENERAL_PARAMS];
+	general_params = table->entries;
+	general_params->hostprio = hostprio;
+
+	return sja1105_static_config_reload(priv, SJA1105_HOSTPRIO);
+}
+
+enum sja1105_devlink_param_id {
+	SJA1105_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
+	SJA1105_DEVLINK_PARAM_ID_HOSTPRIO,
+};
+
+static int sja1105_devlink_param_get(struct dsa_switch *ds, u32 id,
+				     struct devlink_param_gset_ctx *ctx)
+{
+	struct sja1105_private *priv = ds->priv;
+	int err;
+
+	switch (id) {
+	case SJA1105_DEVLINK_PARAM_ID_HOSTPRIO:
+		err = sja1105_hostprio_get(priv, &ctx->val.vu8);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static int sja1105_devlink_param_set(struct dsa_switch *ds, u32 id,
+				     struct devlink_param_gset_ctx *ctx)
+{
+	struct sja1105_private *priv = ds->priv;
+	int err;
+
+	switch (id) {
+	case SJA1105_DEVLINK_PARAM_ID_HOSTPRIO:
+		err = sja1105_hostprio_set(priv, ctx->val.vu8);
+		break;
+	default:
+		err = -EOPNOTSUPP;
+		break;
+	}
+
+	return err;
+}
+
+static const struct devlink_param sja1105_devlink_params[] = {
+	DSA_DEVLINK_PARAM_DRIVER(SJA1105_DEVLINK_PARAM_ID_HOSTPRIO,
+				 "hostprio", DEVLINK_PARAM_TYPE_U8,
+				 BIT(DEVLINK_PARAM_CMODE_RUNTIME)),
+};
+
+static int sja1105_setup_devlink_params(struct dsa_switch *ds)
+{
+	return dsa_devlink_params_register(ds, sja1105_devlink_params,
+					   ARRAY_SIZE(sja1105_devlink_params));
+}
+
+static void sja1105_teardown_devlink_params(struct dsa_switch *ds)
+{
+	dsa_devlink_params_unregister(ds, sja1105_devlink_params,
+				      ARRAY_SIZE(sja1105_devlink_params));
+}
+
 /* The programming model for the SJA1105 switch is "all-at-once" via static
  * configuration tables. Some of these can be dynamically modified at runtime,
  * but not the xMII mode parameters table.
@@ -2085,6 +2172,10 @@ static int sja1105_setup(struct dsa_switch *ds)
 
 	ds->mtu_enforcement_ingress = true;
 
+	rc = sja1105_setup_devlink_params(ds);
+	if (rc < 0)
+		return rc;
+
 	/* The DSA/switchdev model brings up switch ports in standalone mode by
 	 * default, and that means vlan_filtering is 0 since they're not under
 	 * a bridge, so it's safe to set up switch tagging at this time.
@@ -2107,6 +2198,7 @@ static void sja1105_teardown(struct dsa_switch *ds)
 			kthread_destroy_worker(sp->xmit_worker);
 	}
 
+	sja1105_teardown_devlink_params(ds);
 	sja1105_flower_teardown(ds);
 	sja1105_tas_teardown(ds);
 	sja1105_ptp_clock_unregister(ds);
@@ -2445,6 +2537,8 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_policer_del	= sja1105_port_policer_del,
 	.cls_flower_add		= sja1105_cls_flower_add,
 	.cls_flower_del		= sja1105_cls_flower_del,
+	.devlink_param_get	= sja1105_devlink_param_get,
+	.devlink_param_set	= sja1105_devlink_param_set,
 	.crosschip_bridge_join	= sja1105_crosschip_bridge_join,
 	.crosschip_bridge_leave	= sja1105_crosschip_bridge_leave,
 };
-- 
2.17.1

