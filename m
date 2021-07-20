Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675853CFD86
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239958AbhGTOrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:47:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:57358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239955AbhGTOVt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:21:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FC6F61283;
        Tue, 20 Jul 2021 14:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792438;
        bh=OcI4JLWx9byD07inpb1StFBsTxVVAV4+ZA6Ud/7IWqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxLP3Q3U+0CRLxrLFYEHs8jMJaa99SIiCB/jTFLbiwfYx847WGkG0zJ415yGTowHb
         VgGTjESijOfQ7nBDsFvzkWVj9cG4+wXZY0DIffdRO1McebDvFn2eJ3vC+uJUX4Cag4
         DQTpONQDbCj9BjpUwUkrsgk6zBLE8gUhK0GZ4V2+ytm85pcvHl0eU5HRrSzA9q2X+J
         pSrvzCN/A6/UiCx6ejOxLd25rnolmC1EpwH9eEX0TwI5CDy6MLZY0XgUCdaDcTSnmK
         wS0KBtUiehCom1D+pInimY+/bFImwwwES7IzUQodclQMSC0MeS1iVtbp3hVv2xN7d7
         y4vhC+FrnwlAg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 22/31] sb1000: use ndo_siocdevprivate
Date:   Tue, 20 Jul 2021 16:46:29 +0200
Message-Id: <20210720144638.2859828-23-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
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
index e88af978f63c..f01c9db01b16 100644
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
+		if (copy_to_user(data, stats, sizeof(stats)))
 			return -EFAULT;
 		status = 0;
 		break;
@@ -1019,21 +1021,21 @@ static int sb1000_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case SIOCGCMFIRMWARE:		/* get firmware version */
 		if ((status = sb1000_get_firmware_version(ioaddr, name, version, 1)))
 			return status;
-		if(copy_to_user(ifr->ifr_data, version, sizeof(version)))
+		if (copy_to_user(data, version, sizeof(version)))
 			return -EFAULT;
 		break;
 
 	case SIOCGCMFREQUENCY:		/* get frequency */
 		if ((status = sb1000_get_frequency(ioaddr, name, &frequency)))
 			return status;
-		if(put_user(frequency, (int __user *) ifr->ifr_data))
+		if (put_user(frequency, (int __user *)data))
 			return -EFAULT;
 		break;
 
 	case SIOCSCMFREQUENCY:		/* set frequency */
 		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
-		if(get_user(frequency, (int __user *) ifr->ifr_data))
+		if (get_user(frequency, (int __user *)data))
 			return -EFAULT;
 		if ((status = sb1000_set_frequency(ioaddr, name, frequency)))
 			return status;
@@ -1042,14 +1044,14 @@ static int sb1000_dev_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case SIOCGCMPIDS:			/* get PIDs */
 		if ((status = sb1000_get_PIDs(ioaddr, name, PID)))
 			return status;
-		if(copy_to_user(ifr->ifr_data, PID, sizeof(PID)))
+		if (copy_to_user(data, PID, sizeof(PID)))
 			return -EFAULT;
 		break;
 
 	case SIOCSCMPIDS:			/* set PIDs */
 		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
-		if(copy_from_user(PID, ifr->ifr_data, sizeof(PID)))
+		if (copy_from_user(PID, data, sizeof(PID)))
 			return -EFAULT;
 		if ((status = sb1000_set_PIDs(ioaddr, name, PID)))
 			return status;
-- 
2.29.2

