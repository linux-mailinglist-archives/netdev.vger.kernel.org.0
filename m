Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A94431F01
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 15:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbfFANTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Jun 2019 09:19:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:46446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728151AbfFANTP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Jun 2019 09:19:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4480255FF;
        Sat,  1 Jun 2019 13:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395154;
        bh=iAhwYOxkWlSvfVSnrLCFU2gNm87V3tU6asxy1IXvgBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTF+hzkUhI4tGr897dtaXsbK/RmLKfKcdCIJ4ZqAE9Nc2j1jMfZrq2aG5Yxo84rEW
         FNdOFJgIcJ30G2Rnvkdxizg7CG7iUTaFYCRWhdZNRoik2rs08UeLKBvtAxe40vtl88
         GfJ2PWRJ8B0vww2cRPItiDsy+x/X6T3/MRr2Eopw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Taehee Yoo <ap420073@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 069/186] netfilter: nf_flow_table: fix missing error check for rhashtable_insert_fast
Date:   Sat,  1 Jun 2019 09:14:45 -0400
Message-Id: <20190601131653.24205-69-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601131653.24205-1-sashal@kernel.org>
References: <20190601131653.24205-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 43c8f131184faf20c07221f3e09724611c6525d8 ]

rhashtable_insert_fast() may return an error value when memory
allocation fails, but flow_offload_add() does not check for errors.
This patch just adds missing error checking.

Fixes: ac2a66665e23 ("netfilter: add generic flow table infrastructure")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_flow_table_core.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 7aabfd4b1e50b..a9e4f74b1ff6e 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -185,14 +185,25 @@ static const struct rhashtable_params nf_flow_offload_rhash_params = {
 
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow)
 {
-	flow->timeout = (u32)jiffies;
+	int err;
 
-	rhashtable_insert_fast(&flow_table->rhashtable,
-			       &flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].node,
-			       nf_flow_offload_rhash_params);
-	rhashtable_insert_fast(&flow_table->rhashtable,
-			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
-			       nf_flow_offload_rhash_params);
+	err = rhashtable_insert_fast(&flow_table->rhashtable,
+				     &flow->tuplehash[0].node,
+				     nf_flow_offload_rhash_params);
+	if (err < 0)
+		return err;
+
+	err = rhashtable_insert_fast(&flow_table->rhashtable,
+				     &flow->tuplehash[1].node,
+				     nf_flow_offload_rhash_params);
+	if (err < 0) {
+		rhashtable_remove_fast(&flow_table->rhashtable,
+				       &flow->tuplehash[0].node,
+				       nf_flow_offload_rhash_params);
+		return err;
+	}
+
+	flow->timeout = (u32)jiffies;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(flow_offload_add);
-- 
2.20.1

