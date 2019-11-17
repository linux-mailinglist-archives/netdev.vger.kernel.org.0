Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2F00FFBB4
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 22:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfKQVOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 16:14:25 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55807 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbfKQVOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 16:14:25 -0500
Received: by mail-wm1-f65.google.com with SMTP id b11so15287539wmb.5
        for <netdev@vger.kernel.org>; Sun, 17 Nov 2019 13:14:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5GWJuQeKP6cxhR7uF3wiE4siN92UBjIVD9VTSiRg16M=;
        b=fIf8MIPGmLz6Pz2Vdc+4lbkpxPgMXIH+JsyqKOJAOfbxeNa3cU9yvcTgBJi76LHqPF
         cVALNm97TlcvDDUxYChuVpGccqD15Hxh/3mWQK+YvX0PbaI7alTvtuoSsc/Hmlb0Pox6
         CAYLUm02tGCZsF/teYwAO0HErnvT1QG0IJAoVWuvp9u+AlEM7ZX2uVfcc7T5aOC33/vJ
         QM7yRxLUsiJjOOZ7b1qkAnAXGkM6TRLg0nZX0PK77fdMLmMX/PGAwMCy1VNbf7mPZe8v
         x8uT11aQT+UaKYid9TWoFFDRCzZLscFplwkp+X7WNM7hsyVLcX5JTuF0yqX15gjqdeQ2
         fgBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5GWJuQeKP6cxhR7uF3wiE4siN92UBjIVD9VTSiRg16M=;
        b=qWajNDDFJZRVTMYH2UQoGOE56omB3TpEBcJuPvgug0En2wwB7TfFzo6hVYy+NB9ckl
         e1+X9oNCy3POj1qpgqNC5yBm6Vhmo5nDbTdpb3VSEh6/rkkURL2mQY1cCKztw8+ys+nx
         C9rDRdG9JnwmhcJj0rj9CYds/n2r0u3xf7vvra5eeMVzsdz5CNvwQ9nqBesSexVuPaki
         MQJdcMeCJPKowzwUcJ5RcTdvvoQNW9pWs1v2qOxkbSjAhA6FuFnyl/RF8VUl3WgqBqHT
         69HMDqFxRyvioXVGfYPOu1eyFyJBkosPkmIWTguIE2OPIg4EYkOENWiZy0k53VES054L
         y+Sg==
X-Gm-Message-State: APjAAAVK0jDb5taH3hmpcO4jZKr9Q10OMmlvVZ3Jb40nKLJjTu86Vmqf
        Y5Vin7eBW8Fk218HZEDKN8o=
X-Google-Smtp-Source: APXvYqweFfmzZf+XyGnmnqYbG5TO4DWqngQii7K81tLDfrvvwpE6sn8EDSVJhqIiaFkDWgt/y8lr3A==
X-Received: by 2002:a7b:c3d6:: with SMTP id t22mr26607352wmj.13.1574025260528;
        Sun, 17 Nov 2019 13:14:20 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id m3sm20020725wrw.20.2019.11.17.13.14.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Nov 2019 13:14:19 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [RFC PATCH net-next] net: dsa: tag_8021q: Allow DSA tags and VLAN filtering simultaneously
Date:   Sun, 17 Nov 2019 23:14:07 +0200
Message-Id: <20191117211407.9473-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are very good reasons to want this (see documentation reference to
br_if.c), and there are also very good reasons for not enabling it by
default. So a devlink param named best_effort_vlan_filtering, currently
driver-specific and exported only by sja1105, is used to configure this.

In practice, this is perhaps the way that most users are going to use
the switch in. Best-effort untagged traffic can be bridged with any net
device in the system or terminated locally, and VLAN-tagged streams are
forwarded autonomously in a time-sensitive manner according to their
PCP (they need not transit the CPU). For those cases where the CPU needs
to terminate some VLAN-tagged traffic, using the DSA master is still an
option.

