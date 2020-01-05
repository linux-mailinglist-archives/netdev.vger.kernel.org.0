Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4A911309FB
	for <lists+netdev@lfdr.de>; Sun,  5 Jan 2020 22:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgAEVRK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jan 2020 16:17:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:50066 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726792AbgAEVRJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jan 2020 16:17:09 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4078AB15D;
        Sun,  5 Jan 2020 21:17:07 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id E7E4CE048B; Sun,  5 Jan 2020 22:17:06 +0100 (CET)
Message-Id: <f7f3ec1f5e97bd40f6427ce554c3e4d9e0adb63d.1578257976.git.mkubecek@suse.cz>
In-Reply-To: <cover.1578257976.git.mkubecek@suse.cz>
References: <cover.1578257976.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH net-next 2/3] via-velocity: allow nesting of ethtool_ops
 begin() and complete()
To:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        Francois Romieu <romieu@fr.zoreil.com>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Date:   Sun,  5 Jan 2020 22:17:06 +0100 (CET)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unlike most networking drivers using begin() and complete() ethtool_ops
callbacks to resume a device which is down and suspend it again when done,
via-velocity does not use standard refcounted infrastructure but sets
device sleep state directly.

With the introduction of netlink ethtool interface, we may have nested
begin-complete blocks so that inner complete() would put the device back to
sleep for the rest of the outer block.

To avoid rewriting an old and not very actively developed driver, just add
a nesting counter and only perform resume and suspend on the outermost
level.

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 drivers/net/ethernet/via/via-velocity.c | 14 ++++++++++----
 drivers/net/ethernet/via/via-velocity.h |  1 +
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index 346e44115c4e..4b556b74541a 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -3257,12 +3257,16 @@ static struct platform_driver velocity_platform_driver = {
  *	@dev: network device
  *
  *	Called before an ethtool operation. We need to make sure the
- *	chip is out of D3 state before we poke at it.
+ *	chip is out of D3 state before we poke at it. In case of ethtool
+ *	ops nesting, only wake the device up in the outermost block.
  */
 static int velocity_ethtool_up(struct net_device *dev)
 {
 	struct velocity_info *vptr = netdev_priv(dev);
-	if (!netif_running(dev))
+
+	if (vptr->ethtool_ops_nesting == U32_MAX)
+		return -EBUSY;
+	if (!vptr->ethtool_ops_nesting++ && !netif_running(dev))
 		velocity_set_power_state(vptr, PCI_D0);
 	return 0;
 }
@@ -3272,12 +3276,14 @@ static int velocity_ethtool_up(struct net_device *dev)
  *	@dev: network device
  *
  *	Called after an ethtool operation. Restore the chip back to D3
- *	state if it isn't running.
+ *	state if it isn't running. In case of ethtool ops nesting, only
+ *	put the device to sleep in the outermost block.
  */
 static void velocity_ethtool_down(struct net_device *dev)
 {
 	struct velocity_info *vptr = netdev_priv(dev);
-	if (!netif_running(dev))
+
+	if (!--vptr->ethtool_ops_nesting && !netif_running(dev))
 		velocity_set_power_state(vptr, PCI_D3hot);
 }
 
diff --git a/drivers/net/ethernet/via/via-velocity.h b/drivers/net/ethernet/via/via-velocity.h
index cdfe7809e3c1..f196e71d2c04 100644
--- a/drivers/net/ethernet/via/via-velocity.h
+++ b/drivers/net/ethernet/via/via-velocity.h
@@ -1483,6 +1483,7 @@ struct velocity_info {
 	struct velocity_context context;
 
 	u32 ticks;
+	u32 ethtool_ops_nesting;
 
 	u8 rev_id;
 
-- 
2.24.1

