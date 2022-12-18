Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5E2650356
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 18:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbiLRRDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 12:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbiLRRCV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 12:02:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21FF12080;
        Sun, 18 Dec 2022 08:20:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6936960D3D;
        Sun, 18 Dec 2022 16:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530EFC433F0;
        Sun, 18 Dec 2022 16:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380456;
        bh=oiOX472mnnmwJmFbj2f3WMF3509uMFauEYkBPuIU34Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WkPd5tRwc5W5437sbmYOTcw3V/XowZCoOMa0lZJSH/gfU4apWjxmRQw+EZQ58CWoO
         0a+YSYSLOTOeA3d4BL9mg/OqUytZblMb8KJVNfC8zkcX6BxfpdRayJwAUjnBFV8SkP
         GyVnVTa2SbrkGGCIczRytWZVCo6s1HwhXerksiYqQtjSSQBSMa7uLYVmKqm6+Ut5Ep
         dxQbvsWz0xLNof8A8V2AVJIvkaP5EBswnc2Dl1frop1euB3fT6HqOi50qQDgCbyf/u
         kMJoY2fSTAYEK7OTkJSqTGWuvSsgqCvPy4jx/voIbLmNEtlOntBmVtZgY6FVgv739w
         mZjhGtSUhGMlw==
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
Subject: [PATCH AUTOSEL 4.19 12/26] s390/netiucv: Fix return type of netiucv_tx()
Date:   Sun, 18 Dec 2022 11:20:02 -0500
Message-Id: <20221218162016.934280-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218162016.934280-1-sashal@kernel.org>
References: <20221218162016.934280-1-sashal@kernel.org>
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
index 5ce2424ca729..e2984b54447b 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -1344,15 +1344,8 @@ static int netiucv_pm_restore_thaw(struct device *dev)
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

