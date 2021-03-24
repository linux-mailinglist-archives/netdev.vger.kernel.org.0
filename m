Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB2034752E
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 10:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbhCXJ5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 05:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235231AbhCXJ4s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 05:56:48 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239F6C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 02:56:48 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id u21so13834615ejo.13
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 02:56:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HQ0txtKxCRUFMhe+z1pGgT2Hz/9Mq0LdHPkRnAZ1zPo=;
        b=BdUdHBXfn7pcJXd/UqwoScScfXKN05tCWGr60ujWNuTSfEzN4pbg8r3cRcqP14XwQO
         ZHMkmYBFGl8i2x8VTlThhx/1alPaoV0x7MM5jrxtPP/L+PsVS26+4gA1rF5YmPBlwqsi
         MPBNNY2Q10OOI81Vu9Rzk1XgMEwAHrn/CN/pODh3MI+KBCzB1vuH+AMhQ/gGXMRiEddf
         kZddnUO0x1ppuW2u8IXuR/nawTVaclFCS6XTU0lf8/CCHfhCXrQpnIXa8N04lbhLDho6
         cH/bAVtGPvDY6AGoZu9f3Dk0PvTElEAmAU4OxIzBKD0ijO3qOtscKlitBQpmKOx21IQ4
         z8ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HQ0txtKxCRUFMhe+z1pGgT2Hz/9Mq0LdHPkRnAZ1zPo=;
        b=hrheTUCbMKB3m8o9DJuiHwOV06CnTaEcWfDBbIkbgxEpPpP/ZSMZvqwX7Nva930p8F
         dxvBL6JLzxmeSHZXvVfpTkoh2Zv8CmmhdNKx2rBuSjUEjhhXdMobKgpQCb+IPZybZznG
         YeMB7dZxj8TSsXgyOr4yEM5xiFtvdxrO9XucH9tSCMOWl49DL1XIIztaWA7Te1Cat5L1
         STTr1l/fcM+oYRRmIsN3D0YK5XIavXZBGforIBPItiVpkuNshzgt+B/8EAuMi6hkqqW8
         AaBgJH0VXXBz9sVD+LuZP2OfcVEdMuz9sCqa3gU3bqOLkK4iyTby4qn1MRcFaIEJG7VO
         HE1Q==
X-Gm-Message-State: AOAM530Y+Llg/eV4o5CrcWL+omnR4ERAalDwTQmG+kiGXFlmr5VCtQKD
        LYWod8GEXKjoWygigECtFHs=
X-Google-Smtp-Source: ABdhPJxHTol/eaeY3rBxMKJlbwU7ZyfSIlYcqU81rCvdbkFBYLRbGk89Psc8LHtrpsq8+hzrcaNi9Q==
X-Received: by 2002:a17:906:819:: with SMTP id e25mr2783152ejd.292.1616579806814;
        Wed, 24 Mar 2021 02:56:46 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id oy8sm665925ejb.58.2021.03.24.02.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 02:56:46 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net] net: dsa: only unset VLAN filtering when last port leaves last VLAN-aware bridge
Date:   Wed, 24 Mar 2021 11:56:39 +0200
Message-Id: <20210324095639.1354700-1-olteanv@gmail.com>
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
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
Changes in v3:
Split from the larger series:
https://patchwork.kernel.org/project/netdevbpf/patch/20210320225928.2481575-2-olteanv@gmail.com/

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

