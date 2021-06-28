Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DFFC3B6AB9
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 00:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238246AbhF1WEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 18:04:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237454AbhF1WDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 18:03:14 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 505A4C061767
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:48 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id bg14so32461602ejb.9
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aGonoc67Ai6XKeGNBN5cd512cH7Bt87vHd2+sbc3nEM=;
        b=LSMbUROFjz2HVKA+V5wiarxJtWPG17h7nJl2XNVL1zdaMWVBwCbd7CYi/sZbKNGwlJ
         rj9bmddZIF2VUQrbLMcupuux7BNiK78Ah1BoqqqmDgKBGaaY7LtaianO5n7a3GgRhHCS
         rNuRFVItv4b/ECo/enW39v22xTDgykrleOngxdM8YVzV9ysdfslzKZCxPG/mY07gS7H9
         xCHZoXG3wBqvz1eU2uv1iKvgKUmGzLHvACszgRiwNUwO1bI++jTt5tL9ulP11NzUNxxT
         fEmBL0LB8SyDBrYPQzIgXMOxkCCl/hd+7nGCTNZR8VkcKmBjwaSumyQ4T/BZZq7jvRQ7
         dMIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aGonoc67Ai6XKeGNBN5cd512cH7Bt87vHd2+sbc3nEM=;
        b=e0a2Qk2sJGEaKPs42iZ8Z9Ubv+9gjKmPzobMD/iedOf4ynIGuGZl28U18yUrFVMs4n
         kpD+O49Yi8Ig0zIXNZR0adeed0BMhft2Nmo+FSnGlTMNCFfMOciCFos/pCLFK8XBi86k
         UThG4hcISzmCc2gxptq/vkdQsmyzwpxn3gAwlRVHS25xcU35Jwqn9lacyaJB9vc6R3Uk
         V/EYgtvR+PrPzihU79UCgOB4B1dWDcO8DGzq9MF/a3PZBZYooi5IhDoovkjcH3zQyBEZ
         84JSQtVU7zcRdugbbhJk7EmW+lMcV0Wo3/ARiHB7+gfe/JFfv7Vo0FnoG7lRctQYcXXs
         Vwzw==
X-Gm-Message-State: AOAM532EJ2dic2KBDW9G6BZSqaAVz7+1MRQLLGQj0VX4gzeOb8LDHh8h
        fA1gYLSZbiHZPLtfPmqs3aGYPUoBOXs=
X-Google-Smtp-Source: ABdhPJzkKAD69gw4LoBRgmwqGxTdlQKei/pcPCGWsGxO9RK7yyOsCn9E80ecTZVk/oe3gkHvfYqMew==
X-Received: by 2002:a17:907:3d8e:: with SMTP id he14mr26310135ejc.374.1624917646732;
        Mon, 28 Jun 2021 15:00:46 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id dn7sm10146615edb.29.2021.06.28.15.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 15:00:46 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 12/14] net: dsa: include fdb entries pointing to bridge in the host fdb list
Date:   Tue, 29 Jun 2021 01:00:09 +0300
Message-Id: <20210628220011.1910096-13-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210628220011.1910096-1-olteanv@gmail.com>
References: <20210628220011.1910096-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The bridge supports a legacy way of adding local (non-forwarded) FDB
entries, which works on an individual port basis:

bridge fdb add dev swp0 00:01:02:03:04:05 master local

As well as a new way, added by Roopa Prabhu in commit 3741873b4f73
("bridge: allow adding of fdb entries pointing to the bridge device"):

bridge fdb add dev br0 00:01:02:03:04:05 self local

The two commands are functionally equivalent, except that the first one
produces an entry with fdb->dst == swp0, and the other an entry with
fdb->dst == NULL. The confusing part, though, is that even if fdb->dst
is swp0 for the 'local on port' entry, that destination is not used.

Nonetheless, the idea is that the bridge has reference counting for
local entries, and local entries pointing towards the bridge are still
'as local' as local entries for a port.

The bridge adds the MAC addresses of the interfaces automatically as
FDB entries with is_local=1. For the MAC address of the ports, fdb->dst
will be equal to the port, and for the MAC address of the bridge,
fdb->dst will point towards the bridge (i.e. be NULL). Therefore, if the
MAC address of the bridge is not inherited from either of the physical
ports, then we must explicitly catch local FDB entries emitted towards
the br0, otherwise we'll miss the MAC address of the bridge (and, of
course, any entry with 'bridge add dev br0 ... self local').

Co-developed-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index d006bd04f84a..a7b5d2a41472 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2415,7 +2415,11 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 			struct net_device *br_dev;
 			struct dsa_slave_priv *p;
 
-			br_dev = netdev_master_upper_dev_get_rcu(dev);
+			if (netif_is_bridge_master(dev))
+				br_dev = dev;
+			else
+				br_dev = netdev_master_upper_dev_get_rcu(dev);
+
 			if (!br_dev)
 				return NOTIFY_DONE;
 
@@ -2443,8 +2447,13 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 			 * LAG we don't want to send traffic to the CPU, the
 			 * other ports bridged with the LAG should be able to
 			 * autonomously forward towards it.
+			 * On the other hand, if the address is local
+			 * (therefore not learned) then we want to trap it to
+			 * the CPU regardless of whether the interface it
+			 * belongs to is offloaded or not.
 			 */
-			if (dsa_tree_offloads_bridge_port(dp->ds->dst, dev))
+			if (dsa_tree_offloads_bridge_port(dp->ds->dst, dev) &&
+			    !fdb_info->is_local)
 				return NOTIFY_DONE;
 		}
 
-- 
2.25.1

