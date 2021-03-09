Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7065332E73
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 19:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhCISnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 13:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbhCISnM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 13:43:12 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE426C06174A
        for <netdev@vger.kernel.org>; Tue,  9 Mar 2021 10:43:11 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id d3so28749015lfg.10
        for <netdev@vger.kernel.org>; Tue, 09 Mar 2021 10:43:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=ibLfE9SB7taWeIhzU/TH+UoIMdEYkMISEHLg06mJuPo=;
        b=vPfxERZmgEb/Bmq+pLbVj3GwVS46Hho6LyRgOhc+Aa8kx/NGoNTeSI3JH2YaRKG4mV
         t7ql2kdHScCqoPTseiNk7gE1IVLnq7AhDPuxXE1x+ctvwJwQ9USs6H/C2GLUkcF8s7Et
         SVjPENrYMwj022MH/dG4QOMvWJRoc5dHaku7mo7dyHy4tajwbdaD4My8pXkQFVtQiBR7
         +3BqOZICJpjluU+qyDhLGqcIfPFDwIdiWg6jct2RhNsACByeUHW5vSXXv9P6CqfnJWad
         6a5BjlqpfUJXQTuWIaJ2I6r1uuUA9SAiiK1IipsRhaQiBbLgSWpJv3D1v4+Zcoba6SBO
         IK1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=ibLfE9SB7taWeIhzU/TH+UoIMdEYkMISEHLg06mJuPo=;
        b=iMTebdGDNIwvlQ/5df8vVhJyDeHJftMMRbb9tcmsPjZzSMRSZTTBgHiHBXCt2G5Ox4
         w7ZO2gNTsU1EODuAS2YH0hkB/f+XpVVNTotBgGg6/+xl9I8pSuuXkYkUDWue99arHH+u
         y0+hWLdRo2V6mdx4inLsTAoDRgOK2io8ohwK3CRXQH9lKS4MDS8jKw0jVKBPrlr0MubM
         spIvZrjLZdZtdIkp9dy4dgKwNEdM5fSQlFnx8NCdc9NXw3RcRSlvzytX20Had1/AycTf
         C/YJkcMFti81DLA41iHb9/tiRSW78IhKN9vO1p0xz7BZfpJJ/FIyvkzMusjkH/ZVq4h3
         mp3A==
X-Gm-Message-State: AOAM533qq6b4aGr1IhdRtepCFUqAZNjF94eNj9JFTy1fiB0R+5p87ISP
        hMPI26u4CK/h1Er/KVSPjooOZw==
X-Google-Smtp-Source: ABdhPJwBY07QVC+1QBVWNbc7MQ95/8l9xRILYTjMKqvqOwrn6MlBr2vIkMRl4u3j2knTelFjqjXvSA==
X-Received: by 2002:a05:6512:3045:: with SMTP id b5mr18108416lfb.32.1615315390225;
        Tue, 09 Mar 2021 10:43:10 -0800 (PST)
