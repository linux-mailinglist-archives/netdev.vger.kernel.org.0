Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB1A6501EE
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbiLRQj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:39:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232245AbiLRQix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:38:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A705817E2B;
        Sun, 18 Dec 2022 08:13:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E83C360DD4;
        Sun, 18 Dec 2022 16:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FADC433F0;
        Sun, 18 Dec 2022 16:13:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380016;
        bh=74oED/ABmW0A+X9spJM7GV1K+ZhLhsueqGtIF4eopHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TnCNjNS61mn+iRukovitPuoWYDMmSEBYF/s2dEOt/8aVc039U2ncU4RS0Rb4Pw8ba
         OKmqrziJQPr9nCfrBsELpeownwaCbkrZEmhY7AFEXWchbzfSvZCJl1PU83rSXNO8j1
         cG8moQhrY5MXBYwNy+gNxq6EkPi3CBG+wbXTzAcjgkl8VFpK54HfJMzEMoUqa/7Z4S
         ehRKBkwZnj1XG0fHhRD/Yidwy6QmhvKz4UmWx/WbNjv4MrtkeAR5XNtffO0q+Ltx8F
         Aqpaisdj5IeNWFyhhp47jkoEAiZDL1muwSi0p2EhjR6tG1OYgPYBcbPiUvW3e7o+wE
         oTYfd3dCcU8Gw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ndesaulniers@google.com,
        mkl@pengutronix.de, paul@xen.org, f.fainelli@gmail.com,
        colin.i.king@gmail.com, netdev@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 12/46] net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()
Date:   Sun, 18 Dec 2022 11:12:10 -0500
Message-Id: <20221218161244.930785-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161244.930785-1-sashal@kernel.org>
References: <20221218161244.930785-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 63fe6ff674a96cfcfc0fa8df1051a27aa31c70b4 ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
proposed warning in clang aims to catch these at compile time, which
reveals:

  drivers/net/ethernet/ti/netcp_core.c:1944:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .ndo_start_xmit         = netcp_ndo_start_xmit,
                                    ^~~~~~~~~~~~~~~~~~~~
  1 error generated.

->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
'netdev_tx_t', not 'int'. Adjust the return type of
netcp_ndo_start_xmit() to match the prototype's to resolve the warning
and CFI failure.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221102160933.1601260-1-nathan@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/netcp_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index eda2961c0fe2..07bdeece1723 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1262,7 +1262,7 @@ static int netcp_tx_submit_skb(struct netcp_intf *netcp,
 }
 
 /* Submit the packet */
-static int netcp_ndo_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t netcp_ndo_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct netcp_intf *netcp = netdev_priv(ndev);
 	struct netcp_stats *tx_stats = &netcp->stats;
-- 
2.35.1

