Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94BD2AA04B
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 23:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbgKFWWA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 17:22:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:41430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728891AbgKFWSN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 17:18:13 -0500
Received: from localhost.localdomain (HSI-KBW-46-223-126-90.hsi.kabel-badenwuerttemberg.de [46.223.126.90])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47E0620B80;
        Fri,  6 Nov 2020 22:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604701089;
        bh=mk9itH/x8RZP9AaGOhBCIY1LyE5PMKUa+7asIT5VJLU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGmxsszwxZ6dx/QBuHBaKuuNGevbqWEXfSQmd/gwX4WswhglZiaT850RTSMqUyZAS
         fI36+Iii1IgcpMwr8M797pu8ufpmYf53QOcRHbuJWGIDaLnQAOzNaiGuCE3JXkc2up
         tojG1cEoVZI5Ow2yrSoRDFlv6xX9YaX2S61hFKH8=
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
Subject: [RFC net-next 05/28] wireless: remove old ioctls
Date:   Fri,  6 Nov 2020 23:17:20 +0100
Message-Id: <20201106221743.3271965-6-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201106221743.3271965-1-arnd@kernel.org>
References: <20201106221743.3271965-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Commit 8bfb36766064 ("wireless: wext: remove ndo_do_ioctl fallback")
removed the ability to have private wireless ioctl commands implemented
in the normal ndo_do_ioctl handler, under the assumption that no remaining
drivers used that.

This turned out to be incorrect, as both the atmel and intersil drivers
do in fact implement a few such commands, along with SIOCDEVPRIVATE
commands and infrastructure that would allow handling them using the
more modern abstraction.

Since nobody noticed that these interfaces have been broken for over 3.5
years and the drivers are still usable without them (provided there are
still users), it seems better to just remove the now dead code rather
than trying to make it work again.  An alternative would be to just
remove the drivers entirely.

There are also a few staging drivers that got merged with the same
type of interface, which was either broken by the same commit, or
it never worked for the drivers that got merged later.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/atmel/atmel.c            |   72 --
 drivers/net/wireless/intersil/hostap/hostap.h |    1 -
 .../wireless/intersil/hostap/hostap_ioctl.c   |  229 ----
 .../wireless/intersil/hostap/hostap_main.c    |    3 -
 drivers/staging/ks7010/ks_wlan_net.c          |   21 -
 drivers/staging/rtl8188eu/include/ieee80211.h |    2 -
 .../staging/rtl8188eu/include/osdep_intf.h    |    1 -
 .../staging/rtl8188eu/os_dep/ioctl_linux.c    |  938 --------------
 drivers/staging/rtl8188eu/os_dep/os_intfs.c   |    1 -
 drivers/staging/rtl8192u/r8192U_core.c        |  109 --
 drivers/staging/rtl8712/os_intfs.c            |    1 -
 drivers/staging/rtl8712/osdep_intf.h          |    2 -
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |  125 --
 .../staging/rtl8723bs/include/osdep_intf.h    |    1 -
 .../staging/rtl8723bs/os_dep/ioctl_linux.c    | 1083 -----------------
 drivers/staging/rtl8723bs/os_dep/os_intfs.c   |   20 +-
 16 files changed, 1 insertion(+), 2608 deletions(-)

diff --git a/drivers/net/wireless/atmel/atmel.c b/drivers/net/wireless/atmel/atmel.c
index 707fe66727f8..bc48704dd930 100644
--- a/drivers/net/wireless/atmel/atmel.c
+++ b/drivers/net/wireless/atmel/atmel.c
@@ -572,7 +572,6 @@ static const struct {
 		      { REG_DOMAIN_ISRAEL, 3, 9, "Israel"} };
 
 static void build_wpa_mib(struct atmel_private *priv);
