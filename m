Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA9C3CFD41
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239877AbhGTOek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:34:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:55716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235623AbhGTORU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:17:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 189EF6124B;
        Tue, 20 Jul 2021 14:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792428;
        bh=JFtN3ZKMtFz0ojZN3FkkCYerT3CMEu7AWD0A2O8UDIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jVsvPtu/wdNvHw0ILxeGfEXr9Da+vPo03yMK6qgPGHBaOMOROorTq9k2I46SFGhd5
         RMyvuIVcA+WlU+QtJumyz/1a0mqBIrJHgKrZEeLv7Ob1SAAR3sAbUa4yI4/SFk4HcP
         JvqKOYQxj0oW1BllMUvKMSGfI9usWylLBROi6PuPbrPSoOi8kTxiZz3NQ2Eig+LB+p
         Ij6UDp+2YC/kCzpVMTtinAN0YXaxmcD9bm2iGvGoqmJzq+B+46QhfGzhqHL/MQ9gm6
         qdcAmcWS5UUORtwM7MF3z8svDi6MjHNyuJWRttRz2BzXwD/xp/Z7SRH2ZaXFu7Ls8d
         y0q0mGOTramVQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 14/31] net: usb: use ndo_siocdevprivate
Date:   Tue, 20 Jul 2021 16:46:21 +0200
Message-Id: <20210720144638.2859828-15-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
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
 drivers/net/usb/pegasus.c | 5 +++--
 drivers/net/usb/rtl8150.c | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
index 9a907182569c..0475ef0efdca 100644
--- a/drivers/net/usb/pegasus.c
+++ b/drivers/net/usb/pegasus.c
@@ -987,7 +987,8 @@ static const struct ethtool_ops ops = {
 	.set_link_ksettings = pegasus_set_link_ksettings,
 };
 
-static int pegasus_ioctl(struct net_device *net, struct ifreq *rq, int cmd)
+static int pegasus_siocdevprivate(struct net_device *net, struct ifreq *rq,
+				  void __user *udata, int cmd)
 {
 	__u16 *data = (__u16 *) &rq->ifr_ifru;
 	pegasus_t *pegasus = netdev_priv(net);
@@ -1245,7 +1246,7 @@ static int pegasus_resume(struct usb_interface *intf)
 static const struct net_device_ops pegasus_netdev_ops = {
 	.ndo_open =			pegasus_open,
 	.ndo_stop =			pegasus_close,
-	.ndo_do_ioctl =			pegasus_ioctl,
+	.ndo_siocdevprivate =		pegasus_siocdevprivate,
 	.ndo_start_xmit =		pegasus_start_xmit,
 	.ndo_set_rx_mode =		pegasus_set_multicast,
 	.ndo_tx_timeout =		pegasus_tx_timeout,
diff --git a/drivers/net/usb/rtl8150.c b/drivers/net/usb/rtl8150.c
index 7656f2a3afd9..4a1b0e0fc3a3 100644
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
2.29.2

