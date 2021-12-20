Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0481E47A3A8
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 03:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbhLTCbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 21:31:15 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:37288 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbhLTCbP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 21:31:15 -0500
Received: by codeconstruct.com.au (Postfix, from userid 10001)
        id E14EE2022C; Mon, 20 Dec 2021 10:31:13 +0800 (AWST)
From:   Matt Johnston <matt@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jeremy Kerr <jk@codeconstruct.com.au>
Subject: [PATCH net-next v3] mctp: emit RTM_NEWADDR and RTM_DELADDR
Date:   Mon, 20 Dec 2021 10:31:04 +0800
Message-Id: <20211220023104.1965509-1-matt@codeconstruct.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Userspace can receive notification of MCTP address changes via
RTNLGRP_MCTP_IFADDR rtnetlink multicast group.

Signed-off-by: Matt Johnston <matt@codeconstruct.com.au>
---
v2: Simplify error return path, fix local variable ordering
v3: Fix address size for nlmsg allocation, warn on undersized
---
 include/uapi/linux/rtnetlink.h |  2 ++
 net/mctp/device.c              | 53 ++++++++++++++++++++++++++++++----
 2 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 5888492a5257..93d934cc4613 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -754,6 +754,8 @@ enum rtnetlink_groups {
 #define RTNLGRP_NEXTHOP		RTNLGRP_NEXTHOP
 	RTNLGRP_BRVLAN,
 #define RTNLGRP_BRVLAN		RTNLGRP_BRVLAN
+	RTNLGRP_MCTP_IFADDR,
+#define RTNLGRP_MCTP_IFADDR	RTNLGRP_MCTP_IFADDR
 	__RTNLGRP_MAX
 };
 #define RTNLGRP_MAX	(__RTNLGRP_MAX - 1)
diff --git a/net/mctp/device.c b/net/mctp/device.c
index 8799ee77e7b7..ef2755f82f87 100644
--- a/net/mctp/device.c
+++ b/net/mctp/device.c
@@ -35,14 +35,24 @@ struct mctp_dev *mctp_dev_get_rtnl(const struct net_device *dev)
 	return rtnl_dereference(dev->mctp_ptr);
 }
 
-static int mctp_fill_addrinfo(struct sk_buff *skb, struct netlink_callback *cb,
-			      struct mctp_dev *mdev, mctp_eid_t eid)
+static int mctp_addrinfo_size(void)
+{
+	return NLMSG_ALIGN(sizeof(struct ifaddrmsg))
+		+ nla_total_size(1) // IFA_LOCAL
+		+ nla_total_size(1) // IFA_ADDRESS
+		;
+}
+
+/* flag should be NLM_F_MULTI for dump calls */
+static int mctp_fill_addrinfo(struct sk_buff *skb,
+			      struct mctp_dev *mdev, mctp_eid_t eid,
+			      int msg_type, u32 portid, u32 seq, int flag)
 {
 	struct ifaddrmsg *hdr;
 	struct nlmsghdr *nlh;
 
-	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
-			RTM_NEWADDR, sizeof(*hdr), NLM_F_MULTI);
+	nlh = nlmsg_put(skb, portid, seq,
+			msg_type, sizeof(*hdr), flag);
 	if (!nlh)
 		return -EMSGSIZE;
 
@@ -72,10 +82,14 @@ static int mctp_dump_dev_addrinfo(struct mctp_dev *mdev, struct sk_buff *skb,
 				  struct netlink_callback *cb)
 {
 	struct mctp_dump_cb *mcb = (void *)cb->ctx;
+	u32 portid, seq;
 	int rc = 0;
 
+	portid = NETLINK_CB(cb->skb).portid;
+	seq = cb->nlh->nlmsg_seq;
 	for (; mcb->a_idx < mdev->num_addrs; mcb->a_idx++) {
-		rc = mctp_fill_addrinfo(skb, cb, mdev, mdev->addrs[mcb->a_idx]);
+		rc = mctp_fill_addrinfo(skb, mdev, mdev->addrs[mcb->a_idx],
+					RTM_NEWADDR, portid, seq, NLM_F_MULTI);
 		if (rc < 0)
 			break;
 	}
@@ -127,6 +141,32 @@ static int mctp_dump_addrinfo(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static void mctp_addr_notify(struct mctp_dev *mdev, mctp_eid_t eid, int msg_type,
+			     struct sk_buff *req_skb, struct nlmsghdr *req_nlh)
+{
+	u32 portid = NETLINK_CB(req_skb).portid;
+	struct net *net = dev_net(mdev->dev);
+	struct sk_buff *skb;
+	int rc = -ENOBUFS;
+
+	skb = nlmsg_new(mctp_addrinfo_size(), GFP_KERNEL);
+	if (!skb)
+		goto out;
+
+	rc = mctp_fill_addrinfo(skb, mdev, eid, msg_type,
+				portid, req_nlh->nlmsg_seq, 0);
+	if (rc < 0) {
+		WARN_ON_ONCE(rc == -EMSGSIZE);
+		goto out;
+	}
+
+	rtnl_notify(skb, net, portid, RTNLGRP_MCTP_IFADDR, req_nlh, GFP_KERNEL);
+	return;
+out:
+	kfree_skb(skb);
+	rtnl_set_sk_err(net, RTNLGRP_MCTP_IFADDR, rc);
+}
+
 static const struct nla_policy ifa_mctp_policy[IFA_MAX + 1] = {
 	[IFA_ADDRESS]		= { .type = NLA_U8 },
 	[IFA_LOCAL]		= { .type = NLA_U8 },
@@ -189,6 +229,7 @@ static int mctp_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	kfree(tmp_addrs);
 
+	mctp_addr_notify(mdev, addr->s_addr, RTM_NEWADDR, skb, nlh);
 	mctp_route_add_local(mdev, addr->s_addr);
 
 	return 0;
@@ -244,6 +285,8 @@ static int mctp_rtm_deladdr(struct sk_buff *skb, struct nlmsghdr *nlh,
 	mdev->num_addrs--;
 	spin_unlock_irqrestore(&mdev->addrs_lock, flags);
 
+	mctp_addr_notify(mdev, addr->s_addr, RTM_DELADDR, skb, nlh);
+
 	return 0;
 }
 
-- 
2.32.0

