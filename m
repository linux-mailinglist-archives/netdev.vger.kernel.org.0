Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5D73D774C
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237078AbhG0NrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:47:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:47130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237077AbhG0Nql (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 49FD061AA9;
        Tue, 27 Jul 2021 13:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393592;
        bh=3OUbVD/hQ6DdwiZR/3TAtMQ+KmPu+QhinUU9bz4wEsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aOM5oATCu5rffTbyDTRISycXVtiHAv82wEjvd4tKLczDQDccEBbS9MG/f1Je29hjj
         6GEMsg5gvi/w09mrFZQSdNWkujyapIs27ou0mKt4h1luUkQtqBF7nNMYQeNCcO3NOi
         imxzw6djZ49Oim1qc5XSuEHfkjQKo4nSEED5pTYtnDB+Kv/7SU4cATAleSU9gLJLI7
         fN10KNQPlEqBKpljEwKRi4w6qoevT25F3PIofXuTsofU3RpXB9gSKBZxqoS0Yxfzam
         IBQA1vQElhHQspVnw0+0ffWCcEp+sgntfG3F2fbvezJn5x8Dt1juscZfJk2jjOfSgk
         3PSR6XdauoJ0A==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org
Subject: [PATCH net-next v3 19/31] airo: use ndo_siocdevprivate
Date:   Tue, 27 Jul 2021 15:45:05 +0200
Message-Id: <20210727134517.1384504-20-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
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

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
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

