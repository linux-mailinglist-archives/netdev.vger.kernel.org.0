Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80B9D3575B3
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 22:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356024AbhDGUPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 16:15:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356006AbhDGUPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 16:15:18 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35815C061761
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 13:15:07 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id mh7so19781298ejb.12
        for <netdev@vger.kernel.org>; Wed, 07 Apr 2021 13:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZhwUHHf1fLLHLoihm5lm4dJpElq6zSNHVRafr10KZ/w=;
        b=K0FsyKlhov+Wqbbcn52/d0o2QmTEgpPX+D1ypb+kt8ICVdKNqnPjMyAIzvTJ/YGlbK
         KpVbJ/iks/jm/E9IBSQHXC8R8D79cP5uIQr4ZwdgUdN66EuXguyHgBbnG/xAgQ6hC6BA
         VCfWaV5NS6lCkMIJ9stL5FiY0YUvV5TFA2elomGYbocZ7uzpHoAoXdRqPsGjgbBSBQqc
         E9K8/jvkBELii/HNYGmqHKXZKkWMwDavooqj2ufoUW/0ibJifJ2ROTCTysfLck+9z1td
         AJoyIvwQvoSjrxTzqMglQRXhqyXs5utDF7+wSWq/HcVLIwQpu7PSbmznttNpRMicT9KF
         vHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZhwUHHf1fLLHLoihm5lm4dJpElq6zSNHVRafr10KZ/w=;
        b=nmjs5mvWT1mCJ8KCd3TeBATLV/R9/w4u0B0p8yzLVHlzVtTQcYvTdSG6CwrEKaHWxV
         fiOqQmdawBJUExl8NfCQAofOIIHs+Nd5BJiuN/O8VIzat23oB4B729lgSoK96PciHX57
         V/6onIMxMlBfLx/NMpX/NvpilnImpttw+T28yBol5QfSKP6xswN0u+UTb1d9YsUw4eba
         64BlduEtBgwMWfdnatwkTER+0zJBrFdxB10YmdNABbe8/i3i14xDO6tLt8aPKYYqMyHg
         x1OYdjbmjDQZNMW00zhFqhshevP1N0pWwHPEvR18f0MyRqVQTsisc4mv7NVLNq+vd475
         96CA==
X-Gm-Message-State: AOAM530UlQftjLobH/cv7F8L5ZVc9bIrMYjtd+vj3w5T0ylOggXFJ7jO
        LqyeYFJZe4yYTGPf1FkFRok=
X-Google-Smtp-Source: ABdhPJyOSBCLGkwlP762MmKAOZqyqrOd0vDYBAbZ4MhpdXCHxzkiE47YsdAZezGGh0Afe86wZFct5g==
X-Received: by 2002:a17:906:1115:: with SMTP id h21mr6104056eja.352.1617826505867;
        Wed, 07 Apr 2021 13:15:05 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id r26sm4982892edc.43.2021.04.07.13.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 13:15:05 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net 1/3] net: dsa: sja1105: use the bridge pvid in best_effort_vlan_filtering mode
Date:   Wed,  7 Apr 2021 23:14:50 +0300
Message-Id: <20210407201452.1703261-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210407201452.1703261-1-olteanv@gmail.com>
References: <20210407201452.1703261-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The best-effort VLAN filtering mode is the sja1105 driver's attempt to
allow frame tagging towards the CPU with a unique VLAN ID corresponding
to the source port at the same time as allowing the bridge to freely
alter the VLAN table. It works by making the switch classify all untagged
ingress traffic to a secret pvid managed by net/dsa/tag_8021q.c.
Also, VLAN-tagged frames are retagged to another secret VLAN managed by
tag_8021q. Both these VLANs managed by tag_8021q are called "rx_vid".
The retagged rx_vid has some bits which encode a "sub-VLAN", and the
pvid-based rx_vid has those sub-VLAN bits set to zero. Software looks at
the rx_vid and knows what port and original VLAN the packet came from.

There is a huge oversight in the setup created by the sja1105 driver for
the best-effort VLAN filtering mode. That is:

ip link add br0 type bridge vlan_filtering 1
ip link set swp2 master br0
ip link set swp4 master br0
bridge vlan del dev swp4 vid 1
bridge vlan add dev swp4 vid 1 pvid

Then we send an untagged packet from swp2 and expect the switch to
forward it to swp4 and deliver it with VLAN 1 added. It is forwarded,
except the packet is egress-untagged.

This happens because of the way in which tag_8021q works (there is a
detailed picture in net/dsa/tag_8021q.c, above dsa_8021q_setup_port).
In the example above, the tag_8021q pvid of swp2 is 1026. This VLAN is
added to all other switch ports, to allow untagged traffic forwarding.
On all ports, the tag_8021q pvid of 1026 is installed as egress-untagged,
in order to hide the existence of DSA tag_8021q from the user.

This is fine, except when the real (bridge) pvid is egress-tagged, it
isn't. The user _wants_ to see this VLAN in the outside world, and we
can't really do that, because the sja1105 driver doesn't use that VLAN
but another one which the user knows nothing about.

As a side note, this only happens for untagged traffic on the ingress
port. If the packet arrives as pvid-tagged (i.e. tagged with VID 1)
on a port with tag_8021q, then the packet is classified to VLAN ID 1
(the bridge pvid) as opposed to the tag_8021q pvid. So we don't have
the same problem.

Consider the following more generic example:

Port             | sw0p0 sw0p1 sw0p2 sw0p3  |  sw1p0 sw1p1 sw1p2 sw1p3
=================+==========================+==========================
tag_8021q rx_vid | 1024  1025  1026  1027   |  1088  1089  1090  1091
tag_8021q flags  | pvid  pvid  pvid  pvid   |  pvid  pvid  pvid  pvid
                 | untag untag untag untag  |  untag untag untag untag
