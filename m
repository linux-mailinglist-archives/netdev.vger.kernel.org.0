Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6974E3745CA
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbhEERHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 13:07:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236588AbhEERDF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 13:03:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76C4B613F0;
        Wed,  5 May 2021 16:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232906;
        bh=8nAV+BLngu0fFs8EMp2agqkejTe7TnNMaP+QMkgtdMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OxANLPaAJOZ6lgDF1QjTSV8BQc9DBcc72EQY9EJjx3PQaCjLcGMw/wK0+hGpuNb9G
         yQ5FcLEUxCmZZQn3b6PiCZ4ghujlmaIF02NXquJT/Xx0oPN4xwA+SfPD9MgMOiNEdI
         K6JIRL26OCGAOEWkb4gxzz9V1FMRIE/zQIokYjP1IqKJygA3X68vD5z+T3+y5OMR9L
         Gds0UQLy7SRGno/fOcYt4a6ErO977l40lShffNWPXrTSeYoOZ91uCwMWpQHeOF+Hrx
         74Ri+ckl7qBgqe3riQ5/fMZSl98605rhbWtSc7Ys9+BDuhlg28v+7rh5yB6EHy9mpK
         IefaWh9naMxvg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 11/22] mac80211: clear the beacon's CRC after channel switch
Date:   Wed,  5 May 2021 12:41:18 -0400
Message-Id: <20210505164129.3464277-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505164129.3464277-1-sashal@kernel.org>
References: <20210505164129.3464277-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

[ Upstream commit d6843d1ee283137723b4a8c76244607ce6db1951 ]

After channel switch, we should consider any beacon with a
CSA IE as a new switch. If the CSA IE is a leftover from
before the switch that the AP forgot to remove, we'll get
a CSA-to-Self.

This caused issues in iwlwifi where the firmware saw a beacon
with a CSA-to-Self with mode = 1 on the new channel after a
switch. The firmware considered this a new switch and closed
its queues. Since the beacon didn't change between before and
after the switch, we wouldn't handle it (the CRC is the same)
and we wouldn't let the firmware open its queues again or
disconnect if the CSA IE stays for too long.

Clear the CRC valid state after we switch to make sure that
we handle the beacon and handle the CSA IE as required.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Link: https://lore.kernel.org/r/20210408143124.b9e68aa98304.I465afb55ca2c7d59f7bf610c6046a1fd732b4c28@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 58b80270e58c..3217c98f2b5a 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1101,6 +1101,11 @@ static void ieee80211_chswitch_post_beacon(struct ieee80211_sub_if_data *sdata)
 
 	sdata->vif.csa_active = false;
 	ifmgd->csa_waiting_bcn = false;
+	/*
+	 * If the CSA IE is still present on the beacon after the switch,
+	 * we need to consider it as a new CSA (possibly to self).
+	 */
+	ifmgd->beacon_crc_valid = false;
 
 	ret = drv_post_channel_switch(sdata);
 	if (ret) {
-- 
2.30.2

