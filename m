Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA34532E5C
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 18:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239565AbiEXQCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 12:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239353AbiEXQCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 12:02:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C24364E2;
        Tue, 24 May 2022 09:01:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1687B61763;
        Tue, 24 May 2022 16:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FBBC34113;
        Tue, 24 May 2022 16:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653408066;
        bh=lFktN1E1t+rxFQGdQ28nXe9HkrtZhQdy6eSxkYzOlmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NFKBYnYaJc2l3yrrdaw8y9n1ko51sL5t+BNDJddvMP/CS9x4Jobl/LssFcwTHhdQO
         0oZgQ/mBvKX255oFtFkS/iDuw/UhKGa1dnNVVsXTShYqvJau/a9DUqUzJncDUnDvrM
         w68lsps6UTrfRyXmwhaf33/lgxp11lGVKSuNrF6iDXgzSZMTQENbu0T18OMiUu+Wr8
         +YB3VO7s/DNdCgXmtf/kpqXAZkzxl1zfLRCOHU4G6HVLuLkwgZjwgyinplfOspUY7H
         oIV9cEXEPr3nSs46oMLhHy0cKZQh4YaZSCvMN6RFDRc4ZVTVsbyD+Vz+6h+INtDbI9
         kle/ub8pnW2/g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Bartschies <thomas.bartschies@cvk.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 2/5] net: af_key: check encryption module availability consistency
Date:   Tue, 24 May 2022 12:00:58 -0400
Message-Id: <20220524160102.827227-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524160102.827227-1-sashal@kernel.org>
References: <20220524160102.827227-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Bartschies <thomas.bartschies@cvk.de>

[ Upstream commit 015c44d7bff3f44d569716117becd570c179ca32 ]

Since the recent introduction supporting the SM3 and SM4 hash algos for IPsec, the kernel
produces invalid pfkey acquire messages, when these encryption modules are disabled. This
happens because the availability of the algos wasn't checked in all necessary functions.
This patch adds these checks.

Signed-off-by: Thomas Bartschies <thomas.bartschies@cvk.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/key/af_key.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 2ac9560020f9..d8bceb8cf756 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2902,7 +2902,7 @@ static int count_ah_combs(const struct xfrm_tmpl *t)
 			break;
 		if (!aalg->pfkey_supported)
 			continue;
-		if (aalg_tmpl_set(t, aalg))
+		if (aalg_tmpl_set(t, aalg) && aalg->available)
 			sz += sizeof(struct sadb_comb);
 	}
 	return sz + sizeof(struct sadb_prop);
@@ -2920,7 +2920,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 		if (!ealg->pfkey_supported)
 			continue;
 
-		if (!(ealg_tmpl_set(t, ealg)))
+		if (!(ealg_tmpl_set(t, ealg) && ealg->available))
 			continue;
 
 		for (k = 1; ; k++) {
@@ -2931,7 +2931,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 			if (!aalg->pfkey_supported)
 				continue;
 
-			if (aalg_tmpl_set(t, aalg))
+			if (aalg_tmpl_set(t, aalg) && aalg->available)
 				sz += sizeof(struct sadb_comb);
 		}
 	}
-- 
2.35.1

