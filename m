Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E01B234EEC
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 02:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727813AbgHAAeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 20:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgHAAeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 20:34:11 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95263C06174A
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 17:34:11 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 74so6993633pfx.13
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 17:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=vymLDVnmjf2dZNOgHejVc58MeeM58v+rNayB+rP7H6c=;
        b=P61izT0kkZWIrtdjvyhZp4QAa3wR130ZuWAUauV//Wa31R7uU7SQcKysSAcCyuUVWN
         JlF+9Orjyj04uchZH1hHM6lHgKZfB22DxqubhcIUSwnwhhS3VIBcQAQQOIBDPl1kbsEG
         fNfIIUH32gNbEdysZhj0qR1lKJGU6hEE2jZOw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vymLDVnmjf2dZNOgHejVc58MeeM58v+rNayB+rP7H6c=;
        b=NFNB7sz7xTDzZR3QTdpihwqnOCniG+45LSNumlDeESn+3ZpKUxxuT+Pl0rCyDD7rWs
         uVl/JqONXtSz9725ANZQsyfKSOQ2b+ADsJWkoOD6eZEUeIHWzlsn//M9tY8oLzHNM2iC
         1jt9bUMO6lOeFAkMAVxZWFDk4VtPVenRfb14Oz1YkpGEW7GvZMW6/FUYgt5Q+9N3u760
         LzgaCxxkO6CLk94kb0s35XkSxlRkLFvd/BMnKbu5Td5w6kr4uKl7gUJ142xnXAKNh/u2
         QnBmcJWAg8m/KXDTnm6aIk96+JXFPcezYjw6vLc+CKFyWl8LGyRAL3TH/OCMolslhNW6
         Sj3Q==
X-Gm-Message-State: AOAM533JWp4QP5s/JhtNhZ5qFwMwC99+BugndcE9F4Z9GT0LhT5JNVRt
        +G1zdMy5hR41iMYJDHX0iohp5zfni08=
X-Google-Smtp-Source: ABdhPJyHxJFSeoAByMcYfC50kSgHKy8qmb/nDh949mF1JvftfRhJludNZN9MgseeL1wEt2yZxgp5wg==
X-Received: by 2002:a62:9254:: with SMTP id o81mr5771881pfd.73.1596242050862;
        Fri, 31 Jul 2020 17:34:10 -0700 (PDT)
Received: from monster-08.mvlab.cumulusnetworks.com. (fw.cumulusnetworks.com. [216.129.126.126])
        by smtp.googlemail.com with ESMTPSA id x127sm1979921pfd.86.2020.07.31.17.34.09
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 Jul 2020 17:34:10 -0700 (PDT)
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
X-Google-Original-From: Roopa Prabhu
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com
Subject: [PATCH net-next v2] rtnetlink: add support for protodown reason
Date:   Fri, 31 Jul 2020 17:34:01 -0700
Message-Id: <1596242041-14347-1-git-send-email-roopa@cumulusnetworks.com>
X-Mailer: git-send-email 2.1.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roopa Prabhu <roopa@cumulusnetworks.com>

netdev protodown is a mechanism that allows protocols to
hold an interface down. It was initially introduced in
the kernel to hold links down by a multihoming protocol.
There was also an attempt to introduce protodown
reason at the time but was rejected. protodown and protodown reason
is supported by almost every switching and routing platform.
It was ok for a while to live without a protodown reason.
But, its become more critical now given more than
one protocol may need to keep a link down on a system
at the same time. eg: vrrp peer node, port security,
multihoming protocol. Its common for Network operators and
protocol developers to look for such a reason on a networking
box (Its also known as errDisable by most networking operators)

This patch adds support for link protodown reason
attribute. There are two ways to maintain protodown
reasons.
(a) enumerate every possible reason code in kernel
    - A protocol developer has to make a request and
      have that appear in a certain kernel version
(b) provide the bits in the kernel, and allow user-space
(sysadmin or NOS distributions) to manage the bit-to-reasonname
map.
	- This makes extending reason codes easier (kind of like
      the iproute2 table to vrf-name map /etc/iproute2/rt_tables.d/)

