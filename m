Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BC53A1638
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 15:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236941AbhFIN54 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 09:57:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236920AbhFIN5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 09:57:54 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52176C0617AD;
        Wed,  9 Jun 2021 06:55:58 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id l18-20020a1ced120000b029014c1adff1edso4343983wmh.4;
        Wed, 09 Jun 2021 06:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tALAO84BEXwlra45I/+aqzN4vNsFkPhbOFHYbn72oHs=;
        b=Hw4mRZsUOIm/vf8qZK3Lhzh7sUXQSNVeoTtGrYSTbuJG+860zzm/CMlmDk0Y+0eFpR
         i7wuAWXV05KvXEFxdCWUKMkSqmTvop7ltWPt+JCk9tnxpdoPvzwA62Bv2ssGorND0hnJ
         HUkMgVxXX6+mlK6EGKDX/5hwlNRpcdLmHgRRZ5hhqYQ4FCEcjs2Nu3tyQFfwVGYgqQNX
         D8/HghFQzKmvYjVUlQH7P2LUWet59p+eHkJlkElymdAfocIwsFNu/KQQTDZQRBKkj8Cl
         oFEFDJAzkHzB29P2u+dZCRDtp6bwdDPuD5YkQSo5Z7gNAJdlaZB4NVHVr0NlOzsA0Z8r
         lAww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tALAO84BEXwlra45I/+aqzN4vNsFkPhbOFHYbn72oHs=;
        b=hDl0rPchQyC0HzoXfr6QvC+S+6zdXVrTb+k5j6vR4cPWsIkyGzLu3PxFFWWotOs66x
         Uy0CtaIm9CbmYmSD5Q6nLtQza0jDeMLP+G/Dnt/VB4ODQuD38+jWIofXVRcXFoMPjJLg
         OZfLkTW96WX5jGShwf0794jQm9EALuu+oQsY//1kAjuav0ts5kGL8lZHJxZP1UT0tlJ+
         oemrSdM+Gs7NJDF+R7XNx6sbGIHlx7LJ3LfuK8JFXlpL4V/LGIkinL5yCqb9ldBAQAoO
         Mw6uLPtumm1C4xL+nIohbLJ+7LUZdJKdYjgUhQOzKiXMFGy1ra3imbeRza7RHWnDfyE+
         JCNw==
X-Gm-Message-State: AOAM530Mbgwo4RYx6nNTfv13f72pfdpc8zpCEbDnxhVCTVWNewmjPSZS
        JWtUHVMJUD3eZhjgsQscgWxTgHz4Wd6Hvks=
X-Google-Smtp-Source: ABdhPJxQ6UCvfO5UbfWoaDejEReEAGf7r0T9lvcRbzxx88+aBf3ZaPVCxn/OBCVVWGeZUTTqmhUOrQ==
X-Received: by 2002:a1c:f206:: with SMTP id s6mr4205924wmc.102.1623246954004;
        Wed, 09 Jun 2021 06:55:54 -0700 (PDT)
Received: from balnab.. ([37.17.237.224])
        by smtp.gmail.com with ESMTPSA id q20sm4575wrf.45.2021.06.09.06.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 06:55:53 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next 1/3] net: bonding: Add XDP support to the bonding driver
