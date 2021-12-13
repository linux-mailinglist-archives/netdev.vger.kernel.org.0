Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D2A472A49
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 11:37:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbhLMKh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 05:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234822AbhLMKhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 05:37:17 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F37C0497C5
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 02:18:34 -0800 (PST)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639390712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vGFMhWE3YNxN8OCVi38W/wgfSB8G1kKisT2knFJIAUQ=;
        b=2E40IAajG8FvxPZ34f4VdsxJNYnTi32mop3/Z4Nsifnw6Hsfc0ihjLGTNetT9KV1eGNZon
        8rriwoxW8AR2it6Hm6RL/WTcK5FF/wMaBd+D+kA12IIRDBZWMGRC2k3cRZX1rImEBvI3d1
        i3entNaYLrCDJ3UK6cqDeECAj5z6eLV51zACFUOLn10g0KtZCynJxF6x+IiEonv7cGNM2e
        UIdTzjnlbD2r7u7kQefzMPoHQG6Mp+WqzqjTcys8Sfu+V/fMcn31+6bIgx6Zpd319yYjzv
        IEdsTPD4fW+FryTrsUSmMHeoSGA9H+0AG09sKZ36m6gscyay7kB4x8LXh1u24A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639390712;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vGFMhWE3YNxN8OCVi38W/wgfSB8G1kKisT2knFJIAUQ=;
        b=wQBtgZ+Nlewl4YL5cSUBbaUcrp9pE/r3ub1DzStPaTBMV2Vlmn0/xAuwimfmUTrYvOK1Xj
        s+rcjii/MxdbcDBw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net] net: dsa: hellcreek: Allow PTP on blocked ports
Date:   Mon, 13 Dec 2021 11:18:10 +0100
Message-Id: <20211213101810.121553-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PTP forms its own clock distribution tree. Therefore, PTP traffic is allowed to
traverse blocked ports by STP. Adjust the static FDB entries accordingly.

Fixes: ddd56dfe52c9 ("net: dsa: hellcreek: Add PTP clock support")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 4e0b53d94b52..072fc442cde2 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -710,8 +710,9 @@ static int __hellcreek_fdb_add(struct hellcreek *hellcreek,
 	u16 meta = 0;
 
 	dev_dbg(hellcreek->dev, "Add static FDB entry: MAC=%pM, MASK=0x%02x, "
-		"OBT=%d, REPRIO_EN=%d, PRIO=%d\n", entry->mac, entry->portmask,
-		entry->is_obt, entry->reprio_en, entry->reprio_tc);
+		"OBT=%d, PASS_BLOCKED=%d, REPRIO_EN=%d, PRIO=%d\n", entry->mac,
+		entry->portmask, entry->is_obt, entry->pass_blocked,
+		entry->reprio_en, entry->reprio_tc);
 
 	/* Add mac address */
 	hellcreek_write(hellcreek, entry->mac[1] | (entry->mac[0] << 8), HR_FDBWDH);
@@ -722,6 +723,8 @@ static int __hellcreek_fdb_add(struct hellcreek *hellcreek,
 	meta |= entry->portmask << HR_FDBWRM0_PORTMASK_SHIFT;
 	if (entry->is_obt)
 		meta |= HR_FDBWRM0_OBT;
+	if (entry->pass_blocked)
+		meta |= HR_FDBWRM0_PASS_BLOCKED;
 	if (entry->reprio_en) {
 		meta |= HR_FDBWRM0_REPRIO_EN;
 		meta |= entry->reprio_tc << HR_FDBWRM0_REPRIO_TC_SHIFT;
@@ -1055,7 +1058,7 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
 		.portmask     = 0x03,	/* Management ports */
 		.age	      = 0,
 		.is_obt	      = 0,
-		.pass_blocked = 0,
+		.pass_blocked = 1,
 		.is_static    = 1,
 		.reprio_tc    = 6,	/* TC: 6 as per IEEE 802.1AS */
 		.reprio_en    = 1,
@@ -1066,7 +1069,7 @@ static int hellcreek_setup_fdb(struct hellcreek *hellcreek)
 		.portmask     = 0x03,	/* Management ports */
 		.age	      = 0,
 		.is_obt	      = 0,
-		.pass_blocked = 0,
+		.pass_blocked = 1,
 		.is_static    = 1,
 		.reprio_tc    = 6,	/* TC: 6 as per IEEE 802.1AS */
 		.reprio_en    = 1,
-- 
2.30.2

