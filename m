Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A9D2FE25A
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 07:12:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbhAUGL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 01:11:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726310AbhAUCpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 21:45:50 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA71C061786
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 18:36:36 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id 6so516899ejz.5
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 18:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D75mTe+LjZ1hczQ8JVJiFluJINJ3eH+8ioO5cMn4/eo=;
        b=a36FMurlweU5S1Ww2mwuOq7k1poz0KZhttRN+qf4mrW/0V+9GjNZV6Evmp/nwVTXym
         OVxmN0IdXpayX+oHA+Y6bel6J82UvYtkG5VaXMh2jaamByYeVjuqSlc96nfLhJvJjIeL
         0SwcjMRAcBmK2ZUWT7IIFc9ERByZ9dFfG8seTzuuqmN77zdgv5s9mhAqvJjphZCB7FxO
         ojCFgHjOX01nn/igTSiM6N3pQoPWJ2zew8M+gvlmze24sE/EiESgOObuPLjEIXD4xIYK
         WSS76ONg+PHOz0H59ReX0s0YkDqA8k++DM5rm2HvZ3HkyZ/C/Om3q2VDLEgqHTN9vDhc
         rb6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D75mTe+LjZ1hczQ8JVJiFluJINJ3eH+8ioO5cMn4/eo=;
        b=qShwWNHF8rXheEByuV3e65HpdNp6rc1ekwnGKKPsGO2akHKvauVc0hiEaPojgGQLn/
         pZWkXmN0gMK0ExhOytKFPbY7iV6he0RcXZt+DCKlyr5nrdONbhuTHXPBOOa6WG74YA9p
         2HhpHaYbSIub7fZ7sQXIzSslsrCcvoI8oAJpGi1Kwnk2Y9zCsWLDM8BCsmeKeEei8N8S
         umyM4EV7TR6KfEnZ+dVgpE2R7Lo/3m3lwQvi+X6tZ+AdWAbml3X/ZhWKx6nrhXUf8atP
         qYoGFKpShelocoL54/txQCSr8Hw6IPesgMzoE5RIvQrOuUGp5+w1GQv6+P8in08AzS8d
         7KWw==
X-Gm-Message-State: AOAM533A/ipXyVCc4Lj2W1rjkojHGb04+svkJ+4Uo7T6g7iKlrU4RX0s
        UR39s23R/uxMr4zra23ZdWw=
X-Google-Smtp-Source: ABdhPJwRv/FlTG/zbSSPof5i4wyvgsgVmKUw4OcA2X6CQwMWrNy0PpOJhrxZrll/UqPeldJpddrl/w==
X-Received: by 2002:a17:906:2087:: with SMTP id 7mr8100248ejq.232.1611196595400;
        Wed, 20 Jan 2021 18:36:35 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id k22sm2025787edv.33.2021.01.20.18.36.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 18:36:34 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v5 net-next 06/10] net: dsa: document the existing switch tree notifiers and add a new one
Date:   Thu, 21 Jan 2021 04:36:12 +0200
Message-Id: <20210121023616.1696021-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210121023616.1696021-1-olteanv@gmail.com>
References: <20210121023616.1696021-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The existence of dsa_broadcast has generated some confusion in the past:
https://www.mail-archive.com/netdev@vger.kernel.org/msg365042.html

So let's document the existing dsa_port_notify and dsa_broadcast
functions and explain when each of them should be used.

Also, in fact, the in-between function has always been there but was
lacking a name, and is the main reason for this patch: dsa_tree_notify.
Refactor dsa_broadcast to use it.

This patch also moves dsa_broadcast (a top-level function) to dsa2.c,
where it really belonged in the first place, but had no companion so it
stood with dsa_port_notify.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v5:
Patch is new.

 net/dsa/dsa2.c     | 43 +++++++++++++++++++++++++++++++++++++++++++
 net/dsa/dsa_priv.h |  2 ++
 net/dsa/port.c     | 36 +++++++++++++-----------------------
 3 files changed, 58 insertions(+), 23 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index cc13549120e5..2953d0c1c7bc 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -21,6 +21,49 @@
 static DEFINE_MUTEX(dsa2_mutex);
 LIST_HEAD(dsa_tree_list);
 
