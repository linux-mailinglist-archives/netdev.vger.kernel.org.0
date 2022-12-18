Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD2D65013C
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 17:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232067AbiLRQZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 11:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbiLRQYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 11:24:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DDD2D2D7;
        Sun, 18 Dec 2022 08:09:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A24060C99;
        Sun, 18 Dec 2022 16:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D7DC43392;
        Sun, 18 Dec 2022 16:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671379743;
        bh=T9v2af0blhUSQ1zITjghYUNkuy7dANnd3er1zWX4zcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsl/7OKPDwXfzLp6loG3PUB7cA3w3gw6k25dUUfUuGrt3vZF0fGkRb22TyMTwGXdm
         KTcAQuoXiG1YVFI7D7hGmZK8UNl5h1nJGv9DEiqnhkKUn+ktzYtCRTIpU9ZaJwV8Y3
         c2QRKaFU2UmOxJpcoMgL9OYLlmMWTNZjhsu/jj1dEIAltTiVrG8eAxwhXzUQY/fhm9
         J3HoqwB0MFWGR+2xjdvdM3Z+VBjgOUAGgOcjAZIJbTSsRv5JzJ6b+oVSnwq1/0nWgN
         QijvPJ/N7cDUQOM+ntRQDgQQOMGCztsHqHwl27CVr8/HDipSmFlQg0pOnX1nMB8ARD
         Z28Sp1gqY6pdQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, t.sailer@alumni.ethz.ch,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        ndesaulniers@google.com, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 6.0 22/73] hamradio: baycom_epp: Fix return type of baycom_send_packet()
Date:   Sun, 18 Dec 2022 11:06:50 -0500
Message-Id: <20221218160741.927862-22-sashal@kernel.org>
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

[ Upstream commit c5733e5b15d91ab679646ec3149e192996a27d5d ]

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
proposed warning in clang aims to catch these at compile time, which
reveals:

  drivers/net/hamradio/baycom_epp.c:1119:25: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .ndo_start_xmit      = baycom_send_packet,
                                ^~~~~~~~~~~~~~~~~~
  1 error generated.

->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
'netdev_tx_t', not 'int'. Adjust the return type of baycom_send_packet()
to match the prototype's to resolve the warning and CFI failure.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/20221102160610.1186145-1-nathan@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hamradio/baycom_epp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index 3e69079ed694..94720f8a8ba5 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -758,7 +758,7 @@ static void epp_bh(struct work_struct *work)
  * ===================== network driver interface =========================
  */
 
-static int baycom_send_packet(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t baycom_send_packet(struct sk_buff *skb, struct net_device *dev)
 {
 	struct baycom_state *bc = netdev_priv(dev);
 
-- 
2.35.1

