Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB07331CD5
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 03:18:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbhCICRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 21:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbhCICRQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 21:17:16 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FE1C061760
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 18:17:16 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id hs11so24474630ejc.1
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 18:17:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hoOCzlwn3C76LoMSQCHa5HBJqmeEYAJ3cF9eabZPt1k=;
        b=hLIgQdsoC2jLeBDKWaSX742WWEbatlnuE3nkdTc2VEarR7ZFnQLbTwemr1Gl3MUjAl
         yAmkTgdJqWe6SoxKeGvoziBVtgmSnqLcZlYUu5Jsl+oMyiaU6ThMWW/kv6myLR9+VhcA
         GhbRktyY2Zwtaq7X1ztUNcFwC3m+Xf/axp9s+knNoHzlpp3+3fed+DvfEK/DsbwZGFxn
         qYwBHc8OLELoWiwgUuDLw+aKhQTk3+lOh+L2owfXFZWdPG7csLi3/ghfVQTFH++OZMJN
         LWUWqv/gV2fyXFUyql7RHoV5rgLZqhz4zKbyemcxD98e1PSIyYsogBmosNJcGzF7umxx
         lsIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hoOCzlwn3C76LoMSQCHa5HBJqmeEYAJ3cF9eabZPt1k=;
        b=TYPJsohU58S+sU1PdQLEcUZbmdGHkQF0GV8n/bEH20wU5oApwLK0VMR7euYQ5y0yQe
         9j2i373yBOReAY42iS9Fu/FLssUXZ8LYfF1GSBaJthwIZ7lNpK5B5b2SdOiUQQYmRbD+
         TMPysg1R/rbacu5LSNtS6BA7/TzGLAzS7GAdPMtJgKg97r1OG7uN6wnqRHA2dEVcOMFO
         CYPDkqm+OD9WZ2xjl/pZ2brhkMGwv8Ge0j+LKtxihn4Fn3s1B7y/vSpiZc4CmCOwKo6j
         aeoJwM+874KRGP4QfJTPqZvRqZxiPwetN7yOCHs7rVjxFEOE6UrXfWjs6WMirvwuvQJo
         qVZw==
X-Gm-Message-State: AOAM530ZcgpR6DFbpyWVuTfEIxJ6PQp6cobKY0QcrG3gwmTT2d6/4yP7
        RpoSkprDF7wAZphrBfF/K2E=
X-Google-Smtp-Source: ABdhPJxVEkI7SDw5mHckTUzZ2fgf8l+J2HoLfu01bfOSPdpcDdGuj9RWvtdR8CfurQlimhwNrYkaRQ==
X-Received: by 2002:a17:906:a0d3:: with SMTP id bh19mr18225031ejb.199.1615256235009;
        Mon, 08 Mar 2021 18:17:15 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id bj7sm4364902ejb.28.2021.03.08.18.17.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 18:17:14 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net 1/4] net: dsa: on 'bridge vlan add', check for 8021q uppers of all bridge ports
Date:   Tue,  9 Mar 2021 04:16:54 +0200
Message-Id: <20210309021657.3639745-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210309021657.3639745-1-olteanv@gmail.com>
References: <20210309021657.3639745-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The first (original) blamed patch intended to prevent the existence of
overlapping 8021q uppers of any bridge port when attempting to offload a
bridge VLAN. Unfortunately, it doesn't check the presence of the offending
8021q upper on all bridge ports, just on the one on which the 'bridge
vlan add' command was emitted (and on the other ports in the crosschip
bitmap, i.e. CPU port and DSA links, all irrelevant).

For example, the following setup:

$ ip link add dev br0 type bridge vlan_filtering 1
$ ip link add dev lan0.100 link lan0 type vlan id 100
$ ip link set dev lan0 master br0
$ ip link set dev lan1 master br0
$ bridge vlan add dev lan1 vid 100

should return an error at the last command, because if it doesn't, the
hardware will be configured in an invalid state where forwarding will
take place between traffic belonging to lan0.100 and lan1.

The trouble is that in hardware, all VLANs kinda smell the same, so if
we offload an 8021q upper on top of a bridged port, this will be in no
way different than adding that VLAN with 'bridge vlan add', however from
the perspective of Linux network stack semantics it is - traffic sent to
8021q uppers is 'stolen' from the bridge rx_handler in the software data
path, and does not take part in bridging unless the 8021q upper is
explicitly bridged, therefore we should observe those semantics.

This changes dsa_slave_vlan_check_for_8021q_uppers into a more reusable
dsa_check_bridge_for_overlapping_8021q_uppers, and also drops the bogus
requirement for holding RCU read-side protection: we are already
serialized with potential writers to the netdev adjacency lists because
we are executing under the rtnl_mutex.

The second blamed patch is where this commit actually applies to.

Fixes: 061f6a505ac3 ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation")
Fixes: 1ce39f0ee8da ("net: dsa: convert denying bridge VLAN with existing 8021q upper to PRECHANGEUPPER")
Reported-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/slave.c | 35 +++++++++++++++++++----------------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 63ee2cae4d8e..d36e11399626 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -323,23 +323,27 @@ static int dsa_slave_port_attr_set(struct net_device *dev,
 	return ret;
 }
 
-/* Must be called under rcu_read_lock() */
 static int
-dsa_slave_vlan_check_for_8021q_uppers(struct net_device *slave,
-				      const struct switchdev_obj_port_vlan *vlan)
+dsa_check_bridge_for_overlapping_8021q_uppers(struct net_device *bridge_dev,
+					      u16 vid)
 {
-	struct net_device *upper_dev;
-	struct list_head *iter;
-
-	netdev_for_each_upper_dev_rcu(slave, upper_dev, iter) {
-		u16 vid;
+	struct list_head *iter_upper, *iter_lower;
+	struct net_device *upper, *lower;
 
-		if (!is_vlan_dev(upper_dev))
+	netdev_for_each_lower_dev(bridge_dev, lower, iter_lower) {
+		if (!dsa_slave_dev_check(lower))
 			continue;
 
-		vid = vlan_dev_vlan_id(upper_dev);
-		if (vid == vlan->vid)
-			return -EBUSY;
+		netdev_for_each_upper_dev_rcu(lower, upper, iter_upper) {
+			u16 upper_vid;
+
+			if (!is_vlan_dev(upper))
+				continue;
+
+			upper_vid = vlan_dev_vlan_id(upper);
+			if (upper_vid == vid)
+				return -EBUSY;
+		}
 	}
 
 	return 0;
@@ -368,12 +372,11 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 	 * the same VID.
 	 */
 	if (br_vlan_enabled(dp->bridge_dev)) {
-		rcu_read_lock();
-		err = dsa_slave_vlan_check_for_8021q_uppers(dev, &vlan);
-		rcu_read_unlock();
+		err = dsa_check_bridge_for_overlapping_8021q_uppers(dp->bridge_dev,
+								    vlan.vid);
 		if (err) {
 			NL_SET_ERR_MSG_MOD(extack,
-					   "Port already has a VLAN upper with this VID");
+					   "Bridge already has a port with a VLAN upper with this VID");
 			return err;
 		}
 	}
-- 
2.25.1

