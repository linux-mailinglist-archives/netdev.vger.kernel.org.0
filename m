Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093E56C06A7
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 00:41:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjCSXlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 19:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCSXlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 19:41:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8726112BE2
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 16:41:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BA3D611DB
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 23:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F7EC433EF;
        Sun, 19 Mar 2023 23:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679269279;
        bh=Mkaeo/vthgqNOnRW7e/YWH7LRP0nK4bMLrrHQo9+nos=;
        h=From:Date:Subject:To:Cc:From;
        b=LhUHf1hdzhV/XqB+u/WFJM2h4mtaOufVWTao6RuDHvTwGmydEoFt6j87J7OXQGCD5
         TvLinJ39k3qRDhAxyDCn1ehr7pyFj9gA3Kt4r2elZYgAYFgaIkNYex0IvtwEP9sRUf
         iyt1WuoTSSrWu/MuaEAh9TmaUdRM/nvmXPYPRmcMFwbGs/46MkGnJU6wzo7zhtgjHB
         nqQEr3EnAiYYrroiL5UQYDcjhJC6v6EGsVV831vUHtn2ASAM7mpt3KDXOeTe8vEtNc
         nowfNVCFUyy89eaTu/Fu91MvbLLQxuQ7GMM2PEYNme/Jcwg3HyjRgsEH6lM+X6xeyL
         xR0t9DrtT/Ajg==
From:   Nathan Chancellor <nathan@kernel.org>
Date:   Sun, 19 Mar 2023 16:41:08 -0700
Subject: [PATCH net-next] net: pasemi: Fix return type of
 pasemi_mac_start_tx()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230319-pasemi-incompatible-pointer-types-strict-v1-1-1b9459d8aef0@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJOdF2QC/x2O0QrCMAxFf2Xk2cDa6XD+ivjQ1cwFbFaaIJOxf
 7fz8XA5h7uBUmFSuDUbFPqw8iIV3KmBOAd5EfKzMvjWd23nBsxBKTGyxCXlYDy+CfPCYlTQvpk
 U1QpHw+ulH7zvpzO5FmpurCKOJUicj2AKWpVjyIUmXv8f7iBkKLQaPPb9ByucpQqdAAAA
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     ndesaulniers@google.com, trix@redhat.com, netdev@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.12.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2364; i=nathan@kernel.org;
 h=from:subject:message-id; bh=Mkaeo/vthgqNOnRW7e/YWH7LRP0nK4bMLrrHQo9+nos=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDCnic+d9e6jx8VlpWEPDhtdigWIVqY926j/NXXqbPcp5g
 WWouQJLRykLgxgHg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZhIQzwjw+xNQTdPbPv4LlP/
 VdaBesEVO5gSzc7M2h1ySmauVSDfewZGhh+BSalcy8IT96w7vJflvt3lvZ8XVDXf3C60e+bR1da
 JBjwA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With clang's kernel control flow integrity (kCFI, CONFIG_CFI_CLANG),
indirect call targets are validated against the expected function
pointer prototype to make sure the call target is valid to help mitigate
ROP attacks. If they are not identical, there is a failure at run time,
which manifests as either a kernel panic or thread getting killed. A
warning in clang aims to catch these at compile time, which reveals:

  drivers/net/ethernet/pasemi/pasemi_mac.c:1665:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .ndo_start_xmit         = pasemi_mac_start_tx,
                                    ^~~~~~~~~~~~~~~~~~~
  1 error generated.

->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
'netdev_tx_t', not 'int'. Adjust the return type of
pasemi_mac_start_tx() to match the prototype's to resolve the warning.
While PowerPC does not currently implement support for kCFI, it could in
the future, which means this warning becomes a fatal CFI failure at run
time.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/ethernet/pasemi/pasemi_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pasemi/pasemi_mac.c b/drivers/net/ethernet/pasemi/pasemi_mac.c
index aaab590ef548..ed7dd0a04235 100644
--- a/drivers/net/ethernet/pasemi/pasemi_mac.c
+++ b/drivers/net/ethernet/pasemi/pasemi_mac.c
@@ -1423,7 +1423,7 @@ static void pasemi_mac_queue_csdesc(const struct sk_buff *skb,
 	write_dma_reg(PAS_DMA_TXCHAN_INCR(txring->chan.chno), 2);
 }
 
-static int pasemi_mac_start_tx(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t pasemi_mac_start_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	struct pasemi_mac * const mac = netdev_priv(dev);
 	struct pasemi_mac_txring * const txring = tx_ring(mac);

---
base-commit: e8d018dd0257f744ca50a729e3d042cf2ec9da65
change-id: 20230319-pasemi-incompatible-pointer-types-strict-8569226f4e10

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

