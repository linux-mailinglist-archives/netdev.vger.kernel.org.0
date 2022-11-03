Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6112F618592
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 18:02:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231836AbiKCRCX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 13:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231849AbiKCRBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 13:01:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D51CB396;
        Thu,  3 Nov 2022 10:01:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 719A161F87;
        Thu,  3 Nov 2022 17:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78D1C433D7;
        Thu,  3 Nov 2022 17:01:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667494911;
        bh=Ayl0uMDQLjbJW7HCHCKMEYKRRMbofKS7PhzsOSwmDk0=;
        h=From:To:Cc:Subject:Date:From;
        b=SUvqFdxcftHNWUAWw3dMM1PZETx6pz6Tfjvf4PVSCtSdHo7FLBnENF9vCdx+5kQgJ
         gZBfl7sOEfZA9dpToAGOJ9GepoHcDJ8H7SJowBqOR08qOl12zVXLRg8fbpoG7Fy/XX
         ZBchd/NuvSFoFISyB7zdE2yxxw2oiXgPDHIovpT5ZfAArsNfM4lOHiwD+LY/pD+noV
         TtkcoDqEvhUft8VDoHVdPxlv23EHKGEICdRSFI5PJSFVIR48hGo5/SjadQFubD+32I
         b01hoNn7eSmALD9CgzHvOGaVlIql8gdPgJMREvLB9lQvs44IV987nfcM4LTmPVVHEj
         INkM9jDEZn7Gw==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Alexandra Winter <wintera@linux.ibm.com>,
        Wenjia Zhang <wenjia@linux.ibm.com>
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>, llvm@lists.linux.dev,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH v2 1/3] s390/ctcm: Fix return type of ctc{mp,}m_tx()
Date:   Thu,  3 Nov 2022 10:01:28 -0700
Message-Id: <20221103170130.1727408-1-nathan@kernel.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
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
proposed warning in clang aims to catch these at compile time, which
reveals:

  drivers/s390/net/ctcm_main.c:1064:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .ndo_start_xmit         = ctcm_tx,
                                    ^~~~~~~
  drivers/s390/net/ctcm_main.c:1072:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .ndo_start_xmit         = ctcmpc_tx,
                                    ^~~~~~~~~

->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
'netdev_tx_t', not 'int'. Adjust the return type of ctc{mp,}m_tx() to
match the prototype's to resolve the warning and potential CFI failure,
should s390 select ARCH_SUPPORTS_CFI_CLANG in the future.

Additionally, while in the area, remove a comment block that is no
longer relevant.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
v2:
  - Pick up tags from Alexandra and Kees.
  - Remove comment block above ctcm_tx() (Alexandra).
v1: https://lore.kernel.org/20221102163252.49175-1-nathan@kernel.org/
---
 drivers/s390/net/ctcm_main.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
index 37b551bd43bf..bdfab9ea0046 100644
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -825,16 +825,9 @@ static int ctcmpc_transmit_skb(struct channel *ch, struct sk_buff *skb)
 /*
  * Start transmission of a packet.
  * Called from generic network device layer.
- *
- *  skb		Pointer to buffer containing the packet.
- *  dev		Pointer to interface struct.
- *
- * returns 0 if packet consumed, !0 if packet rejected.
- *         Note: If we return !0, then the packet is free'd by
- *               the generic network layer.
  */
 /* first merge version - leaving both functions separated */
-static int ctcm_tx(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t ctcm_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ctcm_priv *priv = dev->ml_priv;
 
@@ -877,7 +870,7 @@ static int ctcm_tx(struct sk_buff *skb, struct net_device *dev)
 }
 
 /* unmerged MPC variant of ctcm_tx */
-static int ctcmpc_tx(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t ctcmpc_tx(struct sk_buff *skb, struct net_device *dev)
 {
 	int len = 0;
 	struct ctcm_priv *priv = dev->ml_priv;

base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
-- 
2.38.1

