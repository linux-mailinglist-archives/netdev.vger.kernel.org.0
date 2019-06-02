Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEE9324E9
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfFBVNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:13:16 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42593 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfFBVNQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:13:16 -0400
Received: by mail-wr1-f65.google.com with SMTP id o12so2848028wrj.9
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 14:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nO16182GFub7AElElbcH93IRaYnx8DkaEo1pquO7Cvs=;
        b=S/3Kl9Skm7Jbx2f512nUyLzKJW1QSnfgiN0gE8pgjRPTBcJSUbA6/Qqmu2M05g4Cya
         zMOa9t+m7VhBi+Y3OcLzpc3NHlSZEUei1t4WNrdifUQr6L40VyQ7SFalETZQe8VW2Ff/
         zRL7sXYixlSD7kKlVudMhLaE6sofC3+oLk//2+iFLAejHFfx0HyVsRj1M5xHUy+RnXHf
         QefdaRFsM9rBO+YQZy0TFUTv8m2qMRpxw1X0CvWcg9niNq1xat/V//R4E0AdDLXYdjPm
         UZBujzPTCUl7qVbo01ulxd4fqqLtH8Pj8ZEnzXrkTt5uAcrqcyAxmB6sAjaRligy6Gnh
         p6oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nO16182GFub7AElElbcH93IRaYnx8DkaEo1pquO7Cvs=;
        b=Vdv37XjSzdWnF9llis6HKKzjTQLTWp5aJP3lhUTTImcv7NVMH5XnJvI/9GbwNDb5tX
         olgqZEN2lg/IOjdnFgQZSWSBZZIPLdNpc2vTO1J3zeUKn+c6w3vf1G5+OLBStFV5yNqr
         rE9nt+XMhDQ0GzbgOZogctxpEuArQOv0lf3M/1ghY2VKn1X3YfoAwvjE2vgptJFP8rA4
         BWtazDpkGTxyDtj6CCzJe5R4vbx87m5Lz4ACNDS64YL3iBryBiqGyWwPy1N1vOgEgA4E
         dhA7zULxh0g2NeM54woPK7l9A78WGQv8RCxnMPnKmKXbzPOmB+rH4eeOOwFbfRp+Dfk0
         h86w==
X-Gm-Message-State: APjAAAWkiE8cmNAiUXIuJV9kQgouc18YjrXqW1rfKgk4mHv5ImV6Dq5V
        Bb9iwdtOoyNZxphIbK87aFN81yjB
X-Google-Smtp-Source: APXvYqzQJY34iY4w2LmgRBQk6Sb1M1h6zeoB2nPdFh3ZAdOb+TawMXjl5h065ISBgPQCpD1GaZOe1w==
X-Received: by 2002:adf:9267:: with SMTP id 94mr89971wrj.338.1559509993771;
        Sun, 02 Jun 2019 14:13:13 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id q11sm9548193wmc.15.2019.06.02.14.13.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:13:06 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 06/11] net: dsa: sja1105: Add P/Q/R/S support for dynamic L2 lookup operations
Date:   Mon,  3 Jun 2019 00:11:58 +0300
Message-Id: <20190602211203.17773-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602211203.17773-1-olteanv@gmail.com>
References: <20190602211203.17773-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are needed in order to implement the switchdev FDB callbacks.

Compared to the E/T generation, not only the ABI (bit offsets) is
different, but also the introduction of the HOSTCMD field which permits
O(1) TCAM search for an FDB entry.  Make use of the newly introduce
OP_SEARCH to permit that.  It will be used while adding and deleting an
FDB entry (to see whether it exists or not).

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 54 +++++++++++++++++--
 1 file changed, 50 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 3a8b0d0ab330..7db1f8258287 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -44,17 +44,63 @@ struct sja1105_dyn_cmd {
 	u64 index;
 };
 
