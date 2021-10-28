Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F3843E1E3
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbhJ1NUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:20:36 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:53431 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbhJ1NUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 09:20:35 -0400
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 37921200021;
        Thu, 28 Oct 2021 13:18:05 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Russell King <linux@armlinux.org.uk>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: [PATCH net-next v2] net: ipconfig: Release the rtnl_lock while waiting for carrier
Date:   Thu, 28 Oct 2021 15:18:04 +0200
Message-Id: <20211028131804.413243-1-maxime.chevallier@bootlin.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While waiting for a carrier to come on one of the netdevices, some
devices will require to take the rtnl lock at some point to fully
initialize all parts of the link.

That's the case for SFP, where the rtnl is taken when a module gets
detected. This prevents mounting an NFS rootfs over an SFP link.

This means that while ipconfig waits for carriers to be detected, no SFP
modules can be detected in the meantime, it's only detected after
ipconfig times out.

This commit releases the rtnl_lock while waiting for the carrier to come
up, and re-takes it to check the for the init device and carrier status.

Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
v2: - Following Antoine's review, release the lock earlier and only
explicitely protect the for_each_netdev loop
    - Rebased and targeted the patch towards net-next
    - Dropped the Fixes tag

 net/ipv4/ipconfig.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 816d8aad5a68..9d41d5d5cd1e 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -262,6 +262,11 @@ static int __init ic_open_devs(void)
 				 dev->name, able, d->xid);
 		}
 	}
+	/* Devices with a complex topology like SFP ethernet interfaces needs
+	 * the rtnl_lock at init. The carrier wait-loop must therefore run
+	 * without holding it.
+	 */
+	rtnl_unlock();
 
 	/* no point in waiting if we could not bring up at least one device */
 	if (!ic_first_dev)
@@ -274,9 +279,13 @@ static int __init ic_open_devs(void)
 			   msecs_to_jiffies(carrier_timeout * 1000))) {
 		int wait, elapsed;
 
+		rtnl_lock();
 		for_each_netdev(&init_net, dev)
-			if (ic_is_init_dev(dev) && netif_carrier_ok(dev))
+			if (ic_is_init_dev(dev) && netif_carrier_ok(dev)) {
+				rtnl_unlock();
 				goto have_carrier;
+			}
+		rtnl_unlock();
 
 		msleep(1);
 
@@ -289,7 +298,6 @@ static int __init ic_open_devs(void)
 		next_msg = jiffies + msecs_to_jiffies(20000);
 	}
 have_carrier:
-	rtnl_unlock();
 
 	*last = NULL;
 
-- 
2.25.4