-static int atmel_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 static void atmel_copy_to_card(struct net_device *dev, u16 dest,
 			       const unsigned char *src, u16 len);
 static void atmel_copy_to_host(struct net_device *dev, unsigned char *dest,
@@ -1488,7 +1487,6 @@ static const struct net_device_ops atmel_netdev_ops = {
 	.ndo_stop		= atmel_close,
 	.ndo_set_mac_address 	= atmel_set_mac_address,
 	.ndo_start_xmit 	= start_tx,
-	.ndo_do_ioctl 		= atmel_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
@@ -2621,76 +2619,6 @@ static const struct iw_handler_def atmel_handler_def = {
 	.get_wireless_stats = atmel_get_wireless_stats
 };
 
-static int atmel_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	int i, rc = 0;
-	struct atmel_private *priv = netdev_priv(dev);
-	struct atmel_priv_ioctl com;
-	struct iwreq *wrq = (struct iwreq *) rq;
-	unsigned char *new_firmware;
-	char domain[REGDOMAINSZ + 1];
-
-	switch (cmd) {
-	case ATMELIDIFC:
-		wrq->u.param.value = ATMELMAGIC;
-		break;
-
-	case ATMELFWL:
-		if (copy_from_user(&com, rq->ifr_data, sizeof(com))) {
-			rc = -EFAULT;
-			break;
-		}
-
-		if (!capable(CAP_NET_ADMIN)) {
-			rc = -EPERM;
-			break;
-		}
-
-		new_firmware = memdup_user(com.data, com.len);
-		if (IS_ERR(new_firmware)) {
-			rc = PTR_ERR(new_firmware);
-			break;
-		}
-
-		kfree(priv->firmware);
-
-		priv->firmware = new_firmware;
-		priv->firmware_length = com.len;
-		strncpy(priv->firmware_id, com.id, 31);
-		priv->firmware_id[31] = '\0';
-		break;
-
-	case ATMELRD:
-		if (copy_from_user(domain, rq->ifr_data, REGDOMAINSZ)) {
-			rc = -EFAULT;
-			break;
-		}
-
-		if (!capable(CAP_NET_ADMIN)) {
-			rc = -EPERM;
-			break;
-		}
-
-		domain[REGDOMAINSZ] = 0;
-		rc = -EINVAL;
-		for (i = 0; i < ARRAY_SIZE(channel_table); i++) {
-			if (!strcasecmp(channel_table[i].name, domain)) {
-				priv->config_reg_domain = channel_table[i].reg_domain;
-				rc = 0;
-			}
-		}
-
-		if (rc == 0 &&  priv->station_state != STATION_STATE_DOWN)
-			rc = atmel_open(dev);
-		break;
-
-	default:
-		rc = -EOPNOTSUPP;
-	}
-
-	return rc;
-}
-
 struct auth_body {
 	__le16 alg;
 	__le16 trans_seq;
diff --git a/drivers/net/wireless/intersil/hostap/hostap.h b/drivers/net/wireless/intersil/hostap/hostap.h
index 0c41efa252f0..66dfdf24ef9d 100644
--- a/drivers/net/wireless/intersil/hostap/hostap.h
+++ b/drivers/net/wireless/intersil/hostap/hostap.h
@@ -92,7 +92,6 @@ void hostap_info_process(local_info_t *local, struct sk_buff *skb);
 extern const struct iw_handler_def hostap_iw_handler_def;
 extern const struct ethtool_ops prism2_ethtool_ops;
 
-int hostap_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
 int hostap_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
 		 void __user *data, int cmd);
 
diff --git a/drivers/net/wireless/intersil/hostap/hostap_ioctl.c b/drivers/net/wireless/intersil/hostap/hostap_ioctl.c
index 7b6471e44255..cc92b52f3348 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_ioctl.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_ioctl.c
@@ -2297,21 +2297,6 @@ static const struct iw_priv_args prism2_priv[] = {
 };
 
 
-static int prism2_ioctl_priv_inquire(struct net_device *dev, int *i)
-{
-	struct hostap_interface *iface;
-	local_info_t *local;
-
-	iface = netdev_priv(dev);
-	local = iface->local;
-
-	if (local->func->cmd(dev, HFA384X_CMDCODE_INQUIRE, *i, NULL, NULL))
-		return -EOPNOTSUPP;
-
-	return 0;
-}
-
-
 static int prism2_ioctl_priv_prism2_param(struct net_device *dev,
 					  struct iw_request_info *info,
 					  void *wrqu, char *extra)
@@ -2891,146 +2876,6 @@ static int prism2_ioctl_priv_writemif(struct net_device *dev,
 }
 
 
-static int prism2_ioctl_priv_monitor(struct net_device *dev, int *i)
-{
-	struct hostap_interface *iface;
-	local_info_t *local;
-	int ret = 0;
-	u32 mode;
-
-	iface = netdev_priv(dev);
-	local = iface->local;
-
-	printk(KERN_DEBUG "%s: process %d (%s) used deprecated iwpriv monitor "
-	       "- update software to use iwconfig mode monitor\n",
-	       dev->name, task_pid_nr(current), current->comm);
-
-	/* Backward compatibility code - this can be removed at some point */
-
-	if (*i == 0) {
-		/* Disable monitor mode - old mode was not saved, so go to
-		 * Master mode */
-		mode = IW_MODE_MASTER;
-		ret = prism2_ioctl_siwmode(dev, NULL, &mode, NULL);
-	} else if (*i == 1) {
-		/* netlink socket mode is not supported anymore since it did
-		 * not separate different devices from each other and was not
-		 * best method for delivering large amount of packets to
-		 * user space */
-		ret = -EOPNOTSUPP;
-	} else if (*i == 2 || *i == 3) {
-		switch (*i) {
-		case 2:
-			local->monitor_type = PRISM2_MONITOR_80211;
-			break;
-		case 3:
-			local->monitor_type = PRISM2_MONITOR_PRISM;
-			break;
-		}
-		mode = IW_MODE_MONITOR;
-		ret = prism2_ioctl_siwmode(dev, NULL, &mode, NULL);
-		hostap_monitor_mode_enable(local);
-	} else
-		ret = -EINVAL;
-
-	return ret;
-}
-
-
-static int prism2_ioctl_priv_reset(struct net_device *dev, int *i)
-{
-	struct hostap_interface *iface;
-	local_info_t *local;
-
-	iface = netdev_priv(dev);
-	local = iface->local;
-
-	printk(KERN_DEBUG "%s: manual reset request(%d)\n", dev->name, *i);
-	switch (*i) {
-	case 0:
-		/* Disable and enable card */
-		local->func->hw_shutdown(dev, 1);
-		local->func->hw_config(dev, 0);
-		break;
-
-	case 1:
-		/* COR sreset */
-		local->func->hw_reset(dev);
-		break;
-
-	case 2:
-		/* Disable and enable port 0 */
-		local->func->reset_port(dev);
-		break;
-
-	case 3:
-		prism2_sta_deauth(local, WLAN_REASON_DEAUTH_LEAVING);
-		if (local->func->cmd(dev, HFA384X_CMDCODE_DISABLE, 0, NULL,
-				     NULL))
-			return -EINVAL;
-		break;
-
-	case 4:
-		if (local->func->cmd(dev, HFA384X_CMDCODE_ENABLE, 0, NULL,
-				     NULL))
-			return -EINVAL;
-		break;
-
-	default:
-		printk(KERN_DEBUG "Unknown reset request %d\n", *i);
-		return -EOPNOTSUPP;
-	}
-
-	return 0;
-}
-
-
-static int prism2_ioctl_priv_set_rid_word(struct net_device *dev, int *i)
-{
-	int rid = *i;
-	int value = *(i + 1);
-
-	printk(KERN_DEBUG "%s: Set RID[0x%X] = %d\n", dev->name, rid, value);
-
-	if (hostap_set_word(dev, rid, value))
-		return -EINVAL;
-
-	return 0;
-}
-
-
-#ifndef PRISM2_NO_KERNEL_IEEE80211_MGMT
-static int ap_mac_cmd_ioctl(local_info_t *local, int *cmd)
-{
-	int ret = 0;
-
-	switch (*cmd) {
-	case AP_MAC_CMD_POLICY_OPEN:
-		local->ap->mac_restrictions.policy = MAC_POLICY_OPEN;
-		break;
-	case AP_MAC_CMD_POLICY_ALLOW:
-		local->ap->mac_restrictions.policy = MAC_POLICY_ALLOW;
-		break;
-	case AP_MAC_CMD_POLICY_DENY:
-		local->ap->mac_restrictions.policy = MAC_POLICY_DENY;
-		break;
-	case AP_MAC_CMD_FLUSH:
-		ap_control_flush_macs(&local->ap->mac_restrictions);
-		break;
-	case AP_MAC_CMD_KICKALL:
-		ap_control_kickall(local->ap);
-		hostap_deauth_all_stas(local->dev, local->ap, 0);
-		break;
-	default:
-		ret = -EOPNOTSUPP;
-		break;
-	}
-
-	return ret;
-}
-#endif /* PRISM2_NO_KERNEL_IEEE80211_MGMT */
-
-
 #ifdef PRISM2_DOWNLOAD_SUPPORT
 static int prism2_ioctl_priv_download(local_info_t *local, struct iw_point *p)
 {
@@ -3952,80 +3797,6 @@ const struct iw_handler_def hostap_iw_handler_def =
 	.get_wireless_stats = hostap_get_wireless_stats,
 };
 
-/* Private ioctls (iwpriv) that have not yet been converted
- * into new wireless extensions API */
-int hostap_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
-{
-	struct iwreq *wrq = (struct iwreq *) ifr;
-	struct hostap_interface *iface;
-	local_info_t *local;
-	int ret = 0;
-
-	iface = netdev_priv(dev);
-	local = iface->local;
-
-	switch (cmd) {
-	case PRISM2_IOCTL_INQUIRE:
-		if (!capable(CAP_NET_ADMIN)) ret = -EPERM;
-		else ret = prism2_ioctl_priv_inquire(dev, (int *) wrq->u.name);
-		break;
-
-	case PRISM2_IOCTL_MONITOR:
-		if (!capable(CAP_NET_ADMIN)) ret = -EPERM;
-		else ret = prism2_ioctl_priv_monitor(dev, (int *) wrq->u.name);
-		break;
-
-	case PRISM2_IOCTL_RESET:
-		if (!capable(CAP_NET_ADMIN)) ret = -EPERM;
-		else ret = prism2_ioctl_priv_reset(dev, (int *) wrq->u.name);
-		break;
-
-	case PRISM2_IOCTL_WDS_ADD:
-		if (!capable(CAP_NET_ADMIN)) ret = -EPERM;
-		else ret = prism2_wds_add(local, wrq->u.ap_addr.sa_data, 1);
-		break;
-
-	case PRISM2_IOCTL_WDS_DEL:
-		if (!capable(CAP_NET_ADMIN)) ret = -EPERM;
-		else ret = prism2_wds_del(local, wrq->u.ap_addr.sa_data, 1, 0);
-		break;
-
-	case PRISM2_IOCTL_SET_RID_WORD:
-		if (!capable(CAP_NET_ADMIN)) ret = -EPERM;
-		else ret = prism2_ioctl_priv_set_rid_word(dev,
-							  (int *) wrq->u.name);
-		break;
-
-#ifndef PRISM2_NO_KERNEL_IEEE80211_MGMT
-	case PRISM2_IOCTL_MACCMD:
-		if (!capable(CAP_NET_ADMIN)) ret = -EPERM;
-		else ret = ap_mac_cmd_ioctl(local, (int *) wrq->u.name);
-		break;
-
-	case PRISM2_IOCTL_ADDMAC:
-		if (!capable(CAP_NET_ADMIN)) ret = -EPERM;
-		else ret = ap_control_add_mac(&local->ap->mac_restrictions,
-					      wrq->u.ap_addr.sa_data);
-		break;
-	case PRISM2_IOCTL_DELMAC:
-		if (!capable(CAP_NET_ADMIN)) ret = -EPERM;
-		else ret = ap_control_del_mac(&local->ap->mac_restrictions,
-					      wrq->u.ap_addr.sa_data);
-		break;
-	case PRISM2_IOCTL_KICKMAC:
-		if (!capable(CAP_NET_ADMIN)) ret = -EPERM;
-		else ret = ap_control_kick_mac(local->ap, local->dev,
-					       wrq->u.ap_addr.sa_data);
-		break;
-#endif /* PRISM2_NO_KERNEL_IEEE80211_MGMT */
-	default:
-		ret = -EOPNOTSUPP;
-		break;
-	}
-
-	return ret;
-}
-
 /* Private ioctls that are not used with iwpriv;
  * in SIOCDEVPRIVATE range */
 int hostap_siocdevprivate(struct net_device *dev, struct ifreq *ifr,
diff --git a/drivers/net/wireless/intersil/hostap/hostap_main.c b/drivers/net/wireless/intersil/hostap/hostap_main.c
index 54f67b682b6a..43eaf0c558a1 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_main.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_main.c
@@ -796,7 +796,6 @@ static const struct net_device_ops hostap_netdev_ops = {
 
 	.ndo_open		= prism2_open,
 	.ndo_stop		= prism2_close,
-	.ndo_do_ioctl		= hostap_ioctl,
 	.ndo_siocdevprivate	= hostap_siocdevprivate,
 	.ndo_set_mac_address	= prism2_set_mac_address,
 	.ndo_set_rx_mode	= hostap_set_multicast_list,
@@ -809,7 +808,6 @@ static const struct net_device_ops hostap_mgmt_netdev_ops = {
 
 	.ndo_open		= prism2_open,
 	.ndo_stop		= prism2_close,
-	.ndo_do_ioctl		= hostap_ioctl,
 	.ndo_siocdevprivate	= hostap_siocdevprivate,
 	.ndo_set_mac_address	= prism2_set_mac_address,
 	.ndo_set_rx_mode	= hostap_set_multicast_list,
@@ -822,7 +820,6 @@ static const struct net_device_ops hostap_master_ops = {
 
 	.ndo_open		= prism2_open,
 	.ndo_stop		= prism2_close,
-	.ndo_do_ioctl		= hostap_ioctl,
 	.ndo_siocdevprivate	= hostap_siocdevprivate,
 	.ndo_set_mac_address	= prism2_set_mac_address,
 	.ndo_set_rx_mode	= hostap_set_multicast_list,
diff --git a/drivers/staging/ks7010/ks_wlan_net.c b/drivers/staging/ks7010/ks_wlan_net.c
index dc09cc6e1c47..df8ba583cb32 100644
--- a/drivers/staging/ks7010/ks_wlan_net.c
+++ b/drivers/staging/ks7010/ks_wlan_net.c
@@ -51,8 +51,6 @@ static int ks_wlan_close(struct net_device *dev);
 static void ks_wlan_set_rx_mode(struct net_device *dev);
 static struct net_device_stats *ks_wlan_get_stats(struct net_device *dev);
 static int ks_wlan_set_mac_address(struct net_device *dev, void *addr);
-static int ks_wlan_netdev_ioctl(struct net_device *dev, struct ifreq *rq,
-				int cmd);
 
 static atomic_t update_phyinfo;
 static struct timer_list update_phyinfo_timer;
@@ -2451,24 +2449,6 @@ static const struct iw_handler_def ks_wlan_handler_def = {
 	.get_wireless_stats = ks_get_wireless_stats,
 };
 
-static int ks_wlan_netdev_ioctl(struct net_device *dev, struct ifreq *rq,
-				int cmd)
-{
-	int ret;
-	struct iwreq *wrq = (struct iwreq *)rq;
-
-	switch (cmd) {
-	case SIOCIWFIRSTPRIV + 20:	/* KS_WLAN_SET_STOP_REQ */
-		ret = ks_wlan_set_stop_request(dev, NULL, &wrq->u.mode, NULL);
-		break;
-		// All other calls are currently unsupported
-	default:
-		ret = -EOPNOTSUPP;
-	}
-
-	return ret;
-}
-
 static
 struct net_device_stats *ks_wlan_get_stats(struct net_device *dev)
 {
@@ -2601,7 +2581,6 @@ static const struct net_device_ops ks_wlan_netdev_ops = {
 	.ndo_start_xmit = ks_wlan_start_xmit,
 	.ndo_open = ks_wlan_open,
 	.ndo_stop = ks_wlan_close,
-	.ndo_do_ioctl = ks_wlan_netdev_ioctl,
 	.ndo_set_mac_address = ks_wlan_set_mac_address,
 	.ndo_get_stats = ks_wlan_get_stats,
 	.ndo_tx_timeout = ks_wlan_tx_timeout,
diff --git a/drivers/staging/rtl8188eu/include/ieee80211.h b/drivers/staging/rtl8188eu/include/ieee80211.h
index cb6940d2aeab..fdaddad34a75 100644
--- a/drivers/staging/rtl8188eu/include/ieee80211.h
+++ b/drivers/staging/rtl8188eu/include/ieee80211.h
@@ -14,8 +14,6 @@
 
 #ifdef CONFIG_88EU_AP_MODE
 
-#define RTL_IOCTL_HOSTAPD (SIOCIWFIRSTPRIV + 28)
-
 /* RTL871X_IOCTL_HOSTAPD ioctl() cmd: */
 enum {
 	RTL871X_HOSTAPD_FLUSH = 1,
diff --git a/drivers/staging/rtl8188eu/include/osdep_intf.h b/drivers/staging/rtl8188eu/include/osdep_intf.h
index 0c2859dc1f15..e40fa7fbb5ba 100644
--- a/drivers/staging/rtl8188eu/include/osdep_intf.h
+++ b/drivers/staging/rtl8188eu/include/osdep_intf.h
@@ -21,7 +21,6 @@ u8 rtw_reset_drv_sw(struct adapter *padapter);
 void rtw_stop_drv_threads(struct adapter *padapter);
 void rtw_cancel_all_timer(struct adapter *padapter);
 
-int rtw_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 int rtw_android_priv_cmd(struct net_device *dev, struct ifreq *rq,
 			 void __user *data, int cmd);
 
diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
index 604d69ba7526..27002f1aee33 100644
--- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
@@ -1925,923 +1925,6 @@ static int dummy(struct net_device *dev, struct iw_request_info *a,
 	return -1;
 }
 
-static int wpa_set_param(struct net_device *dev, u8 name, u32 value)
-{
-	uint ret = 0;
-	struct adapter *padapter = rtw_netdev_priv(dev);
-
-	switch (name) {
-	case IEEE_PARAM_WPA_ENABLED:
-		padapter->securitypriv.dot11AuthAlgrthm = dot11AuthAlgrthm_8021X; /* 802.1x */
-		switch (value & 0xff) {
-		case 1: /* WPA */
-			padapter->securitypriv.ndisauthtype = Ndis802_11AuthModeWPAPSK; /* WPA_PSK */
-			padapter->securitypriv.ndisencryptstatus = Ndis802_11Encryption2Enabled;
-			break;
-		case 2: /* WPA2 */
-			padapter->securitypriv.ndisauthtype = Ndis802_11AuthModeWPA2PSK; /* WPA2_PSK */
-			padapter->securitypriv.ndisencryptstatus = Ndis802_11Encryption3Enabled;
-			break;
-		}
-		RT_TRACE(_module_rtl871x_ioctl_os_c, _drv_info_,
-			 ("%s:padapter->securitypriv.ndisauthtype =%d\n", __func__, padapter->securitypriv.ndisauthtype));
-		break;
-	case IEEE_PARAM_TKIP_COUNTERMEASURES:
-		break;
-	case IEEE_PARAM_DROP_UNENCRYPTED: {
-		/* HACK:
-		 *
-		 * wpa_supplicant calls set_wpa_enabled when the driver
-		 * is loaded and unloaded, regardless of if WPA is being
-		 * used.  No other calls are made which can be used to
-		 * determine if encryption will be used or not prior to
-		 * association being expected.  If encryption is not being
-		 * used, drop_unencrypted is set to false, else true -- we
-		 * can use this to determine if the CAP_PRIVACY_ON bit should
-		 * be set.
-		 */
-
-		break;
-	}
-	case IEEE_PARAM_PRIVACY_INVOKED:
-		break;
-
-	case IEEE_PARAM_AUTH_ALGS:
-		ret = wpa_set_auth_algs(dev, value);
-		break;
-	case IEEE_PARAM_IEEE_802_1X:
-		break;
-	case IEEE_PARAM_WPAX_SELECT:
-		break;
-	default:
-		ret = -EOPNOTSUPP;
-		break;
-	}
-	return ret;
-}
-
-static int wpa_mlme(struct net_device *dev, u32 command, u32 reason)
-{
-	int ret = 0;
-	struct adapter *padapter = rtw_netdev_priv(dev);
-
-	switch (command) {
-	case IEEE_MLME_STA_DEAUTH:
-		if (!rtw_set_802_11_disassociate(padapter))
-			ret = -1;
-		break;
-	case IEEE_MLME_STA_DISASSOC:
-		if (!rtw_set_802_11_disassociate(padapter))
-			ret = -1;
-		break;
-	default:
-		ret = -EOPNOTSUPP;
-		break;
-	}
-
-	return ret;
-}
-
-static int wpa_supplicant_ioctl(struct net_device *dev, struct iw_point *p)
-{
-	struct ieee_param *param;
-	uint ret = 0;
-
-	if (!p->pointer || p->length != sizeof(struct ieee_param))
-		return -EINVAL;
-
-	param = memdup_user(p->pointer, p->length);
-	if (IS_ERR(param))
-		return PTR_ERR(param);
-
-	switch (param->cmd) {
-	case IEEE_CMD_SET_WPA_PARAM:
-		ret = wpa_set_param(dev, param->u.wpa_param.name, param->u.wpa_param.value);
-		break;
-
-	case IEEE_CMD_SET_WPA_IE:
-		ret =  rtw_set_wpa_ie(rtw_netdev_priv(dev),
-				      (char *)param->u.wpa_ie.data, (u16)param->u.wpa_ie.len);
-		break;
-
-	case IEEE_CMD_SET_ENCRYPTION:
-		ret = wpa_set_encryption(dev, param, p->length);
-		break;
-
-	case IEEE_CMD_MLME:
-		ret = wpa_mlme(dev, param->u.mlme.command, param->u.mlme.reason_code);
-		break;
-
-	default:
-		DBG_88E("Unknown WPA supplicant request: %d\n", param->cmd);
-		ret = -EOPNOTSUPP;
-		break;
-	}
-
-	if (ret == 0 && copy_to_user(p->pointer, param, p->length))
-		ret = -EFAULT;
-
-	kfree(param);
-	return ret;
-}
-
-#ifdef CONFIG_88EU_AP_MODE
-static u8 set_pairwise_key(struct adapter *padapter, struct sta_info *psta)
-{
-	struct cmd_obj *ph2c;
-	struct set_stakey_parm	*psetstakey_para;
-	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
-	u8 res = _SUCCESS;
-
-	ph2c = kzalloc(sizeof(struct cmd_obj), GFP_KERNEL);
-	if (!ph2c) {
-		res = _FAIL;
-		goto exit;
-	}
-
-	psetstakey_para = kzalloc(sizeof(struct set_stakey_parm), GFP_KERNEL);
-	if (!psetstakey_para) {
-		kfree(ph2c);
-		res = _FAIL;
-		goto exit;
-	}
-
-	init_h2fwcmd_w_parm_no_rsp(ph2c, psetstakey_para, _SetStaKey_CMD_);
-
-	psetstakey_para->algorithm = (u8)psta->dot118021XPrivacy;
-
-	memcpy(psetstakey_para->addr, psta->hwaddr, ETH_ALEN);
-
-	memcpy(psetstakey_para->key, &psta->dot118021x_UncstKey, 16);
-
-	res = rtw_enqueue_cmd(pcmdpriv, ph2c);
-
-exit:
-
-	return res;
-}
-
-static int set_group_key(struct adapter *padapter, u8 *key, u8 alg, int keyid)
-{
-	u8 keylen;
-	struct cmd_obj *pcmd;
-	struct setkey_parm *psetkeyparm;
-	struct cmd_priv	*pcmdpriv = &padapter->cmdpriv;
-	int res = _SUCCESS;
-
-	DBG_88E("%s\n", __func__);
-
-	pcmd = kzalloc(sizeof(struct	cmd_obj), GFP_KERNEL);
-	if (!pcmd) {
-		res = _FAIL;
-		goto exit;
-	}
-	psetkeyparm = kzalloc(sizeof(struct setkey_parm), GFP_KERNEL);
-	if (!psetkeyparm) {
-		kfree(pcmd);
-		res = _FAIL;
-		goto exit;
-	}
-
-	psetkeyparm->keyid = (u8)keyid;
-
-	psetkeyparm->algorithm = alg;
-
-	psetkeyparm->set_tx = 1;
-
-	switch (alg) {
-	case _WEP40_:
-		keylen = 5;
-		break;
-	case _WEP104_:
-		keylen = 13;
-		break;
-	case _TKIP_:
-	case _TKIP_WTMIC_:
-	case _AES_:
-	default:
-		keylen = 16;
-	}
-
-	memcpy(&psetkeyparm->key[0], key, keylen);
-
-	pcmd->cmdcode = _SetKey_CMD_;
-	pcmd->parmbuf = (u8 *)psetkeyparm;
-	pcmd->cmdsz =  (sizeof(struct setkey_parm));
-	pcmd->rsp = NULL;
-	pcmd->rspsz = 0;
-
-	INIT_LIST_HEAD(&pcmd->list);
-
-	res = rtw_enqueue_cmd(pcmdpriv, pcmd);
-
-exit:
-
-	return res;
-}
-
-static int set_wep_key(struct adapter *padapter, u8 *key, u8 keylen, int keyid)
-{
-	u8 alg;
-
-	switch (keylen) {
-	case 5:
-		alg = _WEP40_;
-		break;
-	case 13:
-		alg = _WEP104_;
-		break;
-	default:
-		alg = _NO_PRIVACY_;
-	}
-
-	return set_group_key(padapter, key, alg, keyid);
-}
-
-static int rtw_set_encryption(struct net_device *dev, struct ieee_param *param, u32 param_len)
-{
-	int ret = 0;
-	u32 wep_key_idx, wep_key_len, wep_total_len;
-	struct ndis_802_11_wep	 *pwep = NULL;
-	struct sta_info *psta = NULL, *pbcmc_sta = NULL;
-	struct adapter *padapter = rtw_netdev_priv(dev);
-	struct mlme_priv	*pmlmepriv = &padapter->mlmepriv;
-	struct security_priv *psecuritypriv = &padapter->securitypriv;
-	struct sta_priv *pstapriv = &padapter->stapriv;
-
-	DBG_88E("%s\n", __func__);
-	param->u.crypt.err = 0;
-	param->u.crypt.alg[IEEE_CRYPT_ALG_NAME_LEN - 1] = '\0';
-	if (param_len !=  sizeof(struct ieee_param) + param->u.crypt.key_len) {
-		ret =  -EINVAL;
-		goto exit;
-	}
-	if (is_broadcast_ether_addr(param->sta_addr)) {
-		if (param->u.crypt.idx >= WEP_KEYS) {
-			ret = -EINVAL;
-			goto exit;
-		}
-	} else {
-		psta = rtw_get_stainfo(pstapriv, param->sta_addr);
-		if (!psta) {
-			DBG_88E("%s(), sta has already been removed or never been added\n", __func__);
-			goto exit;
-		}
-	}
-
-	if (strcmp(param->u.crypt.alg, "none") == 0 && (!psta)) {
-		/* todo:clear default encryption keys */
-
-		DBG_88E("clear default encryption keys, keyid =%d\n", param->u.crypt.idx);
-		goto exit;
-	}
-	if (strcmp(param->u.crypt.alg, "WEP") == 0 && (!psta)) {
-		DBG_88E("r871x_set_encryption, crypt.alg = WEP\n");
-		wep_key_idx = param->u.crypt.idx;
-		wep_key_len = param->u.crypt.key_len;
-		DBG_88E("r871x_set_encryption, wep_key_idx=%d, len=%d\n", wep_key_idx, wep_key_len);
-		if ((wep_key_idx >= WEP_KEYS) || (wep_key_len <= 0)) {
-			ret = -EINVAL;
-			goto exit;
-		}
-
-		if (wep_key_len > 0) {
-			wep_key_len = wep_key_len <= 5 ? 5 : 13;
-			wep_total_len = wep_key_len + offsetof(struct ndis_802_11_wep, KeyMaterial);
-			pwep = (struct ndis_802_11_wep *)rtw_malloc(wep_total_len);
-			if (!pwep) {
-				DBG_88E(" r871x_set_encryption: pwep allocate fail !!!\n");
-				goto exit;
-			}
-
-			memset(pwep, 0, wep_total_len);
-
-			pwep->KeyLength = wep_key_len;
-			pwep->Length = wep_total_len;
-		}
-
-		pwep->KeyIndex = wep_key_idx;
-
-		memcpy(pwep->KeyMaterial,  param->u.crypt.key, pwep->KeyLength);
-
-		if (param->u.crypt.set_tx) {
-			DBG_88E("wep, set_tx = 1\n");
-
-			psecuritypriv->ndisencryptstatus = Ndis802_11Encryption1Enabled;
-			psecuritypriv->dot11PrivacyAlgrthm = _WEP40_;
-			psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
-
-			if (pwep->KeyLength == 13) {
-				psecuritypriv->dot11PrivacyAlgrthm = _WEP104_;
-				psecuritypriv->dot118021XGrpPrivacy = _WEP104_;
-			}
-
-			psecuritypriv->dot11PrivacyKeyIndex = wep_key_idx;
-
-			memcpy(&psecuritypriv->dot11DefKey[wep_key_idx].skey[0], pwep->KeyMaterial, pwep->KeyLength);
-
-			psecuritypriv->dot11DefKeylen[wep_key_idx] = pwep->KeyLength;
-
-			set_wep_key(padapter, pwep->KeyMaterial, pwep->KeyLength, wep_key_idx);
-		} else {
-			DBG_88E("wep, set_tx = 0\n");
-
-			/* don't update "psecuritypriv->dot11PrivacyAlgrthm" and */
-			/* psecuritypriv->dot11PrivacyKeyIndex = keyid", but can rtw_set_key to cam */
-
-			memcpy(&psecuritypriv->dot11DefKey[wep_key_idx].skey[0], pwep->KeyMaterial, pwep->KeyLength);
-
-			psecuritypriv->dot11DefKeylen[wep_key_idx] = pwep->KeyLength;
-
-			set_wep_key(padapter, pwep->KeyMaterial, pwep->KeyLength, wep_key_idx);
-		}
-
-		goto exit;
-	}
-
-	if (!psta && check_fwstate(pmlmepriv, WIFI_AP_STATE)) { /*  group key */
-		if (param->u.crypt.set_tx == 1) {
-			if (strcmp(param->u.crypt.alg, "WEP") == 0) {
-				DBG_88E("%s, set group_key, WEP\n", __func__);
-
-				memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey,
-				       param->u.crypt.key, min_t(u16, param->u.crypt.key_len, 16));
-
-				psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
-				if (param->u.crypt.key_len == 13)
-					psecuritypriv->dot118021XGrpPrivacy = _WEP104_;
-			} else if (strcmp(param->u.crypt.alg, "TKIP") == 0) {
-				DBG_88E("%s, set group_key, TKIP\n", __func__);
-				psecuritypriv->dot118021XGrpPrivacy = _TKIP_;
-				memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey,
-				       param->u.crypt.key, min_t(u16, param->u.crypt.key_len, 16));
-				/* set mic key */
-				memcpy(psecuritypriv->dot118021XGrptxmickey[param->u.crypt.idx].skey, &param->u.crypt.key[16], 8);
-				memcpy(psecuritypriv->dot118021XGrprxmickey[param->u.crypt.idx].skey, &param->u.crypt.key[24], 8);
-
-				psecuritypriv->busetkipkey = true;
-			} else if (strcmp(param->u.crypt.alg, "CCMP") == 0) {
-				DBG_88E("%s, set group_key, CCMP\n", __func__);
-				psecuritypriv->dot118021XGrpPrivacy = _AES_;
-				memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey,
-				       param->u.crypt.key, min_t(u16, param->u.crypt.key_len, 16));
-			} else {
-				DBG_88E("%s, set group_key, none\n", __func__);
-				psecuritypriv->dot118021XGrpPrivacy = _NO_PRIVACY_;
-			}
-			psecuritypriv->dot118021XGrpKeyid = param->u.crypt.idx;
-			psecuritypriv->binstallGrpkey = true;
-			psecuritypriv->dot11PrivacyAlgrthm = psecuritypriv->dot118021XGrpPrivacy;/*  */
-			set_group_key(padapter, param->u.crypt.key, psecuritypriv->dot118021XGrpPrivacy, param->u.crypt.idx);
-			pbcmc_sta = rtw_get_bcmc_stainfo(padapter);
-			if (pbcmc_sta) {
-				pbcmc_sta->ieee8021x_blocked = false;
-				pbcmc_sta->dot118021XPrivacy = psecuritypriv->dot118021XGrpPrivacy;/* rx will use bmc_sta's dot118021XPrivacy */
-			}
-		}
-		goto exit;
-	}
-
-	if (psecuritypriv->dot11AuthAlgrthm == dot11AuthAlgrthm_8021X && psta) { /*  psk/802_1x */
-		if (check_fwstate(pmlmepriv, WIFI_AP_STATE)) {
-			if (param->u.crypt.set_tx == 1) {
-				memcpy(psta->dot118021x_UncstKey.skey,  param->u.crypt.key, min_t(u16, param->u.crypt.key_len, 16));
-
-				if (strcmp(param->u.crypt.alg, "WEP") == 0) {
-					DBG_88E("%s, set pairwise key, WEP\n", __func__);
-
-					psta->dot118021XPrivacy = _WEP40_;
-					if (param->u.crypt.key_len == 13)
-						psta->dot118021XPrivacy = _WEP104_;
-				} else if (strcmp(param->u.crypt.alg, "TKIP") == 0) {
-					DBG_88E("%s, set pairwise key, TKIP\n", __func__);
-
-					psta->dot118021XPrivacy = _TKIP_;
-
-					/* set mic key */
-					memcpy(psta->dot11tkiptxmickey.skey, &param->u.crypt.key[16], 8);
-					memcpy(psta->dot11tkiprxmickey.skey, &param->u.crypt.key[24], 8);
-
-					psecuritypriv->busetkipkey = true;
-				} else if (strcmp(param->u.crypt.alg, "CCMP") == 0) {
-					DBG_88E("%s, set pairwise key, CCMP\n", __func__);
-
-					psta->dot118021XPrivacy = _AES_;
-				} else {
-					DBG_88E("%s, set pairwise key, none\n", __func__);
-
-					psta->dot118021XPrivacy = _NO_PRIVACY_;
-				}
-
-				set_pairwise_key(padapter, psta);
-
-				psta->ieee8021x_blocked = false;
-			} else { /* group key??? */
-				if (strcmp(param->u.crypt.alg, "WEP") == 0) {
-					memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey,
-					       param->u.crypt.key, min_t(u16, param->u.crypt.key_len, 16));
-					psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
-					if (param->u.crypt.key_len == 13)
-						psecuritypriv->dot118021XGrpPrivacy = _WEP104_;
-				} else if (strcmp(param->u.crypt.alg, "TKIP") == 0) {
-					psecuritypriv->dot118021XGrpPrivacy = _TKIP_;
-
-					memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey,
-					       param->u.crypt.key, min_t(u16, param->u.crypt.key_len, 16));
-
-					/* set mic key */
-					memcpy(psecuritypriv->dot118021XGrptxmickey[param->u.crypt.idx].skey, &param->u.crypt.key[16], 8);
-					memcpy(psecuritypriv->dot118021XGrprxmickey[param->u.crypt.idx].skey, &param->u.crypt.key[24], 8);
-
-					psecuritypriv->busetkipkey = true;
-				} else if (strcmp(param->u.crypt.alg, "CCMP") == 0) {
-					psecuritypriv->dot118021XGrpPrivacy = _AES_;
-
-					memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey,
-					       param->u.crypt.key, min_t(u16, param->u.crypt.key_len, 16));
-				} else {
-					psecuritypriv->dot118021XGrpPrivacy = _NO_PRIVACY_;
-				}
-
-				psecuritypriv->dot118021XGrpKeyid = param->u.crypt.idx;
-
-				psecuritypriv->binstallGrpkey = true;
-
-				psecuritypriv->dot11PrivacyAlgrthm = psecuritypriv->dot118021XGrpPrivacy;/*  */
-
-				set_group_key(padapter, param->u.crypt.key, psecuritypriv->dot118021XGrpPrivacy, param->u.crypt.idx);
-
-				pbcmc_sta = rtw_get_bcmc_stainfo(padapter);
-				if (pbcmc_sta) {
-					pbcmc_sta->ieee8021x_blocked = false;
-					pbcmc_sta->dot118021XPrivacy = psecuritypriv->dot118021XGrpPrivacy;/* rx will use bmc_sta's dot118021XPrivacy */
-				}
-			}
-		}
-	}
-
-exit:
-
-	kfree(pwep);
-
-	return ret;
-}
-
-static int rtw_set_beacon(struct net_device *dev, struct ieee_param *param, int len)
-{
-	int ret = 0;
-	struct adapter *padapter = rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-	struct sta_priv *pstapriv = &padapter->stapriv;
-	unsigned char *pbuf = param->u.bcn_ie.buf;
-
-	DBG_88E("%s, len =%d\n", __func__, len);
-
-	if (!check_fwstate(pmlmepriv, WIFI_AP_STATE))
-		return -EINVAL;
-
-	memcpy(&pstapriv->max_num_sta, param->u.bcn_ie.reserved, 2);
-
-	if ((pstapriv->max_num_sta > NUM_STA) || (pstapriv->max_num_sta <= 0))
-		pstapriv->max_num_sta = NUM_STA;
-
-	if (rtw_check_beacon_data(padapter, pbuf, len - 12 - 2) == _SUCCESS) /* 12 = param header, 2:no packed */
-		ret = 0;
-	else
-		ret = -EINVAL;
-
-	return ret;
-}
-
-static int rtw_hostapd_sta_flush(struct net_device *dev)
-{
-	struct adapter *padapter = rtw_netdev_priv(dev);
-
-	DBG_88E("%s\n", __func__);
-
-	flush_all_cam_entry(padapter);	/* clear CAM */
-
-	return rtw_sta_flush(padapter);
-}
-
-static int rtw_add_sta(struct net_device *dev, struct ieee_param *param)
-{
-	int ret = 0;
-	struct sta_info *psta = NULL;
-	struct adapter *padapter = rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-	struct sta_priv *pstapriv = &padapter->stapriv;
-
-	DBG_88E("%s(aid =%d) =%pM\n", __func__, param->u.add_sta.aid, (param->sta_addr));
-
-	if (!check_fwstate(pmlmepriv, (_FW_LINKED | WIFI_AP_STATE)))
-		return -EINVAL;
-
-	if (is_broadcast_ether_addr(param->sta_addr))
-		return -EINVAL;
-
-	psta = rtw_get_stainfo(pstapriv, param->sta_addr);
-	if (psta) {
-		int flags = param->u.add_sta.flags;
-
-		psta->aid = param->u.add_sta.aid;/* aid = 1~2007 */
-
-		memcpy(psta->bssrateset, param->u.add_sta.tx_supp_rates, 16);
-
-		/* check wmm cap. */
-		if (WLAN_STA_WME & flags)
-			psta->qos_option = 1;
-		else
-			psta->qos_option = 0;
-
-		if (pmlmepriv->qospriv.qos_option == 0)
-			psta->qos_option = 0;
-
-		/* chec 802.11n ht cap. */
-		if (WLAN_STA_HT & flags) {
-			psta->htpriv.ht_option = true;
-			psta->qos_option = 1;
-			memcpy(&psta->htpriv.ht_cap, &param->u.add_sta.ht_cap,
-			       sizeof(struct ieee80211_ht_cap));
-		} else {
-			psta->htpriv.ht_option = false;
-		}
-
-		if (!pmlmepriv->htpriv.ht_option)
-			psta->htpriv.ht_option = false;
-
-		update_sta_info_apmode(padapter, psta);
-	} else {
-		ret = -ENOMEM;
-	}
-
-	return ret;
-}
-
-static int rtw_del_sta(struct net_device *dev, struct ieee_param *param)
-{
-	struct sta_info *psta = NULL;
-	struct adapter *padapter = rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-	struct sta_priv *pstapriv = &padapter->stapriv;
-	int updated = 0;
-
-	DBG_88E("%s =%pM\n", __func__, (param->sta_addr));
-
-	if (!check_fwstate(pmlmepriv, _FW_LINKED | WIFI_AP_STATE))
-		return -EINVAL;
-
-	if (is_broadcast_ether_addr(param->sta_addr))
-		return -EINVAL;
-
-	psta = rtw_get_stainfo(pstapriv, param->sta_addr);
-	if (psta) {
-		spin_lock_bh(&pstapriv->asoc_list_lock);
-		if (!list_empty(&psta->asoc_list)) {
-			list_del_init(&psta->asoc_list);
-			pstapriv->asoc_list_cnt--;
-			updated = ap_free_sta(padapter, psta, true, WLAN_REASON_DEAUTH_LEAVING);
-		}
-		spin_unlock_bh(&pstapriv->asoc_list_lock);
-		associated_clients_update(padapter, updated);
-		psta = NULL;
-	} else {
-		DBG_88E("%s(), sta has already been removed or never been added\n", __func__);
-	}
-
-	return 0;
-}
-
-static int rtw_ioctl_get_sta_data(struct net_device *dev, struct ieee_param *param, int len)
-{
-	int ret = 0;
-	struct sta_info *psta = NULL;
-	struct adapter *padapter = rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-	struct sta_priv *pstapriv = &padapter->stapriv;
-	struct ieee_param_ex *param_ex = (struct ieee_param_ex *)param;
-	struct sta_data *psta_data = (struct sta_data *)param_ex->data;
-
-	DBG_88E("rtw_ioctl_get_sta_info, sta_addr: %pM\n", (param_ex->sta_addr));
-
-	if (!check_fwstate(pmlmepriv, _FW_LINKED | WIFI_AP_STATE))
-		return -EINVAL;
-
-	if (is_broadcast_ether_addr(param_ex->sta_addr))
-		return -EINVAL;
-
-	psta = rtw_get_stainfo(pstapriv, param_ex->sta_addr);
-	if (psta) {
-		psta_data->aid = (u16)psta->aid;
-		psta_data->capability = psta->capability;
-		psta_data->flags = psta->flags;
-
-/*
-		nonerp_set : BIT(0)
-		no_short_slot_time_set : BIT(1)
-		no_short_preamble_set : BIT(2)
-		no_ht_gf_set : BIT(3)
-		no_ht_set : BIT(4)
-		ht_20mhz_set : BIT(5)
-*/
-
-		psta_data->sta_set = ((psta->nonerp_set) |
-				      (psta->no_short_slot_time_set << 1) |
-				      (psta->no_short_preamble_set << 2) |
-				      (psta->no_ht_gf_set << 3) |
-				      (psta->no_ht_set << 4) |
-				      (psta->ht_20mhz_set << 5));
-		psta_data->tx_supp_rates_len =  psta->bssratelen;
-		memcpy(psta_data->tx_supp_rates, psta->bssrateset, psta->bssratelen);
-		memcpy(&psta_data->ht_cap,
-		       &psta->htpriv.ht_cap, sizeof(struct ieee80211_ht_cap));
-		psta_data->rx_pkts = psta->sta_stats.rx_data_pkts;
-		psta_data->rx_bytes = psta->sta_stats.rx_bytes;
-		psta_data->rx_drops = psta->sta_stats.rx_drops;
-		psta_data->tx_pkts = psta->sta_stats.tx_pkts;
-		psta_data->tx_bytes = psta->sta_stats.tx_bytes;
-		psta_data->tx_drops = psta->sta_stats.tx_drops;
-	} else {
-		ret = -1;
-	}
-
-	return ret;
-}
-
-static int rtw_get_sta_wpaie(struct net_device *dev, struct ieee_param *param)
-{
-	int ret = 0;
-	struct sta_info *psta = NULL;
-	struct adapter *padapter = rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-	struct sta_priv *pstapriv = &padapter->stapriv;
-
-	DBG_88E("%s, sta_addr: %pM\n", __func__, (param->sta_addr));
-
-	if (!check_fwstate(pmlmepriv, _FW_LINKED | WIFI_AP_STATE))
-		return -EINVAL;
-
-	if (is_broadcast_ether_addr(param->sta_addr))
-		return -EINVAL;
-
-	psta = rtw_get_stainfo(pstapriv, param->sta_addr);
-	if (psta) {
-		if (psta->wpa_ie[0] == WLAN_EID_RSN ||
-		    psta->wpa_ie[0] == WLAN_EID_VENDOR_SPECIFIC) {
-			int wpa_ie_len;
-			int copy_len;
-
-			wpa_ie_len = psta->wpa_ie[1];
-			copy_len = min_t(int, wpa_ie_len + 2, sizeof(psta->wpa_ie));
-			param->u.wpa_ie.len = copy_len;
-			memcpy(param->u.wpa_ie.reserved, psta->wpa_ie, copy_len);
-		} else {
-			DBG_88E("sta's wpa_ie is NONE\n");
-		}
-	} else {
-		ret = -1;
-	}
-
-	return ret;
-}
-
-static int rtw_set_wps_beacon(struct net_device *dev, struct ieee_param *param, int len)
-{
-	unsigned char wps_oui[4] = {0x0, 0x50, 0xf2, 0x04};
-	struct adapter *padapter = rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-	struct mlme_ext_priv	*pmlmeext = &padapter->mlmeextpriv;
-	int ie_len;
-
-	DBG_88E("%s, len =%d\n", __func__, len);
-
-	if (!check_fwstate(pmlmepriv, WIFI_AP_STATE))
-		return -EINVAL;
-
-	ie_len = len - 12 - 2; /* 12 = param header, 2:no packed */
-
-	kfree(pmlmepriv->wps_beacon_ie);
-	pmlmepriv->wps_beacon_ie = NULL;
-
-	if (ie_len > 0) {
-		pmlmepriv->wps_beacon_ie = rtw_malloc(ie_len);
-		pmlmepriv->wps_beacon_ie_len = ie_len;
-		if (!pmlmepriv->wps_beacon_ie) {
-			DBG_88E("%s()-%d: rtw_malloc() ERROR!\n", __func__, __LINE__);
-			return -EINVAL;
-		}
-
-		memcpy(pmlmepriv->wps_beacon_ie, param->u.bcn_ie.buf, ie_len);
-
-		update_beacon(padapter, _VENDOR_SPECIFIC_IE_, wps_oui, true);
-
-		pmlmeext->bstart_bss = true;
-	}
-
-	return 0;
-}
-
-static int rtw_set_wps_probe_resp(struct net_device *dev, struct ieee_param *param, int len)
-{
-	struct adapter *padapter = rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-	int ie_len;
-
-	DBG_88E("%s, len =%d\n", __func__, len);
-
-	if (!check_fwstate(pmlmepriv, WIFI_AP_STATE))
-		return -EINVAL;
-
-	ie_len = len - 12 - 2; /* 12 = param header, 2:no packed */
-
-	kfree(pmlmepriv->wps_probe_resp_ie);
-	pmlmepriv->wps_probe_resp_ie = NULL;
-
-	if (ie_len > 0) {
-		pmlmepriv->wps_probe_resp_ie = rtw_malloc(ie_len);
-		pmlmepriv->wps_probe_resp_ie_len = ie_len;
-		if (!pmlmepriv->wps_probe_resp_ie) {
-			DBG_88E("%s()-%d: rtw_malloc() ERROR!\n", __func__, __LINE__);
-			return -EINVAL;
-		}
-		memcpy(pmlmepriv->wps_probe_resp_ie, param->u.bcn_ie.buf, ie_len);
-	}
-
-	return 0;
-}
-
-static int rtw_set_wps_assoc_resp(struct net_device *dev, struct ieee_param *param, int len)
-{
-	struct adapter *padapter = rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-	int ie_len;
-
-	DBG_88E("%s, len =%d\n", __func__, len);
-
-	if (!check_fwstate(pmlmepriv, WIFI_AP_STATE))
-		return -EINVAL;
-
-	ie_len = len - 12 - 2; /* 12 = param header, 2:no packed */
-
-	kfree(pmlmepriv->wps_assoc_resp_ie);
-	pmlmepriv->wps_assoc_resp_ie = NULL;
-
-	if (ie_len > 0) {
-		pmlmepriv->wps_assoc_resp_ie = rtw_malloc(ie_len);
-		pmlmepriv->wps_assoc_resp_ie_len = ie_len;
-		if (!pmlmepriv->wps_assoc_resp_ie) {
-			DBG_88E("%s()-%d: rtw_malloc() ERROR!\n", __func__, __LINE__);
-			return -EINVAL;
-		}
-
-		memcpy(pmlmepriv->wps_assoc_resp_ie, param->u.bcn_ie.buf, ie_len);
-	}
-
-	return 0;
-}
-
-static int rtw_set_hidden_ssid(struct net_device *dev, struct ieee_param *param, int len)
-{
-	struct adapter *padapter = rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-	struct mlme_ext_priv	*pmlmeext = &padapter->mlmeextpriv;
-	struct mlme_ext_info *pmlmeinfo = &pmlmeext->mlmext_info;
-
-	u8 value;
-
-	if (!check_fwstate(pmlmepriv, WIFI_AP_STATE))
-		return -EINVAL;
-
-	if (param->u.wpa_param.name != 0) /* dummy test... */
-		DBG_88E("%s name(%u) != 0\n", __func__, param->u.wpa_param.name);
-	value = param->u.wpa_param.value;
-
-	/* use the same definition of hostapd's ignore_broadcast_ssid */
-	if (value != 1 && value != 2)
-		value = 0;
-	DBG_88E("%s value(%u)\n", __func__, value);
-	pmlmeinfo->hidden_ssid_mode = value;
-	return 0;
-}
-
-static int rtw_ioctl_acl_remove_sta(struct net_device *dev, struct ieee_param *param, int len)
-{
-	struct adapter *padapter = rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-
-	if (!check_fwstate(pmlmepriv, WIFI_AP_STATE))
-		return -EINVAL;
-
-	if (is_broadcast_ether_addr(param->sta_addr))
-		return -EINVAL;
-
-	return rtw_acl_remove_sta(padapter, param->sta_addr);
-}
-
-static int rtw_ioctl_acl_add_sta(struct net_device *dev, struct ieee_param *param, int len)
-{
-	struct adapter *padapter = rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-
-	if (!check_fwstate(pmlmepriv, WIFI_AP_STATE))
-		return -EINVAL;
-
-	if (is_broadcast_ether_addr(param->sta_addr))
-		return -EINVAL;
-
-	return rtw_acl_add_sta(padapter, param->sta_addr);
-}
-
-static int rtw_ioctl_set_macaddr_acl(struct net_device *dev, struct ieee_param *param, int len)
-{
-	struct adapter *padapter = rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-
-	if (!check_fwstate(pmlmepriv, WIFI_AP_STATE))
-		return -EINVAL;
-
-	rtw_set_macaddr_acl(padapter, param->u.mlme.command);
-
-	return 0;
-}
-
-static int rtw_hostapd_ioctl(struct net_device *dev, struct iw_point *p)
-{
-	struct ieee_param *param;
-	int ret = 0;
-	struct adapter *padapter = rtw_netdev_priv(dev);
-
-	/*
-	 * this function is expect to call in master mode, which allows no power saving
-	 * so, we just check hw_init_completed
-	 */
-
-	if (!padapter->hw_init_completed)
-		return -EPERM;
-
-	if (!p->pointer || p->length != sizeof(struct ieee_param))
-		return -EINVAL;
-
-	param = memdup_user(p->pointer, p->length);
-	if (IS_ERR(param))
-		return PTR_ERR(param);
-
-	switch (param->cmd) {
-	case RTL871X_HOSTAPD_FLUSH:
-		ret = rtw_hostapd_sta_flush(dev);
-		break;
-	case RTL871X_HOSTAPD_ADD_STA:
-		ret = rtw_add_sta(dev, param);
-		break;
-	case RTL871X_HOSTAPD_REMOVE_STA:
-		ret = rtw_del_sta(dev, param);
-		break;
-	case RTL871X_HOSTAPD_SET_BEACON:
-		ret = rtw_set_beacon(dev, param, p->length);
-		break;
-	case RTL871X_SET_ENCRYPTION:
-		ret = rtw_set_encryption(dev, param, p->length);
-		break;
-	case RTL871X_HOSTAPD_GET_WPAIE_STA:
-		ret = rtw_get_sta_wpaie(dev, param);
-		break;
-	case RTL871X_HOSTAPD_SET_WPS_BEACON:
-		ret = rtw_set_wps_beacon(dev, param, p->length);
-		break;
-	case RTL871X_HOSTAPD_SET_WPS_PROBE_RESP:
-		ret = rtw_set_wps_probe_resp(dev, param, p->length);
-		break;
-	case RTL871X_HOSTAPD_SET_WPS_ASSOC_RESP:
-		ret = rtw_set_wps_assoc_resp(dev, param, p->length);
-		break;
-	case RTL871X_HOSTAPD_SET_HIDDEN_SSID:
-		ret = rtw_set_hidden_ssid(dev, param, p->length);
-		break;
-	case RTL871X_HOSTAPD_GET_INFO_STA:
-		ret = rtw_ioctl_get_sta_data(dev, param, p->length);
-		break;
-	case RTL871X_HOSTAPD_SET_MACADDR_ACL:
-		ret = rtw_ioctl_set_macaddr_acl(dev, param, p->length);
-		break;
-	case RTL871X_HOSTAPD_ACL_ADD_STA:
-		ret = rtw_ioctl_acl_add_sta(dev, param, p->length);
-		break;
-	case RTL871X_HOSTAPD_ACL_REMOVE_STA:
-		ret = rtw_ioctl_acl_remove_sta(dev, param, p->length);
-		break;
-	default:
-		DBG_88E("Unknown hostapd request: %d\n", param->cmd);
-		ret = -EOPNOTSUPP;
-		break;
-	}
-
-	if (ret == 0 && copy_to_user(p->pointer, param, p->length))
-		ret = -EFAULT;
-	kfree(param);
-	return ret;
-}
-#endif
-
 #include <rtw_android.h>
 static int rtw_wx_set_priv(struct net_device *dev,
 			   struct iw_request_info *info,
@@ -2996,24 +2079,3 @@ struct iw_handler_def rtw_handlers_def = {
 	.num_standard = ARRAY_SIZE(rtw_handlers),
 	.get_wireless_stats = rtw_get_wireless_stats,
 };
-
-int rtw_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	struct iwreq *wrq = (struct iwreq *)rq;
-	int ret = 0;
-
-	switch (cmd) {
-	case RTL_IOCTL_WPA_SUPPLICANT:
-		ret = wpa_supplicant_ioctl(dev, &wrq->u.data);
-		break;
-#ifdef CONFIG_88EU_AP_MODE
-	case RTL_IOCTL_HOSTAPD:
-		ret = rtw_hostapd_ioctl(dev, &wrq->u.data);
-		break;
-#endif /*  CONFIG_88EU_AP_MODE */
-	default:
-		ret = -EOPNOTSUPP;
-		break;
-	}
-	return ret;
-}
diff --git a/drivers/staging/rtl8188eu/os_dep/os_intfs.c b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
index 9b126200a208..a62490bb38de 100644
--- a/drivers/staging/rtl8188eu/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8188eu/os_dep/os_intfs.c
@@ -289,7 +289,6 @@ static const struct net_device_ops rtw_netdev_ops = {
 	.ndo_select_queue = rtw_select_queue,
 	.ndo_set_mac_address = rtw_net_set_mac_address,
 	.ndo_get_stats = rtw_net_get_stats,
-	.ndo_do_ioctl = rtw_ioctl,
 	.ndo_siocdevprivate = rtw_android_priv_cmd,
 };
 
diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 27dc181c4c9b..b6166f199b1a 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -3471,114 +3471,6 @@ static int r8192_set_mac_adr(struct net_device *dev, void *mac)
 	return 0;
 }
 
-/* based on ipw2200 driver */
-static int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	struct r8192_priv *priv = (struct r8192_priv *)ieee80211_priv(dev);
-	struct iwreq *wrq = (struct iwreq *)rq;
-	int ret = -1;
-	struct ieee80211_device *ieee = priv->ieee80211;
-	u32 key[4];
-	u8 broadcast_addr[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-	struct iw_point *p = &wrq->u.data;
-	struct ieee_param *ipw = NULL;
-
-	mutex_lock(&priv->wx_mutex);
-
-	if (p->length < sizeof(struct ieee_param) || !p->pointer) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	ipw = memdup_user(p->pointer, p->length);
-	if (IS_ERR(ipw)) {
-		ret = PTR_ERR(ipw);
-		goto out;
-	}
-
-	switch (cmd) {
-	case RTL_IOCTL_WPA_SUPPLICANT:
-		/* parse here for HW security */
-		if (ipw->cmd == IEEE_CMD_SET_ENCRYPTION) {
-			if (ipw->u.crypt.set_tx) {
-				if (strcmp(ipw->u.crypt.alg, "CCMP") == 0) {
-					ieee->pairwise_key_type = KEY_TYPE_CCMP;
-				} else if (strcmp(ipw->u.crypt.alg, "TKIP") == 0) {
-					ieee->pairwise_key_type = KEY_TYPE_TKIP;
-				} else if (strcmp(ipw->u.crypt.alg, "WEP") == 0) {
-					if (ipw->u.crypt.key_len == 13)
-						ieee->pairwise_key_type = KEY_TYPE_WEP104;
-					else if (ipw->u.crypt.key_len == 5)
-						ieee->pairwise_key_type = KEY_TYPE_WEP40;
-				} else {
-					ieee->pairwise_key_type = KEY_TYPE_NA;
-				}
-
-				if (ieee->pairwise_key_type) {
-					memcpy((u8 *)key, ipw->u.crypt.key, 16);
-					EnableHWSecurityConfig8192(dev);
-					/* We fill both index entry and 4th
-					 * entry for pairwise key as in IPW
-					 * interface, adhoc will only get here,
-					 * so we need index entry for its
-					 * default key serching!
-					 */
-					setKey(dev, 4, ipw->u.crypt.idx,
-					       ieee->pairwise_key_type,
-					       (u8 *)ieee->ap_mac_addr,
-					       0, key);
-					if (ieee->auth_mode != 2)
-						setKey(dev, ipw->u.crypt.idx,
-						       ipw->u.crypt.idx,
-						       ieee->pairwise_key_type,
-						       (u8 *)ieee->ap_mac_addr,
-						       0, key);
-				}
-			} else {
-				memcpy((u8 *)key, ipw->u.crypt.key, 16);
-				if (strcmp(ipw->u.crypt.alg, "CCMP") == 0) {
-					ieee->group_key_type = KEY_TYPE_CCMP;
-				} else if (strcmp(ipw->u.crypt.alg, "TKIP") == 0) {
-					ieee->group_key_type = KEY_TYPE_TKIP;
-				} else if (strcmp(ipw->u.crypt.alg, "WEP") == 0) {
-					if (ipw->u.crypt.key_len == 13)
-						ieee->group_key_type = KEY_TYPE_WEP104;
-					else if (ipw->u.crypt.key_len == 5)
-						ieee->group_key_type = KEY_TYPE_WEP40;
-				} else {
-					ieee->group_key_type = KEY_TYPE_NA;
-				}
-
-				if (ieee->group_key_type) {
-					setKey(dev, ipw->u.crypt.idx,
-					       /* KeyIndex */
-					       ipw->u.crypt.idx,
-					       /* KeyType */
-					       ieee->group_key_type,
-					       /* MacAddr */
-					       broadcast_addr,
-					       /* DefaultKey */
-					       0,
-					       /* KeyContent */
-					       key);
-				}
-			}
-		}
-		ret = ieee80211_wpa_supplicant_ioctl(priv->ieee80211,
-						     &wrq->u.data);
-		break;
-
-	default:
-		ret = -EOPNOTSUPP;
-		break;
-	}
-	kfree(ipw);
-	ipw = NULL;
-out:
-	mutex_unlock(&priv->wx_mutex);
-	return ret;
-}
-
 static u8 HwRateToMRate90(bool bIsHT, u8 rate)
 {
 	u8  ret_rate = 0xff;
@@ -4683,7 +4575,6 @@ static const struct net_device_ops rtl8192_netdev_ops = {
 	.ndo_stop               = rtl8192_close,
 	.ndo_get_stats          = rtl8192_stats,
 	.ndo_tx_timeout         = tx_timeout,
-	.ndo_do_ioctl           = rtl8192_ioctl,
 	.ndo_set_rx_mode	= r8192_set_multicast,
 	.ndo_set_mac_address    = r8192_set_mac_adr,
 	.ndo_validate_addr      = eth_validate_addr,
diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
index 0c3ae8495afb..bd0b320a9384 100644
--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -191,7 +191,6 @@ static const struct net_device_ops rtl8712_netdev_ops = {
 	.ndo_start_xmit = r8712_xmit_entry,
 	.ndo_set_mac_address = r871x_net_set_mac_address,
 	.ndo_get_stats = r871x_net_get_stats,
-	.ndo_do_ioctl = r871x_ioctl,
 };
 
 struct net_device *r8712_init_netdev(void)
diff --git a/drivers/staging/rtl8712/osdep_intf.h b/drivers/staging/rtl8712/osdep_intf.h
index 9e75116c987e..ce823030bfec 100644
--- a/drivers/staging/rtl8712/osdep_intf.h
+++ b/drivers/staging/rtl8712/osdep_intf.h
@@ -27,6 +27,4 @@ struct intf_priv {
 	struct completion io_retevt_comp;
 };
 
-int r871x_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
-
 #endif	/*_OSDEP_INTF_H_*/
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index cbaa7a489748..d41ea0a60b21 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -36,9 +36,6 @@
 #include <linux/if_arp.h>
 #include <linux/etherdevice.h>
 
-
-#define RTL_IOCTL_WPA_SUPPLICANT	(SIOCIWFIRSTPRIV + 0x1E)
-
 #define SCAN_ITEM_SIZE 768
 #define MAX_CUSTOM_LEN 64
 #define RATE_COUNT 4
@@ -2068,128 +2065,6 @@ static int r871x_wps_start(struct net_device *dev,
 	return 0;
 }
 
-static int wpa_set_param(struct net_device *dev, u8 name, u32 value)
-{
-	struct _adapter *padapter = netdev_priv(dev);
-
-	switch (name) {
-	case IEEE_PARAM_WPA_ENABLED:
-		padapter->securitypriv.AuthAlgrthm = 2; /* 802.1x */
-		switch ((value) & 0xff) {
-		case 1: /* WPA */
-			padapter->securitypriv.ndisauthtype =
-				Ndis802_11AuthModeWPAPSK; /* WPA_PSK */
-			padapter->securitypriv.ndisencryptstatus =
-				Ndis802_11Encryption2Enabled;
-			break;
-		case 2: /* WPA2 */
-			padapter->securitypriv.ndisauthtype =
-				Ndis802_11AuthModeWPA2PSK; /* WPA2_PSK */
-			padapter->securitypriv.ndisencryptstatus =
-				Ndis802_11Encryption3Enabled;
-			break;
-		}
-		break;
-	case IEEE_PARAM_TKIP_COUNTERMEASURES:
-		break;
-	case IEEE_PARAM_DROP_UNENCRYPTED:
-		/* HACK:
-		 *
-		 * wpa_supplicant calls set_wpa_enabled when the driver
-		 * is loaded and unloaded, regardless of if WPA is being
-		 * used.  No other calls are made which can be used to
-		 * determine if encryption will be used or not prior to
-		 * association being expected.  If encryption is not being
-		 * used, drop_unencrypted is set to false, else true -- we
-		 * can use this to determine if the CAP_PRIVACY_ON bit should
-		 * be set.
-		 */
-		break;
-	case IEEE_PARAM_PRIVACY_INVOKED:
-		break;
-	case IEEE_PARAM_AUTH_ALGS:
-		return wpa_set_auth_algs(dev, value);
-	case IEEE_PARAM_IEEE_802_1X:
-		break;
-	case IEEE_PARAM_WPAX_SELECT:
-		/* added for WPA2 mixed mode */
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-	return 0;
-}
-
-static int wpa_mlme(struct net_device *dev, u32 command, u32 reason)
-{
-	struct _adapter *padapter = netdev_priv(dev);
-
-	switch (command) {
-	case IEEE_MLME_STA_DEAUTH:
-		if (!r8712_set_802_11_disassociate(padapter))
-			return -1;
-		break;
-	case IEEE_MLME_STA_DISASSOC:
-		if (!r8712_set_802_11_disassociate(padapter))
-			return -1;
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-	return 0;
-}
-
-static int wpa_supplicant_ioctl(struct net_device *dev, struct iw_point *p)
-{
-	struct ieee_param *param;
-	int ret = 0;
-	struct _adapter *padapter = netdev_priv(dev);
-
-	if (p->length < sizeof(struct ieee_param) || !p->pointer)
-		return -EINVAL;
-	param = memdup_user(p->pointer, p->length);
-	if (IS_ERR(param))
-		return PTR_ERR(param);
-	switch (param->cmd) {
-	case IEEE_CMD_SET_WPA_PARAM:
-		ret = wpa_set_param(dev, param->u.wpa_param.name,
-		      param->u.wpa_param.value);
-		break;
-	case IEEE_CMD_SET_WPA_IE:
-		ret =  r871x_set_wpa_ie(padapter, (char *)param->u.wpa_ie.data,
-		       (u16)param->u.wpa_ie.len);
-		break;
-	case IEEE_CMD_SET_ENCRYPTION:
-		ret = wpa_set_encryption(dev, param, p->length);
-		break;
-	case IEEE_CMD_MLME:
-		ret = wpa_mlme(dev, param->u.mlme.command,
-		      param->u.mlme.reason_code);
-		break;
-	default:
-		ret = -EOPNOTSUPP;
-		break;
-	}
-	if (ret == 0 && copy_to_user(p->pointer, param, p->length))
-		ret = -EFAULT;
-	kfree(param);
-	return ret;
-}
-
-/* based on "driver_ipw" and for hostapd */
-int r871x_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	struct iwreq *wrq = (struct iwreq *)rq;
-
-	switch (cmd) {
-	case RTL_IOCTL_WPA_SUPPLICANT:
-		return wpa_supplicant_ioctl(dev, &wrq->u.data);
-	default:
-		return -EOPNOTSUPP;
-	}
-	return 0;
-}
-
 static iw_handler r8711_handlers[] = {
 	NULL,				/* SIOCSIWCOMMIT */
 	r8711_wx_get_name,		/* SIOCGIWNAME */
diff --git a/drivers/staging/rtl8723bs/include/osdep_intf.h b/drivers/staging/rtl8723bs/include/osdep_intf.h
index 1f194b94c63c..1c022cc531b8 100644
--- a/drivers/staging/rtl8723bs/include/osdep_intf.h
+++ b/drivers/staging/rtl8723bs/include/osdep_intf.h
@@ -53,7 +53,6 @@ u32 rtw_start_drv_threads(struct adapter *padapter);
 void rtw_stop_drv_threads(struct adapter *padapter);
 void rtw_cancel_all_timer(struct adapter *padapter);
 
-int rtw_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 int rtw_siocdevprivate(struct net_device *dev, struct ifreq *rq,
 		       void __user *data, int cmd);
 
diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
index ef2b5f84564c..3ba636f6a6b2 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -3246,1069 +3246,6 @@ static int rtw_dbg_port(struct net_device *dev,
 
 }
 
-static int wpa_set_param(struct net_device *dev, u8 name, u32 value)
-{
-	uint ret = 0;
-	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
-
-	switch (name) {
-	case IEEE_PARAM_WPA_ENABLED:
-
-		padapter->securitypriv.dot11AuthAlgrthm = dot11AuthAlgrthm_8021X; /* 802.1x */
-
-		/* ret = ieee80211_wpa_enable(ieee, value); */
-
-		switch ((value)&0xff) {
-		case 1: /* WPA */
-			padapter->securitypriv.ndisauthtype = Ndis802_11AuthModeWPAPSK; /* WPA_PSK */
-			padapter->securitypriv.ndisencryptstatus = Ndis802_11Encryption2Enabled;
-			break;
-		case 2: /* WPA2 */
-			padapter->securitypriv.ndisauthtype = Ndis802_11AuthModeWPA2PSK; /* WPA2_PSK */
-			padapter->securitypriv.ndisencryptstatus = Ndis802_11Encryption3Enabled;
-			break;
-		}
-
-		RT_TRACE(_module_rtl871x_ioctl_os_c, _drv_info_, ("wpa_set_param:padapter->securitypriv.ndisauthtype =%d\n", padapter->securitypriv.ndisauthtype));
-
-		break;
-
-	case IEEE_PARAM_TKIP_COUNTERMEASURES:
-		/* ieee->tkip_countermeasures =value; */
-		break;
-
-	case IEEE_PARAM_DROP_UNENCRYPTED:
-	{
-		/* HACK:
-		 *
-		 * wpa_supplicant calls set_wpa_enabled when the driver
-		 * is loaded and unloaded, regardless of if WPA is being
-		 * used.  No other calls are made which can be used to
-		 * determine if encryption will be used or not prior to
-		 * association being expected.  If encryption is not being
-		 * used, drop_unencrypted is set to false, else true -- we
-		 * can use this to determine if the CAP_PRIVACY_ON bit should
-		 * be set.
-		 */
-		break;
-
-	}
-	case IEEE_PARAM_PRIVACY_INVOKED:
-
-		/* ieee->privacy_invoked =value; */
-
-		break;
-
-	case IEEE_PARAM_AUTH_ALGS:
-
-		ret = wpa_set_auth_algs(dev, value);
-
-		break;
-
-	case IEEE_PARAM_IEEE_802_1X:
-
-		/* ieee->ieee802_1x =value; */
-
-		break;
-
-	case IEEE_PARAM_WPAX_SELECT:
-
-		/*  added for WPA2 mixed mode */
-		/* DBG_871X(KERN_WARNING "------------------------>wpax value = %x\n", value); */
-		/*
-		spin_lock_irqsave(&ieee->wpax_suitlist_lock, flags);
-		ieee->wpax_type_set = 1;
-		ieee->wpax_type_notify = value;
-		spin_unlock_irqrestore(&ieee->wpax_suitlist_lock, flags);
-		*/
-
-		break;
-
-	default:
-
-
-
-		ret = -EOPNOTSUPP;
-
-
-		break;
-
-	}
-
-	return ret;
-
-}
-
-static int wpa_mlme(struct net_device *dev, u32 command, u32 reason)
-{
-	int ret = 0;
-	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
-
-	switch (command) {
-	case IEEE_MLME_STA_DEAUTH:
-
-		if (!rtw_set_802_11_disassociate(padapter))
-			ret = -1;
-
-		break;
-
-	case IEEE_MLME_STA_DISASSOC:
-
-		if (!rtw_set_802_11_disassociate(padapter))
-			ret = -1;
-
-		break;
-
-	default:
-		ret = -EOPNOTSUPP;
-		break;
-	}
-
-	return ret;
-
-}
-
-static int wpa_supplicant_ioctl(struct net_device *dev, struct iw_point *p)
-{
-	struct ieee_param *param;
-	uint ret = 0;
-
-	/* down(&ieee->wx_sem); */
-
-	if (!p->pointer || p->length != sizeof(struct ieee_param))
-		return -EINVAL;
-
-	param = rtw_malloc(p->length);
-	if (param == NULL)
-		return -ENOMEM;
-
-	if (copy_from_user(param, p->pointer, p->length)) {
-		kfree(param);
-		return -EFAULT;
-	}
-
-	switch (param->cmd) {
-
-	case IEEE_CMD_SET_WPA_PARAM:
-		ret = wpa_set_param(dev, param->u.wpa_param.name, param->u.wpa_param.value);
-		break;
-
-	case IEEE_CMD_SET_WPA_IE:
-		/* ret = wpa_set_wpa_ie(dev, param, p->length); */
-		ret =  rtw_set_wpa_ie((struct adapter *)rtw_netdev_priv(dev), (char *)param->u.wpa_ie.data, (u16)param->u.wpa_ie.len);
-		break;
-
-	case IEEE_CMD_SET_ENCRYPTION:
-		ret = wpa_set_encryption(dev, param, p->length);
-		break;
-
-	case IEEE_CMD_MLME:
-		ret = wpa_mlme(dev, param->u.mlme.command, param->u.mlme.reason_code);
-		break;
-
-	default:
-		DBG_871X("Unknown WPA supplicant request: %d\n", param->cmd);
-		ret = -EOPNOTSUPP;
-		break;
-
-	}
-
-	if (ret == 0 && copy_to_user(p->pointer, param, p->length))
-		ret = -EFAULT;
-
-	kfree(param);
-
-	/* up(&ieee->wx_sem); */
-	return ret;
-}
-
-static int rtw_set_encryption(struct net_device *dev, struct ieee_param *param, u32 param_len)
-{
-	int ret = 0;
-	u32 wep_key_idx, wep_key_len, wep_total_len;
-	struct ndis_802_11_wep	 *pwep = NULL;
-	struct sta_info *psta = NULL, *pbcmc_sta = NULL;
-	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
-	struct security_priv* psecuritypriv = &(padapter->securitypriv);
-	struct sta_priv *pstapriv = &padapter->stapriv;
-
-	DBG_871X("%s\n", __func__);
-
-	param->u.crypt.err = 0;
-	param->u.crypt.alg[IEEE_CRYPT_ALG_NAME_LEN - 1] = '\0';
-
-	/* sizeof(struct ieee_param) = 64 bytes; */
-	/* if (param_len !=  (u32) ((u8 *) param->u.crypt.key - (u8 *) param) + param->u.crypt.key_len) */
-	if (param_len !=  sizeof(struct ieee_param) + param->u.crypt.key_len) {
-		ret =  -EINVAL;
-		goto exit;
-	}
-
-	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
-	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
-		if (param->u.crypt.idx >= WEP_KEYS) {
-			ret = -EINVAL;
-			goto exit;
-		}
-	} else {
-		psta = rtw_get_stainfo(pstapriv, param->sta_addr);
-		if (!psta) {
-			/* ret = -EINVAL; */
-			DBG_871X("rtw_set_encryption(), sta has already been removed or never been added\n");
-			goto exit;
-		}
-	}
-
-	if (strcmp(param->u.crypt.alg, "none") == 0 && (psta == NULL)) {
-		/* todo:clear default encryption keys */
-
-		psecuritypriv->dot11AuthAlgrthm = dot11AuthAlgrthm_Open;
-		psecuritypriv->ndisencryptstatus = Ndis802_11EncryptionDisabled;
-		psecuritypriv->dot11PrivacyAlgrthm = _NO_PRIVACY_;
-		psecuritypriv->dot118021XGrpPrivacy = _NO_PRIVACY_;
-
-		DBG_871X("clear default encryption keys, keyid =%d\n", param->u.crypt.idx);
-
-		goto exit;
-	}
-
-
-	if (strcmp(param->u.crypt.alg, "WEP") == 0 && (psta == NULL)) {
-		DBG_871X("r871x_set_encryption, crypt.alg = WEP\n");
-
-		wep_key_idx = param->u.crypt.idx;
-		wep_key_len = param->u.crypt.key_len;
-
-		DBG_871X("r871x_set_encryption, wep_key_idx =%d, len =%d\n", wep_key_idx, wep_key_len);
-
-		if ((wep_key_idx >= WEP_KEYS) || (wep_key_len <= 0)) {
-			ret = -EINVAL;
-			goto exit;
-		}
-
-
-		if (wep_key_len > 0) {
-			wep_key_len = wep_key_len <= 5 ? 5 : 13;
-			wep_total_len = wep_key_len + FIELD_OFFSET(struct ndis_802_11_wep, KeyMaterial);
-			pwep = kzalloc(wep_total_len, GFP_KERNEL);
-			if (pwep == NULL) {
-				DBG_871X(" r871x_set_encryption: pwep allocate fail !!!\n");
-				goto exit;
-			}
-
-			pwep->KeyLength = wep_key_len;
-			pwep->Length = wep_total_len;
-
-		}
-
-		pwep->KeyIndex = wep_key_idx;
-
-		memcpy(pwep->KeyMaterial,  param->u.crypt.key, pwep->KeyLength);
-
-		if (param->u.crypt.set_tx) {
-			DBG_871X("wep, set_tx = 1\n");
-
-			psecuritypriv->dot11AuthAlgrthm = dot11AuthAlgrthm_Auto;
-			psecuritypriv->ndisencryptstatus = Ndis802_11Encryption1Enabled;
-			psecuritypriv->dot11PrivacyAlgrthm = _WEP40_;
-			psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
-
-			if (pwep->KeyLength == 13) {
-				psecuritypriv->dot11PrivacyAlgrthm = _WEP104_;
-				psecuritypriv->dot118021XGrpPrivacy = _WEP104_;
-			}
-
-
-			psecuritypriv->dot11PrivacyKeyIndex = wep_key_idx;
-
-			memcpy(&(psecuritypriv->dot11DefKey[wep_key_idx].skey[0]), pwep->KeyMaterial, pwep->KeyLength);
-
-			psecuritypriv->dot11DefKeylen[wep_key_idx] = pwep->KeyLength;
-
-			rtw_ap_set_wep_key(padapter, pwep->KeyMaterial, pwep->KeyLength, wep_key_idx, 1);
-		} else {
-			DBG_871X("wep, set_tx = 0\n");
-
-			/* don't update "psecuritypriv->dot11PrivacyAlgrthm" and */
-			/* psecuritypriv->dot11PrivacyKeyIndex =keyid", but can rtw_set_key to cam */
-
-			memcpy(&(psecuritypriv->dot11DefKey[wep_key_idx].skey[0]), pwep->KeyMaterial, pwep->KeyLength);
-
-			psecuritypriv->dot11DefKeylen[wep_key_idx] = pwep->KeyLength;
-
-			rtw_ap_set_wep_key(padapter, pwep->KeyMaterial, pwep->KeyLength, wep_key_idx, 0);
-		}
-
-		goto exit;
-
-	}
-
-
-	if (!psta && check_fwstate(pmlmepriv, WIFI_AP_STATE)) { /*  group key */
-		if (param->u.crypt.set_tx == 1) {
-			if (strcmp(param->u.crypt.alg, "WEP") == 0) {
-				DBG_871X("%s, set group_key, WEP\n", __func__);
-
-				memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
-
-				psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
-				if (param->u.crypt.key_len == 13)
-						psecuritypriv->dot118021XGrpPrivacy = _WEP104_;
-
-			} else if (strcmp(param->u.crypt.alg, "TKIP") == 0) {
-				DBG_871X("%s, set group_key, TKIP\n", __func__);
-
-				psecuritypriv->dot118021XGrpPrivacy = _TKIP_;
-
-				memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
-
-				/* DEBUG_ERR("set key length :param->u.crypt.key_len =%d\n", param->u.crypt.key_len); */
-				/* set mic key */
-				memcpy(psecuritypriv->dot118021XGrptxmickey[param->u.crypt.idx].skey, &(param->u.crypt.key[16]), 8);
-				memcpy(psecuritypriv->dot118021XGrprxmickey[param->u.crypt.idx].skey, &(param->u.crypt.key[24]), 8);
-
-				psecuritypriv->busetkipkey = true;
-
-			}
-			else if (strcmp(param->u.crypt.alg, "CCMP") == 0) {
-				DBG_871X("%s, set group_key, CCMP\n", __func__);
-
-				psecuritypriv->dot118021XGrpPrivacy = _AES_;
-
-				memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
-			} else {
-				DBG_871X("%s, set group_key, none\n", __func__);
-
-				psecuritypriv->dot118021XGrpPrivacy = _NO_PRIVACY_;
-			}
-
-			psecuritypriv->dot118021XGrpKeyid = param->u.crypt.idx;
-
-			psecuritypriv->binstallGrpkey = true;
-
-			psecuritypriv->dot11PrivacyAlgrthm = psecuritypriv->dot118021XGrpPrivacy;/*  */
-
-			rtw_ap_set_group_key(padapter, param->u.crypt.key, psecuritypriv->dot118021XGrpPrivacy, param->u.crypt.idx);
-
-			pbcmc_sta = rtw_get_bcmc_stainfo(padapter);
-			if (pbcmc_sta) {
-				pbcmc_sta->ieee8021x_blocked = false;
-				pbcmc_sta->dot118021XPrivacy = psecuritypriv->dot118021XGrpPrivacy;/* rx will use bmc_sta's dot118021XPrivacy */
-			}
-		}
-
-		goto exit;
-
-	}
-
-	if (psecuritypriv->dot11AuthAlgrthm == dot11AuthAlgrthm_8021X && psta) { /*  psk/802_1x */
-		if (check_fwstate(pmlmepriv, WIFI_AP_STATE)) {
-			if (param->u.crypt.set_tx == 1)	{
-				memcpy(psta->dot118021x_UncstKey.skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
-
-				if (strcmp(param->u.crypt.alg, "WEP") == 0) {
-					DBG_871X("%s, set pairwise key, WEP\n", __func__);
-
-					psta->dot118021XPrivacy = _WEP40_;
-					if (param->u.crypt.key_len == 13)
-						psta->dot118021XPrivacy = _WEP104_;
-				} else if (strcmp(param->u.crypt.alg, "TKIP") == 0) {
-					DBG_871X("%s, set pairwise key, TKIP\n", __func__);
-
-					psta->dot118021XPrivacy = _TKIP_;
-
-					/* DEBUG_ERR("set key length :param->u.crypt.key_len =%d\n", param->u.crypt.key_len); */
-					/* set mic key */
-					memcpy(psta->dot11tkiptxmickey.skey, &(param->u.crypt.key[16]), 8);
-					memcpy(psta->dot11tkiprxmickey.skey, &(param->u.crypt.key[24]), 8);
-
-					psecuritypriv->busetkipkey = true;
-
-				} else if (strcmp(param->u.crypt.alg, "CCMP") == 0) {
-
-					DBG_871X("%s, set pairwise key, CCMP\n", __func__);
-
-					psta->dot118021XPrivacy = _AES_;
-				} else {
-					DBG_871X("%s, set pairwise key, none\n", __func__);
-
-					psta->dot118021XPrivacy = _NO_PRIVACY_;
-				}
-
-				rtw_ap_set_pairwise_key(padapter, psta);
-
-				psta->ieee8021x_blocked = false;
-
-			} else { /* group key??? */
-				if (strcmp(param->u.crypt.alg, "WEP") == 0) {
-					memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
-
-					psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
-					if (param->u.crypt.key_len == 13)
-						psecuritypriv->dot118021XGrpPrivacy = _WEP104_;
-				} else if (strcmp(param->u.crypt.alg, "TKIP") == 0) {
-					psecuritypriv->dot118021XGrpPrivacy = _TKIP_;
-
-					memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
-
-					/* DEBUG_ERR("set key length :param->u.crypt.key_len =%d\n", param->u.crypt.key_len); */
-					/* set mic key */
-					memcpy(psecuritypriv->dot118021XGrptxmickey[param->u.crypt.idx].skey, &(param->u.crypt.key[16]), 8);
-					memcpy(psecuritypriv->dot118021XGrprxmickey[param->u.crypt.idx].skey, &(param->u.crypt.key[24]), 8);
-
-					psecuritypriv->busetkipkey = true;
-
-				} else if (strcmp(param->u.crypt.alg, "CCMP") == 0) {
-					psecuritypriv->dot118021XGrpPrivacy = _AES_;
-
-					memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
-				} else {
-					psecuritypriv->dot118021XGrpPrivacy = _NO_PRIVACY_;
-				}
-
-				psecuritypriv->dot118021XGrpKeyid = param->u.crypt.idx;
-
-				psecuritypriv->binstallGrpkey = true;
-
-				psecuritypriv->dot11PrivacyAlgrthm = psecuritypriv->dot118021XGrpPrivacy;/*  */
-
-				rtw_ap_set_group_key(padapter, param->u.crypt.key, psecuritypriv->dot118021XGrpPrivacy, param->u.crypt.idx);
-
-				pbcmc_sta = rtw_get_bcmc_stainfo(padapter);
-				if (pbcmc_sta) {
-					pbcmc_sta->ieee8021x_blocked = false;
-					pbcmc_sta->dot118021XPrivacy = psecuritypriv->dot118021XGrpPrivacy;/* rx will use bmc_sta's dot118021XPrivacy */
-				}
-			}
-		}
-	}
-
-exit:
-	kfree(pwep);
-
-	return ret;
-
-}
-
-static int rtw_set_beacon(struct net_device *dev, struct ieee_param *param, int len)
-{
-	int ret = 0;
-	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
-	struct sta_priv *pstapriv = &padapter->stapriv;
-	unsigned char *pbuf = param->u.bcn_ie.buf;
-
-
-	DBG_871X("%s, len =%d\n", __func__, len);
-
-	if (check_fwstate(pmlmepriv, WIFI_AP_STATE) != true)
-		return -EINVAL;
-
-	memcpy(&pstapriv->max_num_sta, param->u.bcn_ie.reserved, 2);
-
-	if ((pstapriv->max_num_sta > NUM_STA) || (pstapriv->max_num_sta <= 0))
-		pstapriv->max_num_sta = NUM_STA;
-
-
-	if (rtw_check_beacon_data(padapter, pbuf,  (len-12-2)) == _SUCCESS)/*  12 = param header, 2:no packed */
-		ret = 0;
-	else
-		ret = -EINVAL;
-
-
-	return ret;
-
-}
-
-static void rtw_hostapd_sta_flush(struct net_device *dev)
-{
-	/* _irqL irqL; */
-	/* struct list_head	*phead, *plist; */
-	/* struct sta_info *psta = NULL; */
-	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
-	/* struct sta_priv *pstapriv = &padapter->stapriv; */
-
-	DBG_871X("%s\n", __func__);
-
-	flush_all_cam_entry(padapter);	/* clear CAM */
-
-	rtw_sta_flush(padapter);
-}
-
-static int rtw_add_sta(struct net_device *dev, struct ieee_param *param)
-{
-	int ret = 0;
-	struct sta_info *psta = NULL;
-	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
-	struct sta_priv *pstapriv = &padapter->stapriv;
-
-	DBG_871X("rtw_add_sta(aid =%d) =" MAC_FMT "\n", param->u.add_sta.aid, MAC_ARG(param->sta_addr));
-
-	if (check_fwstate(pmlmepriv, (_FW_LINKED|WIFI_AP_STATE)) != true)
-		return -EINVAL;
-
-	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
-	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
-		return -EINVAL;
-	}
-
-/*
-	psta = rtw_get_stainfo(pstapriv, param->sta_addr);
-	if (psta)
-	{
-		DBG_871X("rtw_add_sta(), free has been added psta =%p\n", psta);
-		spin_lock_bh(&(pstapriv->sta_hash_lock));
-		rtw_free_stainfo(padapter,  psta);
-		spin_unlock_bh(&(pstapriv->sta_hash_lock));
-
-		psta = NULL;
-	}
-*/
-	/* psta = rtw_alloc_stainfo(pstapriv, param->sta_addr); */
-	psta = rtw_get_stainfo(pstapriv, param->sta_addr);
-	if (psta) {
-		int flags = param->u.add_sta.flags;
-
-		/* DBG_871X("rtw_add_sta(), init sta's variables, psta =%p\n", psta); */
-
-		psta->aid = param->u.add_sta.aid;/* aid = 1~2007 */
-
-		memcpy(psta->bssrateset, param->u.add_sta.tx_supp_rates, 16);
-
-
-		/* check wmm cap. */
-		if (WLAN_STA_WME&flags)
-			psta->qos_option = 1;
-		else
-			psta->qos_option = 0;
-
-		if (pmlmepriv->qospriv.qos_option == 0)
-			psta->qos_option = 0;
-
-		/* chec 802.11n ht cap. */
-		if (WLAN_STA_HT&flags) {
-			psta->htpriv.ht_option = true;
-			psta->qos_option = 1;
-			memcpy((void *)&psta->htpriv.ht_cap, (void *)&param->u.add_sta.ht_cap, sizeof(struct rtw_ieee80211_ht_cap));
-		} else {
-			psta->htpriv.ht_option = false;
-		}
-
-		if (pmlmepriv->htpriv.ht_option == false)
-			psta->htpriv.ht_option = false;
-
-		update_sta_info_apmode(padapter, psta);
-
-
-	} else {
-		ret = -ENOMEM;
-	}
-
-	return ret;
-
-}
-
-static int rtw_del_sta(struct net_device *dev, struct ieee_param *param)
-{
-	int ret = 0;
-	struct sta_info *psta = NULL;
-	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
-	struct sta_priv *pstapriv = &padapter->stapriv;
-
-	DBG_871X("rtw_del_sta =" MAC_FMT "\n", MAC_ARG(param->sta_addr));
-
-	if (check_fwstate(pmlmepriv, (_FW_LINKED|WIFI_AP_STATE)) != true)
-		return -EINVAL;
-
-	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
-	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
-		return -EINVAL;
-	}
-
-	psta = rtw_get_stainfo(pstapriv, param->sta_addr);
-	if (psta) {
-		u8 updated = false;
-
-		/* DBG_871X("free psta =%p, aid =%d\n", psta, psta->aid); */
-
-		spin_lock_bh(&pstapriv->asoc_list_lock);
-		if (list_empty(&psta->asoc_list) == false) {
-			list_del_init(&psta->asoc_list);
-			pstapriv->asoc_list_cnt--;
-			updated = ap_free_sta(padapter, psta, true, WLAN_REASON_DEAUTH_LEAVING);
-
-		}
-		spin_unlock_bh(&pstapriv->asoc_list_lock);
-
-		associated_clients_update(padapter, updated);
-
-		psta = NULL;
-
-	} else {
-		DBG_871X("rtw_del_sta(), sta has already been removed or never been added\n");
-
-		/* ret = -1; */
-	}
-
-
-	return ret;
-
-}
-
-static int rtw_ioctl_get_sta_data(struct net_device *dev, struct ieee_param *param, int len)
-{
-	int ret = 0;
-	struct sta_info *psta = NULL;
-	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
-	struct sta_priv *pstapriv = &padapter->stapriv;
-	struct ieee_param_ex *param_ex = (struct ieee_param_ex *)param;
-	struct sta_data *psta_data = (struct sta_data *)param_ex->data;
-
-	DBG_871X("rtw_ioctl_get_sta_info, sta_addr: " MAC_FMT "\n", MAC_ARG(param_ex->sta_addr));
-
-	if (check_fwstate(pmlmepriv, (_FW_LINKED|WIFI_AP_STATE)) != true)
-		return -EINVAL;
-
-	if (param_ex->sta_addr[0] == 0xff && param_ex->sta_addr[1] == 0xff &&
-	    param_ex->sta_addr[2] == 0xff && param_ex->sta_addr[3] == 0xff &&
-	    param_ex->sta_addr[4] == 0xff && param_ex->sta_addr[5] == 0xff) {
-		return -EINVAL;
-	}
-
-	psta = rtw_get_stainfo(pstapriv, param_ex->sta_addr);
-	if (psta) {
-		psta_data->aid = (u16)psta->aid;
-		psta_data->capability = psta->capability;
-		psta_data->flags = psta->flags;
-
-/*
-		nonerp_set : BIT(0)
-		no_short_slot_time_set : BIT(1)
-		no_short_preamble_set : BIT(2)
-		no_ht_gf_set : BIT(3)
-		no_ht_set : BIT(4)
-		ht_20mhz_set : BIT(5)
-*/
-
-		psta_data->sta_set = ((psta->nonerp_set) |
-							 (psta->no_short_slot_time_set << 1) |
-							 (psta->no_short_preamble_set << 2) |
-							 (psta->no_ht_gf_set << 3) |
-							 (psta->no_ht_set << 4) |
-							 (psta->ht_20mhz_set << 5));
-
-		psta_data->tx_supp_rates_len =  psta->bssratelen;
-		memcpy(psta_data->tx_supp_rates, psta->bssrateset, psta->bssratelen);
-		memcpy(&psta_data->ht_cap, &psta->htpriv.ht_cap, sizeof(struct rtw_ieee80211_ht_cap));
-		psta_data->rx_pkts = psta->sta_stats.rx_data_pkts;
-		psta_data->rx_bytes = psta->sta_stats.rx_bytes;
-		psta_data->rx_drops = psta->sta_stats.rx_drops;
-
-		psta_data->tx_pkts = psta->sta_stats.tx_pkts;
-		psta_data->tx_bytes = psta->sta_stats.tx_bytes;
-		psta_data->tx_drops = psta->sta_stats.tx_drops;
-
-
-	} else {
-		ret = -1;
-	}
-
-	return ret;
-
-}
-
-static int rtw_get_sta_wpaie(struct net_device *dev, struct ieee_param *param)
-{
-	int ret = 0;
-	struct sta_info *psta = NULL;
-	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
-	struct sta_priv *pstapriv = &padapter->stapriv;
-
-	DBG_871X("rtw_get_sta_wpaie, sta_addr: " MAC_FMT "\n", MAC_ARG(param->sta_addr));
-
-	if (check_fwstate(pmlmepriv, (_FW_LINKED|WIFI_AP_STATE)) != true)
-		return -EINVAL;
-
-	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
-	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
-		return -EINVAL;
-	}
-
-	psta = rtw_get_stainfo(pstapriv, param->sta_addr);
-	if (psta) {
-		if ((psta->wpa_ie[0] == WLAN_EID_RSN) || (psta->wpa_ie[0] == WLAN_EID_GENERIC)) {
-			int wpa_ie_len;
-			int copy_len;
-
-			wpa_ie_len = psta->wpa_ie[1];
-
-			copy_len = ((wpa_ie_len+2) > sizeof(psta->wpa_ie)) ? (sizeof(psta->wpa_ie)):(wpa_ie_len+2);
-
-			param->u.wpa_ie.len = copy_len;
-
-			memcpy(param->u.wpa_ie.reserved, psta->wpa_ie, copy_len);
-		} else {
-			/* ret = -1; */
-			DBG_871X("sta's wpa_ie is NONE\n");
-		}
-	} else {
-		ret = -1;
-	}
-
-	return ret;
-
-}
-
-static int rtw_set_wps_beacon(struct net_device *dev, struct ieee_param *param, int len)
-{
-	int ret = 0;
-	unsigned char wps_oui[4] = {0x0, 0x50, 0xf2, 0x04};
-	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
-	struct mlme_ext_priv *pmlmeext = &(padapter->mlmeextpriv);
-	int ie_len;
-
-	DBG_871X("%s, len =%d\n", __func__, len);
-
-	if (check_fwstate(pmlmepriv, WIFI_AP_STATE) != true)
-		return -EINVAL;
-
-	ie_len = len-12-2;/*  12 = param header, 2:no packed */
-
-
-	kfree(pmlmepriv->wps_beacon_ie);
-	pmlmepriv->wps_beacon_ie = NULL;
-
-	if (ie_len > 0) {
-		pmlmepriv->wps_beacon_ie = rtw_malloc(ie_len);
-		pmlmepriv->wps_beacon_ie_len = ie_len;
-		if (pmlmepriv->wps_beacon_ie == NULL) {
-			DBG_871X("%s()-%d: rtw_malloc() ERROR!\n", __func__, __LINE__);
-			return -EINVAL;
-		}
-
-		memcpy(pmlmepriv->wps_beacon_ie, param->u.bcn_ie.buf, ie_len);
-
-		update_beacon(padapter, _VENDOR_SPECIFIC_IE_, wps_oui, true);
-
-		pmlmeext->bstart_bss = true;
-	}
-
-
-	return ret;
-
-}
-
-static int rtw_set_wps_probe_resp(struct net_device *dev, struct ieee_param *param, int len)
-{
-	int ret = 0;
-	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
-	int ie_len;
-
-	DBG_871X("%s, len =%d\n", __func__, len);
-
-	if (check_fwstate(pmlmepriv, WIFI_AP_STATE) != true)
-		return -EINVAL;
-
-	ie_len = len-12-2;/*  12 = param header, 2:no packed */
-
-
-	kfree(pmlmepriv->wps_probe_resp_ie);
-	pmlmepriv->wps_probe_resp_ie = NULL;
-
-	if (ie_len > 0) {
-		pmlmepriv->wps_probe_resp_ie = rtw_malloc(ie_len);
-		pmlmepriv->wps_probe_resp_ie_len = ie_len;
-		if (pmlmepriv->wps_probe_resp_ie == NULL) {
-			DBG_871X("%s()-%d: rtw_malloc() ERROR!\n", __func__, __LINE__);
-			return -EINVAL;
-		}
-		memcpy(pmlmepriv->wps_probe_resp_ie, param->u.bcn_ie.buf, ie_len);
-	}
-
-
-	return ret;
-
-}
-
-static int rtw_set_wps_assoc_resp(struct net_device *dev, struct ieee_param *param, int len)
-{
-	int ret = 0;
-	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
-	int ie_len;
-
-	DBG_871X("%s, len =%d\n", __func__, len);
-
-	if (check_fwstate(pmlmepriv, WIFI_AP_STATE) != true)
-		return -EINVAL;
-
-	ie_len = len-12-2;/*  12 = param header, 2:no packed */
-
-
-	kfree(pmlmepriv->wps_assoc_resp_ie);
-	pmlmepriv->wps_assoc_resp_ie = NULL;
-
-	if (ie_len > 0) {
-		pmlmepriv->wps_assoc_resp_ie = rtw_malloc(ie_len);
-		pmlmepriv->wps_assoc_resp_ie_len = ie_len;
-		if (pmlmepriv->wps_assoc_resp_ie == NULL) {
-			DBG_871X("%s()-%d: rtw_malloc() ERROR!\n", __func__, __LINE__);
-			return -EINVAL;
-		}
-
-		memcpy(pmlmepriv->wps_assoc_resp_ie, param->u.bcn_ie.buf, ie_len);
-	}
-
-
-	return ret;
-
-}
-
-static int rtw_set_hidden_ssid(struct net_device *dev, struct ieee_param *param, int len)
-{
-	int ret = 0;
-	struct adapter *adapter = (struct adapter *)rtw_netdev_priv(dev);
-	struct mlme_priv *mlmepriv = &(adapter->mlmepriv);
-	struct mlme_ext_priv *mlmeext = &(adapter->mlmeextpriv);
-	struct mlme_ext_info *mlmeinfo = &(mlmeext->mlmext_info);
-	int ie_len;
-	u8 *ssid_ie;
-	char ssid[NDIS_802_11_LENGTH_SSID + 1];
-	sint ssid_len;
-	u8 ignore_broadcast_ssid;
-
-	if (check_fwstate(mlmepriv, WIFI_AP_STATE) != true)
-		return -EPERM;
-
-	if (param->u.bcn_ie.reserved[0] != 0xea)
-		return -EINVAL;
-
-	mlmeinfo->hidden_ssid_mode = ignore_broadcast_ssid = param->u.bcn_ie.reserved[1];
-
-	ie_len = len-12-2;/*  12 = param header, 2:no packed */
-	ssid_ie = rtw_get_ie(param->u.bcn_ie.buf,  WLAN_EID_SSID, &ssid_len, ie_len);
-
-	if (ssid_ie && ssid_len > 0 && ssid_len <= NDIS_802_11_LENGTH_SSID) {
-		struct wlan_bssid_ex *pbss_network = &mlmepriv->cur_network.network;
-		struct wlan_bssid_ex *pbss_network_ext = &mlmeinfo->network;
-
-		memcpy(ssid, ssid_ie+2, ssid_len);
-		ssid[ssid_len] = 0x0;
-
-		if (0)
-			DBG_871X(FUNC_ADPT_FMT" ssid:(%s,%d), from ie:(%s,%d), (%s,%d)\n", FUNC_ADPT_ARG(adapter),
-				 ssid, ssid_len,
-				 pbss_network->Ssid.Ssid, pbss_network->Ssid.SsidLength,
-				 pbss_network_ext->Ssid.Ssid, pbss_network_ext->Ssid.SsidLength);
-
-		memcpy(pbss_network->Ssid.Ssid, (void *)ssid, ssid_len);
-		pbss_network->Ssid.SsidLength = ssid_len;
-		memcpy(pbss_network_ext->Ssid.Ssid, (void *)ssid, ssid_len);
-		pbss_network_ext->Ssid.SsidLength = ssid_len;
-
-		if (0)
-			DBG_871X(FUNC_ADPT_FMT" after ssid:(%s,%d), (%s,%d)\n", FUNC_ADPT_ARG(adapter),
-				 pbss_network->Ssid.Ssid, pbss_network->Ssid.SsidLength,
-				 pbss_network_ext->Ssid.Ssid, pbss_network_ext->Ssid.SsidLength);
-	}
-
-	DBG_871X(FUNC_ADPT_FMT" ignore_broadcast_ssid:%d, %s,%d\n", FUNC_ADPT_ARG(adapter),
-		ignore_broadcast_ssid, ssid, ssid_len);
-
-	return ret;
-}
-
-static int rtw_ioctl_acl_remove_sta(struct net_device *dev, struct ieee_param *param, int len)
-{
-	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
-
-	if (check_fwstate(pmlmepriv, WIFI_AP_STATE) != true)
-		return -EINVAL;
-
-	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
-	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
-		return -EINVAL;
-	}
-
-	rtw_acl_remove_sta(padapter, param->sta_addr);
-	return 0;
-
-}
-
-static int rtw_ioctl_acl_add_sta(struct net_device *dev, struct ieee_param *param, int len)
-{
-	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
-
-	if (check_fwstate(pmlmepriv, WIFI_AP_STATE) != true)
-		return -EINVAL;
-
-	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
-	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
-		return -EINVAL;
-	}
-
-	return rtw_acl_add_sta(padapter, param->sta_addr);
-
-}
-
-static int rtw_ioctl_set_macaddr_acl(struct net_device *dev, struct ieee_param *param, int len)
-{
-	int ret = 0;
-	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
-	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
-
-	if (check_fwstate(pmlmepriv, WIFI_AP_STATE) != true)
-		return -EINVAL;
-
-	rtw_set_macaddr_acl(padapter, param->u.mlme.command);
-
-	return ret;
-}
-
-static int rtw_hostapd_ioctl(struct net_device *dev, struct iw_point *p)
-{
-	struct ieee_param *param;
-	int ret = 0;
-	struct adapter *padapter = (struct adapter *)rtw_netdev_priv(dev);
-
-	/* DBG_871X("%s\n", __func__); */
-
-	/*
-	* this function is expect to call in master mode, which allows no power saving
-	* so, we just check hw_init_completed
-	*/
-
-	if (!padapter->hw_init_completed)
-		return -EPERM;
-
-	if (!p->pointer || p->length != sizeof(*param))
-		return -EINVAL;
-
-	param = rtw_malloc(p->length);
-	if (param == NULL)
-		return -ENOMEM;
-
-	if (copy_from_user(param, p->pointer, p->length)) {
-		kfree(param);
-		return -EFAULT;
-	}
-
-	/* DBG_871X("%s, cmd =%d\n", __func__, param->cmd); */
-
-	switch (param->cmd) {
-	case RTL871X_HOSTAPD_FLUSH:
-
-		rtw_hostapd_sta_flush(dev);
-
-		break;
-
-	case RTL871X_HOSTAPD_ADD_STA:
-
-		ret = rtw_add_sta(dev, param);
-
-		break;
-
-	case RTL871X_HOSTAPD_REMOVE_STA:
-
-		ret = rtw_del_sta(dev, param);
-
-		break;
-
-	case RTL871X_HOSTAPD_SET_BEACON:
-
-		ret = rtw_set_beacon(dev, param, p->length);
-
-		break;
-
-	case RTL871X_SET_ENCRYPTION:
-
-		ret = rtw_set_encryption(dev, param, p->length);
-
-		break;
-
-	case RTL871X_HOSTAPD_GET_WPAIE_STA:
-
-		ret = rtw_get_sta_wpaie(dev, param);
-
-		break;
-
-	case RTL871X_HOSTAPD_SET_WPS_BEACON:
-
-		ret = rtw_set_wps_beacon(dev, param, p->length);
-
-		break;
-
-	case RTL871X_HOSTAPD_SET_WPS_PROBE_RESP:
-
-		ret = rtw_set_wps_probe_resp(dev, param, p->length);
-
-		break;
-
-	case RTL871X_HOSTAPD_SET_WPS_ASSOC_RESP:
-
-		ret = rtw_set_wps_assoc_resp(dev, param, p->length);
-
-		break;
-
-	case RTL871X_HOSTAPD_SET_HIDDEN_SSID:
-
-		ret = rtw_set_hidden_ssid(dev, param, p->length);
-
-		break;
-
-	case RTL871X_HOSTAPD_GET_INFO_STA:
-
-		ret = rtw_ioctl_get_sta_data(dev, param, p->length);
-
-		break;
-
-	case RTL871X_HOSTAPD_SET_MACADDR_ACL:
-
-		ret = rtw_ioctl_set_macaddr_acl(dev, param, p->length);
-
-		break;
-
-	case RTL871X_HOSTAPD_ACL_ADD_STA:
-
-		ret = rtw_ioctl_acl_add_sta(dev, param, p->length);
-
-		break;
-
-	case RTL871X_HOSTAPD_ACL_REMOVE_STA:
-
-		ret = rtw_ioctl_acl_remove_sta(dev, param, p->length);
-
-		break;
-
-	default:
-		DBG_871X("Unknown hostapd request: %d\n", param->cmd);
-		ret = -EOPNOTSUPP;
-		break;
-
-	}
-
-	if (ret == 0 && copy_to_user(p->pointer, param, p->length))
-		ret = -EFAULT;
-
-	kfree(param);
-	return ret;
-}
-
 static int rtw_wx_set_priv(struct net_device *dev,
 				struct iw_request_info *info,
 				union iwreq_data *awrq,
@@ -5148,23 +4085,3 @@ int rtw_siocdevprivate(struct net_device *dev, struct ifreq *rq,
 
 	return rtw_ioctl_wext_private(dev, &wrq->u);
 }
-
-int rtw_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	struct iwreq *wrq = (struct iwreq *)rq;
-	int ret = 0;
-
-	switch (cmd) {
-	case RTL_IOCTL_WPA_SUPPLICANT:
-		ret = wpa_supplicant_ioctl(dev, &wrq->u.data);
-		break;
-	case RTL_IOCTL_HOSTAPD:
-		ret = rtw_hostapd_ioctl(dev, &wrq->u.data);
-		break;
-	default:
-		ret = -EOPNOTSUPP;
-		break;
-	}
-
-	return ret;
-}
diff --git a/drivers/staging/rtl8723bs/os_dep/os_intfs.c b/drivers/staging/rtl8723bs/os_dep/os_intfs.c
index e15725ef4c27..8872ab87b62f 100644
--- a/drivers/staging/rtl8723bs/os_dep/os_intfs.c
+++ b/drivers/staging/rtl8723bs/os_dep/os_intfs.c
@@ -416,30 +416,13 @@ u16 rtw_recv_select_queue(struct sk_buff *skb)
 	return rtw_1d_to_queue[priority];
 }
 
