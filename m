Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33421DBCBC
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 20:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbgETSXY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 14:23:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726936AbgETSXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 14:23:20 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E49E9C061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 11:23:19 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ci21so1706301pjb.3
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 11:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WuhxVaagttplMc/DzDLk4pJTDywwulAMlmWcV3bxYZs=;
        b=NHuSPkForgjKqeKcE3nVcRIvIRZDLbv4E/cE/KGwgG9IdesX/mfWIPK8NI7OF5emJE
         b7pSS1UdDaZjMTCoI3097YZOEX41/HxGKTAErYwECN8JhGbxehF68Tu4yDkWD0goY3Iy
         sQN2HvVx7f/O946kZU19KmlfJrjMQ2AhtPp4c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WuhxVaagttplMc/DzDLk4pJTDywwulAMlmWcV3bxYZs=;
        b=pgvlLnza9X5P0jyTChil83rApaM6uuTCPVotYr7jnsjQ27vqRhGVnimuE1gDGLr3Jq
         H6ceg9SY4H3d1aVcfX5QilILKPiR8XiJ6tQxISglfqI98ZMgDEbS/ToWCRM1+pA8jK8+
         HM7S86Q977GxQtWm8mmIPf21XmXx6Xv5Z7LVqEdvAOhJISzwmF3x+1yeVSh7pQz7gM1i
         4ljZzeTtYDiPTgLOkCAF4BR80nrFs4vrSsEUDFKG9oqzCv4WlOnr72gHwEqY4Ht2iKKZ
         DDCfYL/nIWnXVoKRruDQ1rZHxmxMJ2ac9jy4ll1FbKWyIXJu+LaLKUBBbQ61LwjM1Es/
         TXXA==
X-Gm-Message-State: AOAM5315nh5i0/wO4Ftp1vIoJlR5H/7QY3B0IANTnYNalvPIQqh3r5rz
        d8xUpnuOhDmJfGLJUC9v2kSocg==
X-Google-Smtp-Source: ABdhPJx2vVz2Go0HE+qNAhFt+eTHYPWV+NClcPfUX8CPCs71BK+3Qlz7UUd1YG6qlw9+GiaGY7e5Ew==
X-Received: by 2002:a17:90b:23d4:: with SMTP id md20mr7279680pjb.164.1589998999284;
        Wed, 20 May 2020 11:23:19 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id d184sm2490238pfc.130.2020.05.20.11.23.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 May 2020 11:23:18 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     dsahern@gmail.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
Subject: [PATCH net-next v3 2/5] vxlan: ecmp support for mac fdb entries
Date:   Wed, 20 May 2020 11:23:08 -0700
Message-Id: <1589998991-40120-3-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1589998991-40120-1-git-send-email-roopa@cumulusnetworks.com>
References: <1589998991-40120-1-git-send-email-roopa@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

Todays vxlan mac fdb entries can point to multiple remote
ips (rdsts) with the sole purpose of replicating
broadcast-multicast and unknown unicast packets to those remote ips.

E-VPN multihoming [1,2,3] requires bridged vxlan traffic to be
load balanced to remote switches (vteps) belonging to the
same multi-homed ethernet segment (E-VPN multihoming is analogous
to multi-homed LAG implementations, but with the inter-switch
peerlink replaced with a vxlan tunnel). In other words it needs
support for mac ecmp. Furthermore, for faster convergence, E-VPN
multihoming needs the ability to update fdb ecmp nexthops independent
of the fdb entries.

New route nexthop API is perfect for this usecase.
This patch extends the vxlan fdb code to take a nexthop id
pointing to an ecmp nexthop group.

Changes include:
- New NDA_NH_ID attribute for fdbs
- Use the newly added fdb nexthop groups
- makes vxlan rdsts and nexthop handling code mutually
  exclusive
- since this is a new use-case and the requirement is for ecmp
nexthop groups, the fdb add and update path checks that the
nexthop is really an ecmp nexthop group. This check can be relaxed
in the future, if we want to introduce replication fdb nexthop groups
and allow its use in lieu of current rdst lists.
- fdb update requests with nexthop id's only allowed for existing
fdb's that have nexthop id's
- learning will not override an existing fdb entry with nexthop
group
- I have wrapped the switchdev offload code around the presence of
rdst