Bridge VLAN      |  1     1     2     1     |    3     2     2     1
Bridge flags     | pvid        pvid         |   pvid  pvid
                 | untag untag              |

What is not shown in the above table, because it would make it too
bloated, is that:
- VLAN 1024 is added to sw0p1, sw0p2, sw0p3, sw1p0, sw1p1, sw1p2, sw1p3
  as egress-untagged but not pvid.
- VLAN 1025 is added to sw0p0, sw0p2, sw0p3, sw1p0, sw1p1, sw1p2, sw1p3
  as egress-untagged but not pvid
- etc

The following pattern emerges:
A VLAN which is pvid on any port in the bridging domain (therefore has a
tag_8021q rx_vid) and is egress-tagged on another (potentially the same)
port will leak the tag_8021q VLAN. Every egress-tagged bridge VLAN that
is a pvid on another port must have a retagging rule from the tag_8021q
rx_vid to the bridge VLAN. In the above example, there needs to be a
retagging rule on the egress of sw0p1 for traffic with the tag_8021q
rx_vid 1024 (coming from sw0p0) towards VID 1. For sw0p3, we need to
retag VLAN 1024. For sw0p2, we need to retag VID 1090, etc etc.

So the data would indicate that, at the very least, we should retag the
tag_8021q pvid back towards the original bridge pvid on the egress ports
where this bridge VLAN is installed as egress-tagged. We could do that,
except:
- We only have 32 VLAN retagging entries in the sja1105, and we do use
  them for other purposes too.
- VLAN retagging works in hardware by making use of a special "loopback
  port" which is limited to only 1Gbps of bandwidth. When using the
  loopback port for traffic retagged towards the CPU that's fine because
  the CPU port is gigabit anyway, but when we start involving it in the
  autonomous forwarding data path we have a problem, because we'd
  bottleneck it.

So we take a step back and think a bit more about the problem.

Due to the need to plug another hole - pvid-tagged traffic is not seen
with a tag_8021q rx_vid by software, but with the bridge pvid, say 1 -
sja1105_build_subvlans() already creates VLAN retagging entries towards
the CPU even for the bridge pvid, not just for tagged VLANs.
That is to say, even if we let the bridge pvid be the hardware's pvid in
best-effort VLAN filtering mode, untagged and pvid-tagged packets will
still arrive at the CPU as tagged with the tag_8021q rx_vid, because
they will both hit the same retagging rule.

But that actually means we don't _need_ the tag_8021q module to dictate
a pvid value for us. We can rely on retagging just fine, and let the
bridge dictate the pvid. This solves the problem in a much cleaner way:
because the packets in the autonomous data path are now classified to
the bridge pvid, the egress-tagged setting on the egress port works just
fine.

[ note that this means we can always rely on VLAN retagging towards the
  CPU, and never on changing the port's pvid. And because the pvid is no
  longer managed by tag_8021q, we can even go as far as enable
  Independent VLAN Learning again. But I digress, that is an
  optimization to make for net-next, this is just to fix a bug ]

The commit I'm blaming is the one which introduced the problem, but the
fix relies on a mechanism that was only added a few commits later:
3f01c91aab92 ("net: dsa: sja1105: implement VLAN retagging for dsa_8021q
sub-VLANs"). This is fine, since they all went into the same kernel
release (v5.8).

Fixes: 2cafa72e516f ("net: dsa: sja1105: add a new best_effort_vlan_filtering devlink parameter")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/sja1105/sja1105_main.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index d9c198ca0197..8b380ccd95cf 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -2240,10 +2240,10 @@ static int sja1105_commit_pvid(struct sja1105_private *priv)
 	struct list_head *vlan_list;
 	int rc = 0;
 
-	if (priv->vlan_state == SJA1105_VLAN_FILTERING_FULL)
-		vlan_list = &priv->bridge_vlans;
-	else
+	if (priv->vlan_state == SJA1105_VLAN_UNAWARE)
 		vlan_list = &priv->dsa_8021q_vlans;
+	else
+		vlan_list = &priv->bridge_vlans;
 
 	list_for_each_entry(v, vlan_list, list) {
 		if (v->pvid) {
@@ -2290,6 +2290,21 @@ sja1105_build_dsa_8021q_vlans(struct sja1105_private *priv,
 	list_for_each_entry(v, &priv->dsa_8021q_vlans, list) {
 		int match = v->vid;
 
+		/* In best-effort VLAN filtering mode, the pvid of the port is
+		 * no longer the tag_8021q rx_vid, but the bridge pvid is.
+		 * The tag_8021q rx_vid is just used for retagging the bridge
+		 * pvid towards the CPU. So let's install only the rx_vid
+		 * values which are strictly required. This means that the
+		 * rxvlan is still installed on the port on which tag_8021q
+		 * thinks it must be pvid (the source port) - this is required
+		 * by the retagging table - but not on the ports where this
+		 * VLAN isn't a pvid (the destination ports).
+		 */
+		if (priv->vlan_state == SJA1105_VLAN_BEST_EFFORT &&
+		    vid_is_dsa_8021q_rxvlan(v->vid) &&
+		    dsa_8021q_rx_subvlan(v->vid) == 0 && !v->pvid)
+			continue;
+
 		new_vlan[match].vlanid = v->vid;
 		new_vlan[match].vmemb_port |= BIT(v->port);
 		new_vlan[match].vlan_bc |= BIT(v->port);
-- 
2.25.1

