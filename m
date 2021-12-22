Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC13747D499
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 16:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343927AbhLVP6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 10:58:23 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:59117 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343902AbhLVP6G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 10:58:06 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 3C0786000C;
        Wed, 22 Dec 2021 15:58:04 +0000 (UTC)
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
Subject: [net-next 13/18] net: mac802154: Inform device drivers about the scanning operation
Date:   Wed, 22 Dec 2021 16:57:38 +0100
Message-Id: <20211222155743.256280-14-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20211222155743.256280-1-miquel.raynal@bootlin.com>
References: <20211222155743.256280-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Let's create a couple of driver hooks in order to tell the device
drivers that a scan is ongoing, if they need to apply a particular
configuration. These hooks are optional.

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/mac802154.h    | 13 +++++++++++++
 net/mac802154/driver-ops.h | 33 +++++++++++++++++++++++++++++++++
 net/mac802154/scan.c       |  7 +++++++
 net/mac802154/trace.h      | 28 ++++++++++++++++++++++++++++
 4 files changed, 81 insertions(+)

diff --git a/include/net/mac802154.h b/include/net/mac802154.h
index 19bfbf591ea1..97aefba7bf96 100644
--- a/include/net/mac802154.h
+++ b/include/net/mac802154.h
@@ -204,6 +204,16 @@ enum ieee802154_hw_flags {
  *
  * set_promiscuous_mode
  *	  Enables or disable promiscuous mode.
+ *
+ * enter_scan_mode
+ *	  Enters the scan mode, may then refuse certain operations.
+ *	  Can be NULL, if the driver has no internal configuration to do.
+ *	  Returns either zero, or negative errno.
+ *
+ * exit_scan_mode
+ *	  Exits the scan mode and returns to a fully functioning state.
+ *	  Should only be provided if ->enter_scan_mode() is populated.
+ *	  Returns either zero, or negative errno.
  */
 struct ieee802154_ops {
 	struct module	*owner;
@@ -230,6 +240,9 @@ struct ieee802154_ops {
 					     s8 retries);
 	int             (*set_promiscuous_mode)(struct ieee802154_hw *hw,
 						const bool on);
+	int		(*enter_scan_mode)(struct ieee802154_hw *hw,
+					   struct cfg802154_scan_request *request);
+	int		(*exit_scan_mode)(struct ieee802154_hw *hw);
 };
 
 /**
diff --git a/net/mac802154/driver-ops.h b/net/mac802154/driver-ops.h
index d23f0db98015..2f5650f7bf91 100644
--- a/net/mac802154/driver-ops.h
+++ b/net/mac802154/driver-ops.h
@@ -282,4 +282,37 @@ drv_set_promiscuous_mode(struct ieee802154_local *local, bool on)
 	return ret;
 }
 
+static inline int drv_enter_scan_mode(struct ieee802154_local *local,
+				      struct cfg802154_scan_request *request)
+{
+	int ret;
+
+	might_sleep();
+
+	if (!local->ops->enter_scan_mode || !local->ops->exit_scan_mode)
+		return 0;
+
+	trace_802154_drv_enter_scan_mode(local, request);
+	ret = local->ops->enter_scan_mode(&local->hw, request);
+	trace_802154_drv_return_int(local, ret);
+
+	return ret;
+}
+
+static inline int drv_exit_scan_mode(struct ieee802154_local *local)
+{
+	int ret;
+
+	might_sleep();
+
+	if (!local->ops->exit_scan_mode)
+		return 0;
+
+	trace_802154_drv_exit_scan_mode(local);
+	ret = local->ops->exit_scan_mode(&local->hw);
+	trace_802154_drv_return_int(local, ret);
+
+	return ret;
+}
+
 #endif /* __MAC802154_DRIVER_OPS */
diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
index c5b85eaec319..1382489d4e58 100644
--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -87,6 +87,8 @@ int mac802154_abort_scan_locked(struct ieee802154_local *local)
 	if (!local->scanning)
 		return -ESRCH;
 
+	drv_exit_scan_mode(local);
+
 	cancel_delayed_work(&local->scan_work);
 
 	return mac802154_end_of_scan(local);
@@ -186,6 +188,11 @@ int mac802154_trigger_scan_locked(struct ieee802154_sub_if_data *sdata,
 	else
 		local->scan_addr = cpu_to_le64(get_unaligned_be64(sdata->dev->dev_addr));
 
+	/* Inform the hardware about the scanning operation starting */
+	ret = drv_enter_scan_mode(local, request);
+	if (ret)
+		return ret;
+
 	local->scan_channel_idx = -1;
 	local->scanning = true;
 
diff --git a/net/mac802154/trace.h b/net/mac802154/trace.h
index df855c33daf2..9c0a4f07ced1 100644
--- a/net/mac802154/trace.h
+++ b/net/mac802154/trace.h
@@ -264,6 +264,34 @@ TRACE_EVENT(802154_drv_set_promiscuous_mode,
 		  BOOL_TO_STR(__entry->on))
 );
 
+TRACE_EVENT(802154_drv_enter_scan_mode,
+	TP_PROTO(struct ieee802154_local *local,
+		 struct cfg802154_scan_request *request),
+	TP_ARGS(local, request),
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		__field(u8, page)
+		__field(u32, channels)
+		__field(u8, duration)
+		__field(u64, addr)
+	),
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		__entry->page = request->page;
+		__entry->channels = request->channels;
+		__entry->duration = request->duration;
+		__entry->addr = local->scan_addr;
+	),
+	TP_printk(LOCAL_PR_FMT ", scan, page: %d, channels: %x, duration %d, addr: 0x%llx",
+		  LOCAL_PR_ARG, __entry->page, __entry->channels,
+		  __entry->duration, __entry->addr)
+);
+
+DEFINE_EVENT(local_only_evt4, 802154_drv_exit_scan_mode,
+	TP_PROTO(struct ieee802154_local *local),
+	TP_ARGS(local)
+);
+
 #endif /* !__MAC802154_DRIVER_TRACE || TRACE_HEADER_MULTI_READ */
 
 #undef TRACE_INCLUDE_PATH
-- 
2.27.0

