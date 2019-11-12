Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60331F84F0
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 01:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbfKLAME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 19:12:04 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:38099 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfKLAMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 19:12:03 -0500
Received: by mail-wm1-f66.google.com with SMTP id z19so1088001wmk.3
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 16:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0ja3O57SzmPj2PtSnHgDR5bpzdvMAId6ijEG8Ic9GNs=;
        b=HQpycBguv0Vb8XoM3ipWNFAxOgFpxDUVQhorDHdYcK4kEb2liAp/NGd5PUGU3A66Vd
         jFqEEGzrOmLYLzuJzBQ8HGZD5sDAFol+iPeM3xpP0XesJJoguk0DDCYZ2a0x+qBMXuXE
         L0hjQrjmlQVRFv7sercss6yP2IXJHejqAcb3M7p+MpXxg47eKTKy1mgHdDO/8348fyUm
         36YmWe5dDoXEjM4zKMMEdrNI+Z9nSeyEs078r/5BQPeyHLMGgrID5ln+Gp3TyWCYft1q
         qvObOdBBVrM9YiaSH8xUUNCCouSED0ILvJdi/xZiC68VDGe5aXmpFSyWUOH32oIgeR4/
         8kqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0ja3O57SzmPj2PtSnHgDR5bpzdvMAId6ijEG8Ic9GNs=;
        b=brBeb+wCkNbA5qX7l5BmAV4Ya+/W2CVBupc++L9OUekPW58VCJqpGuDoxbDY0HNEKx
         +6GGud345rSqervNYELUn0xIKbPjFlMFmZQnpGuvk/s3oY7IzTDEbBfxSOzjITVPGmfo
         zsAka6hZ2cZT4Mt9e+UNUdLt7ZSwoD7uVDuBscv1j3ILPSYCcZ6lUmkRWf8UhF1wCx2r
         o3atASaHhpvB1+jhtD0d7ztp9DsX6pCAC6xB2z2DbY01r7b4VqpUmbyQy27QUsLGldfF
         aHSK41goh4rIYxeciZOfciZ8K9a4LV0a6zzy2drRpEfp9NrEBcexrN9U7HFH8fT/Z1nf
         kVXQ==
X-Gm-Message-State: APjAAAUjmMvt6Xy1VPx8A/jyDyOVzqWhGLXjFxvxM1bSRtJjGK9a8OfK
        yRcsH5wKEaVACOfXVPklkrg=
X-Google-Smtp-Source: APXvYqwQhsW2N96HaINN3UcycqHv/UwNm4m4BIKteHfG/rhlSm3OtXJSmliyqrrVk/Q/F/EB3TDFfw==
X-Received: by 2002:a7b:c08f:: with SMTP id r15mr1269790wmh.45.1573517521296;
        Mon, 11 Nov 2019 16:12:01 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id m25sm808687wmi.46.2019.11.11.16.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 16:12:00 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     vinicius.gomes@intel.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/2] net: dsa: sja1105: Make the PTP command read-write
Date:   Tue, 12 Nov 2019 02:11:53 +0200
Message-Id: <20191112001154.26650-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191112001154.26650-1-olteanv@gmail.com>
References: <20191112001154.26650-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PTPSTRTSCH and PTPSTOPSCH bits are actually readable and indicate
whether the time-aware scheduler is running or not. We will be using
that for monitoring the scheduler in the next patch, so refactor the PTP
command API in order to allow that.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105.h     | 14 +++----
 drivers/net/dsa/sja1105/sja1105_ptp.c | 59 +++++++++++++++------------
 drivers/net/dsa/sja1105/sja1105_ptp.h | 12 +++---
 drivers/net/dsa/sja1105/sja1105_spi.c | 12 +++---
 4 files changed, 53 insertions(+), 44 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 1a3722971b61..38340b74249e 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -20,6 +20,11 @@
  */
 #define SJA1105_AGEING_TIME_MS(ms)	((ms) / 10)
 
+typedef enum {
+	SPI_READ = 0,
+	SPI_WRITE = 1,
+} sja1105_spi_rw_mode_t;
+
 #include "sja1105_tas.h"
 #include "sja1105_ptp.h"
 
