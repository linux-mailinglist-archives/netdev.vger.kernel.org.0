Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9543C5B62E9
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 23:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiILVny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 17:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiILVnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 17:43:52 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03A84C61F
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 14:43:51 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v202-20020a252fd3000000b006a8f6c5d39bso8430588ybv.21
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 14:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=2d3fydqfX2g65N3phYlMxqgvPYWylfGPLLgNinkZtt0=;
        b=ZyLbqVNgTed8/0xWnsk+tR2bOwO5rwirlfTupR72ID3PCTMhFXg/e8BAFLSWElwOIb
         kSEZWlZpBUDgCmHZ6FNZRaMsPx0f9XWxOS9KfY3ch50Le7A9zCo8OpgZd3aHfrxEZZdZ
         HNABn/7p+5t0vUxv4hrnNsVv7BjgfBaSxu8BYz7IY9/Ls7QRdUWJpJJsCx/GG0TjY4YL
         9osbkn93FTbkUyvA3D5z2WBxpQ6T35P0YiCNDIKnzirRfLvomOplATDlwkKMdVOHjLwb
         qoNnHtZ9PXj8el2ezt0rGJreHXQMtSRkv10hKARhx9ZHKUd5suGg2tJ06B+b/InWPt+g
         5yAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=2d3fydqfX2g65N3phYlMxqgvPYWylfGPLLgNinkZtt0=;
        b=fGq2z/jSmasuUSrFH6md+FShKIlD8Kx+t236GzRmc/IYdinGfLcLCpTBZLB0SFtMTm
         8rSteR3n7jVC08OWq53qrnEydxOyoDXU+RTfkzQr+POQc8Niqo3DHSX6eBoQ26DAoJ5y
         jjAvUKrtzXaled/SvbuTzlbS5CF8/WbfzLAxjMOVBSqrmYyyF/Jv+DTWUzMSWlKAchx/
         WR8C0pK9IMcOEOlbXe7yho5nV32ga0OK1q8fO4qM61heJ/w1IboJ0JgohRboCS2ZCJ68
         K7KlenGLnSKXJT1dTYtmlO82UHL4aBbrp8WtiUBFWXC9N84oX7FY7KFY4CSspQQ0Qh5T
         KbUg==
X-Gm-Message-State: ACgBeo3nSETqEaf6l3HVSbRjJH6Nuk8Hk9FTl3jb/fhl91PIEAzHuxlO
        sXNd3sN6luhD6TcAdfS6FziAQo2/1A==
X-Google-Smtp-Source: AA6agR6dOUbw4syADaJEIcxCeDzWlSzErY/9EAd+wVdfmpfcPpI7s8I6rNEgQ+gEJZAdtRqd6evKVLkZDw==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a0d:e946:0:b0:345:696:caaa with SMTP id
 s67-20020a0de946000000b003450696caaamr23604716ywe.507.1663019030957; Mon, 12
 Sep 2022 14:43:50 -0700 (PDT)
Date:   Mon, 12 Sep 2022 14:43:40 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220912214344.928925-1-nhuck@google.com>
Subject: [PATCH] net: korina: Fix return type of korina_send_packet
From:   Nathan Huckleberry <nhuck@google.com>
Cc:     Nathan Huckleberry <nhuck@google.com>,
        Dan Carpenter <error27@gmail.com>, llvm@lists.linux.dev,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ndo_start_xmit field in net_device_ops is expected to be of type
netdev_tx_t (*ndo_start_xmit)(struct sk_buff *skb, struct net_device *dev).

The mismatched return type breaks forward edge kCFI since the underlying
function definition does not match the function hook definition.

The return type of korina_send_packet should be changed from int to
netdev_tx_t.

Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1703
Cc: llvm@lists.linux.dev
Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 drivers/net/ethernet/korina.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
index df9a8eefa007..eec6a9ec528b 100644
--- a/drivers/net/ethernet/korina.c
+++ b/drivers/net/ethernet/korina.c
@@ -416,7 +416,8 @@ static void korina_abort_rx(struct net_device *dev)
 }
 
 /* transmit packet */
-static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t korina_send_packet(struct sk_buff *skb,
+				      struct net_device *dev)
 {
 	struct korina_private *lp = netdev_priv(dev);
 	u32 chain_prev, chain_next;
-- 
2.37.2.789.g6183377224-goog

