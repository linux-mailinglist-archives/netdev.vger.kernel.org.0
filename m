Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF2026C56B8
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 21:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbjCVUIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 16:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231840AbjCVUIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 16:08:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379696B963;
        Wed, 22 Mar 2023 13:02:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F17CB81DF0;
        Wed, 22 Mar 2023 20:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D72EC433D2;
        Wed, 22 Mar 2023 20:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515297;
        bh=+RT9YDSEttzIAMfCnD12uEqbt4kxuriKcntVTxpdabg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=da8pCG7z1lM79EWn0EcwM8xNmLFe7SFCzddM9HQY12c3tK4z02A+jhzfoQ7fSFsBS
         isIf1vs+FmMJZpwf6xWCm9ZGQDeh+Rk5p2aeoP5yPXKEgwN3KiatD8jcChBonSYg2e
         3uO6m5ZfzEIAfLq7tzXY7TQMKR+lHZ+ytbyPM5VM9HkEJZm4pSkImhzREKez476oYt
         dsic++7gahy8Ld6WutH4GlrsILq/TFAvk1m8Yc+ej+Wl/5SwpMEEdxrhNmYylOhdP6
         Jichjgt7Hp83dfVfJi1KDBg1VfKwL0FThvfAjRtVDkHZ9fUBJ+6bKUw14KlHoqTnIa
         zNlQrkFkiXPEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kristian Overskeid <koverskeid@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, bigeasy@linutronix.de,
        kurt@linutronix.de, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 05/16] net: hsr: Don't log netdev_err message on unknown prp dst node
Date:   Wed, 22 Mar 2023 16:01:09 -0400
Message-Id: <20230322200121.1997157-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230322200121.1997157-1-sashal@kernel.org>
References: <20230322200121.1997157-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kristian Overskeid <koverskeid@gmail.com>

[ Upstream commit 28e8cabe80f3e6e3c98121576eda898eeb20f1b1 ]

If no frames has been exchanged with a node for HSR_NODE_FORGET_TIME, the
node will be deleted from the node_db list. If a frame is sent to the node
after it is deleted, a netdev_err message for each slave interface is
produced. This should not happen with dan nodes because of supervision
frames, but can happen often with san nodes, which clutters the kernel
log. Since the hsr protocol does not support sans, this is only relevant
for the prp protocol.

Signed-off-by: Kristian Overskeid <koverskeid@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_framereg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
index 414bf4d3d3c92..44eb9c9f80ee9 100644
--- a/net/hsr/hsr_framereg.c
+++ b/net/hsr/hsr_framereg.c
@@ -385,7 +385,7 @@ void hsr_addr_subst_dest(struct hsr_node *node_src, struct sk_buff *skb,
 	node_dst = find_node_by_addr_A(&port->hsr->node_db,
 				       eth_hdr(skb)->h_dest);
 	if (!node_dst) {
-		if (net_ratelimit())
+		if (net_ratelimit() && port->hsr->prot_version != PRP_V1)
 			netdev_err(skb->dev, "%s: Unknown node\n", __func__);
 		return;
 	}
-- 
2.39.2