Received: from veiron.westermo.com (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id j20sm2020949lfu.94.2021.03.09.10.43.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 10:43:09 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        olteanv@gmail.com, netdev@vger.kernel.org
Subject: [RFC net] net: dsa: Centralize validation of VLAN configuration
Date:   Tue,  9 Mar 2021 19:42:44 +0100
Message-Id: <20210309184244.1970173-1-tobias@waldekranz.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are three kinds of events that have an inpact on VLAN
configuration of DSA ports:

- Adding of stacked VLANs
  (ip link add dev swp0.1 link swp0 type vlan id 1)

- Adding of bridged VLANs
  (bridge vlan add dev swp0 vid 1)

- Changes to a bridge's VLAN filtering setting
  (ip link set dev br0 type bridge vlan_filtering 1)

For all of these events, we want to ensure that some invariants are
upheld:

- For hardware where VLAN filtering is a global setting, either all
  bridges must use VLAN filtering, or no bridge can.

- For all filtering bridges, no stacked VLAN on any port may be
  configured on multiple ports.

- For all filtering bridges, no stacked VLAN may be configured in the
  bridge.

Move the validation of these invariants to a central function, and use
it from all sites where these events are handled. This way, we ensure
that all invariants are always checked, avoiding certain configs being
allowed or disallowed depending on the order in which commands are
given.

Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
---

There is still testing left to do on this, but I wanted to send early
in order show what I meant by "generic" VLAN validation in this
discussion:

https://lore.kernel.org/netdev/87mtvdp97q.fsf@waldekranz.com/

This is basically an alternative implementation of 1/4 and 2/4 from
this series by Vladimir:

https://lore.kernel.org/netdev/20210309021657.3639745-1-olteanv@gmail.com/

net/dsa/dsa_priv.h |   4 ++
 net/dsa/port.c     | 167 ++++++++++++++++++++++++++++++++-------------
 net/dsa/slave.c    |  31 +--------
 3 files changed, 125 insertions(+), 77 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 9d4b0e9b1aa1..c88ef5a43612 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -188,6 +188,10 @@ int dsa_port_lag_change(struct dsa_port *dp,
 int dsa_port_lag_join(struct dsa_port *dp, struct net_device *lag_dev,
 		      struct netdev_lag_upper_info *uinfo);
 void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag_dev);
+bool dsa_port_can_apply_stacked_vlan(struct dsa_port *dp, u16 vid,
+				     struct netlink_ext_ack *extack);
+bool dsa_port_can_apply_bridge_vlan(struct dsa_port *dp, u16 vid,
+				    struct netlink_ext_ack *extack);
 int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
 			    struct netlink_ext_ack *extack);
 bool dsa_port_skip_vlan_configuration(struct dsa_port *dp);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index c9c6d7ab3f47..3bf457d6775d 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -292,72 +292,141 @@ void dsa_port_lag_leave(struct dsa_port *dp, struct net_device *lag)
 	dsa_lag_unmap(dp->ds->dst, lag);
 }
 
