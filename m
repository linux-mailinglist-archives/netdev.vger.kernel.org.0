Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1874C2AA02F
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbgKFWSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:18:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:41140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728793AbgKFWSB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:18:01 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2C5C20882;
        Fri,  6 Nov 2020 22:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701080;
        bh=1a0AE2Q03wh3BjAFA1TP0gFsg2GJsgexcfq5g6hpUP8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QoAKjO3oqNNHZcPR5S21+1I2xFSofR0+HYHecpmV1rv/MCc5yukVfM+sV+4+5m4z0
         LM6Nm2EHd30ykVSJvVXqcj2uzGFTfk+APj4VoeUEdnF7rM09Du/Ou+i2/LpeqFqBkW
         rVMqXxd9x0RC1VA0NpZ/m2XWf5t4ax7s1gASiE6w=
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
Subject: [RFC net-next 02/28] staging: rtlwifi: use siocdevprivate
Date:   Fri,  6 Nov 2020 23:17:17 +0100
Message-Id: <20201106221743.3271965-3-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

rtl8188eu has an "android private" ioctl command multiplexer
that is not currently safe for use in compat mode because
of its triple-indirect pointer.

rtl8723bs uses a different interface on the SIOCDEVPRIVATE
command, based on the iwpriv data structure

Both also have normal unreachable iwpriv commands, and all
of the above should probably just get removed. For the
moment, just switch over to the new interface.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/staging/rtl8188eu/include/osdep_intf.h |  2 ++
 .../staging/rtl8188eu/include/rtw_android.h    |  3 ++-
 drivers/staging/rtl8188eu/os_dep/ioctl_linux.c |  3 ---
 drivers/staging/rtl8188eu/os_dep/os_intfs.c    |  1 +
 drivers/staging/rtl8188eu/os_dep/rtw_android.c | 13 ++++++++++---
 drivers/staging/rtl8723bs/include/osdep_intf.h |  2 ++
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c | 18 +++++++++++++++---
 drivers/staging/rtl8723bs/os_dep/os_intfs.c    |  1 +
 8 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_intf.h b/drivers/staging/rtl8188eu/include/osdep_intf.h
index 07c32768f649..0c2859dc1f15 100644
--- a/drivers/staging/rtl8188eu/include/osdep_intf.h
+++ b/drivers/staging/rtl8188eu/include/osdep_intf.h
@@ -22,6 +22,8 @@ void rtw_stop_drv_threads(struct adapter *padapter);
 void rtw_cancel_all_timer(struct adapter *padapter);
 
 int rtw_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
+int rtw_android_priv_cmd(struct net_device *dev, struct ifreq *rq,
+			 void __user *data, int cmd);
 
 int rtw_init_netdev_name(struct net_device *pnetdev, const char *ifname);
 struct net_device *rtw_init_netdev(struct adapter *padapter);
diff --git a/drivers/staging/rtl8188eu/include/rtw_android.h b/drivers/staging/rtl8188eu/include/rtw_android.h
index d7ca7c2fb118..e724d983d298 100644
--- a/drivers/staging/rtl8188eu/include/rtw_android.h
+++ b/drivers/staging/rtl8188eu/include/rtw_android.h
@@ -46,6 +46,7 @@ enum ANDROID_WIFI_CMD {
 };
 
 int rtw_android_cmdstr_to_num(char *cmdstr);
-int rtw_android_priv_cmd(struct net_device *net, struct ifreq *ifr, int cmd);
+int rtw_android_priv_cmd(struct net_device *net, struct ifreq *ifr,
+			 void __user *data, int cmd);
 
 #endif /* __RTW_ANDROID_H__ */
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 8e10462f1fbe..604d69ba7526 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -3011,9 +3011,6 @@ int rtw_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 		ret = rtw_hostapd_ioctl(dev, &wrq->u.data);
 		break;
 #endif /*  CONFIG_88EU_AP_MODE */
-	case (SIOCDEVPRIVATE + 1):
-		ret = rtw_android_priv_cmd(dev, rq, cmd);
-		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index e291df87f620..9b126200a208 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -290,6 +290,7 @@ static const struct net_device_ops rtw_netdev_ops = {
 	.ndo_set_mac_address = rtw_net_set_mac_address,
 	.ndo_get_stats = rtw_net_get_stats,
 	.ndo_do_ioctl = rtw_ioctl,
+	.ndo_siocdevprivate = rtw_android_priv_cmd,
 };
 
 int rtw_init_netdev_name(struct net_device *pnetdev, const char *ifname)
