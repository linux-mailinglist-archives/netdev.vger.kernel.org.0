Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 344953411EC
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 02:07:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232491AbhCSBGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 21:06:36 -0400
Received: from mail.netfilter.org ([217.70.188.207]:52604 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbhCSBGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 21:06:19 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id CDA3C630BF;
        Fri, 19 Mar 2021 02:06:14 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 4/9] netfilter: ctnetlink: fix dump of the expect mask attribute
Date:   Fri, 19 Mar 2021 02:06:03 +0100
Message-Id: <20210319010608.9758-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210319010608.9758-1-pablo@netfilter.org>
References: <20210319010608.9758-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Before this change, the mask is never included in the netlink message, so
"conntrack -E expect" always prints 0.0.0.0.

In older kernels the l3num callback struct was passed as argument, based
on tuple->src.l3num. After the l3num indirection got removed, the call
chain is based on m.src.l3num, but this value is 0xffff.

Init l3num to the correct value.

Fixes: f957be9d349a3 ("netfilter: conntrack: remove ctnetlink callbacks from l3 protocol trackers")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 1469365bac7e..1d519b0e51a5 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2962,6 +2962,7 @@ static int ctnetlink_exp_dump_mask(struct sk_buff *skb,
 	memset(&m, 0xFF, sizeof(m));
 	memcpy(&m.src.u3, &mask->src.u3, sizeof(m.src.u3));
 	m.src.u.all = mask->src.u.all;
+	m.src.l3num = tuple->src.l3num;
 	m.dst.protonum = tuple->dst.protonum;
 
 	nest_parms = nla_nest_start(skb, CTA_EXPECT_MASK);
-- 
2.20.1

