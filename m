Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8BB855C6F
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 01:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbfFYXkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 19:40:14 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46210 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbfFYXkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 19:40:13 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so471485wrw.13
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 16:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=raXIqhPaohlGa77/z9hJwiDqgE5iF8kwlixH9wTFSfQ=;
        b=X8HoJqeuMskRkuRGdc33JSQ1lMsh5tf48wd3bfM3LPs2twIWTLn2zrkSgeH7kU/aLn
         J4q/dcbEPMRIgyhAvn9aTkNaBwojuEM0P6VO5Ple/APAwgmxx7B8KwCbcewlXQ+hp90v
         Brb62iO2c03cuc7X4YS1Yh2racay7la49YSp2N9uY5IEJf1PzdCh6j1SZk5lL1Gr245m
         8CRLnDLykYJw9qZW5GRdFgCrxOsHuLEk6AkEi+NWlr6KV3isZT67X3pR3mEeCMPKIqRR
         IwAKRReGDYso8mYS0vWigpAIVUvP3A49XpH7VS4myq05A7/k86sQMmvVMUFmU/QEjH4v
         a7Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=raXIqhPaohlGa77/z9hJwiDqgE5iF8kwlixH9wTFSfQ=;
        b=P3vN3qj9Ovfo8tYxt1RjUdAD/24eqg6Mkx9nyVA4RFc82APd/yC6MM4hsgRcdlCYNK
         iSZafWJ59NzNbd9hUHmYFbu7CYaB9yP0uAonQTkgAIJbLqb0eCk9ZMVqPmrGT6qDaxjE
         FKzdeqAAVE8LhclMaUUSpfsRzMD1aEvzGvwsUQlgRq/UACO8jGGbFWgG3GutZyWNeWrK
         7QUPvTHEAcouPAN0s2MGpT8ywMLBDSVrDJBoAHFHjKfp0BbOeazuR8Q/ZxZzoGIg6JkX
         uOlUKmi13VxdBwryGQf4bb/VJ0Twv6W8vGo/8c5NtOhhfAH0i9jxm991/jJnNMHBed2S
         vQXQ==
X-Gm-Message-State: APjAAAVRpNa+RtluN5pw5McgfOHtgPEDQxgdi1HpVmvbPmFaS1H1GY2S
        9XslUIlBZEoDaoi3pzJbv3M=
X-Google-Smtp-Source: APXvYqxeotbn+AmcBPHy0SsOGQQiQmpwpARDzhKQOCJMa4nCX5rDjLuYJuCAnxCV6Yevd8Ef/pzgtw==
X-Received: by 2002:adf:f442:: with SMTP id f2mr439045wrp.275.1561506011070;
        Tue, 25 Jun 2019 16:40:11 -0700 (PDT)
Received: from localhost.localdomain ([188.26.252.192])
        by smtp.gmail.com with ESMTPSA id p3sm10810949wrd.47.2019.06.25.16.40.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Jun 2019 16:40:10 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 08/10] net: dsa: sja1105: Populate is_static for FDB entries on P/Q/R/S
