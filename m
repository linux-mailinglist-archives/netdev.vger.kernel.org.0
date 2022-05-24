Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE08532E42
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 18:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239310AbiEXQCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 12:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239348AbiEXQBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 12:01:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8737A7750;
        Tue, 24 May 2022 09:00:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B98A6175C;
        Tue, 24 May 2022 16:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE3DC3411A;
        Tue, 24 May 2022 16:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653408045;
        bh=wWxUCVgmoyE9TpGdM86AqF4tu7PdSDYQTSN2Ki2Rw60=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYZSXiQbBl1CkHDYrbOlJcr/96cYJpz8Xx7xSniihXkH5kFCM2nCnRVRJzACTPzzI
         HtwixR4NBVQkki8QGlpIl51zq83c5T2GG9oFR3uHTQNiZs8xOgGWb1M+5y1Stj6Fuh
         TYIWvgobb0rMougN/7QGQKcxaPpLypiOpTbbHCAe1eMXBxoPvOfHIHSBK5S9TyGGFe
         CJ5/3FIeir4bkr9vTNEM+aOU3ZXwYVKyY8B8I5hdhJUshBmchxfR7821YmH+1Ap8/M
         21D1IydLVb7iDPCltavug+tDA4OuX93UCxniyaxR26UHqRA6Xo9EwLItPViB9sO3n4
         M+4pg9JMUtedQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Bartschies <thomas.bartschies@cvk.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 4/8] net: af_key: check encryption module availability consistency
Date:   Tue, 24 May 2022 12:00:31 -0400
Message-Id: <20220524160035.827109-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524160035.827109-1-sashal@kernel.org>
References: <20220524160035.827109-1-sashal@kernel.org>
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
index bd9b5c573b5a..ae466256ab8c 100644
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

