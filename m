Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5F442AA02A
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728814AbgKFWSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:18:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:41094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728055AbgKFWR5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:17:57 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D39F12087E;
        Fri,  6 Nov 2020 22:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701077;
        bh=nzhWms5vuZRRAWciYsS79GiwdEaX2soiPILlN+tvJKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LdAmxG3U4urOY/6fkI9PqtC/me9sbsLzKpCacBAVSQ/mcwfsBbJ4cpC4CV4Do2xrD
         aiTjAMSgGGO4/NxcBJ06LS16EiMsTOYV/EZfLjxjGYBvjTuJczVP43Oc9wqc9TIfm8
         Eb7FTqm+alG3Y0CDPbAs1NPN3j4EHKQIzrGpyYf0=
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-hams@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [RFC net-next 01/28] net: split out SIOCDEVPRIVATE handling from dev_ioctl
Date:   Fri,  6 Nov 2020 23:17:16 +0100
Message-Id: <20201106221743.3271965-2-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

SIOCDEVPRIVATE ioctl commands are mainly used in really old
drivers, and they have a number of problems:

- They hide behind the normal .ndo_do_ioctl function that
  is also used for other things in modern drivers, so it's
  hard to spot a driver that actually uses one of these

- Since drivers use a number different calling conventions,
  it is impossible to support compat mode for them in
  a generic way.

- With all drivers using the same 16 commands codes, there
  is no way to introspect the data being passed through
  things like strace.

Add a new net_device_ops callback pointer, to address the
first two of these. Separating them from .ndo_do_ioctl
makes it easy to grep for drivers with a .ndo_siocdevprivate
callback, and the unwieldy name hopefully makes it easier
to spot in code review.

By passing the ifreq structure and the ifr_data pointer
separately, it is no longer necessary to overload these,
and the driver can use either one for a given command.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/netdevice.h |  3 +++
 net/core/dev_ioctl.c      | 25 ++++++++++++++++++++++---
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d1b7fb1241b3..93f980e1d69b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1301,6 +1301,9 @@ struct net_device_ops {
 	int			(*ndo_validate_addr)(struct net_device *dev);
 	int			(*ndo_do_ioctl)(struct net_device *dev,
 					        struct ifreq *ifr, int cmd);
+	int			(*ndo_siocdevprivate)(struct net_device *dev,
+						struct ifreq *ifr,
+						void __user *data, int cmd);
 	int			(*ndo_set_config)(struct net_device *dev,
 					          struct ifmap *map);
 	int			(*ndo_change_mtu)(struct net_device *dev,
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 5822737a78f4..58daf41a4a08 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -269,6 +269,23 @@ static int dev_do_ioctl(struct net_device *dev,
 	return err;
 }
 
+static int dev_siocdevprivate(struct net_device *dev,
+			      struct ifreq *ifr, unsigned int cmd)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	void __user *data = ifr->ifr_data;
+
+	if (ops->ndo_siocdevprivate) {
+		if (netif_device_present(dev))
+			return ops->ndo_siocdevprivate(dev, ifr, data, cmd);
+		else
+			return -ENODEV;
+	}
+
+	/* fall back to do_ioctl for drivers not yet converted */
+	return dev_do_ioctl(dev, ifr, cmd);
+}
+
 /*
  *	Perform the SIOCxIFxxx calls, inside rtnl_lock()
  */
@@ -346,9 +363,11 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, unsigned int cmd)
 	 *	Unknown or private ioctl
 	 */
 	default:
-		if ((cmd >= SIOCDEVPRIVATE &&
-		    cmd <= SIOCDEVPRIVATE + 15) ||
-		    cmd == SIOCBONDENSLAVE ||
+		if (cmd >= SIOCDEVPRIVATE &&
+		    cmd <= SIOCDEVPRIVATE + 15)
+			return dev_siocdevprivate(dev, ifr, cmd);
+
+		if (cmd == SIOCBONDENSLAVE ||
 		    cmd == SIOCBONDRELEASE ||
 		    cmd == SIOCBONDSETHWADDR ||
 		    cmd == SIOCBONDSLAVEINFOQUERY ||
-- 
2.27.0

