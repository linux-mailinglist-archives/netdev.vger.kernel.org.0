Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15805D311F
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 21:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfJJTHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 15:07:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49406 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726489AbfJJTHf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 15:07:35 -0400
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 071C481129
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 19:07:34 +0000 (UTC)
Received: by mail-wm1-f72.google.com with SMTP id g67so2066480wmg.4
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 12:07:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=X8xcP4ssGj6cJ5RnkUrCmamBsaWSW9S/Ly8Ro+QSOvA=;
        b=hvJq5YdsugY9BBkilrdHhyp9jOn6QIbdjcy0CONMtVnv3KU38yBrmRaSvLY2tgnx4H
         ersQ5VjZgAdFJFJGUA5QPLSTVGIzlGMU/hWrTj7d8/QgjKcTfeDBQ5mwas7I7826eGSM
         BIeRf6sBeIkS81ujb+O6HBzyX7YzU8fMIWpT+VlfVMV0PuMlPYqffHmuz1p3g1ZjOcit
         uM50/ZPqUM/ipgwes0lJaXL7Y6CCmMf/vLvcpfoHbkWlmqYlxC5JwK5uld80o0Rnj9pW
         6Abr+jOwZG6Qn6S6kdjWYDgxr7vYeUqVwjEqP73IhdwMx2O2AQyDPn87iq2Nvq3iVvYX
         C1nA==
X-Gm-Message-State: APjAAAWFkzNTFIVPq3Rf+BYkUgs7fvWNkTCLcb6xx6WMh/BENWQV88Fd
        whSYpaXcDEJedE4o/iuayavf+i7A+KxOR1eGehWDyeGK5ufdL28cpntQct6j6UAgAW270T8LiA/
        PMMcxESzmFtkrc4uE
X-Received: by 2002:adf:fd04:: with SMTP id e4mr10167143wrr.371.1570734452407;
        Thu, 10 Oct 2019 12:07:32 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwIzrovMEQeEcWS/akqFMurTq63Josz+HueOVw+NvUnZ388/8vKCHDWwRSWRkrk1ZZXZ9PTrg==
X-Received: by 2002:adf:fd04:: with SMTP id e4mr10167112wrr.371.1570734452027;
        Thu, 10 Oct 2019 12:07:32 -0700 (PDT)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id a3sm10970424wmc.3.2019.10.10.12.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 12:07:31 -0700 (PDT)
Date:   Thu, 10 Oct 2019 21:07:29 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Jesse Gross <jesse@nicira.com>,
        Pravin B Shelar <pshelar@nicira.com>,
        Jiri Benc <jbenc@redhat.com>
Subject: [RFC PATCH net] netns: fix GFP flags in rtnl_net_notifyid()
Message-ID: <41b3fbfe3aac5ca03f4af0f1c4e146ae67c20570.1570734410.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In rtnl_net_notifyid(), we certainly can't pass a null GFP flag to
rtnl_notify(). A GFP_KERNEL flag would be fine in most circumstances,
but there are a few paths calling rtnl_net_notifyid() from atomic
context or from RCU critical section. The later also precludes the use
of gfp_any() as it wouldn't detect the RCU case. Also, the nlmsg_new()
call is wrong too, as it uses GFP_KERNEL unconditionally.

Therefore, we need to pass the GFP flags as parameter. The problem then
propagates recursively to the callers until the proper flags can be
determined. The problematic call chains are:

 * ovs_vport_cmd_fill_info -> peernet2id_alloc -> rtnl_net_notifyid

 * rtnl_fill_ifinfo -> rtnl_fill_link_netnsid -> peernet2id_alloc
 -> rtnl_net_notifyid

For openvswitch, ovs_vport_cmd_get() and ovs_vport_cmd_dump() prevent
ovs_vport_cmd_fill_info() from using GFP_KERNEL. It'd be nice to move
the call out of the RCU critical sections, but struct vport doesn't
have a reference counter, so that'd probably require taking the ovs
lock. Also, I don't get why ovs_vport_cmd_build_info() used GFP_ATOMIC
in nlmsg_new(). I've changed it to GFP_KERNEL for consistency, as this
functions seems to be allowed to sleep (as stated in the comment, it's
called from a workqueue, under the protection of a mutex).

