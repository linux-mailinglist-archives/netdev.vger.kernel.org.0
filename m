Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBBD3F9BFF
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 22:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbfKLVWJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 16:22:09 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35265 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbfKLVWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 16:22:09 -0500
Received: by mail-wr1-f66.google.com with SMTP id s5so9071534wrw.2
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 13:22:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AfvTzi6YifDxrT24vq0fRNLq/D4pzOsX1bfKzbB4/JM=;
        b=IUxs2Oc1W5kVxJinxRpDDDsHIRW8MPRGJtP2vehBwcBs9AN7g8DeI4mpHQQSOALKGY
         yZ79CVasacMo28CrYUXocF1KZ7jIy/e1yqDBMVnpzn1EW2LsNE2nzSR8SffYyMbhDgXC
         zipIlfZfgh3ogLTahAu/MRe9zGFGhd2GftjaRKHay8oNfMe99MuB4NeAsgNBvYn1+jub
         Zw3iZUXH/3RwodKRBp5/OGqoKGMfIDkTbq5Tc2IuM8jBbQWeQkFI13TKy9Rv5OGaEkBR
         zgRUYHKKftr/MYbsRsy/PiEUKtSRUYPLSwJo5Mbc4TOG7QHoSbz6ECxVhYkGAVJBs9Mb
         j8FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AfvTzi6YifDxrT24vq0fRNLq/D4pzOsX1bfKzbB4/JM=;
        b=k6Sud1yXRXsY/RRJlaKg+jq3KyKPz3Qe/cfLstQnTWQ+qGYvFKrLR9O90SymDpcQ0a
         vKhdu4b/orEeJt/5kRj8b4+awvMIxXnMspvovb+JMx/mxTXqWcyO5ME7Jd+3vpa5H0oQ
         orKbCprOWJQLCCoOcXf6y0SSF1AR5tpoFnA5EduGsr3UiWFseOeu2/Vdtmq06HlJR8bQ
         KTtHBfRSQ5AD1zFjFeXc09eZ1DD5gRFnSNAYc1Tw1tXOWCYhMhu84S3xLVi/VZE3Snql
         AVRQvE4za5DaJOvaZfCnOevlksc37Msokg7VLKnAXpd7FRNa162oUmhaDiYFeNBZIhaN
         IMNQ==
X-Gm-Message-State: APjAAAXnmYEtq8LK9739xThDSEesjJG5/tQGbjuBEYHZh2DZdZtNBLkE
        nqi2znxeH/B5HvboKnwdv88=
X-Google-Smtp-Source: APXvYqxIKiAoUOOKHDVqBzWMJC3X17OOqRR/xX3hMrY/thWSi5tXnfRNZYxETxTlkmcEIoL2oVphUg==
X-Received: by 2002:adf:f4c9:: with SMTP id h9mr26618524wrp.354.1573593726650;
        Tue, 12 Nov 2019 13:22:06 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id w7sm118450wru.62.2019.11.12.13.22.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 13:22:06 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next] net: dsa: sja1105: Print the reset reason
Date:   Tue, 12 Nov 2019 23:22:00 +0200
Message-Id: <20191112212200.5572-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes it can be quite opaque even for me why the driver decided to
reset the switch. So instead of adding dump_stack() calls each time for
debugging, just add a reset reason to sja1105_static_config_reload
calls which gets printed to the console.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h      | 10 +++++++++-
 drivers/net/dsa/sja1105/sja1105_main.c | 18 +++++++++++++++---
 drivers/net/dsa/sja1105/sja1105_ptp.c  |  2 +-
 drivers/net/dsa/sja1105/sja1105_tas.c  |  4 ++--
 4 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 64b3ee7b9771..1a3722971b61 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -115,7 +115,15 @@ typedef enum {
 } sja1105_spi_rw_mode_t;
 
 /* From sja1105_main.c */
