Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F63148C9B0
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355814AbiALRed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:34:33 -0500
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:42287 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349894AbiALReK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:34:10 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 89A162000C;
        Wed, 12 Jan 2022 17:34:07 +0000 (UTC)
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
Subject: [wpan-next v2 25/27] net: mac802154: Inform device drivers about scans
Date:   Wed, 12 Jan 2022 18:33:10 +0100
Message-Id: <20220112173312.764660-26-miquel.raynal@bootlin.com>
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
drivers that a scan is ongoing, allowing them to eventually apply any
needed configuration, or in the worst case to refuse the operation if it
is not supported. These hooks are optional and not implementing them
does not prevent the scan operation to happen. Returning an error from
these implementations will however shut down the scan entirely.

Co-developed-by: David Girault <david.girault@qorvo.com>
Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 include/net/mac802154.h    | 12 ++++++++++++
 net/mac802154/driver-ops.h | 29 +++++++++++++++++++++++++++++
 net/mac802154/scan.c       |  7 +++++++
 net/mac802154/trace.h      | 28 ++++++++++++++++++++++++++++
 4 files changed, 76 insertions(+)

diff --git a/include/net/mac802154.h b/include/net/mac802154.h
index 19bfbf591ea1..9b852c02db88 100644
--- a/include/net/mac802154.h
+++ b/include/net/mac802154.h
@@ -204,6 +204,15 @@ enum ieee802154_hw_flags {
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
  */
 struct ieee802154_ops {
 	struct module	*owner;
@@ -230,6 +239,9 @@ struct ieee802154_ops {
 					     s8 retries);
 	int             (*set_promiscuous_mode)(struct ieee802154_hw *hw,
 						const bool on);
+	int		(*enter_scan_mode)(struct ieee802154_hw *hw,
+					   struct cfg802154_scan_request *request);
+	void		(*exit_scan_mode)(struct ieee802154_hw *hw);
 };
 
 /**
diff --git a/net/mac802154/driver-ops.h b/net/mac802154/driver-ops.h
index d23f0db98015..9da2325d8346 100644
--- a/net/mac802154/driver-ops.h
+++ b/net/mac802154/driver-ops.h
@@ -282,4 +282,33 @@ drv_set_promiscuous_mode(struct ieee802154_local *local, bool on)
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
+static inline void drv_exit_scan_mode(struct ieee802154_local *local)
+{
+	might_sleep();
+
+	if (!local->ops->enter_scan_mode || !local->ops->exit_scan_mode)
+		return;
+
+	trace_802154_drv_exit_scan_mode(local);
+	local->ops->exit_scan_mode(&local->hw);
+	trace_802154_drv_return_void(local);
+}
+
 #endif /* __MAC802154_DRIVER_OPS */
diff --git a/net/mac802154/scan.c b/net/mac802154/scan.c
index c9412dfaeb66..a639c53fa3ba 100644
--- a/net/mac802154/scan.c
+++ b/net/mac802154/scan.c
@@ -103,6 +103,8 @@ int mac802154_abort_scan_locked(struct ieee802154_local *local)
 
 	cancel_delayed_work(&local->scan_work);
 
+	drv_exit_scan_mode(local);
+
 	return mac802154_end_of_scan(local);
 }
 
@@ -327,6 +329,11 @@ int mac802154_trigger_scan_locked(struct ieee802154_sub_if_data *sdata,
 	else
 		local->scan_addr = cpu_to_le64(get_unaligned_be64(sdata->dev->dev_addr));
 
+	/* Let the drivers know  about the starting scanning operation */
+	ret = drv_enter_scan_mode(local, request);
+	if (ret)
+		return ret;
+
 	if (request->type == NL802154_SCAN_ACTIVE)
 		mac802154_scan_prepare_beacon_req(local);
 
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

