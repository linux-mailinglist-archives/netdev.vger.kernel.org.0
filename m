Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9ED947173A
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 23:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbhLKWv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 17:51:58 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42972 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhLKWv6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 17:51:58 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 660AECE09FF
        for <netdev@vger.kernel.org>; Sat, 11 Dec 2021 22:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F56C004DD;
        Sat, 11 Dec 2021 22:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639263114;
        bh=H0931xbX52D2M3PxxcWjCdHVoeKW+D7YDwcwd5VOEJE=;
        h=From:To:Cc:Subject:Date:From;
        b=o3FSriTpN4qVn3+a3VHbMCli5GAK1tGIaDkHGUzS/QuxWVnoCC3JFOQ77pZYIhnmW
         BuOxW/N5WdiXXnPBfPfr8Uz1yqiwUFCYIwAq0yLcB9gUcVunIqtQ7u7LNnyw5hA7Uw
         28KWPVx7yLZfI2N9/AjtjQki+293XEb6r5PYnyHCUFKuVGJsh1filAibQUDVwvbfrC
         n7InctcGIW7T1uezB0F1wjZxwLe3ugdKvp6QcHyXr+9u009/V5F8gCUybNi0Fh0gGR
         7w+n9vj03uS7rplVoxtLzOKUlYWAMHpx1WFy7l5+rNyx1jEWN1QY6jxQa2IofgWihS
         X2iBfSaUujupQ==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net] net: dsa: mv88e6xxx: Unforce speed & duplex in mac_link_down()
Date:   Sat, 11 Dec 2021 23:51:41 +0100
Message-Id: <20211211225141.6626-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 64d47d50be7a ("net: dsa: mv88e6xxx: configure interface settings
in mac_config") removed forcing of speed and duplex from
mv88e6xxx_mac_config(), where the link is forced down, and left it only
in mv88e6xxx_mac_link_up(), by which time link is unforced.

It seems that (at least on 88E6190) when changing cmode to 2500base-x,
if the link is not forced down, but the speed or duplex are still
forced, the forcing of new settings for speed & duplex doesn't take in
mv88e6xxx_mac_link_up().

Fix this by unforcing speed & duplex in mv88e6xxx_mac_link_down().

Fixes: 64d47d50be7a ("net: dsa: mv88e6xxx: configure interface settings in mac_config")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 14f87f6ac479..cd8462d1e27c 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -768,6 +768,10 @@ static void mv88e6xxx_mac_link_down(struct dsa_switch *ds, int port,
 	if ((!mv88e6xxx_port_ppu_updates(chip, port) ||
 	     mode == MLO_AN_FIXED) && ops->port_sync_link)
 		err = ops->port_sync_link(chip, port, mode, false);
+
+	if (!err && ops->port_set_speed_duplex)
+		err = ops->port_set_speed_duplex(chip, port, SPEED_UNFORCED,
+						 DUPLEX_UNFORCED);
 	mv88e6xxx_reg_unlock(chip);
 
 	if (err)
-- 
2.32.0

