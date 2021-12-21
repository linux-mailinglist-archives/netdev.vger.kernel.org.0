Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E2547B788
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232475AbhLUCAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231817AbhLUB7c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 20:59:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2938FC061D60;
        Mon, 20 Dec 2021 17:59:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B445161166;
        Tue, 21 Dec 2021 01:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090C1C36AE8;
        Tue, 21 Dec 2021 01:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051963;
        bh=BNXgPjfocNKSR3tWjYTYadaxv98CJjuMh5GNFeludyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WS2WiYfov1k/3Xc8UeVClG/Fg1auuhjsEJyiBle4BPSp9W7H5ySgVW0aYWbnyR7Vo
         6RE7o8DTuzSoKSssEjRfh91p1aRhDviGtpsfNEDBYWrI69vMz64KqhLLGnF/11PCoz
         w/QiZG2lSxEX9FDszctz+YMYZui5IAC7GopUyYXpNFue4H5UHuL9AQy7waUKWQzwSJ
         tkn7r337+OPhi7FVDpdHImTzgn5Mo04Ku6ZRYz4MXB5RTD4hHBD31uPt9udSgev+RT
         QIVRoyr3TMTierDshmec7A8qPKRpnVnueP0RpC0/rVt3ODQ9JPYAHs5MsmL9qijcB7
         Mj+hV9x7lDy1w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Finn Behrens <me@kloenk.dev>, Finn Behrens <fin@nyantec.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        kuba@kernel.org, johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/19] nl80211: reset regdom when reloading regdb
Date:   Mon, 20 Dec 2021 20:59:00 -0500
Message-Id: <20211221015914.116767-5-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015914.116767-1-sashal@kernel.org>
References: <20211221015914.116767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Finn Behrens <me@kloenk.dev>

[ Upstream commit 1eda919126b420fee6b8d546f7f728fbbd4b8f11 ]

Reload the regdom when the regulatory db is reloaded.
Otherwise, the user had to change the regulatoy domain
to a different one and then reset it to the correct
one to have a new regulatory db take effect after a
reload.

Signed-off-by: Finn Behrens <fin@nyantec.com>
Link: https://lore.kernel.org/r/YaIIZfxHgqc/UTA7@gimli.kloenk.dev
[edit commit message]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/regulatory.h |  1 +
 net/wireless/reg.c       | 27 +++++++++++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/include/net/regulatory.h b/include/net/regulatory.h
index 47f06f6f5a67c..0cf9335431e07 100644
--- a/include/net/regulatory.h
+++ b/include/net/regulatory.h
@@ -83,6 +83,7 @@ struct regulatory_request {
 	enum nl80211_dfs_regions dfs_region;
 	bool intersect;
 	bool processed;
+	bool reload;
 	enum environment_cap country_ie_env;
 	struct list_head list;
 };
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a04fdfb35f070..341c88972aed1 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -133,6 +133,7 @@ static u32 reg_is_indoor_portid;
 
 static void restore_regulatory_settings(bool reset_user, bool cached);
 static void print_regdomain(const struct ieee80211_regdomain *rd);
+static void reg_process_hint(struct regulatory_request *reg_request);
 
 static const struct ieee80211_regdomain *get_cfg80211_regdom(void)
 {
@@ -1079,6 +1080,8 @@ int reg_reload_regdb(void)
 	const struct firmware *fw;
 	void *db;
 	int err;
+	const struct ieee80211_regdomain *current_regdomain;
+	struct regulatory_request *request;
 
 	err = request_firmware(&fw, "regulatory.db", &reg_pdev->dev);
 	if (err)
@@ -1099,8 +1102,27 @@ int reg_reload_regdb(void)
 	if (!IS_ERR_OR_NULL(regdb))
 		kfree(regdb);
 	regdb = db;
-	rtnl_unlock();
 
+	/* reset regulatory domain */
+	current_regdomain = get_cfg80211_regdom();
+
+	request = kzalloc(sizeof(*request), GFP_KERNEL);
+	if (!request) {
+		err = -ENOMEM;
+		goto out_unlock;
+	}
+
+	request->wiphy_idx = WIPHY_IDX_INVALID;
+	request->alpha2[0] = current_regdomain->alpha2[0];
+	request->alpha2[1] = current_regdomain->alpha2[1];
+	request->initiator = NL80211_USER_REG_HINT_USER;
+	request->user_reg_hint_type = NL80211_USER_REG_HINT_USER;
+	request->reload = true;
+
+	reg_process_hint(request);
+
+out_unlock:
+	rtnl_unlock();
  out:
 	release_firmware(fw);
 	return err;
@@ -2657,7 +2679,8 @@ reg_process_hint_user(struct regulatory_request *user_request)
 
 	treatment = __reg_process_hint_user(user_request);
 	if (treatment == REG_REQ_IGNORE ||
-	    treatment == REG_REQ_ALREADY_SET)
+	    (treatment == REG_REQ_ALREADY_SET &&
+	     !user_request->reload))
 		return REG_REQ_IGNORE;
 
 	user_request->intersect = treatment == REG_REQ_INTERSECT;
-- 
2.34.1

