Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BE72E15FB
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:59:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731399AbgLWC4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:56:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:45508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727144AbgLWCU6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:20:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C0F42333D;
        Wed, 23 Dec 2020 02:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690039;
        bh=n2APBAAFlUerQAQIuTD9g+9eWy1+0CiK4weSE1Tlp7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P8SHaDqFAq7K673lmYLeHt+AnGFhPoblMfkeWuGhuWFm6Cmz8aDaijFnXC/j1hHFC
         8Bdkx5qPnxXBbbbsXDXD8pLNG1FJ8bUOPDZQwo6MU4Gu8bwK8rQPepz2/EE46hJp0k
         o/ZtktmqHdwg3Rp74pqQcsmH6jBCtE6BCrlq3W8egjiibtGmheJdEze2z6nx+bgkVD
         nkU6tZg8FPgRMJLI7xJPx/mV2mUz310PL00r1bXTUWzJDjAykL4uenG4Rs5O1+idVt
         /QfAc9Pia5Cch9kaaD7H2elN2z9Bz9YF/d+xl6xbKjA+c+hBWBek2u1ZPNkKss2WoM
         T9vwAksN05dIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 113/130] iwlwifi: mvm: disconnect if channel switch delay is too long
Date:   Tue, 22 Dec 2020 21:17:56 -0500
Message-Id: <20201223021813.2791612-113-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 87d9564e14cf5d05e4f1fa4eb7c55d798427f1dd ]

If the channel switch delay that we would incur after the channel
switch actually happens is longer than the quiet time we're willing
to tolerate, disconnect as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201209231352.3bc3449922da.Ib0255deb67b2fc21317e274adcacb545bb1dc669@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index daae86cd61140..366dc2d756bfb 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4523,6 +4523,9 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 
 		break;
 	case NL80211_IFTYPE_STATION:
+		if (chsw->delay > IWL_MAX_CSA_BLOCK_TX)
+			schedule_delayed_work(&mvmvif->csa_work, 0);
+
 		if (chsw->block_tx) {
 			/*
 			 * In case of undetermined / long time with immediate
-- 
2.27.0

