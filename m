Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B9A61858B
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 18:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbiKCRCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 13:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231956AbiKCRB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 13:01:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB9C9396;
        Thu,  3 Nov 2022 10:01:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A5CE1B82962;
        Thu,  3 Nov 2022 17:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54C8DC433D7;
        Thu,  3 Nov 2022 17:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667494915;
        bh=D6/fRtPSM2LL/1pNEu7S9mDvRcvLO6bXEXGfxKCxLfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XMDIuoDVdszuwgtpet7Zhut7+sLQ3lCO+sIwchaG0nneXIBaKXTtNveI6/Ed4b2Pt
         dcsH02Dfwofx3dgr6jxvcTPCCZjiS7qJGFcBa7gdRajTjVyL1dpFbLZqrqjKUgA8Vk
         qnPsDUOxD1tl1JsrA73L4wCeH/fVZVPpecXhCXR8j0RNb2dwlfpsL288P3+FHFWIgw
         wN4rACbk21wqlBUqmyJI/4GKab1pyUhx8u3zGw3NlgUOQVRuqiaaPoHyTuVA8x87KD
         nkQt1apI4lSBd0jku12nocowT0xOsKZy5cYO560fkLb6ttyU/3iIHOcyGOjn1zjhxU
         efVmAj/18PjJg==
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
Subject: [PATCH v2 3/3] s390/lcs: Fix return type of lcs_start_xmit()
Date:   Thu,  3 Nov 2022 10:01:30 -0700
Message-Id: <20221103170130.1727408-3-nathan@kernel.org>
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

  drivers/s390/net/lcs.c:2090:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .ndo_start_xmit         = lcs_start_xmit,
                                    ^~~~~~~~~~~~~~
  drivers/s390/net/lcs.c:2097:21: error: incompatible function pointer types initializing 'netdev_tx_t (*)(struct sk_buff *, struct net_device *)' (aka 'enum netdev_tx (*)(struct sk_buff *, struct net_device *)') with an expression of type 'int (struct sk_buff *, struct net_device *)' [-Werror,-Wincompatible-function-pointer-types-strict]
          .ndo_start_xmit         = lcs_start_xmit,
                                    ^~~~~~~~~~~~~~

->ndo_start_xmit() in 'struct net_device_ops' expects a return type of
'netdev_tx_t', not 'int'. Adjust the return type of lcs_start_xmit() to
match the prototype's to resolve the warning and potential CFI failure,
should s390 select ARCH_SUPPORTS_CFI_CLANG in the future.

Link: https://github.com/ClangBuiltLinux/linux/issues/1750
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
v2:
  - Pick up tags from Alexandra and Kees.
  - Adjust indentation of modified lines, as they can fit within the
    line limit (Alexandra).
v1: https://lore.kernel.org/20221102163252.49175-3-nathan@kernel.org/
---
 drivers/s390/net/lcs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index 84c8981317b4..38f312664ce7 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -1519,9 +1519,8 @@ lcs_txbuffer_cb(struct lcs_channel *channel, struct lcs_buffer *buffer)
 /*
  * Packet transmit function called by network stack
  */
-static int
-__lcs_start_xmit(struct lcs_card *card, struct sk_buff *skb,
-		 struct net_device *dev)
+static netdev_tx_t __lcs_start_xmit(struct lcs_card *card, struct sk_buff *skb,
+				    struct net_device *dev)
 {
 	struct lcs_header *header;
 	int rc = NETDEV_TX_OK;
@@ -1582,8 +1581,7 @@ __lcs_start_xmit(struct lcs_card *card, struct sk_buff *skb,
 	return rc;
 }
 
-static int
-lcs_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t lcs_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct lcs_card *card;
 	int rc;
-- 
2.38.1

