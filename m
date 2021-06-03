Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756A2399B1E
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 08:59:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhFCHBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 03:01:14 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:46908 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbhFCHBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 03:01:10 -0400
Received: by codeconstruct.com.au (Postfix, from userid 10000)
        id 7978F219EF; Thu,  3 Jun 2021 14:52:32 +0800 (AWST)
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     netdev@vger.kernel.org
Cc:     Andrew Jeffery <andrew@aj.id.au>,
        Matt Johnston <matt@codeconstruct.com.au>
Subject: [PATCH RFC net-next 10/16] mctp: Add neighbour netlink interface
Date:   Thu,  3 Jun 2021 14:52:12 +0800
Message-Id: <20210603065218.570867-11-jk@codeconstruct.com.au>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603065218.570867-1-jk@codeconstruct.com.au>
References: <20210603065218.570867-1-jk@codeconstruct.com.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matt Johnston <matt@codeconstruct.com.au>

This change adds the netlink interfaces for manipulating the MCTP
neighbour table.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
 net/mctp/neigh.c | 207 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 204 insertions(+), 3 deletions(-)

diff --git a/net/mctp/neigh.c b/net/mctp/neigh.c
index acf4f38c878b..5fb3cbaa03ac 100644
--- a/net/mctp/neigh.c
+++ b/net/mctp/neigh.c
@@ -21,9 +21,9 @@
 #include <net/netlink.h>
 #include <net/sock.h>
 
-static int __always_unused mctp_neigh_add(struct mctp_dev *mdev, mctp_eid_t eid,
-					  enum mctp_neigh_source source,
-					  size_t lladdr_len, const void *lladdr)
+static int mctp_neigh_add(struct mctp_dev *mdev, mctp_eid_t eid,
+			  enum mctp_neigh_source source,
+			  size_t lladdr_len, const void *lladdr)
 {
 	struct net *net = dev_net(mdev->dev);
 	struct mctp_neigh *neigh;
@@ -85,6 +85,196 @@ void mctp_neigh_remove_dev(struct mctp_dev *mdev)
 	mutex_unlock(&net->mctp.neigh_lock);
 }
 
