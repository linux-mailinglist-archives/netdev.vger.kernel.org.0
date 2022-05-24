Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7ACF532E70
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 18:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239660AbiEXQEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 12:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239622AbiEXQDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 12:03:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A28544C7B4;
        Tue, 24 May 2022 09:01:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B84F6176C;
        Tue, 24 May 2022 16:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684F1C34113;
        Tue, 24 May 2022 16:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653408096;
        bh=yDJsPSHh874jx8/dxp+KXwMEiQHn7tzJ/SjRRhElgj4=;
        h=From:To:Cc:Subject:Date:From;
        b=hgZToS82pEAKSxU/rAcbZby4fGJFjVWNnR7WEu8ViF+Ymf1oUNWWRFYlvzo1TvqN0
         /sVDn1G0HMDc2dpb3ImqAvieq2RkQ9iSKKrZ8ipcUbAbovJMSvTvjsq5Hw5u2THfmG
         KMvalW0let62SlbU8NtrJHbCq7alWPQ5B76GCS65vQuDTHs7xY3Q6m/yCQN370OWUi
         G2Sn9J5CzKLdFWQ3SxQ2lG3tyV6161w2w7CQdpU1Nax4T/O1m/mYHM/tnZDlZeMXhq
         +bfo+E9l8LRJnU7qadypHPVDuIWMdQRtg5LKk4LP/CglYO8evBG3yxWa28LfRXw0sQ
         /OYND1IMMzucw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Bartschies <thomas.bartschies@cvk.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 1/3] net: af_key: check encryption module availability consistency
Date:   Tue, 24 May 2022 12:01:29 -0400
Message-Id: <20220524160131.827384-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
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
index d7adac31b0fd..f342397a0b44 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2906,7 +2906,7 @@ static int count_ah_combs(const struct xfrm_tmpl *t)
 			break;
 		if (!aalg->pfkey_supported)
 			continue;
-		if (aalg_tmpl_set(t, aalg))
+		if (aalg_tmpl_set(t, aalg) && aalg->available)
 			sz += sizeof(struct sadb_comb);
 	}
 	return sz + sizeof(struct sadb_prop);
@@ -2924,7 +2924,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 		if (!ealg->pfkey_supported)
 			continue;
 
-		if (!(ealg_tmpl_set(t, ealg)))
+		if (!(ealg_tmpl_set(t, ealg) && ealg->available))
 			continue;
 
 		for (k = 1; ; k++) {
@@ -2935,7 +2935,7 @@ static int count_esp_combs(const struct xfrm_tmpl *t)
 			if (!aalg->pfkey_supported)
 				continue;
 
-			if (aalg_tmpl_set(t, aalg))
+			if (aalg_tmpl_set(t, aalg) && aalg->available)
 				sz += sizeof(struct sadb_comb);
 		}
 	}
-- 
2.35.1