-static int rtw_ndev_notifier_call(struct notifier_block *nb, unsigned long state, void *ptr)
-{
-	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
-
-	if (dev->netdev_ops->ndo_do_ioctl != rtw_ioctl)
-		return NOTIFY_DONE;
-
-	DBG_871X_LEVEL(_drv_info_, FUNC_NDEV_FMT " state:%lu\n", FUNC_NDEV_ARG(dev), state);
-
-	return NOTIFY_DONE;
-}
-
-static struct notifier_block rtw_ndev_notifier = {
-	.notifier_call = rtw_ndev_notifier_call,
-};
-
 int rtw_ndev_notifier_register(void)
 {
-	return register_netdevice_notifier(&rtw_ndev_notifier);
+	return 0;
 }
 
 void rtw_ndev_notifier_unregister(void)
 {
-	unregister_netdevice_notifier(&rtw_ndev_notifier);
 }
 
 
@@ -469,7 +452,6 @@ static const struct net_device_ops rtw_netdev_ops = {
 	.ndo_select_queue	= rtw_select_queue,
 	.ndo_set_mac_address = rtw_net_set_mac_address,
 	.ndo_get_stats = rtw_net_get_stats,
-	.ndo_do_ioctl = rtw_ioctl,
 	.ndo_siocdevprivate = rtw_siocdevprivate,
 };
 
-- 
2.27.0