+enum sja1105_hostcmd {
+	SJA1105_HOSTCMD_SEARCH = 1,
+	SJA1105_HOSTCMD_READ = 2,
+	SJA1105_HOSTCMD_WRITE = 3,
+	SJA1105_HOSTCMD_INVALIDATE = 4,
+};
+
 static void
 sja1105pqrs_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 				  enum packing_op op)
 {
 	u8 *p = buf + SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY;
 	const int size = SJA1105_SIZE_DYN_CMD;
+	u64 lockeds = 0;
+	u64 hostcmd;
 
 	sja1105_packing(p, &cmd->valid,    31, 31, size, op);
 	sja1105_packing(p, &cmd->rdwrset,  30, 30, size, op);
 	sja1105_packing(p, &cmd->errors,   29, 29, size, op);
+	sja1105_packing(p, &lockeds,       28, 28, size, op);
 	sja1105_packing(p, &cmd->valident, 27, 27, size, op);
+
+	/* VALIDENT is supposed to indicate "keep or not", but in SJA1105 E/T,
+	 * using it to delete a management route was unsupported. UM10944
+	 * said about it:
+	 *
+	 *   In case of a write access with the MGMTROUTE flag set,
+	 *   the flag will be ignored. It will always be found cleared
+	 *   for read accesses with the MGMTROUTE flag set.
+	 *
+	 * SJA1105 P/Q/R/S keeps the same behavior w.r.t. VALIDENT, but there
+	 * is now another flag called HOSTCMD which does more stuff (quoting
+	 * from UM11040):
+	 *
+	 *   A write request is accepted only when HOSTCMD is set to write host
+	 *   or invalid. A read request is accepted only when HOSTCMD is set to
+	 *   search host or read host.
+	 *
+	 * So it is possible to translate a RDWRSET/VALIDENT combination into
+	 * HOSTCMD so that we keep the dynamic command API in place, and
+	 * at the same time achieve compatibility with the management route
+	 * command structure.
+	 */
+	if (cmd->rdwrset == SPI_READ) {
+		if (cmd->search)
+			hostcmd = SJA1105_HOSTCMD_SEARCH;
+		else
+			hostcmd = SJA1105_HOSTCMD_READ;
+	} else {
+		/* SPI_WRITE */
+		if (cmd->valident)
+			hostcmd = SJA1105_HOSTCMD_WRITE;
+		else
+			hostcmd = SJA1105_HOSTCMD_INVALIDATE;
+	}
+	sja1105_packing(p, &hostcmd, 25, 23, size, op);
+
 	/* Hack - The hardware takes the 'index' field within
 	 * struct sja1105_l2_lookup_entry as the index on which this command
 	 * will operate. However it will ignore everything else, so 'index'
@@ -65,7 +111,6 @@ sja1105pqrs_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 	 */
 	sja1105_packing(buf, &cmd->index, 15, 6,
 			SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY, op);
-	/* TODO hostcmd */
 }
 
 static void
@@ -319,9 +364,9 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 	[BLK_IDX_L2_LOOKUP] = {
 		.entry_packing = sja1105pqrs_l2_lookup_entry_packing,
 		.cmd_packing = sja1105pqrs_l2_lookup_cmd_packing,
-		.access = (OP_READ | OP_WRITE | OP_DEL),
+		.access = (OP_READ | OP_WRITE | OP_DEL | OP_SEARCH),
 		.max_entry_count = SJA1105_MAX_L2_LOOKUP_COUNT,
-		.packed_size = SJA1105ET_SIZE_L2_LOOKUP_DYN_CMD,
+		.packed_size = SJA1105PQRS_SIZE_L2_LOOKUP_DYN_CMD,
 		.addr = 0x24,
 	},
 	[BLK_IDX_L2_POLICING] = {0},
@@ -403,7 +448,7 @@ int sja1105_dynamic_config_read(struct sja1105_private *priv,
 
 	ops = &priv->info->dyn_ops[blk_idx];
 
-	if (index >= ops->max_entry_count)
+	if (index >= 0 && index >= ops->max_entry_count)
 		return -ERANGE;
 	if (index < 0 && !(ops->access & OP_SEARCH))
 		return -EOPNOTSUPP;
@@ -426,6 +471,7 @@ int sja1105_dynamic_config_read(struct sja1105_private *priv,
 		cmd.index = index;
 		cmd.search = false;
 	}
+	cmd.valident = true;
 	ops->cmd_packing(packed_buf, &cmd, PACK);
 
 	if (cmd.search)
-- 
2.17.1