@@ -71,8 +76,6 @@ struct sja1105_info {
 	const struct sja1105_dynamic_table_ops *dyn_ops;
 	const struct sja1105_table_ops *static_ops;
 	const struct sja1105_regs *regs;
-	int (*ptp_cmd)(const struct dsa_switch *ds,
-		       const struct sja1105_ptp_cmd *cmd);
 	int (*reset_cmd)(const void *ctx, const void *data);
 	int (*setup_rgmii_delay)(const void *ctx, int port);
 	/* Prototypes from include/net/dsa.h */
@@ -80,6 +83,8 @@ struct sja1105_info {
 			   const unsigned char *addr, u16 vid);
 	int (*fdb_del_cmd)(struct dsa_switch *ds, int port,
 			   const unsigned char *addr, u16 vid);
+	void (*ptp_cmd_packing)(u8 *buf, struct sja1105_ptp_cmd *cmd,
+				enum packing_op op);
 	const char *name;
 };
 
@@ -109,11 +114,6 @@ struct sja1105_spi_message {
 	u64 address;
 };
 
-typedef enum {
-	SPI_READ = 0,
-	SPI_WRITE = 1,
-} sja1105_spi_rw_mode_t;
-
 /* From sja1105_main.c */
 enum sja1105_reset_reason {
 	SJA1105_VLAN_FILTERING = 0,
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index 6b9b2bef8a7b..00014e836d3f 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -193,42 +193,50 @@ int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-int sja1105et_ptp_cmd(const struct dsa_switch *ds,
-		      const struct sja1105_ptp_cmd *cmd)
+void sja1105et_ptp_cmd_packing(u8 *buf, struct sja1105_ptp_cmd *cmd,
+			       enum packing_op op)
 {
-	const struct sja1105_private *priv = ds->priv;
-	const struct sja1105_regs *regs = priv->info->regs;
 	const int size = SJA1105_SIZE_PTP_CMD;
-	u8 buf[SJA1105_SIZE_PTP_CMD] = {0};
 	/* No need to keep this as part of the structure */
 	u64 valid = 1;
 
-	sja1105_pack(buf, &valid,           31, 31, size);
-	sja1105_pack(buf, &cmd->resptp,      2,  2, size);
-	sja1105_pack(buf, &cmd->corrclk4ts,  1,  1, size);
-	sja1105_pack(buf, &cmd->ptpclkadd,   0,  0, size);
-
-	return sja1105_xfer_buf(priv, SPI_WRITE, regs->ptp_control, buf,
-				SJA1105_SIZE_PTP_CMD);
+	sja1105_packing(buf, &valid,           31, 31, size, op);
+	sja1105_packing(buf, &cmd->resptp,      2,  2, size, op);
+	sja1105_packing(buf, &cmd->corrclk4ts,  1,  1, size, op);
+	sja1105_packing(buf, &cmd->ptpclkadd,   0,  0, size, op);
 }
 
-int sja1105pqrs_ptp_cmd(const struct dsa_switch *ds,
-			const struct sja1105_ptp_cmd *cmd)
+void sja1105pqrs_ptp_cmd_packing(u8 *buf, struct sja1105_ptp_cmd *cmd,
+				 enum packing_op op)
 {
-	const struct sja1105_private *priv = ds->priv;
-	const struct sja1105_regs *regs = priv->info->regs;
 	const int size = SJA1105_SIZE_PTP_CMD;
-	u8 buf[SJA1105_SIZE_PTP_CMD] = {0};
 	/* No need to keep this as part of the structure */
 	u64 valid = 1;
 
-	sja1105_pack(buf, &valid,           31, 31, size);
-	sja1105_pack(buf, &cmd->resptp,      3,  3, size);
-	sja1105_pack(buf, &cmd->corrclk4ts,  2,  2, size);
-	sja1105_pack(buf, &cmd->ptpclkadd,   0,  0, size);
+	sja1105_packing(buf, &valid,           31, 31, size, op);
+	sja1105_packing(buf, &cmd->resptp,      3,  3, size, op);
+	sja1105_packing(buf, &cmd->corrclk4ts,  2,  2, size, op);
+	sja1105_packing(buf, &cmd->ptpclkadd,   0,  0, size, op);
+}
+
+static int sja1105_ptp_commit(struct sja1105_private *priv,
+			      struct sja1105_ptp_cmd *cmd,
+			      sja1105_spi_rw_mode_t rw)
+{
+	const struct sja1105_regs *regs = priv->info->regs;
+	u8 buf[SJA1105_SIZE_PTP_CMD] = {0};
+	int rc;
+
+	if (rw == SPI_WRITE)
+		priv->info->ptp_cmd_packing(buf, cmd, PACK);
 
-	return sja1105_xfer_buf(priv, SPI_WRITE, regs->ptp_control, buf,
-				SJA1105_SIZE_PTP_CMD);
+	rc = sja1105_xfer_buf(priv, SPI_WRITE, regs->ptp_control, buf,
+			      SJA1105_SIZE_PTP_CMD);
+
+	if (rw == SPI_READ)
+		priv->info->ptp_cmd_packing(buf, cmd, UNPACK);
+
+	return rc;
 }
 
 /* The switch returns partial timestamps (24 bits for SJA1105 E/T, which wrap
@@ -438,8 +446,9 @@ static int sja1105_ptp_reset(struct dsa_switch *ds)
 	mutex_lock(&ptp_data->lock);
 
 	cmd.resptp = 1;
+
 	dev_dbg(ds->dev, "Resetting PTP clock\n");
-	rc = priv->info->ptp_cmd(ds, &cmd);
+	rc = sja1105_ptp_commit(priv, &cmd, SPI_WRITE);
 
 	mutex_unlock(&ptp_data->lock);
 
@@ -495,7 +504,7 @@ static int sja1105_ptp_mode_set(struct sja1105_private *priv,
 
 	ptp_data->cmd.ptpclkadd = mode;
 
-	return priv->info->ptp_cmd(priv->ds, &ptp_data->cmd);
+	return sja1105_ptp_commit(priv, &ptp_data->cmd, SPI_WRITE);
 }
 
 /* Write to PTPCLKVAL while PTPCLKADD is 0 */
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index 19e707db7e8c..83d9d4ae6d3a 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -39,11 +39,11 @@ int sja1105_ptp_clock_register(struct dsa_switch *ds);
 
 void sja1105_ptp_clock_unregister(struct dsa_switch *ds);
 
-int sja1105et_ptp_cmd(const struct dsa_switch *ds,
-		      const struct sja1105_ptp_cmd *cmd);
+void sja1105et_ptp_cmd_packing(u8 *buf, struct sja1105_ptp_cmd *cmd,
+			       enum packing_op op);
 
-int sja1105pqrs_ptp_cmd(const struct dsa_switch *ds,
-			const struct sja1105_ptp_cmd *cmd);
+void sja1105pqrs_ptp_cmd_packing(u8 *buf, struct sja1105_ptp_cmd *cmd,
+				 enum packing_op op);
 
 int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 			struct ethtool_ts_info *ts);