A complication while implementing this was the fact that
__netif_receive_skb_core calls __vlan_hwaccel_clear_tag right before
passing the skb to the DSA packet_type handler. This means that the
tagger does not see the VLAN tag in the skb, nor in the skb meta data.
The patch that starting zeroing the skb VLAN tag is:

  commit d4b812dea4a236f729526facf97df1a9d18e191c
  Author: Eric Dumazet <edumazet@google.com>
  Date:   Thu Jul 18 07:19:26 2013 -0700

      vlan: mask vlan prio bits

      In commit 48cc32d38a52d0b68f91a171a8d00531edc6a46e
      ("vlan: don't deliver frames for unknown vlans to protocols")
      Florian made sure we set pkt_type to PACKET_OTHERHOST
      if the vlan id is set and we could find a vlan device for this
      particular id.

      But we also have a problem if prio bits are set.

      Steinar reported an issue on a router receiving IPv6 frames with a
      vlan tag of 4000 (id 0, prio 2), and tunneled into a sit device,
      because skb->vlan_tci is set.

      Forwarded frame is completely corrupted : We can see (8100:4000)
      being inserted in the middle of IPv6 source address :

      16:48:00.780413 IP6 2001:16d8:8100:4000:ee1c:0:9d9:bc87 >
      9f94:4d95:2001:67c:29f4::: ICMP6, unknown icmp6 type (0), length 64
             0x0000:  0000 0029 8000 c7c3 7103 0001 a0ae e651
             0x0010:  0000 0000 ccce 0b00 0000 0000 1011 1213
             0x0020:  1415 1617 1819 1a1b 1c1d 1e1f 2021 2223
             0x0030:  2425 2627 2829 2a2b 2c2d 2e2f 3031 3233

      It seems we are not really ready to properly cope with this right now.

      We can probably do better in future kernels :
      vlan_get_ingress_priority() should be a netdev property instead of
      a per vlan_dev one.

      For stable kernels, lets clear vlan_tci to fix the bugs.

      Reported-by: Steinar H. Gunderson <sesse@google.com>
      Signed-off-by: Eric Dumazet <edumazet@google.com>
      Signed-off-by: David S. Miller <davem@davemloft.net>

The patch doesn't say why "we are not really ready to properly cope with
this right now", and hence why the best solution is to remove the VLAN
tag from skb's that don't have a local VLAN sub-interface interested in
them. And I have no idea either.

But the above patch has a loophole: if the VLAN tag is not
hw-accelerated, it isn't removed from the skb if there is no VLAN
sub-interface interested in it (our case). So we are hooking into the
.ndo_fix_features callback of the DSA master and clearing the rxvlan
offload feature, so the DSA tagger will always see the VLAN as part of
the skb data. This is symmetrical with the ETH_P_DSA_8021Q case and does
not need special treatment in the tagger. But perhaps the workaround is
brittle and might break if not understood well enough.

The disabling of the rxvlan feature of the DSA master is unconditional.
The reasoning is that at first sight, no DSA master with regular frame
parsing abilities could be able to locate the VLAN tag with any of the
existing taggers anyway, and therefore, adding a property in dsa_switch
to control the rxvlan feature of the master would seem like useless
boilerplate.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 .../networking/devlink-params-sja1105.txt     | 24 ++++++
 Documentation/networking/dsa/sja1105.rst      | 74 ++++++++++++++---
 drivers/net/dsa/sja1105/sja1105.h             |  1 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 81 +++++++++++++++++--
 include/linux/dsa/8021q.h                     |  7 ++
 include/linux/dsa/sja1105.h                   |  2 +
 net/dsa/master.c                              |  7 ++
 net/dsa/tag_8021q.c                           | 62 ++++++++++++++
 net/dsa/tag_sja1105.c                         | 16 ++--
 9 files changed, 250 insertions(+), 24 deletions(-)

diff --git a/Documentation/networking/devlink-params-sja1105.txt b/Documentation/networking/devlink-params-sja1105.txt
index 5096a4cf923c..f0ee76bbb68d 100644
--- a/Documentation/networking/devlink-params-sja1105.txt
+++ b/Documentation/networking/devlink-params-sja1105.txt
@@ -7,3 +7,27 @@ hostprio		[DEVICE, DRIVER-SPECIFIC]
 			your PTP frames.
 			Configuration mode: runtime
 			Type: u8. 0-7 valid.
