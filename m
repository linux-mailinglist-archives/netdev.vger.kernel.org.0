Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2063161858E
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 18:02:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbiKCRCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 13:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231941AbiKCRBz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 13:01:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF571143;
        Thu,  3 Nov 2022 10:01:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D27F61F87;
        Thu,  3 Nov 2022 17:01:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C85C433B5;
        Thu,  3 Nov 2022 17:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667494913;
        bh=f6y6m1EnUKwUsyjzfNr41VDZUX99wh7+ivnefKR1ZII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IvELajK622CDtEFS3+Ndom/QAcrk2LdjDsIKm24NObJTK2STWaEF4arbw04pLNHCI
         YoG29onc7BA/p6VUkguQljzIoQ6N3IppFAGDiFFro5n8rICMp0V619jM6mjpHJONlr
         H/K4uGzHzHh+uyJ7dusvQBwQEofJaWE1qVWEGXzc3aAWHfASCXjPapjURUL6JyH1Pv
         xe9Ai/oWFSeNaDl3YdbeQiPRcdBW8qRWztLuBGGKMo2vV9FX0uf1z/1WkJW+cRgwBc
         +IKFm/7vzni39ewblgUJWogi4H0rO0edEFA+aIOQoRoXy0zx32gon1dapt8/7/9bSA
         JC/AvS7uXIC8w==
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
Subject: [PATCH v2 2/3] s390/netiucv: Fix return type of netiucv_tx()
Date:   Thu,  3 Nov 2022 10:01:29 -0700
Message-Id: <20221103170130.1727408-2-nathan@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221103170130.1727408-1-nathan@kernel.org>
References: <20221103170130.1727408-1-nathan@kernel.org>
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
---
v2:
  - Pick up tags from Alexandra and Kees.
  - Remove comment block above netiucv_tx() (Alexandra).
v1: https://lore.kernel.org/20221102163252.49175-2-nathan@kernel.org/
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
2.38.1

