Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143B237443D
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 19:47:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235917AbhEEQz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 12:55:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:58986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234550AbhEEQvC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 12:51:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A61061446;
        Wed,  5 May 2021 16:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232664;
        bh=xwuLWojHP5Hg4h0xP7sbXO+rq65Smp/CTzPEGhCWUcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1wlwTVyONnZi//TClYPmOTgCt++eP9PCqBUeF9SbrFA3lb8/OF/+D1ZKLSDopbnh
         HaOB8CLlHC7+LEypZmV0wwDCop2HCmD1x3cxQOrHEDLEP3onX9ec4LgED3g4dyt5jH
         5SFFzLkazovg0qtswkAyCvqZXrsSc92PUhFLhJGBry5gOuXfyKHV3/R0iUPAH0HsZl
         bV5fCLVBBzE7NAaJM+zI9HNwsyouFcqYTZdH/ENLufYvySCmD/jMCQA7B0Gxf/IHyV
         uQABsW8K8/+HOkWDFi485PkYmEXSDUT2QeInmEn2Td2Ln8RPxR3sztPWz6I3blAlC/
         oiZ9ss5OlqZnA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 38/85] mac80211: clear the beacon's CRC after channel switch
Date:   Wed,  5 May 2021 12:36:01 -0400
Message-Id: <20210505163648.3462507-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
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
index ef19c3399b89..6d3220c66931 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1295,6 +1295,11 @@ static void ieee80211_chswitch_post_beacon(struct ieee80211_sub_if_data *sdata)
 
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

