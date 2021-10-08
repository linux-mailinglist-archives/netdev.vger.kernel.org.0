Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301D5426CDA
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 16:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241313AbhJHOl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 10:41:59 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:54261 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230487AbhJHOl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 10:41:59 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633704004; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=sSLRHtqNzXBreWBcXMWeuNEstLNC79jQk6EwiNmqJ8A=; b=uC0CwbaPRIXYfFCM4tkNJN7VXfqyen3EPV8E+kwjTqjMgjARZu4jOfPN1arC1K3GzdRU3S3v
 YdXR5Ph1pQCInv4W6kCf0adC9sZjvoseXztZRMsSCssAIqLG8cXeAx8ed819YqAWebeFYD7u
 +ns/AM6SJbXSy1sapF5si2PCAzE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 6160582da45ca75307d2471a (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 08 Oct 2021 14:39:41
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 814CDC4360C; Fri,  8 Oct 2021 14:39:40 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from tykki.adurom.net (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1B997C4360C;
        Fri,  8 Oct 2021 14:39:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org 1B997C4360C
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     netdev@vger.kernel.org
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        sfr@canb.auug.org.au, geert@linux-m68k.org
Subject: [PATCH net-next] ath11k: fix m68k and xtensa build failure in ath11k_peer_assoc_h_smps()
Date:   Fri,  8 Oct 2021 17:39:32 +0300
Message-Id: <20211008143932.23884-1-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen reported that ath11k was failing to build on m68k and xtensa:

In file included from <command-line>:0:0:
In function 'ath11k_peer_assoc_h_smps',
    inlined from 'ath11k_peer_assoc_prepare' at drivers/net/wireless/ath/ath11k/mac.c:2362:2:
include/linux/compiler_types.h:317:38: error: call to '__compiletime_assert_650' declared with attribute error: FIELD_GET: type of reg too small for mask
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
                                      ^
include/linux/compiler_types.h:298:4: note: in definition of macro '__compiletime_assert'
    prefix ## suffix();    \
    ^
include/linux/compiler_types.h:317:2: note: in expansion of macro '_compiletime_assert'
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
  ^
include/linux/build_bug.h:39:37: note: in expansion of macro 'compiletime_assert'
 #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                     ^
include/linux/bitfield.h:52:3: note: in expansion of macro 'BUILD_BUG_ON_MSG'
   BUILD_BUG_ON_MSG((_mask) > (typeof(_reg))~0ull,  \
   ^
include/linux/bitfield.h:108:3: note: in expansion of macro '__BF_FIELD_CHECK'
   __BF_FIELD_CHECK(_mask, _reg, 0U, "FIELD_GET: "); \
   ^
drivers/net/wireless/ath/ath11k/mac.c:2079:10: note: in expansion of macro 'FIELD_GET'
   smps = FIELD_GET(IEEE80211_HE_6GHZ_CAP_SM_PS,

Fix the issue by using le16_get_bits() to specify the size explicitly.

Fixes: 6f4d70308e5e ("ath11k: support SMPS configuration for 6 GHz")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---

Dave & Jakub, as this fixes a build issue in net-next can you take this
directly to net-next? But if you prefer, I can also send this in a pull
request.

 drivers/net/wireless/ath/ath11k/mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 89ab2fa7557c..160740c45dd7 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -2076,8 +2076,8 @@ static void ath11k_peer_assoc_h_smps(struct ieee80211_sta *sta,
 		smps = ht_cap->cap & IEEE80211_HT_CAP_SM_PS;
 		smps >>= IEEE80211_HT_CAP_SM_PS_SHIFT;
 	} else {
-		smps = FIELD_GET(IEEE80211_HE_6GHZ_CAP_SM_PS,
-				 le16_to_cpu(sta->he_6ghz_capa.capa));
+		smps = le16_get_bits(sta->he_6ghz_capa.capa,
+				     IEEE80211_HE_6GHZ_CAP_SM_PS);
 	}
 
 	switch (smps) {
-- 
2.20.1

