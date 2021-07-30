Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5867D3E0171
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 14:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238276AbhHDMql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 08:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238214AbhHDMqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 08:46:24 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AEBC0617A4;
        Wed,  4 Aug 2021 05:45:50 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id n11so1140416wmd.2;
        Wed, 04 Aug 2021 05:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=auVShO/KOPLd/Z9skkoeLwX+SW55ROIfbzPJUZIBiDs=;
        b=t/O05RMpyuty0pLBsHSYZx/WLGgNwg+GeWetmTByCN/o0JX7N40sTtA5Luw9iRdgih
         QFRzD0qyyxqcIMKUc8dTQefd3uqbhBH5i7/4hIcLdvHO+6yS0XJZ2LPojx65NBlpsxkx
         ud5ctWFzRs8TMw0nCLGYML4MHBg7248rEMstL0SbM/dywSZOtTn0xkzee2vy53p1bqpL
         3hkL0g0WRE6eMAWIg76WRPem5MRuvM7W3PgS2BmFBpzvRy+wuXAq7UI4EQfJywuQkY/l
         q/zhV7U/10GqqRMpLInCVuuc3CKNCucLwffTTq3+uj/8DO/MeqhNV5CcCrwyPQ2WciHw
         1+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=auVShO/KOPLd/Z9skkoeLwX+SW55ROIfbzPJUZIBiDs=;
        b=bIIDF1+JCCx/cP7bA+l2WRcXUeIxzhs98nCYmVarJfuq57DY+ddREG5L2AdOZ/yXKy
         z9jCy5q9Cv+DqQFs3UI5CoPkhu/4BqsblsgQLUCuz4PE2bP6T4yXUWEf4uVJtagLhbFA
         W0bVAWxX5YNFzmanTnP32u7+i1hMyv7GMFBO9/oEaBfGcMGPFjrRt4KnVsn5/PWz8IWo
         pw3C4HS5ZqbKkWPFbtHo4/Icu6bnw3zI3X3Pqos3myVGpT9Xb+ljPUqNBpOPdfjAY/oM
         c/IqgCA3D4cQKJxOfCd6y+8TIfb4rAtDVHEWOP7Mbn6huYnxpDmc1k2VYusK5Ki0qFEL
         Jj3w==
X-Gm-Message-State: AOAM532t3fzMAx2IYLuDKE2H9dms4fmY+5r5gJvNZDAgwtDGor6r9l5J
        0gVPzaFrHr02W/58NSYyYeXN70vy4B8w0kQ=
X-Google-Smtp-Source: ABdhPJxIPQNwmvIwSuz7gf8D16n4SUfMXTO4pTSUl6berccDOGSU1nBnKp29L9MN1jXmTQbjIM1TqQ==
X-Received: by 2002:a1c:3886:: with SMTP id f128mr9806007wma.85.1628081148852;
        Wed, 04 Aug 2021 05:45:48 -0700 (PDT)
Received: from localhost.localdomain ([77.109.191.101])
        by smtp.gmail.com with ESMTPSA id y4sm2257923wmi.22.2021.08.04.05.45.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 05:45:48 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next v5 3/7] net: bonding: Add XDP support to the bonding driver
Date:   Fri, 30 Jul 2021 06:18:18 +0000
Message-Id: <20210730061822.6600-4-joamaki@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210730061822.6600-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
 <20210730061822.6600-1-joamaki@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

XDP is implemented in the bonding driver by transparently delegating
the XDP program loading, removal and xmit operations to the bonding
slave devices. The overall goal of this work is that XDP programs
can be attached to a bond device *without* any further changes (or
awareness) necessary to the program itself, meaning the same XDP
program can be attached to a native device but also a bonding device.

Semantics of XDP_TX when attached to a bond are equivalent in such
setting to the case when a tc/BPF program would be attached to the
bond, meaning transmitting the packet out of the bond itself using one
of the bond's configured xmit methods to select a slave device (rather
than XDP_TX on the slave itself). Handling of XDP_TX to transmit
using the configured bonding mechanism is therefore implemented by
rewriting the BPF program return value in bpf_prog_run_xdp. To avoid
performance impact this check is guarded by a static key, which is
incremented when a XDP program is loaded onto a bond device. This
approach was chosen to avoid changes to drivers implementing XDP. If
the slave device does not match the receive device, then XDP_REDIRECT
is transparently used to perform the redirection in order to have
the network driver release the packet from its RX ring.  The bonding
driver hashing functions have been refactored to allow reuse with
xdp_buff's to avoid code duplication.

