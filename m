Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92272A2235
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 23:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbgKAWf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 17:35:59 -0500
Received: from 95-31-39-132.broadband.corbina.ru ([95.31.39.132]:56408 "EHLO
        blackbox.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727081AbgKAWf6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Nov 2020 17:35:58 -0500
Received: from metamini.metanet (metamini.metanet [192.168.2.5])
        by blackbox.su (Postfix) with ESMTP id 20A2882D0D;
        Mon,  2 Nov 2020 01:35:59 +0300 (MSK)
From:   Sergej Bauer <sbauer@blackbox.su>
Cc:     andrew@lunn.ch, Markus.Elfring@web.de, sbauer@blackbox.su,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] lan743x: fix for potential NULL pointer dereference with bare card
Date:   Mon,  2 Nov 2020 01:35:55 +0300
Message-Id: <20201101223556.16116-1-sbauer@blackbox.su>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <220201101203820.GD1109407@lunn.ch>
References: <220201101203820.GD1109407@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the 3rd revision of the patch fix for potential null pointer dereference
with lan743x card.

The simpliest way to reproduce: boot with bare lan743x and issue "ethtool ethN"
commant where ethN is the interface with lan743x card. Example:

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
return -ENETDOWN insted of -EIO (review by Andrew Lunn)

Signed-off-by: Sergej Bauer <sbauer@blackbox.su>
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
 
