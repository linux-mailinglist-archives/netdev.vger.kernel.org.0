Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4DF1A7257
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 06:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405176AbgDNEQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 00:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405167AbgDNEQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 00:16:48 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6097C0A3BDC;
        Mon, 13 Apr 2020 21:16:47 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id a25so12727367wrd.0;
        Mon, 13 Apr 2020 21:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8+FrUca9gQRLeYSS11nklym7WjOSuUcaGzg4kk+01tQ=;
        b=pupj91GB0MguZ3qm6Rz3Fej2+i4TI2Ni4aQKc7mhm+6OQB8W7zvGLpXk6N1ldiM0PM
         UwiICYKKlj/9cNwuN10x8/jNZj2O858PeAU25ExxtTddQIgVuLh2vNKpwncE+fT9giPK
         ey4YhzBUMWC/GQS5lJn1mRhkotxQdz1lyMwXWfBso0mFPazLDAdBBuMlsRll9VdavIqx
         dlALdfQd0ZqqY9L/I05KQa5EFV32rK11UUoUkzwfDxgokvY5cq+S8ZrAzyMMY0mvk6cs
         c7v2Qp6J3X/vKHy5S+IonJebr2wmWDxea1bVjEuT/FU/H2G2U5brpcI42LZADiAHlLbZ
         80GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8+FrUca9gQRLeYSS11nklym7WjOSuUcaGzg4kk+01tQ=;
        b=o4eESWmp/uvahvlTmUKatLGF5kvN/FZcer9kSHTd9lo5P41SNxdXwWsamH1tfTMC/K
         maRfM0J5LHT5aTaTBEWBjykFGTJDi9LnbiDmUwT/IloiNdIrDuHi2OdAh3jqaHva7FR8
         oUgzpB8pLbCj9kSe39sktVmqNJUBIgzO9vrziiipwp1O5Tx9Rd74kwb4BoY2aVgRd3UB
         eYL3Yz5CtvfuaCu5M5juOjS23bU8AYIbixxQcyYl67fL7qW+YgDVjppOYGcGtFYbVVUC
         un5j/LIxzy2++XT4+JnOuHv2RGY11bREFIG9iY9X2tAgc7tHvvYRfWPie65tIXArEz9s
         6rbg==
X-Gm-Message-State: AGi0PuZk6JkQwot/zkUicJDbTHkNqCjPi+FrGuTrJO/nnxlHB8gx/+Yq
        uQM2aqDhHLcJnUImRNRqaiDrptsN
X-Google-Smtp-Source: APiQypK7D1pS3X0E8mch1uooa9sSpvYvwAtKVfaDNpmQrYlmVj4QRIdfwkICUTrLBnc9/6sDI3KdAw==
X-Received: by 2002:adf:ed07:: with SMTP id a7mr22431728wro.2.1586837806339;
        Mon, 13 Apr 2020 21:16:46 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n4sm16704471wmi.20.2020.04.13.21.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 21:16:45 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        linux-kernel@vger.kernel.org (open list), davem@davemloft.net,
        kuba@kernel.org
Subject: [PATCH net 4/4] net: dsa: b53: Rework ARL bin logic
Date:   Mon, 13 Apr 2020 21:16:30 -0700
Message-Id: <20200414041630.5740-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200414041630.5740-1-f.fainelli@gmail.com>
References: <20200414041630.5740-1-f.fainelli@gmail.com>
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
 drivers/net/dsa/b53/b53_common.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index e937bf365490..b2b2c4a301bf 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1483,6 +1483,7 @@ static int b53_arl_read(struct b53_device *dev, u64 mac,
 			u16 vid, struct b53_arl_entry *ent, u8 *idx,
 			bool is_valid)
 {
+	DECLARE_BITMAP(free_bins, dev->num_arl_entries);
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
 
@@ -1537,13 +1548,21 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
 
 	ret = b53_arl_read(dev, mac, vid, &ent, &idx, is_valid);
 	/* If this is a read, just finish now */
-	if (op)
+	if (op && ret != -ENOENT)
 		return ret;
 
 	/* We could not find a matching MAC, so reset to a new entry */
-	if (ret) {
+	switch (ret) {
+	case -ENOSPC:
+		dev_warn(dev->dev, "no space left in ARL\n");
+		return ret;
+	case -ENOENT:
+		dev_dbg(dev->dev, "{%pM,%.4d} not found, using idx: %d\n", addr, vid, idx);
 		fwd_entry = 0;
-		idx = 1;
+		break;
+	default:
+		dev_dbg(dev->dev, "{%pM,%.4d} found, using idx: %d\n", addr, vid, idx);
+		break;
 	}
 
 	/* For multicast address, the port is a bitmask and the validity
-- 
2.17.1

