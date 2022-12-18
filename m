Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1BC16503B7
	for <lists+netdev@lfdr.de>; Sun, 18 Dec 2022 18:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbiLRRH7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Dec 2022 12:07:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233290AbiLRRGN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Dec 2022 12:06:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D1913CE6;
        Sun, 18 Dec 2022 08:22:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7770FB801C0;
        Sun, 18 Dec 2022 16:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDC6C433EF;
        Sun, 18 Dec 2022 16:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671380545;
        bh=Tc7v/EfefAd1QyxeblQZSdpmmvCKnqcvArUojj/EYjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRva6VaL3L8S7S5QRmJkvqGl28vsajdlHb6nnW00rd6JY1LvA8OdPsXT67i+Q1B95
         1RMOrulxb1KtXkwrIqKdr+3LC9gawBXoHfqJuNergLru4GVnoN7JjbUZteuOFTcqwT
         /anO3g7egVVTMccsevb85KoKP0Adpf2AO83SAULyeV4F+5fjQwxHYKUIgIYsHVx+3h
         xUe2WVdCMJVk/k4RAUVSWsNtnqzfY+Td9ATe96XgSoMzQwAua0v20yWxujp+AppG+E
         7LT9Pv48jnPQi7+Q0h75oK1o7zU/f6BlqfNqyxvlUd0DV6kiH2lwV4fVWaJH3Gf4fT
         jgTjrP0KE+04A==
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
Subject: [PATCH AUTOSEL 4.14 12/23] s390/lcs: Fix return type of lcs_start_xmit()
Date:   Sun, 18 Dec 2022 11:21:38 -0500
Message-Id: <20221218162149.935047-12-sashal@kernel.org>
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

[ Upstream commit bb16db8393658e0978c3f0d30ae069e878264fa3 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/lcs.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
index da4d7284db67..924681e70a2b 100644
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -1540,9 +1540,8 @@ lcs_txbuffer_cb(struct lcs_channel *channel, struct lcs_buffer *buffer)
 /**
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
@@ -1603,8 +1602,7 @@ __lcs_start_xmit(struct lcs_card *card, struct sk_buff *skb,
 	return rc;
 }
 
-static int
-lcs_start_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t lcs_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct lcs_card *card;
 	int rc;
-- 
2.35.1