Date:   Wed, 26 Jun 2019 02:39:40 +0300
Message-Id: <20190625233942.1946-9-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190625233942.1946-1-olteanv@gmail.com>
References: <20190625233942.1946-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The reason why this wasn't tackled earlier is that I had hoped I
understood the user manual wrong.  But unfortunately hacks are required
in order to retrieve the static/dynamic nature of FDB entries on SJA1105
P/Q/R/S, since this info is stored in the writeback buffer of the
dynamic config command.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 62 ++++++++++++++++++-
 drivers/net/dsa/sja1105/sja1105_main.c        |  3 +-
 .../net/dsa/sja1105/sja1105_static_config.h   |  2 +-
 3 files changed, 62 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 3acd48615981..6bfb1696a6f2 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -149,13 +149,11 @@ sja1105pqrs_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 {
 	u8 *p = buf + SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY;
 	const int size = SJA1105_SIZE_DYN_CMD;
-	u64 lockeds = 0;
 	u64 hostcmd;
 
 	sja1105_packing(p, &cmd->valid,    31, 31, size, op);
 	sja1105_packing(p, &cmd->rdwrset,  30, 30, size, op);
 	sja1105_packing(p, &cmd->errors,   29, 29, size, op);
-	sja1105_packing(p, &lockeds,       28, 28, size, op);
 	sja1105_packing(p, &cmd->valident, 27, 27, size, op);
 
 	/* VALIDENT is supposed to indicate "keep or not", but in SJA1105 E/T,
@@ -205,6 +203,64 @@ sja1105pqrs_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 			SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY, op);
 }
 
+/* The switch is so retarded that it makes our command/entry abstraction
+ * crumble apart.
+ *
+ * On P/Q/R/S, the switch tries to say whether a FDB entry
+ * is statically programmed or dynamically learned via a flag called LOCKEDS.
+ * The hardware manual says about this fiels:
+ *
+ *   On write will specify the format of ENTRY.
+ *   On read the flag will be found cleared at times the VALID flag is found
+ *   set.  The flag will also be found cleared in response to a read having the
+ *   MGMTROUTE flag set.  In response to a read with the MGMTROUTE flag
+ *   cleared, the flag be set if the most recent access operated on an entry
+ *   that was either loaded by configuration or through dynamic reconfiguration
+ *   (as opposed to automatically learned entries).
+ *
+ * The trouble with this flag is that it's part of the *command* to access the
+ * dynamic interface, and not part of the *entry* retrieved from it.
+ * Otherwise said, for a sja1105_dynamic_config_read, LOCKEDS is supposed to be
+ * an output from the switch into the command buffer, and for a
+ * sja1105_dynamic_config_write, the switch treats LOCKEDS as an input
+ * (hence we can write either static, or automatically learned entries, from
+ * the core).
+ * But the manual contradicts itself in the last phrase where it says that on
+ * read, LOCKEDS will be set to 1 for all FDB entries written through the
+ * dynamic interface (therefore, the value of LOCKEDS from the
+ * sja1105_dynamic_config_write is not really used for anything, it'll store a
+ * 1 anyway).
+ * This means you can't really write a FDB entry with LOCKEDS=0 (automatically
+ * learned) into the switch, which kind of makes sense.
+ * As for reading through the dynamic interface, it doesn't make too much sense
+ * to put LOCKEDS into the command, since the switch will inevitably have to
+ * ignore it (otherwise a command would be like "read the FDB entry 123, but
+ * only if it's dynamically learned" <- well how am I supposed to know?) and
+ * just use it as an output buffer for its findings. But guess what... that's
+ * what the entry buffer is for!
+ * Unfortunately, what really breaks this abstraction is the fact that it
+ * wasn't designed having the fact in mind that the switch can output
+ * entry-related data as writeback through the command buffer.
+ * However, whether a FDB entry is statically or dynamically learned *is* part
+ * of the entry and not the command data, no matter what the switch thinks.
+ * In order to do that, we'll need to wrap around the
+ * sja1105pqrs_l2_lookup_entry_packing from sja1105_static_config.c, and take
+ * a peek outside of the caller-supplied @buf (the entry buffer), to reach the
+ * command buffer.
+ */
+static size_t
+sja1105pqrs_dyn_l2_lookup_entry_packing(void *buf, void *entry_ptr,
+					enum packing_op op)
+{
+	struct sja1105_l2_lookup_entry *entry = entry_ptr;
+	u8 *cmd = buf + SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY;
+	const int size = SJA1105_SIZE_DYN_CMD;
+
+	sja1105_packing(cmd, &entry->lockeds, 28, 28, size, op);
+
+	return sja1105pqrs_l2_lookup_entry_packing(buf, entry_ptr, op);
+}
+
 static void
 sja1105et_l2_lookup_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
 				enum packing_op op)
@@ -485,7 +541,7 @@ struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 /* SJA1105P/Q/R/S: Second generation */
 struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 	[BLK_IDX_L2_LOOKUP] = {
-		.entry_packing = sja1105pqrs_l2_lookup_entry_packing,
+		.entry_packing = sja1105pqrs_dyn_l2_lookup_entry_packing,
 		.cmd_packing = sja1105pqrs_l2_lookup_cmd_packing,
 		.access = (OP_READ | OP_WRITE | OP_DEL | OP_SEARCH),
 		.max_entry_count = SJA1105_MAX_L2_LOOKUP_COUNT,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 80d8d2f5c472..ed0b721c794e 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1070,6 +1070,7 @@ int sja1105pqrs_fdb_add(struct dsa_switch *ds, int port,
 		dev_err(ds->dev, "FDB is full, cannot add entry.\n");
 		return -EINVAL;
 	}
+	l2_lookup.lockeds = true;
 	l2_lookup.index = i;
 
 skip_finding_an_index:
@@ -1205,7 +1206,7 @@ static int sja1105_fdb_dump(struct dsa_switch *ds, int port,
 		 */
 		if (!dsa_port_is_vlan_filtering(&ds->ports[port]))
 			l2_lookup.vlanid = 1;
-		cb(macaddr, l2_lookup.vlanid, false, data);
+		cb(macaddr, l2_lookup.vlanid, l2_lookup.lockeds, data);
 	}
 	return 0;
 }
diff --git a/drivers/net/dsa/sja1105/sja1105_static_config.h b/drivers/net/dsa/sja1105/sja1105_static_config.h
index 2a3a1a92d7c3..684465fc0882 100644
--- a/drivers/net/dsa/sja1105/sja1105_static_config.h
+++ b/drivers/net/dsa/sja1105/sja1105_static_config.h
@@ -132,7 +132,7 @@ struct sja1105_l2_lookup_entry {
 	u64 mask_vlanid;
 	u64 mask_macaddr;
 	u64 iotag;
-	bool lockeds;
+	u64 lockeds;
 	union {
 		/* LOCKEDS=1: Static FDB entries */
 		struct {
-- 
2.17.1

