Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A79971BFAA1
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 15:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729061AbgD3Nyt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 09:54:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:37546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729050AbgD3Nys (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 09:54:48 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA722208DB;
        Thu, 30 Apr 2020 13:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254887;
        bh=Le0zW1plhrNPBG0p2P7erK3rKc1E/Ehf/4uht5qiCYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjSqxigdev1hCGsh1ScwS9HpxHD5GIK/JlWupYEWUjTkx/EvrbWZx3cjfrx7rePDO
         ttxB4aEFnnxq1b0cCpF7N7NhM66J44mfqALnDYddOHb9LWTb3GRXEoq5aE11NUg9H/
         c3eRD60JQ0bGks43G5rIwcT9GbvtEtsqY+12w2Pg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/17] net: dsa: b53: Rework ARL bin logic
Date:   Thu, 30 Apr 2020 09:54:28 -0400
Message-Id: <20200430135433.21204-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135433.21204-1-sashal@kernel.org>
References: <20200430135433.21204-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 6344dbde6a27d10d16246d734b968f84887841e2 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 30 ++++++++++++++++++++++++++----
 drivers/net/dsa/b53/b53_regs.h   |  3 +++
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 71525950c641d..060f9b1769298 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1109,6 +1109,7 @@ static int b53_arl_read(struct b53_device *dev, u64 mac,
 			u16 vid, struct b53_arl_entry *ent, u8 *idx,
 			bool is_valid)
 {
+	DECLARE_BITMAP(free_bins, B53_ARLTBL_MAX_BIN_ENTRIES);
 	unsigned int i;
 	int ret;
 
@@ -1116,6 +1117,8 @@ static int b53_arl_read(struct b53_device *dev, u64 mac,
 	if (ret)
 		return ret;
 
+	bitmap_zero(free_bins, dev->num_arl_entries);
+
 	/* Read the bins */
 	for (i = 0; i < dev->num_arl_entries; i++) {
 		u64 mac_vid;
@@ -1127,13 +1130,21 @@ static int b53_arl_read(struct b53_device *dev, u64 mac,
 			   B53_ARLTBL_DATA_ENTRY(i), &fwd_entry);
 		b53_arl_to_entry(ent, mac_vid, fwd_entry);
 
-		if (!(fwd_entry & ARLTBL_VALID))
+		if (!(fwd_entry & ARLTBL_VALID)) {
+			set_bit(i, free_bins);
 			continue;
+		}
 		if ((mac_vid & ARLTBL_MAC_MASK) != mac)
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
 
@@ -1163,10 +1174,21 @@ static int b53_arl_op(struct b53_device *dev, int op, int port,
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
 
 	memset(&ent, 0, sizeof(ent));
diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
index 85c44bfba55a2..3cf246c6bdcc4 100644
--- a/drivers/net/dsa/b53/b53_regs.h
+++ b/drivers/net/dsa/b53/b53_regs.h
@@ -280,6 +280,9 @@
 #define   ARLTBL_STATIC			BIT(15)
 #define   ARLTBL_VALID			BIT(16)
 
+/* Maximum number of bin entries in the ARL for all switches */
+#define B53_ARLTBL_MAX_BIN_ENTRIES	4
+
 /* ARL Search Control Register (8 bit) */
 #define B53_ARL_SRCH_CTL		0x50
 #define B53_ARL_SRCH_CTL_25		0x20
-- 
2.20.1

