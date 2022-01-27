Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8573F49EF04
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 00:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343670AbiA0Xwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 18:52:42 -0500
Received: from mail.netfilter.org ([217.70.188.207]:42998 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343818AbiA0Xwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 18:52:41 -0500
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 07D7860866;
        Fri, 28 Jan 2022 00:49:36 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/8] netfilter: nft_ct: fix use after free when attaching zone template
Date:   Fri, 28 Jan 2022 00:52:29 +0100
Message-Id: <20220127235235.656931-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220127235235.656931-1-pablo@netfilter.org>
References: <20220127235235.656931-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

The conversion erroneously removed the refcount increment.
In case we can use the percpu template, we need to increment
the refcount, else it will be released when the skb gets freed.

In case the slowpath is taken, the new template already has a
refcount of 1.

Fixes: 719774377622 ("netfilter: conntrack: convert to refcount_t api")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_ct.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 518d96c8c247..5adf8bb628a8 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -260,9 +260,12 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 	ct = this_cpu_read(nft_ct_pcpu_template);
 
 	if (likely(refcount_read(&ct->ct_general.use) == 1)) {
+		refcount_inc(&ct->ct_general.use);
 		nf_ct_zone_add(ct, &zone);
 	} else {
-		/* previous skb got queued to userspace */
+		/* previous skb got queued to userspace, allocate temporary
+		 * one until percpu template can be reused.
+		 */
 		ct = nf_ct_tmpl_alloc(nft_net(pkt), &zone, GFP_ATOMIC);
 		if (!ct) {
 			regs->verdict.code = NF_DROP;
-- 
2.30.2