+/**
+ * dsa_tree_notify - Execute code for all switches in a DSA switch tree.
+ * @dst: collection of struct dsa_switch devices to notify.
+ * @e: event, must be of type DSA_NOTIFIER_*
+ * @v: event-specific value.
+ *
+ * Given a struct dsa_switch_tree, this can be used to run a function once for
+ * each member DSA switch. The other alternative of traversing the tree is only
+ * through its ports list, which does not uniquely list the switches.
+ */
+int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v)
+{
+	struct raw_notifier_head *nh = &dst->nh;
+	int err;
+
+	err = raw_notifier_call_chain(nh, e, v);
+
+	return notifier_to_errno(err);
+}
+
+/**
+ * dsa_broadcast - Notify all DSA trees in the system.
+ * @e: event, must be of type DSA_NOTIFIER_*
+ * @v: event-specific value.
+ *
+ * Can be used to notify the switching fabric of events such as cross-chip
+ * bridging between disjoint trees (such as islands of tagger-compatible
+ * switches bridged by an incompatible middle switch).
+ */
+int dsa_broadcast(unsigned long e, void *v)
+{
+	struct dsa_switch_tree *dst;
+	int err = 0;
+
+	list_for_each_entry(dst, &dsa_tree_list, list) {
+		err = dsa_tree_notify(dst, e, v);
+		if (err)
+			break;
+	}
+
+	return err;
+}
+
 /**
  * dsa_lag_map() - Map LAG netdev to a linear LAG ID
  * @dst: Tree in which to record the mapping.
diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 2ce46bb87703..3cc1e6d76e3a 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -283,6 +283,8 @@ void dsa_switch_unregister_notifier(struct dsa_switch *ds);
 /* dsa2.c */
 void dsa_lag_map(struct dsa_switch_tree *dst, struct net_device *lag);
 void dsa_lag_unmap(struct dsa_switch_tree *dst, struct net_device *lag);
+int dsa_tree_notify(struct dsa_switch_tree *dst, unsigned long e, void *v);
+int dsa_broadcast(unsigned long e, void *v);
 
 extern struct list_head dsa_tree_list;
 
diff --git a/net/dsa/port.c b/net/dsa/port.c
index f5b0f72ee7cd..a8886cf40160 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -13,31 +13,21 @@
 
 #include "dsa_priv.h"
 
-static int dsa_broadcast(unsigned long e, void *v)
-{
-	struct dsa_switch_tree *dst;
-	int err = 0;
-
-	list_for_each_entry(dst, &dsa_tree_list, list) {
-		struct raw_notifier_head *nh = &dst->nh;
-
-		err = raw_notifier_call_chain(nh, e, v);
-		err = notifier_to_errno(err);
-		if (err)
-			break;
-	}
-
-	return err;
-}
-
+/**
+ * dsa_port_notify - Notify the switching fabric of changes to a port
+ * @dp: port on which change occurred
+ * @e: event, must be of type DSA_NOTIFIER_*
+ * @v: event-specific value.
+ *
+ * Notify all switches in the DSA tree that this port's switch belongs to,
+ * including this switch itself, of an event. Allows the other switches to
+ * reconfigure themselves for cross-chip operations. Can also be used to
+ * reconfigure ports without net_devices (CPU ports, DSA links) whenever
+ * a user port's state changes.
+ */
 static int dsa_port_notify(const struct dsa_port *dp, unsigned long e, void *v)
 {
-	struct raw_notifier_head *nh = &dp->ds->dst->nh;
-	int err;
-
-	err = raw_notifier_call_chain(nh, e, v);
-
-	return notifier_to_errno(err);
+	return dsa_tree_notify(dp->ds->dst, e, v);
 }
 
 int dsa_port_set_state(struct dsa_port *dp, u8 state)
-- 
2.25.1

