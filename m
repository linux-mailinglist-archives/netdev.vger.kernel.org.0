Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF493E2D5B
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 17:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244049AbhHFPMa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 11:12:30 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33838 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243279AbhHFPMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 11:12:22 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id DCFFA60057;
        Fri,  6 Aug 2021 17:11:27 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 9/9] netfilter: nfnetlink_hook: translate inet ingress to netdev
Date:   Fri,  6 Aug 2021 17:11:49 +0200
Message-Id: <20210806151149.6356-10-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210806151149.6356-1-pablo@netfilter.org>
References: <20210806151149.6356-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NFPROTO_INET pseudofamily is not exposed through this new netlink
interface. The netlink dump either shows NFPROTO_IPV4 or NFPROTO_IPV6
for NFPROTO_INET prerouting/input/forward/output/postrouting hooks.
The NFNLA_CHAIN_FAMILY attribute provides the family chain, which
specifies if this hook applies to inet traffic only (either IPv4 or
IPv6).

Translate the inet/ingress hook to netdev/ingress to fully hide the
NFPROTO_INET implementation details.

Fixes: e2cf17d3774c ("netfilter: add new hook nfnl subsystem")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_hook.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index 32eea785ae25..f554e2ea32ee 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -119,6 +119,7 @@ static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 	unsigned int portid = NETLINK_CB(nlskb).portid;
 	struct nlmsghdr *nlh;
 	int ret = -EMSGSIZE;
+	u32 hooknum;
 #ifdef CONFIG_KALLSYMS
 	char sym[KSYM_SYMBOL_LEN];
 	char *module_name;
@@ -156,7 +157,12 @@ static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 		goto nla_put_failure;
 #endif
 
-	ret = nla_put_be32(nlskb, NFNLA_HOOK_HOOKNUM, htonl(ops->hooknum));
+	if (ops->pf == NFPROTO_INET && ops->hooknum == NF_INET_INGRESS)
+		hooknum = NF_NETDEV_INGRESS;
+	else
+		hooknum = ops->hooknum;
+
+	ret = nla_put_be32(nlskb, NFNLA_HOOK_HOOKNUM, htonl(hooknum));
 	if (ret)
 		goto nla_put_failure;
 
-- 
2.20.1

