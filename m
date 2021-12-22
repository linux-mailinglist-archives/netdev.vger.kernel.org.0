Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C6747D4A4
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343987AbhLVP6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:58:33 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:56615 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343967AbhLVP6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:58:12 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id B9E3E60012;
        Wed, 22 Dec 2021 15:58:09 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        <linux-kernel@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [net-next 17/18] net: mac802154: Let drivers provide their own beacons implementation
Date:   Wed, 22 Dec 2021 16:57:42 +0100
Message-Id: <20211222155743.256280-18-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211222155743.256280-1-miquel.raynal@bootlin.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

So far only a pure software procedure for sending beacons was possible.
Let's create a couple of driver's hooks in order to allow the device
drivers to provide their own implementation. If not provided, fallback
to the pure software logic.

It is possible for device drivers to only support a specific type of
request and return -EOPNOTSUPP otherwise, this will have the same effect
as not providing any hooks for these specific cases.

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/mac802154.h    | 13 +++++++++++++
 net/mac802154/driver-ops.h | 33 +++++++++++++++++++++++++++++++++
 net/mac802154/scan.c       | 17 +++++++++++++++++
 net/mac802154/trace.h      | 21 +++++++++++++++++++++
 4 files changed, 84 insertions(+)

diff --git a/include/net/mac802154.h b/include/net/mac802154.h
index 97aefba7bf96..72978fb72a3a 100644
--- a/include/net/mac802154.h
+++ b/include/net/mac802154.h
@@ -214,6 +214,16 @@ enum ieee802154_hw_flags {
  *	  Exits the scan mode and returns to a fully functioning state.
  *	  Should only be provided if ->enter_scan_mode() is populated.
  *	  Returns either zero, or negative errno.
+ *
+ * send_beacons
+ *	  Send beacons at a fixed rate over the current channel.
+ *	  Can be NULL, if the driver doesn't support sending beacons by itself.
+ *	  Returns either zero, or negative errno.
+ *
+ * stop_beacons
+ *	  Stops sending beacons.
+ *	  Should only be provided if ->send_beacons() is populated.
+ *	  Returns either zero, or negative errno.
  */
 struct ieee802154_ops {
 	struct module	*owner;
@@ -243,6 +253,9 @@ struct ieee802154_ops {
 	int		(*enter_scan_mode)(struct ieee802154_hw *hw,
 					   struct cfg802154_scan_request *request);
 	int		(*exit_scan_mode)(struct ieee802154_hw *hw);
+	int		(*send_beacons)(struct ieee802154_hw *hw,
+					struct cfg802154_beacons_request *request);
+	int		(*stop_beacons)(struct ieee802154_hw *hw);
 };
 
 /**
diff --git a/net/mac802154/driver-ops.h b/net/mac802154/driver-ops.h
index 2f5650f7bf91..003e6edee049 100644
--- a/net/mac802154/driver-ops.h
+++ b/net/mac802154/driver-ops.h
@@ -315,4 +315,37 @@ static inline int drv_exit_scan_mode(struct ieee802154_local *local)
 	return ret;
 }
 
+static inline int drv_send_beacons(struct ieee802154_local *local,
+				   struct cfg802154_beacons_request *request)
+{
+	int ret;
+
+	might_sleep();
+
+	if (!local->ops->send_beacons || !local->ops->stop_beacons)
+		return -EOPNOTSUPP;
+
+	trace_802154_drv_send_beacons(local, request);
+	ret = local->ops->send_beacons(&local->hw, request);
+	trace_802154_drv_return_int(local, ret);
+
+	return ret;
+}
+
+static inline int drv_stop_beacons(struct ieee802154_local *local)
+{
+	int ret;
+
+	might_sleep();
+
+	if (!local->ops->send_beacons || !local->ops->stop_beacons)
+		return -EOPNOTSUPP;
+
+	trace_802154_drv_stop_beacons(local);
+	ret = local->ops->stop_beacons(&local->hw);
+	trace_802154_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC802154_DRIVER_OPS */
diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
index b334fa856c00..55af9d16744a 100644
--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -109,6 +109,7 @@ int mac802154_send_beacons_locked(struct ieee802154_sub_if_data *sdata,
 {
 	struct ieee802154_local *local = sdata->local;
 	unsigned int interval;
+	int ret;
 
 	lockdep_assert_held(&local->beacons_lock);
 
@@ -117,6 +118,14 @@ int mac802154_send_beacons_locked(struct ieee802154_sub_if_data *sdata,
 
 	local->ongoing_beacons_request = true;
 
+	/* Either let the hardware handle the beacons or handle them manually */
+	ret = drv_send_beacons(local, request);
+	if (ret != -EOPNOTSUPP) {
+		if (ret)
+			local->ongoing_beacons_request = false;
+		return ret;
+	}
+
 	interval = mac802154_scan_get_channel_time(request->interval,
 						   request->wpan_phy->symbol_duration);
 
@@ -151,6 +160,8 @@ int mac802154_send_beacons_locked(struct ieee802154_sub_if_data *sdata,
 
 int mac802154_stop_beacons_locked(struct ieee802154_local *local)
 {
+	int ret;
+
 	lockdep_assert_held(&local->beacons_lock);
 
 	if (!local->ongoing_beacons_request)
@@ -159,6 +170,12 @@ int mac802154_stop_beacons_locked(struct ieee802154_local *local)
 	local->ongoing_beacons_request = false;
 	cancel_delayed_work(&local->beacons_work);
 
+	ret = drv_stop_beacons(local);
+	if (ret != -EOPNOTSUPP)
+		return ret;
+
+	cancel_delayed_work(&local->beacons_work);
+
 	return 0;
 }
 
diff --git a/net/mac802154/trace.h b/net/mac802154/trace.h
index 9c0a4f07ced1..b487523f83c3 100644
--- a/net/mac802154/trace.h
+++ b/net/mac802154/trace.h
@@ -292,6 +292,27 @@ DEFINE_EVENT(local_only_evt4, 802154_drv_exit_scan_mode,
 	TP_ARGS(local)
 );
 
+TRACE_EVENT(802154_drv_send_beacons,
+	TP_PROTO(struct ieee802154_local *local,
+		 struct cfg802154_beacons_request *request),
+	TP_ARGS(local, request),
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u8, interval)
+	),
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->interval = request->interval;
+	),
+	TP_printk(LOCAL_PR_FMT ", send beacons at interval: %d",
+		  LOCAL_PR_ARG, __entry->interval)
+);
+
+DEFINE_EVENT(local_only_evt4, 802154_drv_stop_beacons,
+	TP_PROTO(struct ieee802154_local *local),
+	TP_ARGS(local)
+);
+
 #endif /* !__MAC802154_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.27.0

