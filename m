Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02D163CE84F
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 19:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355836AbhGSQkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 12:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347591AbhGSQgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 12:36:37 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4E6C078813
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 09:49:57 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id oz7so26090002ejc.2
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 10:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0cf2LlS6jWfQkusBdzzkz/uvVmHVHUO2QoyYAj4uPiI=;
        b=Gkm9g8hVYMOhtrs9MTG+1zFy8TL/tamGGnCnIrlm+IOtoTAHVbv/K3knrcbhKNtLh1
         DYOnkhmtPquPsFpuVbsVwOL79M2+a84h9oTZHx1EpcF9VHvWdGIudiRX9TStEKB57tP0
         54OddR1Zf+EuQ8khnjxVeua9jStoybFiAOr/RaFx0KF5qjyW1xzR4BjUTnRCihyhB+ct
         XGQ0LCgYpOowd3ybZzlAyXFROfrQJE+ra+/fGseWvNfBwG9k2DJeACff9SvKldqR2nI4
         y8VFTpUoI3nXTWu7F5Ellv5vh3lnO2jndI4tSXFpN8MgRH7ajwPrKWEsJbNguoihHsNO
         juwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0cf2LlS6jWfQkusBdzzkz/uvVmHVHUO2QoyYAj4uPiI=;
        b=RBeY2cwwuAfL93ff0TTpHGkNFi58/OXFj5OaFUaaeR0vfeaYbpZph+MfJSE/dlzbJl
         47XSW73I7h0231vvzu5xkbZ29l0On5DRx3RFe98Pn6fOU5YLw+gOGXzTpdXr4PdmOWKG
         6gvvzDuUbAde1TLfGUQPzTXFBkJ1p/E8lpJaAqemIKExElxwDkP4MCI88feGTR6LC2ef
         w97ZrpW2272gwHyQP+qJS8ICEVeXYlBx12jaUxH0VwqLJyWixh2Zk+jkA4akW2UosXEs
         T5oXfLg/CtTkHOCvHBvs82Wy/0Q7TNaw18Gjya4QTAUcjRzqInk8Ve0Y7Uwe5oc9HasY
         Zq5Q==
X-Gm-Message-State: AOAM532ospngJpGpYMFqvdwF7gew+8gB7aYTIlFrrMBjRSUpsg23d8WN
        UvOXVojg0CFjYZ5KI6tojo3D0pkkM8wKz/zPriE=
X-Google-Smtp-Source: ABdhPJwtOFuV3FqU4fr00EqQNTXvoFiTqke8X4xPkej103amW1xUOkZ9vR0U74QcOE0oI6EH95REwQ==
X-Received: by 2002:a17:906:2a04:: with SMTP id j4mr28744231eje.344.1626714609073;
        Mon, 19 Jul 2021 10:10:09 -0700 (PDT)
Received: from debil.vdiclient.nvidia.com (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id nc29sm6073896ejc.10.2021.07.19.10.10.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 10:10:08 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     roopa@nvidia.com, bridge@lists.linux-foundation.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 13/15] net: bridge: vlan: add support for dumping global vlan options
Date:   Mon, 19 Jul 2021 20:06:35 +0300
Message-Id: <20210719170637.435541-14-razor@blackwall.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210719170637.435541-1-razor@blackwall.org>
References: <20210719170637.435541-1-razor@blackwall.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@nvidia.com>

Add a new vlan options dump flag which causes only global vlan options
to be dumped. The dumps are done only with bridge devices, ports are
ignored. They support vlan compression if the options in sequential
vlans are equal (currently always true).

