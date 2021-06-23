Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 134EA3B1F34
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 19:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230205AbhFWRFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 13:05:36 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33558 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbhFWRFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 13:05:32 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 441D064275;
        Wed, 23 Jun 2021 19:01:48 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 6/6] netfilter: nfnetlink_hook: fix check for snprintf() overflow
Date:   Wed, 23 Jun 2021 19:03:01 +0200
Message-Id: <20210623170301.59973-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210623170301.59973-1-pablo@netfilter.org>
References: <20210623170301.59973-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

The kernel version of snprintf() can't return negatives.  The
"ret > (int)sizeof(sym)" check is off by one because and it should be
>=.  Finally, we need to set a negative error code.

Fixes: e2cf17d3774c ("netfilter: add new hook nfnl subsystem")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_hook.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nfnetlink_hook.c b/net/netfilter/nfnetlink_hook.c
index 58fda6ac663b..50b4e3c9347a 100644
--- a/net/netfilter/nfnetlink_hook.c
+++ b/net/netfilter/nfnetlink_hook.c
@@ -126,8 +126,10 @@ static int nfnl_hook_dump_one(struct sk_buff *nlskb,
 
 #ifdef CONFIG_KALLSYMS
 	ret = snprintf(sym, sizeof(sym), "%ps", ops->hook);
-	if (ret < 0 || ret > (int)sizeof(sym))
+	if (ret >= sizeof(sym)) {
+		ret = -EINVAL;
 		goto nla_put_failure;
+	}
 
 	module_name = strstr(sym, " [");
 	if (module_name) {
-- 
2.30.2