+
+best_effort_vlan_filtering
+			[DEVICE, DRIVER-SPECIFIC]
+			Allow plain ETH_P_8021Q headers to be used as DSA tags.
+			Benefits:
+			- Can terminate untagged traffic over switch net
+			  devices even when enslaved to a bridge with
+			  vlan_filtering=1.
+			- Can do QoS based on VLAN PCP for autonomously
+			  forwarded frames.
+			Drawbacks:
+			- User cannot change pvid via 'bridge' commands. This
+			  would break source port identification on RX for
+			  untagged traffic.
+			- User cannot use VLANs in range 1024-3071. If the
+			  switch receives frames with such VIDs, it will
+			  misinterpret them as DSA tags.
+			- Cannot terminate VLAN-tagged traffic on local device.
+			  There is no way to deduce the source port from these.
+			  One could still use the DSA master though.
+			- Switch uses Shared VLAN Learning (FDB lookup uses
+			  only DMAC as key).
+			Configuration mode: runtime
+			Type: bool.
diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
index 21a288aa7692..5e4bd277ee70 100644
--- a/Documentation/networking/dsa/sja1105.rst
+++ b/Documentation/networking/dsa/sja1105.rst
@@ -77,6 +77,41 @@ change.
 The TPID is restored when ``vlan_filtering`` is requested by the user through
 the bridge layer, and general IP termination becomes no longer possible through
 the switch netdevices in this mode.
+There exists a third configuration option, via ``best_effort_vlan_filtering``.
+This permits termination of some traffic on switch net devices (untagged
+frames), at the expense of losing some VLAN filtering abilities: reduced range
+of usable VIDs, cannot change pvid.
+This operating mode is slightly insane to be collated with the default
+``vlan_filtering``, so it is an opt-in that needs to be enabled using a devlink
+parameter. To enable it::
+
+  ip link set dev br0 type bridge vlan_filtering 1
+  [   61.204770] sja1105 spi0.1: Reset switch and programmed static config. Reason: VLAN filtering
+  [   61.239944] sja1105 spi0.1: Disabled switch tagging
+  devlink dev param set spi/spi0.1 name best_effort_vlan_filtering value true cmode runtime
+  [   64.682927] sja1105 spi0.1: Reset switch and programmed static config. Reason: VLAN filtering
+  [   64.711925] sja1105 spi0.1: Enabled switch tagging
+  bridge vlan add dev swp2 vid 1025 untagged pvid
+  RTNETLINK answers: Operation not permitted
+  bridge vlan add dev swp2 vid 100
+  bridge vlan add dev swp2 vid 101 untagged
+  bridge vlan
+  port    vlan ids
+  swp5     1 PVID Egress Untagged
+
+  swp2     1 PVID Egress Untagged
+           100
+           101 Egress Untagged
+
+  swp3     1 PVID Egress Untagged
+
+  swp4     1 PVID Egress Untagged
+
+  br0      1 PVID Egress Untagged
+
+Note that in the above example, the bridge is unaware of the dsa_8021q VLANs
+and thinks the pvid of each port is 1. The bridge code design makes it too
+complicated to make it aware of these VIDs.
 
 The switches have two programmable filters for link-local destination MACs.
 These are used to trap BPDUs and PTP traffic to the master netdevice, and are
@@ -85,15 +120,18 @@ functionality.
 
 The following traffic modes are supported over the switch netdevices:
 
-+--------------------+------------+------------------+------------------+
-|                    | Standalone | Bridged with     | Bridged with     |
-|                    | ports      | vlan_filtering 0 | vlan_filtering 1 |
-+====================+============+==================+==================+
-| Regular traffic    |     Yes    |       Yes        |  No (use master) |
-+--------------------+------------+------------------+------------------+
-| Management traffic |     Yes    |       Yes        |       Yes        |
-| (BPDU, PTP)        |            |                  |                  |
-+--------------------+------------+------------------+------------------+
++-------------+------------+----------------+----------------+----------------------------+
+|             | Standalone |  Bridged with  |  Bridged with  |        Bridged with        |
+|             |    ports   | vlan_filtering | vlan_filtering | best_effort_vlan_filtering |
+|             |            |        0       |        1       |              1             |
++=============+============+================+================+============================+
+|   Regular   |     Yes    |       Yes      |       No       |     Partial (untagged),    |
+|   traffic   |            |                |  (use master)  |    use master for tagged   |
++-------------+------------+----------------+----------------+----------------------------+
+| Management  |     Yes    |       Yes      |      Yes       |             Yes            |
+|  traffic    |            |                |                |                            |
+| (BPDU, PTP) |            |                |                |                            |
++-------------+------------+----------------+----------------+----------------------------+
 
 Switching features
 ==================