For core networking, rtmsg_ifinfo_build_skb() prevents rtnl_fill_ifinfo()
from using GFP_KERNEL. So we have to reuse rtmsg_ifinfo_build_skb()'s GFP
flags there. Actually, the only caller preventing the use of GFP_KERNEL,
is __dev_notify_flags() which calls rtmsg_ifinfo() with GFP_ATOMIC (see
commit 7f29405403d7 ("net: fix rtnl notification in atomic context")).
I'd have expected this function to be allowed to sleep, but I haven't
dug deeper yet.

Before I spend more time on this, do we have a chance to make
ovs_vport_cmd_fill_info() and __dev_notify_flags() sleepable?
I'd like to avoid passing GFP flags along these call chains, if at all
possible.

Found by code inspection.

Fixes: 9a9634545c70 ("netns: notify netns id events")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 include/net/net_namespace.h |  2 +-
 net/core/dev.c              |  2 +-
 net/core/net_namespace.c    | 17 +++++++++--------
 net/core/rtnetlink.c        | 14 +++++++-------
 net/openvswitch/datapath.c  | 20 +++++++++++---------
 5 files changed, 29 insertions(+), 26 deletions(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index f8712bbeb2e0..fa0381c6b4c4 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -333,7 +333,7 @@ static inline struct net *read_pnet(const possible_net_t *pnet)
 #define __net_initconst	__initconst
 #endif
 
-int peernet2id_alloc(struct net *net, struct net *peer);
+int peernet2id_alloc(struct net *net, struct net *peer, gfp_t gfp);
 int peernet2id(struct net *net, struct net *peer);
 bool peernet_has_id(struct net *net, struct net *peer);
 struct net *get_net_ns_by_id(struct net *net, int id);
diff --git a/net/core/dev.c b/net/core/dev.c
index bf3ed413abaf..d966208bc857 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9460,7 +9460,7 @@ int dev_change_net_namespace(struct net_device *dev, struct net *net, const char
 	call_netdevice_notifiers(NETDEV_UNREGISTER, dev);
 	rcu_barrier();
 
-	new_nsid = peernet2id_alloc(dev_net(dev), net);
+	new_nsid = peernet2id_alloc(dev_net(dev), net, GFP_KERNEL);
 	/* If there is an ifindex conflict assign a new one */
 	if (__dev_get_by_index(net, dev->ifindex))
 		new_ifindex = dev_new_index(net);
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 6d3e4821b02d..2f49d5078298 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -246,11 +246,11 @@ static int __peernet2id(struct net *net, struct net *peer)
 }
 
 static void rtnl_net_notifyid(struct net *net, int cmd, int id, u32 portid,
-			      struct nlmsghdr *nlh);
+			      struct nlmsghdr *nlh, gfp_t gfp);
 /* This function returns the id of a peer netns. If no id is assigned, one will
  * be allocated and returned.
  */
-int peernet2id_alloc(struct net *net, struct net *peer)
+int peernet2id_alloc(struct net *net, struct net *peer, gfp_t gfp)
 {
 	bool alloc = false, alive = false;
 	int id;
@@ -269,7 +269,7 @@ int peernet2id_alloc(struct net *net, struct net *peer)
 	id = __peernet2id_alloc(net, peer, &alloc);
 	spin_unlock_bh(&net->nsid_lock);
 	if (alloc && id >= 0)
-		rtnl_net_notifyid(net, RTM_NEWNSID, id, 0, NULL);
+		rtnl_net_notifyid(net, RTM_NEWNSID, id, 0, NULL, gfp);
 	if (alive)
 		put_net(peer);
 	return id;
@@ -533,7 +533,8 @@ static void unhash_nsid(struct net *net, struct net *last)
 			idr_remove(&tmp->netns_ids, id);
 		spin_unlock_bh(&tmp->nsid_lock);
 		if (id >= 0)
-			rtnl_net_notifyid(tmp, RTM_DELNSID, id, 0, NULL);
+			rtnl_net_notifyid(tmp, RTM_DELNSID, id, 0, NULL,
+					  GFP_KERNEL);
 		if (tmp == last)
 			break;
 	}
