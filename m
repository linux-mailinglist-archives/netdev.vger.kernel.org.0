Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5AF25F9064
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231664AbiJIWYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:24:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbiJIWXe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:23:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B7011140;
        Sun,  9 Oct 2022 15:18:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8CD1760CBB;
        Sun,  9 Oct 2022 22:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53D4AC433D7;
        Sun,  9 Oct 2022 22:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353876;
        bh=EV1aWa0RnASqulCvNKmsejHYmsYcScF6Ye+v3g617V4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PpzVxBFAoLhEEEYVE7mi4+Mzl9uG4TfofoRl7o/brAfdjBa0jV/pD0NXb35GIHpoA
         Ebyq7vSODjgxC7TEVvxuAFy1se2ShlI8yBTM04ta8XdIG30jPagQEOqOjzFwl9eK/Y
         5RMpaaQ0CUIzubukNwQekRpfO7LXtbXtQdQNuYbAuOa7XGpv6OWwpl7s7HKlrXw5B3
         sPbHM7ld5VPz9eBHJ3tpZVG0HHCTRMSE2oFAZeP2f30NhUZQE6pcoOzfZ1yg+IOCvX
         6dx2j3hym6NqyPj2O1mLMnR8i05OmuSm5XoXRHoyip9khe1xpstb3uguvykP2Px8Cs
         zECapGFVWeprQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        chandrashekar.devegowda@intel.com, linuxwwan@intel.com,
        loic.poulain@linaro.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 48/73] net: wwan: t7xx: Fix return type of t7xx_ccmni_start_xmit
Date:   Sun,  9 Oct 2022 18:14:26 -0400
Message-Id: <20221009221453.1216158-48-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221453.1216158-1-sashal@kernel.org>
References: <20221009221453.1216158-1-sashal@kernel.org>
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

From: Nathan Huckleberry <nhuck@google.com>

[ Upstream commit 73c99e26036529e633a0f2d628ad7ddff6594668 ]

The ndo_start_xmit field in net_device_ops is expected to be of type
netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of t7xx_ccmni_start_xmit should be changed from int to
netdev_tx_t.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Acked-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Link: https://lore.kernel.org/r/20220912214510.929070-1-nhuck@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wwan/t7xx/t7xx_netdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wwan/t7xx/t7xx_netdev.c b/drivers/net/wwan/t7xx/t7xx_netdev.c
index c6b6547f2c6f..f71d3bc3b237 100644
--- a/drivers/net/wwan/t7xx/t7xx_netdev.c
+++ b/drivers/net/wwan/t7xx/t7xx_netdev.c
@@ -74,7 +74,7 @@ static int t7xx_ccmni_send_packet(struct t7xx_ccmni *ccmni, struct sk_buff *skb,
 	return 0;
 }
 
-static int t7xx_ccmni_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t t7xx_ccmni_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct t7xx_ccmni *ccmni = wwan_netdev_drvpriv(dev);
 	int skb_len = skb->len;
-- 
2.35.1

