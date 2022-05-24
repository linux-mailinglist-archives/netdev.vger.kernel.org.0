Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCFA7532E1E
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 18:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239303AbiEXQAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 12:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237885AbiEXQAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 12:00:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B8C9D050;
        Tue, 24 May 2022 08:59:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98C95B81A50;
        Tue, 24 May 2022 15:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C63C34115;
        Tue, 24 May 2022 15:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653407991;
        bh=/g7GJVGtj32KCuRI5XqiYNVqvcLMLdvs+UUNGBovEoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvXWWQHTE0z5ze402cuPMdQ4NSdFN5p0YeIynHaYnSRKojfT+mE7h5KlTe+m1/Hgq
         Z2mg/U4a3wIgjIJ3oLN026w6wVZt0qV/Fkn14sw7lneA+nQv4JKxbrR5doGSb0JXX5
         +YglO4tY+1/Vbkd7m0P86miWoQloOSoroc3ZrvHj/xijF+HZNJicErPIF8qXJeZEqX
         tqvD1+2j+HSBXRGYqtRKIHZvvusULPHmmMadXtRW4x1YGLhP7+kUW6FhNB0k72yPSR
         UbrRsybZMM2IM5DE/k6tOM7nIWVKt1wmIbsw3Dy2HWB/vhDQCC8Yi8JKVWDZcffVRt
         Z2UBya1rlXRGA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Bartschies <thomas.bartschies@cvk.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 08/12] net: af_key: check encryption module availability consistency
Date:   Tue, 24 May 2022 11:59:22 -0400
Message-Id: <20220524155929.826793-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524155929.826793-1-sashal@kernel.org>
References: <20220524155929.826793-1-sashal@kernel.org>
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
index fd51db3be91c..fbb2c16693ad 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2898,7 +2898,7 @@ static int count_ah_combs(const struct xfrm_tmpl *t)
 			break;
 		if (!aalg->pfkey_supported)
 			continue;
-		if (aalg_tmpl_set(t, aalg))
+		if (aalg_tmpl_set(t, aalg) && aalg->available)
 			sz += sizeof(struct sadb_comb);
 	}
 	return sz + sizeof(struct sadb_prop);
@@ -2916,7 +2916,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 		if (!ealg->pfkey_supported)
 			continue;
 
-		if (!(ealg_tmpl_set(t, ealg)))
+		if (!(ealg_tmpl_set(t, ealg) && ealg->available))
 			continue;
 
 		for (k = 1; ; k++) {
@@ -2927,7 +2927,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 			if (!aalg->pfkey_supported)
 				continue;
 
-			if (aalg_tmpl_set(t, aalg))
+			if (aalg_tmpl_set(t, aalg) && aalg->available)
 				sz += sizeof(struct sadb_comb);
 		}
 	}
-- 
2.35.1