-/* Must be called under rcu_read_lock() */
-static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
-					      bool vlan_filtering,
-					      struct netlink_ext_ack *extack)
+static int dsa_port_stacked_vids_collect(struct net_device *vdev, int vid,
+					 void *_stacked_vids)
 {
-	struct dsa_switch *ds = dp->ds;
-	int err, i;
+	unsigned long *stacked_vids = _stacked_vids;
+
+	if (test_bit(vid, stacked_vids))
+		return -EBUSY;
 
-	/* VLAN awareness was off, so the question is "can we turn it on".
-	 * We may have had 8021q uppers, those need to go. Make sure we don't
-	 * enter an inconsistent state: deny changing the VLAN awareness state
-	 * as long as we have 8021q uppers.
+	set_bit(vid, stacked_vids);
+	return 0;
+}
+
+static bool dsa_port_can_apply_vlan(struct dsa_port *dp, bool *mod_filter,
+				    u16 *stacked_vid, u16 *br_vid,
+				    struct netlink_ext_ack *extack)
+{
+	struct dsa_switch_tree *dst = dp->ds->dst;
+	unsigned long *stacked_vids = NULL;
+	struct dsa_port *other_dp;
+	bool filter;
+	u16 vid;
+
+	/* If the modification we are validating is not toggling VLAN
+	 * filtering, use the current setting.
 	 */
-	if (vlan_filtering && dsa_is_user_port(ds, dp->index)) {
-		struct net_device *upper_dev, *slave = dp->slave;
-		struct net_device *br = dp->bridge_dev;
-		struct list_head *iter;
+	if (mod_filter)
+		filter = *mod_filter;
+	else
+		filter = dp->bridge_dev && br_vlan_enabled(dp->bridge_dev);
 
-		netdev_for_each_upper_dev_rcu(slave, upper_dev, iter) {
-			struct bridge_vlan_info br_info;
-			u16 vid;
+	/* For cases where enabling/disabling VLAN awareness is global
+	 * to the switch, we need to handle the case where multiple
+	 * bridges span different ports of the same switch device and
+	 * one of them has a different setting than what is being
+	 * requested.
+	 */
+	if (dp->ds->vlan_filtering_is_global) {
+		list_for_each_entry(other_dp, &dst->ports, list) {
+			if (!other_dp->bridge_dev ||
+			    other_dp->bridge_dev == dp->bridge_dev)
+				continue;
 
-			if (!is_vlan_dev(upper_dev))
+			if (br_vlan_enabled(other_dp->bridge_dev) == filter)
 				continue;
 
-			vid = vlan_dev_vlan_id(upper_dev);
-
-			/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
-			 * device, respectively the VID is not found, returning
-			 * 0 means success, which is a failure for us here.
-			 */
-			err = br_vlan_get_info(br, vid, &br_info);
-			if (err == 0) {
-				NL_SET_ERR_MSG_MOD(extack,
-						   "Must first remove VLAN uppers having VIDs also present in bridge");
-				return false;
-			}
+			NL_SET_ERR_MSG_MOD(extack, "VLAN filtering is a global setting");
+			goto err;
 		}
+
 	}
 
-	if (!ds->vlan_filtering_is_global)
+	if (!filter)
 		return true;
 
-	/* For cases where enabling/disabling VLAN awareness is global to the
-	 * switch, we need to handle the case where multiple bridges span
-	 * different ports of the same switch device and one of them has a
-	 * different setting than what is being requested.
-	 */
-	for (i = 0; i < ds->num_ports; i++) {
-		struct net_device *other_bridge;
+	stacked_vids = bitmap_zalloc(VLAN_N_VID, GFP_KERNEL);
+	if (!stacked_vids) {
+		WARN_ON_ONCE(1);
+		goto err;
+	}
 
-		other_bridge = dsa_to_port(ds, i)->bridge_dev;
-		if (!other_bridge)
+	/* If the current operation is to add a stacked VLAN, mark it
+	 * as busy. */
+	if (stacked_vid)
+		set_bit(*stacked_vid, stacked_vids);
+
+	/* Forbid any VID used by a stacked VLAN to exist on more than
+	 * one port in the bridge, as the resulting configuration in
+	 * hardware would allow forwarding between those ports. */
+	list_for_each_entry(other_dp, &dst->ports, list) {
+		if (!dsa_is_user_port(other_dp->ds, other_dp->index) ||
+		    !other_dp->bridge_dev ||
+		    other_dp->bridge_dev != dp->bridge_dev)
 			continue;
-		/* If it's the same bridge, it also has same
-		 * vlan_filtering setting => no need to check
-		 */
-		if (other_bridge == dp->bridge_dev)
-			continue;
-		if (br_vlan_enabled(other_bridge) != vlan_filtering) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "VLAN filtering is a global setting");
-			return false;
+
+		if (vlan_for_each(other_dp->slave, dsa_port_stacked_vids_collect,
+				  stacked_vids)) {
+			NL_SET_ERR_MSG_MOD(extack, "Two bridge ports cannot be "
+					   "the base interfaces for VLAN "
+					   "interfaces using the same VID");
+			goto err;
 		}
 	}
+
+	/* If the current operation is to add a bridge VLAN, make sure
+	 * that it is not used by a stacked VLAN. */
+	if (br_vid && test_bit(*br_vid, stacked_vids)) {
+		NL_SET_ERR_MSG_MOD(extack, "A bridge cannot use the same VID "
+				   "already in use by a VLAN interface "
+				   "configured on a bridge port");
+		goto err;
+	}
+
+	/* Ensure that no stacked VLAN is also configured on the bridge
+	 * offloaded by dp as that could result in leakage between
+	 * non-bridged ports. */
+	for_each_set_bit(vid, stacked_vids, VLAN_N_VID) {
+		struct bridge_vlan_info br_info;
+
+		if (br_vlan_get_info(dp->bridge_dev, vid, &br_info))
+			/* Error means that the VID does not exist,
+			 * which is what we want to ensure. */
+			continue;
+
+		NL_SET_ERR_MSG_MOD(extack, "A VLAN interface cannot use a VID "
+				   "that is already in use by a bridge");
+		goto err;
+	}
+
+	kfree(stacked_vids);
 	return true;
+
+err:
+	if (stacked_vids)
+		kfree(stacked_vids);
+	return false;
+}
+
+bool dsa_port_can_apply_stacked_vlan(struct dsa_port *dp, u16 vid,
+				     struct netlink_ext_ack *extack)
+{
+	return dsa_port_can_apply_vlan(dp, NULL, &vid, NULL, extack);
+}
+
+bool dsa_port_can_apply_bridge_vlan(struct dsa_port *dp, u16 vid,
+				    struct netlink_ext_ack *extack)
+{
+	return dsa_port_can_apply_vlan(dp, NULL, NULL, &vid, extack);
+}
+
+static bool dsa_port_can_apply_vlan_filtering(struct dsa_port *dp,
+					      bool vlan_filtering,
+					      struct netlink_ext_ack *extack)
+{
+	return dsa_port_can_apply_vlan(dp, &vlan_filtering,
+				       NULL, NULL, extack);
 }
 
 int dsa_port_vlan_filtering(struct dsa_port *dp, bool vlan_filtering,
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 992fcab4b552..fc0dfeb6b64c 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -363,19 +363,8 @@ static int dsa_slave_vlan_add(struct net_device *dev,
 
 	vlan = *SWITCHDEV_OBJ_PORT_VLAN(obj);
 
-	/* Deny adding a bridge VLAN when there is already an 802.1Q upper with
-	 * the same VID.
-	 */
-	if (br_vlan_enabled(dp->bridge_dev)) {
-		rcu_read_lock();
-		err = dsa_slave_vlan_check_for_8021q_uppers(dev, &vlan);
-		rcu_read_unlock();
-		if (err) {
-			NL_SET_ERR_MSG_MOD(extack,
-					   "Port already has a VLAN upper with this VID");
-			return err;
-		}
-	}
+	if (!dsa_port_can_apply_bridge_vlan(dp, vlan.vid, extack))
+		return -EBUSY;
 
 	err = dsa_port_vlan_add(dp, &vlan, extack);
 	if (err)
@@ -2083,28 +2072,14 @@ dsa_slave_check_8021q_upper(struct net_device *dev,
 			    struct netdev_notifier_changeupper_info *info)
 {
 	struct dsa_port *dp = dsa_slave_to_port(dev);
-	struct net_device *br = dp->bridge_dev;
-	struct bridge_vlan_info br_info;
 	struct netlink_ext_ack *extack;
-	int err = NOTIFY_DONE;
 	u16 vid;
 
-	if (!br || !br_vlan_enabled(br))
-		return NOTIFY_DONE;
-
 	extack = netdev_notifier_info_to_extack(&info->info);
 	vid = vlan_dev_vlan_id(info->upper_dev);
 
-	/* br_vlan_get_info() returns -EINVAL or -ENOENT if the
-	 * device, respectively the VID is not found, returning
-	 * 0 means success, which is a failure for us here.
-	 */
-	err = br_vlan_get_info(br, vid, &br_info);
-	if (err == 0) {
-		NL_SET_ERR_MSG_MOD(extack,
-				   "This VLAN is already configured by the bridge");
+	if (!dsa_port_can_apply_stacked_vlan(dp, vid, extack))
 		return notifier_from_errno(-EBUSY);
-	}
 
 	return NOTIFY_DONE;
 }
-- 
2.25.1

