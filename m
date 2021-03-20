Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6B934303D
	for <lists+netdev@lfdr.de>; Sun, 21 Mar 2021 00:01:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCTXAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 19:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229780AbhCTW7r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 18:59:47 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23052C061574
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 15:59:47 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id t18so15309354ejc.13
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 15:59:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Rrb/52u6dTK6D+MxywdIm90NR83YinSo1k+0BXicEw=;
        b=o6oC3w7a4CZTJSAon753ed52+XTjgFDlOMXLKjGZQbxRYRXKJF3v6wa/pXbaHg/pes
         BbRIxgPEG/rG8VgYJWzYl3FBM2IEq17nRO6Tk2NLkMdXGfRNwcQ5q/ql5qhBNzU13ZnS
         yYyP8iKRVnlmgWX6TF0oWKdBgnMfTAqnutoQpk7asQ8E/077NoAytgu5Bg/uBJUeRXL3
         eVKvO1e9jgHK60rhTk/oR0Gr/jk216AefxblfN+VFYLZH5QpB3F0xqF/XKW6Wou8/WR2
         u5lXAPSQ3a08aeVV90WGJAHjys6qp19+GhUo5nGpP9wMF95YUS35ZihySZBrKCbiLy2T
         reaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Rrb/52u6dTK6D+MxywdIm90NR83YinSo1k+0BXicEw=;
        b=Q14IBLZTPNghcVB9drK1QXSDr4jmzFfOEGRyXGINawfzlzE27H/KlgzvIIh/5ziZTJ
         PnLtgh/I+3rGxIztrKC2eSghV/6ht+02bLPU7N2ZyyXn434jRfflGms8cZZZjzJmFaCr
         BvjI+ts7aWjn/kEsRCVM/c2PrK7GTtbD17SLmaBxxri3dfeTUSeMD/l7tW58z04ncGF8
         n8WR6OgII5O+3kFn4JHwcLhU2t8P/D7kd/vn41ejUSpHBga3P+0bJcaK3bHDUHoyf+3Y
         +Fk7r9VwxwkGgpytCXoa1TD09DMNK8CS8VD9HAFxL4hWAJ5FGcXFAQvbbyzEng0oZAu/
         QU4A==
X-Gm-Message-State: AOAM5301+uCWgyTt6JyEbdZkqNKfQHI6DZMw/ekbKXCq1GEYQLNDNqjn
        XtMxyB+2tHKAd4BI0/r1BFUHXSDYbHY=
X-Google-Smtp-Source: ABdhPJxc/t34ihi3f1kwSrwmWpm0RwPOSS83t+HJ/9d3/ao+3zLbmnOeq9uk6Q1a92C/cYYXKxsF2A==
X-Received: by 2002:a17:906:3b48:: with SMTP id h8mr11574356ejf.261.1616281185840;
        Sat, 20 Mar 2021 15:59:45 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id a3sm6101517ejv.40.2021.03.20.15.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Mar 2021 15:59:45 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net 1/3] net: dsa: only unset VLAN filtering when last port leaves last VLAN-aware bridge
Date:   Sun, 21 Mar 2021 00:59:26 +0200
Message-Id: <20210320225928.2481575-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210320225928.2481575-1-olteanv@gmail.com>
References: <20210320225928.2481575-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

DSA is aware of switches with global VLAN filtering since the blamed
commit, but it makes a bad decision when multiple bridges are spanning
the same switch:

ip link add br0 type bridge vlan_filtering 1
ip link add br1 type bridge vlan_filtering 1
ip link set swp2 master br0
ip link set swp3 master br0
ip link set swp4 master br1
ip link set swp5 master br1
ip link set swp5 nomaster
ip link set swp4 nomaster
[138665.939930] sja1105 spi0.1: port 3: dsa_core: VLAN filtering is a global setting
[138665.947514] DSA: failed to notify DSA_NOTIFIER_BRIDGE_LEAVE

When all ports leave br1, DSA blindly attempts to disable VLAN filtering
on the switch, ignoring the fact that br0 still exists and is VLAN-aware
too. It fails while doing that.

This patch checks whether any port exists at all and is under a
VLAN-aware bridge.

Fixes: d371b7c92d19 ("net: dsa: Unset vlan_filtering when ports leave the bridge")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 net/dsa/switch.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 4b5da89dc27a..32963276452f 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -107,7 +107,7 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 	bool unset_vlan_filtering = br_vlan_enabled(info->br);
 	struct dsa_switch_tree *dst = ds->dst;
 	struct netlink_ext_ack extack = {0};
-	int err, i;
+	int err, port;
 
 	if (dst->index == info->tree_index && ds->index == info->sw_index &&
 	    ds->ops->port_bridge_join)
@@ -124,13 +124,16 @@ static int dsa_switch_bridge_leave(struct dsa_switch *ds,
 	 * it. That is a good thing, because that lets us handle it and also
 	 * handle the case where the switch's vlan_filtering setting is global
 	 * (not per port). When that happens, the correct moment to trigger the
-	 * vlan_filtering callback is only when the last port left this bridge.
+	 * vlan_filtering callback is only when the last port leaves the last
+	 * VLAN-aware bridge.
 	 */
 	if (unset_vlan_filtering && ds->vlan_filtering_is_global) {
-		for (i = 0; i < ds->num_ports; i++) {
-			if (i == info->port)
-				continue;
-			if (dsa_to_port(ds, i)->bridge_dev == info->br) {
+		for (port = 0; port < ds->num_ports; port++) {
+			struct net_device *bridge_dev;
+
+			bridge_dev = dsa_to_port(ds, port)->bridge_dev;
+
+			if (bridge_dev && br_vlan_enabled(bridge_dev)) {
 				unset_vlan_filtering = false;
 				break;
 			}
-- 
2.25.1

