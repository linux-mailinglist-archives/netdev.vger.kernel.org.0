Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAADC339D64
	for <lists+netdev@lfdr.de>; Sat, 13 Mar 2021 10:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233155AbhCMJkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Mar 2021 04:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbhCMJkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Mar 2021 04:40:02 -0500
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268EBC061764
        for <netdev@vger.kernel.org>; Sat, 13 Mar 2021 01:40:01 -0800 (PST)
Received: from p548da928.dip0.t-ipconnect.de ([84.141.169.40] helo=kmk0.Speedport_W_724V_09011603_06_007); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1lL0kY-0002vy-0E; Sat, 13 Mar 2021 10:39:58 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH net-next v2 3/4] net: dsa: hellcreek: Move common code to helper
Date:   Sat, 13 Mar 2021 10:39:38 +0100
Message-Id: <20210313093939.15179-4-kurt@kmk-computers.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210313093939.15179-1-kurt@kmk-computers.de>
References: <20210313093939.15179-1-kurt@kmk-computers.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1615628402;59b7f840;
X-HE-SMSGID: 1lL0kY-0002vy-0E
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are two functions which need to populate fdb entries. Move that to a
helper function.

Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 85 +++++++++++++-------------
 1 file changed, 43 insertions(+), 42 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index edac39462a07..38ff0f12e8a4 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -670,6 +670,40 @@ static int __hellcreek_fdb_del(struct hellcreek *hellcreek,
 	return hellcreek_wait_fdb_ready(hellcreek);
 }
 
+static void hellcreek_populate_fdb_entry(struct hellcreek *hellcreek,
+					 struct hellcreek_fdb_entry *entry,
+					 size_t idx)
+{
+	unsigned char addr[ETH_ALEN];
+	u16 meta, mac;
+
+	/* Read values */
+	meta	= hellcreek_read(hellcreek, HR_FDBMDRD);
+	mac	= hellcreek_read(hellcreek, HR_FDBRDL);
+	addr[5] = mac & 0xff;
+	addr[4] = (mac & 0xff00) >> 8;
+	mac	= hellcreek_read(hellcreek, HR_FDBRDM);
+	addr[3] = mac & 0xff;
+	addr[2] = (mac & 0xff00) >> 8;
+	mac	= hellcreek_read(hellcreek, HR_FDBRDH);
+	addr[1] = mac & 0xff;
+	addr[0] = (mac & 0xff00) >> 8;
+
+	/* Populate @entry */
+	memcpy(entry->mac, addr, sizeof(addr));
+	entry->idx	    = idx;
+	entry->portmask	    = (meta & HR_FDBMDRD_PORTMASK_MASK) >>
+		HR_FDBMDRD_PORTMASK_SHIFT;
+	entry->age	    = (meta & HR_FDBMDRD_AGE_MASK) >>
+		HR_FDBMDRD_AGE_SHIFT;
+	entry->is_obt	    = !!(meta & HR_FDBMDRD_OBT);
+	entry->pass_blocked = !!(meta & HR_FDBMDRD_PASS_BLOCKED);
+	entry->is_static    = !!(meta & HR_FDBMDRD_STATIC);
+	entry->reprio_tc    = (meta & HR_FDBMDRD_REPRIO_TC_MASK) >>
+		HR_FDBMDRD_REPRIO_TC_SHIFT;
+	entry->reprio_en    = !!(meta & HR_FDBMDRD_REPRIO_EN);
+}
+
 /* Retrieve the index of a FDB entry by mac address. Currently we search through
  * the complete table in hardware. If that's too slow, we might have to cache
  * the complete FDB table in software.
@@ -691,39 +725,19 @@ static int hellcreek_fdb_get(struct hellcreek *hellcreek,
 	 * enter new entries anywhere.
 	 */
 	for (i = 0; i < hellcreek->fdb_entries; ++i) {
-		unsigned char addr[ETH_ALEN];
-		u16 meta, mac;
-
-		meta	= hellcreek_read(hellcreek, HR_FDBMDRD);
-		mac	= hellcreek_read(hellcreek, HR_FDBRDL);
-		addr[5] = mac & 0xff;
-		addr[4] = (mac & 0xff00) >> 8;
-		mac	= hellcreek_read(hellcreek, HR_FDBRDM);
-		addr[3] = mac & 0xff;
-		addr[2] = (mac & 0xff00) >> 8;
-		mac	= hellcreek_read(hellcreek, HR_FDBRDH);
-		addr[1] = mac & 0xff;
-		addr[0] = (mac & 0xff00) >> 8;
+		struct hellcreek_fdb_entry tmp = { 0 };
+
+		/* Read entry */
+		hellcreek_populate_fdb_entry(hellcreek, &tmp, i);
 
 		/* Force next entry */
 		hellcreek_write(hellcreek, 0x00, HR_FDBRDH);
 
-		if (memcmp(addr, dest, ETH_ALEN))
+		if (memcmp(tmp.mac, dest, ETH_ALEN))
 			continue;
 
 		/* Match found */
-		entry->idx	    = i;
-		entry->portmask	    = (meta & HR_FDBMDRD_PORTMASK_MASK) >>
-			HR_FDBMDRD_PORTMASK_SHIFT;
-		entry->age	    = (meta & HR_FDBMDRD_AGE_MASK) >>
-			HR_FDBMDRD_AGE_SHIFT;
-		entry->is_obt	    = !!(meta & HR_FDBMDRD_OBT);
-		entry->pass_blocked = !!(meta & HR_FDBMDRD_PASS_BLOCKED);
-		entry->is_static    = !!(meta & HR_FDBMDRD_STATIC);
-		entry->reprio_tc    = (meta & HR_FDBMDRD_REPRIO_TC_MASK) >>
-			HR_FDBMDRD_REPRIO_TC_SHIFT;
-		entry->reprio_en    = !!(meta & HR_FDBMDRD_REPRIO_EN);
-		memcpy(entry->mac, addr, sizeof(addr));
+		memcpy(entry, &tmp, sizeof(*entry));
 
 		return 0;
 	}