The motivation for this change is to enable use of bonding (and
802.3ad) in hairpinning L4 load-balancers such as [1] implemented with
XDP and also to transparently support bond devices for projects that
use XDP given most modern NICs have dual port adapters.  An alternative
to this approach would be to implement 802.3ad in user-space and
implement the bonding load-balancing in the XDP program itself, but
is rather a cumbersome endeavor in terms of slave device management
(e.g. by watching netlink) and requires separate programs for native
vs bond cases for the orchestrator. A native in-kernel implementation
overcomes these issues and provides more flexibility.

Below are benchmark results done on two machines with 100Gbit
Intel E810 (ice) NIC and with 32-core 3970X on sending machine, and
16-core 3950X on receiving machine. 64 byte packets were sent with
pktgen-dpdk at full rate. Two issues [2, 3] were identified with the
ice driver, so the tests were performed with iommu=off and patch [2]
applied. Additionally the bonding round robin algorithm was modified
to use per-cpu tx counters as high CPU load (50% vs 10%) and high rate
of cache misses were caused by the shared rr_tx_counter (see patch
2/3). The statistics were collected using "sar -n dev -u 1 10".

 -----------------------|  CPU  |--| rxpck/s |--| txpck/s |----
 without patch (1 dev):
   XDP_DROP:              3.15%      48.6Mpps
   XDP_TX:                3.12%      18.3Mpps     18.3Mpps
   XDP_DROP (RSS):        9.47%      116.5Mpps
   XDP_TX (RSS):          9.67%      25.3Mpps     24.2Mpps
 -----------------------
 with patch, bond (1 dev):
   XDP_DROP:              3.14%      46.7Mpps
   XDP_TX:                3.15%      13.9Mpps     13.9Mpps
   XDP_DROP (RSS):        10.33%     117.2Mpps
   XDP_TX (RSS):          10.64%     25.1Mpps     24.0Mpps
 -----------------------
 with patch, bond (2 devs):
   XDP_DROP:              6.27%      92.7Mpps
   XDP_TX:                6.26%      17.6Mpps     17.5Mpps
   XDP_DROP (RSS):       11.38%      117.2Mpps
   XDP_TX (RSS):         14.30%      28.7Mpps     27.4Mpps
 --------------------------------------------------------------

RSS: Receive Side Scaling, e.g. the packets were sent to a range of
destination IPs.

[1]: https://cilium.io/blog/2021/05/20/cilium-110#standalonelb
[2]: https://lore.kernel.org/bpf/20210601113236.42651-1-maciej.fijalkowski@intel.com/T/#t
[3]: https://lore.kernel.org/bpf/CAHn8xckNXci+X_Eb2WMv4uVYjO2331UWB2JLtXr_58z0Av8+8A@mail.gmail.com/

Signed-off-by: Jussi Maki <joamaki@gmail.com>
---
 drivers/net/bonding/bond_main.c | 309 +++++++++++++++++++++++++++++++-
 include/net/bonding.h           |   1 +
 2 files changed, 309 insertions(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index dcec5cc4dab1..fcd01acd1c83 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -317,6 +317,19 @@ bool bond_sk_check(struct bonding *bond)
 	}
 }
 
