Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84F5CA5B5D
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 18:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbfIBQ02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 12:26:28 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39028 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbfIBQ00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 12:26:26 -0400
Received: by mail-wm1-f67.google.com with SMTP id n2so13827755wmk.4
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 09:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P9oG3BHBVE7pWjgJJWCRQ9uRzHRPN4b4W0ZBJrzK8AM=;
        b=jvBLWt7CoxQwA5viX64Vh9HSV8HdRhQKo/XbNF+CZckuK31QrWhnjpQprzB2KhqAdH
         yA0vw8jdWFm4S5TbPrZEC3QNFEt+inV6XOD3YIpF9hWuIjc/tcHVdBpNwub50qVBHFd6
         iyCIWvnszjbHHPvBQ1mlEU6VnG6d+d+5m1Aodo1L0MHk3pTFNXvQuDKm8MxLo0bnzsMc
         TKV1xF5+dFj0pSkNPO0TKObbpzla3xpGCLDsiID5xi4jGw5LecxU7Nfbu9Utc+zM3JaW
         2ZuMBt5s9s1TFmp5D7zMNdTxhTAdiV3DXoFrg7t6NtRzPiA2d24MlxK4q5NCLYQVf63N
         pQrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P9oG3BHBVE7pWjgJJWCRQ9uRzHRPN4b4W0ZBJrzK8AM=;
        b=Jj/fwinGI8pqdvDWvdL8BLO2e5TshYHcvpBaUzc7z4jLv7z0RVdclICWWGnd3aJJBk
         yMqFBwXjuZ6nt1CkDIYTj//mc25Dydfwc77gATFHzWEQVisy3RCBgaO/lt2UMsc0en2g
         Ugxh+yX/cid1oaZGoTnIMWr4nV1B15At+U/MjXmZZMGAM76YB+4Lb/IsadsYZvu0Mzro
         b3FNsQTEDHFQUrnPsIQDgA3R2sM8IEjkhpO7eTmH56+lOI3Z1D2q6WEHNCgBmsGeONBa
         AjM0VTilgLQcvlYIK6Z0fAvLgKBK081oPTU8Rc1fXMW5XasFA9Pv3rdQ/6E7b/1qOXtJ
         YLaw==
X-Gm-Message-State: APjAAAWvzNspBdwWTAggga5ib6F+MDGSUZUy/r+rDBphInfPCCnuzHcX
        0t7WyxMy8OZgCAocq8hw7cQ=
X-Google-Smtp-Source: APXvYqy+xd+g7HsIOlVpEn5c8jMRwfpp6VcGD2hyOjX2xvxFFBfCeZ3xLHbDcOtu8hEpBnL+Hl8hag==
X-Received: by 2002:a7b:c84e:: with SMTP id c14mr36999295wml.46.1567441583453;
        Mon, 02 Sep 2019 09:26:23 -0700 (PDT)
Received: from localhost.localdomain ([86.126.25.232])
        by smtp.gmail.com with ESMTPSA id z187sm2879994wmb.0.2019.09.02.09.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2019 09:26:23 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v1 net-next 14/15] net: dsa: sja1105: Make the PTP command read-write
Date:   Mon,  2 Sep 2019 19:25:43 +0300
Message-Id: <20190902162544.24613-15-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190902162544.24613-1-olteanv@gmail.com>
References: <20190902162544.24613-1-olteanv@gmail.com>
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
Changes since RFC:
- None.

 drivers/net/dsa/sja1105/sja1105.h     | 13 +++---
 drivers/net/dsa/sja1105/sja1105_ptp.c | 64 ++++++++++++++++-----------
 drivers/net/dsa/sja1105/sja1105_ptp.h | 12 +++--
 drivers/net/dsa/sja1105/sja1105_spi.c | 12 ++---
 4 files changed, 58 insertions(+), 43 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index d95f9ce3b4f9..44f7385c51b5 100644
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
 #include "sja1105_ptp.h"
 #include "sja1105_tas.h"
 
