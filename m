Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D54DA532E33
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 18:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236378AbiEXQB6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 12:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239340AbiEXQAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 12:00:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F3F9CF50;
        Tue, 24 May 2022 09:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46A54B81A55;
        Tue, 24 May 2022 16:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E117FC34113;
        Tue, 24 May 2022 16:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653408021;
        bh=/g7GJVGtj32KCuRI5XqiYNVqvcLMLdvs+UUNGBovEoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mk+QJ043opVPe/SuWItsCn5OiP3uFG6xmgkPZoAdL/quOGopxJuzbx71ryP3IY0fL
         zBUWVT4II8ridqFgcIL4sHWSS/NcdGVBzu8ROUCYntUOVIfPDWU+9HWYmhZw1dZOAu
         OMf/O0Le4xCbxisxBIDxFarRjpaY59xJBiwTO0gyN8u4+T1v7Cn5xYGVhs5rnPtAPx
         UFFW14Al8xEA6U1o5dHiMIpBxCsPZioM29rtPl5knUUc+fIf50ZX3JI23LJucTo8lj
         BjpRt4qaW8JleNakszccknWEDvO7PxqtGseM5AcWU/SaI4mHwD72kXhcPcHH+wbNEi
         RuEeG4+VF21xg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Bartschies <thomas.bartschies@cvk.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 06/10] net: af_key: check encryption module availability consistency
Date:   Tue, 24 May 2022 12:00:03 -0400
Message-Id: <20220524160009.826957-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220524160009.826957-1-sashal@kernel.org>
References: <20220524160009.826957-1-sashal@kernel.org>
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

