Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD90467D9A
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 19:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238492AbhLCTAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 14:00:34 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:41150 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231935AbhLCTAd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 14:00:33 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 20C0FCE281C;
        Fri,  3 Dec 2021 18:57:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544E6C53FCD;
        Fri,  3 Dec 2021 18:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638557826;
        bh=dp0Dwd7/FHERsJ8wdDWfIhc5JTBnL6SdxrHXd1BnkM4=;
        h=From:To:Cc:Subject:Date:From;
        b=NI4Hs4SiNcOvJHXCSQ7uZ4OyzZ37IDbKuol2GAoBpzOyDSLaoQ1N2GDQnRFTz5WWv
         hKvHUrO4MhSqnm2Y9kNlMFs4OufqeNo1Gk68HKJt6LS+6stm8Og0umfW7EdlNSmrHu
         PGrxS6zZn/m5kspUgpt0Aiw1qDjoBqCiocWRV5O4mVYrsT1dzyqgKSSXl16fFWRmPe
         qlXS4YdTClsMJWIR2yq9ZZ2VSfADE2R0g2dIulZEDjRMLKaEEauYNpngCmL81YAI+E
         VVowzcBB2iRhwoln8XzGFrQrGZ2iz+IHIYT0somlBepEf0/rME/cis76Ob24WD93t4
         wr+tH1TSXwU5Q==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Finn Behrens <me@kloenk.dev>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Luca Coelho <luciano.coelho@intel.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        Sriram R <srirrama@codeaurora.org>,
        Qiheng Lin <linqiheng@huawei.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] nl80211: use correct enum type in reg_reload_regdb
Date:   Fri,  3 Dec 2021 19:56:45 +0100
Message-Id: <20211203185700.756121-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

NL80211_USER_REG_HINT_USER is not something that can be
assigned to an 'enum nl80211_reg_initiator', as pointed out
by gcc.

net/wireless/reg.c: In function 'reg_reload_regdb':
net/wireless/reg.c:1137:28: error: implicit conversion from 'enum nl80211_user_reg_hint_type' to 'enum nl80211_reg_initiator' [-Werror=enum-conversion]

I don't know what was intended here, most likely it was either
NL80211_REGDOM_SET_BY_CORE (same numeric value) or
NL80211_REGDOM_SET_BY_USER (most similar name), so I pick the former
here, leaving the behavior unchanged while avoiding the warning.

Fixes: 1eda919126b4 ("nl80211: reset regdom when reloading regdb")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 61f1bf1bc4a7..edb2081f75e8 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1134,7 +1134,7 @@ int reg_reload_regdb(void)
 	request->wiphy_idx = WIPHY_IDX_INVALID;
 	request->alpha2[0] = current_regdomain->alpha2[0];
 	request->alpha2[1] = current_regdomain->alpha2[1];
-	request->initiator = NL80211_USER_REG_HINT_USER;
+	request->initiator = NL80211_REGDOM_SET_BY_CORE;
 	request->user_reg_hint_type = NL80211_USER_REG_HINT_USER;
 	request->reload = true;
 
-- 
2.29.2

