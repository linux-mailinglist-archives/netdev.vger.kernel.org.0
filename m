Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549DF3D7728
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236776AbhG0NqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:46:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:46116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236722AbhG0NqE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 09:46:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A841A61A80;
        Tue, 27 Jul 2021 13:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627393564;
        bh=I8vyS+/Pjbcd6AJ+GB5Pnp5mSYNlThQR0Wnf5h6uVBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HbEQm0T8xoeDmW3CLjFogtHnJJb0YE/q3o5BmYERlhmeuJVlYX9G00Zc8t42HlkuJ
         EnAb+6RvCL0T9M5mZdh6eCL8hrwf3e9uGBdp5YSiFo6DaxTS+KRt3C+9YyaTq0Fhdh
         ZazDzR37LY3h0h9sDu2gYvlCZi88SdPt/PE/0aVmBLnA2YcpBhQW41ho9JfVcSrbDH
         a7SovBuBtZhIYIAKSMGsd4cdZxwelS4/vkxY2vGFRUWhzuPsgHQOd9jPPulv+NUYaV
         UBCH9zxBmi2ts2rCnJB3wKrXhJxtQCpJA+Mw5HN5e75CU6Ji4fnNkSPhKWXSO8SiJq
         MkVRsFT9yIAgw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v3 03/31] staging: wlan-ng: use siocdevprivate
Date:   Tue, 27 Jul 2021 15:44:49 +0200
Message-Id: <20210727134517.1384504-4-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210727134517.1384504-1-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

wlan-ng has two private ioctls that correctly work in compat
mode. Move these over to the new ndo_siocdevprivate mechanism.

The p80211netdev_ethtool() function is commented out and
has no use here, so this can be removed

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/wlan-ng/p80211netdev.c | 76 ++++----------------------
 1 file changed, 11 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index 6f470e7ba647..1c62130a5eee 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -98,8 +98,8 @@ static int p80211knetdev_stop(struct net_device *netdev);
 static netdev_tx_t p80211knetdev_hard_start_xmit(struct sk_buff *skb,
 						 struct net_device *netdev);
 static void p80211knetdev_set_multicast_list(struct net_device *dev);
-static int p80211knetdev_do_ioctl(struct net_device *dev, struct ifreq *ifr,
-				  int cmd);
+static int p80211knetdev_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
+					void __user *data, int cmd);
 static int p80211knetdev_set_mac_address(struct net_device *dev, void *addr);
 static void p80211knetdev_tx_timeout(struct net_device *netdev, unsigned int txqueue);
 static int p80211_rx_typedrop(struct wlandevice *wlandev, u16 fc);
@@ -461,56 +461,8 @@ static void p80211knetdev_set_multicast_list(struct net_device *dev)
 		wlandev->set_multicast_list(wlandev, dev);
 }
 
-#ifdef SIOCETHTOOL
-
-static int p80211netdev_ethtool(struct wlandevice *wlandev,
-				void __user *useraddr)
-{
-	u32 ethcmd;
-	struct ethtool_drvinfo info;
-	struct ethtool_value edata;
-
-	memset(&info, 0, sizeof(info));
-	memset(&edata, 0, sizeof(edata));
-
-	if (copy_from_user(&ethcmd, useraddr, sizeof(ethcmd)))
-		return -EFAULT;
-
-	switch (ethcmd) {
-	case ETHTOOL_GDRVINFO:
-		info.cmd = ethcmd;
-		snprintf(info.driver, sizeof(info.driver), "p80211_%s",
-			 wlandev->nsdname);
-		snprintf(info.version, sizeof(info.version), "%s",
-			 WLAN_RELEASE);
-
-		if (copy_to_user(useraddr, &info, sizeof(info)))
-			return -EFAULT;
-		return 0;
-#ifdef ETHTOOL_GLINK
-	case ETHTOOL_GLINK:
-		edata.cmd = ethcmd;
-
-		if (wlandev->linkstatus &&
-		    (wlandev->macmode != WLAN_MACMODE_NONE)) {
-			edata.data = 1;
-		} else {
-			edata.data = 0;
-		}
-
-		if (copy_to_user(useraddr, &edata, sizeof(edata)))
-			return -EFAULT;
-		return 0;
-#endif
-	}
-
-	return -EOPNOTSUPP;
-}
-
-#endif
-
 /*----------------------------------------------------------------
- * p80211knetdev_do_ioctl
+ * p80211knetdev_siocdevprivate
  *
  * Handle an ioctl call on one of our devices.  Everything Linux
  * ioctl specific is done here.  Then we pass the contents of the
@@ -537,8 +489,9 @@ static int p80211netdev_ethtool(struct wlandevice *wlandev,
  *	locks.
  *----------------------------------------------------------------
  */
-static int p80211knetdev_do_ioctl(struct net_device *dev,
-				  struct ifreq *ifr, int cmd)
+static int p80211knetdev_siocdevprivate(struct net_device *dev,
+					struct ifreq *ifr,
+					void __user *data, int cmd)
 {
 	int result = 0;
 	struct p80211ioctl_req *req = (struct p80211ioctl_req *)ifr;
@@ -547,13 +500,8 @@ static int p80211knetdev_do_ioctl(struct net_device *dev,
 
 	netdev_dbg(dev, "rx'd ioctl, cmd=%d, len=%d\n", cmd, req->len);
 
-#ifdef SIOCETHTOOL
-	if (cmd == SIOCETHTOOL) {
-		result =
-		    p80211netdev_ethtool(wlandev, (void __user *)ifr->ifr_data);
-		goto bail;
-	}
-#endif
+	if (in_compat_syscall())
+		return -EOPNOTSUPP;
 
 	/* Test the magic, assume ifr is good if it's there */
 	if (req->magic != P80211_IOCTL_MAGIC) {
@@ -569,7 +517,7 @@ static int p80211knetdev_do_ioctl(struct net_device *dev,
 		goto bail;
 	}
 
-	msgbuf = memdup_user(req->data, req->len);
+	msgbuf = memdup_user(data, req->len);
 	if (IS_ERR(msgbuf)) {
 		result = PTR_ERR(msgbuf);
 		goto bail;
@@ -578,10 +526,8 @@ static int p80211knetdev_do_ioctl(struct net_device *dev,
 	result = p80211req_dorequest(wlandev, msgbuf);
 
 	if (result == 0) {
-		if (copy_to_user
-		    (req->data, msgbuf, req->len)) {
+		if (copy_to_user(data, msgbuf, req->len))
 			result = -EFAULT;
-		}
 	}
 	kfree(msgbuf);
 
@@ -682,7 +628,7 @@ static const struct net_device_ops p80211_netdev_ops = {
 	.ndo_stop = p80211knetdev_stop,
 	.ndo_start_xmit = p80211knetdev_hard_start_xmit,
 	.ndo_set_rx_mode = p80211knetdev_set_multicast_list,
-	.ndo_do_ioctl = p80211knetdev_do_ioctl,
+	.ndo_siocdevprivate = p80211knetdev_siocdevprivate,
 	.ndo_set_mac_address = p80211knetdev_set_mac_address,
 	.ndo_tx_timeout = p80211knetdev_tx_timeout,
 	.ndo_validate_addr = eth_validate_addr,
-- 
2.29.2

