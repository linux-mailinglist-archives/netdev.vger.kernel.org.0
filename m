Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D856018A65C
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 22:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgCRVHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 17:07:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:53564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727589AbgCRUyK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:54:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0195520724;
        Wed, 18 Mar 2020 20:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564849;
        bh=xBOE+7Ra99qAzGVmvgHSfG1A656KnnXW9Gtqj1hXnE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pjhlSKq08UWbF05KEUnQEOATpghtM5pPNgM7lCY2ggd4f+7OYIB9lxHGxFuW2u9lb
         0tZhc/ib05xJmnXvLKEHM1Dl5Kb3kQTbxODNKMjqkB3Z+vo22hqC2aa+UEayEsrSPu
         81NKPLHQb9OletfMUXC1Pd9n0xhG6YVUvS51xF2Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 27/73] netfilter: nf_tables: fix infinite loop when expr is not available
Date:   Wed, 18 Mar 2020 16:52:51 -0400
Message-Id: <20200318205337.16279-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205337.16279-1-sashal@kernel.org>
References: <20200318205337.16279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 1d305ba40eb8081ff21eeb8ca6ba5c70fd920934 ]

nft will loop forever if the kernel doesn't support an expression:

1. nft_expr_type_get() appends the family specific name to the module list.
2. -EAGAIN is returned to nfnetlink, nfnetlink calls abort path.
3. abort path sets ->done to true and calls request_module for the
   expression.
4. nfnetlink replays the batch, we end up in nft_expr_type_get() again.
5. nft_expr_type_get attempts to append family-specific name. This
   one already exists on the list, so we continue
6. nft_expr_type_get adds the generic expression name to the module
   list. -EAGAIN is returned, nfnetlink calls abort path.
7. abort path encounters the family-specific expression which
   has 'done' set, so it gets removed.
8. abort path requests the generic expression name, sets done to true.
9. batch is replayed.

If the expression could not be loaded, then we will end up back at 1),
because the family-specific name got removed and the cycle starts again.

Note that userspace can SIGKILL the nft process to stop the cycle, but
the desired behaviour is to return an error after the generic expr name
fails to load the expression.

Fixes: eb014de4fd418 ("netfilter: nf_tables: autoload modules from the abort path")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bd76ef77c03f5..068daff41f6e6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6975,13 +6975,8 @@ static void nf_tables_module_autoload(struct net *net)
 	list_splice_init(&net->nft.module_list, &module_list);
 	mutex_unlock(&net->nft.commit_mutex);
 	list_for_each_entry_safe(req, next, &module_list, list) {
-		if (req->done) {
-			list_del(&req->list);
-			kfree(req);
-		} else {
-			request_module("%s", req->module);
-			req->done = true;
-		}
+		request_module("%s", req->module);
+		req->done = true;
 	}
 	mutex_lock(&net->nft.commit_mutex);
 	list_splice(&module_list, &net->nft.module_list);
@@ -7764,6 +7759,7 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	__nft_release_tables(net);
 	mutex_unlock(&net->nft.commit_mutex);
 	WARN_ON_ONCE(!list_empty(&net->nft.tables));
+	WARN_ON_ONCE(!list_empty(&net->nft.module_list));
 }
 
 static struct pernet_operations nf_tables_net_ops = {
-- 
2.20.1

