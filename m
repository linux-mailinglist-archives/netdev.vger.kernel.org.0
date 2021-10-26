Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF88843B889
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 19:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236745AbhJZRt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 13:49:26 -0400
Received: from mga05.intel.com ([192.55.52.43]:61969 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236730AbhJZRtW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 13:49:22 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10149"; a="316178694"
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="316178694"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2021 10:46:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,184,1631602800"; 
   d="scan'208";a="494318110"
Received: from unknown (HELO localhost.igk.intel.com) ([10.102.22.231])
  by fmsmga007.fm.intel.com with ESMTP; 26 Oct 2021 10:46:55 -0700
From:   Maciej Machnikowski <maciej.machnikowski@intel.com>
To:     maciej.machnikowski@intel.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org
Cc:     richardcochran@gmail.com, abyagowi@fb.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        linux-kselftest@vger.kernel.org, idosch@idosch.org,
        mkubecek@suse.cz, saeed@kernel.org, michael.chan@broadcom.com
Subject: [RFC v5 net-next 4/5] rtnetlink: Add support for SyncE recovered clock configuration
Date:   Tue, 26 Oct 2021 19:31:45 +0200
Message-Id: <20211026173146.1031412-5-maciej.machnikowski@intel.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20211026173146.1031412-1-maciej.machnikowski@intel.com>
References: <20211026173146.1031412-1-maciej.machnikowski@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for RTNL messages for reading/configuring SyncE recovered
clocks.
The messages are:
RTM_GETRCLKRANGE: Reads the allowed pin index range for the recovered
		  clock outputs. This can be aligned to PHY outputs or
		  to EEC inputs, whichever is better for a given
		  application

RTM_GETRCLKSTATE: Read the state of recovered pins that output recovered
		  clock from a given port. The message will contain the
		  number of assigned clocks (IFLA_RCLK_STATE_COUNT) and
		  a N pin inexes in IFLA_RCLK_STATE_OUT_IDX

RTM_SETRCLKSTATE: Sets the redirection of the recovered clock for
		  a given pin

Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
---
 include/linux/netdevice.h      |   9 ++
 include/uapi/linux/if_link.h   |  26 +++++
 include/uapi/linux/rtnetlink.h |   7 ++
 net/core/rtnetlink.c           | 178 ++++++++++++++++++++++++++++++++-
 security/selinux/nlmsgtab.c    |   3 +
 5 files changed, 222 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index fec54951347e..e70d1ca72a99 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1572,6 +1572,15 @@ struct net_device_ops {
 	int			(*ndo_get_eec_src)(struct net_device *dev,
 						   u32 *src,
 						   struct netlink_ext_ack *extack);
+	int			(*ndo_get_rclk_range)(struct net_device *dev,
+						      u32 *min_idx, u32 *max_idx,
+						      struct netlink_ext_ack *extack);
+	int			(*ndo_set_rclk_out)(struct net_device *dev,
+						    u32 out_idx, bool ena,
+						    struct netlink_ext_ack *extack);
+	int			(*ndo_get_rclk_state)(struct net_device *dev,
+						      u32 out_idx, bool *ena,
+						      struct netlink_ext_ack *extack);
 };
 
 /**
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index abab69b79e8a..b3764e2f6fb0 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -1300,4 +1300,30 @@ enum {
 
 #define IFLA_EEC_MAX (__IFLA_EEC_MAX - 1)
 
+struct if_rclk_range_msg {
+	__u32 ifindex;
+};
+
+enum {
+	IFLA_RCLK_RANGE_UNSPEC,
+	IFLA_RCLK_RANGE_MIN_PIN,
+	IFLA_RCLK_RANGE_MAX_PIN,
+	__IFLA_RCLK_RANGE_MAX,
+};
+
+struct if_set_rclk_msg {
+	__u32 ifindex;
+	__u32 out_idx;
+	__u32 flags;
+};
+
+#define SET_RCLK_FLAGS_ENA	(1U << 0)
+
+enum {
+	IFLA_RCLK_STATE_UNSPEC,
+	IFLA_RCLK_STATE_OUT_IDX,
+	IFLA_RCLK_STATE_COUNT,
+	__IFLA_RCLK_STATE_MAX,
+};
+
 #endif /* _UAPI_LINUX_IF_LINK_H */
diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
index 1d8662afd6bd..6c0d96d56ec7 100644
--- a/include/uapi/linux/rtnetlink.h
+++ b/include/uapi/linux/rtnetlink.h
@@ -185,6 +185,13 @@ enum {
 	RTM_GETNEXTHOPBUCKET,
 #define RTM_GETNEXTHOPBUCKET	RTM_GETNEXTHOPBUCKET
 
+	RTM_GETRCLKRANGE = 120,
+#define RTM_GETRCLKRANGE	RTM_GETRCLKRANGE
+	RTM_GETRCLKSTATE = 121,
+#define RTM_GETRCLKSTATE	RTM_GETRCLKSTATE
+	RTM_SETRCLKSTATE = 122,
+#define RTM_SETRCLKSTATE	RTM_SETRCLKSTATE
+
 	RTM_GETEECSTATE = 124,
 #define RTM_GETEECSTATE	RTM_GETEECSTATE
 
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index bba13b377e73..bc1e050f6d38 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5524,8 +5524,10 @@ static int rtnl_eec_state_get(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	state = nlmsg_data(nlh);
 	dev = __dev_get_by_index(net, state->ifindex);
-	if (!dev)
+	if (!dev) {
+		NL_SET_ERR_MSG(extack, "unknown ifindex");
 		return -ENODEV;
+	}
 
 	nskb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!nskb)
@@ -5542,6 +5544,176 @@ static int rtnl_eec_state_get(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return err;
 }
 
+static int rtnl_fill_rclk_range(struct sk_buff *skb, struct net_device *dev,
+				u32 portid, u32 seq,
+				struct netlink_callback *cb, int flags,
+				struct netlink_ext_ack *extack)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	struct if_rclk_range_msg *state_msg;
+	struct nlmsghdr *nlh;
+	u32 min_idx, max_idx;
+	int err;
+
+	ASSERT_RTNL();
+
+	if (!ops->ndo_get_rclk_range)
+		return -EOPNOTSUPP;
+
+	err = ops->ndo_get_rclk_range(dev, &min_idx, &max_idx, extack);
+	if (err)
+		return err;
+
+	nlh = nlmsg_put(skb, portid, seq, RTM_GETRCLKRANGE, sizeof(*state_msg),
+			flags);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	state_msg = nlmsg_data(nlh);
+	state_msg->ifindex = dev->ifindex;
+
+	if (nla_put_u32(skb, IFLA_RCLK_RANGE_MIN_PIN, min_idx) ||
+	    nla_put_u32(skb, IFLA_RCLK_RANGE_MAX_PIN, max_idx))
+		return -EMSGSIZE;
+
+	nlmsg_end(skb, nlh);
+	return 0;
+}
+
+static int rtnl_rclk_range_get(struct sk_buff *skb, struct nlmsghdr *nlh,
+			       struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(skb->sk);
+	struct if_eec_state_msg *state;
+	struct net_device *dev;
+	struct sk_buff *nskb;
+	int err;
+
+	state = nlmsg_data(nlh);
+	dev = __dev_get_by_index(net, state->ifindex);
+	if (!dev) {
+		NL_SET_ERR_MSG(extack, "unknown ifindex");
+		return -ENODEV;
+	}
+
+	nskb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!nskb)
+		return -ENOBUFS;
+
+	err = rtnl_fill_rclk_range(nskb, dev, NETLINK_CB(skb).portid,
+				   nlh->nlmsg_seq, NULL, nlh->nlmsg_flags,
+				   extack);
+	if (err < 0)
+		kfree_skb(nskb);
+	else
+		err = rtnl_unicast(nskb, net, NETLINK_CB(skb).portid);
+
+	return err;
+}
+
+static int rtnl_fill_rclk_state(struct sk_buff *skb, struct net_device *dev,
+				u32 portid, u32 seq,
+				struct netlink_callback *cb, int flags,
+				struct netlink_ext_ack *extack)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	u32 min_idx, max_idx, src_idx, count = 0;
+	struct if_eec_state_msg *state_msg;
+	struct nlmsghdr *nlh;
+	bool ena;
+	int err;
+
+	ASSERT_RTNL();
+
+	if (!ops->ndo_get_rclk_state || !ops->ndo_get_rclk_range)
+		return -EOPNOTSUPP;
+
+	err = ops->ndo_get_rclk_range(dev, &min_idx, &max_idx, extack);
+	if (err)
+		return err;
+
+	nlh = nlmsg_put(skb, portid, seq, RTM_GETRCLKSTATE, sizeof(*state_msg),
+			flags);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	state_msg = nlmsg_data(nlh);
+	state_msg->ifindex = dev->ifindex;
+
+	for (src_idx = min_idx; src_idx <= max_idx; src_idx++) {
+		ops->ndo_get_rclk_state(dev, src_idx, &ena, extack);
+		if (!ena)
+			continue;
+
+		if (nla_put_u32(skb, IFLA_RCLK_STATE_OUT_IDX, src_idx))
+			return -EMSGSIZE;
+		count++;
+	}
+
+	if (nla_put_u32(skb, IFLA_RCLK_STATE_COUNT, count))
+		return -EMSGSIZE;
+
+	nlmsg_end(skb, nlh);
+	return 0;
+}
+
+static int rtnl_rclk_state_get(struct sk_buff *skb, struct nlmsghdr *nlh,
+			       struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(skb->sk);
+	struct if_eec_state_msg *state;
+	struct net_device *dev;
+	struct sk_buff *nskb;
+	int err;
+
+	state = nlmsg_data(nlh);
+	dev = __dev_get_by_index(net, state->ifindex);
+	if (!dev) {
+		NL_SET_ERR_MSG(extack, "unknown ifindex");
+		return -ENODEV;
+	}
+
+	nskb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!nskb)
+		return -ENOBUFS;
+
+	err = rtnl_fill_rclk_state(nskb, dev, NETLINK_CB(skb).portid,
+				   nlh->nlmsg_seq, NULL, nlh->nlmsg_flags,
+				   extack);
+	if (err < 0)
+		kfree_skb(nskb);
+	else
+		err = rtnl_unicast(nskb, net, NETLINK_CB(skb).portid);
+
+	return err;
+}
+
+static int rtnl_rclk_set(struct sk_buff *skb, struct nlmsghdr *nlh,
+			 struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(skb->sk);
+	struct if_set_rclk_msg *state;
+	struct net_device *dev;
+	bool ena;
+	int err;
+
+	state = nlmsg_data(nlh);
+	dev = __dev_get_by_index(net, state->ifindex);
+	if (!dev) {
+		NL_SET_ERR_MSG(extack, "unknown ifindex");
+		return -ENODEV;
+	}
+
+	if (!dev->netdev_ops->ndo_set_rclk_out)
+		return -EOPNOTSUPP;
+
+	ena = !!(state->flags & SET_RCLK_FLAGS_ENA);
+	err = dev->netdev_ops->ndo_set_rclk_out(dev, state->out_idx, ena,
+						extack);
+
+	return err;
+}
+
 /* Process one rtnetlink message. */
 
 static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -5768,5 +5940,9 @@ void __init rtnetlink_init(void)
 	rtnl_register(PF_UNSPEC, RTM_GETSTATS, rtnl_stats_get, rtnl_stats_dump,
 		      0);
 
