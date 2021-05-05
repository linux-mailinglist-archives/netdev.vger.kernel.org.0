Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A90DE374294
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 18:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbhEEQrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:47:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235972AbhEEQpW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:45:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39FEE6192E;
        Wed,  5 May 2021 16:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232569;
        bh=mhTW7ap38pUqicSAQA9CEMmiuWNfQtIjQmf9McsxMc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oo7R51P7ILBhNcovemu/d2W1d6Vghed+Ba1FgqbrmMY1yyjCsjBDCWcJESE3LpDwc
         9l0SCX7YV/WXeLDEI2Z757HeGA1NAUqZl8qSd4aruEtpy3FbtvjZnEuBn8k97a83DN
         yEF7QlDq39ohZYZ4CvBWwKvRe74z++/nmk2g1MoCOClK30FjHiS/JQ71KoDihoofDW
         zfEXv4V9FLBWdE/RC1DabutwV9RKJMAiMH4hNFWSY2iUi5siJLBpE2qFPKpD8T6Ws8
         uCPD/KaEUf+LByqN0LPJqtPb2BCwGKM33nRsDp50en0vupLUEnoN04QRwvJeXTblZL
         sZGnVdRjRstCw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 079/104] mac80211: properly drop the connection in case of invalid CSA IE
Date:   Wed,  5 May 2021 12:33:48 -0400
Message-Id: <20210505163413.3461611-79-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163413.3461611-1-sashal@kernel.org>
References: <20210505163413.3461611-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 253907ab8bc0818639af382f6398810fa1f022b3 ]

In case the frequency is invalid, ieee80211_parse_ch_switch_ie
will fail and we may not even reach the check in
ieee80211_sta_process_chanswitch. Drop the connection
in case ieee80211_parse_ch_switch_ie failed, but still
take into account the CSA mode to remember not to send
a deauth frame in case if it is forbidden to.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210409123755.34712ef96a0a.I75d7ad7f1d654e8b0aa01cd7189ff00a510512b3@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c9eb75603576..fe71c1ca984a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1405,11 +1405,8 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 		ch_switch.delay = csa_ie.max_switch_time;
 	}
 
-	if (res < 0) {
-		ieee80211_queue_work(&local->hw,
-				     &ifmgd->csa_connection_drop_work);
-		return;
-	}
+	if (res < 0)
+		goto lock_and_drop_connection;
 
 	if (beacon && sdata->vif.csa_active && !ifmgd->csa_waiting_bcn) {
 		if (res)
-- 
2.30.2