diff --git a/drivers/staging/rtl8188eu/os_dep/rtw_android.c b/drivers/staging/rtl8188eu/os_dep/rtw_android.c
index b5209627fd1a..a98d7fc0c723 100644
--- a/drivers/staging/rtl8188eu/os_dep/rtw_android.c
+++ b/drivers/staging/rtl8188eu/os_dep/rtw_android.c
@@ -127,7 +127,8 @@ static int android_get_p2p_addr(struct net_device *net, char *command,
 	return ETH_ALEN;
 }
 
-int rtw_android_priv_cmd(struct net_device *net, struct ifreq *ifr, int cmd)
+int rtw_android_priv_cmd(struct net_device *net, struct ifreq *ifr,
+			 void __user *data, int cmd)
 {
 	int ret = 0;
 	char *command;
@@ -135,9 +136,15 @@ int rtw_android_priv_cmd(struct net_device *net, struct ifreq *ifr, int cmd)
 	int bytes_written = 0;
 	struct android_wifi_priv_cmd priv_cmd;
 
-	if (!ifr->ifr_data)
+	if (cmd != SIOCDEVPRIVATE)
+		return -EOPNOTSUPP;
+
+	if (in_compat_syscall()) /* to be implemented */
+		return -EOPNOTSUPP;
+
+	if (!data)
 		return -EINVAL;
-	if (copy_from_user(&priv_cmd, ifr->ifr_data, sizeof(priv_cmd)))
+	if (copy_from_user(&priv_cmd, data, sizeof(priv_cmd)))
 		return -EFAULT;
 	if (priv_cmd.total_len < 1)
 		return -EINVAL;
diff --git a/drivers/staging/rtl8723bs/include/osdep_intf.h b/drivers/staging/rtl8723bs/include/osdep_intf.h
index c59c1384944b..1f194b94c63c 100644
--- a/drivers/staging/rtl8723bs/include/osdep_intf.h
+++ b/drivers/staging/rtl8723bs/include/osdep_intf.h
@@ -54,6 +54,8 @@ void rtw_stop_drv_threads(struct adapter *padapter);
 void rtw_cancel_all_timer(struct adapter *padapter);
 
 int rtw_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
+int rtw_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+		       void __user *data, int cmd);
 
 int rtw_init_netdev_name(struct net_device *pnetdev, const char *ifname);
 struct net_device *rtw_init_netdev(struct adapter *padapter);
diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
index 902ac8169948..ef2b5f84564c 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -5134,6 +5134,21 @@ static int rtw_ioctl_wext_private(struct net_device *dev, union iwreq_data *wrq_
 	return err;
 }
 
+int rtw_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+		       void __user *data, int cmd)
+{
+	struct iwreq *wrq = (struct iwreq *)rq;
+
+	/* little hope of fixing this, better remove the whole function */
+	if (in_compat_syscall())
+		return -EOPNOTSUPP;
+
+	if (cmd != SIOCDEVPRIVATE)
+		return -EOPNOTSUPP;
+
+	return rtw_ioctl_wext_private(dev, &wrq->u);
+}
+
 int rtw_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
 	struct iwreq *wrq = (struct iwreq *)rq;
@@ -5146,9 +5161,6 @@ int rtw_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 	case RTL_IOCTL_HOSTAPD:
 		ret = rtw_hostapd_ioctl(dev, &wrq->u.data);
 		break;
-	case SIOCDEVPRIVATE:
-		ret = rtw_ioctl_wext_private(dev, &wrq->u);
-		break;
 	default:
 		ret = -EOPNOTSUPP;
 		break;
diff --git a/drivers/staging/rtl8723bs/os_dep/os_intfs.c b/drivers/staging/rtl8723bs/os_dep/os_intfs.c
index 27f990a01a23..e15725ef4c27 100644
--- a/drivers/staging/rtl8723bs/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8723bs/os_dep/os_intfs.c
@@ -470,6 +470,7 @@ static const struct net_device_ops rtw_netdev_ops = {
 	.ndo_set_mac_address = rtw_net_set_mac_address,
 	.ndo_get_stats = rtw_net_get_stats,
 	.ndo_do_ioctl = rtw_ioctl,
+	.ndo_siocdevprivate = rtw_siocdevprivate,
 };
 
 int rtw_init_netdev_name(struct net_device *pnetdev, const char *ifname)
-- 
2.27.0

