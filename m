Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33B6D59485
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 08:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbfF1G7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 02:59:52 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:51076 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726574AbfF1G7v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 02:59:51 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 54038D01547FC815F27D;
        Fri, 28 Jun 2019 14:59:48 +0800 (CST)
Received: from huawei.com (10.175.100.202) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Fri, 28 Jun 2019
 14:59:41 +0800
From:   Miaohe Lin <linmiaohe@huawei.com>
To:     <pablo@netfilter.org>, <kadlec@blackhole.kfki.hu>, <fw@strlen.de>,
        <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <netfilter-devel@vger.kernel.org>,
        <coreteam@netfilter.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <linmiaohe@huawei.com>, <mingfangsen@huawei.com>
Subject: [PATCH v4] net: netfilter: Fix rpfilter dropping vrf packets by mistake
Date:   Fri, 28 Jun 2019 09:06:43 +0000
Message-ID: <1561712803-195184-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.100.202]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When firewalld is enabled with ipv4/ipv6 rpfilter, vrf
ipv4/ipv6 packets will be dropped. Vrf device will pass
through netfilter hook twice. One with enslaved device
and another one with l3 master device. So in device may
dismatch witch out device because out device is always
enslaved device.So failed with the check of the rpfilter
and drop the packets by mistake.

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/ipv4/netfilter/ipt_rpfilter.c  | 1 +
 net/ipv6/netfilter/ip6t_rpfilter.c | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index 59031670b16a..cc23f1ce239c 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -78,6 +78,7 @@ static bool rpfilter_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	flow.flowi4_mark = info->flags & XT_RPFILTER_VALID_MARK ? skb->mark : 0;
 	flow.flowi4_tos = RT_TOS(iph->tos);
 	flow.flowi4_scope = RT_SCOPE_UNIVERSE;
+	flow.flowi4_oif = l3mdev_master_ifindex_rcu(xt_in(par));
 
 	return rpfilter_lookup_reverse(xt_net(par), &flow, xt_in(par), info->flags) ^ invert;
 }
diff --git a/net/ipv6/netfilter/ip6t_rpfilter.c b/net/ipv6/netfilter/ip6t_rpfilter.c
index 6bcaf7357183..3c4a1772c15f 100644
--- a/net/ipv6/netfilter/ip6t_rpfilter.c
+++ b/net/ipv6/netfilter/ip6t_rpfilter.c
@@ -55,6 +55,10 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 	if (rpfilter_addr_linklocal(&iph->saddr)) {
 		lookup_flags |= RT6_LOOKUP_F_IFACE;
 		fl6.flowi6_oif = dev->ifindex;
+	/* Set flowi6_oif for vrf devices to lookup route in l3mdev domain. */
+	} else if (netif_is_l3_master(dev) || netif_is_l3_slave(dev)) {
+		lookup_flags |= FLOWI_FLAG_SKIP_NH_OIF;
+		fl6.flowi6_oif = dev->ifindex;
 	} else if ((flags & XT_RPFILTER_LOOSE) == 0)
 		fl6.flowi6_oif = dev->ifindex;
 
@@ -70,7 +74,9 @@ static bool rpfilter_lookup_reverse6(struct net *net, const struct sk_buff *skb,
 		goto out;
 	}
 
-	if (rt->rt6i_idev->dev == dev || (flags & XT_RPFILTER_LOOSE))
+	if (rt->rt6i_idev->dev == dev ||
+	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) == dev->ifindex ||
+	    (flags & XT_RPFILTER_LOOSE))
 		ret = true;
  out:
 	ip6_rt_put(rt);
-- 
2.21.GIT

