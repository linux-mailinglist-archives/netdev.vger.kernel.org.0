Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BFA05284CE
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 14:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235059AbiEPM5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 08:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236295AbiEPM5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 08:57:35 -0400
Received: from cvk-fw1.cvk.de (cvk-fw1.cvk.de [194.39.189.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D47393E0;
        Mon, 16 May 2022 05:57:32 -0700 (PDT)
Received: from localhost (cvk-fw1 [127.0.0.1])
        by cvk-fw1.cvk.de (Postfix) with ESMTP id 4L1zmp2D78z4wCd;
        Mon, 16 May 2022 14:57:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cvk.de; h=date
        :date:message-id:subject:subject:from:from; s=mailcvk20190509;
         t=1652705850; x=1654520251; bh=Utam1949PRlwRKGxLcllKJ7LrsVNbIWe
        hFQQTs1q+cw=; b=paQJWPWFMcO2U2DHv9w4nWP+VYpxbv5RHTW50GuzrcxmsxT7
        v7dcFqTfrRMuSd8yQOEhepHz0nJ/y2nI4/ahfgikllyNkfvp/Xnj+PyhjC/F4p8v
        QBN3+OMcbLrNvwOElQ5kcevJHEXh09GuhWxnPKCBZaffqiPPODbI+DfEYBgifIpy
        uknpk2xgl1we5F45CyDJ03s+BtNZoqACzpth36BqDvUnA6I538A4DoMyjxEyROqA
        UPa27D86M0L6O6/88rg8oO89DuukRz//zjUf7S/n0qCW5Ojh1r4PynoDcHVeWPnw
        3Nrzu92LJkuAKyP+90GfSqdtOtx1e1Jy9g8XSw==
X-Virus-Scanned: by amavisd-new at cvk.de
Received: from cvk-fw1.cvk.de ([127.0.0.1])
        by localhost (cvk-fw1.cvk.de [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id jEhoRymj2iNT; Mon, 16 May 2022 14:57:30 +0200 (CEST)
Received: from cvk027.cvk.de (cvk027.cvk.de [10.11.25.27])
        by cvk-fw1.cvk.de (Postfix) with ESMTP;
        Mon, 16 May 2022 14:57:30 +0200 (CEST)
Received: by cvk027.cvk.de (Postfix, from userid 0)
        id 4446D160219F3; Mon, 16 May 2022 14:57:30 +0200 (CEST)
From:   Thomas Bartschies <thomas.bartschies@cvk.de>
Cc:     Thomas Bartschies <thomas.bartschies@cvk.de>
Subject: [Patch] net: af_key: check encryption module availability consistency
Message-Id: <20220516125730.4446D160219F3@cvk027.cvk.de>
Date:   Mon, 16 May 2022 14:57:30 +0200 (CEST)
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,MISSING_HEADERS,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the recent introduction supporting the SM3 and SM4 hash algos for IPsec, the kernel 
produces invalid pfkey acquire messages, when these encryption modules are disabled. This 
happens because the availability of the algos wasn't checked in all necessary functions. 
This patch adds these checks.

Signed-off-by: Thomas Bartschies <thomas.bartschies@cvk.de>

diff -uprN a/net/key/af_key.c b/net/key/af_key.c
--- a/net/key/af_key.c	2022-05-09 09:16:33.000000000 +0200
+++ b/net/key/af_key.c	2022-05-13 13:51:58.286250337 +0200
@@ -2898,7 +2898,7 @@ static int count_ah_combs(const struct x
 			break;
 		if (!aalg->pfkey_supported)
 			continue;
-		if (aalg_tmpl_set(t, aalg))
+		if (aalg_tmpl_set(t, aalg) && aalg->available)
 			sz += sizeof(struct sadb_comb);
 	}
 	return sz + sizeof(struct sadb_prop);
@@ -2916,7 +2916,7 @@ static int count_esp_combs(const struct
 		if (!ealg->pfkey_supported)
 			continue;
 
-		if (!(ealg_tmpl_set(t, ealg)))
+		if (!(ealg_tmpl_set(t, ealg) && ealg->available))
 			continue;
 
 		for (k = 1; ; k++) {
@@ -2927,7 +2927,7 @@ static int count_esp_combs(const struct
 			if (!aalg->pfkey_supported)
 				continue;
 
-			if (aalg_tmpl_set(t, aalg))
+			if (aalg_tmpl_set(t, aalg) && aalg->available)
 				sz += sizeof(struct sadb_comb);
 		}
 	}
