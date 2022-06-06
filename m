Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB7E53E0EC
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 08:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbiFFF3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 01:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiFFF2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 01:28:05 -0400
Received: from condef-08.nifty.com (condef-08.nifty.com [202.248.20.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B65713A2E2;
        Sun,  5 Jun 2022 22:07:59 -0700 (PDT)
Received: from conuserg-10.nifty.com ([10.126.8.73])by condef-08.nifty.com with ESMTP id 2564tuC1017874;
        Mon, 6 Jun 2022 13:56:17 +0900
Received: from grover.sesame (133-32-177-133.west.xps.vectant.ne.jp [133.32.177.133]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id 2564rxUB026256;
        Mon, 6 Jun 2022 13:54:03 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com 2564rxUB026256
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1654491244;
        bh=8DsFZaGELYB7JvwytYb5vfoaMr6TS1NLhkVqZf+4BBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fJ/D8hXjFIh+wPt+yETn7vdGZzNYq1/3hzgsf0g1WYd5EvNUKb7sFe09qxQP3X6gY
         LxIASv+ka9fQHrDIPDpxMsTAaO+AlqlWnhFLkNWI+uEk/r6yTEorleWfqnhh/kdpAs
         KwCsXgpyVxeFWbadM7lVp0wWLOmjLNGcHHyzDhgztK56+fJKLq72cUvYqKOcIbWCGA
         ZDOFibDqFM4sFQCLqQk+ahSkZcBIpEzZRNhjqiJ2X/3NhdrYp0EOIPVBNW47lG6xNt
         uGDsC0txo+64CJXCY3FbmnCGOFOV93uRPyVqejSorqsP8z3Z3k2oxDW4ZvKOAT4Frj
         eu9G5Y/Yl4MSw==
X-Nifty-SrcIP: [133.32.177.133]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Ahern <dsahern@kernel.org>,
        David Lebrun <david.lebrun@uclouvain.be>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] net: ipv6: unexport __init-annotated seg6_hmac_init()
Date:   Mon,  6 Jun 2022 13:53:55 +0900
Message-Id: <20220606045355.4160711-4-masahiroy@kernel.org>
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

I chose the latter for this case because the caller (net/ipv6/seg6.c)
and the callee (net/ipv6/seg6_hmac.c) belong to the same module.
It seems an internal function call in ipv6.ko.

Fixes: bf355b8d2c30 ("ipv6: sr: add core files for SR HMAC support")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 net/ipv6/seg6_hmac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 29bc4e7c3046..6de01185cc68 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -399,7 +399,6 @@ int __init seg6_hmac_init(void)
 {
 	return seg6_hmac_init_algo();
 }
-EXPORT_SYMBOL(seg6_hmac_init);
 
 int __net_init seg6_hmac_net_init(struct net *net)
 {
-- 
2.32.0

