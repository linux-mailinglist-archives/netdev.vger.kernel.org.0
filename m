Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95D79324EB
	for <lists+netdev@lfdr.de>; Sun,  2 Jun 2019 23:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfFBVPm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Jun 2019 17:15:42 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36221 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726693AbfFBVPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Jun 2019 17:15:41 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so6926550wrs.3
        for <netdev@vger.kernel.org>; Sun, 02 Jun 2019 14:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kENYGijRJXdKjo4gcTmbCUDdyWtUcvt1iTG4bwFTD00=;
        b=BRDvxO0Nylj7VvHAljGpSDYGrD8+9Tw6aqpMiH98t3Cze3t45/SwcA165jdTVoKH2S
         Q1QuDHdp4LTEUGpH+TVXiDDFFTLdT7rpLpmeU5UEDOf3YPHzBMOvzhFkhpiZw1fH7hSV
         Vw+wWN8gHMnYE38EcJn0vD8kNP7R8WlUnlalEjWjkvveByXSA0CbbfuGrzaAu91eIEqO
         7sFybMDUiNDKHLDUPfUZHDgZWKWgpFzMZ3/U/F0ZC/KnwqZPlilQ5wIDxKH2rvXrgD3k
         eGw9wIKvlqFWV9Ae6LaJIPXYSb87E5LG0Kbm8EZyNY/WGLRHFayoeLocOP4CN6PcsJVH
         mdiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kENYGijRJXdKjo4gcTmbCUDdyWtUcvt1iTG4bwFTD00=;
        b=CczsLn9GkECo2yX9oOqJ5q9euzVBfi8kXEINOJOdpIPM1kr4+NJUNxkimdgGV5S/1t
         VfbvkPQjuUd9IMkE+v8qbvnO2LGLv68HWe0AwWEuqXQo2Iy9ybcaboKkI4Uju5zj4xK3
         joAUT6Y7OMFRjj+AbKuhw3qDaKbu/aL8VQGay1OnjxgN6trd9GVUh362T7Whhbk/Bcza
         yxkimeZ3GX1SqzK83GtsRfFvbcyynahJju9wK5AiK6NxIBZteXS4CuukbqIyd1iEWBG1
         IMy93INJgwFKB7PMUaEYcvUkWD55y6n7wkz9IQcUeDRpveOe0BScxHKAo0mvhuA0yiyt
         ffAw==
X-Gm-Message-State: APjAAAWMLV9E5hBPdweVxHTpU11sd3iPLOFhNokUp85bvwyCzGl4AOjl
        yuZfcBDdFF0U6sOzC7a8m8zo7HOB
X-Google-Smtp-Source: APXvYqwA8gKPRmkPZPKBeDPFSon/SuOvxUpNbbWKPbgiqxAeSLCRsVw8dAr6ch54VsFFHLT8BSqH6Q==
X-Received: by 2002:a5d:4004:: with SMTP id n4mr14305901wrp.240.1559510139794;
        Sun, 02 Jun 2019 14:15:39 -0700 (PDT)
Received: from localhost.localdomain ([86.121.27.188])
        by smtp.gmail.com with ESMTPSA id p11sm8858589wrs.5.2019.06.02.14.15.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jun 2019 14:15:39 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 08/11] net: dsa: sja1105: Add P/Q/R/S management route support via dynamic interface
Date:   Mon,  3 Jun 2019 00:15:33 +0300
Message-Id: <20190602211533.18855-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Management routes are one-shot FDB rules installed on the CPU port for
sending link-local traffic.  They are a prerequisite for STP, PTP etc to
work.

Also make a note that removing a management route was not supported on
the previous generation of switches.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 40 ++++++++++++++++++-
 drivers/net/dsa/sja1105/sja1105_main.c        |  2 +
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 02a67df4437e..352bb6e89297 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -161,6 +161,36 @@ static size_t sja1105et_mgmt_route_entry_packing(void *buf, void *entry_ptr,
 	return size;
 }
 
