Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D02B4A68E9
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 01:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243081AbiBBAEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 19:04:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241930AbiBBAEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 19:04:11 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC26C061714;
        Tue,  1 Feb 2022 16:04:11 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id l5so37833500edv.3;
        Tue, 01 Feb 2022 16:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hW0A2fwb2egt5/xs/i8eOBtRqiPCD2qt3w5mV7rvVHk=;
        b=HW6wa4OLE5p9AdhPVMhkbDWrTZYb6LVT6vU1v6snQeX+DBnaB6vooLpDzbwDqLwybT
         3k0vQ9j6Bz6TknbeyD8XCNotczp7cDB4pqgL9yER19VFBdcDPKnyuXTJpiVy/lkaWktK
         1aB2jT9ykVvAFA85jWA+Yd2L5Co1lDbAvg6AyISdPneMrf9+7i2nTiv4+p626uYy9G3w
         UEczbhiZNOyvun8HIWzvOCBcfR6vFNcB1FfK2CSxKg313oWEGfXAuZYOUCBx0S5AxWVM
         OHSlmqd7s+IoWln5Bcn01uUuj4BfJhn/N1ViwSjPsaxZCPrA5XFCs4MdssoeNVgRo3dW
         kH0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hW0A2fwb2egt5/xs/i8eOBtRqiPCD2qt3w5mV7rvVHk=;
        b=wOZSqZRVt2WTsV7dndfrRo5uzmmG1sIlAuoF5IVbU2gPDNx7F/MKcccfRNoUMHg3XM
         oKrO7Lb9Sb7c3KDLB8a+kbZoe2K2d/OtniROK0mmEer9zttbqKO0cz7qMCzHZrRevNKs
         t3C7207wVN3xq2op10Nz06kGwpSvtOtqokKoVLLGcr8eH6sUigBQ5qmv6HRxquuVnfyu
         UA2QOZ1kO9Z/bLIi5q7N+NcL8H11miIBwa5IFPsNH1rFc7g6yUIYCsmYTxr88ZBs0Sz+
         yJ7DWBtEM/mwjJK42SsDJV0OlYl6nY8erqgW/rSKCbd7zpVJpR767Rr+aHDPMyMyV2mJ
         wEow==
X-Gm-Message-State: AOAM531e0CDAPIAOPtvkHkTFbk5fKgLAFNfXic6zrMB11ib6DJBPGMZ1
        swKsdswXavxuJkA9H1fxT+s=
X-Google-Smtp-Source: ABdhPJzA9X7beQoFTcSMj4xos/9dT/AK0sJDd5KS7OAM2vFmLnMEiMMGAeaIBLXYq9p9AKrbwrNplg==
X-Received: by 2002:a05:6402:1703:: with SMTP id y3mr27624037edu.239.1643760248716;
        Tue, 01 Feb 2022 16:04:08 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id n3sm3590451ejr.6.2022.02.01.16.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Feb 2022 16:04:08 -0800 (PST)
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
Subject: [net-next PATCH v8 02/16] net: dsa: replay master state events in dsa_tree_{setup,teardown}_master
Date:   Wed,  2 Feb 2022 01:03:21 +0100
Message-Id: <20220202000335.19296-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220202000335.19296-1-ansuelsmth@gmail.com>
References: <20220202000335.19296-1-ansuelsmth@gmail.com>
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
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

