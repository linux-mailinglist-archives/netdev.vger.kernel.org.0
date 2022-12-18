Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459BC65039B
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 18:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233448AbiLRRGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 12:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbiLRRFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 12:05:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D37913CC1;
        Sun, 18 Dec 2022 08:22:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD1BB60C40;
        Sun, 18 Dec 2022 16:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFE58C433EF;
        Sun, 18 Dec 2022 16:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380529;
        bh=ONuYGq6oB24d94k2QgN3qhxbPTyBa1Lzwbl6aFqLKAo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gn0PDFwm4eoWWDpqZx2xVtRfNVHzOUXF1hZQTViVAskwiA2TIltKixjoHmSPPK8lz
         3BGQnNVuDZLrzaAJq6sjhYbyXvfqgS7j5DOo60I4U0dyOQsWQIaf4dlkwyZAi3MB0S
         lRpv3NQiAk2UqaiY0pDoHkcqerSZI7Au5849PBqxlIj9JgYKkxa0Qxhw1i/9XPHtck
         zUbfVWrcuAoCTmho+xptegKTCgZ56dKbFPCRshN6F5HyH79QEI2NSApGunjRX0fwOz
         7vg6NaYc9ND5XRMMU3H3e6rCzNGjkmGpUv9ZLwHDeB6trvP7lWtXqVpVolum3r/Wky
         KLFW7eqPi7RZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, t.sailer@alumni.ethz.ch,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        ndesaulniers@google.com, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 4.14 07/23] hamradio: baycom_epp: Fix return type of baycom_send_packet()
Date:   Sun, 18 Dec 2022 11:21:33 -0500
Message-Id: <20221218162149.935047-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218162149.935047-1-sashal@kernel.org>
References: <20221218162149.935047-1-sashal@kernel.org>
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
index 1503f10122f7..a80948d700fe 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -772,7 +772,7 @@ static void epp_bh(struct work_struct *work)
  * ===================== network driver interface =========================
  */
 
-static int baycom_send_packet(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t baycom_send_packet(struct sk_buff *skb, struct net_device *dev)
 {
 	struct baycom_state *bc = netdev_priv(dev);
 
-- 
2.35.1

