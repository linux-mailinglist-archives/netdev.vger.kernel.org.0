Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D0245988F
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 00:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbhKVXzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 18:55:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:42570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232007AbhKVXzI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 18:55:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C9436101A;
        Mon, 22 Nov 2021 23:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637625121;
        bh=egm/7DenZTTEK7bHJfVrPa0M9dSi6t5o9PCmnk+J7i4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=blc41oc0wkUYjnp3CWi1e3lu4RQuwnL/CbEJmvVKt4w0TP/xvD27n1aEIXFpAAG0m
         KL7QNgPO7263OvU0cCQWOqOoK2c6BefDdAO/dHPxUJPsDxmIs11RTgghskg5RbBXcv
         DUuuiYoyZzK7cJ7+OmNBym9YhEu2mizNLOeuPzlLOqwZJMStRkndCJ6MaZhofdGmbZ
         Bv9uk0FTa+0eXg8qUoD0rwt20Qxr0f4kynX537oyip7bASaNT501Sr+dk82T51Jd+v
         QuOy9pQp8RjRJD/lR+Rt2JWtyRS1OzWl5bUkYBKHLi645Lh6cdyofjWtZFTK34gMuV
         tVUuxabZL2+UQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net 2/2] net: phylink: Force retrigger in case of latched link-fail indicator
Date:   Tue, 23 Nov 2021 00:51:54 +0100
Message-Id: <20211122235154.6392-3-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122235154.6392-1-kabel@kernel.org>
References: <20211122235154.6392-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
link was up.

The wrong value is read when phylink requests change from sgmii to
2500base-x mode, and link won't come up. This fixes the bug.

Fixes: 9525ae83959b ("phylink: add phylink infrastructure")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/phy/phylink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 5b8b61daeb98..c6b5d5af8817 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -994,6 +994,12 @@ static void phylink_resolve(struct work_struct *w)
 		case MLO_AN_INBAND:
 			phylink_mac_pcs_get_state(pl, &link_state);
 
+			/* The PCS may have a latching link-fail indicator.
+			 * If the PCS link goes down, retrigger a resolve.
+			 */
+			if (!link_state.link && cur_link_state)
+				retrigger = true;
+
 			/* If we have a phy, the "up" state is the union of
 			 * both the PHY and the MAC
 			 */
-- 
2.32.0

