Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 611971900A6
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 22:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgCWVta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 17:49:30 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52808 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725897AbgCWVta (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 17:49:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=AMMYmc9z2TG0eI3asbrOqUDtzc3wXLWu7cuIYCzS890=; b=FKY0HOjVBFHu0KQ3tORp8DirbZ
        S3LLjzMNfKZoE2zw9OiZLpVoAA8YONJaDYtrnfjED4JEozydbYm9kqR/UMzxm/Q5STHRcd2e7zOC7
        pVVunO0FhE4zBVyM68j70L84iSX8VklXpL6DQfaHTQYyJEbn8/uPU51BuOgq7ktaeths=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jGUwh-0003g6-5p; Mon, 23 Mar 2020 22:49:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 2/2] net: dsa: mv88e6xxx: Set link down when changing speed
Date:   Mon, 23 Mar 2020 22:49:00 +0100
Message-Id: <20200323214900.14083-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200323214900.14083-1-andrew@lunn.ch>
References: <20200323214900.14083-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MAC control register must not be changed unless the link is down.
Add the necassary call into mv88e6xxx_mac_link_up. Without it, the MAC
does not change state, the link remains at the wrong speed.

Fixes: 30c4a5b0aad8 ("net: mv88e6xxx: use resolved link config in mac_link_up()")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index dd8a5666a584..24ce17503950 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -733,6 +733,14 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
 
 	mv88e6xxx_reg_lock(chip);
 	if (!mv88e6xxx_port_ppu_updates(chip, port) || mode == MLO_AN_FIXED) {
+		/* Port's MAC control must not be changed unless the
+		 * link is down
+		 */
+		err = chip->info->ops->port_set_link(chip, port,
+						     LINK_FORCED_DOWN);
+		if (err)
+			goto error;
+
 		/* FIXME: for an automedia port, should we force the link
 		 * down here - what if the link comes up due to "other" media
 		 * while we're bringing the port up, how is the exclusivity
-- 
2.26.0.rc2