@@ -144,7 +182,23 @@ intended results.
 If br0 has vlan_filtering 1, then a new br1 interface needs to be created that
 enslaves eth0 and eth1 (the DSA master of the switch ports). This is because in
 this mode, the switch ports beneath br0 are not capable of regular traffic, and
-are only used as a conduit for switchdev operations.
+are only used as a conduit for switchdev operations. But this cannot be done,
+due to this check in ``net/bridge/br_if.c``::
+
+	/* Don't allow bridging non-ethernet like devices, or DSA-enabled
+	 * master network devices since the bridge layer rx_handler prevents
+	 * the DSA fake ethertype handler to be invoked, so we do not strip off
+	 * the DSA switch tag protocol header and the bridge layer just return
+	 * RX_HANDLER_CONSUMED, stopping RX processing for these frames.
+	 */
+	if ((dev->flags & IFF_LOOPBACK) ||
+	    dev->type != ARPHRD_ETHER || dev->addr_len != ETH_ALEN ||
+	    !is_valid_ether_addr(dev->dev_addr) ||
+	    netdev_uses_dsa(dev))
+		return -EINVAL;
+
+So in practice, bridging with other net devices only works if the switch ports
+are able of terminating traffic.
 
 Offloads
 ========
diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index cc2e5e73e34c..50c9cbfe9503 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -94,6 +94,7 @@ struct sja1105_private {
 	struct sja1105_static_config static_config;
 	bool rgmii_rx_delay[SJA1105_NUM_PORTS];
 	bool rgmii_tx_delay[SJA1105_NUM_PORTS];
+	bool best_effort_vlan_filtering;
 	const struct sja1105_info *info;
 	struct gpio_desc *reset_gpio;
 	struct spi_device *spidev;
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 70dec3db0e9a..9ffeb21db2cc 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -1579,10 +1579,27 @@ sja1105_get_tag_protocol(struct dsa_switch *ds, int port)
 	return DSA_TAG_PROTO_SJA1105;
 }
 
-/* This callback needs to be present */
 static int sja1105_vlan_prepare(struct dsa_switch *ds, int port,
 				const struct switchdev_obj_port_vlan *vlan)
 {
+	struct sja1105_private *priv = ds->priv;
+	u16 vid;
+	int rc;
+
+	if (!dsa_port_is_vlan_filtering(dsa_to_port(ds, port)) ||
+	    !priv->best_effort_vlan_filtering)
+		return 0;
+
+	/* If the user wants best-effort VLAN filtering (aka vlan_filtering
+	 * bridge plus tagging), be sure to at least deny alterations to the
+	 * configuration done by dsa_8021q.
+	 */
+	for (vid = vlan->vid_begin; vid <= vlan->vid_end; vid++) {
+		rc = dsa_8021q_vid_validate(ds, port, vid, vlan->flags);
+		if (rc < 0)
+			return rc;
+	}
+
 	return 0;
 }
 
@@ -1596,6 +1613,7 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	struct sja1105_general_params_entry *general_params;
 	struct sja1105_private *priv = ds->priv;
 	struct sja1105_table *table;
+	bool want_tagging;
 	u16 tpid, tpid2;
 	int rc;
 
@@ -1621,8 +1639,10 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	general_params->incl_srcpt1 = enabled;
 	general_params->incl_srcpt0 = enabled;
 
+	want_tagging = priv->best_effort_vlan_filtering || !enabled;
+
 	/* VLAN filtering => independent VLAN learning.
-	 * No VLAN filtering => shared VLAN learning.
+	 * No VLAN filtering (or best effort) => shared VLAN learning.
 	 *
 	 * In shared VLAN learning mode, untagged traffic still gets
 	 * pvid-tagged, and the FDB table gets populated with entries
@@ -1641,7 +1661,7 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 	 */
 	table = &priv->static_config.tables[BLK_IDX_L2_LOOKUP_PARAMS];
 	l2_lookup_params = table->entries;