[1] E-VPN RFC https://tools.ietf.org/html/rfc7432
[2] E-VPN with vxlan https://tools.ietf.org/html/rfc8365
[3] http://vger.kernel.org/lpc_net2018_talks/scaling_bridge_fdb_database_slidesV3.pdf

Includes a null check fix in vxlan_xmit from Nikolay

v2 - Fixed build issue:
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
 drivers/net/vxlan.c            | 301 +++++++++++++++++++++++++++++++++--------
 include/net/vxlan.h            |  25 ++++
 include/uapi/linux/neighbour.h |   1 +
 net/core/neighbour.c           |   2 +
 4 files changed, 270 insertions(+), 59 deletions(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index a5b415f..380d887 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -26,6 +26,7 @@
 #include <net/netns/generic.h>
 #include <net/tun_proto.h>
 #include <net/vxlan.h>
+#include <net/nexthop.h>
 
 #if IS_ENABLED(CONFIG_IPV6)
 #include <net/ip6_tunnel.h>
@@ -78,6 +79,8 @@ struct vxlan_fdb {
 	u16		  state;	/* see ndm_state */
 	__be32		  vni;
 	u16		  flags;	/* see ndm_flags and below */
+	struct list_head  nh_list;
+	struct nexthop __rcu *nh;
 };
 
 #define NTF_VXLAN_ADDED_BY_USER 0x100
@@ -174,11 +177,15 @@ static inline struct hlist_head *vs_head(struct net *net, __be16 port)
  */
 static inline struct vxlan_rdst *first_remote_rcu(struct vxlan_fdb *fdb)
 {
+	if (rcu_access_pointer(fdb->nh))
+		return NULL;
 	return list_entry_rcu(fdb->remotes.next, struct vxlan_rdst, list);
 }
 
 static inline struct vxlan_rdst *first_remote_rtnl(struct vxlan_fdb *fdb)
 {
+	if (rcu_access_pointer(fdb->nh))
+		return NULL;
 	return list_first_entry(&fdb->remotes, struct vxlan_rdst, list);
 }
 
@@ -251,9 +258,10 @@ static int vxlan_fdb_info(struct sk_buff *skb, struct vxlan_dev *vxlan,
 {
 	unsigned long now = jiffies;
 	struct nda_cacheinfo ci;
+	bool send_ip, send_eth;
 	struct nlmsghdr *nlh;
+	struct nexthop *nh;
 	struct ndmsg *ndm;
-	bool send_ip, send_eth;
 
 	nlh = nlmsg_put(skb, portid, seq, type, sizeof(*ndm), flags);
 	if (nlh == NULL)
@@ -264,16 +272,21 @@ static int vxlan_fdb_info(struct sk_buff *skb, struct vxlan_dev *vxlan,
 
 	send_eth = send_ip = true;
 
+	nh = rcu_dereference_rtnl(fdb->nh);
 	if (type == RTM_GETNEIGH) {
-		send_ip = !vxlan_addr_any(&rdst->remote_ip);
+		if (rdst) {
+			send_ip = !vxlan_addr_any(&rdst->remote_ip);
+			ndm->ndm_family = send_ip ? rdst->remote_ip.sa.sa_family : AF_INET;
+		} else if (nh) {
+			ndm->ndm_family = nexthop_get_family(nh);
+		}
 		send_eth = !is_zero_ether_addr(fdb->eth_addr);
-		ndm->ndm_family = send_ip ? rdst->remote_ip.sa.sa_family : AF_INET;
 	} else
 		ndm->ndm_family	= AF_BRIDGE;
 	ndm->ndm_state = fdb->state;
 	ndm->ndm_ifindex = vxlan->dev->ifindex;
 	ndm->ndm_flags = fdb->flags;
-	if (rdst->offloaded)
+	if (rdst && rdst->offloaded)
 		ndm->ndm_flags |= NTF_OFFLOADED;
 	ndm->ndm_type = RTN_UNICAST;
 
@@ -284,23 +297,30 @@ static int vxlan_fdb_info(struct sk_buff *skb, struct vxlan_dev *vxlan,
 
 	if (send_eth && nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->eth_addr))
 		goto nla_put_failure;
+	if (nh) {
+		if (nla_put_u32(skb, NDA_NH_ID, nh->id))
+			goto nla_put_failure;
+	} else if (rdst) {
+		if (send_ip && vxlan_nla_put_addr(skb, NDA_DST,
+						  &rdst->remote_ip))
+			goto nla_put_failure;
+
+		if (rdst->remote_port &&
+		    rdst->remote_port != vxlan->cfg.dst_port &&
+		    nla_put_be16(skb, NDA_PORT, rdst->remote_port))
+			goto nla_put_failure;
+		if (rdst->remote_vni != vxlan->default_dst.remote_vni &&
+		    nla_put_u32(skb, NDA_VNI, be32_to_cpu(rdst->remote_vni)))
+			goto nla_put_failure;
+		if (rdst->remote_ifindex &&
+		    nla_put_u32(skb, NDA_IFINDEX, rdst->remote_ifindex))
+			goto nla_put_failure;
+	}
 
-	if (send_ip && vxlan_nla_put_addr(skb, NDA_DST, &rdst->remote_ip))
-		goto nla_put_failure;
-
-	if (rdst->remote_port && rdst->remote_port != vxlan->cfg.dst_port &&
-	    nla_put_be16(skb, NDA_PORT, rdst->remote_port))
-		goto nla_put_failure;
-	if (rdst->remote_vni != vxlan->default_dst.remote_vni &&
-	    nla_put_u32(skb, NDA_VNI, be32_to_cpu(rdst->remote_vni)))
-		goto nla_put_failure;
 	if ((vxlan->cfg.flags & VXLAN_F_COLLECT_METADATA) && fdb->vni &&
 	    nla_put_u32(skb, NDA_SRC_VNI,
 			be32_to_cpu(fdb->vni)))
 		goto nla_put_failure;
-	if (rdst->remote_ifindex &&
-	    nla_put_u32(skb, NDA_IFINDEX, rdst->remote_ifindex))
-		goto nla_put_failure;
 
 	ci.ndm_used	 = jiffies_to_clock_t(now - fdb->used);
 	ci.ndm_confirmed = 0;
@@ -401,7 +421,7 @@ static int vxlan_fdb_notify(struct vxlan_dev *vxlan, struct vxlan_fdb *fdb,
 {
 	int err;
 
-	if (swdev_notify) {
+	if (swdev_notify && rd) {
 		switch (type) {
 		case RTM_NEWNEIGH:
 			err = vxlan_fdb_switchdev_call_notifiers(vxlan, fdb, rd,
@@ -805,6 +825,8 @@ static struct vxlan_fdb *vxlan_fdb_alloc(const u8 *mac, __u16 state,
 	f->flags = ndm_flags;
 	f->updated = f->used = jiffies;
 	f->vni = src_vni;
+	f->nh = NULL;
+	INIT_LIST_HEAD(&f->nh_list);
 	INIT_LIST_HEAD(&f->remotes);
 	memcpy(f->eth_addr, mac, ETH_ALEN);
 
@@ -819,11 +841,78 @@ static void vxlan_fdb_insert(struct vxlan_dev *vxlan, const u8 *mac,
 			   vxlan_fdb_head(vxlan, mac, src_vni));
 }
 
+static int vxlan_fdb_nh_update(struct vxlan_dev *vxlan, struct vxlan_fdb *fdb,
+			       u32 nhid, struct netlink_ext_ack *extack)
+{
+	struct nexthop *old_nh = rtnl_dereference(fdb->nh);
+	struct nh_group *nhg;
+	struct nexthop *nh;
+	int err = -EINVAL;
+
+	if (old_nh && old_nh->id == nhid)
+		return 0;
+
+	nh = nexthop_find_by_id(vxlan->net, nhid);
+	if (!nh) {
+		NL_SET_ERR_MSG(extack, "Nexthop id does not exist");
+		goto err_inval;
+	}
+
+	if (nh) {
+		if (!nexthop_get(nh)) {
+			NL_SET_ERR_MSG(extack, "Nexthop has been deleted");
+			nh = NULL;
+			goto err_inval;
+		}
+		if (!nh->is_fdb_nh) {
+			NL_SET_ERR_MSG(extack, "Nexthop is not a fdb nexthop");
+			goto err_inval;
+		}
+
+		if (!nh->is_group || !nh->nh_grp->mpath) {
+			NL_SET_ERR_MSG(extack, "Nexthop is not a multipath group");
+			goto err_inval;
+		}
+
+		/* check nexthop group family */
+		nhg = rtnl_dereference(nh->nh_grp);
+		switch (vxlan->default_dst.remote_ip.sa.sa_family) {
+		case AF_INET:
+			if (!nhg->has_v4) {
+				err = -EAFNOSUPPORT;
+				NL_SET_ERR_MSG(extack, "Nexthop group family not supported");
+				goto err_inval;
+			}
+			break;
+		case AF_INET6:
+			if (nhg->has_v4) {
+				err = -EAFNOSUPPORT;
+				NL_SET_ERR_MSG(extack, "Nexthop group family not supported");
+				goto err_inval;
+			}
+		}
+	}
+
+	if (old_nh) {
+		list_del_rcu(&fdb->nh_list);
+		nexthop_put(old_nh);
+	}
+	rcu_assign_pointer(fdb->nh, nh);
+	list_add_tail_rcu(&fdb->nh_list, &nh->fdb_list);
+	return 1;
+
+err_inval:
+	if (nh)
+		nexthop_put(nh);
+	return err;
+}
+
 static int vxlan_fdb_create(struct vxlan_dev *vxlan,
 			    const u8 *mac, union vxlan_addr *ip,
 			    __u16 state, __be16 port, __be32 src_vni,
 			    __be32 vni, __u32 ifindex, __u16 ndm_flags,
-			    struct vxlan_fdb **fdb)
+			    u32 nhid, struct vxlan_fdb **fdb,
+			    struct netlink_ext_ack *extack)
 {
 	struct vxlan_rdst *rd = NULL;
 	struct vxlan_fdb *f;
@@ -838,20 +927,33 @@ static int vxlan_fdb_create(struct vxlan_dev *vxlan,
 	if (!f)
 		return -ENOMEM;
 
-	rc = vxlan_fdb_append(f, ip, port, vni, ifindex, &rd);
-	if (rc < 0) {
-		kfree(f);
-		return rc;
-	}
+	if (nhid)
+		rc = vxlan_fdb_nh_update(vxlan, f, nhid, extack);
+	else
+		rc = vxlan_fdb_append(f, ip, port, vni, ifindex, &rd);
+	if (rc < 0)
+		goto errout;
 
 	*fdb = f;
 
 	return 0;
+
+errout:
+	kfree(f);
+	return rc;
 }
 
 static void __vxlan_fdb_free(struct vxlan_fdb *f)
 {
 	struct vxlan_rdst *rd, *nd;
+	struct nexthop *nh;
+
+	nh = rcu_dereference_raw(f->nh);
+	if (nh) {
+		rcu_assign_pointer(f->nh, NULL);
+		list_del_rcu(&f->nh_list);
+		nexthop_put(nh);
+	}
 
 	list_for_each_entry_safe(rd, nd, &f->remotes, list) {
 		dst_cache_destroy(&rd->dst_cache);
@@ -875,10 +977,15 @@ static void vxlan_fdb_destroy(struct vxlan_dev *vxlan, struct vxlan_fdb *f,
 	netdev_dbg(vxlan->dev, "delete %pM\n", f->eth_addr);
 
 	--vxlan->addrcnt;
-	if (do_notify)
-		list_for_each_entry(rd, &f->remotes, list)
-			vxlan_fdb_notify(vxlan, f, rd, RTM_DELNEIGH,
+	if (do_notify) {
+		if (rcu_access_pointer(f->nh))
+			vxlan_fdb_notify(vxlan, f, NULL, RTM_DELNEIGH,
 					 swdev_notify, NULL);
+		else
+			list_for_each_entry(rd, &f->remotes, list)
+				vxlan_fdb_notify(vxlan, f, rd, RTM_DELNEIGH,
+						 swdev_notify, NULL);
+	}
 
 	hlist_del_rcu(&f->hlist);
 	call_rcu(&f->rcu, vxlan_fdb_free);
@@ -897,7 +1004,7 @@ static int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
 				     __u16 state, __u16 flags,
 				     __be16 port, __be32 vni,
 				     __u32 ifindex, __u16 ndm_flags,
-				     struct vxlan_fdb *f,
+				     struct vxlan_fdb *f, u32 nhid,
 				     bool swdev_notify,
 				     struct netlink_ext_ack *extack)
 {
@@ -908,6 +1015,18 @@ static int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
 	int rc = 0;
 	int err;
 
+	if (nhid && !rcu_access_pointer(f->nh)) {
+		NL_SET_ERR_MSG(extack,
+			       "Cannot replace an existing non nexthop fdb with a nexthop");
+		return -EOPNOTSUPP;
+	}
+
+	if (nhid && (flags & NLM_F_APPEND)) {
+		NL_SET_ERR_MSG(extack,
+			       "Cannot append to a nexthop fdb");
+		return -EOPNOTSUPP;
+	}
+
 	/* Do not allow an externally learned entry to take over an entry added
 	 * by the user.
 	 */
@@ -929,10 +1048,18 @@ static int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
 		/* Only change unicasts */
 		if (!(is_multicast_ether_addr(f->eth_addr) ||
 		      is_zero_ether_addr(f->eth_addr))) {
-			rc = vxlan_fdb_replace(f, ip, port, vni,
-					       ifindex, &oldrd);
+			if (nhid) {
+				rc = vxlan_fdb_nh_update(vxlan, f, nhid, extack);
+				if (rc < 0)
+					return rc;
+			} else {
+				rc = vxlan_fdb_replace(f, ip, port, vni,
+						       ifindex, &oldrd);
+			}
 			notify |= rc;
 		} else {
+			NL_SET_ERR_MSG(extack,
+			       "Cannot replace non-unicast fdb entries");
 			return -EOPNOTSUPP;
 		}
 	}
@@ -962,6 +1089,8 @@ static int vxlan_fdb_update_existing(struct vxlan_dev *vxlan,
 	return 0;
 
 err_notify:
+	if (nhid)
+		return err;
 	if ((flags & NLM_F_REPLACE) && rc)
 		*rd = oldrd;
 	else if ((flags & NLM_F_APPEND) && rc) {
@@ -975,7 +1104,7 @@ static int vxlan_fdb_update_create(struct vxlan_dev *vxlan,
 				   const u8 *mac, union vxlan_addr *ip,
 				   __u16 state, __u16 flags,
 				   __be16 port, __be32 src_vni, __be32 vni,
-				   __u32 ifindex, __u16 ndm_flags,
+				   __u32 ifindex, __u16 ndm_flags, u32 nhid,
 				   bool swdev_notify,
 				   struct netlink_ext_ack *extack)
 {
@@ -990,7 +1119,7 @@ static int vxlan_fdb_update_create(struct vxlan_dev *vxlan,
 
 	netdev_dbg(vxlan->dev, "add %pM -> %pIS\n", mac, ip);
 	rc = vxlan_fdb_create(vxlan, mac, ip, state, port, src_vni,
-			      vni, ifindex, fdb_flags, &f);
+			      vni, ifindex, fdb_flags, nhid, &f, extack);
 	if (rc < 0)
 		return rc;
 
@@ -1012,7 +1141,7 @@ static int vxlan_fdb_update(struct vxlan_dev *vxlan,
 			    const u8 *mac, union vxlan_addr *ip,
 			    __u16 state, __u16 flags,
 			    __be16 port, __be32 src_vni, __be32 vni,
-			    __u32 ifindex, __u16 ndm_flags,
+			    __u32 ifindex, __u16 ndm_flags, u32 nhid,
 			    bool swdev_notify,
 			    struct netlink_ext_ack *extack)
 {
@@ -1028,14 +1157,15 @@ static int vxlan_fdb_update(struct vxlan_dev *vxlan,
 
 		return vxlan_fdb_update_existing(vxlan, ip, state, flags, port,
 						 vni, ifindex, ndm_flags, f,
-						 swdev_notify, extack);
+						 nhid, swdev_notify, extack);
 	} else {
 		if (!(flags & NLM_F_CREATE))
 			return -ENOENT;
 
 		return vxlan_fdb_update_create(vxlan, mac, ip, state, flags,
 					       port, src_vni, vni, ifindex,
-					       ndm_flags, swdev_notify, extack);
+					       ndm_flags, nhid, swdev_notify,
+					       extack);
 	}
 }
 
@@ -1049,7 +1179,7 @@ static void vxlan_fdb_dst_destroy(struct vxlan_dev *vxlan, struct vxlan_fdb *f,
 
 static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
 			   union vxlan_addr *ip, __be16 *port, __be32 *src_vni,
-			   __be32 *vni, u32 *ifindex)
+			   __be32 *vni, u32 *ifindex, u32 *nhid)
 {
 	struct net *net = dev_net(vxlan->dev);
 	int err;
@@ -1109,6 +1239,11 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
 		*ifindex = 0;
 	}
 
+	if (tb[NDA_NH_ID])
+		*nhid = nla_get_u32(tb[NDA_NH_ID]);
+	else
+		*nhid = 0;
+
 	return 0;
 }
 
@@ -1123,7 +1258,7 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 	union vxlan_addr ip;
 	__be16 port;
 	__be32 src_vni, vni;
-	u32 ifindex;
+	u32 ifindex, nhid;
 	u32 hash_index;
 	int err;
 
@@ -1133,10 +1268,11 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 		return -EINVAL;
 	}
 
-	if (tb[NDA_DST] == NULL)
+	if (!tb || (!tb[NDA_DST] && !tb[NDA_NH_ID]))
 		return -EINVAL;
 
-	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex);
+	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex,
+			      &nhid);
 	if (err)
 		return err;
 
@@ -1148,7 +1284,7 @@ static int vxlan_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
 	err = vxlan_fdb_update(vxlan, addr, &ip, ndm->ndm_state, flags,
 			       port, src_vni, vni, ifindex,
 			       ndm->ndm_flags | NTF_VXLAN_ADDED_BY_USER,
-			       true, extack);
+			       nhid, true, extack);
 	spin_unlock_bh(&vxlan->hash_lock[hash_index]);
 
 	return err;
@@ -1159,8 +1295,8 @@ static int __vxlan_fdb_delete(struct vxlan_dev *vxlan,
 			      __be16 port, __be32 src_vni, __be32 vni,
 			      u32 ifindex, bool swdev_notify)
 {
-	struct vxlan_fdb *f;
 	struct vxlan_rdst *rd = NULL;
+	struct vxlan_fdb *f;
 	int err = -ENOENT;
 
 	f = vxlan_find_mac(vxlan, addr, src_vni);
@@ -1195,12 +1331,13 @@ static int vxlan_fdb_delete(struct ndmsg *ndm, struct nlattr *tb[],
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	union vxlan_addr ip;
 	__be32 src_vni, vni;
-	__be16 port;
-	u32 ifindex;
+	u32 ifindex, nhid;
 	u32 hash_index;
+	__be16 port;
 	int err;
 
-	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex);
+	err = vxlan_fdb_parse(tb, vxlan, &ip, &port, &src_vni, &vni, &ifindex,
+			      &nhid);
 	if (err)
 		return err;
 
@@ -1228,6 +1365,17 @@ static int vxlan_fdb_dump(struct sk_buff *skb, struct netlink_callback *cb,
 		hlist_for_each_entry_rcu(f, &vxlan->fdb_head[h], hlist) {
 			struct vxlan_rdst *rd;
 
+			if (rcu_access_pointer(f->nh)) {
+				err = vxlan_fdb_info(skb, vxlan, f,
+						     NETLINK_CB(cb->skb).portid,
+						     cb->nlh->nlmsg_seq,
+						     RTM_NEWNEIGH,
+						     NLM_F_MULTI, NULL);
+				if (err < 0)
+					goto out;
+				continue;
+			}
+
 			list_for_each_entry_rcu(rd, &f->remotes, list) {
 				if (*idx < cb->args[2])
 					goto skip;
@@ -1311,6 +1459,10 @@ static bool vxlan_snoop(struct net_device *dev,
 		if (f->state & (NUD_PERMANENT | NUD_NOARP))
 			return true;
 
+		/* Don't override an fdb with nexthop with a learnt entry */
+		if (rcu_access_pointer(f->nh))
+			return true;
+
 		if (net_ratelimit())
 			netdev_info(dev,
 				    "%pM migrated from %pIS to %pIS\n",
@@ -1333,7 +1485,7 @@ static bool vxlan_snoop(struct net_device *dev,
 					 vxlan->cfg.dst_port,
 					 vni,
 					 vxlan->default_dst.remote_vni,
-					 ifindex, NTF_SELF, true, NULL);
+					 ifindex, NTF_SELF, 0, true, NULL);
 		spin_unlock(&vxlan->hash_lock[hash_index]);
 	}
 
@@ -2616,6 +2768,32 @@ static void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	kfree_skb(skb);
 }
 
+static void vxlan_xmit_nh(struct sk_buff *skb, struct net_device *dev,
+			  struct vxlan_fdb *f, __be32 vni, bool did_rsc)
+{
+	struct vxlan_rdst nh_rdst;
+	struct nexthop *nh;
+	bool do_xmit;
+	u32 hash;
+
+	memset(&nh_rdst, 0, sizeof(struct vxlan_rdst));
+	hash = skb_get_hash(skb);
+
+	rcu_read_lock();
+	nh = rcu_dereference(f->nh);
+	if (!nh) {
+		rcu_read_unlock();
+		return;
+	}
+	do_xmit = vxlan_fdb_nh_path_select(nh, hash, &nh_rdst);
+	rcu_read_unlock();
+
+	if (likely(do_xmit))
+		vxlan_xmit_one(skb, dev, vni, &nh_rdst, did_rsc);
+	else
+		kfree_skb(skb);
+}
+
 /* Transmit local packets over Vxlan
  *
  * Outer IP header inherits ECN and DF from inner header.
@@ -2692,22 +2870,27 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 		}
 	}
 
-	list_for_each_entry_rcu(rdst, &f->remotes, list) {
-		struct sk_buff *skb1;
+	if (rcu_access_pointer(f->nh)) {
+		vxlan_xmit_nh(skb, dev, f,
+			      (vni ? : vxlan->default_dst.remote_vni), did_rsc);
+	} else {
+		list_for_each_entry_rcu(rdst, &f->remotes, list) {
+			struct sk_buff *skb1;
 
-		if (!fdst) {
-			fdst = rdst;
-			continue;
+			if (!fdst) {
+				fdst = rdst;
+				continue;
+			}
+			skb1 = skb_clone(skb, GFP_ATOMIC);
+			if (skb1)
+				vxlan_xmit_one(skb1, dev, vni, rdst, did_rsc);
 		}
-		skb1 = skb_clone(skb, GFP_ATOMIC);
-		if (skb1)
-			vxlan_xmit_one(skb1, dev, vni, rdst, did_rsc);
+		if (fdst)
+			vxlan_xmit_one(skb, dev, vni, fdst, did_rsc);
+		else
+			kfree_skb(skb);
 	}
 
-	if (fdst)
-		vxlan_xmit_one(skb, dev, vni, fdst, did_rsc);
-	else
-		kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
 
@@ -3615,7 +3798,7 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 				       dst->remote_vni,
 				       dst->remote_vni,
 				       dst->remote_ifindex,
-				       NTF_SELF, &f);
+				       NTF_SELF, 0, &f, extack);
 		if (err)
 			return err;
 	}
@@ -4013,7 +4196,7 @@ static int vxlan_changelink(struct net_device *dev, struct nlattr *tb[],
 					       vxlan->cfg.dst_port,
 					       conf.vni, conf.vni,
 					       conf.remote_ifindex,
-					       NTF_SELF, true, extack);
+					       NTF_SELF, 0, true, extack);
 			if (err) {
 				spin_unlock_bh(&vxlan->hash_lock[hash_index]);
 				netdev_adjacent_change_abort(dst->remote_dev,
@@ -4335,7 +4518,7 @@ vxlan_fdb_external_learn_add(struct net_device *dev,
 			       fdb_info->remote_vni,
 			       fdb_info->remote_ifindex,
 			       NTF_USE | NTF_SELF | NTF_EXT_LEARNED,
-			       false, extack);
+			       0, false, extack);
 	spin_unlock_bh(&vxlan->hash_lock[hash_index]);
 
 	return err;
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 373aadc..3a41627c 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -7,6 +7,7 @@
 #include <net/dst_metadata.h>
 #include <net/rtnetlink.h>
 #include <net/switchdev.h>
+#include <net/nexthop.h>
 
 #define IANA_VXLAN_UDP_PORT     4789
 
@@ -487,4 +488,28 @@ static inline void vxlan_flag_attr_error(int attrtype,
 #undef VXLAN_FLAG
 }
 
+static inline bool vxlan_fdb_nh_path_select(struct nexthop *nh,
+					    int hash,
+					    struct vxlan_rdst *rdst)
+{
+	struct fib_nh_common *nhc;
+
+	nhc = nexthop_path_fdb_result(nh, hash);
+	if (unlikely(!nhc))
+		return false;
+
+	switch (nhc->nhc_gw_family) {
+	case AF_INET:
+		rdst->remote_ip.sin.sin_addr.s_addr = nhc->nhc_gw.ipv4;
+		rdst->remote_ip.sa.sa_family = AF_INET;
+		break;
+	case AF_INET6:
+		rdst->remote_ip.sin6.sin6_addr = nhc->nhc_gw.ipv6;
+		rdst->remote_ip.sa.sa_family = AF_INET6;
+		break;
+	}
+
+	return true;
+}
+
 #endif
diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
index cd144e3..eefcda8 100644
--- a/include/uapi/linux/neighbour.h
+++ b/include/uapi/linux/neighbour.h
@@ -29,6 +29,7 @@ enum {
 	NDA_LINK_NETNSID,
 	NDA_SRC_VNI,
 	NDA_PROTOCOL,  /* Originator of entry */
+	NDA_NH_ID,
 	__NDA_MAX
 };
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index b607ea6..37e4dba 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1771,6 +1771,7 @@ static struct neigh_table *neigh_find_table(int family)
 }
 
 const struct nla_policy nda_policy[NDA_MAX+1] = {
+	[NDA_UNSPEC]		= { .strict_start_type = NDA_NH_ID },
 	[NDA_DST]		= { .type = NLA_BINARY, .len = MAX_ADDR_LEN },
 	[NDA_LLADDR]		= { .type = NLA_BINARY, .len = MAX_ADDR_LEN },
 	[NDA_CACHEINFO]		= { .len = sizeof(struct nda_cacheinfo) },
@@ -1781,6 +1782,7 @@ const struct nla_policy nda_policy[NDA_MAX+1] = {
 	[NDA_IFINDEX]		= { .type = NLA_U32 },
 	[NDA_MASTER]		= { .type = NLA_U32 },
 	[NDA_PROTOCOL]		= { .type = NLA_U8 },
+	[NDA_NH_ID]		= { .type = NLA_U32 },
 };
 
 static int neigh_delete(struct sk_buff *skb, struct nlmsghdr *nlh,
-- 
2.1.4

