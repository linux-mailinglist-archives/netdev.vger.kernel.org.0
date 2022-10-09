Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624275F92C9
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbiJIWvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233333AbiJIWts (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:49:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77BF13B943;
        Sun,  9 Oct 2022 15:26:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EB9AB80DD1;
        Sun,  9 Oct 2022 22:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AF8C433C1;
        Sun,  9 Oct 2022 22:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665354236;
        bh=0G7pgzAbm2+9YR5/tmvia7bob4tC2qyNvnsTbTuBWPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyE2OdN4qkDH8PrBwfJFAM1VCb7QNAaDMdrlpp27wg3y2sU5QqUueWe6MEHg6WwS5
         R/sgg41xtCxbvqOPU5ZwIEGtWCJSCrIaeITDpZDl4yVVLOvGYLzVZYEl+CChIpD0x2
         x+YOvjhzQpAZaA6pJjFBfyzYOM+JaB3Qb7sleiGkxcUaJ4u/ougkNANM+P8GJQuPHB
         kOnMmZF+P08l769uwRos40Bbv0l/WnzrMDvk67pn65UVCfvLnUk094MHokwBzf2JCh
         NSQ2/2S4btcZS7lGDqdWDIDWLDOQfp0nRkJ37JLJCJ3X0U2ILWgRiyc0KlRptrV054
         y51CrhbQNYSqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, ndesaulniers@google.com,
        leon@kernel.org, mkl@pengutronix.de, khalasa@piap.pl,
        wsa+renesas@sang-engineering.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 16/29] net: korina: Fix return type of korina_send_packet
Date:   Sun,  9 Oct 2022 18:22:51 -0400
Message-Id: <20221009222304.1218873-16-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221009222304.1218873-1-sashal@kernel.org>
References: <20221009222304.1218873-1-sashal@kernel.org>
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
index 9f804e2aba35..d1bd56f6eecb 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -196,7 +196,8 @@ static void korina_chain_rx(struct korina_private *lp,
 }
 
 /* transmit packet */
-static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t korina_send_packet(struct sk_buff *skb,
+				      struct net_device *dev)
 {
 	struct korina_private *lp = netdev_priv(dev);
 	unsigned long flags;
-- 
2.35.1

