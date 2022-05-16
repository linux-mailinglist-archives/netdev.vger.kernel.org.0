Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADB9F52847C
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 14:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242991AbiEPMtB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 08:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242553AbiEPMsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 08:48:51 -0400
X-Greylist: delayed 586 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 16 May 2022 05:48:47 PDT
Received: from cvk-fw2.cvk.de (cvk-fw2.cvk.de [194.39.189.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912E1393F2;
        Mon, 16 May 2022 05:48:47 -0700 (PDT)
Received: by cvk-fw2.cvk.de (Postfix, from userid 0)
        id 4L1zMQ5drlz4wKQ; Mon, 16 May 2022 14:38:58 +0200 (CEST)
From:   Thomas Bartschies <thomas.bartschies@cvk.de>
Subject: [Patch] net: af_key: check encryption module availability consistency
Message-Id: <4L1zMQ5drlz4wKQ@cvk-fw2.cvk.de>
Date:   Mon, 16 May 2022 14:38:58 +0200 (CEST)
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,MISSING_HEADERS,
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
