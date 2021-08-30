Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965C53FB34A
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 11:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbhH3JkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 05:40:20 -0400
Received: from mail.netfilter.org ([217.70.188.207]:42608 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236129AbhH3JkB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 05:40:01 -0400
Received: from localhost.localdomain (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id B5D6A6003C;
        Mon, 30 Aug 2021 11:38:07 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 6/8] netfilter: ctnetlink: missing counters and timestamp in nfnetlink_{log,queue}
Date:   Mon, 30 Aug 2021 11:38:50 +0200
Message-Id: <20210830093852.21654-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210830093852.21654-1-pablo@netfilter.org>
References: <20210830093852.21654-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add counters and timestamps (if available) to the conntrack object
that is represented in nfnetlink_log and _queue messages.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_netlink.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 5008fa0891b3..5f9fc6b94855 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2669,6 +2669,8 @@ ctnetlink_glue_build_size(const struct nf_conn *ct)
 	       + nla_total_size(0) /* CTA_HELP */
 	       + nla_total_size(NF_CT_HELPER_NAME_LEN) /* CTA_HELP_NAME */
 	       + ctnetlink_secctx_size(ct)
+	       + ctnetlink_acct_size(ct)
+	       + ctnetlink_timestamp_size(ct)
 #if IS_ENABLED(CONFIG_NF_NAT)
 	       + 2 * nla_total_size(0) /* CTA_NAT_SEQ_ADJ_ORIG|REPL */
 	       + 6 * nla_total_size(sizeof(u_int32_t)) /* CTA_NAT_SEQ_OFFSET */
@@ -2726,6 +2728,10 @@ static int __ctnetlink_glue_build(struct sk_buff *skb, struct nf_conn *ct)
 	if (ctnetlink_dump_protoinfo(skb, ct, false) < 0)
 		goto nla_put_failure;
 
+	if (ctnetlink_dump_acct(skb, ct, IPCTNL_MSG_CT_GET) < 0 ||
+	    ctnetlink_dump_timestamp(skb, ct) < 0)
+		goto nla_put_failure;
+
 	if (ctnetlink_dump_helpinfo(skb, ct) < 0)
 		goto nla_put_failure;
 
-- 
2.20.1