This patch takes approach (b).

a few things about the patch:
- It treats the protodown reason bits as counter to indicate
active protodown users
- Since protodown attribute is already an exposed UAPI,
the reason is not enforced on a protodown set. Its a no-op
if not used.
the patch follows the below algorithm:
  - presence of reason bits set indicates protodown
    is in use
  - user can set protodown and protodown reason in a
    single or multiple setlink operations
  - setlink operation to clear protodown, will return -EBUSY
    if there are active protodown reason bits
  - reason is not included in link dumps if not used

example with patched iproute2:
$cat /etc/iproute2/protodown_reasons.d/r.conf
0 mlag
1 evpn
2 vrrp
3 psecurity

$ip link set dev vxlan0 protodown on protodown_reason vrrp on
$ip link set dev vxlan0 protodown_reason mlag on
$ip link show
14: vxlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode
DEFAULT group default qlen 1000
    link/ether f6:06:be:17:91:e7 brd ff:ff:ff:ff:ff:ff protodown on <mlag,vrrp>

$ip link set dev vxlan0 protodown_reason mlag off
$ip link set dev vxlan0 protodown off protodown_reason vrrp off

Signed-off-by: Roopa Prabhu <roopa@cumulusnetworks.com>
---
v2 - remove unnecessary helper dev_get_proto_down_reason
     - move dev->proto_down_reason to use an existing hole in struct net_device
 include/linux/netdevice.h    |   4 ++
 include/uapi/linux/if_link.h |  10 ++++
 net/core/dev.c               |  25 ++++++++++
 net/core/rtnetlink.c         | 113 +++++++++++++++++++++++++++++++++++++++++--
 4 files changed, 147 insertions(+), 5 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index ac2cd3f..ba0fa6b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2058,6 +2058,8 @@ struct net_device {
 	struct timer_list	watchdog_timer;
 	int			watchdog_timeo;
 
+	u32                     proto_down_reason;
+
 	struct list_head	todo_list;
 	int __percpu		*pcpu_refcnt;
 
@@ -3810,6 +3812,8 @@ int dev_get_port_parent_id(struct net_device *dev,
 bool netdev_port_same_parent_id(struct net_device *a, struct net_device *b);
 int dev_change_proto_down(struct net_device *dev, bool proto_down);
 int dev_change_proto_down_generic(struct net_device *dev, bool proto_down);
+void dev_change_proto_down_reason(struct net_device *dev, unsigned long mask,
+				  u32 value);
 struct sk_buff *validate_xmit_skb_list(struct sk_buff *skb, struct net_device *dev, bool *again);
 struct sk_buff *dev_hard_start_xmit(struct sk_buff *skb, struct net_device *dev,
 				    struct netdev_queue *txq, int *ret);
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 63af646..7fba4de 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -170,12 +170,22 @@ enum {
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
 	IFLA_PERM_ADDRESS,
+	IFLA_PROTO_DOWN_REASON,
 	__IFLA_MAX
 };
 
 
 #define IFLA_MAX (__IFLA_MAX - 1)
 
+enum {
+	IFLA_PROTO_DOWN_REASON_UNSPEC,
+	IFLA_PROTO_DOWN_REASON_MASK,	/* u32, mask for reason bits */
+	IFLA_PROTO_DOWN_REASON_VALUE,   /* u32, reason bit value */
+
+	__IFLA_PROTO_DOWN_REASON_CNT,
+	IFLA_PROTO_DOWN_REASON_MAX = __IFLA_PROTO_DOWN_REASON_CNT - 1
+};
+
 /* backwards compatibility for userspace */
 #ifndef __KERNEL__
 #define IFLA_RTA(r)  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct ifinfomsg))))
diff --git a/net/core/dev.c b/net/core/dev.c
index fe2e387..a1f18bb 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -8716,6 +8716,31 @@ int dev_change_proto_down_generic(struct net_device *dev, bool proto_down)
 }
 EXPORT_SYMBOL(dev_change_proto_down_generic);
 
+/**
+ *	dev_change_proto_down_reason - proto down reason
+ *
+ *	@dev: device
+ *	@mask: proto down mask
+ *	@value: proto down value
+ */
+void dev_change_proto_down_reason(struct net_device *dev, unsigned long mask,
+				  u32 value)
+{
+	int b;
+
+	if (!mask) {
+		dev->proto_down_reason = value;
+	} else {
+		for_each_set_bit(b, &mask, 32) {
+			if (value & (1 << b))
+				dev->proto_down_reason |= BIT(b);
+			else
+				dev->proto_down_reason &= ~BIT(b);
+		}
+	}
+}
+EXPORT_SYMBOL(dev_change_proto_down_reason);
+
 u32 __dev_xdp_query(struct net_device *dev, bpf_op_t bpf_op,
 		    enum bpf_netdev_command cmd)
 {
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 85a4b01..a54c3e0 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -1000,6 +1000,16 @@ static size_t rtnl_prop_list_size(const struct net_device *dev)
 	return size;
 }
 
+static size_t rtnl_proto_down_size(const struct net_device *dev)
+{
+	size_t size = nla_total_size(1);
+
+	if (dev->proto_down_reason)
+		size += nla_total_size(0) + nla_total_size(4);
+
+	return size;
+}
+
 static noinline size_t if_nlmsg_size(const struct net_device *dev,
 				     u32 ext_filter_mask)
 {
@@ -1041,7 +1051,7 @@ static noinline size_t if_nlmsg_size(const struct net_device *dev,
 	       + nla_total_size(4)  /* IFLA_EVENT */
 	       + nla_total_size(4)  /* IFLA_NEW_NETNSID */
 	       + nla_total_size(4)  /* IFLA_NEW_IFINDEX */
-	       + nla_total_size(1)  /* IFLA_PROTO_DOWN */
+	       + rtnl_proto_down_size(dev)  /* proto down */
 	       + nla_total_size(4)  /* IFLA_TARGET_NETNSID */
 	       + nla_total_size(4)  /* IFLA_CARRIER_UP_COUNT */
 	       + nla_total_size(4)  /* IFLA_CARRIER_DOWN_COUNT */
@@ -1658,6 +1668,35 @@ static int rtnl_fill_prop_list(struct sk_buff *skb,
 	return ret;
 }
 
+static int rtnl_fill_proto_down(struct sk_buff *skb,
+				const struct net_device *dev)
+{
+	struct nlattr *pr;
+	u32 preason;
+
+	if (nla_put_u8(skb, IFLA_PROTO_DOWN, dev->proto_down))
+		goto nla_put_failure;
+
+	preason = dev->proto_down_reason;
+	if (!preason)
+		return 0;
+
+	pr = nla_nest_start(skb, IFLA_PROTO_DOWN_REASON);
+	if (!pr)
+		return -EMSGSIZE;
+
+	if (nla_put_u32(skb, IFLA_PROTO_DOWN_REASON_VALUE, preason)) {
+		nla_nest_cancel(skb, pr);
+		goto nla_put_failure;
+	}
+
+	nla_nest_end(skb, pr);
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static int rtnl_fill_ifinfo(struct sk_buff *skb,
 			    struct net_device *dev, struct net *src_net,
 			    int type, u32 pid, u32 seq, u32 change,
@@ -1708,13 +1747,15 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb,
 	    nla_put_u32(skb, IFLA_CARRIER_CHANGES,
 			atomic_read(&dev->carrier_up_count) +
 			atomic_read(&dev->carrier_down_count)) ||
-	    nla_put_u8(skb, IFLA_PROTO_DOWN, dev->proto_down) ||
 	    nla_put_u32(skb, IFLA_CARRIER_UP_COUNT,
 			atomic_read(&dev->carrier_up_count)) ||
 	    nla_put_u32(skb, IFLA_CARRIER_DOWN_COUNT,
 			atomic_read(&dev->carrier_down_count)))
 		goto nla_put_failure;
 
+	if (rtnl_fill_proto_down(skb, dev))
+		goto nla_put_failure;
+
 	if (event != IFLA_EVENT_NONE) {
 		if (nla_put_u32(skb, IFLA_EVENT, event))
 			goto nla_put_failure;
@@ -1834,6 +1875,7 @@ static const struct nla_policy ifla_policy[IFLA_MAX+1] = {
 	[IFLA_ALT_IFNAME]	= { .type = NLA_STRING,
 				    .len = ALTIFNAMSIZ - 1 },
 	[IFLA_PERM_ADDRESS]	= { .type = NLA_REJECT },
+	[IFLA_PROTO_DOWN_REASON] = { .type = NLA_NESTED },
 };
 
 static const struct nla_policy ifla_info_policy[IFLA_INFO_MAX+1] = {
@@ -2483,6 +2525,67 @@ static int do_set_master(struct net_device *dev, int ifindex,
 	return 0;
 }
 
+static const struct nla_policy ifla_proto_down_reason_policy[IFLA_PROTO_DOWN_REASON_VALUE + 1] = {
+	[IFLA_PROTO_DOWN_REASON_MASK]	= { .type = NLA_U32 },
+	[IFLA_PROTO_DOWN_REASON_VALUE]	= { .type = NLA_U32 },
+};
+
+static int do_set_proto_down(struct net_device *dev,
+			     struct nlattr *nl_proto_down,
+			     struct nlattr *nl_proto_down_reason,
+			     struct netlink_ext_ack *extack)
+{
+	struct nlattr *pdreason[IFLA_PROTO_DOWN_REASON_MAX + 1];
+	const struct net_device_ops *ops = dev->netdev_ops;
+	unsigned long mask = 0;
+	u32 value;
+	bool proto_down;
+	int err;
+
+	if (!ops->ndo_change_proto_down) {
+		NL_SET_ERR_MSG(extack,  "Protodown not supported by device");
+		return -EOPNOTSUPP;
+	}
+
+	if (nl_proto_down_reason) {
+		err = nla_parse_nested_deprecated(pdreason,
+						  IFLA_PROTO_DOWN_REASON_MAX,
+						  nl_proto_down_reason,
+						  ifla_proto_down_reason_policy,
+						  NULL);
+		if (err < 0)
+			return err;
+
+		if (!pdreason[IFLA_PROTO_DOWN_REASON_VALUE]) {
+			NL_SET_ERR_MSG(extack, "Invalid protodown reason value");
+			return -EINVAL;
+		}
+
+		value = nla_get_u32(pdreason[IFLA_PROTO_DOWN_REASON_VALUE]);
+
+		if (pdreason[IFLA_PROTO_DOWN_REASON_MASK])
+			mask = nla_get_u32(pdreason[IFLA_PROTO_DOWN_REASON_MASK]);
+
+		dev_change_proto_down_reason(dev, mask, value);
+	}
+
+	if (nl_proto_down) {
+		proto_down = nla_get_u8(nl_proto_down);
+
+		/* Dont turn off protodown if there are active reasons */
+		if (!proto_down && dev->proto_down_reason) {
+			NL_SET_ERR_MSG(extack, "Cannot clear protodown, active reasons");
+			return -EBUSY;
+		}
+		err = dev_change_proto_down(dev,
+					    proto_down);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 #define DO_SETLINK_MODIFIED	0x01
 /* notify flag means notify + modified. */
 #define DO_SETLINK_NOTIFY	0x03
@@ -2771,9 +2874,9 @@ static int do_setlink(const struct sk_buff *skb,
 	}
 	err = 0;
 
-	if (tb[IFLA_PROTO_DOWN]) {
-		err = dev_change_proto_down(dev,
-					    nla_get_u8(tb[IFLA_PROTO_DOWN]));
+	if (tb[IFLA_PROTO_DOWN] || tb[IFLA_PROTO_DOWN_REASON]) {
+		err = do_set_proto_down(dev, tb[IFLA_PROTO_DOWN],
+					tb[IFLA_PROTO_DOWN_REASON], extack);
 		if (err)
 			goto errout;
 		status |= DO_SETLINK_NOTIFY;
-- 
2.1.4