+	rtnl_register(PF_UNSPEC, RTM_GETRCLKRANGE, rtnl_rclk_range_get, NULL, 0);
+	rtnl_register(PF_UNSPEC, RTM_GETRCLKSTATE, rtnl_rclk_state_get, NULL, 0);
+	rtnl_register(PF_UNSPEC, RTM_SETRCLKSTATE, rtnl_rclk_set, NULL, 0);
+
 	rtnl_register(PF_UNSPEC, RTM_GETEECSTATE, rtnl_eec_state_get, NULL, 0);
 }
diff --git a/security/selinux/nlmsgtab.c b/security/selinux/nlmsgtab.c
index 2c66e722ea9c..57c7c85edd4d 100644
--- a/security/selinux/nlmsgtab.c
+++ b/security/selinux/nlmsgtab.c
@@ -91,6 +91,9 @@ static const struct nlmsg_perm nlmsg_route_perms[] =
 	{ RTM_NEWNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_DELNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_GETNEXTHOPBUCKET,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_GETRCLKRANGE,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_GETRCLKSTATE,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
+	{ RTM_SETRCLKSTATE,	NETLINK_ROUTE_SOCKET__NLMSG_WRITE },
 	{ RTM_GETEECSTATE,	NETLINK_ROUTE_SOCKET__NLMSG_READ  },
 };
 
-- 
2.26.3