@@ -838,18 +852,9 @@ static int hellcreek_fdb_dump(struct dsa_switch *ds, int port,
 	for (i = 0; i < hellcreek->fdb_entries; ++i) {
 		unsigned char null_addr[ETH_ALEN] = { 0 };
 		struct hellcreek_fdb_entry entry = { 0 };
-		u16 meta, mac;
-
-		meta	= hellcreek_read(hellcreek, HR_FDBMDRD);
-		mac	= hellcreek_read(hellcreek, HR_FDBRDL);
-		entry.mac[5] = mac & 0xff;
-		entry.mac[4] = (mac & 0xff00) >> 8;
-		mac	= hellcreek_read(hellcreek, HR_FDBRDM);
-		entry.mac[3] = mac & 0xff;
-		entry.mac[2] = (mac & 0xff00) >> 8;
-		mac	= hellcreek_read(hellcreek, HR_FDBRDH);
-		entry.mac[1] = mac & 0xff;
-		entry.mac[0] = (mac & 0xff00) >> 8;
+
+		/* Read entry */
+		hellcreek_populate_fdb_entry(hellcreek, &entry, i);
 
 		/* Force next entry */
 		hellcreek_write(hellcreek, 0x00, HR_FDBRDH);
@@ -858,10 +863,6 @@ static int hellcreek_fdb_dump(struct dsa_switch *ds, int port,
 		if (!memcmp(entry.mac, null_addr, ETH_ALEN))
 			continue;
 
-		entry.portmask	= (meta & HR_FDBMDRD_PORTMASK_MASK) >>
-			HR_FDBMDRD_PORTMASK_SHIFT;
-		entry.is_static	= !!(meta & HR_FDBMDRD_STATIC);
-
 		/* Check port mask */
 		if (!(entry.portmask & BIT(port)))
 			continue;
-- 
2.30.2

