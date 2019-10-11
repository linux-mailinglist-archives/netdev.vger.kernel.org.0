Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 152DFD4AD8
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 01:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727507AbfJKXSe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 19:18:34 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38035 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727346AbfJKXSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 19:18:32 -0400
Received: by mail-wm1-f68.google.com with SMTP id 3so11597040wmi.3
        for <netdev@vger.kernel.org>; Fri, 11 Oct 2019 16:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qEj/6JZWa3MClRaNNuADSsrLnMiUF5LkzQX5fX/4/EQ=;
        b=TJg0lSRAXezwmrK9qMAks2epDZMqQSINtUHv+dB2b6oezMj/kP/6ef1irXNqJlZhDn
         HioiPXCTV9wPK0MQfaunsoTM3PG8I0s5dMKbepV9MOJtJm/YOzDOPpECxn74p+X5a3Om
         Uu1/tLdujH3E4HS9CuBuUnRk4dTa83Jm36SF1PPodjCq3uGSYUqa28WhDE7lgMIOlLZL
         3hvr6fkYNNrFG/uZIviSLluw5MfGgigbIR9SQOm0xgKYn4vMvUVYvjTPeSrW98vACM5b
         OBAu0tJAElJXmIy/e+BFkxt3S2r5lEqvSaEa/DguQ7686FFzD/mk23NETJ8xoF7qtZEb
         5rqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qEj/6JZWa3MClRaNNuADSsrLnMiUF5LkzQX5fX/4/EQ=;
        b=Cgi4c62CZFpYXdB6UfbfkVUiBzMO5BLBEyjg6N3hA8zhxY1AjgAEpgnx4FehtD2tX4
         QvYIweWIMOqoQTl2ZAJ2RU4VLYoiTlNo+vPnk6YcMI/cYYl2MWAA0HVkmAG5hu3R9nog
         L2J3hhTLJTMdIsB5eZ/xoTRSG4QsYeGmTihtxGlXt3iv7JaUmZq5hKYVlPhquIAauxVg
         gvARZBNqFKKl1OXB8JH3+rnr7k61aWpePoBkeRHQmR1nT7i5HFIVG6fIP6QWtJsgRzzO
         6CefcQVowXCLyMLOoynXAkl/tfc5msXe4HCFBWBK+TIXUR/AVgZcdlgFb5jpSSYQCIl/
         P4Tw==
X-Gm-Message-State: APjAAAWZSREBhqg0vRoNTB0Vcq9HZS0c86DTb9vlt8WNEOlq8zIvPd0Y
        ZLLhJhs/M1kfetEqpdmGPTs=
X-Google-Smtp-Source: APXvYqxGqrBjvbQNlXDcmWHqR9Uo3HWIRXCHOkz1nm92VWLtMfyz8152NAJ5b0B6UQNqd6VtWpp10w==
X-Received: by 2002:a1c:e08a:: with SMTP id x132mr4899560wmg.155.1570835909034;
        Fri, 11 Oct 2019 16:18:29 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id 207sm17425853wme.17.2019.10.11.16.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Oct 2019 16:18:28 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     richardcochran@gmail.com, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, jakub.kicinski@netronome.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 4/4] net: dsa: sja1105: Change the PTP command access pattern
Date:   Sat, 12 Oct 2019 02:18:16 +0300
Message-Id: <20191011231816.7888-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191011231816.7888-1-olteanv@gmail.com>
References: <20191011231816.7888-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PTP command register contains enable bits for:
- Putting the 64-bit PTPCLKVAL register in add/subtract or write mode
- Taking timestamps off of the corrected vs free-running clock
- Starting/stopping the TTEthernet scheduling
- Starting/stopping PPS output
- Resetting the switch

