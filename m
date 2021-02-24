Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F942323B72
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235029AbhBXLsD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:48:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235013AbhBXLpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:45:30 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4653C0617AB
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:14 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id g5so2546504ejt.2
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8Z8RxArzm3Bt6cO5FJ/vajivUciH4I6m9xbaFfaxYxo=;
        b=ln+4CRnkuL5bFe/atUWdDWcVVGF07mj08wZD5CuSbugk6jAVwn0oFAx2p30OpD4VFj
         T+tzUkkaERstS/bKaPzfRK9fdtzvMdcGZeUBH/Yi3T9J8XJDWKNswCsXUs8eposRD4E/
         QdpiDfGSqUbkzhkyQQ0JmP1Dhbxku7sfkptAmgV5YpYpGik8LDvuiF8xTUKlU8O2aeQw
         BomNfPe/WUV3Mo4kAEw/8MEMzdnAtvFPmMWzE50U64GSn//FH9AzG+tx5qmHVXFFoqfz
         BGB+h+PONfVnqjsS4k6N8AWideB66HdSNoQkVE0hGuYVSGOwRC/j7LTXSK+AlSKssrPy
         TQoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8Z8RxArzm3Bt6cO5FJ/vajivUciH4I6m9xbaFfaxYxo=;
        b=YjAbxw2Yzo6fFv+Wj5hXozbLRaJ9i51yHVcSobotA8jqjOqo453B8u5H/87Y9xHx9L
         Lr7AjtkybiWISVHSBWYvAx9KdibcZguSB2QHHUxsnW1To60OlZImuEx00v64j/ZSAE7m
         SrFh9km/wvvZT6YPf1w8VJ6+J03CJaIWIYUft53+cruYhFraSK3m5IbfScL4BDSlKtRT
         H26fWp9yyoZP54nmPKFukw7789M7wDI0FkJb84r/S6QzApWPFjVtnTV7O57hTv/UNrJS
         ADBw4wOUxEkXNhTz+gbIxrUk12snwr3OV07MWDJWwun3rjHzHt+3RKl8kU7vHHa7tMGS
         prVw==
X-Gm-Message-State: AOAM530UCY0/DY82zCDKNzCzMbhdLRObYiX7aWOWCulTOxzZLqYh067f
        BzPwESS2w87LyjzhlSIVG0XUa/cfZUM=
X-Google-Smtp-Source: ABdhPJwmnVIH1T8E7B2cvJi+KGmmRZu0cH1AqKZe11qE1KkntFOvCmzAJwidk6JgiYb1PR/NSyA9Dg==
X-Received: by 2002:a17:907:36e:: with SMTP id rs14mr2313823ejb.42.1614167053296;
        Wed, 24 Feb 2021 03:44:13 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm1203921ejx.96.2021.02.24.03.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:44:13 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC PATCH v2 net-next 11/17] net: dsa: include fdb entries pointing to bridge in the host fdb list
Date:   Wed, 24 Feb 2021 13:43:44 +0200
Message-Id: <20210224114350.2791260-12-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210224114350.2791260-1-olteanv@gmail.com>
References: <20210224114350.2791260-1-olteanv@gmail.com>
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
index 8d4cd27cc79f..425b3223b7d1 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2563,7 +2563,11 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
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
 
@@ -2584,8 +2588,13 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 			 * LAG we don't want to send traffic to the CPU, the
 			 * other ports bridged with the LAG should be able to
 			 * autonomously forward towards it.
+			 * On the other hand, if the address is local
+			 * (therefore not learned) then we want to trap it to
+			 * the CPU regardless of whether the interface it
+			 * belongs to is offloaded or not.
 			 */
-			if (dsa_tree_offloads_netdev(dp->ds->dst, dev))
+			if (dsa_tree_offloads_netdev(dp->ds->dst, dev) &&
+			    !fdb_info->is_local)
 				return NOTIFY_DONE;
 		}
 
-- 
2.25.1

