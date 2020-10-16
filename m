Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1842328FC55
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 04:03:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732436AbgJPCC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 22:02:58 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:32966 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732262AbgJPCC5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 22:02:57 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0765457258D1EDBDBDE1;
        Fri, 16 Oct 2020 10:02:55 +0800 (CST)
Received: from DESKTOP-9883QJJ.china.huawei.com (10.136.114.155) by
 DGGEMS403-HUB.china.huawei.com (10.3.19.203) with Microsoft SMTP Server id
 14.3.487.0; Fri, 16 Oct 2020 10:02:48 +0800
From:   zhudi <zhudi21@huawei.com>
To:     <davem@davemloft.net>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>, <zhudi21@huawei.com>,
        <rose.chen@huawei.com>
Subject: [PATCH] rtnetlink: fix data overflow in rtnl_calcit()
Date:   Fri, 16 Oct 2020 10:02:38 +0800
Message-ID: <20201016020238.22445-1-zhudi21@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.136.114.155]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"ip addr show" command execute error when we have a physical
network card with number of VFs larger than 247.

The return value of if_nlmsg_size() in rtnl_calcit() will exceed
range of u16 data type when any network cards has a larger number of
VFs. rtnl_vfinfo_size() will significant increase needed dump size when
the value of num_vfs is larger.

Eventually we get a wrong value of min_ifinfo_dump_size because of overflow
which decides the memory size needed by netlink dump and netlink_dump()
will return -EMSGSIZE because of not enough memory was allocated.

So fix it by promoting  min_dump_alloc data type to u32 to
avoid data overflow and it's also align with the data type of
struct netlink_callback{}.min_dump_alloc which is assigned by
return value of rtnl_calcit()

Signed-off-by: zhudi <zhudi21@huawei.com>
---
 include/linux/netlink.h | 2 +-
 net/core/rtnetlink.c    | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index e3e49f0e5c13..0a7db41b9e42 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -230,7 +230,7 @@ struct netlink_dump_control {
 	int (*done)(struct netlink_callback *);
 	void *data;
 	struct module *module;
-	u16 min_dump_alloc;
+	u32 min_dump_alloc;
 };
 
 int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 68e0682450c6..b199137ddcdf 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3709,13 +3709,13 @@ static int rtnl_dellinkprop(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return rtnl_linkprop(RTM_DELLINKPROP, skb, nlh, extack);
 }
 
-static u16 rtnl_calcit(struct sk_buff *skb, struct nlmsghdr *nlh)
+static u32 rtnl_calcit(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
 	struct net *net = sock_net(skb->sk);
 	struct net_device *dev;
 	struct nlattr *tb[IFLA_MAX+1];
 	u32 ext_filter_mask = 0;
-	u16 min_ifinfo_dump_size = 0;
+	u32 min_ifinfo_dump_size = 0;
 	int hdrlen;
 
 	/* Same kernel<->userspace interface hack as in rtnl_dump_ifinfo. */
@@ -3735,7 +3735,7 @@ static u16 rtnl_calcit(struct sk_buff *skb, struct nlmsghdr *nlh)
 	 */
 	rcu_read_lock();
 	for_each_netdev_rcu(net, dev) {
-		min_ifinfo_dump_size = max_t(u16, min_ifinfo_dump_size,
+		min_ifinfo_dump_size = max_t(u32, min_ifinfo_dump_size,
 					     if_nlmsg_size(dev,
 						           ext_filter_mask));
 	}
@@ -5494,7 +5494,7 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (kind == 2 && nlh->nlmsg_flags&NLM_F_DUMP) {
 		struct sock *rtnl;
 		rtnl_dumpit_func dumpit;
-		u16 min_dump_alloc = 0;
+		u32 min_dump_alloc = 0;
 
 		link = rtnl_get_link(family, type);
 		if (!link || !link->dumpit) {
-- 
2.23.0

