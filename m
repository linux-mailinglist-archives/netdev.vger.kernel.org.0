Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205ED3CFDB1
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241868AbhGTOyh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240447AbhGTOay (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:30:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79DE36121F;
        Tue, 20 Jul 2021 14:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792417;
        bh=sk9ORgW78QUBxWAyMOYPogdenLuHD5qaeS/HXjGxBxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTSDFuKmC7gf16ysMTKJeWZm1w3nOc+eUxyBcunTeFKXgsnNdrNU2tuKNTW7AGxMs
         8lrr8biWm7bVJR4AmbBmVnfuIoO1ItguD17dQW+XpV3oTRhwTDflsl0VboPqtA2Nrs
         dmYrTg3NG55An2CCFChOvbiIHa0axHHLvU3Nc4XMpBM454c6FgS5rPv9GQOdJseDWl
         pQtRK4soIvIwdxVGiytBAbghifi+P2MTor5aRx296t2zi/vu+4ANqp4pVKp5QmQCDY
         f1Jxdbj1/6M0eMJi7W3APNJbCV/uTLU7pI8uiHCEwF7j59ou8/yFilbY8uUZ5c9dw3
         xpnIQDJHbKdsg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 04/31] hostap: use ndo_siocdevprivate
Date:   Tue, 20 Jul 2021 16:46:11 +0200
Message-Id: <20210720144638.2859828-5-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

hostap has a combination of iwpriv ioctls that do not work at
all, and two SIOCDEVPRIVATE commands that work natively but
lack a compat conversion handler.

For the moment, move them over to the new ndo_siocdevprivate
interface and return an error for compat mode.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/intersil/hostap/hostap.h |  3 +-
 .../wireless/intersil/hostap/hostap_ioctl.c   | 30 +++++++++++++++----
 .../wireless/intersil/hostap/hostap_main.c    |  3 ++
 3 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap.h b/drivers/net/wireless/intersil/hostap/hostap.h
index c4b81ff7d7e4..c17ab6dbbb53 100644
--- a/drivers/net/wireless/intersil/hostap/hostap.h
+++ b/drivers/net/wireless/intersil/hostap/hostap.h
@@ -93,6 +93,7 @@ extern const struct iw_handler_def hostap_iw_handler_def;
 extern const struct ethtool_ops prism2_ethtool_ops;
 
 int hostap_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
-
+int hostap_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+			  void __user *data, int cmd);
 
 #endif /* HOSTAP_H */
diff --git a/drivers/net/wireless/intersil/hostap/hostap_ioctl.c b/drivers/net/wireless/intersil/hostap/hostap_ioctl.c
index 49766b285230..0a376f112db9 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_ioctl.c
@@ -3941,7 +3941,8 @@ const struct iw_handler_def hostap_iw_handler_def =
 	.get_wireless_stats = hostap_get_wireless_stats,
 };
 
-
+/* Private ioctls (iwpriv) that have not yet been converted
+ * into new wireless extensions API */
 int hostap_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 {
 	struct iwreq *wrq = (struct iwreq *) ifr;
@@ -3953,9 +3954,6 @@ int hostap_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	local = iface->local;
 
 	switch (cmd) {
-		/* Private ioctls (iwpriv) that have not yet been converted
-		 * into new wireless extensions API */
-
 	case PRISM2_IOCTL_INQUIRE:
 		if (!capable(CAP_NET_ADMIN)) ret = -EPERM;
 		else ret = prism2_ioctl_priv_inquire(dev, (int *) wrq->u.name);
@@ -4009,11 +4007,31 @@ int hostap_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 					       wrq->u.ap_addr.sa_data);
 		break;
 #endif /* PRISM2_NO_KERNEL_IEEE80211_MGMT */
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
+	return ret;
+}
 
+/* Private ioctls that are not used with iwpriv;
+ * in SIOCDEVPRIVATE range */
+int hostap_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+			  void __user *data, int cmd)
+{
+	struct iwreq *wrq = (struct iwreq *)ifr;
+	struct hostap_interface *iface;
+	local_info_t *local;
+	int ret = 0;
 
-		/* Private ioctls that are not used with iwpriv;
-		 * in SIOCDEVPRIVATE range */
+	iface = netdev_priv(dev);
+	local = iface->local;
+
+	if (in_compat_syscall()) /* not implemented yet */
+		return -EOPNOTSUPP;
 
+	switch (cmd) {
 #ifdef PRISM2_DOWNLOAD_SUPPORT
 	case PRISM2_IOCTL_DOWNLOAD:
 		if (!capable(CAP_NET_ADMIN)) ret = -EPERM;
diff --git a/drivers/net/wireless/intersil/hostap/hostap_main.c b/drivers/net/wireless/intersil/hostap/hostap_main.c
index de97b3304115..54f67b682b6a 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_main.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_main.c
@@ -797,6 +797,7 @@ static const struct net_device_ops hostap_netdev_ops = {
 	.ndo_open		= prism2_open,
 	.ndo_stop		= prism2_close,
 	.ndo_do_ioctl		= hostap_ioctl,
+	.ndo_siocdevprivate	= hostap_siocdevprivate,
 	.ndo_set_mac_address	= prism2_set_mac_address,
 	.ndo_set_rx_mode	= hostap_set_multicast_list,
 	.ndo_tx_timeout 	= prism2_tx_timeout,
@@ -809,6 +810,7 @@ static const struct net_device_ops hostap_mgmt_netdev_ops = {
 	.ndo_open		= prism2_open,
 	.ndo_stop		= prism2_close,
 	.ndo_do_ioctl		= hostap_ioctl,
+	.ndo_siocdevprivate	= hostap_siocdevprivate,
 	.ndo_set_mac_address	= prism2_set_mac_address,
 	.ndo_set_rx_mode	= hostap_set_multicast_list,
 	.ndo_tx_timeout 	= prism2_tx_timeout,
@@ -821,6 +823,7 @@ static const struct net_device_ops hostap_master_ops = {
 	.ndo_open		= prism2_open,
 	.ndo_stop		= prism2_close,
 	.ndo_do_ioctl		= hostap_ioctl,
+	.ndo_siocdevprivate	= hostap_siocdevprivate,
 	.ndo_set_mac_address	= prism2_set_mac_address,
 	.ndo_set_rx_mode	= hostap_set_multicast_list,
 	.ndo_tx_timeout 	= prism2_tx_timeout,
-- 
2.29.2

