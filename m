Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB83040275B
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 12:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245216AbhIGKsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 06:48:07 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:54950
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244744AbhIGKsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Sep 2021 06:48:06 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id C2CE94017C;
        Tue,  7 Sep 2021 10:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1631011618;
        bh=fX1N3TOwZMxrjPJFX3uSNd2JDuJSiQ0i8IY9scgNe1k=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=JrlWUbgVLY2tqzUxKRhjSIHz19gPT1essAZw/2RXf4i+t6cfwtRTl1RP6z4H+cr9H
         OmWsVdcqeo+TYRK7puMWmnNLNjT4/lTI2NeUnbpe+Trf1EfWqIP14FvcRTRHpmR0/n
         FsBwV6l3p/x280hMSizkX3pa2K6cm/dWozO30y4CVZ5Ujv+sB6LNRW/tHv57Su+iKU
         E/nPzPavrxOxhWIXoqMtSpJLhYe7Tv1vwOT2Iy1F3u+CzPhJ1Akp+lcXrasQcbY/gX
         2TJ4fZGW7GVaYQGENY1ysE9d8A1j7SfDN1CAHT2OFq4NhOP498CFAeUCZajITdWz1/
         S0PklCe4WiwQA==
From:   Colin King <colin.king@canonical.com>
To:     Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W . Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: Fix -EIO error code that is never returned
Date:   Tue,  7 Sep 2021 11:46:58 +0100
Message-Id: <20210907104658.14706-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Currently the error -EIO is being assinged to variable ret when
the READY_BIT is not set but the function iwlagn_mac_start returns
0 rather than ret. Fix this by returning ret instead of 0.

Addresses-Coverity: ("Unused value")
Fixes: 7335613ae27a ("iwlwifi: move all mac80211 related functions to one place")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
index 75e7665773c5..90fe4adca492 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/mac80211.c
@@ -304,7 +304,7 @@ static int iwlagn_mac_start(struct ieee80211_hw *hw)
 
 	priv->is_open = 1;
 	IWL_DEBUG_MAC80211(priv, "leave\n");
-	return 0;
+	return ret;
 }
 
 static void iwlagn_mac_stop(struct ieee80211_hw *hw)
-- 
2.32.0

