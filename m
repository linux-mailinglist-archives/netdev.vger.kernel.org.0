Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF1F6503E5
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 18:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233612AbiLRRJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 12:09:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbiLRRHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 12:07:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 332FB1E3EB;
        Sun, 18 Dec 2022 08:23:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEB47B803F1;
        Sun, 18 Dec 2022 16:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CFFDC433EF;
        Sun, 18 Dec 2022 16:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380597;
        bh=IiznI6s7z6AJ6dUU8a+7Bqq7FFsj2KoatyvFS47s3fA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WdeHzq/xs9ISBrwVpKAK4chvIPscD7WMOAnl5e1gpaBFqIBcLMzDYiBabTKpjpvBn
         GD+2WQ3e2FDICoj7Wk4Ewk+03oNQ5KDwrQREQusUjEHxkraihP61Yw18nGxNWbT28i
         gJcg2OfJEhP6UH/bILoG7vxjph1fKcE5Brc2frWsVEF03qCCGDXr4tQmgjfzw7P+oa
         xHyBO15Nn9d/1p3KhGRw0Sekyd2XgwdHh7fbubVDtWBdX8JSa1Oqa6rNdQ3uP7o5/9
         dMjsMSUQJY8+gj9XyEmrgOb648BNMSOiDnzS3wXYXrj93gYqCJnZPMhqrp/tZ8T+lc
         BGRZ+h9UVmUzw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ndesaulniers@google.com,
        wintera@linux.ibm.com, mkl@pengutronix.de, f.fainelli@gmail.com,
        colin.i.king@gmail.com, netdev@vger.kernel.org,
        llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 4.9 04/20] net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()
Date:   Sun, 18 Dec 2022 11:22:49 -0500
Message-Id: <20221218162305.935724-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218162305.935724-1-sashal@kernel.org>
References: <20221218162305.935724-1-sashal@kernel.org>
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
index c17967b23d3c..957701d48712 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1237,7 +1237,7 @@ static int netcp_tx_submit_skb(struct netcp_intf *netcp,
 }
 
 /* Submit the packet */
-static int netcp_ndo_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t netcp_ndo_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct netcp_intf *netcp = netdev_priv(ndev);
 	int subqueue = skb_get_queue_mapping(skb);
-- 
2.35.1

