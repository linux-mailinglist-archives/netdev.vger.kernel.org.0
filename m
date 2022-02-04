Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0ECA4A9BD3
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 16:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359648AbiBDPTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 10:19:23 -0500
Received: from mail.netfilter.org ([217.70.188.207]:50404 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359633AbiBDPTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 10:19:18 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id A3B24601A3;
        Fri,  4 Feb 2022 16:19:11 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 6/6] netfilter: ctnetlink: disable helper autoassign
Date:   Fri,  4 Feb 2022 16:19:03 +0100
Message-Id: <20220204151903.320786-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220204151903.320786-1-pablo@netfilter.org>
References: <20220204151903.320786-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

When userspace, e.g. conntrackd, inserts an entry with a specified helper,
its possible that the helper is lost immediately after its added:

ctnetlink_create_conntrack
  -> nf_ct_helper_ext_add + assign helper
    -> ctnetlink_setup_nat
      -> ctnetlink_parse_nat_setup
         -> parse_nat_setup -> nfnetlink_parse_nat_setup
	                       -> nf_nat_setup_info
                                 -> nf_conntrack_alter_reply
                                   -> __nf_ct_try_assign_helper

... and __nf_ct_try_assign_helper will zero the helper again.

Set IPS_HELPER bit to bypass auto-assign logic, its unwanted, just like
when helper is assigned via ruleset.

Dropped old 'not strictly necessary' comment, it referred to use of
rcu_assign_pointer() before it got replaced by RCU_INIT_POINTER().

NB: Fixes tag intentionally incorrect, this extends the referenced commit,
but this change won't build without IPS_HELPER introduced there.

Fixes: 6714cf5465d280 ("netfilter: nf_conntrack: fix explicit helper attachment and NAT")
Reported-by: Pham Thanh Tuyen <phamtyn@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_conntrack_common.h | 2 +-
 net/netfilter/nf_conntrack_netlink.c               | 3 ++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_conntrack_common.h b/include/uapi/linux/netfilter/nf_conntrack_common.h
index 4b3395082d15..26071021e986 100644
--- a/include/uapi/linux/netfilter/nf_conntrack_common.h
+++ b/include/uapi/linux/netfilter/nf_conntrack_common.h
@@ -106,7 +106,7 @@ enum ip_conntrack_status {
 	IPS_NAT_CLASH = IPS_UNTRACKED,
 #endif
 
-	/* Conntrack got a helper explicitly attached via CT target. */
+	/* Conntrack got a helper explicitly attached (ruleset, ctnetlink). */
 	IPS_HELPER_BIT = 13,
 	IPS_HELPER = (1 << IPS_HELPER_BIT),
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ac438370f94a..7032402ffd33 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2311,7 +2311,8 @@ ctnetlink_create_conntrack(struct net *net,
 			if (helper->from_nlattr)
 				helper->from_nlattr(helpinfo, ct);
 
-			/* not in hash table yet so not strictly necessary */
+			/* disable helper auto-assignment for this entry */
+			ct->status |= IPS_HELPER;
 			RCU_INIT_POINTER(help->helper, helper);
 		}
 	} else {
-- 
2.30.2

