Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30C83935D3
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 21:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236332AbhE0TDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 15:03:04 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38828 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236108AbhE0TC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 15:02:57 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id C246B64502;
        Thu, 27 May 2021 21:00:20 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 2/5] netfilter: nf_tables: missing error reporting for not selected expressions
Date:   Thu, 27 May 2021 21:01:12 +0200
Message-Id: <20210527190115.98503-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210527190115.98503-1-pablo@netfilter.org>
References: <20210527190115.98503-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometimes users forget to turn on nftables extensions from Kconfig that
they need. In such case, the error reporting from userspace is
misleading:

 $ sudo nft add rule x y counter
 Error: Could not process rule: No such file or directory
 add rule x y counter
 ^^^^^^^^^^^^^^^^^^^^

Add missing NL_SET_BAD_ATTR() to provide a hint:

 $ nft add rule x y counter
 Error: Could not process rule: No such file or directory
 add rule x y counter
              ^^^^^^^

Fixes: 83d9dcba06c5 ("netfilter: nf_tables: extended netlink error reporting for expressions")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d63d2d8f769c..5a02b48af7fb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3328,8 +3328,10 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 			if (n == NFT_RULE_MAXEXPRS)
 				goto err1;
 			err = nf_tables_expr_parse(&ctx, tmp, &expr_info[n]);
-			if (err < 0)
+			if (err < 0) {
+				NL_SET_BAD_ATTR(extack, tmp);
 				goto err1;
+			}
 			size += expr_info[n].ops->size;
 			n++;
 		}
-- 
2.30.2

