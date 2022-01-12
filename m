Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD3B48C9B9
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350069AbiALRet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:34:49 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:51829 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355728AbiALReO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:34:14 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 7163220003;
        Wed, 12 Jan 2022 17:34:09 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Michael Hennerich <michael.hennerich@analog.com>,
        Harry Morris <h.morris@cascoda.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        linux-wireless@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [wpan-next v2 26/27] net: mac802154: Inform device drivers about beacon operations
Date:   Wed, 12 Jan 2022 18:33:11 +0100
Message-Id: <20220112173312.764660-27-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220112173312.764660-1-miquel.raynal@bootlin.com>
References: <20220112173312.764660-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's create a couple of driver hooks in order to tell the device
drivers that beacons are being sent, allowing them to eventually apply
any needed configuration, or in the worst case to refuse the operation
if it is not supported. These hooks are optional and not implementing
them does not prevent the beacons operation to happen. Returning an
error from these implementations will however shut down the beacons
configuration entirely.

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/mac802154.h    | 14 ++++++++++++++
 net/mac802154/driver-ops.h | 29 +++++++++++++++++++++++++++++
 net/mac802154/scan.c       | 10 ++++++++++
 net/mac802154/trace.h      | 21 +++++++++++++++++++++
 4 files changed, 74 insertions(+)

diff --git a/include/net/mac802154.h b/include/net/mac802154.h
index 9b852c02db88..f73b4f4f1025 100644
--- a/include/net/mac802154.h
+++ b/include/net/mac802154.h
@@ -213,6 +213,17 @@ enum ieee802154_hw_flags {
  * exit_scan_mode
  *	  Exits the scan mode and returns to a fully functioning state.
  *	  Should only be provided if ->enter_scan_mode() is populated.
+ *
+ * enter_beacons_mode
+ *	  Enters the beacons mode, the stack will either send beacons at a fixed
+ *	  rate or upon request depending on the configuration.
+ *	  Can be NULL, if the driver has no internal configuration to do.
+ *	  Returns either zero, or negative errno.
+ *
+ * exit_beacons_mode
+ *	  Exits the beacons mode and returns to a fully functioning state.
+ *	  Should only be provided if ->enter_beacons_mode() is populated.
+ *	  Returns either zero, or negative errno.
  */
 struct ieee802154_ops {
 	struct module	*owner;
@@ -242,6 +253,9 @@ struct ieee802154_ops {
 	int		(*enter_scan_mode)(struct ieee802154_hw *hw,
 					   struct cfg802154_scan_request *request);
 	void		(*exit_scan_mode)(struct ieee802154_hw *hw);
+	int		(*enter_beacons_mode)(struct ieee802154_hw *hw,
+					      struct cfg802154_beacons_request *request);
+	void		(*exit_beacons_mode)(struct ieee802154_hw *hw);
 };
 
 /**
diff --git a/net/mac802154/driver-ops.h b/net/mac802154/driver-ops.h
index 9da2325d8346..fa874088a284 100644
--- a/net/mac802154/driver-ops.h
+++ b/net/mac802154/driver-ops.h
@@ -311,4 +311,33 @@ static inline void drv_exit_scan_mode(struct ieee802154_local *local)
 	trace_802154_drv_return_void(local);
 }
 
+static inline int drv_enter_beacons_mode(struct ieee802154_local *local,
+					 struct cfg802154_beacons_request *request)
+{
+	int ret;
+
+	might_sleep();
+
+	if (!local->ops->enter_beacons_mode || !local->ops->exit_beacons_mode)
+		return 0;
+
+	trace_802154_drv_enter_beacons_mode(local, request);
+	ret = local->ops->enter_beacons_mode(&local->hw, request);
+	trace_802154_drv_return_int(local, ret);
+
+	return ret;
+}
+
+static inline void drv_exit_beacons_mode(struct ieee802154_local *local)
+{
+	might_sleep();
+
+	if (!local->ops->enter_beacons_mode || !local->ops->exit_beacons_mode)
+		return;
+
+	trace_802154_drv_exit_beacons_mode(local);
+	local->ops->exit_beacons_mode(&local->hw);
+	trace_802154_drv_return_void(local);
+}
+
 #endif /* __MAC802154_DRIVER_OPS */
diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
index a639c53fa3ba..bda13448e294 100644
--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -122,6 +122,7 @@ int mac802154_send_beacons_locked(struct ieee802154_sub_if_data *sdata,
 				  struct cfg802154_beacons_request *request)
 {
 	struct ieee802154_local *local = sdata->local;
+	int ret;
 
 	lockdep_assert_held(&local->beacons_lock);
 
@@ -130,6 +131,13 @@ int mac802154_send_beacons_locked(struct ieee802154_sub_if_data *sdata,
 
 	local->ongoing_beacons_request = true;
 
+	/* Either let the hardware handle the beacons or handle them manually */
+	ret = drv_enter_beacons_mode(local, request);
+	if (ret) {
+		local->ongoing_beacons_request = false;
+		return ret;
+	}
+
 	memset(&local->beacon, 0, sizeof(local->beacon));
 	local->beacon.mhr.fc.type = IEEE802154_BEACON_FRAME;
 	local->beacon.mhr.fc.security_enabled = 0;
@@ -179,6 +187,8 @@ int mac802154_stop_beacons_locked(struct ieee802154_local *local)
 	if (local->beacons_interval >= 0)
 		cancel_delayed_work(&local->beacons_work);
 
+	drv_exit_beacons_mode(local);
+
 	return 0;
 }
 
diff --git a/net/mac802154/trace.h b/net/mac802154/trace.h
index 9c0a4f07ced1..93519181045a 100644
--- a/net/mac802154/trace.h
+++ b/net/mac802154/trace.h
@@ -292,6 +292,27 @@ DEFINE_EVENT(local_only_evt4, 802154_drv_exit_scan_mode,
 	TP_ARGS(local)
 );
 
+TRACE_EVENT(802154_drv_enter_beacons_mode,
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
+DEFINE_EVENT(local_only_evt4, 802154_drv_exit_beacons_mode,
+	TP_PROTO(struct ieee802154_local *local),
+	TP_ARGS(local)
+);
+
 #endif /* !__MAC802154_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.27.0

