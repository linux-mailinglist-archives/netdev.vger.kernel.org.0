Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BFEE6503E4
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 18:09:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbiLRRJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 12:09:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233638AbiLRRHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 12:07:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9257CD12C;
        Sun, 18 Dec 2022 08:23:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F7FA60DB4;
        Sun, 18 Dec 2022 16:23:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C121C433D2;
        Sun, 18 Dec 2022 16:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380599;
        bh=+Y5rY6Spr69G3yO6EVScjdi7yjQxdJZoDsPcAT51BN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RfgcHsE1S+1PnoKb+nBfl8wD+3FxD/O8uREaKthxnvMukuM6ZcuWmm65e8fJxOk+d
         zw9m+VM3xm0veGRThP/VbFlMeZMaiuE7LytNdDAm1OFzXDonxYh2Wjyt3/Gcv39FPY
         9QacZ65e+fNBLSggW3TI7DU9hcT/zOHOMViu8hRDIGxhPyDl4oWNdOUvWXz6tVHg/q
         jL5Fi8ZSV4A/AgfwIBUp0OD+oQp+RehjlTFYoBCbzh7UZqdX4yOZycidVdJinLfhN0
         YP+sQ0Hms5W8vqoXbEqMnPMJgY4MBmlckMkFmnJF2P69zQLIwxAOA3sEicPl4ymmpa
         9bG3V3dqnV64g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, t.sailer@alumni.ethz.ch,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        ndesaulniers@google.com, linux-hams@vger.kernel.org,
        netdev@vger.kernel.org, llvm@lists.linux.dev
Subject: [PATCH AUTOSEL 4.9 05/20] hamradio: baycom_epp: Fix return type of baycom_send_packet()
Date:   Sun, 18 Dec 2022 11:22:50 -0500
Message-Id: <20221218162305.935724-5-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221218162305.935724-1-sashal@kernel.org>
References: <20221218162305.935724-1-sashal@kernel.org>
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
index 78dbc44540f6..b7831d0fd084 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -768,7 +768,7 @@ static void epp_bh(struct work_struct *work)
  * ===================== network driver interface =========================
  */
 
-static int baycom_send_packet(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t baycom_send_packet(struct sk_buff *skb, struct net_device *dev)
 {
 	struct baycom_state *bc = netdev_priv(dev);
 
-- 
2.35.1

