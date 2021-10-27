Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B396843CA8A
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 15:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242116AbhJ0N1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 09:27:48 -0400
Received: from mslow1.mail.gandi.net ([217.70.178.240]:47215 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhJ0N1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 09:27:47 -0400
Received: from relay6-d.mail.gandi.net (unknown [217.70.183.198])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id C7827CAF2C;
        Wed, 27 Oct 2021 13:20:19 +0000 (UTC)
Received: (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 7D694C000D;
        Wed, 27 Oct 2021 13:19:56 +0000 (UTC)
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     davem@davemloft.net, Russell King <linux@armlinux.org.uk>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        thomas.petazzoni@bootlin.com
Subject: [RFC PATCH net] net: ipconfig: Release the rtnl_lock while waiting for carrier
Date:   Wed, 27 Oct 2021 15:19:53 +0200
Message-Id: <20211027131953.9270-1-maxime.chevallier@bootlin.com>
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

At that point, the rtnl_lock seems to be only protecting
ic_is_init_dev().

Fixes: 73970055450e ("sfp: add SFP module support")
Signed-off-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
---
I've sent this patch as an RFC (it doesn't look very clean indeed), since I'm
not fully familiar with the implications of modifying the locking scheme at
that point in the boot process. Please feel free to comment or suggest other
approaches.

 net/ipv4/ipconfig.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 816d8aad5a68..069ae05bd0a5 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -278,7 +278,12 @@ static int __init ic_open_devs(void)
 			if (ic_is_init_dev(dev) && netif_carrier_ok(dev))
 				goto have_carrier;
 
+		/* Give a chance to do complex initialization that
+		 * would require to take the rtnl lock.
+		 */
+		rtnl_unlock();
 		msleep(1);
+		rtnl_lock();
 
 		if (time_before(jiffies, next_msg))
 			continue;
-- 
2.25.4

