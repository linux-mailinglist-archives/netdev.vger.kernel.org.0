Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD1074FC9C6
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 02:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243088AbiDLAsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 20:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243107AbiDLAsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 20:48:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D2A72F00C;
        Mon, 11 Apr 2022 17:45:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AB7E3CE185D;
        Tue, 12 Apr 2022 00:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7E5C385AB;
        Tue, 12 Apr 2022 00:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724351;
        bh=7XTqroqFO/okzB1xM2ykxMbeDx4n0Pp7JOnf+IK9yyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hsKZzoHiOHVk06o6JD/IFUOZm0Sm8j1e2eBlsKHVaZe4LMw/5xou47aLGnvNGFvi+
         PeRfNGzhak1PPa4xN/9WHacKg2fNY9vHK0DdRVAQmj8Q1cdOpcx4ZjWejxpVixFzSO
         qLKBrvu0EFvn+Z1LaZ1MwEJnIGuLCNj9rR+KON02tIVSRvxGvEhM7bS1+vrRETG9lW
         eNnzD0YT19nIQYJog3zugBO3cmpRHvcpbE6cw4hDwRSmRPhR9wZ9oxKgLNOdhED/kv
         tco3RRWl58cBClS78puFt81LHJ/9yV2EHzSdSQQW4LoxWNaGAPs+g1qZHcx704oK4v
         8qN466qc7KyRQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, christopher.lee@cspi.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 33/49] myri10ge: fix an incorrect free for skb in myri10ge_sw_tso
Date:   Mon, 11 Apr 2022 20:43:51 -0400
Message-Id: <20220412004411.349427-33-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004411.349427-1-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

[ Upstream commit b423e54ba965b4469b48e46fd16941f1e1701697 ]

All remaining skbs should be released when myri10ge_xmit fails to
transmit a packet. Fix it within another skb_list_walk_safe.

Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 50ac3ee2577a..21d2645885ce 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -2903,11 +2903,9 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
 		status = myri10ge_xmit(curr, dev);
 		if (status != 0) {
 			dev_kfree_skb_any(curr);
-			if (segs != NULL) {
-				curr = segs;
-				segs = next;
+			skb_list_walk_safe(next, curr, next) {
 				curr->next = NULL;
-				dev_kfree_skb_any(segs);
+				dev_kfree_skb_any(curr);
 			}
 			goto drop;
 		}
-- 
2.35.1

