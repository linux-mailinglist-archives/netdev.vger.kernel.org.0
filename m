Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9B1571959
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 14:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbiGLMB1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 08:01:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbiGLMBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 08:01:25 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D2C2DF
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 05:01:24 -0700 (PDT)
From:   Benedikt Spranger <b.spranger@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1657627281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Z/6eGtGh38E+V/0P19QFHYnBRhfhe0+5Qg1gdXTWRE=;
        b=2zR0IGu+DOXAnj3ani/hCMw2FpNe0CyG31r2PBbT/3LaSvdiRbdiOxbLTSordJV1G1aeBY
        /K3cgIkRO11rQe/oGF0hNw/mOfZ6QQsLC/gI0kxqEIK7v+EHiZGN9NYAPZOQ1LmgCl4ixK
        Nic9yYWYAFNO1+8i5CLz34KBuSw+YjuQALxMLOSl7/aFZ9VFoI3J6QnOp4SbKSMtZoZd3M
        20vJIg0fJXMS3DockZjcmxby/RFs/oEVzIm/lqiE4iY4IsVZ8YqKbTL27Xs1N3oamR1cEF
        ld3CuFyeZMWod5X91VhaeXKxLWhXD1+KErHvOu7RI9c5kaFXBvrJ9xKXiVLHdw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1657627281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3Z/6eGtGh38E+V/0P19QFHYnBRhfhe0+5Qg1gdXTWRE=;
        b=xpuDpKGuaYEWFD84pFDLBfa7UAK6eOPybJuaGOg7CktvOGLToTPw3yllURo6R/ujcMQo2J
        o2a58wc9anELtbCA==
To:     netdev@vger.kernel.org
Subject: [PATCH ethtool 1/1] pretty: Add support for TI CPSW register dumps
Date:   Tue, 12 Jul 2022 14:01:14 +0200
Message-Id: <20220712120114.3219-2-b.spranger@linutronix.de>
In-Reply-To: <20220712120114.3219-1-b.spranger@linutronix.de>
References: <20220712120114.3219-1-b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add pretty register dump for the ALE table of the cpsw kernel drivers.

Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
Reviewed-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 Makefile.am |   2 +-
 cpsw.c      | 193 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 ethtool.c   |   1 +
 internal.h  |   3 +
 4 files changed, 198 insertions(+), 1 deletion(-)
 create mode 100644 cpsw.c

diff --git a/Makefile.am b/Makefile.am
index dc5fbec..e1eabe2 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -18,7 +18,7 @@ ethtool_SOURCES += \
 		  smsc911x.c at76c50x-usb.c sfc.c stmmac.c	\
 		  sff-common.c sff-common.h sfpid.c sfpdiag.c	\
 		  ixgbevf.c tse.c vmxnet3.c qsfp.c qsfp.h fjes.c lan78xx.c \
-		  igc.c cmis.c cmis.h bnxt.c
+		  igc.c cmis.c cmis.h bnxt.c cpsw.c
 endif
 
 if ENABLE_BASH_COMPLETION
