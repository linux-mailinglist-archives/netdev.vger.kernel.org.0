Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2043E4907D0
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 12:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239473AbiAQL4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 06:56:11 -0500
Received: from relay12.mail.gandi.net ([217.70.178.232]:33711 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236802AbiAQLzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 06:55:51 -0500
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id DDD30200008;
        Mon, 17 Jan 2022 11:55:48 +0000 (UTC)
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH v3 37/41] net: ieee802154: Trace the registration of new PANs
Date:   Mon, 17 Jan 2022 12:54:36 +0100
Message-Id: <20220117115440.60296-38-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220117115440.60296-1-miquel.raynal@bootlin.com>
References: <20220117115440.60296-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Girault <david.girault@qorvo.com>

Add an internal trace when new PANs get discovered.

Signed-off-by: David Girault <david.girault@qorvo.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 net/ieee802154/pan.c   |  3 +++
 net/ieee802154/trace.h | 25 +++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/net/ieee802154/pan.c b/net/ieee802154/pan.c
index 1ea15ea1b3bd..5afc0aa38a43 100644
--- a/net/ieee802154/pan.c
+++ b/net/ieee802154/pan.c
@@ -18,6 +18,7 @@
 
 #include "ieee802154.h"
 #include "core.h"
+#include "trace.h"
 
 static struct cfg802154_internal_pan *
 cfg802154_alloc_pan(struct ieee802154_pan_desc *desc)
@@ -205,6 +206,8 @@ static void cfg802154_pan_update(struct cfg802154_registered_device *rdev,
 	found = cfg802154_find_matching_pan(rdev, new);
 	if (found)
 		cfg802154_unlink_pan(rdev, found);
+	else
+		trace_802154_new_pan(&new->desc);
 
 	if (unlikely(cfg802154_need_to_expire_pans(rdev)))
 		cfg802154_expire_oldest_pan(rdev);
diff --git a/net/ieee802154/trace.h b/net/ieee802154/trace.h
index 353ba799244f..506fe4930440 100644
--- a/net/ieee802154/trace.h
+++ b/net/ieee802154/trace.h
@@ -356,6 +356,31 @@ DEFINE_EVENT(802154_wdev_template, 802154_rdev_stop_beacons,
 	TP_ARGS(wpan_phy, wpan_dev)
 );
 
+DECLARE_EVENT_CLASS(802154_pan_evt,
+	TP_PROTO(struct ieee802154_pan_desc *desc),
+	TP_ARGS(desc),
+	TP_STRUCT__entry(
+		__field(u16, pan_id)
+		__field(__le64, coord_addr)
+		__field(u8, channel)
+		__field(u8, page)
+	),
+	TP_fast_assign(
+		__entry->page = desc->page;
+		__entry->channel = desc->channel;
+		memcpy(&__entry->pan_id, &desc->coord->pan_id, 2);
+		memcpy(&__entry->coord_addr, &desc->coord->extended_addr, 8);
+	),
+	TP_printk("panid: %u, coord_addr: 0x%llx, page: %u, channel: %u",
+		  __entry->pan_id, __le64_to_cpu(__entry->coord_addr),
+		  __entry->page, __entry->channel)
+);
+
+DEFINE_EVENT(802154_pan_evt, 802154_new_pan,
+	TP_PROTO(struct ieee802154_pan_desc *desc),
+	TP_ARGS(desc)
+);
+
 TRACE_EVENT(802154_rdev_return_int,
 	TP_PROTO(struct wpan_phy *wpan_phy, int ret),
 	TP_ARGS(wpan_phy, ret),
-- 
2.27.0