@@ -71,7 +76,6 @@ struct sja1105_info {
 	const struct sja1105_dynamic_table_ops *dyn_ops;
 	const struct sja1105_table_ops *static_ops;
 	const struct sja1105_regs *regs;
-	int (*ptp_cmd)(const void *ctx, const void *data);
 	int (*reset_cmd)(const void *ctx, const void *data);
 	int (*setup_rgmii_delay)(const void *ctx, int port);
 	/* Prototypes from include/net/dsa.h */
@@ -79,6 +83,8 @@ struct sja1105_info {
 			   const unsigned char *addr, u16 vid);
 	int (*fdb_del_cmd)(struct dsa_switch *ds, int port,
 			   const unsigned char *addr, u16 vid);
+	void (*ptp_cmd_packing)(u8 *buf, struct sja1105_ptp_cmd *cmd,
+				enum packing_op op);
 	const char *name;
 };
 
@@ -108,11 +114,6 @@ struct sja1105_spi_message {
 	u64 address;
 };
 
-typedef enum {
-	SPI_READ = 0,
-	SPI_WRITE = 1,
-} sja1105_spi_rw_mode_t;
-
 /* From sja1105_main.c */
 int sja1105_static_config_reload(struct sja1105_private *priv);
 
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.c b/drivers/net/dsa/sja1105/sja1105_ptp.c
index f85f44bdab31..ed80278a3521 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.c
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.c
@@ -59,42 +59,50 @@ int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 	return 0;
 }
 
-int sja1105et_ptp_cmd(const void *ctx, const void *data)
+void sja1105et_ptp_cmd_packing(u8 *buf, struct sja1105_ptp_cmd *cmd,
+			       enum packing_op op)
 {
-	const struct sja1105_ptp_cmd *cmd = data;
-	const struct sja1105_private *priv = ctx;
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
-	return sja1105_spi_send_packed_buf(priv, SPI_WRITE, regs->ptp_control,
-					   buf, SJA1105_SIZE_PTP_CMD);
+	sja1105_packing(buf, &valid,           31, 31, size, op);
+	sja1105_packing(buf, &cmd->resptp,      2,  2, size, op);
+	sja1105_packing(buf, &cmd->corrclk4ts,  1,  1, size, op);
+	sja1105_packing(buf, &cmd->ptpclkadd,   0,  0, size, op);
 }
 
-int sja1105pqrs_ptp_cmd(const void *ctx, const void *data)
+void sja1105pqrs_ptp_cmd_packing(u8 *buf, struct sja1105_ptp_cmd *cmd,
+				 enum packing_op op)
 {
-	const struct sja1105_ptp_cmd *cmd = data;
-	const struct sja1105_private *priv = ctx;
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
 
-	return sja1105_spi_send_packed_buf(priv, SPI_WRITE, regs->ptp_control,
-					   buf, SJA1105_SIZE_PTP_CMD);
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
+
+	rc = sja1105_spi_send_packed_buf(priv, rw, regs->ptp_control,
+					 buf, SJA1105_SIZE_PTP_CMD);
+
+	if (rw == SPI_READ)
+		priv->info->ptp_cmd_packing(buf, cmd, UNPACK);
+
+	return rc;
 }
 
 /* The switch returns partial timestamps (24 bits for SJA1105 E/T, which wrap
@@ -212,7 +220,7 @@ int sja1105_ptp_reset(struct sja1105_private *priv)
 	cmd.resptp = 1;
 
 	dev_dbg(priv->ds->dev, "Resetting PTP clock\n");
-	rc = priv->info->ptp_cmd(priv, &cmd);
+	rc = sja1105_ptp_commit(priv, &cmd, SPI_WRITE);
 
 	mutex_unlock(&ptp_data->lock);
 
@@ -250,12 +258,14 @@ static int sja1105_ptp_gettimex(struct ptp_clock_info *ptp,
 static int sja1105_ptp_mode_set(struct sja1105_private *priv,
 				enum sja1105_ptp_clk_mode mode)
 {
-	if (priv->ptp_data.cmd.ptpclkadd == mode)
+	struct sja1105_ptp_data *ptp_data = &priv->ptp_data;
+
+	if (ptp_data->cmd.ptpclkadd == mode)
 		return 0;
 
-	priv->ptp_data.cmd.ptpclkadd = mode;
+	ptp_data->cmd.ptpclkadd = mode;
 
-	return priv->info->ptp_cmd(priv, &priv->ptp_data.cmd);
+	return sja1105_ptp_commit(priv, &ptp_data->cmd, SPI_WRITE);
 }
 
 /* Caller must hold priv->ptp_data.lock */
