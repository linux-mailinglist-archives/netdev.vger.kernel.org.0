Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572D64EF636
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239713AbiDAPba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 11:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245271AbiDAOyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:54:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAA12B51AB;
        Fri,  1 Apr 2022 07:42:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E93E4B8250D;
        Fri,  1 Apr 2022 14:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8CDC34113;
        Fri,  1 Apr 2022 14:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824172;
        bh=t5LJpJ90GgcTQG8KbXVFszdnwuR0NmlgzssKuKHuHBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vAlBWumvkJQQDeMjZXUJZqVWCmLke7cwj/15v/wV0TaPBkVUqMy0aSI8j1mUkZrb5
         hZ6DBIhkYekKircV/mmsUMVeXFOzVCLOK56V2MpcuKJa+tfRF5MMO5Ck6XcZmPR3Ua
         Jp/5l11/EeCtv1CmB7cjpgSa0EDpuvRI6kYV2yDOAB5yQQATinCHwYTjWhZAyEdA5N
         OzfmwQA3En2K2UBquFQETChlv64XGFx6PAhOUTl+bP9BinV3NmO1XHlG5qDP5B0Cg9
         VwhCOFmtEAh3Ztq/NN4ZSO1Lg56NiTaAqt/r6mmsR5IloHZI19jrqOgHhpvbiIY6pu
         b4S61pywTCdqA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 16/65] cfg80211: don't add non transmitted BSS to 6GHz scanned channels
Date:   Fri,  1 Apr 2022 10:41:17 -0400
Message-Id: <20220401144206.1953700-16-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401144206.1953700-1-sashal@kernel.org>
References: <20220401144206.1953700-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 5666ee154f4696c011dfa8544aaf5591b6b87515 ]

When adding 6GHz channels to scan request based on reported
co-located APs, don't add channels that have only APs with
"non-transmitted" BSSes if they only match the wildcard SSID since
they will be found by probing the "transmitted" BSS.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20220202104617.f6ddf099f934.I231e55885d3644f292d00dfe0f42653269f2559e@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index fd614a5a00b4..c1b2655682a8 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -702,8 +702,12 @@ static bool cfg80211_find_ssid_match(struct cfg80211_colocated_ap *ap,
 
 	for (i = 0; i < request->n_ssids; i++) {
 		/* wildcard ssid in the scan request */
-		if (!request->ssids[i].ssid_len)
+		if (!request->ssids[i].ssid_len) {
+			if (ap->multi_bss && !ap->transmitted_bssid)
+				continue;
+
 			return true;
+		}
 
 		if (ap->ssid_len &&
 		    ap->ssid_len == request->ssids[i].ssid_len) {
@@ -830,6 +834,9 @@ static int cfg80211_scan_6ghz(struct cfg80211_registered_device *rdev)
 		    !cfg80211_find_ssid_match(ap, request))
 			continue;
 
+		if (!request->n_ssids && ap->multi_bss && !ap->transmitted_bssid)
+			continue;
+
 		cfg80211_scan_req_add_chan(request, chan, true);
 		memcpy(scan_6ghz_params->bssid, ap->bssid, ETH_ALEN);
 		scan_6ghz_params->short_ssid = ap->short_ssid;
-- 
2.34.1

