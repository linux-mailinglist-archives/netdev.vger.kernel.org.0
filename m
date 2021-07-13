Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B5C3C73D8
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 18:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhGMQKw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 12:10:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhGMQKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 12:10:42 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19B4C061788;
        Tue, 13 Jul 2021 09:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TXXpZdQabLRguffEGhge1V0w3b5CtBHrtxITPCZI2HY=; b=cExJpzdZSfOMhpsbaNzyxINh0w
        dsqUzuXNAV484LKNZzMPTQiyHQXhllP2Pryzjj2lR3cYsB5/raCx18LeTc2dGQ9pXK2uKeJWU6HWo
        /HwxVgn3KYuvdp8wDiOypVfLEgycnRrx55IwDE0lVlJVgfPEUuQkTJMsIusYYjvO1rz0=;
Received: from p54ae93f7.dip0.t-ipconnect.de ([84.174.147.247] helo=localhost.localdomain)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1m3Kwm-0008TX-5J; Tue, 13 Jul 2021 18:07:48 +0200
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, ryder.lee@mediatek.com
Subject: [RFC 1/7] mac80211: add support for .ndo_fill_forward_path
Date:   Tue, 13 Jul 2021 18:07:39 +0200
Message-Id: <20210713160745.59707-2-nbd@nbd.name>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210713160745.59707-1-nbd@nbd.name>
References: <20210713160745.59707-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows drivers to provide a destination device + info for flow offload
Only supported in combination with 802.3 encap offload

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/mac80211.h     |  5 ++++
 net/mac80211/driver-ops.h  | 22 +++++++++++++++
 net/mac80211/ieee80211_i.h |  2 +-
 net/mac80211/iface.c       | 58 ++++++++++++++++++++++++++++++++++++++
 net/mac80211/trace.h       |  7 +++++
 5 files changed, 93 insertions(+), 1 deletion(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d8a1d09a2141..c09ec24f8348 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4242,6 +4242,11 @@ struct ieee80211_ops {
 	void (*sta_set_decap_offload)(struct ieee80211_hw *hw,
 				      struct ieee80211_vif *vif,
 				      struct ieee80211_sta *sta, bool enabled);
+	int (*net_fill_forward_path)(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
+				     struct ieee80211_sta *sta,
+				     struct net_device_path_ctx *ctx,
+				     struct net_device_path *path);
 };
 
 /**
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index bcb7cc06db3d..f487002660e5 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1447,4 +1447,26 @@ static inline void drv_sta_set_decap_offload(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline int drv_net_fill_forward_path(struct ieee80211_local *local,
+					    struct ieee80211_sub_if_data *sdata,
+					    struct ieee80211_sta *sta,
+					    struct net_device_path_ctx *ctx,
+					    struct net_device_path *path)
+{
+	int ret = -EOPNOTSUPP;
+
+	sdata = get_bss_sdata(sdata);
+	if (!check_sdata_in_driver(sdata))
+		return -EIO;
+
+	trace_drv_net_fill_forward_path(local, sdata, sta);
+	if (local->ops->net_fill_forward_path)
+		ret = local->ops->net_fill_forward_path(&local->hw,
+							&sdata->vif, sta,
+							ctx, path);
+	trace_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC80211_DRIVER_OPS */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 22549b95d1aa..5b96e79402a1 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1451,7 +1451,7 @@ struct ieee80211_local {
 };
 
 static inline struct ieee80211_sub_if_data *
-IEEE80211_DEV_TO_SUB_IF(struct net_device *dev)
+IEEE80211_DEV_TO_SUB_IF(const struct net_device *dev)
 {
 	return netdev_priv(dev);
 }
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 1e5e9fc45523..fe093da63243 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -717,6 +717,7 @@ static const struct net_device_ops ieee80211_dataif_ops = {
 	.ndo_set_mac_address 	= ieee80211_change_mac,
 	.ndo_select_queue	= ieee80211_netdev_select_queue,
 	.ndo_get_stats64	= ieee80211_get_stats64,
+	.ndo_fill_forward_path	= ieee80211_netdev_fill_forward_path,
 };
 
 static u16 ieee80211_monitor_select_queue(struct net_device *dev,
@@ -758,6 +759,63 @@ static const struct net_device_ops ieee80211_monitorif_ops = {
 	.ndo_get_stats64	= ieee80211_get_stats64,
 };
 
+
+static int ieee80211_netdev_fill_forward_path(struct net_device_path_ctx *ctx,
+					      struct net_device_path *path)
+{
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_local *local;
+	struct sta_info *sta;
+	int ret = -ENOENT;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(ctx->dev);
+	local = sdata->local;
+
+	if (!local->ops->net_fill_forward_path)
+		return -EOPNOTSUPP;
+
+	rcu_read_lock();
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_AP_VLAN:
+		sta = rcu_dereference(sdata->u.vlan.sta);
+		if (sta)
+			break;
+		if (!sdata->wdev.use_4addr)
+			goto out;
+		fallthrough;
+	case NL80211_IFTYPE_AP:
+		if (is_multicast_ether_addr(ctx->daddr))
+			goto out;
+		sta = sta_info_get_bss(sdata, ctx->daddr);
+		break;
+	case NL80211_IFTYPE_STATION:
+		if (sdata->wdev.wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS) {
+			sta = sta_info_get(sdata, ctx->daddr);
+			if (sta && test_sta_flag(sta, WLAN_STA_TDLS_PEER)) {
+				if (!test_sta_flag(sta, WLAN_STA_TDLS_PEER_AUTH))
+					goto out;
+
+				break;
+			}
+		}
+
+		sta = sta_info_get(sdata, sdata->u.mgd.bssid);
+		break;
+	default:
+		goto out;
+	}
+
+	if (!sta)
+		goto out;
+
+	ret = drv_net_fill_forward_path(local, sdata, &sta->sta, ctx, path);
+out:
+	rcu_read_unlock();
+
+	return ret;
+}
+
+
 static const struct net_device_ops ieee80211_dataif_8023_ops = {
 	.ndo_open		= ieee80211_open,
 	.ndo_stop		= ieee80211_stop,
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index f6ef15366938..611bff1e1cd8 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2825,6 +2825,13 @@ DEFINE_EVENT(sta_flag_evt, drv_sta_set_decap_offload,
 	TP_ARGS(local, sdata, sta, enabled)
 );
 
+DEFINE_EVENT(sta_event, drv_net_fill_forward_path,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta),
+	TP_ARGS(local, sdata, sta)
+);
+
 #endif /* !__MAC80211_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.30.1

