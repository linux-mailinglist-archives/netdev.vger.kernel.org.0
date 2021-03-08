Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01681331026
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 14:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230439AbhCHN44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 08:56:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230410AbhCHN4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 08:56:09 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78165C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 05:55:22 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id b7so14856082edz.8
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 05:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ThKHhGN4mCbqI2uGAwKypLVEaWnrJaYUetB99qFwUDE=;
        b=py/MFCOVTKRcTA8p+hOlCVrt0N5s35uYbiVF2+XuK1H9dNIrUuuxmcCUVjqg/33Wr3
         0hmKarV+UxY+TFD7c+zd0So0woDbJljmFgz3iGWy09j4wqNBzLgLYtJvWMX6c8GgJ0dA
         g4C0S6g+evSa31dtCztM+4SD0Eq+gMKwR2nrAy66IXyPbyVeyKebJkVje3w2LgVfZam4
         yU3XtqfO1py5WiWP9dv4Y02wsSiR86yytUcjjtvD5p6HkGAH4ghYVzveDFzSttz8l1gE
         jH7BTsYAQsNXBOczNDaEKFjEg3zPYtNkDT5o3kHvVoLY+J7aZc+WYooGpvOghYSdO36f
         9xdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ThKHhGN4mCbqI2uGAwKypLVEaWnrJaYUetB99qFwUDE=;
        b=ZHokEpxH04juB+A9j5vnPSu/Ou3jj2F7bkUqZCohSrVAB826aWp5Ox+LhqnNorlR5d
         VMvHQr4yCJbXGhHrt+Ms3V9Ywo6l26ExMgEMK+dQmIS3xGaOGWwrp7Kn9hwb54uJ6/qB
         wveeMOf9MsFYDVLf7wGjJZZTaw9lmDrsvehLsjuNvdnoYpK6rqNvqIt86JqCvhZYhpHh
         +F/jYgArYBPkp/D/HY6Ej/PUoJVFZam62NQxQbKiNZniGoaE+Er+V7FKWPW/XM7yVbu2
         Kl4TipJjGglw4+nGqv3Pl5qLRExEO6j+eOPTFbgzQTY8tcG76N86772vUwjfLjPkRnLJ
         iujA==
X-Gm-Message-State: AOAM533jGUmqjwWXxuwREjKE8ttTsEb6Oi/12pzQmcrGpPAjGtIhHPEj
        4f/N4kUHGdD8tdINlWhFNUY=
X-Google-Smtp-Source: ABdhPJx9zfGahY/dT2XiSUPHU6CG/tttgpHg6QRPIP0I7BBDYyASqUtT/PdV+Urk4G6PWPK8ePRBVA==
X-Received: by 2002:aa7:c551:: with SMTP id s17mr22273749edr.291.1615211721101;
        Mon, 08 Mar 2021 05:55:21 -0800 (PST)
Received: from localhost.localdomain ([188.25.219.167])
        by smtp.gmail.com with ESMTPSA id u17sm7300161edr.0.2021.03.08.05.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 05:55:20 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net] net: dsa: only unset VLAN filtering when last port leaves last VLAN-aware bridge
Date:   Mon,  8 Mar 2021 15:55:09 +0200
Message-Id: <20210308135509.3040286-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
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
---
 net/dsa/switch.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 4b5da89dc27a..56ed31b0e636 100644
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
+	 * vlan_filtering callback is only when the last port the last
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