+static bool bond_xdp_check(struct bonding *bond)
+{
+	switch (BOND_MODE(bond)) {
+	case BOND_MODE_ROUNDROBIN:
+	case BOND_MODE_ACTIVEBACKUP:
+	case BOND_MODE_8023AD:
+	case BOND_MODE_XOR:
+		return true;
+	default:
+		return false;
+	}
+}
+
 /*---------------------------------- VLAN -----------------------------------*/
 
 /* In the following 2 functions, bond_vlan_rx_add_vid and bond_vlan_rx_kill_vid,
@@ -2133,6 +2146,41 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 		bond_update_slave_arr(bond, NULL);
 
 
+	if (!slave_dev->netdev_ops->ndo_bpf ||
+	    !slave_dev->netdev_ops->ndo_xdp_xmit) {
+		if (bond->xdp_prog) {
+			NL_SET_ERR_MSG(extack, "Slave does not support XDP");
+			slave_err(bond_dev, slave_dev, "Slave does not support XDP\n");
+			res = -EOPNOTSUPP;
+			goto err_sysfs_del;
+		}
+	} else {
+		struct netdev_bpf xdp = {
+			.command = XDP_SETUP_PROG,
+			.flags   = 0,
+			.prog    = bond->xdp_prog,
+			.extack  = extack,
+		};
+
+		if (dev_xdp_prog_count(slave_dev) > 0) {
+			NL_SET_ERR_MSG(extack,
+				       "Slave has XDP program loaded, please unload before enslaving");
+			slave_err(bond_dev, slave_dev,
+				  "Slave has XDP program loaded, please unload before enslaving\n");
+			res = -EOPNOTSUPP;
+			goto err_sysfs_del;
+		}
+
+		res = slave_dev->netdev_ops->ndo_bpf(slave_dev, &xdp);
+		if (res < 0) {
+			/* ndo_bpf() sets extack error message */
+			slave_dbg(bond_dev, slave_dev, "Error %d calling ndo_bpf\n", res);
+			goto err_sysfs_del;
+		}
+		if (bond->xdp_prog)
+			bpf_prog_inc(bond->xdp_prog);
+	}
+
 	slave_info(bond_dev, slave_dev, "Enslaving as %s interface with %s link\n",
 		   bond_is_active_slave(new_slave) ? "an active" : "a backup",
 		   new_slave->link != BOND_LINK_DOWN ? "an up" : "a down");
