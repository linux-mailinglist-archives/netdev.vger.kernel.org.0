Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2E92AA034
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgKFWSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:18:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728915AbgKFWSP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:18:15 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48D73208C7;
        Fri,  6 Nov 2020 22:18:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701094;
        bh=0nZsvJC7bKvsWii/4F8rVLDyxbI5Zs8ZxzeJcfM4j+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYhuh1WeMtLDKBKefKeaic5NUOJzadJ53FzEB2UQXzCEHinw7qCsI6CYtNMqeEdoy
         6S+yFjM7lHpx1DLzo4Uj1ON7HLGgFJLCfQxucvGzoWLz9fYorSMk3baiAp5pVpG2hb
         Zn0EDsMTOs9P9nrFdTdwsyIEN5Us7lupQKr+BlvM=
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
Subject: [RFC net-next 07/28] phonet: use siocdevprivate
Date:   Fri,  6 Nov 2020 23:17:22 +0100
Message-Id: <20201106221743.3271965-8-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

phonet has a single private ioctl that is broken in compat
mode on big-endian machines today because the data returned
from it is never copied back to user space.

Move it over to the ndo_siocdevprivate callback, which also
fixes the compat issue.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/usb/cdc-phonet.c | 5 +++--
 net/phonet/pn_dev.c          | 6 +++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/cdc-phonet.c b/drivers/net/usb/cdc-phonet.c
index dba847f28096..5f6d34acf871 100644
--- a/drivers/net/usb/cdc-phonet.c
+++ b/drivers/net/usb/cdc-phonet.c
@@ -253,7 +253,8 @@ static int usbpn_close(struct net_device *dev)
 	return usb_set_interface(pnd->usb, num, !pnd->active_setting);
 }
 
-static int usbpn_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int usbpn_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+				void __user *data, int cmd)
 {
 	struct if_phonet_req *req = (struct if_phonet_req *)ifr;
 
@@ -269,7 +270,7 @@ static const struct net_device_ops usbpn_ops = {
 	.ndo_open	= usbpn_open,
 	.ndo_stop	= usbpn_close,
 	.ndo_start_xmit = usbpn_xmit,
-	.ndo_do_ioctl	= usbpn_ioctl,
+	.ndo_siocdevprivate = usbpn_siocdevprivate,
 };
 
 static void usbpn_setup(struct net_device *dev)
diff --git a/net/phonet/pn_dev.c b/net/phonet/pn_dev.c
index ac0fae06cc15..876d0ae5f9fd 100644
--- a/net/phonet/pn_dev.c
+++ b/net/phonet/pn_dev.c
@@ -233,11 +233,11 @@ static int phonet_device_autoconf(struct net_device *dev)
 	struct if_phonet_req req;
 	int ret;
 
-	if (!dev->netdev_ops->ndo_do_ioctl)
+	if (!dev->netdev_ops->ndo_siocdevprivate)
 		return -EOPNOTSUPP;
 
-	ret = dev->netdev_ops->ndo_do_ioctl(dev, (struct ifreq *)&req,
-						SIOCPNGAUTOCONF);
+	ret = dev->netdev_ops->ndo_siocdevprivate(dev, (struct ifreq *)&req,
+						  NULL, SIOCPNGAUTOCONF);
 	if (ret < 0)
 		return ret;
 
-- 
2.27.0

