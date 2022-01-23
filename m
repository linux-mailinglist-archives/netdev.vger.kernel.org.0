Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE64496F69
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 02:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235255AbiAWBdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 20:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235224AbiAWBdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 20:33:45 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 142F1C06173B;
        Sat, 22 Jan 2022 17:33:45 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id j2so11048174ejk.6;
        Sat, 22 Jan 2022 17:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1f21rqjO++zRISxHBRo/gChgYZDRgqrJD1AbgYqQ8Rw=;
        b=Dxf70AD+WzUJQisFqXuMZ1So1PxZgij5pGqSzuGP9AbY/etK/EljMmXBupUDcPSx3C
         ESBIZq0g3W1os3Lbapd+a+uhS5wCcievyRO08Rh38YsfzEZIZNxZN2mDgH53SsHy/IQe
         viqdMVdXKLDHeyXRGC8LKhRNsR7Pey6NaSdQJAQETbWqkqCHhlzyiSAkZC+NeiiMOAIj
         9Lue3rtZwzcRxYTk4Y7Uz7FF6OPq7dV9mj1duUV/WJQ5xvfdOfj2tbiWHfBFsce6corn
         kV3tmKSzx2xMEZbctRrhQkPYyMP8v6+hj6txmOPDiPQX1XBcLJWW15h4+1I4tKpamjEN
         djSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1f21rqjO++zRISxHBRo/gChgYZDRgqrJD1AbgYqQ8Rw=;
        b=clZ/Hyzdzm9yuYpRpKXfz0rTVyBzJIyD9AWLw5v1+SuvaNUW//z0LmtL7FLrP9vZoa
         owvBjhDQCtrMzKtqmk0O1kEBf37xQIaskGgfJU0Ux2fs7eGMZSpqzX208Dn1zXMWl3kX
         ywvas3mcf3sybfCVdwmWVZa6vJdWrdja0OHbu8fdCT4W31pe6ATYG/FQHkMViLM0haf6
         Y9xXPFAsqPjLwyyfksC+51TmftR+s2xb0kf4Pn8dEE+jVXrV24tyO2qF2X6m0RGosity
         U1CDf9ZJ2g4Y2CBaYXJt0wMZR17l3Gu6E78Y/0jt9BzqUFAOVhVBYFUfvChAUHbW33Nv
         xaZg==
X-Gm-Message-State: AOAM5300vPysCjU7S1BlC8czcLWv9soiprcUFxrAYzYgxUG78dBsjqDM
        qrY40hO2s8RwIxlSWhal540=
X-Google-Smtp-Source: ABdhPJwRv/MUm8BX7nB0cZ/hEGogz9Tug1Ju3UhMT084i0IP0wa2B1NAy7itcGlJ5PMWM8C8RFzWEA==
X-Received: by 2002:a17:906:9b8e:: with SMTP id dd14mr8006535ejc.307.1642901623536;
        Sat, 22 Jan 2022 17:33:43 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id fy40sm3259866ejc.36.2022.01.22.17.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Jan 2022 17:33:43 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ansuel Smith <ansuelsmth@gmail.com>
Subject: [RFC PATCH v7 02/16] net: dsa: replay master state events in dsa_tree_{setup,teardown}_master
Date:   Sun, 23 Jan 2022 02:33:23 +0100
Message-Id: <20220123013337.20945-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220123013337.20945-1-ansuelsmth@gmail.com>
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In order for switch driver to be able to make simple and reliable use of
the master tracking operations, they must also be notified of the
initial state of the DSA master, not just of the changes. This is
because they might enable certain features only during the time when
they know that the DSA master is up and running.

Therefore, this change explicitly checks the state of the DSA master
under the same rtnl_mutex as we were holding during the
dsa_master_setup() and dsa_master_teardown() call. The idea being that
if the DSA master became operational in between the moment in which it
became a DSA master (dsa_master_setup set dev->dsa_ptr) and the moment
when we checked for the master being up, there is a chance that we
would emit a ->master_state_change() call with no actual state change.
We need to avoid that by serializing the concurrent netdevice event with
us. If the netdevice event started before, we force it to finish before
we begin, because we take rtnl_lock before making netdev_uses_dsa()
return true. So we also handle that early event and do nothing on it.
Similarly, if the dev_open() attempt is concurrent with us, it will
attempt to take the rtnl_mutex, but we're holding it. We'll see that
the master flag IFF_UP isn't set, then when we release the rtnl_mutex
we'll process the NETDEV_UP notifier.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 net/dsa/dsa2.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index ff998c0ede02..909b045c9b11 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -15,6 +15,7 @@
 #include <linux/of.h>
 #include <linux/of_net.h>
 #include <net/devlink.h>
+#include <net/sch_generic.h>
 
 #include "dsa_priv.h"
 
@@ -1064,9 +1065,18 @@ static int dsa_tree_setup_master(struct dsa_switch_tree *dst)
 
 	list_for_each_entry(dp, &dst->ports, list) {
 		if (dsa_port_is_cpu(dp)) {
-			err = dsa_master_setup(dp->master, dp);
+			struct net_device *master = dp->master;
+			bool admin_up = (master->flags & IFF_UP) &&
+					!qdisc_tx_is_noop(master);
+
+			err = dsa_master_setup(master, dp);
 			if (err)
 				return err;
+
+			/* Replay master state event */
+			dsa_tree_master_admin_state_change(dst, master, admin_up);
+			dsa_tree_master_oper_state_change(dst, master,
+							  netif_oper_up(master));
 		}
 	}
 
@@ -1081,9 +1091,19 @@ static void dsa_tree_teardown_master(struct dsa_switch_tree *dst)
 
 	rtnl_lock();
 
-	list_for_each_entry(dp, &dst->ports, list)
-		if (dsa_port_is_cpu(dp))
-			dsa_master_teardown(dp->master);
+	list_for_each_entry(dp, &dst->ports, list) {
+		if (dsa_port_is_cpu(dp)) {
+			struct net_device *master = dp->master;
+
+			/* Synthesizing an "admin down" state is sufficient for
+			 * the switches to get a notification if the master is
+			 * currently up and running.
+			 */
+			dsa_tree_master_admin_state_change(dst, master, false);
+
+			dsa_master_teardown(master);
+		}
+	}
 
 	rtnl_unlock();
 }
-- 
2.33.1

