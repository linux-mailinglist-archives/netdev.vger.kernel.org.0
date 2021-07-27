Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D860C3D773B
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237225AbhG0Nq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:46:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:46636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236941AbhG0NqX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4A9961A80;
        Tue, 27 Jul 2021 13:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393583;
        bh=K/9qCrP8m6gI+8b1caSGXf+YkiuQeZbMwRHuwubVNy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SiBw9ELbHOmcW/p1rKwES5+uQFcMWb92v7gkqD9nBV8i4tEc0YXDetmBfMAq6DAcx
         i7r1BQ9JqtVqBchuEnPbj1ExEylPe8/9WqA11iClRRvt/VQbx8TDWVWRuwqh1w7Nqa
         owx+3s7dNvIYNYgTsL+Y3ZuQKYVgdp3tp77XvtxK0a1h4mh2gvC666r7RCFRZUeeTH
         wVPn+VGiyXJ1Ya0SYxxgGRaq1tDMd9ZqoMo1Fyy/drJU+V4MHaF03AbmjBxHvToHyP
         IbXb9fMix5vv3l56HyV4MB3aV7kPrNocTFglBunJME5aelMn6dVH98sFs94g2AqA6F
         hmDUab23M3hlA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Petko Manolov <petkan@nucleusys.com>, linux-usb@vger.kernel.org
Subject: [PATCH net-next v3 14/31] net: usb: use ndo_siocdevprivate
Date:   Tue, 27 Jul 2021 15:45:00 +0200
Message-Id: <20210727134517.1384504-15-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
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

Cc: Petko Manolov <petkan@nucleusys.com>
Cc: linux-usb@vger.kernel.org
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