When a command needs to be issued (e.g. "change the PTPCLKVAL from write
mode to add/subtract mode"), one cannot simply write to the command
register setting the PTPCLKADD bit to 1, because that would zeroize the
other settings. One also cannot do a read-modify-write (that would be
too easy for this hardware) because not all bits of the command register
are readable over SPI.

So this leaves us with the only option of keeping the value of the PTP
command register in the driver, and operating on that.

Actually there are 2 types of PTP operations now:
- Operations that modify the cached PTP command. These operate on
  ptp_data->cmd as a pointer.
- Operations that apply all previously cached PTP settings, but don't
  otherwise cache what they did themselves. The sja1105_ptp_reset
  function is such an example. It copies the ptp_data->cmd on stack
  before modifying and writing it to SPI.

This practically means that struct sja1105_ptp_cmd is no longer an
implementation detail, since it needs to be stored in full into struct
sja1105_ptp_data, and hence in struct sja1105_private. So the (*ptp_cmd)
function prototype can change and take struct sja1105_ptp_cmd as second
argument now.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h     |  3 ++-
 drivers/net/dsa/sja1105/sja1105_ptp.c | 14 +++++---------
 drivers/net/dsa/sja1105/sja1105_ptp.h | 13 +++++++++++--
 3 files changed, 18 insertions(+), 12 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index cb619225cd46..0ef97a916707 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -72,7 +72,8 @@ struct sja1105_info {
 	const struct sja1105_dynamic_table_ops *dyn_ops;
 	const struct sja1105_table_ops *static_ops;
 	const struct sja1105_regs *regs;
-	int (*ptp_cmd)(const struct dsa_switch *ds, const void *data);
+	int (*ptp_cmd)(const struct dsa_switch *ds,
+		       const struct sja1105_ptp_cmd *cmd);
 	int (*reset_cmd)(const void *ctx, const void *data);
 	int (*setup_rgmii_delay)(const void *ctx, int port);
 	/* Prototypes from include/net/dsa.h */
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 625411f59627..b43096063cf4 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -59,10 +59,6 @@
 #define ptp_data_to_sja1105(d) \
 		container_of((d), struct sja1105_private, ptp_data)
 
-struct sja1105_ptp_cmd {
-	u64 resptp;       /* reset */
-};
-
 static int sja1105_init_avb_params(struct sja1105_private *priv,
 				   bool on)
 {
@@ -212,10 +208,10 @@ int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-int sja1105et_ptp_cmd(const struct dsa_switch *ds, const void *data)
+int sja1105et_ptp_cmd(const struct dsa_switch *ds,
+		      const struct sja1105_ptp_cmd *cmd)
 {
 	const struct sja1105_private *priv = ds->priv;
-	const struct sja1105_ptp_cmd *cmd = data;
 	const struct sja1105_regs *regs = priv->info->regs;
 	const int size = SJA1105_SIZE_PTP_CMD;
 	u8 buf[SJA1105_SIZE_PTP_CMD] = {0};
@@ -229,10 +225,10 @@ int sja1105et_ptp_cmd(const struct dsa_switch *ds, const void *data)
 				SJA1105_SIZE_PTP_CMD);
 }
 
-int sja1105pqrs_ptp_cmd(const struct dsa_switch *ds, const void *data)
+int sja1105pqrs_ptp_cmd(const struct dsa_switch *ds,
+			const struct sja1105_ptp_cmd *cmd)
 {
 	const struct sja1105_private *priv = ds->priv;
-	const struct sja1105_ptp_cmd *cmd = data;
 	const struct sja1105_regs *regs = priv->info->regs;
 	const int size = SJA1105_SIZE_PTP_CMD;
 	u8 buf[SJA1105_SIZE_PTP_CMD] = {0};
@@ -422,7 +418,7 @@ int sja1105_ptp_reset(struct dsa_switch *ds)
 {
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
-	struct sja1105_ptp_cmd cmd = {0};
+	struct sja1105_ptp_cmd cmd = ptp_data->cmd;
 	int rc;
 
 	mutex_lock(&ptp_data->lock);
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 0b6b0e262a02..507107ffd6a3 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -6,9 +6,14 @@
 
 #if IS_ENABLED(CONFIG_NET_DSA_SJA1105_PTP)
 
+struct sja1105_ptp_cmd {
+	u64 resptp;		/* reset */
+};
+
 struct sja1105_ptp_data {
 	struct ptp_clock_info caps;
 	struct ptp_clock *clock;
+	struct sja1105_ptp_cmd cmd;
 	/* The cycle counter translates the PTP timestamps (based on
 	 * a free-running counter) into a software time domain.
 	 */
@@ -23,9 +28,11 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds);
 
 void sja1105_ptp_clock_unregister(struct dsa_switch *ds);
 
-int sja1105et_ptp_cmd(const struct dsa_switch *ds, const void *data);
+int sja1105et_ptp_cmd(const struct dsa_switch *ds,
+		      const struct sja1105_ptp_cmd *cmd);
 
-int sja1105pqrs_ptp_cmd(const struct dsa_switch *ds, const void *data);
+int sja1105pqrs_ptp_cmd(const struct dsa_switch *ds,
+			const struct sja1105_ptp_cmd *cmd);
 
 int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 			struct ethtool_ts_info *ts);
@@ -47,6 +54,8 @@ int sja1105_hwtstamp_set(struct dsa_switch *ds, int port, struct ifreq *ifr);
 
 #else
 
+struct sja1105_ptp_cmd;
+
 /* Structures cannot be empty in C. Bah!
  * Keep the mutex as the only element, which is a bit more difficult to
  * refactor out of sja1105_main.c anyway.
-- 
2.17.1