+// TODO: add a "source" flag so netlink can only delete static neighbours?
+static int mctp_neigh_remove(struct mctp_dev *mdev, mctp_eid_t eid)
+{
+	struct net *net = dev_net(mdev->dev);
+	struct mctp_neigh *neigh, *tmp;
+	bool dropped = false;
+
+	mutex_lock(&net->mctp.neigh_lock);
+	list_for_each_entry_safe(neigh, tmp, &net->mctp.neighbours, list) {
+		if (neigh->dev == mdev && neigh->eid == eid) {
+			list_del_rcu(&neigh->list);
+			/* TODO: immediate RTM_DELNEIGH */
+			call_rcu(&neigh->rcu, __mctp_neigh_free);
+			dropped = true;
+		}
+	}
+
+	mutex_unlock(&net->mctp.neigh_lock);
+	return dropped ? 0 : -ENOENT;
+}
+
+static const struct nla_policy nd_mctp_policy[NDA_MAX + 1] = {
+	[NDA_DST]		= { .type = NLA_U8 },
+	[NDA_LLADDR]		= { .type = NLA_BINARY, .len = MAX_ADDR_LEN },
+};
+
+static int mctp_rtm_newneigh(struct sk_buff *skb, struct nlmsghdr *nlh,
+			     struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(skb->sk);
+	struct net_device *dev;
+	struct mctp_dev *mdev;
+	struct ndmsg *ndm;
+	struct nlattr *tb[NDA_MAX + 1];
+	int rc;
+	mctp_eid_t eid;
+	void *lladdr;
+	int lladdr_len;
+
+	rc = nlmsg_parse(nlh, sizeof(*ndm), tb, NDA_MAX, nd_mctp_policy,
+			 extack);
+	if (rc < 0) {
+		NL_SET_ERR_MSG(extack, "lladdr too large?");
+		return rc;
+	}
+
+	if (!tb[NDA_DST]) {
+		NL_SET_ERR_MSG(extack, "Neighbour EID must be specified");
+		return -EINVAL;
+	}
+
+	if (!tb[NDA_LLADDR]) {
+		NL_SET_ERR_MSG(extack, "Neighbour lladdr must be specified");
+		return -EINVAL;
+	}
+
+	eid = nla_get_u8(tb[NDA_DST]);
+	if (!mctp_address_ok(eid)) {
+		NL_SET_ERR_MSG(extack, "Invalid neighbour EID");
+		return -EINVAL;
+	}
+
+	lladdr = nla_data(tb[NDA_LLADDR]);
+	lladdr_len = nla_len(tb[NDA_LLADDR]);
+
+	ndm = nlmsg_data(nlh);
+
+	dev = __dev_get_by_index(net, ndm->ndm_ifindex);
+	if (!dev)
+		return -ENODEV;
+
+	mdev = mctp_dev_get_rtnl(dev);
+	if (!mdev)
+		return -ENODEV;
+
+	if (lladdr_len != dev->addr_len) {
+		NL_SET_ERR_MSG(extack, "Wrong lladdr length");
+		return -EINVAL;
+	}
+
+	return mctp_neigh_add(mdev, eid, MCTP_NEIGH_STATIC,
+			lladdr_len, lladdr);
+}
+
+static int mctp_rtm_delneigh(struct sk_buff *skb, struct nlmsghdr *nlh,
+			     struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(skb->sk);
+	struct nlattr *tb[NDA_MAX + 1];
+	struct net_device *dev;
+	struct mctp_dev *mdev;
+	struct ndmsg *ndm;
+	int rc;
+	mctp_eid_t eid;
+
+	rc = nlmsg_parse(nlh, sizeof(*ndm), tb, NDA_MAX, nd_mctp_policy,
+			 extack);
+	if (rc < 0) {
+		NL_SET_ERR_MSG(extack, "incorrect format");
+		return rc;
+	}
+
+	if (!tb[NDA_DST]) {
+		NL_SET_ERR_MSG(extack, "Neighbour EID must be specified");
+		return -EINVAL;
+	}
+	eid = nla_get_u8(tb[NDA_DST]);
+
+	ndm = nlmsg_data(nlh);
+	dev = __dev_get_by_index(net, ndm->ndm_ifindex);
+	if (!dev)
+		return -ENODEV;
+
+	mdev = mctp_dev_get_rtnl(dev);
+	if (!mdev)
+		return -ENODEV;
+
+	return mctp_neigh_remove(mdev, eid);
+}
+
+static int mctp_fill_neigh(struct sk_buff *skb, u32 portid, u32 seq, int event,
+			   unsigned int flags, struct mctp_neigh *neigh)
+{
+	struct net_device *dev = neigh->dev->dev;
+	struct nlmsghdr *nlh;
+	struct ndmsg *hdr;
+
+	nlh = nlmsg_put(skb, portid, seq, event, sizeof(*hdr), flags);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	hdr = nlmsg_data(nlh);
+	hdr->ndm_family = AF_MCTP;
+	hdr->ndm_ifindex = dev->ifindex;
+	hdr->ndm_state = 0; // TODO other state bits?
+	if (neigh->source == MCTP_NEIGH_STATIC)
+		hdr->ndm_state |= NUD_PERMANENT;
+	hdr->ndm_flags = 0;
+	hdr->ndm_type = RTN_UNICAST; // TODO: is loopback RTN_LOCAL?
+
+	if (nla_put_u8(skb, NDA_DST, neigh->eid))
+		goto cancel;
+
+	if (nla_put(skb, NDA_LLADDR, dev->addr_len, neigh->ha))
+		goto cancel;
+
+	nlmsg_end(skb, nlh);
+
+	return 0;
+cancel:
+	nlmsg_cancel(skb, nlh);
+	return -EMSGSIZE;
+}
+
+static int mctp_rtm_getneigh(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct net *net = sock_net(skb->sk);
+	int rc, idx, req_ifindex;
+	struct mctp_neigh *neigh;
+	struct ndmsg *ndmsg;
+	struct {
+		int idx;
+	} *cbctx = (void *)cb->ctx;
+
+	ndmsg = nlmsg_data(cb->nlh);
+	req_ifindex = ndmsg->ndm_ifindex;
+
+	idx = 0;
+	rcu_read_lock();
+	list_for_each_entry_rcu(neigh, &net->mctp.neighbours, list) {
+		if (idx < cbctx->idx)
+			goto cont;
+
+		rc = 0;
+		if (req_ifindex == 0 || req_ifindex == neigh->dev->dev->ifindex)
+			rc = mctp_fill_neigh(skb, NETLINK_CB(cb->skb).portid,
+					     cb->nlh->nlmsg_seq,
+					     RTM_NEWNEIGH, NLM_F_MULTI, neigh);
+
+		if (rc)
+			break;
+cont:
+		idx++;
+	}
+	rcu_read_unlock();
+
+	cbctx->idx = idx;
+	return skb->len;
+}
+
 int mctp_neigh_lookup(struct mctp_dev *mdev, mctp_eid_t eid, void *ret_hwaddr)
 {
 	struct net *net = dev_net(mdev->dev);
@@ -111,6 +301,7 @@ static int __net_init mctp_neigh_net_init(struct net *net)
 	struct netns_mctp *ns = &net->mctp;
 
 	INIT_LIST_HEAD(&ns->neighbours);
+	mutex_init(&ns->neigh_lock);
 	return 0;
 }
 
@@ -132,10 +323,20 @@ static struct pernet_operations mctp_net_ops = {
 
 int __init mctp_neigh_init(void)
 {
+	rtnl_register_module(THIS_MODULE, PF_MCTP, RTM_NEWNEIGH,
+			     mctp_rtm_newneigh, NULL, 0);
+	rtnl_register_module(THIS_MODULE, PF_MCTP, RTM_DELNEIGH,
+			     mctp_rtm_delneigh, NULL, 0);
+	rtnl_register_module(THIS_MODULE, PF_MCTP, RTM_GETNEIGH,
+			     NULL, mctp_rtm_getneigh, 0);
+
 	return register_pernet_subsys(&mctp_net_ops);
 }
 
 void __exit mctp_neigh_exit(void)
 {
 	unregister_pernet_subsys(&mctp_net_ops);
+	rtnl_unregister(PF_MCTP, RTM_GETNEIGH);
+	rtnl_unregister(PF_MCTP, RTM_DELNEIGH);
+	rtnl_unregister(PF_MCTP, RTM_NEWNEIGH);
 }
-- 
2.30.2