+static void
+sja1105pqrs_mgmt_route_cmd_packing(void *buf, struct sja1105_dyn_cmd *cmd,
+				   enum packing_op op)
+{
+	u8 *p = buf + SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY;
+	u64 mgmtroute = 1;
+
+	sja1105pqrs_l2_lookup_cmd_packing(buf, cmd, op);
+	if (op == PACK)
+		sja1105_pack(p, &mgmtroute, 26, 26, SJA1105_SIZE_DYN_CMD);
+}
+
+static size_t sja1105pqrs_mgmt_route_entry_packing(void *buf, void *entry_ptr,
+						   enum packing_op op)
+{
+	const size_t size = SJA1105PQRS_SIZE_L2_LOOKUP_ENTRY;
+	struct sja1105_mgmt_entry *entry = entry_ptr;
+
+	/* In P/Q/R/S, enfport got renamed to mgmtvalid, but its purpose
+	 * is the same (driver uses it to confirm that frame was sent).
+	 * So just keep the name from E/T.
+	 */
+	sja1105_packing(buf, &entry->tsreg,     71, 71, size, op);
+	sja1105_packing(buf, &entry->takets,    70, 70, size, op);
+	sja1105_packing(buf, &entry->macaddr,   69, 22, size, op);
+	sja1105_packing(buf, &entry->destports, 21, 17, size, op);
+	sja1105_packing(buf, &entry->enfport,   16, 16, size, op);
+	return size;
+}
+
 /* In E/T, entry is at addresses 0x27-0x28. There is a 4 byte gap at 0x29,
  * and command is at 0x2a. Similarly in P/Q/R/S there is a 1 register gap
  * between entry (0x2d, 0x2e) and command (0x30).
@@ -359,7 +389,7 @@ struct sja1105_dynamic_table_ops sja1105et_dyn_ops[BLK_IDX_MAX_DYN] = {
 	[BLK_IDX_XMII_PARAMS] = {0},
 };
 
-/* SJA1105P/Q/R/S: Second generation: TODO */
+/* SJA1105P/Q/R/S: Second generation */
 struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 	[BLK_IDX_L2_LOOKUP] = {
 		.entry_packing = sja1105pqrs_l2_lookup_entry_packing,
@@ -369,6 +399,14 @@ struct sja1105_dynamic_table_ops sja1105pqrs_dyn_ops[BLK_IDX_MAX_DYN] = {
 		.packed_size = SJA1105PQRS_SIZE_L2_LOOKUP_DYN_CMD,
 		.addr = 0x24,
 	},
+	[BLK_IDX_MGMT_ROUTE] = {
+		.entry_packing = sja1105pqrs_mgmt_route_entry_packing,
+		.cmd_packing = sja1105pqrs_mgmt_route_cmd_packing,
+		.access = (OP_READ | OP_WRITE | OP_DEL | OP_SEARCH),
+		.max_entry_count = SJA1105_NUM_PORTS,
+		.packed_size = SJA1105PQRS_SIZE_L2_LOOKUP_DYN_CMD,
+		.addr = 0x24,
+	},
 	[BLK_IDX_L2_POLICING] = {0},
 	[BLK_IDX_VLAN_LOOKUP] = {
 		.entry_packing = sja1105_vlan_lookup_entry_packing,
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index dc9803efdbbd..f9bbc780f835 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1475,6 +1475,8 @@ static int sja1105_mgmt_xmit(struct dsa_switch *ds, int port, int slot,
 	if (!timeout) {
 		/* Clean up the management route so that a follow-up
 		 * frame may not match on it by mistake.
+		 * This is only hardware supported on P/Q/R/S - on E/T it is
+		 * a no-op and we are silently discarding the -EOPNOTSUPP.
 		 */
 		sja1105_dynamic_config_write(priv, BLK_IDX_MGMT_ROUTE,
 					     slot, &mgmt_route, false);
-- 
2.17.1