-int sja1105_static_config_reload(struct sja1105_private *priv);
+enum sja1105_reset_reason {
+	SJA1105_VLAN_FILTERING = 0,
+	SJA1105_RX_HWTSTAMPING,
+	SJA1105_AGEING_TIME,
+	SJA1105_SCHEDULING,
+};
+
+int sja1105_static_config_reload(struct sja1105_private *priv,
+				 enum sja1105_reset_reason reason);
 
 /* From sja1105_spi.c */
 int sja1105_xfer_buf(const struct sja1105_private *priv,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 475cc2d8b0e8..b60224c55244 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1341,13 +1341,21 @@ static void sja1105_bridge_leave(struct dsa_switch *ds, int port,
 	sja1105_bridge_member(ds, port, br, false);
 }
 
+static const char * const sja1105_reset_reasons[] = {
+	[SJA1105_VLAN_FILTERING] = "VLAN filtering",
+	[SJA1105_RX_HWTSTAMPING] = "RX timestamping",
+	[SJA1105_AGEING_TIME] = "Ageing time",
+	[SJA1105_SCHEDULING] = "Time-aware scheduling",
+};
+
 /* For situations where we need to change a setting at runtime that is only
  * available through the static configuration, resetting the switch in order
  * to upload the new static config is unavoidable. Back up the settings we
  * modify at runtime (currently only MAC) and restore them after uploading,
  * such that this operation is relatively seamless.
  */
-int sja1105_static_config_reload(struct sja1105_private *priv)
+int sja1105_static_config_reload(struct sja1105_private *priv,
+				 enum sja1105_reset_reason reason)
 {
 	struct ptp_system_timestamp ptp_sts_before;
 	struct ptp_system_timestamp ptp_sts_after;
@@ -1405,6 +1413,10 @@ int sja1105_static_config_reload(struct sja1105_private *priv)
 out_unlock_ptp:
 	mutex_unlock(&priv->ptp_data.lock);
 
+	dev_info(priv->ds->dev,
+		 "Reset switch and programmed static config. Reason: %s\n",
+		 sja1105_reset_reasons[reason]);
+
 	/* Configure the CGU (PLLs) for MII and RMII PHYs.
 	 * For these interfaces there is no dynamic configuration
 	 * needed, since PLLs have same settings at all speeds.
@@ -1599,7 +1611,7 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	l2_lookup_params = table->entries;
 	l2_lookup_params->shared_learn = !enabled;
 
-	rc = sja1105_static_config_reload(priv);
+	rc = sja1105_static_config_reload(priv, SJA1105_VLAN_FILTERING);
 	if (rc)
 		dev_err(ds->dev, "Failed to change VLAN Ethertype\n");
 
@@ -1871,7 +1883,7 @@ static int sja1105_set_ageing_time(struct dsa_switch *ds,
 
 	l2_lookup_params->maxage = maxage;
 
-	return sja1105_static_config_reload(priv);
+	return sja1105_static_config_reload(priv, SJA1105_AGEING_TIME);
 }
 
 static int sja1105_port_setup_tc(struct dsa_switch *ds, int port,
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 0a35813f9328..6b9b2bef8a7b 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -102,7 +102,7 @@ static int sja1105_change_rxtstamping(struct sja1105_private *priv,
 		priv->tagger_data.stampable_skb = NULL;
 	}
 
-	return sja1105_static_config_reload(priv);
+	return sja1105_static_config_reload(priv, SJA1105_RX_HWTSTAMPING);
 }
 
 int sja1105_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr)
diff --git a/drivers/net/dsa/sja1105/sja1105_tas.c b/drivers/net/dsa/sja1105/sja1105_tas.c
index 33eca6a82ec5..d846fb5c4e4d 100644
--- a/drivers/net/dsa/sja1105/sja1105_tas.c
+++ b/drivers/net/dsa/sja1105/sja1105_tas.c
@@ -352,7 +352,7 @@ int sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
 		if (rc < 0)
 			return rc;
 
-		return sja1105_static_config_reload(priv);
+		return sja1105_static_config_reload(priv, SJA1105_SCHEDULING);
 	}
 
 	/* The cycle time extension is the amount of time the last cycle from
@@ -400,7 +400,7 @@ int sja1105_setup_tc_taprio(struct dsa_switch *ds, int port,
 	if (rc < 0)
 		return rc;
 
-	return sja1105_static_config_reload(priv);
+	return sja1105_static_config_reload(priv, SJA1105_SCHEDULING);
 }
 
 void sja1105_tas_setup(struct dsa_switch *ds)
-- 
2.17.1

