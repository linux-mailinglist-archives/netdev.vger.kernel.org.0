Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BEA2B4EFE
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 19:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731898AbgKPSQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 13:16:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47936 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731241AbgKPSQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 13:16:42 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kej3M-0006bF-Ao; Mon, 16 Nov 2020 18:16:36 +0000
From:   Colin King <colin.king@canonical.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: make a const array static, makes object smaller
Date:   Mon, 16 Nov 2020 18:16:36 +0000
Message-Id: <20201116181636.362729-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the const array bws on the stack but instead it
static. Makes the object code smaller by 80 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
  85694	  16865	   1216	 103775	  1955f	./net/wireless/reg.o

After:
   text	   data	    bss	    dec	    hex	filename
  85518	  16961	   1216	 103695	  1950f	./net/wireless/reg.o

(gcc version 10.2.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a04fdfb35f07..c037960e5a1a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1616,7 +1616,7 @@ static const struct ieee80211_reg_rule *
 __freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 min_bw)
 {
 	const struct ieee80211_regdomain *regd = reg_get_regdomain(wiphy);
-	const u32 bws[] = {0, 1, 2, 4, 5, 8, 10, 16, 20};
+	static const u32 bws[] = {0, 1, 2, 4, 5, 8, 10, 16, 20};
 	const struct ieee80211_reg_rule *reg_rule;
 	int i = ARRAY_SIZE(bws) - 1;
 	u32 bw;
-- 
2.28.0

