Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 992EF324E7
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfFBVMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:12:50 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41287 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726879AbfFBVMu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:12:50 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so9971691wrm.8
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 14:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=X7Isc7dkSAG4gSYUlK60oTHltsGixfWJEjAtfvpYsUM=;
        b=uVb13Syg+Dt3mG4w8+W4CoRY9/4GeGGPbigRzsXkSBq7DF262fY/cY/qOPyC7rKsdq
         ZI2auQnMqXPDEDdxWm59D9o6i83s9/sfHWl0iXYr+CzFhWaAPZkDyVzmUOld4/l5lYSc
         SbtObgAf8eeQq2Qreb+mn8bVDLVu2XWq6IKCjYwRZSTqF4wd9G2ud4XDbuWv5L707JhL
         aaWUehk8c7HZyYfblC1eZqUGUYIf6s4ujhYtynuRIq1JBYd/ZFMCGeF4x56Wbt6bp5wl
         XxCcMb+7pUcFKIs8rDSVGHQaVbe13YjrjuikL8bkiWczwryo2meVk95W6tdodeMUIZAH
         DOgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=X7Isc7dkSAG4gSYUlK60oTHltsGixfWJEjAtfvpYsUM=;
        b=r7HsWLK2WkuA8pOAJ2whPq5koFQcSDMELhoHfE4EWatShE7NNhxoqqJTSEBfrPK/zz
         MGQ1h9d76M7eaYvFA0FKw/NRIRIHso8fST54iTEazg9419sLtGfAgYCI4wJiTS0vQHb4
         J10qdd9wBb6PxYigOoYrh6+E+D8lcAZxydDl3DqOBCCe3R2WQZl6U+OSagjpK3j1uMHl
         JhWILm+hZT2TiNSmWPcPzSxysI1p3lQ6iLFvm4jEuB9mEkjJHtl+xzwWPICJ+W7eMRAE
         HiKiJz+Foxr8KHIzQK7xsLHrRwzIemfDZFDmP3wum6YO16uG61gc7p5AuwELbaReM6H/
         Uodg==
X-Gm-Message-State: APjAAAUoCbVOuGE+BMqgmnOGQF+JOjNVwo+IdDVam8w08Fg7fI9dyBtk
        QhSxktTO5c+TCDtrfEHh5FW6UA0m
X-Google-Smtp-Source: APXvYqy5Ah+QqY5rf7N00T62yC7hlJIGYIKjUOxL5V8sW9S0JH/pis6v2Jw2wODdgkYManhVpa/73Q==
X-Received: by 2002:adf:e9c4:: with SMTP id l4mr101628wrn.142.1559509967634;
        Sun, 02 Jun 2019 14:12:47 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id q11sm9548193wmc.15.2019.06.02.14.12.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:12:42 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 04/11] net: dsa: sja1105: Plug in support for TCAM searches via the dynamic interface
Date:   Mon,  3 Jun 2019 00:11:56 +0300
Message-Id: <20190602211203.17773-5-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190602211203.17773-1-olteanv@gmail.com>
References: <20190602211203.17773-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only a single dynamic configuration table of the SJA1105 P/Q/R/S
supports this operation: the FDB.

To keep the existing structure in place (sja1105_dynamic_config_read and
sja1105_dynamic_config_write) and not introduce any new function, a
convention is made for sja1105_dynamic_config_read that a negative index
argument denotes a search for the entry provided as argument.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 36 ++++++++++++++++++-
 .../net/dsa/sja1105/sja1105_dynamic_config.h  |  3 ++
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 0023b03a010d..7e7efc2e8ee4 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -36,6 +36,7 @@
 	SJA1105PQRS_SIZE_MAC_CONFIG_DYN_CMD
 
 struct sja1105_dyn_cmd {
+	bool search;
 	u64 valid;
 	u64 rdwrset;
 	u64 errors;
@@ -248,6 +249,7 @@ sja1105et_general_params_entry_packing(void *buf, void *entry_ptr,
 #define OP_READ		BIT(0)
 #define OP_WRITE	BIT(1)
 #define OP_DEL		BIT(2)
+#define OP_SEARCH	BIT(3)
 
 /* SJA1105E/T: First generation */
 struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
@@ -367,6 +369,24 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 	[BLK_IDX_XMII_PARAMS] = {0},
 };
 
+/* Provides read access to the settings through the dynamic interface
+ * of the switch.
+ * @blk_idx	is used as key to select from the sja1105_dynamic_table_ops.
+ *		The selection is limited by the hardware in respect to which
+ *		configuration blocks can be read through the dynamic interface.
+ * @index	is used to retrieve a particular table entry. If negative,
+ *		(and if the @blk_idx supports the searching operation) a search
+ *		is performed by the @entry parameter.
+ * @entry	Type-casted to an unpacked structure that holds a table entry
+ *		of the type specified in @blk_idx.
+ *		Usually an output argument. If @index is negative, then this
+ *		argument is used as input/output: it should be pre-populated
+ *		with the element to search for. Entries which support the
+ *		search operation will have an "index" field (not the @index
+ *		argument to this function) and that is where the found index
+ *		will be returned (or left unmodified - thus negative - if not
+ *		found).
+ */
 int sja1105_dynamic_config_read(struct sja1105_private *priv,
 				enum sja1105_blk_idx blk_idx,
 				int index, void *entry)
@@ -385,6 +405,8 @@ int sja1105_dynamic_config_read(struct sja1105_private *priv,
 
 	if (index >= ops->max_entry_count)
 		return -ERANGE;
+	if (index < 0 && !(ops->access & OP_SEARCH))
+		return -EOPNOTSUPP;
 	if (!(ops->access & OP_READ))
 		return -EOPNOTSUPP;
 	if (ops->packed_size > SJA1105_MAX_DYN_CMD_SIZE)
@@ -396,9 +418,19 @@ int sja1105_dynamic_config_read(struct sja1105_private *priv,
 
 	cmd.valid = true; /* Trigger action on table entry */
 	cmd.rdwrset = SPI_READ; /* Action is read */
-	cmd.index = index;
+	if (index < 0) {
+		/* Avoid copying a signed negative number to an u64 */
+		cmd.index = 0;
+		cmd.search = true;
+	} else {
+		cmd.index = index;
+		cmd.search = false;
+	}
 	ops->cmd_packing(packed_buf, &cmd, PACK);
 
+	if (cmd.search)
+		ops->entry_packing(packed_buf, entry, PACK);
+
 	/* Send SPI write operation: read config table entry */
 	rc = sja1105_spi_send_packed_buf(priv, SPI_WRITE, ops->addr,
 					 packed_buf, ops->packed_size);
@@ -456,6 +488,8 @@ int sja1105_dynamic_config_write(struct sja1105_private *priv,
 
 	if (index >= ops->max_entry_count)
 		return -ERANGE;
+	if (index < 0)
+		return -ERANGE;
 	if (!(ops->access & OP_WRITE))
 		return -EOPNOTSUPP;
 	if (!keep && !(ops->access & OP_DEL))
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.h b/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
index 49c611eb02cb..740dadf43f01 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.h
@@ -7,6 +7,9 @@
 #include "sja1105.h"
 #include <linux/packing.h>
 
+/* Special index that can be used for sja1105_dynamic_config_read */
+#define SJA1105_SEARCH		-1
+
 struct sja1105_dyn_cmd;
 
 struct sja1105_dynamic_table_ops {
-- 
2.17.1

