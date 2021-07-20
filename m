Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B0563CFDB3
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 17:39:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241734AbhGTOxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 10:53:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:35608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239787AbhGTO2q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 10:28:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BA486120E;
        Tue, 20 Jul 2021 14:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626792414;
        bh=HeCjumant9zOvemF66btOBepei7KoaQ2+NpoLeowync=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GaxLMhhhtY0KpAhasVtrop/3exOfrnlufC9oWj+xq4p1rJP+sWZ+1kQaqBq2uL/ql
         VMnsW0CbjwOBXkBnJ4s5zK+SHb1FBpxRV3dVs/KhzxwFqCbtoYGqAx4qapIytOYSqb
         b0jZi2ESpbQO2F0pD6mE2R7BcR/fBcBqMMH7bAeWB/08GhJ7JpnQ2adMS9C/U7HmVE
         h3r5SH1XR5KeOjKwkhjOO06KKrIFNKRkn0LhjKhmNlH21Hz3jcxj1GGRoPt/lNEvZ0
         bW4KdmJyXgdZirYwCRgW10lAFjYL4LtbMqv0KuDLap/2OyHTsjpxVaqbcPjSHDUEI2
         ToTeCN0U7beiQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH net-next v2 02/31] staging: rtlwifi: use siocdevprivate
Date:   Tue, 20 Jul 2021 16:46:09 +0200
Message-Id: <20210720144638.2859828-3-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210720144638.2859828-1-arnd@kernel.org>
References: <20210720144638.2859828-1-arnd@kernel.org>
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
 drivers/staging/rtl8188eu/os_dep/rtw_android.c | 14 +++++++++++---
 drivers/staging/rtl8723bs/include/osdep_intf.h |  2 ++
 drivers/staging/rtl8723bs/os_dep/ioctl_linux.c | 18 +++++++++++++++---
 drivers/staging/rtl8723bs/os_dep/os_intfs.c    |  1 +
 8 files changed, 34 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_intf.h b/drivers/staging/rtl8188eu/include/osdep_intf.h
index 5012b9176526..34decb03e92f 100644
--- a/drivers/staging/rtl8188eu/include/osdep_intf.h
+++ b/drivers/staging/rtl8188eu/include/osdep_intf.h
@@ -22,6 +22,8 @@ void rtw_stop_drv_threads(struct adapter *padapter);
 void rtw_cancel_all_timer(struct adapter *padapter);
 
 int rtw_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
+int rtw_android_priv_cmd(struct net_device *dev, struct ifreq *rq,
+			 void __user *data, int cmd);
 
 struct net_device *rtw_init_netdev(void);
 u16 rtw_recv_select_queue(struct sk_buff *skb);
diff --git a/drivers/staging/rtl8188eu/include/rtw_android.h b/drivers/staging/rtl8188eu/include/rtw_android.h
index 2c26993b8205..3018fc1e8de8 100644
--- a/drivers/staging/rtl8188eu/include/rtw_android.h
+++ b/drivers/staging/rtl8188eu/include/rtw_android.h
@@ -45,6 +45,7 @@ enum ANDROID_WIFI_CMD {
 	ANDROID_WIFI_CMD_MAX
 };
 
-int rtw_android_priv_cmd(struct net_device *net, struct ifreq *ifr, int cmd);
+int rtw_android_priv_cmd(struct net_device *net, struct ifreq *ifr,
+			 void __user *data, int cmd);
 
 #endif /* __RTW_ANDROID_H__ */
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index b958a8d882b0..193a3dde462c 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -2769,9 +2769,6 @@ int rtw_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
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
index 423c382e3d20..596e03e7b286 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -288,6 +288,7 @@ static const struct net_device_ops rtw_netdev_ops = {
 	.ndo_set_mac_address = rtw_net_set_mac_address,
 	.ndo_get_stats = rtw_net_get_stats,
 	.ndo_do_ioctl = rtw_ioctl,
+	.ndo_siocdevprivate = rtw_android_priv_cmd,
 };
 
 static const struct device_type wlan_type = {
diff --git a/drivers/staging/rtl8188eu/os_dep/rtw_android.c b/drivers/staging/rtl8188eu/os_dep/rtw_android.c
index 3c5446999686..a13df3880378 100644
--- a/drivers/staging/rtl8188eu/os_dep/rtw_android.c
+++ b/drivers/staging/rtl8188eu/os_dep/rtw_android.c
@@ -5,6 +5,7 @@
  *
  ******************************************************************************/
 
+#include <linux/compat.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 
@@ -116,7 +117,8 @@ static int android_get_p2p_addr(struct net_device *net, char *command,
 	return ETH_ALEN;
 }
 
-int rtw_android_priv_cmd(struct net_device *net, struct ifreq *ifr, int cmd)
+int rtw_android_priv_cmd(struct net_device *net, struct ifreq *ifr,
+			 void __user *data, int cmd)
 {
 	int ret = 0;
 	char *command;
@@ -124,9 +126,15 @@ int rtw_android_priv_cmd(struct net_device *net, struct ifreq *ifr, int cmd)
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
index 111e0179712a..5badd441c14b 100644
--- a/drivers/staging/rtl8723bs/include/osdep_intf.h
+++ b/drivers/staging/rtl8723bs/include/osdep_intf.h
@@ -48,6 +48,8 @@ void rtw_stop_drv_threads(struct adapter *padapter);
 void rtw_cancel_all_timer(struct adapter *padapter);
 
 int rtw_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
+int rtw_siocdevprivate(struct net_device *dev, struct ifreq *rq,
+		       void __user *data, int cmd);
 
 int rtw_init_netdev_name(struct net_device *pnetdev, const char *ifname);
 struct net_device *rtw_init_netdev(struct adapter *padapter);
diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
index f95000df8942..aa7bd76bb5f1 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -4485,6 +4485,21 @@ static int rtw_ioctl_wext_private(struct net_device *dev, union iwreq_data *wrq_
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
@@ -4497,9 +4512,6 @@ int rtw_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
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
index 648456b992bb..9e38b53d3b4a 100644
--- a/drivers/staging/rtl8723bs/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8723bs/os_dep/os_intfs.c
@@ -459,6 +459,7 @@ static const struct net_device_ops rtw_netdev_ops = {
 	.ndo_set_mac_address = rtw_net_set_mac_address,
 	.ndo_get_stats = rtw_net_get_stats,
 	.ndo_do_ioctl = rtw_ioctl,
+	.ndo_siocdevprivate = rtw_siocdevprivate,
 };
 
 int rtw_init_netdev_name(struct net_device *pnetdev, const char *ifname)
-- 
2.29.2

