Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22C972E13EF
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbgLWCgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:36:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:54080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729293AbgLWCY3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:24:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67A9922573;
        Wed, 23 Dec 2020 02:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690252;
        bh=nxV28MIrAz5BWQa9rCoG0oNed2DEcl13uz+rBFYBWsI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDQv0/CAii1rs7j6kaZ1gyGe83fyuAvYrWry0D1ITmlSaOTdNC3NLmj2prrWhwCyX
         E227qTGNcguRswzA9H4Dsw4G22CwkOJZpf0cWkwZHdYSlOw58CuRDJM1L0HPerwRTn
         IxSpbvQ9avZi8/1Owj1hPK50aP5EimVMT1M0QXtKtpEfRY6iTXUojLT8PwMOKkZy/S
         8s2ZrUR3S9CI3iukZYJR9utQGao9hakxFwReua3gBiCHOPf9n4fMfPmGaR80x4Ok8a
         IqZM9Aez7l/kHbDsqBg8eBGkgXAoXs68tIUEsAcS2McAj3RpwTE6m83lUHR6UZZ2Vn
         CxuWKnx683OIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 63/66] mac80211: don't filter out beacons once we start CSA
Date:   Tue, 22 Dec 2020 21:22:49 -0500
Message-Id: <20201223022253.2793452-63-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit 189a164d0fc6c59a22c4486d641d0a0a0d33387a ]

I hit a bug in which we started a CSA with an action frame,
but the AP changed its mind and didn't change the beacon.
The CSA wasn't cancelled and we lost the connection.

The beacons were ignored because they never changed: they
never contained any CSA IE. Because they never changed, the
CRC of the beacon didn't change either which made us ignore
the beacons instead of processing them.

Now what happens is:
1) beacon has CRC X and it is valid. No CSA IE in the beacon
2) as long as beacon's CRC X, don't process their IEs
3) rx action frame with CSA
4) invalidate the beacon's CRC
5) rx beacon, CRC is still X, but now it is invalid
6) process the beacon, detect there is no CSA IE
7) abort CSA

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201206145305.83470b8407e6.I739b907598001362744692744be15335436b8351@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c23364948f946..c18ca6ff1570d 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1262,6 +1262,7 @@ ieee80211_sta_process_chanswitch(struct ieee80211_sub_if_data *sdata,
 	sdata->csa_chandef = csa_ie.chandef;
 	sdata->csa_block_tx = csa_ie.mode;
 	ifmgd->csa_ignored_same_chan = false;
+	ifmgd->beacon_crc_valid = false;
 
 	if (sdata->csa_block_tx)
 		ieee80211_stop_vif_queues(local, sdata,
-- 
2.27.0

