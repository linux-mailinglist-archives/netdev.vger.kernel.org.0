Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6BBFF453
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 18:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727868AbfKPRXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 12:23:41 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43824 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727752AbfKPRXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 12:23:40 -0500
Received: by mail-wr1-f65.google.com with SMTP id n1so14504953wra.10
        for <netdev@vger.kernel.org>; Sat, 16 Nov 2019 09:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=HmQ6DL8ZM8zX8lM48y7cWgz/4ccKkjfrqpnWcNGD3V8=;
        b=nf8+/5sfxCsl911vfEE/RIu7hlZrI+z2zV4sV18RtKLwzTobes5LDc9ZlMB7/WqO+R
         SbLdZjCl8fDNnU+EACotyi9es7h2Ai/wVPVJw2JjA8pBZU5v9v1ixE9JSnLW7NEfJ9Ek
         sHVTqstQnxvkkAQ3uDI9arRa1PmFgwQTMUoVAELV+enoDF4//9c/iZm5v57UgIqcARbp
         XCJT3ZIzgYICSBh6NV9sSOYr/bp2b9q8ZoLCfOlasMzH69R7DA6dtANyf+LQz1CFzjen
         nFObkRdgOrh9K6svRirn6exgUxlUdMmyhSAD9VVcyVUD0iPB8bJazbPjvwl8G7LlyUxq
         xemA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=HmQ6DL8ZM8zX8lM48y7cWgz/4ccKkjfrqpnWcNGD3V8=;
        b=ND5FPPCE3Lh0dQ6uf0v5IuFqjkRXEajZ40qZzhhpGrZ9zyJAMpKoiMka/4FsDthCha
         RdhYMdD2Y3lde36wZPXPxOWjUH07xQnyCk5hOnEDHOEgjUAeefmkEbmpFcp+9xX0Mngb
         pC45KyzpSsfxbumxLD8DMF0meCKoU9TPImeMV5KnK/Upjh+8fj/iUiVqEM6y8zTsgmAC
         1bTnJYaO3QUXh9cNNB1nwhHWeOqFQwEnAkjbs0DvK5zNTxR0NnODvqcWz71zgCaGw60C
         Bmhpb1WJxXGZqYokUMkEj10WiFGNIRD+wgUCNvNvZ1G/u58QylxLHUDT9p1Vmifh8EGM
         G1bg==
X-Gm-Message-State: APjAAAXMo5v2F0AbNmcCF3SvuCVB/vvvql+Y8FqwzjY7Mbd/EKOjN6eT
        GMN+TCkMRehEpEkoH1cWEgo=
X-Google-Smtp-Source: APXvYqyXQ3jvI6qxR2TAUoFYTSiaHDLX68fybPLxgGyE9ZxFxvSCCP7O4gFHK7rVkH3MCv7b9dMQ/g==
X-Received: by 2002:a5d:6b4d:: with SMTP id x13mr20485711wrw.96.1573925016364;
        Sat, 16 Nov 2019 09:23:36 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id u26sm14405797wmj.9.2019.11.16.09.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Nov 2019 09:23:35 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jiri@mellanox.com,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next] net: dsa: sja1105: Make HOSTPRIO a devlink param
Date:   Sat, 16 Nov 2019 19:23:25 +0200
Message-Id: <20191116172325.13310-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unfortunately with this hardware, there is no way to transmit in-band
QoS hints with management frames (i.e. VLAN PCP is ignored). The traffic
class for these is fixed in the static config (which in turn requires a
reset to change).

With the new ability to add time gates for individual traffic classes,
there is a real danger that the user might unknowingly turn off the
traffic class for PTP, BPDUs, LLDP etc.

So we need to manage this situation the best we can. There isn't any
knob in Linux for this, so create a driver-specific devlink param which
is a runtime u8. The default value is 7 (the highest priority traffic
class).

Patch is largely inspired by the mv88e6xxx ATU_hash devlink param
implementation.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
Turned the NET_DSA_SJA1105_HOSTPRIO kernel config into a "hostprio"
runtime devlink param.

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
index eef20d0bcf7c..21a288aa7692 100644
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
index 39681b34f8e3..cf2aac5a613c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11688,6 +11688,7 @@ M:	Vladimir Oltean <olteanv@gmail.com>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	drivers/net/dsa/sja1105
+F:	Documentation/networking/devlink-params-sja1105.txt
 
 NXP TDA998X DRM DRIVER
 M:	Russell King <linux@armlinux.org.uk>
diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index d801fc204d19..4db0060bc1eb 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -122,6 +122,7 @@ enum sja1105_reset_reason {
 	SJA1105_RX_HWTSTAMPING,
 	SJA1105_AGEING_TIME,
 	SJA1105_SCHEDULING,
+	SJA1105_HOSTPRIO,
 };
 
 int sja1105_static_config_reload(struct sja1105_private *priv,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index b60224c55244..c5e162605db7 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1346,6 +1346,7 @@ static const char * const sja1105_reset_reasons[] = {
 	[SJA1105_RX_HWTSTAMPING] = "RX timestamping",
 	[SJA1105_AGEING_TIME] = "Ageing time",
 	[SJA1105_SCHEDULING] = "Time-aware scheduling",
+	[SJA1105_HOSTPRIO] = "Link-local traffic class",
 };
 
 /* For situations where we need to change a setting at runtime that is only
@@ -1667,6 +1668,92 @@ static int sja1105_vlan_del(struct dsa_switch *ds, int port,
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
@@ -1730,6 +1817,10 @@ static int sja1105_setup(struct dsa_switch *ds)
 	/* Advertise the 8 egress queues */
 	ds->num_tx_queues = SJA1105_NUM_TC;
 
+	rc = sja1105_setup_devlink_params(ds);
+	if (rc < 0)
+		return rc;
+
 	/* The DSA/switchdev model brings up switch ports in standalone mode by
 	 * default, and that means vlan_filtering is 0 since they're not under
 	 * a bridge, so it's safe to set up switch tagging at this time.
@@ -1741,6 +1832,7 @@ static void sja1105_teardown(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
 
+	sja1105_teardown_devlink_params(ds);
 	sja1105_tas_teardown(ds);
 	sja1105_ptp_clock_unregister(ds);
 	sja1105_static_config_free(&priv->static_config);
@@ -2011,6 +2103,8 @@ static const struct dsa_switch_ops sja1105_switch_ops = {
 	.port_setup_tc		= sja1105_port_setup_tc,
 	.port_mirror_add	= sja1105_mirror_add,
 	.port_mirror_del	= sja1105_mirror_del,
+	.devlink_param_get	= sja1105_devlink_param_get,
+	.devlink_param_set	= sja1105_devlink_param_set,
 };
 
 static int sja1105_check_device_id(struct sja1105_private *priv)
-- 
2.17.1