-	l2_lookup_params->shared_learn = !enabled;
+	l2_lookup_params->shared_learn = want_tagging;
 
 	rc = sja1105_static_config_reload(priv, SJA1105_VLAN_FILTERING);
 	if (rc)
@@ -1649,11 +1669,24 @@ static int sja1105_vlan_filtering(struct dsa_switch *ds, int port, bool enabled)
 
 	/* Switch port identification based on 802.1Q is only passable
 	 * if we are not under a vlan_filtering bridge. So make sure
-	 * the two configurations are mutually exclusive.
+	 * the two configurations are mutually exclusive (of course, the
+	 * user may know better, i.e. best_effort_vlan_filtering).
 	 */
-	return sja1105_setup_8021q_tagging(ds, !enabled);
+	return sja1105_setup_8021q_tagging(ds, want_tagging);
 }
 
+bool sja1105_can_use_vlan_as_tags(struct dsa_port *dp)
+{
+	struct dsa_switch *ds = dp->ds;
+	struct sja1105_private *priv = ds->priv;
+
+	if (dsa_port_is_vlan_filtering(dp) && !priv->best_effort_vlan_filtering)
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(sja1105_can_use_vlan_as_tags);
+
 static void sja1105_vlan_add(struct dsa_switch *ds, int port,
 			     const struct switchdev_obj_port_vlan *vlan)
 {
@@ -1726,9 +1759,35 @@ static int sja1105_hostprio_set(struct sja1105_private *priv, u8 hostprio)
 	return sja1105_static_config_reload(priv, SJA1105_HOSTPRIO);
 }
 
+static int sja1105_best_effort_vlan_filtering_get(struct sja1105_private *priv,
+						  bool *be_vlan)
+{
+	*be_vlan = priv->best_effort_vlan_filtering;
+
+	return 0;
+}
+
+static int sja1105_best_effort_vlan_filtering_set(struct sja1105_private *priv,
+						  bool be_vlan)
+{
+	struct dsa_switch *ds = priv->ds;
+	bool vlan_filtering;
+	int rc;
+
+	vlan_filtering = dsa_port_is_vlan_filtering(dsa_to_port(ds, 0));
+	priv->best_effort_vlan_filtering = be_vlan;
+
+	rtnl_lock();
+	rc = sja1105_vlan_filtering(ds, 0, vlan_filtering);
+	rtnl_unlock();
+
+	return rc;
+}
+
 enum sja1105_devlink_param_id {
 	SJA1105_DEVLINK_PARAM_ID_BASE = DEVLINK_PARAM_GENERIC_ID_MAX,
 	SJA1105_DEVLINK_PARAM_ID_HOSTPRIO,
+	SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING,
 };
 
 static int sja1105_devlink_param_get(struct dsa_switch *ds, u32 id,
@@ -1741,6 +1800,10 @@ static int sja1105_devlink_param_get(struct dsa_switch *ds, u32 id,
 	case SJA1105_DEVLINK_PARAM_ID_HOSTPRIO:
 		err = sja1105_hostprio_get(priv, &ctx->val.vu8);
 		break;
+	case SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING:
+		err = sja1105_best_effort_vlan_filtering_get(priv,
+							     &ctx->val.vbool);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
@@ -1759,6 +1822,10 @@ static int sja1105_devlink_param_set(struct dsa_switch *ds, u32 id,
 	case SJA1105_DEVLINK_PARAM_ID_HOSTPRIO:
 		err = sja1105_hostprio_set(priv, ctx->val.vu8);
 		break;
+	case SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING:
+		err = sja1105_best_effort_vlan_filtering_set(priv,
+							     ctx->val.vbool);
+		break;
 	default:
 		err = -EOPNOTSUPP;
 		break;
@@ -1771,6 +1838,10 @@ static const struct devlink_param sja1105_devlink_params[] = {
 	DSA_DEVLINK_PARAM_DRIVER(SJA1105_DEVLINK_PARAM_ID_HOSTPRIO,
 				 "hostprio", DEVLINK_PARAM_TYPE_U8,
 				 BIT(DEVLINK_PARAM_CMODE_RUNTIME)),
+	DSA_DEVLINK_PARAM_DRIVER(SJA1105_DEVLINK_PARAM_ID_BEST_EFFORT_VLAN_FILTERING,
+				 "best_effort_vlan_filtering",
+				 DEVLINK_PARAM_TYPE_BOOL,
+				 BIT(DEVLINK_PARAM_CMODE_RUNTIME)),
 };
 
 static int sja1105_setup_devlink_params(struct dsa_switch *ds)
diff --git a/include/linux/dsa/8021q.h b/include/linux/dsa/8021q.h
index 0aa803c451a3..7642537c71c1 100644
--- a/include/linux/dsa/8021q.h
+++ b/include/linux/dsa/8021q.h
@@ -17,6 +17,8 @@ struct packet_type;
 int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
 				 bool enabled);
 
+int dsa_8021q_vid_validate(struct dsa_switch *ds, int port, u16 vid, u16 flags);
+
 struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 			       u16 tpid, u16 tci);
 
@@ -38,6 +40,11 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int index,
 	return 0;
 }
 
+int dsa_8021q_vid_validate(struct dsa_switch *ds, int port, u16 vid, u16 flags)
+{
+	return 0;
+}
+
 struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 			       u16 tpid, u16 tci)
 {
diff --git a/include/linux/dsa/sja1105.h b/include/linux/dsa/sja1105.h
index 897e799dbcb9..ef3b12422722 100644
--- a/include/linux/dsa/sja1105.h
+++ b/include/linux/dsa/sja1105.h
@@ -61,4 +61,6 @@ struct sja1105_port {
 	int mgmt_slot;
 };
 
+bool sja1105_can_use_vlan_as_tags(struct dsa_port *dp);
+
 #endif /* _NET_DSA_SJA1105_H */
diff --git a/net/dsa/master.c b/net/dsa/master.c
index 3255dfc97f86..cbcbf3048f45 100644
--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -197,6 +197,12 @@ static int dsa_master_get_phys_port_name(struct net_device *dev,
 	return 0;
 }
 
+static netdev_features_t dsa_master_fix_features(struct net_device *dev,
+						 netdev_features_t features)
+{
+	return features & ~NETIF_F_HW_VLAN_CTAG_RX;
+}
+
 static int dsa_master_ethtool_setup(struct net_device *dev)
 {
 	struct dsa_port *cpu_dp = dev->dsa_ptr;
@@ -249,6 +255,7 @@ static int dsa_master_ndo_setup(struct net_device *dev)
 		memcpy(ops, cpu_dp->orig_ndo_ops, sizeof(*ops));
 
 	ops->ndo_get_phys_port_name = dsa_master_get_phys_port_name;
+	ops->ndo_fix_features = dsa_master_fix_features;
 
 	dev->netdev_ops  = ops;
 
diff --git a/net/dsa/tag_8021q.c b/net/dsa/tag_8021q.c
index 2fb6c26294b5..c39767f45516 100644
--- a/net/dsa/tag_8021q.c
+++ b/net/dsa/tag_8021q.c
@@ -288,6 +288,68 @@ int dsa_port_setup_8021q_tagging(struct dsa_switch *ds, int port, bool enabled)
 }
 EXPORT_SYMBOL_GPL(dsa_port_setup_8021q_tagging);
 
+int dsa_8021q_vid_validate(struct dsa_switch *ds, int port, u16 vid, u16 flags)
+{
+	int upstream = dsa_upstream_port(ds, port);
+	int rx_vid_of = ds->num_ports;
+	int tx_vid_of = ds->num_ports;
+	int other_port;
+
+	/* @vid wants to be a pvid of @port, but is not equal to its rx_vid */
+	if ((flags & BRIDGE_VLAN_INFO_PVID) &&
+	    vid != dsa_8021q_rx_vid(ds, port))
+		return -EPERM;
+
+	for (other_port = 0; other_port < ds->num_ports; other_port++) {
+		if (vid == dsa_8021q_rx_vid(ds, other_port)) {
+			rx_vid_of = other_port;
+			break;
+		}
+		if (vid == dsa_8021q_tx_vid(ds, other_port)) {
+			tx_vid_of = other_port;
+			break;
+		}
+	}
+
+	/* @vid is a TX VLAN of the @tx_vid_of port */
+	if (tx_vid_of != ds->num_ports) {
+		if (tx_vid_of == port) {
+			if (flags != BRIDGE_VLAN_INFO_UNTAGGED)
+				return -EPERM;
+			/* Fall through on proper flags */
+		} else if (port == upstream) {
+			if (flags != 0)
+				return -EPERM;
+			/* Fall through on proper flags */
+		} else {
+			/* Trying to configure on other port */
+			return -EPERM;
+		}
+	}
+
+	/* @vid is an RX VLAN of the @rx_vid_of port */
+	if (rx_vid_of != ds->num_ports) {
+		if (rx_vid_of == port) {
+			if (flags != (BRIDGE_VLAN_INFO_UNTAGGED |
+				      BRIDGE_VLAN_INFO_PVID))
+				return -EPERM;
+			/* Fall through on proper flags */
+		} else if (port == upstream) {
+			if (flags != 0)
+				return -EPERM;
+			/* Fall through on proper flags */
+		} else if (flags != BRIDGE_VLAN_INFO_UNTAGGED) {
+			/* Trying to configure on other port, but with
+			 * invalid flags.
+			 */
+			return -EPERM;
+		}
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dsa_8021q_vid_validate);
+
 struct sk_buff *dsa_8021q_xmit(struct sk_buff *skb, struct net_device *netdev,
 			       u16 tpid, u16 tci)
 {
diff --git a/net/dsa/tag_sja1105.c b/net/dsa/tag_sja1105.c
index f325624c25b5..225a95af92c9 100644
--- a/net/dsa/tag_sja1105.c
+++ b/net/dsa/tag_sja1105.c
@@ -74,7 +74,7 @@ static inline bool sja1105_is_meta_frame(const struct sk_buff *skb)
  */
 static bool sja1105_filter(const struct sk_buff *skb, struct net_device *dev)
 {
-	if (!dsa_port_is_vlan_filtering(dev->dsa_ptr))
+	if (sja1105_can_use_vlan_as_tags(skb->dev->dsa_ptr))
 		return true;
 	if (sja1105_is_link_local(skb))
 		return true;
@@ -91,6 +91,7 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 	u16 tx_vid = dsa_8021q_tx_vid(ds, dp->index);
 	u16 queue_mapping = skb_get_queue_mapping(skb);
 	u8 pcp = netdev_txq_to_tc(netdev, queue_mapping);
+	u16 tpid;
 
 	/* Transmitting management traffic does not rely upon switch tagging,
 	 * but instead SPI-installed management routes. Part 2 of this
@@ -99,15 +100,12 @@ static struct sk_buff *sja1105_xmit(struct sk_buff *skb,
 	if (unlikely(sja1105_is_link_local(skb)))
 		return dsa_defer_xmit(skb, netdev);
 
-	/* If we are under a vlan_filtering bridge, IP termination on
-	 * switch ports based on 802.1Q tags is simply too brittle to
-	 * be passable. So just defer to the dsa_slave_notag_xmit
-	 * implementation.
-	 */
 	if (dsa_port_is_vlan_filtering(dp))
-		return skb;
+		tpid = ETH_P_8021Q;
+	else
+		tpid = ETH_P_SJA1105;
 
-	return dsa_8021q_xmit(skb, netdev, ETH_P_SJA1105,
+	return dsa_8021q_xmit(skb, netdev, tpid,
 			     ((pcp << VLAN_PRIO_SHIFT) | tx_vid));
 }
 
@@ -250,7 +248,7 @@ static struct sk_buff *sja1105_rcv(struct sk_buff *skb,
 
 	hdr = vlan_eth_hdr(skb);
 	tpid = ntohs(hdr->h_vlan_proto);
-	is_tagged = (tpid == ETH_P_SJA1105);
+	is_tagged = (tpid == ETH_P_SJA1105 || tpid == ETH_P_8021Q);
 	is_link_local = sja1105_is_link_local(skb);
 	is_meta = sja1105_is_meta_frame(skb);
 
-- 
2.17.1

