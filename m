Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D6020BFDF
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 09:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgF0Ho4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 03:44:56 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:48724 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725885AbgF0Ho4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Jun 2020 03:44:56 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C2FFD2E5E07A84A9C047;
        Sat, 27 Jun 2020 15:44:53 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Sat, 27 Jun 2020
 15:44:43 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <kuba@kernel.org>, <dsahern@gmail.com>,
        <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: ipv4: Fix wrong type conversion from hint to rt in ip_route_use_hint()
Date:   Sat, 27 Jun 2020 15:47:51 +0800
Message-ID: <1593244071-28291-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

We can't cast sk_buff to rtable by (struct rtable *)hint. Use skb_rtable().

Fixes: 02b24941619f ("ipv4: use dst hint for ipv4 list receive")

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 net/ipv4/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 1d7076b78e63..a01efa062f6b 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2027,7 +2027,7 @@ int ip_route_use_hint(struct sk_buff *skb, __be32 daddr, __be32 saddr,
 		      const struct sk_buff *hint)
 {
 	struct in_device *in_dev = __in_dev_get_rcu(dev);
-	struct rtable *rt = (struct rtable *)hint;
+	struct rtable *rt = skb_rtable(hint);
 	struct net *net = dev_net(dev);
 	int err = -EINVAL;
 	u32 tag = 0;
-- 
2.19.1

