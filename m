Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293F52B00D6
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 09:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgKLIGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 03:06:37 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:7884 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgKLIGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 03:06:36 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CWvLl74q1z75ts;
        Thu, 12 Nov 2020 16:06:23 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.487.0; Thu, 12 Nov 2020
 16:06:05 +0800
From:   Zhang Qilong <zhangqilong3@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>
Subject: [PATCH] ipv6: Fix error path to cancel the meseage
Date:   Thu, 12 Nov 2020 16:09:50 +0800
Message-ID: <20201112080950.1476302-1-zhangqilong3@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

genlmsg_cancel() needs to be called in the error path of
inet6_fill_ifmcaddr and inet6_fill_ifacaddr to cancel
the message.

Fixes: 203651b665f72 ("ipv6: add inet6_fill_args")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
---
 net/ipv6/addrconf.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 4211e960130c..eff2cacd5209 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5023,8 +5023,10 @@ static int inet6_fill_ifmcaddr(struct sk_buff *skb, struct ifmcaddr6 *ifmca,
 		return -EMSGSIZE;
 
 	if (args->netnsid >= 0 &&
-	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid))
+	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid)) {
+		nlmsg_cancel(skb, nlh);
 		return -EMSGSIZE;
+	}
 
 	put_ifaddrmsg(nlh, 128, IFA_F_PERMANENT, scope, ifindex);
 	if (nla_put_in6_addr(skb, IFA_MULTICAST, &ifmca->mca_addr) < 0 ||
@@ -5055,8 +5057,10 @@ static int inet6_fill_ifacaddr(struct sk_buff *skb, struct ifacaddr6 *ifaca,
 		return -EMSGSIZE;
 
 	if (args->netnsid >= 0 &&
-	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid))
+	    nla_put_s32(skb, IFA_TARGET_NETNSID, args->netnsid)) {
+		nlmsg_cancel(skb, nlh);
 		return -EMSGSIZE;
+	}
 
 	put_ifaddrmsg(nlh, 128, IFA_F_PERMANENT, scope, ifindex);
 	if (nla_put_in6_addr(skb, IFA_ANYCAST, &ifaca->aca_addr) < 0 ||
-- 
2.25.4