@@ -110,9 +110,9 @@ static inline int __sja1105_ptp_adjtime(struct dsa_switch *ds, s64 delta)
 	return 0;
 }
 
-#define sja1105et_ptp_cmd NULL
+#define sja1105et_ptp_cmd_packing NULL
 
-#define sja1105pqrs_ptp_cmd NULL
+#define sja1105pqrs_ptp_cmd_packing NULL
 
 #define sja1105_get_ts_info NULL
 
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index cb48e77f63fd..ba245bd98124 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -584,7 +584,7 @@ struct sja1105_info sja1105e_info = {
 	.reset_cmd		= sja1105et_reset_cmd,
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
-	.ptp_cmd		= sja1105et_ptp_cmd,
+	.ptp_cmd_packing	= sja1105et_ptp_cmd_packing,
 	.regs			= &sja1105et_regs,
 	.name			= "SJA1105E",
 };
@@ -598,7 +598,7 @@ struct sja1105_info sja1105t_info = {
 	.reset_cmd		= sja1105et_reset_cmd,
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
-	.ptp_cmd		= sja1105et_ptp_cmd,
+	.ptp_cmd_packing	= sja1105et_ptp_cmd_packing,
 	.regs			= &sja1105et_regs,
 	.name			= "SJA1105T",
 };
@@ -613,7 +613,7 @@ struct sja1105_info sja1105p_info = {
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
-	.ptp_cmd		= sja1105pqrs_ptp_cmd,
+	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.regs			= &sja1105pqrs_regs,
 	.name			= "SJA1105P",
 };
@@ -628,7 +628,7 @@ struct sja1105_info sja1105q_info = {
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
-	.ptp_cmd		= sja1105pqrs_ptp_cmd,
+	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.regs			= &sja1105pqrs_regs,
 	.name			= "SJA1105Q",
 };
@@ -643,7 +643,7 @@ struct sja1105_info sja1105r_info = {
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
-	.ptp_cmd		= sja1105pqrs_ptp_cmd,
+	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.regs			= &sja1105pqrs_regs,
 	.name			= "SJA1105R",
 };
@@ -659,6 +659,6 @@ struct sja1105_info sja1105s_info = {
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
-	.ptp_cmd		= sja1105pqrs_ptp_cmd,
+	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.name			= "SJA1105S",
 };
-- 
2.17.1