diff --git a/cpsw.c b/cpsw.c
new file mode 100644
index 0000000..68dcfac
--- /dev/null
+++ b/cpsw.c
@@ -0,0 +1,193 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Code to dump registers for TI CPSW switch devices.
+ *
+ * Copyright (c) 2022 Linutronix GmbH
+ * Author: Benedikt Spranger <b.spranger@linutronix.de>
+ */
+
+#include <stdio.h>
+#include <string.h>
+
+#include "internal.h"
+
+#define ALE_ENTRY_BITS		68
+#define ALE_ENTRY_WORDS DIV_ROUND_UP(ALE_ENTRY_BITS, 32)
+#define ALE_ENTRY_BYTES (ALE_ENTRY_WORDS * 4)
+
+struct address_table_entry
+{
+	u8 port;
+	u8 reserved1;
+	u8 reserved2;
+	u8 reserved3;
+	u8 addr2;
+	u8 addr1;
+	u16 vlan;
+	u8 addr6;
+	u8 addr5;
+	u8 addr4;
+	u8 addr3;
+} __attribute__((packed));
+
+struct vlan_table_entry
+{
+	u8 reserved1;
+	u8 reserved2;
+	u8 reserved3;
+	u8 reserved4;
+	u8 reserved5;
+	u8 reserved6;
+	u16 vlan;
+	u8 member;
+	u8 mc_unreg;
+	u8 mc_reg;
+	u8 untag;
+} __attribute__((packed));
+
+union ale_entry {
+	struct address_table_entry addr;
+	struct vlan_table_entry vlan;
+	u32 val[3];
+	u8 byte[12];
+};
+
+enum entry_type {
+	FREE_ENTRY = 0,
+	ADDR_ENTRY,
+	VLAN_ENTRY,
+	VLAN_ADDR_ENTRY,
+	LAST_ENTRY
+};
+
+static char *fwd_state_name[] = {
+	"Forwarding",
+	"Blocking/Forwarding/Learning",
+	"Forwarding/Learning",
+	"Forwarding",
+};
+
+static char *type_name[] = {
+	"free entry",
+	"address entry",
+	"VLAN entry",
+	"VLAN address entry",
+	"invalid"
+};
+
+enum entry_type decode_type(union ale_entry *entry)
+{
+	/* Entry Type (61:60) */
+	return (entry->byte[7] >> 4) & 0x3;
+}
+
+static void print_addr(u8 *data)
+{
+	printf("%02x:%02x:%02x:%02x:%02x:%02x",
+	       data[5], data[4], data[11], data[10], data[9], data[8]);
+}
+
+static void decode_multi_addr(union ale_entry *entry, int vlan)
+{
+	printf("      MULTI: ");
+	print_addr(entry->byte);
+	printf(" %s", fwd_state_name[entry->addr.vlan >> 14]);
+	printf("%s", (entry->addr.port & 0x02) ? " Super" : "");
+	printf(" Ports: 0x%x", (entry->addr.port >> 2) & 0x3);
+	if (vlan)
+		printf(" VLAN: %04d", entry->addr.vlan & 0x0fff);
+	printf("\n");
+}
+
+static void decode_uni_addr(union ale_entry *entry, int vlan)
+{
+	printf("      UNI  : ");
+	print_addr(entry->byte);
+	printf("%s", (entry->addr.port & 0x01) ? " Secure" : "");
+	printf("%s", (entry->addr.port & 0x02) ? " Block" : "");
+	printf("%s", (entry->addr.port & 0x20) ? " DLR" : "");
+	printf(" Ports: 0x%x", (entry->addr.port >> 2) & 0x3);
+	if (vlan)
+		printf(" VLAN: %04d", entry->addr.vlan & 0x0fff);
+	printf("\n");
+}
+
+static void decode_oui_addr(union ale_entry *entry)
+{
+	printf("      OUI  : ");
+	print_addr(entry->byte);
+	printf("\n");
+}
+
+static void decode_vlan(union ale_entry *entry)
+{
+	printf("      VLAN ");
+	printf("%04d: ", entry->vlan.vlan & 0x0fff);
+	printf("member: 0x%x ", entry->vlan.member & 0x7);
+	printf("mc flood unreg: 0x%x ", entry->vlan.mc_unreg & 0x7);
+	printf("mc flood reg: 0x%x ", entry->vlan.mc_reg & 0x7);
+	printf("untag: 0x%x\n", entry->vlan.untag & 0x7);
+}
+
+static enum entry_type decode_ale_entry(unsigned int idx, const u8 *data,
+					bool last_was_free)
+{
+	union ale_entry *entry = (union ale_entry *) data;
+	enum entry_type type;
+
+	entry = entry + idx;
+	type = decode_type(entry);
+
+	if (!last_was_free || type != FREE_ENTRY)
+		printf("%04d: %s\n", idx, type_name[type]);
+
+	switch (type)
+	{
+	case FREE_ENTRY:
+		goto out;
+		break;
+
+	case ADDR_ENTRY:
+		/* Multicast: OUI 01:00:5e:xx:xx:xx */
+		if (entry->addr.addr1 == 0x01)
+			decode_multi_addr(entry, 0);
+		else
+			if ((entry->addr.vlan >> 14) == 0x2)
+				decode_oui_addr(entry);
+			else
+				decode_uni_addr(entry, 0);
+		break;
+
+	case VLAN_ENTRY:
+		decode_vlan(entry);
+		break;
+
+	case VLAN_ADDR_ENTRY:
+		/* Check for Individual/Group bit */
+		if (entry->addr.addr1 & 0x01)
+			decode_multi_addr(entry, 1);
+		else
+			decode_uni_addr(entry, 1);
+		break;
+
+	default:
+		printf("internal failure.\n");
+	}
+
+out:
+	return type;
+}
+
+int cpsw_dump_regs(struct ethtool_drvinfo *info __maybe_unused,
+		   struct ethtool_regs *regs)
+{
+	unsigned int entries = regs->len/ALE_ENTRY_BYTES;
+	enum entry_type type = LAST_ENTRY;
+	unsigned int i;
+
+	printf("ALE Entries (%d):\n", entries);
+
+	for (i = 0; i < entries; i++)
+		type = decode_ale_entry(i, regs->data, (type == FREE_ENTRY));
+
+	return 0;
+}
diff --git a/ethtool.c b/ethtool.c
index 911f26b..517cdc5 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -1129,6 +1129,7 @@ static const struct {
 	{ "fec", fec_dump_regs },
 	{ "igc", igc_dump_regs },
 	{ "bnxt_en", bnxt_dump_regs },
+	{ "cpsw-switch", cpsw_dump_regs },
 };
 #endif
 
diff --git a/internal.h b/internal.h
index 0d9d816..9c4b86a 100644
--- a/internal.h
+++ b/internal.h
@@ -412,4 +412,7 @@ int igc_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
 /* Broadcom Ethernet Controller */
 int bnxt_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
 
+/* TI CPSW Ethernet Switch */
+int cpsw_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs);
+
 #endif /* ETHTOOL_INTERNAL_H__ */
-- 
2.36.1

