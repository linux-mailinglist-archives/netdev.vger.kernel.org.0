Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17304743C8
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 14:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234541AbhLNNpj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 08:45:39 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:41874 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234537AbhLNNph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Dec 2021 08:45:37 -0500
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639489535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dtBv0pCkOaDpa1ktY12/an6AVoU44vB4b5jZF67iQuA=;
        b=IGM0UuBfcTAslINHF00Rv9nT5k1KeA1SxHn/YwOpwUbmDZBkR9ttVTByoL5ywtlAqlqiyz
        7gyHhhrVraMHPAxswP47YruGvs94Rm+QFFVIUVDl1MMyyAzYuEG84WCltyW1SQz+cryPBr
        1b7Fm8MeW8rq+ktHyTjkG+IZTGoBc3sUUxNKR5AqkoY6jiFJ5BbqGSgT2X4fnS9EZrOTCv
        YrhvEXUk2fsbW01NW4tNEC3ww3RUDZ9TJW/FmuznGJRe3tpRcOC2MTI5ucF951ErV9tibj
        1/gc6uv9UP8K1dGRUpjuicaZdvPnm+boRIFbMWqUfkXz65sVoB2uoVzW5Sik5A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639489535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dtBv0pCkOaDpa1ktY12/an6AVoU44vB4b5jZF67iQuA=;
        b=xQdnos2B/6DYSIFykSgLWPadISD9J0nMzoGhUnXrVpJ76WcDziLo426FcmvhG2ibvx8KJS
        17ytJx2UGubQJbAw==
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        netdev@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: [PATCH net-next v2 1/4] net: dsa: hellcreek: Fix insertion of static FDB entries
Date:   Tue, 14 Dec 2021 14:45:05 +0100
Message-Id: <20211214134508.57806-2-kurt@linutronix.de>
In-Reply-To: <20211214134508.57806-1-kurt@linutronix.de>
References: <20211214134508.57806-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The insertion of static FDB entries ignores the pass_blocked bit. That bit is
evaluated with regards to STP. Add the missing functionality.

Fixes: e4b27ebc780f ("net: dsa: Add DSA driver for Hirschmann Hellcreek switches")
Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 9eecb7529573..c4f840b20adf 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -711,8 +711,9 @@ static int __hellcreek_fdb_add(struct hellcreek *hellcreek,
 	u16 meta = 0;
 
 	dev_dbg(hellcreek->dev, "Add static FDB entry: MAC=%pM, MASK=0x%02x, "
-		"OBT=%d, REPRIO_EN=%d, PRIO=%d\n", entry->mac, entry->portmask,
-		entry->is_obt, entry->reprio_en, entry->reprio_tc);
+		"OBT=%d, PASS_BLOCKED=%d, REPRIO_EN=%d, PRIO=%d\n", entry->mac,
+		entry->portmask, entry->is_obt, entry->pass_blocked,
+		entry->reprio_en, entry->reprio_tc);
 
 	/* Add mac address */
 	hellcreek_write(hellcreek, entry->mac[1] | (entry->mac[0] << 8), HR_FDBWDH);
@@ -723,6 +724,8 @@ static int __hellcreek_fdb_add(struct hellcreek *hellcreek,
 	meta |= entry->portmask << HR_FDBWRM0_PORTMASK_SHIFT;
 	if (entry->is_obt)
 		meta |= HR_FDBWRM0_OBT;
+	if (entry->pass_blocked)
+		meta |= HR_FDBWRM0_PASS_BLOCKED;
 	if (entry->reprio_en) {
 		meta |= HR_FDBWRM0_REPRIO_EN;
 		meta |= entry->reprio_tc << HR_FDBWRM0_REPRIO_TC_SHIFT;
-- 
2.30.2