diff --git a/drivers/net/dsa/sja1105/sja1105_ptp.h b/drivers/net/dsa/sja1105/sja1105_ptp.h
index dfe856200394..c24c40115650 100644
--- a/drivers/net/dsa/sja1105/sja1105_ptp.h
+++ b/drivers/net/dsa/sja1105/sja1105_ptp.h
@@ -48,9 +48,11 @@ void sja1105_ptp_clock_unregister(struct sja1105_private *priv);
 
 int sja1105_ptpegr_ts_poll(struct sja1105_private *priv, int port, u64 *ts);
 
-int sja1105et_ptp_cmd(const void *ctx, const void *data);
+void sja1105et_ptp_cmd_packing(u8 *buf, struct sja1105_ptp_cmd *cmd,
+			       enum packing_op op);
 
-int sja1105pqrs_ptp_cmd(const void *ctx, const void *data);
+void sja1105pqrs_ptp_cmd_packing(u8 *buf, struct sja1105_ptp_cmd *cmd,
+				 enum packing_op op);
 
 int sja1105_get_ts_info(struct dsa_switch *ds, int port,
 			struct ethtool_ts_info *ts);
@@ -73,6 +75,8 @@ int __sja1105_ptp_adjtime(struct sja1105_private *priv, s64 delta);
 
 #else
 
+struct sja1105_ptp_cmd;
+
 /* Structures cannot be empty in C. Bah!
  * Keep the mutex as the only element, which is a bit more difficult to
  * refactor out of sja1105_main.c anyway.
@@ -131,9 +135,9 @@ static inline int __sja1105_ptp_adjtime(struct sja1105_private *priv, s64 delta)
 	return 0;
 }
 
-#define sja1105et_ptp_cmd NULL
+#define sja1105et_ptp_cmd_packing NULL
 
-#define sja1105pqrs_ptp_cmd NULL
+#define sja1105pqrs_ptp_cmd_packing NULL
 
 #define sja1105_get_ts_info NULL
 
diff --git a/drivers/net/dsa/sja1105/sja1105_spi.c b/drivers/net/dsa/sja1105/sja1105_spi.c
index eae9c9baa189..794cc5077565 100644
--- a/drivers/net/dsa/sja1105/sja1105_spi.c
+++ b/drivers/net/dsa/sja1105/sja1105_spi.c
@@ -571,7 +571,7 @@ struct sja1105_info sja1105e_info = {
 	.reset_cmd		= sja1105et_reset_cmd,
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
-	.ptp_cmd		= sja1105et_ptp_cmd,
+	.ptp_cmd_packing	= sja1105et_ptp_cmd_packing,
 	.regs			= &sja1105et_regs,
 	.name			= "SJA1105E",
 };
@@ -585,7 +585,7 @@ struct sja1105_info sja1105t_info = {
 	.reset_cmd		= sja1105et_reset_cmd,
 	.fdb_add_cmd		= sja1105et_fdb_add,
 	.fdb_del_cmd		= sja1105et_fdb_del,
-	.ptp_cmd		= sja1105et_ptp_cmd,
+	.ptp_cmd_packing	= sja1105et_ptp_cmd_packing,
 	.regs			= &sja1105et_regs,
 	.name			= "SJA1105T",
 };
@@ -600,7 +600,7 @@ struct sja1105_info sja1105p_info = {
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
-	.ptp_cmd		= sja1105pqrs_ptp_cmd,
+	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.regs			= &sja1105pqrs_regs,
 	.name			= "SJA1105P",
 };
@@ -615,7 +615,7 @@ struct sja1105_info sja1105q_info = {
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
-	.ptp_cmd		= sja1105pqrs_ptp_cmd,
+	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.regs			= &sja1105pqrs_regs,
 	.name			= "SJA1105Q",
 };
@@ -630,7 +630,7 @@ struct sja1105_info sja1105r_info = {
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
-	.ptp_cmd		= sja1105pqrs_ptp_cmd,
+	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.regs			= &sja1105pqrs_regs,
 	.name			= "SJA1105R",
 };
@@ -646,6 +646,6 @@ struct sja1105_info sja1105s_info = {
 	.reset_cmd		= sja1105pqrs_reset_cmd,
 	.fdb_add_cmd		= sja1105pqrs_fdb_add,
 	.fdb_del_cmd		= sja1105pqrs_fdb_del,
-	.ptp_cmd		= sja1105pqrs_ptp_cmd,
+	.ptp_cmd_packing	= sja1105pqrs_ptp_cmd_packing,
 	.name			= "SJA1105S",
 };
-- 
2.17.1

