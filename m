Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 622532AA014
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:21:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgKFWU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:20:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729092AbgKFWTB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:19:01 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00519221FE;
        Fri,  6 Nov 2020 22:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701140;
        bh=LJtDaUHH63i3o2EMXP8szuWYRpl83P553+fUvMeSGK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=inKXSx7pu4OlpdzCD5Ep6OcHlKJRGvMAxzNAl2slHhIwVAxkcTQLSF9WIdiliNBcA
         WWlqw4cwyVvis73M4kp0tBT0Ckf0DK+JRoz8CDsxpgTTnZ4bqmS86gVWOviRFkdiGa
         6uIquNqkO2we+L3RPOsWxawVmwrOMXxbf3eUuvnA=
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
Subject: [RFC net-next 23/28] airo: use ndo_siocdevprivate
Date:   Fri,  6 Nov 2020 23:17:38 +0100
Message-Id: <20201106221743.3271965-24-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The airo driver overloads SIOCDEVPRIVATE ioctls with another
set based on SIOCIWFIRSTPRIV. Only the first ones actually
work (also in compat mode) as the others do not get passed
down any more.

Change it over to ndo_siocdevprivate for clarification.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/cisco/airo.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 87b9398b03fd..045b9bb4db5d 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -1142,7 +1142,7 @@ static int waitbusy(struct airo_info *ai);
 static irqreturn_t airo_interrupt(int irq, void* dev_id);
 static int airo_thread(void *data);
 static void timer_func(struct net_device *dev);
-static int airo_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
+static int airo_siocdevprivate(struct net_device *dev, struct ifreq *rq, void __user *, int cmd);
 static struct iw_statistics *airo_get_wireless_stats(struct net_device *dev);
 static void airo_read_wireless_stats(struct airo_info *local);
 #ifdef CISCO_EXT
@@ -2668,7 +2668,7 @@ static const struct net_device_ops airo11_netdev_ops = {
 	.ndo_start_xmit 	= airo_start_xmit11,
 	.ndo_get_stats 		= airo_get_stats,
 	.ndo_set_mac_address	= airo_set_mac_address,
-	.ndo_do_ioctl		= airo_ioctl,
+	.ndo_siocdevprivate	= airo_siocdevprivate,
 };
 
 static void wifi_setup(struct net_device *dev)
@@ -2768,7 +2768,7 @@ static const struct net_device_ops airo_netdev_ops = {
 	.ndo_get_stats		= airo_get_stats,
 	.ndo_set_rx_mode	= airo_set_multicast_list,
 	.ndo_set_mac_address	= airo_set_mac_address,
-	.ndo_do_ioctl		= airo_ioctl,
+	.ndo_siocdevprivate	= airo_siocdevprivate,
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
@@ -2779,7 +2779,7 @@ static const struct net_device_ops mpi_netdev_ops = {
 	.ndo_get_stats		= airo_get_stats,
 	.ndo_set_rx_mode	= airo_set_multicast_list,
 	.ndo_set_mac_address	= airo_set_mac_address,
-	.ndo_do_ioctl		= airo_ioctl,
+	.ndo_siocdevprivate	= airo_siocdevprivate,
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
@@ -7650,7 +7650,8 @@ static const struct iw_handler_def	airo_handler_def =
  * Javier Achirica did a great job of merging code from the unnamed CISCO
  * developer that added support for flashing the card.
  */
-static int airo_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+static int airo_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+				void __user *data, int cmd)
 {
 	int rc = 0;
 	struct airo_info *ai = dev->ml_priv;
@@ -7667,7 +7668,7 @@ static int airo_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	{
 		int val = AIROMAGIC;
 		aironet_ioctl com;
-		if (copy_from_user(&com, rq->ifr_data, sizeof(com)))
+		if (copy_from_user(&com, data, sizeof(com)))
 			rc = -EFAULT;
 		else if (copy_to_user(com.data, (char *)&val, sizeof(val)))
 			rc = -EFAULT;
@@ -7683,7 +7684,7 @@ static int airo_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 		 */
 	{
 		aironet_ioctl com;
-		if (copy_from_user(&com, rq->ifr_data, sizeof(com))) {
+		if (copy_from_user(&com, data, sizeof(com))) {
 			rc = -EFAULT;
 			break;
 		}
-- 
2.27.0

