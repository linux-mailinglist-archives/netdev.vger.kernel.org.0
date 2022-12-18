Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 059CC65011B
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbiLRQYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbiLRQXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:23:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B736213E21;
        Sun, 18 Dec 2022 08:09:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6E60B80BA5;
        Sun, 18 Dec 2022 16:09:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A462C43396;
        Sun, 18 Dec 2022 16:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379771;
        bh=35qg6hjhsveC4cadPh8VkshppfXL78Z16HjjR3pai2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XqIrz4ic5PEVUtGKXq1AhU24HxxFruvHcuQj5WZe8p+lb5CKxJREedVWBEzj+zFJZ
         4N7aLcthjPTJ9bo/Or6Vta5poOErfzhCzX6fY+EAoE785YcuYdz+/A1Rn2kjlFY1ES
         pQbaxer3QgkuW6V3qAtQXT+7Y4k9ValQ8X/HwqfKEYMljL4VbHdBtj+e6J4P1swrbW
         j1EFPMNxiA7bNXqLzHm0/J41YsLY06teDhG+OBIVPqOwOSSc84GV1F4gj1vfhfvz7D
         Z4d0NItRAPy6U2W+wmE7JVQ8+t0o7Wf0EgfJh9/jIQAz2l9og/zducyOxq4hwshmDO
         8/NyknxQ60qsw==
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
Subject: [PATCH AUTOSEL 6.0 29/73] s390/netiucv: Fix return type of netiucv_tx()
Date:   Sun, 18 Dec 2022 11:06:57 -0500
Message-Id: <20221218160741.927862-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218160741.927862-1-sashal@kernel.org>
References: <20221218160741.927862-1-sashal@kernel.org>
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
index 65aa0a96c21d..66076cada8ae 100644
--- a/drivers/s390/net/netiucv.c
+++ b/drivers/s390/net/netiucv.c
@@ -1248,15 +1248,8 @@ static int netiucv_close(struct net_device *dev)
 /*
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

