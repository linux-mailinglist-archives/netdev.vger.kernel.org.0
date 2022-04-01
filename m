Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF5E4EF244
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 17:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349010AbiDAOxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 10:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351067AbiDAOsV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 10:48:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3946B5AECF;
        Fri,  1 Apr 2022 07:38:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF68D60B8D;
        Fri,  1 Apr 2022 14:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 386A1C34113;
        Fri,  1 Apr 2022 14:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823935;
        bh=UmlDQzkf8U3ut7O2vP2v5jscGnyqvm9S55BrksIsaI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3OmYw6rIORSswiCBzae1a37Q81E+sJWaWYcv+ODfJwI5+AviOqiiuK7WET78N0Ug
         pKdF6lKNCbkb5MHhB8CagkMJBSQYCYG/uzd44bQD8cwDVGfWHr6NBB4kwwnz1s0a/+
         kmpU8IzVr07LdC4cNEf1c5o/880+ykGZ3dViiAzmQdXKaO4jN2QpkKAtM73KC2MhOd
         /OUHuJXUvxXt4fq7VTzNFZ2BOcn0FF4jqYawtxiAzg3Yv5uG+yOTSbEUA3LV+hZ7+d
         +VhQdSnVGrbENFMSElXWMIAV0LVQNJWGJTv6a69ZkLwx5JyvbdL3syxa6mfwGS+/1F
         DSd4c1S/7Qrsg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 25/98] cfg80211: don't add non transmitted BSS to 6GHz scanned channels
Date:   Fri,  1 Apr 2022 10:36:29 -0400
Message-Id: <20220401143742.1952163-25-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143742.1952163-1-sashal@kernel.org>
References: <20220401143742.1952163-1-sashal@kernel.org>
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
index adc0d14cfd86..8e1e578d64bc 100644
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
@@ -829,6 +833,9 @@ static int cfg80211_scan_6ghz(struct cfg80211_registered_device *rdev)
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

