Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26C465AD857
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 19:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238024AbiIERXU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 13:23:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238010AbiIERXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 13:23:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F8D52FC4;
        Mon,  5 Sep 2022 10:23:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B62E6144F;
        Mon,  5 Sep 2022 17:23:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD7BC433D6;
        Mon,  5 Sep 2022 17:23:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="TNueuWIj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1662398595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=QGF4zwsRqDXlEODl32ZtykriL3evuX7a16SgJVtXROs=;
        b=TNueuWIjHMZbhy3cN61L79VIeQ39tBC5k+XKr2YIzdk3h91M3D6hxFCpDtyY/S9QEc3nfq
        HWDelmeJb60ci9CuwKXhlWyTeNYnKAQDk7KM+6g+8Z07NYjV/53emIefMF4IiS0+KKPm/R
        LPvKN5EHRGTpiOVKFsGY6yD5ONm1Oo0=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d97d00fa (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Mon, 5 Sep 2022 17:23:14 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] iwlwifi: don't spam logs with NSS>2 messages
Date:   Mon,  5 Sep 2022 19:22:46 +0200
Message-Id: <20220905172246.105383-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I get a log line like this every 4 seconds when connected to my AP:

[15650.221468] iwlwifi 0000:09:00.0: Got NSS = 4 - trimming to 2

Looking at the code, this seems to be related to a hardware limitation,
and there's nothing to be done. In an effort to keep my dmesg
manageable, downgrade this error to "debug" rather than "info".

Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 5eb28f8ee87e..11536f115198 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -1833,8 +1833,8 @@ static void iwl_mvm_parse_ppe(struct iwl_mvm *mvm,
 	* If nss < MAX: we can set zeros in other streams
 	*/
 	if (nss > MAX_HE_SUPP_NSS) {
-		IWL_INFO(mvm, "Got NSS = %d - trimming to %d\n", nss,
-			 MAX_HE_SUPP_NSS);
+		IWL_DEBUG_INFO(mvm, "Got NSS = %d - trimming to %d\n", nss,
+			       MAX_HE_SUPP_NSS);
 		nss = MAX_HE_SUPP_NSS;
 	}
 
-- 
2.37.3

