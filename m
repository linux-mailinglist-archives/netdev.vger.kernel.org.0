Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC159650289
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:48:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbiLRQsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:48:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232799AbiLRQrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:47:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EFB10573;
        Sun, 18 Dec 2022 08:17:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC28C60C99;
        Sun, 18 Dec 2022 16:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1214C433EF;
        Sun, 18 Dec 2022 16:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380233;
        bh=jGWV1F/52tDMtlZyzRzbQPCYoETjK1HdqV3sIhSdaYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VIXoPMDKkotwK8Ymm8EE/beKroG9E+F5HX3mT9NtJmIWrLXEXaBSTUETZxI62P3Kv
         ZmUf3xz9NJAo7WFu2jCgNzVjifQfMHvnntu3iHZHo0UQJZGpGr9pQN6PV0D5tytO5p
         GFPnIL0Vpjt6pQ/tO/q4llVtn1sh3C++Ic2vLXcfYpPcA1up+OLuiX0lg4/sgTHWUJ
         o317jehyJw9R0ob/c83vkzZ1JsdCt1ptlWPKp31S9HYLtFlUoLqlw15s6uLJ1Z6emP
         uAYDD6wptpAXj6GvLITKm6EMn12x8ODU01rKfCUT0Oqum3pp7XGV+wu/x62exNsI6d
         ooQ9P+iSocleg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Kees Cook <keescook@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, wenjia@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        ndesaulniers@google.com, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 5.10 17/39] s390/netiucv: Fix return type of netiucv_tx()
Date:   Sun, 18 Dec 2022 11:15:37 -0500
Message-Id: <20221218161559.932604-17-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218161559.932604-1-sashal@kernel.org>
References: <20221218161559.932604-1-sashal@kernel.org>
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

[ Upstream commit 88d86d18d7cf7e9137c95f9d212bb9fff8a1b4be ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
proposed warning in clang aims to catch these at compile time, which
reveals:

  drivers/s390/net/netiucv.c:1854:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .ndo_start_xmit         = netiucv_tx,
                                    ^~~~~~~~~~

->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
'netdev_tx_t', not 'int'. Adjust the return type of netiucv_tx() to
match the prototype's to resolve the warning and potential CFI failure,
should s390 select ARCH_SUPPORTS_CFI_CLANG in the future.

Additionally, while in the area, remove a comment block that is no
longer relevant.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/netiucv.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/s390/net/netiucv.c b/drivers/s390/net/netiucv.c
index 260860cf3aa1..a2f403c4ec38 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -1260,15 +1260,8 @@ static int netiucv_close(struct net_device *dev)
 /**
  * Start transmission of a packet.
  * Called from generic network device layer.
- *
- * @param skb Pointer to buffer containing the packet.
- * @param dev Pointer to interface struct.
- *
- * @return 0 if packet consumed, !0 if packet rejected.
- *         Note: If we return !0, then the packet is free'd by
- *               the generic network layer.
  */
-static int netiucv_tx(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t netiucv_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	struct netiucv_priv *privptr = netdev_priv(dev);
 	int rc;
-- 
2.35.1