@@ -2252,6 +2300,17 @@ static int __bond_release_one(struct net_device *bond_dev,
 	/* recompute stats just before removing the slave */
 	bond_get_stats(bond->dev, &bond->bond_stats);
 
+	if (bond->xdp_prog) {
+		struct netdev_bpf xdp = {
+			.command = XDP_SETUP_PROG,
+			.flags   = 0,
+			.prog	 = NULL,
+			.extack  = NULL,
+		};
+		if (slave_dev->netdev_ops->ndo_bpf(slave_dev, &xdp))
+			slave_warn(bond_dev, slave_dev, "failed to unload XDP program\n");
+	}
+
 	bond_upper_dev_unlink(bond, slave);
 	/* unregister rx_handler early so bond_handle_frame wouldn't be called
 	 * for this slave anymore.
@@ -3635,7 +3694,7 @@ static inline u32 bond_eth_hash(struct sk_buff *skb, const void *data, int mhoff
 		return 0;
 
 	ep = (struct ethhdr *)(data + mhoff);
-	return ep->h_dest[5] ^ ep->h_source[5] ^ ep->h_proto;
+	return ep->h_dest[5] ^ ep->h_source[5] ^ be16_to_cpu(ep->h_proto);
 }
 
 static bool bond_flow_ip(struct sk_buff *skb, struct flow_keys *fk, const void *data,
@@ -3804,6 +3863,26 @@ u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
 				skb_headlen(skb));
 }
 
+/**
+ * bond_xmit_hash_xdp - generate a hash value based on the xmit policy
+ * @bond: bonding device
+ * @xdp: buffer to use for headers
+ *
+ * The XDP variant of bond_xmit_hash.
+ */
+static u32 bond_xmit_hash_xdp(struct bonding *bond, struct xdp_buff *xdp)
+{
+	struct ethhdr *eth;
+
+	if (xdp->data + sizeof(struct ethhdr) > xdp->data_end)
+		return 0;
+
+	eth = (struct ethhdr *)xdp->data;
+
+	return __bond_xmit_hash(bond, NULL, xdp->data, eth->h_proto, 0,
+				sizeof(struct ethhdr), xdp->data_end - xdp->data);
+}
+
 /*-------------------------- Device entry points ----------------------------*/
 
 void bond_work_init_all(struct bonding *bond)
@@ -4420,6 +4499,47 @@ static struct slave *bond_xmit_roundrobin_slave_get(struct bonding *bond,
 	return NULL;
 }
 
+static struct slave *bond_xdp_xmit_roundrobin_slave_get(struct bonding *bond,
+							struct xdp_buff *xdp)
+{
+	struct slave *slave;
+	int slave_cnt;
+	u32 slave_id;
+	const struct ethhdr *eth;
+	void *data = xdp->data;
+
+	if (data + sizeof(struct ethhdr) > xdp->data_end)
+		goto non_igmp;
+
+	eth = (struct ethhdr *)data;
+	data += sizeof(struct ethhdr);
+
+	/* See comment on IGMP in bond_xmit_roundrobin_slave_get() */
+	if (eth->h_proto == htons(ETH_P_IP)) {
+		const struct iphdr *iph;
+
+		if (data + sizeof(struct iphdr) > xdp->data_end)
+			goto non_igmp;
+
+		iph = (struct iphdr *)data;
+
+		if (iph->protocol == IPPROTO_IGMP) {
+			slave = rcu_dereference(bond->curr_active_slave);
+			if (slave)
+				return slave;
+			return bond_get_slave_by_id(bond, 0);
+		}
+	}
+
+non_igmp:
+	slave_cnt = READ_ONCE(bond->slave_cnt);
+	if (likely(slave_cnt)) {
+		slave_id = bond_rr_gen_slave_id(bond) % slave_cnt;
+		return bond_get_slave_by_id(bond, slave_id);
+	}
+	return NULL;
+}
+
 static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
 					struct net_device *bond_dev)
 {
@@ -4635,6 +4755,22 @@ static struct slave *bond_xmit_3ad_xor_slave_get(struct bonding *bond,
 	return slave;
 }
 
+static struct slave *bond_xdp_xmit_3ad_xor_slave_get(struct bonding *bond,
+						     struct xdp_buff *xdp)
+{
+	struct bond_up_slave *slaves;
+	unsigned int count;
+	u32 hash;
+
+	hash = bond_xmit_hash_xdp(bond, xdp);
+	slaves = rcu_dereference(bond->usable_slaves);
+	count = slaves ? READ_ONCE(slaves->count) : 0;
+	if (unlikely(!count))
+		return NULL;
+
+	return slaves->arr[hash % count];
+}
+
 /* Use this Xmit function for 3AD as well as XOR modes. The current
  * usable slave array is formed in the control path. The xmit function
  * just calculates hash and sends the packet out.
@@ -4919,6 +5055,174 @@ static netdev_tx_t bond_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return ret;
 }
 
+static struct net_device *
+bond_xdp_get_xmit_slave(struct net_device *bond_dev, struct xdp_buff *xdp)
+{
+	struct bonding *bond = netdev_priv(bond_dev);
+	struct slave *slave;
+
+	/* Caller needs to hold rcu_read_lock() */
+
+	switch (BOND_MODE(bond)) {
+	case BOND_MODE_ROUNDROBIN:
+		slave = bond_xdp_xmit_roundrobin_slave_get(bond, xdp);
+		break;
+
+	case BOND_MODE_ACTIVEBACKUP:
+		slave = bond_xmit_activebackup_slave_get(bond);
+		break;
+
+	case BOND_MODE_8023AD:
+	case BOND_MODE_XOR:
+		slave = bond_xdp_xmit_3ad_xor_slave_get(bond, xdp);
+		break;
+
+	default:
+		/* Should never happen. Mode guarded by bond_xdp_check() */
+		netdev_err(bond_dev, "Unknown bonding mode %d for xdp xmit\n", BOND_MODE(bond));
+		WARN_ON_ONCE(1);
+		return NULL;
+	}
+
+	if (slave)
+		return slave->dev;
+
+	return NULL;
+}
+
+static int bond_xdp_xmit(struct net_device *bond_dev,
+			 int n, struct xdp_frame **frames, u32 flags)
+{
+	int nxmit, err = -ENXIO;
+
+	rcu_read_lock();
+
+	for (nxmit = 0; nxmit < n; nxmit++) {
+		struct xdp_frame *frame = frames[nxmit];
+		struct xdp_frame *frames1[] = {frame};
+		struct net_device *slave_dev;
+		struct xdp_buff xdp;
+
+		xdp_convert_frame_to_buff(frame, &xdp);
+
+		slave_dev = bond_xdp_get_xmit_slave(bond_dev, &xdp);
+		if (!slave_dev) {
+			err = -ENXIO;
+			break;
+		}
+
+		err = slave_dev->netdev_ops->ndo_xdp_xmit(slave_dev, 1, frames1, flags);
+		if (err < 1)
+			break;
+	}
+
+	rcu_read_unlock();
+
+	/* If error happened on the first frame then we can pass the error up, otherwise
+	 * report the number of frames that were xmitted.
+	 */
+	if (err < 0)
+		return (nxmit == 0 ? err : nxmit);
+
+	return nxmit;
+}
+
+static int bond_xdp_set(struct net_device *dev, struct bpf_prog *prog,
+			struct netlink_ext_ack *extack)
+{
+	struct bonding *bond = netdev_priv(dev);
+	struct list_head *iter;
+	struct slave *slave, *rollback_slave;
+	struct bpf_prog *old_prog;
+	struct netdev_bpf xdp = {
+		.command = XDP_SETUP_PROG,
+		.flags   = 0,
+		.prog    = prog,
+		.extack  = extack,
+	};
+	int err;
+
+	ASSERT_RTNL();
+
+	if (!bond_xdp_check(bond))
+		return -EOPNOTSUPP;
+
+	old_prog = bond->xdp_prog;
+	bond->xdp_prog = prog;
+
+	bond_for_each_slave(bond, slave, iter) {
+		struct net_device *slave_dev = slave->dev;
+
+		if (!slave_dev->netdev_ops->ndo_bpf ||
+		    !slave_dev->netdev_ops->ndo_xdp_xmit) {
+			NL_SET_ERR_MSG(extack, "Slave device does not support XDP");
+			slave_err(dev, slave_dev, "Slave does not support XDP\n");
+			err = -EOPNOTSUPP;
+			goto err;
+		}
+
+		if (dev_xdp_prog_count(slave_dev) > 0) {
+			NL_SET_ERR_MSG(extack,
+				       "Slave has XDP program loaded, please unload before enslaving");
+			slave_err(dev, slave_dev,
+				  "Slave has XDP program loaded, please unload before enslaving\n");
+			err = -EOPNOTSUPP;
+			goto err;
+		}
+
+		err = slave_dev->netdev_ops->ndo_bpf(slave_dev, &xdp);
+		if (err < 0) {
+			/* ndo_bpf() sets extack error message */
+			slave_err(dev, slave_dev, "Error %d calling ndo_bpf\n", err);
+			goto err;
+		}
+		if (prog)
+			bpf_prog_inc(prog);
+	}
+
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
+	if (prog)
+		static_branch_inc(&bpf_master_redirect_enabled_key);
+	else
+		static_branch_dec(&bpf_master_redirect_enabled_key);
+
+	return 0;
+
+err:
+	/* unwind the program changes */
+	bond->xdp_prog = old_prog;
+	xdp.prog = old_prog;
+	xdp.extack = NULL; /* do not overwrite original error */
+
+	bond_for_each_slave(bond, rollback_slave, iter) {
+		struct net_device *slave_dev = rollback_slave->dev;
+		int err_unwind;
+
+		if (slave == rollback_slave)
+			break;
+
+		err_unwind = slave_dev->netdev_ops->ndo_bpf(slave_dev, &xdp);
+		if (err_unwind < 0)
+			slave_err(dev, slave_dev,
+				  "Error %d when unwinding XDP program change\n", err_unwind);
+		else if (xdp.prog)
+			bpf_prog_inc(xdp.prog);
+	}
+	return err;
+}
+
+static int bond_xdp(struct net_device *dev, struct netdev_bpf *xdp)
+{
+	switch (xdp->command) {
+	case XDP_SETUP_PROG:
+		return bond_xdp_set(dev, xdp->prog, xdp->extack);
+	default:
+		return -EINVAL;
+	}
+}
+
 static u32 bond_mode_bcast_speed(struct slave *slave, u32 speed)
 {
 	if (speed == 0 || speed == SPEED_UNKNOWN)
@@ -5005,6 +5309,9 @@ static const struct net_device_ops bond_netdev_ops = {
 	.ndo_features_check	= passthru_features_check,
 	.ndo_get_xmit_slave	= bond_xmit_get_slave,
 	.ndo_sk_get_lower_dev	= bond_sk_get_lower_dev,
+	.ndo_bpf		= bond_xdp,
+	.ndo_xdp_xmit           = bond_xdp_xmit,
+	.ndo_xdp_get_xmit_slave = bond_xdp_get_xmit_slave,
 };
 
 static const struct device_type bond_type = {
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 625d9c72dee3..b91c365e4e95 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -258,6 +258,7 @@ struct bonding {
 	/* protecting ipsec_list */
 	spinlock_t ipsec_lock;
 #endif /* CONFIG_XFRM_OFFLOAD */
+	struct bpf_prog *xdp_prog;
 };
 
 #define bond_slave_get_rcu(dev) \
-- 
2.17.1