@@ -766,7 +767,7 @@ static int rtnl_net_newid(struct sk_buff *skb, struct nlmsghdr *nlh,
 	spin_unlock_bh(&net->nsid_lock);
 	if (err >= 0) {
 		rtnl_net_notifyid(net, RTM_NEWNSID, err, NETLINK_CB(skb).portid,
-				  nlh);
+				  nlh, GFP_KERNEL);
 		err = 0;
 	} else if (err == -ENOSPC && nsid >= 0) {
 		err = -EEXIST;
@@ -1054,7 +1055,7 @@ static int rtnl_net_dumpid(struct sk_buff *skb, struct netlink_callback *cb)
 }
 
 static void rtnl_net_notifyid(struct net *net, int cmd, int id, u32 portid,
-			      struct nlmsghdr *nlh)
+			      struct nlmsghdr *nlh, gfp_t gfp)
 {
 	struct net_fill_args fillargs = {
 		.portid = portid,
@@ -1065,7 +1066,7 @@ static void rtnl_net_notifyid(struct net *net, int cmd, int id, u32 portid,
 	struct sk_buff *msg;
 	int err = -ENOMEM;
 
-	msg = nlmsg_new(rtnl_net_get_size(), GFP_KERNEL);
+	msg = nlmsg_new(rtnl_net_get_size(), gfp);
 	if (!msg)
 		goto out;
 
@@ -1073,7 +1074,7 @@ static void rtnl_net_notifyid(struct net *net, int cmd, int id, u32 portid,
 	if (err < 0)
 		goto err_out;
 
-	rtnl_notify(msg, net, portid, RTNLGRP_NSID, nlh, 0);
+	rtnl_notify(msg, net, portid, RTNLGRP_NSID, nlh, gfp);
 	return;
 
 err_out:
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 1ee6460f8275..6b866aff7b21 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1523,7 +1523,7 @@ static noinline_for_stack int nla_put_ifalias(struct sk_buff *skb,
 
 static int rtnl_fill_link_netnsid(struct sk_buff *skb,
 				  const struct net_device *dev,
-				  struct net *src_net)
+				  struct net *src_net, gfp_t gfp)
 {
 	bool put_iflink = false;
 
@@ -1531,7 +1531,7 @@ static int rtnl_fill_link_netnsid(struct sk_buff *skb,
 		struct net *link_net = dev->rtnl_link_ops->get_link_net(dev);
 
 		if (!net_eq(dev_net(dev), link_net)) {
-			int id = peernet2id_alloc(src_net, link_net);
+			int id = peernet2id_alloc(src_net, link_net, gfp);
 
 			if (nla_put_s32(skb, IFLA_LINK_NETNSID, id))
 				return -EMSGSIZE;
@@ -1589,7 +1589,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 			    int type, u32 pid, u32 seq, u32 change,
 			    unsigned int flags, u32 ext_filter_mask,
 			    u32 event, int *new_nsid, int new_ifindex,
-			    int tgt_netnsid)
+			    int tgt_netnsid, gfp_t gfp)
 {
 	struct ifinfomsg *ifm;
 	struct nlmsghdr *nlh;
@@ -1681,7 +1681,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 			goto nla_put_failure;
 	}
 
-	if (rtnl_fill_link_netnsid(skb, dev, src_net))
+	if (rtnl_fill_link_netnsid(skb, dev, src_net, gfp))
 		goto nla_put_failure;
 
 	if (new_nsid &&
@@ -2001,7 +2001,7 @@ static int rtnl_dump_ifinfo(struct sk_buff *skb, struct netlink_callback *cb)
 					       NETLINK_CB(cb->skb).portid,
 					       nlh->nlmsg_seq, 0, flags,
 					       ext_filter_mask, 0, NULL, 0,
-					       netnsid);
+					       netnsid, GFP_KERNEL);
 
 			if (err < 0) {
 				if (likely(skb->len))
@@ -3359,7 +3359,7 @@ static int rtnl_getlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 	err = rtnl_fill_ifinfo(nskb, dev, net,
 			       RTM_NEWLINK, NETLINK_CB(skb).portid,
 			       nlh->nlmsg_seq, 0, 0, ext_filter_mask,
-			       0, NULL, 0, netnsid);
+			       0, NULL, 0, netnsid, GFP_KERNEL);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in if_nlmsg_size */
 		WARN_ON(err == -EMSGSIZE);
@@ -3471,7 +3471,7 @@ struct sk_buff *rtmsg_ifinfo_build_skb(int type, struct net_device *dev,
 
 	err = rtnl_fill_ifinfo(skb, dev, dev_net(dev),
 			       type, 0, 0, change, 0, 0, event,
-			       new_nsid, new_ifindex, -1);
+			       new_nsid, new_ifindex, -1, flags);
 	if (err < 0) {
 		/* -EMSGSIZE implies BUG in if_nlmsg_size() */
 		WARN_ON(err == -EMSGSIZE);
diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
index f30e406fbec5..d8c364d637b1 100644
--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1881,7 +1881,7 @@ static struct genl_family dp_datapath_genl_family __ro_after_init = {
 /* Called with ovs_mutex or RCU read lock. */
 static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 				   struct net *net, u32 portid, u32 seq,
-				   u32 flags, u8 cmd)
+				   u32 flags, u8 cmd, gfp_t gfp)
 {
 	struct ovs_header *ovs_header;
 	struct ovs_vport_stats vport_stats;
@@ -1902,7 +1902,7 @@ static int ovs_vport_cmd_fill_info(struct vport *vport, struct sk_buff *skb,
 		goto nla_put_failure;
 
 	if (!net_eq(net, dev_net(vport->dev))) {
-		int id = peernet2id_alloc(net, dev_net(vport->dev));
+		int id = peernet2id_alloc(net, dev_net(vport->dev), gfp);
 
 		if (nla_put_s32(skb, OVS_VPORT_ATTR_NETNSID, id))
 			goto nla_put_failure;
@@ -1943,11 +1943,12 @@ struct sk_buff *ovs_vport_cmd_build_info(struct vport *vport, struct net *net,
 	struct sk_buff *skb;
 	int retval;
 
-	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_ATOMIC);
+	skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!skb)
 		return ERR_PTR(-ENOMEM);
 
-	retval = ovs_vport_cmd_fill_info(vport, skb, net, portid, seq, 0, cmd);
+	retval = ovs_vport_cmd_fill_info(vport, skb, net, portid, seq, 0, cmd,
+					 GFP_KERNEL);
 	BUG_ON(retval < 0);
 
 	return skb;
@@ -2089,7 +2090,7 @@ static int ovs_vport_cmd_new(struct sk_buff *skb, struct genl_info *info)
 
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
-				      OVS_VPORT_CMD_NEW);
+				      OVS_VPORT_CMD_NEW, GFP_KERNEL);
 
 	new_headroom = netdev_get_fwd_headroom(vport->dev);
 
@@ -2150,7 +2151,7 @@ static int ovs_vport_cmd_set(struct sk_buff *skb, struct genl_info *info)
 
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
-				      OVS_VPORT_CMD_SET);
+				      OVS_VPORT_CMD_SET, GFP_KERNEL);
 	BUG_ON(err < 0);
 
 	ovs_unlock();
@@ -2190,7 +2191,7 @@ static int ovs_vport_cmd_del(struct sk_buff *skb, struct genl_info *info)
 
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
-				      OVS_VPORT_CMD_DEL);
+				      OVS_VPORT_CMD_DEL, GFP_KERNEL);
 	BUG_ON(err < 0);
 
 	/* the vport deletion may trigger dp headroom update */
@@ -2237,7 +2238,7 @@ static int ovs_vport_cmd_get(struct sk_buff *skb, struct genl_info *info)
 		goto exit_unlock_free;
 	err = ovs_vport_cmd_fill_info(vport, reply, genl_info_net(info),
 				      info->snd_portid, info->snd_seq, 0,
-				      OVS_VPORT_CMD_GET);
+				      OVS_VPORT_CMD_GET, GFP_ATOMIC);
 	BUG_ON(err < 0);
 	rcu_read_unlock();
 
@@ -2273,7 +2274,8 @@ static int ovs_vport_cmd_dump(struct sk_buff *skb, struct netlink_callback *cb)
 						    NETLINK_CB(cb->skb).portid,
 						    cb->nlh->nlmsg_seq,
 						    NLM_F_MULTI,
-						    OVS_VPORT_CMD_GET) < 0)
+						    OVS_VPORT_CMD_GET,
+						    GFP_ATOMIC) < 0)
 				goto out;
 
 			j++;
-- 
2.21.0

