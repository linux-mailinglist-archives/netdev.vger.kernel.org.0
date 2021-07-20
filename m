Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB0F3CFD58
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:22:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240668AbhGTOjX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239380AbhGTOSs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:18:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CF9F61279;
        Tue, 20 Jul 2021 14:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792434;
        bh=NndkhHBAfcK3BOw3uZFcRUtMwL8nmX7mrOZ0tORohmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FN5enucZuBk03TSg7sL9i+0kuTrG2HR6ZkKNokqTEWjC3uCOHgnrBcyhipwpX5i7D
         U+8u7O743IjRaNiTqhJvMryQFGKaFeK2cT8/G01sOS5PJCztQXIr2K4e/XXr8YN5+x
         Qjj3W8m8lBwnwcqPPXyt2SfqFUjY6llp1CM8I44s8+wR4DuFhQVEvGeHPEEASaot8W
         YmIvkyFVpus0cLEXBFQN/KhZU6A/W8czX2G13JnWkQ3dBOLJnmPofybMUGpPUwS1XS
         d9voOv/a3osi5DreuWpOndsbx/CEvsbzvypFZDVgGkMClDkBLlcUJ5K3aYhbDiMbXB
         YX+nf42qYSWTw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 19/31] airo: use ndo_siocdevprivate
Date:   Tue, 20 Jul 2021 16:46:26 +0200
Message-Id: <20210720144638.2859828-20-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
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
index fd37d4d2983b..65dd8cff1b01 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -1144,7 +1144,7 @@ static int waitbusy(struct airo_info *ai);
 static irqreturn_t airo_interrupt(int irq, void* dev_id);
 static int airo_thread(void *data);
 static void timer_func(struct net_device *dev);
-static int airo_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
+static int airo_siocdevprivate(struct net_device *dev, struct ifreq *rq, void __user *, int cmd);
 static struct iw_statistics *airo_get_wireless_stats(struct net_device *dev);
 #ifdef CISCO_EXT
 static int readrids(struct net_device *dev, aironet_ioctl *comp);
@@ -2664,7 +2664,7 @@ static const struct net_device_ops airo11_netdev_ops = {
 	.ndo_start_xmit 	= airo_start_xmit11,
 	.ndo_get_stats 		= airo_get_stats,
 	.ndo_set_mac_address	= airo_set_mac_address,
-	.ndo_do_ioctl		= airo_ioctl,
+	.ndo_siocdevprivate	= airo_siocdevprivate,
 };
 
 static void wifi_setup(struct net_device *dev)
@@ -2764,7 +2764,7 @@ static const struct net_device_ops airo_netdev_ops = {
 	.ndo_get_stats		= airo_get_stats,
 	.ndo_set_rx_mode	= airo_set_multicast_list,
 	.ndo_set_mac_address	= airo_set_mac_address,
-	.ndo_do_ioctl		= airo_ioctl,
+	.ndo_siocdevprivate	= airo_siocdevprivate,
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
@@ -2775,7 +2775,7 @@ static const struct net_device_ops mpi_netdev_ops = {
 	.ndo_get_stats		= airo_get_stats,
 	.ndo_set_rx_mode	= airo_set_multicast_list,
 	.ndo_set_mac_address	= airo_set_mac_address,
-	.ndo_do_ioctl		= airo_ioctl,
+	.ndo_siocdevprivate	= airo_siocdevprivate,
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
@@ -7661,7 +7661,8 @@ static const struct iw_handler_def	airo_handler_def =
  * Javier Achirica did a great job of merging code from the unnamed CISCO
  * developer that added support for flashing the card.
  */
-static int airo_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+static int airo_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+			       void __user *data, int cmd)
 {
 	int rc = 0;
 	struct airo_info *ai = dev->ml_priv;
@@ -7678,7 +7679,7 @@ static int airo_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	{
 		int val = AIROMAGIC;
 		aironet_ioctl com;
-		if (copy_from_user(&com, rq->ifr_data, sizeof(com)))
+		if (copy_from_user(&com, data, sizeof(com)))
 			rc = -EFAULT;
 		else if (copy_to_user(com.data, (char *)&val, sizeof(val)))
 			rc = -EFAULT;
@@ -7694,7 +7695,7 @@ static int airo_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 		 */
 	{
 		aironet_ioctl com;
-		if (copy_from_user(&com, rq->ifr_data, sizeof(com))) {
+		if (copy_from_user(&com, data, sizeof(com))) {
 			rc = -EFAULT;
 			break;
 		}
-- 
2.29.2

