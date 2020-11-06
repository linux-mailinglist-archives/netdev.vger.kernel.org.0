Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCE9B2A9FE2
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729070AbgKFWSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:18:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:42002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729049AbgKFWSi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:18:38 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DC1421D81;
        Fri,  6 Nov 2020 22:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701117;
        bh=/cpDjwa8dOkb01yFtUHo3+36yqs3G0WmNes6UhKpcxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbTQSTmHZ0f7QKkEEQGaFRuwKQy1MxygJVIz6jojqveklKc4+zOzk9u3OWxiBvSSq
         4Uudn8oPtMe4nsAthvwJKH6FjYr4nluegVUd/PmHn9cNTSzJqu9jX0yIOAAkKX9hQi
         r2tYL6RbzFOcphYfGdo5Dxv0xP2zBr/GLGZxgr8w=
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
Subject: [RFC net-next 15/28] net: usb: use ndo_siocdevprivate
Date:   Fri,  6 Nov 2020 23:17:30 +0100
Message-Id: <20201106221743.3271965-16-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The pegasus and rtl8150 drivers use SIOCDEVPRIVATE ioctls
to access their MII registers, in place of the normal
commands. This is broken for all compat ioctls today.

Change to ndo_siocdevprivate to fix it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/usb/pegasus.c | 4 ++--
 drivers/net/usb/rtl8150.c | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 32e1335c94ad..7cc0727eee1a 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -988,7 +988,7 @@ static const struct ethtool_ops ops = {
 	.set_link_ksettings = pegasus_set_link_ksettings,
 };
 
-static int pegasus_ioctl(struct net_device *net, struct ifreq *rq, int cmd)
+static int pegasus_siocdevprivate(struct net_device *net, struct ifreq *rq, void __user *udata, int cmd)
 {
 	__u16 *data = (__u16 *) &rq->ifr_ifru;
 	pegasus_t *pegasus = netdev_priv(net);
@@ -1246,7 +1246,7 @@ static int pegasus_resume(struct usb_interface *intf)
 static const struct net_device_ops pegasus_netdev_ops = {
 	.ndo_open =			pegasus_open,
 	.ndo_stop =			pegasus_close,
-	.ndo_do_ioctl =			pegasus_ioctl,
+	.ndo_siocdevprivate =		pegasus_siocdevprivate,
 	.ndo_start_xmit =		pegasus_start_xmit,
 	.ndo_set_rx_mode =		pegasus_set_multicast,
 	.ndo_tx_timeout =		pegasus_tx_timeout,
diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index bf8a60533f3e..bb37fb24f7d7 100644
--- a/drivers/net/usb/rtl8150.c
+++ b/drivers/net/usb/rtl8150.c
@@ -822,7 +822,8 @@ static const struct ethtool_ops ops = {
 	.get_link_ksettings = rtl8150_get_link_ksettings,
 };
 
-static int rtl8150_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
+static int rtl8150_siocdevprivate(struct net_device *netdev, struct ifreq *rq,
+				  void __user *udata, int cmd)
 {
 	rtl8150_t *dev = netdev_priv(netdev);
 	u16 *data = (u16 *) & rq->ifr_ifru;
@@ -850,7 +851,7 @@ static int rtl8150_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
 static const struct net_device_ops rtl8150_netdev_ops = {
 	.ndo_open		= rtl8150_open,
 	.ndo_stop		= rtl8150_close,
-	.ndo_do_ioctl		= rtl8150_ioctl,
+	.ndo_siocdevprivate	= rtl8150_siocdevprivate,
 	.ndo_start_xmit		= rtl8150_start_xmit,
 	.ndo_tx_timeout		= rtl8150_tx_timeout,
 	.ndo_set_rx_mode	= rtl8150_set_multicast,
-- 
2.27.0

