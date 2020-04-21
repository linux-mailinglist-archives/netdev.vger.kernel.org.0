Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9CAA1B1CCE
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 05:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728337AbgDUD2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 23:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728309AbgDUD2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 23:28:01 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7792C061A0E;
        Mon, 20 Apr 2020 20:28:00 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id a8so4170774edv.2;
        Mon, 20 Apr 2020 20:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=i4f3blRR8KOStv74M2Pa40QRZx7xjwDr+fwIlAgyHBU=;
        b=CJVb3sr/LYvyotgBZak6pKlNUJEBYdt2uLOQxdTecK623ra3YoeWYPRzL56uJXiiiQ
         dXm0Wxn9kkptZ8DuOCimIbrTwO1zazHQFIep5lX6/eah6+vikw4vxHk17q5dTtxrLuvg
         gtOA5o0NdqBw4KIbiXpB+zEH5Qjs7wf67WqyGT2lmP0kZUXyPuj38N+KouRhJz0u3HeV
         YeJ1jsP4XM9vOQlOlGzci+/WsX+706ioaBrcwQl8YAWLV06r0Z1gfWS+Zf6halyhomta
         FTo9l1W2Ct4NRry+O86gotZa3KzSkrJQuyhQ5pkDvm7ZaJlsi3Z09QtqEk2U1mi6ThTc
         D6IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=i4f3blRR8KOStv74M2Pa40QRZx7xjwDr+fwIlAgyHBU=;
        b=VXJy8kPfqiROqrXy1JVIVp5eallXG7Anq1prWcrENxaml7WP6aUwPXb1DV+h6PnKih
         dZrx0ovSOnJN6uGXiEYviFVYUvGL2DY0HegCdah8CsuMiZPQkWIcGVEdD+35VGWhLxiZ
         KY8qpLpcF/ndd8AhOI+qmCQi9bTMkAPzHMCKy2NMCmENFctM38vKqcCq+IMqD4ohI3rT
         Z8skS6HIGDPUj9UXhWNAqMh4kkna2rZHdP1MmgN3Q64HH6cUQOvE1p1BJsUir9bnoUPA
         QMkm4nryGEma0/H/kKy4AZT9vKOIlBcG8VbDbQpbQ+wKxedlw/fAJK2qfbNEa+8NgPUT
         L9Qw==
X-Gm-Message-State: AGi0PuaMXbQ5kw17AXxnXw9oyC3HVFgGZ5gwhpnn9B3egMablRTibnlr
        QLxS9Z3uQBNRq+je7eYUmNyZHCQQ
X-Google-Smtp-Source: APiQypLfllFy+OZu7n31et0wNdvBBuP2o1B2gSwnoU9qxd+054SD7WMOykrccOVp9Z+wIK/RdGq/Eg==
X-Received: by 2002:a05:6402:1a46:: with SMTP id bf6mr10314295edb.44.1587439679027;
        Mon, 20 Apr 2020 20:27:59 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j9sm216836edl.67.2020.04.20.20.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 20:27:58 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        linux-kernel@vger.kernel.org (open list), davem@davemloft.net,
        kuba@kernel.org
Subject: [PATCH net v2 4/5] net: dsa: b53: Rework ARL bin logic
Date:   Mon, 20 Apr 2020 20:26:54 -0700
Message-Id: <20200421032655.5537-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200421032655.5537-1-f.fainelli@gmail.com>
References: <20200421032655.5537-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When asking the ARL to read a MAC address, we will get a number of bins
returned in a single read. Out of those bins, there can essentially be 3
states:

- all bins are full, we have no space left, and we can either replace an
  existing address or return that full condition

- the MAC address was found, then we need to return its bin index and
  modify that one, and only that one

- the MAC address was not found and we have a least one bin free, we use
  that bin index location then

The code would unfortunately fail on all counts.

Fixes: 1da6df85c6fb ("net: dsa: b53: Implement ARL add/del/dump operations")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/b53/b53_common.c | 30 ++++++++++++++++++++++++++----
 drivers/net/dsa/b53/b53_regs.h   |  3 +++
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index e937bf365490..8cb41583bbad 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1483,6 +1483,7 @@ static int b53_arl_read(struct b53_device *dev, u64 mac,
 			u16 vid, struct b53_arl_entry *ent, u8 *idx,
 			bool is_valid)
 {
+	DECLARE_BITMAP(free_bins, B53_ARLTBL_MAX_BIN_ENTRIES);
 	unsigned int i;
 	int ret;
 
@@ -1490,6 +1491,8 @@ static int b53_arl_read(struct b53_device *dev, u64 mac,
 	if (ret)
 		return ret;
 
+	bitmap_zero(free_bins, dev->num_arl_entries);
+
 	/* Read the bins */
 	for (i = 0; i < dev->num_arl_entries; i++) {
 		u64 mac_vid;
@@ -1501,16 +1504,24 @@ static int b53_arl_read(struct b53_device *dev, u64 mac,
 			   B53_ARLTBL_DATA_ENTRY(i), &fwd_entry);
 		b53_arl_to_entry(ent, mac_vid, fwd_entry);
 
-		if (!(fwd_entry & ARLTBL_VALID))
+		if (!(fwd_entry & ARLTBL_VALID)) {
+			set_bit(i, free_bins);
 			continue;
+		}
 		if ((mac_vid & ARLTBL_MAC_MASK) != mac)
 			continue;
 		if (dev->vlan_enabled &&
 		    ((mac_vid >> ARLTBL_VID_S) & ARLTBL_VID_MASK) != vid)
 			continue;
 		*idx = i;
+		return 0;
 	}
 
+	if (bitmap_weight(free_bins, dev->num_arl_entries) == 0)
+		return -ENOSPC;
+
+	*idx = find_first_bit(free_bins, dev->num_arl_entries);
+
 	return -ENOENT;
 }
 
@@ -1540,10 +1551,21 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 	if (op)
 		return ret;
 
-	/* We could not find a matching MAC, so reset to a new entry */
-	if (ret) {
+	switch (ret) {
+	case -ENOSPC:
+		dev_dbg(dev->dev, "{%pM,%.4d} no space left in ARL\n",
+			addr, vid);
+		return is_valid ? ret : 0;
+	case -ENOENT:
+		/* We could not find a matching MAC, so reset to a new entry */
+		dev_dbg(dev->dev, "{%pM,%.4d} not found, using idx: %d\n",
+			addr, vid, idx);
 		fwd_entry = 0;
-		idx = 1;
+		break;
+	default:
+		dev_dbg(dev->dev, "{%pM,%.4d} found, using idx: %d\n",
+			addr, vid, idx);
+		break;
 	}
 
 	/* For multicast address, the port is a bitmask and the validity
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index d914e756cdab..14f617e9173d 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -323,6 +323,9 @@
 #define   ARLTBL_STATIC			BIT(15)
 #define   ARLTBL_VALID			BIT(16)
 
+/* Maximum number of bin entries in the ARL for all switches */
+#define B53_ARLTBL_MAX_BIN_ENTRIES	4
+
 /* ARL Search Control Register (8 bit) */
 #define B53_ARL_SRCH_CTL		0x50
 #define B53_ARL_SRCH_CTL_25		0x20
-- 
2.17.1

