Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3623B53A5
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 16:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhF0ONK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 10:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhF0ONC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 10:13:02 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80D06C061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:37 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id q14so21221977eds.5
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aGonoc67Ai6XKeGNBN5cd512cH7Bt87vHd2+sbc3nEM=;
        b=Ef8eR7iC719Q5rispk3bmTL0NQdBidwmqR0kYLmSjrjyIv5E/Ml/hgPo+bGOFR7j14
         7xfcDj6YW1K8uU0RwNgjKhVXpDmvr7GK2sfZvaaSJ6oZf2DHKvmhY3NvvKwFqZV9wfzB
         amkuxPPPuUBpUXnXjVMCkjujp4pXE7LEEL60iyFeH+RkxHJ6h9+2WAlzvD4VCAcQ5o8B
         GmzKTWUguhkx/hdaTqtwv+h4wenA20TqDEy3NwBUVzjtHstM2yWsm1CfqizJp/tvJ2XZ
         tIOl71URqi7IogtXndomAPJdo/15dg00TpRPgmUu4fWMlw/OjG1zne2xT+kN9v98gcho
         2tww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aGonoc67Ai6XKeGNBN5cd512cH7Bt87vHd2+sbc3nEM=;
        b=txW/0bbndlpkPzCaQezgN3veRWFYW2jAwn6i5cFKBduVjEKf46Gts2jCvLPnjfIPxV
         LmdESSzjxpG0yPLTdstN+MFHp3f1ZbF27bZP9rD785fMYTH01+BPYzCshe2s1GPEHm9q
         xWI9fYPSL7UoKxWv+UoPYYohbdTp+8oIlGcWGfY1By0MQWaCHtHfeIgLNTyX04LmWasc
         EzN4+UEYCupQeA05AHI6zxi3n4H4G7n/gR8tLHcee67K3cKcYGHfD+nSnVYCBUsq0URM
         t6f9YgUUXhjZ8Ug40bUcLC6u1LoU2UsVg/PpDDWJVe5n8jFpm5iMvYy0dGaCpQxIkc4t
         YT8w==
X-Gm-Message-State: AOAM531/6OAKyfNoochlBJM+FIFJqsQRFBDKD4elZPPYkjMcTBiGfnco
        +wrezUMKAr9P8PdYk2QCvvHLIugnm6k=
X-Google-Smtp-Source: ABdhPJy76YBfWdLer278IN+hKl0pG4BHWxqsvUQS73JZOqF8+XCd9jlX6DFb619lcSiCPN8RDz+IJA==
X-Received: by 2002:aa7:d413:: with SMTP id z19mr27779734edq.37.1624803036027;
        Sun, 27 Jun 2021 07:10:36 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7857389edu.49.2021.06.27.07.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 07:10:35 -0700 (PDT)
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
Subject: [RFC PATCH v3 net-next 13/15] net: dsa: include fdb entries pointing to bridge in the host fdb list
Date:   Sun, 27 Jun 2021 17:10:11 +0300
Message-Id: <20210627141013.1273942-14-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210627141013.1273942-1-olteanv@gmail.com>
References: <20210627141013.1273942-1-olteanv@gmail.com>
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

