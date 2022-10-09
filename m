Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCDE65F91CD
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233346AbiJIWlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:41:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233473AbiJIWkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:40:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF9639125;
        Sun,  9 Oct 2022 15:21:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA00B60C19;
        Sun,  9 Oct 2022 22:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB89C43150;
        Sun,  9 Oct 2022 22:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354042;
        bh=wHSQTFmiYAKE7QPAJn4zsqtVARXl5twvNT9Y8ivQYV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HGZME2g8egreH6X5puAvkqlO0hcrxF6Jdm9OBZ+K0U/PssCt7XgdWh9mr/p1M97/T
         xWsUsdOOcBLjmlpHizU4lINiDZ4hSA+j+xhZBubsqoILUDS/2+5KeD3gF7P47YvWJe
         MWQJfp1teoXmQu5k1gKdY3Y2HTaHDnzLDws8j8mJ9E3zAzIS81XaIWKsP+pj8uTkf7
         VQsYZtK0p/rM2W0ibw1q9wO3rCzOV5bsCsW0UkO8cvN2zURnqXt365Eq1WDdRHyTmw
         3Udpo+YpQGWDkU+Yf/ROfLWlNnEuaD6J7MYXS1DLGNZNe/cKk4aP5yLtOprdfmNkHL
         pHKo/3XU/b4LQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ndesaulniers@google.com,
        wsa+renesas@sang-engineering.com, mw@semihalf.com, leon@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 28/46] net: korina: Fix return type of korina_send_packet
Date:   Sun,  9 Oct 2022 18:18:53 -0400
Message-Id: <20221009221912.1217372-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009221912.1217372-1-sashal@kernel.org>
References: <20221009221912.1217372-1-sashal@kernel.org>
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

[ Upstream commit 106c67ce46f3c82dd276e983668a91d6ed631173 ]

The ndo_start_xmit field in net_device_ops is expected to be of type
netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of korina_send_packet should be changed from int to
netdev_tx_t.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20220912214344.928925-1-nhuck@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/korina.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index 3e9f324f1061..2e6f51a0eab0 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -416,7 +416,8 @@ static void korina_abort_rx(struct net_device *dev)
 }
 
 /* transmit packet */
-static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t korina_send_packet(struct sk_buff *skb,
+				      struct net_device *dev)
 {
 	struct korina_private *lp = netdev_priv(dev);
 	u32 chain_prev, chain_next;
-- 
2.35.1

