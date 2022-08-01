Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8FE5870E5
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 21:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234475AbiHATEd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 15:04:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbiHATDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 15:03:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051693D5A7;
        Mon,  1 Aug 2022 12:03:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE0CFB8164E;
        Mon,  1 Aug 2022 19:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72FDFC43143;
        Mon,  1 Aug 2022 19:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659380577;
        bh=XT9CHCBcznGP4xGSJkutbZroW4zBQE9uHUyLtAnoH9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QPIRw5yaolHjXP5UG7oCLmeBRuzYfC1/YIvCDIIOCtjnRl487yT2a4eg8HPFp589F
         74dwNwdh2qmkznzMCaqp4vPvIqfI45heHbqim/KCGWfw5gN+SbbPnxEvMlhUivp+Ym
         jnBIh2EAFWk2NxkJkp6XHi8odwfN7RRZsclL3SyI8yoYj061o21JITZ4LVZYpsQ6ay
         GDHB/zzXPaLWX4RMJ7yDzgklaXZ2oXdaB0zOjjBpjKmmOMtzPjE45A0MdyZV3RNtJr
         2YFA3WP1XFrJPLGrLdK4FIOTIRqZw83F5JbgniGGBosvVm0fohjaHmZyn/HeLAaMIJ
         TotXDJpD3ElVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, kadlec@netfilter.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 7/8] netfilter: nf_tables: add rescheduling points during loop detection walks
Date:   Mon,  1 Aug 2022 15:02:42 -0400
Message-Id: <20220801190243.3818811-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220801190243.3818811-1-sashal@kernel.org>
References: <20220801190243.3818811-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 81ea010667417ef3f218dfd99b69769fe66c2b67 ]

Add explicit rescheduling points during ruleset walk.

Switching to a faster algorithm is possible but this is a much
smaller change, suitable for nf tree.

Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1460
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a32acf056e32..5e1520d82876 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3245,6 +3245,8 @@ int nft_chain_validate(const struct nft_ctx *ctx, const struct nft_chain *chain)
 			if (err < 0)
 				return err;
 		}
+
+		cond_resched();
 	}
 
 	return 0;
@@ -9217,9 +9219,13 @@ static int nf_tables_check_loops(const struct nft_ctx *ctx,
 				break;
 			}
 		}
+
+		cond_resched();
 	}
 
 	list_for_each_entry(set, &ctx->table->sets, list) {
+		cond_resched();
+
 		if (!nft_is_active_next(ctx->net, set))
 			continue;
 		if (!(set->flags & NFT_SET_MAP) ||
-- 
2.35.1