Signed-off-by: Nikolay Aleksandrov <nikolay@nvidia.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_private.h        |  4 ++++
 net/bridge/br_vlan.c           | 41 +++++++++++++++++++++++++++-------
 net/bridge/br_vlan_options.c   | 31 +++++++++++++++++++++++++
 4 files changed, 69 insertions(+), 8 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 760b264bd03d..2203eb749d31 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -479,6 +479,7 @@ enum {
 
 /* flags used in BRIDGE_VLANDB_DUMP_FLAGS attribute to affect dumps */
 #define BRIDGE_VLANDB_DUMPF_STATS	(1 << 0) /* Include stats in the dump */
+#define BRIDGE_VLANDB_DUMPF_GLOBAL	(1 << 1) /* Dump global vlan options only */
 
 /* Bridge vlan RTM attributes
  * [BRIDGE_VLANDB_ENTRY] = {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index bc920bc1ff44..e0a982275a93 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1609,6 +1609,10 @@ int br_vlan_rtm_process_global_options(struct net_device *dev,
 				       const struct nlattr *attr,
 				       int cmd,
 				       struct netlink_ext_ack *extack);
+bool br_vlan_global_opts_can_enter_range(const struct net_bridge_vlan *v_curr,
+					 const struct net_bridge_vlan *r_end);
+bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
+			      const struct net_bridge_vlan *v_opts);
 
 /* vlan state manipulation helpers using *_ONCE to annotate lock-free access */
 static inline u8 br_vlan_get_state(const struct net_bridge_vlan *v)
diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index dcb5acf783d2..e66b004df763 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -1919,6 +1919,7 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 			    u32 dump_flags)
 {
 	struct net_bridge_vlan *v, *range_start = NULL, *range_end = NULL;
+	bool dump_global = !!(dump_flags & BRIDGE_VLANDB_DUMPF_GLOBAL);
 	bool dump_stats = !!(dump_flags & BRIDGE_VLANDB_DUMPF_STATS);
 	struct net_bridge_vlan_group *vg;
 	int idx = 0, s_idx = cb->args[1];
@@ -1937,6 +1938,10 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 		vg = br_vlan_group_rcu(br);
 		p = NULL;
 	} else {
+		/* global options are dumped only for bridge devices */
+		if (dump_global)
+			return 0;
+
 		p = br_port_get_rcu(dev);
 		if (WARN_ON(!p))
 			return -EINVAL;
@@ -1959,7 +1964,7 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 
 	/* idx must stay at range's beginning until it is filled in */
 	list_for_each_entry_rcu(v, &vg->vlan_list, vlist) {
-		if (!br_vlan_should_use(v))
+		if (!dump_global && !br_vlan_should_use(v))
 			continue;
 		if (idx < s_idx) {
 			idx++;
@@ -1972,8 +1977,21 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 			continue;
 		}
 
-		if (dump_stats || v->vid == pvid ||
-		    !br_vlan_can_enter_range(v, range_end)) {
+		if (dump_global) {
+			if (br_vlan_global_opts_can_enter_range(v, range_end))
+				continue;
+			if (!br_vlan_global_opts_fill(skb, range_start->vid,
+						      range_end->vid,
+						      range_start)) {
+				err = -EMSGSIZE;
+				break;
+			}
+			/* advance number of filled vlans */
+			idx += range_end->vid - range_start->vid + 1;
+
+			range_start = v;
+		} else if (dump_stats || v->vid == pvid ||
+			   !br_vlan_can_enter_range(v, range_end)) {
 			u16 vlan_flags = br_vlan_flags(range_start, pvid);
 
 			if (!br_vlan_fill_vids(skb, range_start->vid,
@@ -1995,11 +2013,18 @@ static int br_vlan_dump_dev(const struct net_device *dev,
 	 * - last vlan (range_start == range_end, not in range)
 	 * - last vlan range (range_start != range_end, in range)
 	 */
-	if (!err && range_start &&
-	    !br_vlan_fill_vids(skb, range_start->vid, range_end->vid,
-			       range_start, br_vlan_flags(range_start, pvid),
-			       dump_stats))
-		err = -EMSGSIZE;
+	if (!err && range_start) {
+		if (dump_global &&
+		    !br_vlan_global_opts_fill(skb, range_start->vid,
+					      range_end->vid, range_start))
+			err = -EMSGSIZE;
+		else if (!dump_global &&
+			 !br_vlan_fill_vids(skb, range_start->vid,
+					    range_end->vid, range_start,
+					    br_vlan_flags(range_start, pvid),
+					    dump_stats))
+			err = -EMSGSIZE;
+	}
 
 	cb->args[1] = err ? idx : 0;
 
diff --git a/net/bridge/br_vlan_options.c b/net/bridge/br_vlan_options.c
index a7d5a2334207..f290f5140547 100644
--- a/net/bridge/br_vlan_options.c
+++ b/net/bridge/br_vlan_options.c
@@ -259,6 +259,37 @@ int br_vlan_process_options(const struct net_bridge *br,
 	return err;
 }
 
+bool br_vlan_global_opts_can_enter_range(const struct net_bridge_vlan *v_curr,
+					 const struct net_bridge_vlan *r_end)
+{
+	return v_curr->vid - r_end->vid == 1;
+}
+
+bool br_vlan_global_opts_fill(struct sk_buff *skb, u16 vid, u16 vid_range,
+			      const struct net_bridge_vlan *v_opts)
+{
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, BRIDGE_VLANDB_GLOBAL_OPTIONS);
+	if (!nest)
+		return false;
+
+	if (nla_put_u16(skb, BRIDGE_VLANDB_GOPTS_ID, vid))
+		goto out_err;
+
+	if (vid_range && vid < vid_range &&
+	    nla_put_u16(skb, BRIDGE_VLANDB_GOPTS_RANGE, vid_range))
+		goto out_err;
+
+	nla_nest_end(skb, nest);
+
+	return true;
+
+out_err:
+	nla_nest_cancel(skb, nest);
+	return false;
+}
+
 static int br_vlan_process_global_one_opts(const struct net_bridge *br,
 					   struct net_bridge_vlan_group *vg,
 					   struct net_bridge_vlan *v,
-- 
2.31.1

