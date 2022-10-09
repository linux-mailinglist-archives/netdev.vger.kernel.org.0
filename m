Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A985F90DA
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 00:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiJIW1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 18:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231934AbiJIW0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 18:26:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F45027CFB;
        Sun,  9 Oct 2022 15:18:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E43360C99;
        Sun,  9 Oct 2022 22:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7ABC4347C;
        Sun,  9 Oct 2022 22:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665353866;
        bh=cpkR3yihHCyaXTPeQQm/wMJ4ddFUjwbeXWAh0j03wr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+F/yduyDhaF4dE2ppZKC0z3zajKD4Mlk++x4H/mxS9WFAU4wz4TboNBpIxkaD/wx
         L5e11zv1RiaBCE+jDnQkdqLC9lkYyEaWh2tcnLCku8Osk90oMYMA7RdwYRLYquYZbQ
         /UyKg2FdMUnYjNrlKBHON7X2aGtaKMIiV1HxHNsq3ub4+k3aDSCAoLfw1I7D4ogMsn
         XgCbGxHpiREwS3TUcL6F0cBx6fWS5wt1Jtj/rchQ0vJ/5/wxHWM81Bjsk2JtdRhS7N
         bKtjoXsaC39mR2+ugl1NN7kF4sF7n4FCpA/zBGjpx6bj3NI9RdYl+J1K88Vx/8Jr8u
         VeoPXbvFfxRHA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>,
        Gabriel Somlo <gsomlo@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, kgugala@antmicro.com,
        mholenko@antmicro.com, joel@jms.id.au, ndesaulniers@google.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 45/73] net: ethernet: litex: Fix return type of liteeth_start_xmit
Date:   Sun,  9 Oct 2022 18:14:23 -0400
Message-Id: <20221009221453.1216158-45-sashal@kernel.org>
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

[ Upstream commit 40662333dd7c64664247a6138bc33f3974e3a331 ]

The ndo_start_xmit field in net_device_ops is expected to be of type
netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of liteeth_start_xmit should be changed from int to
netdev_tx_t.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Gabriel Somlo <gsomlo@gmail.com>
Link: https://lore.kernel.org/r/20220912195307.812229-1-nhuck@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/litex/litex_liteeth.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/litex/litex_liteeth.c b/drivers/net/ethernet/litex/litex_liteeth.c
index fdd99f0de424..35f24e0f0934 100644
--- a/drivers/net/ethernet/litex/litex_liteeth.c
+++ b/drivers/net/ethernet/litex/litex_liteeth.c
@@ -152,7 +152,8 @@ static int liteeth_stop(struct net_device *netdev)
 	return 0;
 }
 
-static int liteeth_start_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t liteeth_start_xmit(struct sk_buff *skb,
+				      struct net_device *netdev)
 {
 	struct liteeth *priv = netdev_priv(netdev);
 	void __iomem *txbuffer;
-- 
2.35.1

