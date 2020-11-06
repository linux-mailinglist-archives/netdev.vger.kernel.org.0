Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3CDE2A9FFD
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbgKFWTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:19:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729198AbgKFWTK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:19:10 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C64F22203;
        Fri,  6 Nov 2020 22:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701148;
        bh=pEjO8MOIRZIJ7Ooiru/CipOAPrgkHN/unK+fIxgV7T0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dRtd5q1iL4QqZGn3xToh9+nA8yInKonADzu22FwHKwMf7SgG/l4MRxe5OVhPDXH33
         EIJJrFiBhB8Ax7YONIBF6yaX9ZLbUZTLYg5xjtv33W/Pz+jMLZzbck6NsF9OIpIH5e
         JyVaEvLkDAn7MPbmbxnyQ9w5KkXmSN8v9DvbPWvQ=
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
Subject: [RFC net-next 26/28] sb1000: use ndo_siocdevprivate
Date:   Fri,  6 Nov 2020 23:17:41 +0100
Message-Id: <20201106221743.3271965-27-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The private sb1000 ioctl commands all work correctly in
compat mode. Change the to ndo_siocdevprivate as a cleanup.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/sb1000.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/sb1000.c b/drivers/net/sb1000.c
index e88af978f63c..9b14087be900 100644
--- a/drivers/net/sb1000.c
+++ b/drivers/net/sb1000.c
@@ -78,7 +78,8 @@ struct sb1000_private {
 /* prototypes for Linux interface */
 extern int sb1000_probe(struct net_device *dev);
 static int sb1000_open(struct net_device *dev);
-static int sb1000_dev_ioctl (struct net_device *dev, struct ifreq *ifr, int cmd);
+static int sb1000_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+				 void __user *data, int cmd);
 static netdev_tx_t sb1000_start_xmit(struct sk_buff *skb,
 				     struct net_device *dev);
 static irqreturn_t sb1000_interrupt(int irq, void *dev_id);
@@ -135,7 +136,7 @@ MODULE_DEVICE_TABLE(pnp, sb1000_pnp_ids);
 static const struct net_device_ops sb1000_netdev_ops = {
 	.ndo_open		= sb1000_open,
 	.ndo_start_xmit		= sb1000_start_xmit,
-	.ndo_do_ioctl		= sb1000_dev_ioctl,
+	.ndo_siocdevprivate	= sb1000_siocdevprivate,
 	.ndo_stop		= sb1000_close,
 	.ndo_set_mac_address 	= eth_mac_addr,
 	.ndo_validate_addr	= eth_validate_addr,
@@ -987,7 +988,8 @@ sb1000_open(struct net_device *dev)
 	return 0;					/* Always succeed */
 }
 
-static int sb1000_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
+static int sb1000_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+				 void __user *data, int cmd)
 {
 	char* name;
 	unsigned char version[2];
@@ -1011,7 +1013,7 @@ static int sb1000_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		stats[2] = dev->stats.rx_packets;
 		stats[3] = dev->stats.rx_errors;
 		stats[4] = dev->stats.rx_dropped;
-		if(copy_to_user(ifr->ifr_data, stats, sizeof(stats)))
+		if(copy_to_user(data, stats, sizeof(stats)))
 			return -EFAULT;
 		status = 0;
 		break;
@@ -1019,21 +1021,21 @@ static int sb1000_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case SIOCGCMFIRMWARE:		/* get firmware version */
 		if ((status = sb1000_get_firmware_version(ioaddr, name, version, 1)))
 			return status;
-		if(copy_to_user(ifr->ifr_data, version, sizeof(version)))
+		if(copy_to_user(data, version, sizeof(version)))
 			return -EFAULT;
 		break;
 
 	case SIOCGCMFREQUENCY:		/* get frequency */
 		if ((status = sb1000_get_frequency(ioaddr, name, &frequency)))
 			return status;
-		if(put_user(frequency, (int __user *) ifr->ifr_data))
+		if(put_user(frequency, (int __user *) data))
 			return -EFAULT;
 		break;
 
 	case SIOCSCMFREQUENCY:		/* set frequency */
 		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
-		if(get_user(frequency, (int __user *) ifr->ifr_data))
+		if(get_user(frequency, (int __user *) data))
 			return -EFAULT;
 		if ((status = sb1000_set_frequency(ioaddr, name, frequency)))
 			return status;
@@ -1042,14 +1044,14 @@ static int sb1000_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case SIOCGCMPIDS:			/* get PIDs */
 		if ((status = sb1000_get_PIDs(ioaddr, name, PID)))
 			return status;
-		if(copy_to_user(ifr->ifr_data, PID, sizeof(PID)))
+		if(copy_to_user(data, PID, sizeof(PID)))
 			return -EFAULT;
 		break;
 
 	case SIOCSCMPIDS:			/* set PIDs */
 		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
-		if(copy_from_user(PID, ifr->ifr_data, sizeof(PID)))
+		if(copy_from_user(PID, data, sizeof(PID)))
 			return -EFAULT;
 		if ((status = sb1000_set_PIDs(ioaddr, name, PID)))
 			return status;
-- 
2.27.0

