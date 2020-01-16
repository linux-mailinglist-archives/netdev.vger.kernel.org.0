Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20FA313E214
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 17:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731019AbgAPQxc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 11:53:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:37370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730990AbgAPQxb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 830772081E;
        Thu, 16 Jan 2020 16:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193610;
        bh=eNmW3pak0Drwu2Uzw7tfRv/DSDXFQ0oyshwD7EuwO7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a0xvzTnptSsvsGF31fqsHPknl3opuXHH4epehEz3UmVfJt5snPfCca0uSsH3XCkHP
         VhOIhqTi9qlSGETbXLVOxuoJIg2eJa6Fkf69eWzaZKtTB3rNBHIMI6LJ/zEV3f569f
         NoEOFeYWx8EPeIYi8Aoa08GdWoWYT3CIJBdtJWkA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 148/205] netfilter: nf_tables_offload: release flow_rule on error from commit path
Date:   Thu, 16 Jan 2020 11:42:03 -0500
Message-Id: <20200116164300.6705-148-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 23403cd8898dbc9808d3eb2f63bc1db8a340b751 ]

If hardware offload commit path fails, release all flow_rule objects.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_offload.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index e743f811245f..96a64e7594a5 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -358,14 +358,14 @@ int nft_flow_rule_offload_commit(struct net *net)
 				continue;
 
 			if (trans->ctx.flags & NLM_F_REPLACE ||
-			    !(trans->ctx.flags & NLM_F_APPEND))
-				return -EOPNOTSUPP;
-
+			    !(trans->ctx.flags & NLM_F_APPEND)) {
+				err = -EOPNOTSUPP;
+				break;
+			}
 			err = nft_flow_offload_rule(trans->ctx.chain,
 						    nft_trans_rule(trans),
 						    nft_trans_flow_rule(trans),
 						    FLOW_CLS_REPLACE);
-			nft_flow_rule_destroy(nft_trans_flow_rule(trans));
 			break;
 		case NFT_MSG_DELRULE:
 			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
@@ -379,7 +379,23 @@ int nft_flow_rule_offload_commit(struct net *net)
 		}
 
 		if (err)
-			return err;
+			break;
+	}
+
+	list_for_each_entry(trans, &net->nft.commit_list, list) {
+		if (trans->ctx.family != NFPROTO_NETDEV)
+			continue;
+
+		switch (trans->msg_type) {
+		case NFT_MSG_NEWRULE:
+			if (!(trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD))
+				continue;
+
+			nft_flow_rule_destroy(nft_trans_flow_rule(trans));
+			break;
+		default:
+			break;
+		}
 	}
 
 	return err;
-- 
2.20.1

