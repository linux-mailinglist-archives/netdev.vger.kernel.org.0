Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3324D53E0C1
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 08:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiFFF1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 01:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiFFF1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 01:27:40 -0400
Received: from condef-07.nifty.com (condef-07.nifty.com [202.248.20.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE529119069;
        Sun,  5 Jun 2022 22:06:05 -0700 (PDT)
Received: from conuserg-10.nifty.com ([10.126.8.73])by condef-07.nifty.com with ESMTP id 2564ttqF026112;
        Mon, 6 Jun 2022 13:56:15 +0900
Received: from grover.sesame (133-32-177-133.west.xps.vectant.ne.jp [133.32.177.133]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id 2564rxUA026256;
        Mon, 6 Jun 2022 13:54:02 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com 2564rxUA026256
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1654491243;
        bh=ziQR3Y2YVkVjwU2FN5ZC+RUigUk86AY6lP77BM69cbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YK9ljVsieM/Oe6LIGFVOj3act3Y+vtt/qbzrdfidezomn2THxtGDQwGpxvOTi+RZm
         pF6qs15bi0tyntc8Wl2uv9tH2cyTx1n1tjZBxaA7Qrlo/N+bRY7zTY6r2eMQ3aucBy
         qKx3ZvjyvPzBa0urhSQlaHECANtaYdh97M9CA1GDGnSa6nuzgE81NbhkbnNqY1mfKs
         AazrY8ger8oAZ/HhDmhCEIVwD/G2WRymdTVF5iixsIqcsRkckW3FVQ4TLXq5X5SgJk
         XK0lqGi8TpdbWNPWX/0Y21f68B5Gu3gNa8dTCk/FyDWtGaHASScGNl7Gm9EKZbSIb2
         US58dmCjmgOsA==
X-Nifty-SrcIP: [133.32.177.133]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Ahern <dsahern@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] net: xfrm: unexport __init-annotated xfrm4_protocol_init()
Date:   Mon,  6 Jun 2022 13:53:54 +0900
Message-Id: <20220606045355.4160711-3-masahiroy@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220606045355.4160711-1-masahiroy@kernel.org>
References: <20220606045355.4160711-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EXPORT_SYMBOL and __init is a bad combination because the .init.text
section is freed up after the initialization. Hence, modules cannot
use symbols annotated __init. The access to a freed symbol may end up
with kernel panic.

modpost used to detect it, but it has been broken for a decade.

Recently, I fixed modpost so it started to warn it again, then this
showed up in linux-next builds.

There are two ways to fix it:

  - Remove __init
  - Remove EXPORT_SYMBOL

I chose the latter for this case because the only in-tree call-site,
net/ipv4/xfrm4_policy.c is never compiled as modular.
(CONFIG_XFRM is boolean)

Fixes: 2f32b51b609f ("xfrm: Introduce xfrm_input_afinfo to access the the callbacks properly")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 net/ipv4/xfrm4_protocol.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/xfrm4_protocol.c b/net/ipv4/xfrm4_protocol.c
index 2fe5860c21d6..b146ce88c5d0 100644
--- a/net/ipv4/xfrm4_protocol.c
+++ b/net/ipv4/xfrm4_protocol.c
@@ -304,4 +304,3 @@ void __init xfrm4_protocol_init(void)
 {
 	xfrm_input_register_afinfo(&xfrm4_input_afinfo);
 }
-EXPORT_SYMBOL(xfrm4_protocol_init);
-- 
2.32.0

