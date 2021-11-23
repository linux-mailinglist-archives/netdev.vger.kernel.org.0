Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 003C745A6BF
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 16:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236345AbhKWPrU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 10:47:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:34892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236330AbhKWPrT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 10:47:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 56A9460F9D;
        Tue, 23 Nov 2021 15:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637682251;
        bh=OLhgtLiZ098SPvaox7Xvh4plbAgGDAJ9PdtCzmjKwEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8pD31JblxsYNDLVUpVWoXlFMGsRTaDOf82cCtnuAN3ktoAN82lWGeLE7ftbJ3kOo
         2XEGShyIfvzWnlwNKVOY9vJl6C5sf5RVFQ1YJkPtN9Lc3HmHhCldHOneM6+5uxcPIh
         2cy7c8/2CSqfmJFOFt8lq1YyBCmp29/ktIrn2GeNY84vNgoglqcpvydNGLwwG+bXnH
         SBdYzVovv6lnQI/+GjI40OwD67/YW8PZSmTkMCi4lnljUV8f7gWBR+zeiy5gC4IJEI
         5+nXFesvWJKsxkfeA/djxxWtdUYTCBhWMxZh1JOwQblzBYHWhPxerp9CIWWF/EFsik
         1N+KN3O5NkmEw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net v2 2/2] net: phylink: Force retrigger in case of latched link-fail indicator
Date:   Tue, 23 Nov 2021 16:44:03 +0100
Message-Id: <20211123154403.32051-3-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211123154403.32051-1-kabel@kernel.org>
References: <20211123154403.32051-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>

On mv88e6xxx 1G/2.5G PCS, the SerDes register 4.2001.2 has the following
description:
  This register bit indicates when link was lost since the last
  read. For the current link status, read this register
  back-to-back.

Thus to get current link state, we need to read the register twice.

But doing that in the link change interrupt handler would lead to
potentially ignoring link down events, which we really want to avoid.

Thus this needs to be solved in phylink's resolve, by retriggering
another resolve in the event when PCS reports link down and previous
link was up, and by re-reading PCS state if the previous link was down.

The wrong value is read when phylink requests change from sgmii to
2500base-x mode, and link won't come up. This fixes the bug.

Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/phylink.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 5b8b61daeb98..eacbb0e6a24b 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -994,6 +994,19 @@ static void phylink_resolve(struct work_struct *w)
 		case MLO_AN_INBAND:
 			phylink_mac_pcs_get_state(pl, &link_state);
 
+			/* The PCS may have a latching link-fail indicator.
+			 * If the link was up, bring the link down and
+			 * re-trigger the resolve. Otherwise, re-read the
+			 * PCS state to get the current status of the link.
+			 */
+			if (!link_state.link) {
+				if (cur_link_state)
+					retrigger = true;
+				else
+					phylink_mac_pcs_get_state(pl,
+								  &link_state);
+			}
+
 			/* If we have a phy, the "up" state is the union of
 			 * both the PHY and the MAC
 			 */
-- 
2.32.0

