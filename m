Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C68642DB10B
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:15:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730789AbgLOQN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:13:56 -0500
Received: from 95-31-39-132.broadband.corbina.ru ([95.31.39.132]:52684 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729766AbgLOQNr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 11:13:47 -0500
Received: from metamini.metanet (metamini.metanet [192.168.2.5])
        by blackbox.su (Postfix) with ESMTP id EFE7F80496;
        Tue, 15 Dec 2020 19:12:57 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blackbox.su; s=mail;
        t=1608048778; bh=5K8IvY3lKlWHV9M2KlZ4zCcf8qQd74FViqIFuXxtE2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXyvlQFa5jJ0nR7HBWPd3x1zTFF06vBkAme89/jH0lgToGjFFo0b5JRz6OdukBrnD
         7ECInII0HEoR8JlcJDpuacwG3Vrh3G1S9BIElJm7uMONzo3BGjLZyT3JtlQynMt2sF
         EsmDuMiVocxKJdCzdEGX6M86eVmTVf+0VANmuRfPa7w9mJWRQYQbb7pIcs+RfQEB8c
         jlzAZQNpWv3CMKEdimqPjrIJAyNIHWb+fDshlJ+Atmlai8hipbVyCRpawtv3uEqPLV
         r/LaztjQ9DlmAvuCIyW7ZieTE1VbO3/yO+pUgjvS6l0R/csPldDhKOclVN5Rg768/7
         gPAOvHW1/jtBA==
From:   Sergej Bauer <sbauer@blackbox.su>
Cc:     andrew@lunn.ch, Markus.Elfring@web.de, thesven73@gmail.com,
        sbauer@blackbox.su, Jakub Kicinski <kuba@kernel.org>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4] lan743x: fix for potential NULL pointer dereference with bare card
Date:   Tue, 15 Dec 2020 19:12:45 +0300
Message-Id: <20201215161252.8448-1-sbauer@blackbox.su>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201127083925.4813c57a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20201127083925.4813c57a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the 4th revision of the patch fix for potential null pointer dereference
with lan743x card.

The simpliest way to reproduce: boot with bare lan743x and issue "ethtool ethN"
command where ethN is the interface with lan743x card. Example:

$ sudo ethtool eth7
dmesg:
[  103.510336] BUG: kernel NULL pointer dereference, address: 0000000000000340
...
[  103.510836] RIP: 0010:phy_ethtool_get_wol+0x5/0x30 [libphy]
...
[  103.511629] Call Trace:
[  103.511666]  lan743x_ethtool_get_wol+0x21/0x40 [lan743x]
[  103.511724]  dev_ethtool+0x1507/0x29d0
[  103.511769]  ? avc_has_extended_perms+0x17f/0x440
[  103.511820]  ? tomoyo_init_request_info+0x84/0x90
[  103.511870]  ? tomoyo_path_number_perm+0x68/0x1e0
[  103.511919]  ? tty_insert_flip_string_fixed_flag+0x82/0xe0
[  103.511973]  ? inet_ioctl+0x187/0x1d0
[  103.512016]  dev_ioctl+0xb5/0x560
[  103.512055]  sock_do_ioctl+0xa0/0x140
[  103.512098]  sock_ioctl+0x2cb/0x3c0
[  103.512139]  __x64_sys_ioctl+0x84/0xc0
[  103.512183]  do_syscall_64+0x33/0x80
[  103.512224]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  103.512274] RIP: 0033:0x7f54a9cba427
...

Previous versions can be found at:
v1:
initial version
    https://lkml.org/lkml/2020/10/28/921

v2:
do not return from lan743x_ethtool_set_wol if netdev->phydev == NULL, just skip
the call of phy_ethtool_set_wol() instead.
    https://lkml.org/lkml/2020/10/31/380

v3:
in function lan743x_ethtool_set_wol:
use ternary operator instead of if-else sentence (review by Markus Elfring)
return -ENETDOWN instead of -EIO (review by Andrew Lunn)

v4:
Sven Van Asbruck noticed that the patch was being applied cleanly to the 5.9
branch, so the tag “Fixes” was added as Jakub suggested.

Signed-off-by: Sergej Bauer <sbauer@blackbox.su>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Fixes: 4d94282afd95 ("lan743x: Add power management support")
---
diff --git a/drivers/net/ethernet/microchip/lan743x_ethtool.c b/drivers/net/ethernet/microchip/lan743x_ethtool.c
index dcde496da7fb..c5de8f46cdd3 100644
--- a/drivers/net/ethernet/microchip/lan743x_ethtool.c
+++ b/drivers/net/ethernet/microchip/lan743x_ethtool.c
@@ -780,7 +780,9 @@ static void lan743x_ethtool_get_wol(struct net_device *netdev,
 
 	wol->supported = 0;
 	wol->wolopts = 0;
-	phy_ethtool_get_wol(netdev->phydev, wol);
+
+	if (netdev->phydev)
+		phy_ethtool_get_wol(netdev->phydev, wol);
 
 	wol->supported |= WAKE_BCAST | WAKE_UCAST | WAKE_MCAST |
 		WAKE_MAGIC | WAKE_PHY | WAKE_ARP;
@@ -809,9 +811,8 @@ static int lan743x_ethtool_set_wol(struct net_device *netdev,
 
 	device_set_wakeup_enable(&adapter->pdev->dev, (bool)wol->wolopts);
 
-	phy_ethtool_set_wol(netdev->phydev, wol);
-
-	return 0;
+	return netdev->phydev ? phy_ethtool_set_wol(netdev->phydev, wol)
+			: -ENETDOWN;
 }
 #endif /* CONFIG_PM */
 