Date:   Wed,  9 Jun 2021 13:55:35 +0000
Message-Id: <20210609135537.1460244-2-joamaki@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210609135537.1460244-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 drivers/net/bonding/bond_main.c | 441 ++++++++++++++++++++++++++++----
 include/linux/filter.h          |  13 +-
 include/linux/netdevice.h       |   5 +
 include/net/bonding.h           |   1 +
 kernel/bpf/devmap.c             |  34 ++-
 net/core/filter.c               |  37 ++-
 6 files changed, 467 insertions(+), 64 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index dafeaef3cbd3..38eea7e096f3 100644
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
@@ -2001,6 +2014,28 @@ int bond_enslave(struct net_device *bond_dev, struct net_device *slave_dev,
 	if (bond_mode_can_use_xmit_hash(bond))
 		bond_update_slave_arr(bond, NULL);
 
+	if (bond->xdp_prog) {
+		struct netdev_bpf xdp = {
+			.command = XDP_SETUP_PROG,
+			.flags   = 0,
+			.prog    = bond->xdp_prog,
+			.extack  = extack,
+		};
+		if (!slave_dev->netdev_ops->ndo_bpf ||
+		    !slave_dev->netdev_ops->ndo_xdp_xmit) {
+			NL_SET_ERR_MSG(extack, "Slave does not support XDP");
+			slave_err(bond_dev, slave_dev, "Slave does not support XDP\n");
+			res = -EOPNOTSUPP;
+			goto err_sysfs_del;
+		}
+		res = slave_dev->netdev_ops->ndo_bpf(slave_dev, &xdp);
+		if (res < 0) {
+			/* ndo_bpf() sets extack error message */
+			slave_dbg(bond_dev, slave_dev, "Error %d calling ndo_bpf\n", res);
+			goto err_sysfs_del;
+		}
+		bpf_prog_inc(bond->xdp_prog);
+	}
 
 	slave_info(bond_dev, slave_dev, "Enslaving as %s interface with %s link\n",
 		   bond_is_active_slave(new_slave) ? "an active" : "a backup",
@@ -2121,6 +2156,17 @@ static int __bond_release_one(struct net_device *bond_dev,
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
@@ -3479,55 +3525,80 @@ static struct notifier_block bond_netdev_notifier = {
 
 /*---------------------------- Hashing Policies -----------------------------*/
 
+/* Helper to access data in a packet, with or without a backing skb.
+ * If skb is given the data is linearized if necessary via pskb_may_pull.
+ */
+static inline const void *bond_pull_data(struct sk_buff *skb,
+					 const void *data, int hlen, int n)
+{
+	if (likely(n <= hlen))
+		return data;
+	else if (skb && likely(pskb_may_pull(skb, n)))
+		return skb->head;
+
+	return NULL;
+}
+
 /* L2 hash helper */
-static inline u32 bond_eth_hash(struct sk_buff *skb)
+static inline u32 bond_eth_hash(struct sk_buff *skb, const void *data, int mhoff, int hlen)
 {
-	struct ethhdr *ep, hdr_tmp;
+	struct ethhdr *ep;
 
-	ep = skb_header_pointer(skb, 0, sizeof(hdr_tmp), &hdr_tmp);
-	if (ep)
-		return ep->h_dest[5] ^ ep->h_source[5] ^ ep->h_proto;
-	return 0;
+	data = bond_pull_data(skb, data, hlen, mhoff + sizeof(struct ethhdr));
+	if (!data)
+		return 0;
+
+	ep = (struct ethhdr *)(data + mhoff);
+	return ep->h_dest[5] ^ ep->h_source[5] ^ ep->h_proto;
 }
 
-static bool bond_flow_ip(struct sk_buff *skb, struct flow_keys *fk,
-			 int *noff, int *proto, bool l34)
+static bool bond_flow_ip(struct sk_buff *skb, struct flow_keys *fk, const void *data,
+			 int hlen, int l2_proto, int *nhoff, int *ip_proto, bool l34)
 {
 	const struct ipv6hdr *iph6;
 	const struct iphdr *iph;
 
-	if (skb->protocol == htons(ETH_P_IP)) {
-		if (unlikely(!pskb_may_pull(skb, *noff + sizeof(*iph))))
+	if (l2_proto == htons(ETH_P_IP)) {
+		data = bond_pull_data(skb, data, hlen, *nhoff + sizeof(*iph));
+		if (!data)
 			return false;
-		iph = (const struct iphdr *)(skb->data + *noff);
+
+		iph = (const struct iphdr *)(data + *nhoff);
 		iph_to_flow_copy_v4addrs(fk, iph);
-		*noff += iph->ihl << 2;
+		*nhoff += iph->ihl << 2;
 		if (!ip_is_fragment(iph))
-			*proto = iph->protocol;
-	} else if (skb->protocol == htons(ETH_P_IPV6)) {
-		if (unlikely(!pskb_may_pull(skb, *noff + sizeof(*iph6))))
+			*ip_proto = iph->protocol;
+	} else if (l2_proto == htons(ETH_P_IPV6)) {
+		data = bond_pull_data(skb, data, hlen, *nhoff + sizeof(*iph6));
+		if (!data)
 			return false;
-		iph6 = (const struct ipv6hdr *)(skb->data + *noff);
+
+		iph6 = (const struct ipv6hdr *)(data + *nhoff);
 		iph_to_flow_copy_v6addrs(fk, iph6);
-		*noff += sizeof(*iph6);
-		*proto = iph6->nexthdr;
+		*nhoff += sizeof(*iph6);
+		*ip_proto = iph6->nexthdr;
 	} else {
 		return false;
 	}
 
-	if (l34 && *proto >= 0)
-		fk->ports.ports = skb_flow_get_ports(skb, *noff, *proto);
+	if (l34 && *ip_proto >= 0)
+		fk->ports.ports = __skb_flow_get_ports(skb, *nhoff, *ip_proto, data, hlen);
 
 	return true;
 }
 
-static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
+static u32 bond_vlan_srcmac_hash(struct sk_buff *skb, const void *data, int mhoff, int hlen)
 {
-	struct ethhdr *mac_hdr = (struct ethhdr *)skb_mac_header(skb);
+	struct ethhdr *mac_hdr;
 	u32 srcmac_vendor = 0, srcmac_dev = 0;
 	u16 vlan;
 	int i;
 
+	data = bond_pull_data(skb, data, hlen, mhoff + sizeof(struct ethhdr));
+	if (!data)
+		return 0;
+	mac_hdr = (struct ethhdr *)(data + mhoff);
+
 	for (i = 0; i < 3; i++)
 		srcmac_vendor = (srcmac_vendor << 8) | mac_hdr->h_source[i];
 
@@ -3543,26 +3614,30 @@ static u32 bond_vlan_srcmac_hash(struct sk_buff *skb)
 }
 
 /* Extract the appropriate headers based on bond's xmit policy */
-static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb,
+static bool bond_flow_dissect(struct bonding *bond,
+			      struct sk_buff *skb,
+			      const void *data,
+			      __be16 l2_proto,
+			      int nhoff,
+			      int hlen,
 			      struct flow_keys *fk)
 {
 	bool l34 = bond->params.xmit_policy == BOND_XMIT_POLICY_LAYER34;
-	int noff, proto = -1;
+	int ip_proto = -1;
 
 	switch (bond->params.xmit_policy) {
 	case BOND_XMIT_POLICY_ENCAP23:
 	case BOND_XMIT_POLICY_ENCAP34:
 		memset(fk, 0, sizeof(*fk));
 		return __skb_flow_dissect(NULL, skb, &flow_keys_bonding,
-					  fk, NULL, 0, 0, 0, 0);
+					  fk, data, l2_proto, nhoff, hlen, 0);
 	default:
 		break;
 	}
 
 	fk->ports.ports = 0;
 	memset(&fk->icmp, 0, sizeof(fk->icmp));
-	noff = skb_network_offset(skb);
-	if (!bond_flow_ip(skb, fk, &noff, &proto, l34))
+	if (!bond_flow_ip(skb, fk, data, hlen, l2_proto, &nhoff, &ip_proto, l34))
 		return false;
 
 	/* ICMP error packets contains at least 8 bytes of the header
@@ -3570,22 +3645,20 @@ static bool bond_flow_dissect(struct bonding *bond, struct sk_buff *skb,
 	 * to correlate ICMP error packets within the same flow which
 	 * generated the error.
 	 */
-	if (proto == IPPROTO_ICMP || proto == IPPROTO_ICMPV6) {
-		skb_flow_get_icmp_tci(skb, &fk->icmp, skb->data,
-				      skb_transport_offset(skb),
-				      skb_headlen(skb));
-		if (proto == IPPROTO_ICMP) {
+	if (ip_proto == IPPROTO_ICMP || ip_proto == IPPROTO_ICMPV6) {
+		skb_flow_get_icmp_tci(skb, &fk->icmp, data, nhoff, hlen);
+		if (ip_proto == IPPROTO_ICMP) {
 			if (!icmp_is_err(fk->icmp.type))
 				return true;
 
-			noff += sizeof(struct icmphdr);
-		} else if (proto == IPPROTO_ICMPV6) {
+			nhoff += sizeof(struct icmphdr);
+		} else if (ip_proto == IPPROTO_ICMPV6) {
 			if (!icmpv6_is_err(fk->icmp.type))
 				return true;
 
-			noff += sizeof(struct icmp6hdr);
+			nhoff += sizeof(struct icmp6hdr);
 		}
-		return bond_flow_ip(skb, fk, &noff, &proto, l34);
+		return bond_flow_ip(skb, fk, data, hlen, l2_proto, &nhoff, &ip_proto, l34);
 	}
 
 	return true;
@@ -3601,33 +3674,30 @@ static u32 bond_ip_hash(u32 hash, struct flow_keys *flow)
 	return hash >> 1;
 }
 
-/**
- * bond_xmit_hash - generate a hash value based on the xmit policy
- * @bond: bonding device
- * @skb: buffer to use for headers
- *
- * This function will extract the necessary headers from the skb buffer and use
- * them to generate a hash based on the xmit_policy set in the bonding device
+/* Generate hash based on xmit policy. If @skb is given it is used to linearize
+ * the data as required, but this function can be used without it.
  */
-u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
+static u32 __bond_xmit_hash(struct bonding *bond,
+			    struct sk_buff *skb,
+			    const void *data,
+			    __be16 l2_proto,
+			    int mhoff,
+			    int nhoff,
+			    int hlen)
 {
 	struct flow_keys flow;
 	u32 hash;
 
-	if (bond->params.xmit_policy == BOND_XMIT_POLICY_ENCAP34 &&
-	    skb->l4_hash)
-		return skb->hash;
-
 	if (bond->params.xmit_policy == BOND_XMIT_POLICY_VLAN_SRCMAC)
-		return bond_vlan_srcmac_hash(skb);
+		return bond_vlan_srcmac_hash(skb, data, mhoff, hlen);
 
 	if (bond->params.xmit_policy == BOND_XMIT_POLICY_LAYER2 ||
-	    !bond_flow_dissect(bond, skb, &flow))
-		return bond_eth_hash(skb);
+	    !bond_flow_dissect(bond, skb, data, l2_proto, nhoff, hlen, &flow))
+		return bond_eth_hash(skb, data, mhoff, hlen);
 
 	if (bond->params.xmit_policy == BOND_XMIT_POLICY_LAYER23 ||
 	    bond->params.xmit_policy == BOND_XMIT_POLICY_ENCAP23) {
-		hash = bond_eth_hash(skb);
+		hash = bond_eth_hash(skb, data, mhoff, hlen);
 	} else {
 		if (flow.icmp.id)
 			memcpy(&hash, &flow.icmp, sizeof(hash));
@@ -3638,6 +3708,48 @@ u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
 	return bond_ip_hash(hash, &flow);
 }
 
+/**
+ * bond_xmit_hash_skb - generate a hash value based on the xmit policy
+ * @bond: bonding device
+ * @skb: buffer to use for headers
+ *
+ * This function will extract the necessary headers from the skb buffer and use
+ * them to generate a hash based on the xmit_policy set in the bonding device
+ */
+u32 bond_xmit_hash(struct bonding *bond, struct sk_buff *skb)
+{
+	if (bond->params.xmit_policy == BOND_XMIT_POLICY_ENCAP34 &&
+	    skb->l4_hash)
+		return skb->hash;
+
+	return __bond_xmit_hash(bond, skb, skb->head, skb->protocol,
+				skb->mac_header,
+				skb->network_header,
+				skb_headlen(skb));
+}
+
+/**
+ * bond_xmit_hash_xdp - generate a hash value based on the xmit policy
+ * @bond: bonding device
+ * @xdp: buffer to use for headers
+ *
+ * XDP variant of bond_xmit_hash.
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
+	return __bond_xmit_hash(bond, NULL, xdp->data, eth->h_proto,
+				0,
+				sizeof(struct ethhdr),
+				xdp->data_end - xdp->data);
+}
+
 /*-------------------------- Device entry points ----------------------------*/
 
 void bond_work_init_all(struct bonding *bond)
@@ -4254,6 +4366,47 @@ static struct slave *bond_xmit_roundrobin_slave_get(struct bonding *bond,
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
@@ -4267,8 +4420,7 @@ static netdev_tx_t bond_xmit_roundrobin(struct sk_buff *skb,
 	return bond_tx_drop(bond_dev, skb);
 }
 
-static struct slave *bond_xmit_activebackup_slave_get(struct bonding *bond,
-						      struct sk_buff *skb)
+static struct slave *bond_xmit_activebackup_slave_get(struct bonding *bond)
 {
 	return rcu_dereference(bond->curr_active_slave);
 }
@@ -4282,7 +4434,7 @@ static netdev_tx_t bond_xmit_activebackup(struct sk_buff *skb,
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave;
 
-	slave = bond_xmit_activebackup_slave_get(bond, skb);
+	slave = bond_xmit_activebackup_slave_get(bond);
 	if (slave)
 		return bond_dev_queue_xmit(bond, skb, slave->dev);
 
@@ -4470,6 +4622,22 @@ static struct slave *bond_xmit_3ad_xor_slave_get(struct bonding *bond,
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
+	slaves = bond->usable_slaves;
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
@@ -4580,7 +4748,7 @@ static struct net_device *bond_xmit_get_slave(struct net_device *master_dev,
 		slave = bond_xmit_roundrobin_slave_get(bond, skb);
 		break;
 	case BOND_MODE_ACTIVEBACKUP:
-		slave = bond_xmit_activebackup_slave_get(bond, skb);
+		slave = bond_xmit_activebackup_slave_get(bond);
 		break;
 	case BOND_MODE_8023AD:
 	case BOND_MODE_XOR:
@@ -4754,6 +4922,164 @@ static netdev_tx_t bond_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return ret;
 }
 
+struct net_device *
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
+		static_branch_inc(&bpf_bond_redirect_enabled_key);
+	else
+		static_branch_dec(&bpf_bond_redirect_enabled_key);
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
@@ -4840,6 +5166,9 @@ static const struct net_device_ops bond_netdev_ops = {
 	.ndo_features_check	= passthru_features_check,
 	.ndo_get_xmit_slave	= bond_xmit_get_slave,
 	.ndo_sk_get_lower_dev	= bond_sk_get_lower_dev,
+	.ndo_bpf		= bond_xdp,
+	.ndo_xdp_xmit           = bond_xdp_xmit,
+	.ndo_xdp_get_xmit_slave = bond_xdp_get_xmit_slave,
 };
 
 static const struct device_type bond_type = {
diff --git a/include/linux/filter.h b/include/linux/filter.h
index c5ad7df029ed..57c166089456 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -760,6 +760,10 @@ static inline u32 bpf_prog_run_clear_cb(const struct bpf_prog *prog,
 
 DECLARE_BPF_DISPATCHER(xdp)
 
+DECLARE_STATIC_KEY_FALSE(bpf_bond_redirect_enabled_key);
+
+u32 xdp_bond_redirect(struct xdp_buff *xdp);
+
 static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
 					    struct xdp_buff *xdp)
 {
@@ -769,7 +773,14 @@ static __always_inline u32 bpf_prog_run_xdp(const struct bpf_prog *prog,
 	 * already takes rcu_read_lock() when fetching the program, so
 	 * it's not necessary here anymore.
 	 */
-	return __BPF_PROG_RUN(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
+	u32 act = __BPF_PROG_RUN(prog, xdp, BPF_DISPATCHER_FUNC(xdp));
+
+	if (static_branch_unlikely(&bpf_bond_redirect_enabled_key)) {
+		if (act == XDP_TX && netif_is_bond_slave(xdp->rxq->dev))
+			act = xdp_bond_redirect(xdp);
+	}
+
+	return act;
 }
 
 void bpf_prog_change_xdp(struct bpf_prog *prev_prog, struct bpf_prog *prog);
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5cbc950b34df..1a6cc6356498 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1321,6 +1321,9 @@ struct netdev_net_notifier {
  *	that got dropped are freed/returned via xdp_return_frame().
  *	Returns negative number, means general error invoking ndo, meaning
  *	no frames were xmit'ed and core-caller will free all frames.
+ * struct net_device *(*ndo_xdp_get_xmit_slave)(struct net_device *dev,
+ *					        struct xdp_buff *xdp);
+ *      Get the xmit slave of master device based on the xdp_buff.
  * int (*ndo_xsk_wakeup)(struct net_device *dev, u32 queue_id, u32 flags);
  *      This function is used to wake up the softirq, ksoftirqd or kthread
  *	responsible for sending and/or receiving packets on a specific
@@ -1539,6 +1542,8 @@ struct net_device_ops {
 	int			(*ndo_xdp_xmit)(struct net_device *dev, int n,
 						struct xdp_frame **xdp,
 						u32 flags);
+	struct net_device *	(*ndo_xdp_get_xmit_slave)(struct net_device *dev,
+							  struct xdp_buff *xdp);
 	int			(*ndo_xsk_wakeup)(struct net_device *dev,
 						  u32 queue_id, u32 flags);
 	struct devlink_port *	(*ndo_get_devlink_port)(struct net_device *dev);
diff --git a/include/net/bonding.h b/include/net/bonding.h
index 019e998d944a..34acb81b4234 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -251,6 +251,7 @@ struct bonding {
 #ifdef CONFIG_XFRM_OFFLOAD
 	struct xfrm_state *xs;
 #endif /* CONFIG_XFRM_OFFLOAD */
+	struct bpf_prog *xdp_prog;
 };
 
 #define bond_slave_get_rcu(dev) \
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 2a75e6c2d27d..2caff5714f4d 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -514,9 +514,11 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 }
 
 static bool is_valid_dst(struct bpf_dtab_netdev *obj, struct xdp_buff *xdp,
-			 int exclude_ifindex)
+			 int exclude_ifindex, int exclude_ifindex_master)
 {
-	if (!obj || obj->dev->ifindex == exclude_ifindex ||
+	if (!obj ||
+	    obj->dev->ifindex == exclude_ifindex ||
+	    obj->dev->ifindex == exclude_ifindex_master ||
 	    !obj->dev->netdev_ops->ndo_xdp_xmit)
 		return false;
 
@@ -546,12 +548,19 @@ int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	int exclude_ifindex = exclude_ingress ? dev_rx->ifindex : 0;
+	int exclude_ifindex_master = 0;
 	struct bpf_dtab_netdev *dst, *last_dst = NULL;
 	struct hlist_head *head;
 	struct xdp_frame *xdpf;
 	unsigned int i;
 	int err;
 
+	if (static_branch_unlikely(&bpf_bond_redirect_enabled_key)) {
+		struct net_device *master = netdev_master_upper_dev_get_rcu(dev_rx);
+
+		exclude_ifindex_master = (master && exclude_ingress) ? master->ifindex : 0;
+	}
+
 	xdpf = xdp_convert_buff_to_frame(xdp);
 	if (unlikely(!xdpf))
 		return -EOVERFLOW;
@@ -559,7 +568,7 @@ int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
 	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
 		for (i = 0; i < map->max_entries; i++) {
 			dst = READ_ONCE(dtab->netdev_map[i]);
-			if (!is_valid_dst(dst, xdp, exclude_ifindex))
+			if (!is_valid_dst(dst, xdp, exclude_ifindex, exclude_ifindex_master))
 				continue;
 
 			/* we only need n-1 clones; last_dst enqueued below */
@@ -579,7 +588,9 @@ int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
 			head = dev_map_index_hash(dtab, i);
 			hlist_for_each_entry_rcu(dst, head, index_hlist,
 						 lockdep_is_held(&dtab->index_lock)) {
-				if (!is_valid_dst(dst, xdp, exclude_ifindex))
+				if (!is_valid_dst(dst, xdp,
+						  exclude_ifindex,
+						  exclude_ifindex_master))
 					continue;
 
 				/* we only need n-1 clones; last_dst enqueued below */
@@ -646,16 +657,25 @@ int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	int exclude_ifindex = exclude_ingress ? dev->ifindex : 0;
+	int exclude_ifindex_master = 0;
 	struct bpf_dtab_netdev *dst, *last_dst = NULL;
 	struct hlist_head *head;
 	struct hlist_node *next;
 	unsigned int i;
 	int err;
 
+	if (static_branch_unlikely(&bpf_bond_redirect_enabled_key)) {
+		struct net_device *master = netdev_master_upper_dev_get_rcu(dev);
+
+		exclude_ifindex_master = (master && exclude_ingress) ? master->ifindex : 0;
+	}
+
 	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
 		for (i = 0; i < map->max_entries; i++) {
 			dst = READ_ONCE(dtab->netdev_map[i]);
-			if (!dst || dst->dev->ifindex == exclude_ifindex)
+			if (!dst ||
+			    dst->dev->ifindex == exclude_ifindex ||
+			    dst->dev->ifindex == exclude_ifindex_master)
 				continue;
 
 			/* we only need n-1 clones; last_dst enqueued below */
@@ -674,7 +694,9 @@ int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
 		for (i = 0; i < dtab->n_buckets; i++) {
 			head = dev_map_index_hash(dtab, i);
 			hlist_for_each_entry_safe(dst, next, head, index_hlist) {
-				if (!dst || dst->dev->ifindex == exclude_ifindex)
+				if (!dst ||
+				    dst->dev->ifindex == exclude_ifindex ||
+				    dst->dev->ifindex == exclude_ifindex_master)
 					continue;
 
 				/* we only need n-1 clones; last_dst enqueued below */
diff --git a/net/core/filter.c b/net/core/filter.c
index caa88955562e..5d268eb980e7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2469,6 +2469,7 @@ int skb_do_redirect(struct sk_buff *skb)
 	ri->flags = 0;
 	if (unlikely(!dev))
 		goto out_drop;
+
 	if (flags & BPF_F_PEER) {
 		const struct net_device_ops *ops = dev->netdev_ops;
 
@@ -3947,6 +3948,40 @@ void bpf_clear_redirect_map(struct bpf_map *map)
 	}
 }
 
+DEFINE_STATIC_KEY_FALSE(bpf_bond_redirect_enabled_key);
+EXPORT_SYMBOL_GPL(bpf_bond_redirect_enabled_key);
+INDIRECT_CALLABLE_DECLARE(struct net_device *
+	bond_xdp_get_xmit_slave(struct net_device *bond_dev, struct xdp_buff *xdp));
+
+u32 xdp_bond_redirect(struct xdp_buff *xdp)
+{
+	struct net_device *master, *slave;
+	struct bpf_redirect_info *ri = this_cpu_ptr(&bpf_redirect_info);
+
+	master = netdev_master_upper_dev_get_rcu(xdp->rxq->dev);
+
+#if IS_BUILTIN(CONFIG_BONDING)
+	slave = INDIRECT_CALL_1(master->netdev_ops->ndo_xdp_get_xmit_slave,
+				bond_xdp_get_xmit_slave,
+				master, xdp);
+#else
+	slave = master->netdev_ops->ndo_xdp_get_xmit_slave(master, xdp);
+#endif
+	if (slave && slave != xdp->rxq->dev) {
+		/* The target device is different from the receiving device, so
+		 * redirect it to the new device.
+		 * Using XDP_REDIRECT gets the correct behaviour from XDP enabled
+		 * drivers to unmap the packet from their rx ring.
+		 */
+		ri->tgt_index = slave->ifindex;
+		ri->map_id = INT_MAX;
+		ri->map_type = BPF_MAP_TYPE_UNSPEC;
+		return XDP_REDIRECT;
+	}
+	return XDP_TX;
+}
+EXPORT_SYMBOL_GPL(xdp_bond_redirect);
+
 int xdp_do_redirect(struct net_device *dev, struct xdp_buff *xdp,
 		    struct bpf_prog *xdp_prog)
 {
@@ -4466,7 +4501,7 @@ static const struct bpf_func_proto bpf_skb_cgroup_id_proto = {
 };
 
 static inline u64 __bpf_sk_ancestor_cgroup_id(struct sock *sk,
-					      int ancestor_level)
+					     int ancestor_level)
 {
 	struct cgroup *ancestor;
 	struct cgroup *cgrp;
-- 
2.30.2

