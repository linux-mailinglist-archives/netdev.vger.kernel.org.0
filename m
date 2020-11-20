Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635F32BB3A4
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730874AbgKTSgm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:36:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:54918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731104AbgKTSgk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:36:40 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEF8F24178;
        Fri, 20 Nov 2020 18:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605897399;
        bh=Cw3kMT2soQFlDPoJ+IIlzptkUjp5pAY//sfQt0HVJxQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vwOYAMClyjcQKR/Ta3xDAdOdPSDdrLav4tWZRcBm2x4Xu6QZUouoUeDtYP9VZxnmd
         QK+ehil9FZLUnfDiOskUacZbxO9M1xOjjgMD4stRPoNqwP7u1HM153Zlgpl/l9K/c5
         C8n3m0nlC7fqGSXuQUHhipERZf9vWf2KS/Hwp+ug=
Date:   Fri, 20 Nov 2020 12:36:45 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 093/141] mac80211: Fix fall-through warnings for Clang
Message-ID: <1a9c4e8248e76e1361edbe2471a68773d87f0b67.1605896060.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break statements instead of
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 net/mac80211/cfg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 7276e66ae435..1d1a4f3c8d66 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -405,6 +405,7 @@ static int ieee80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	case WLAN_CIPHER_SUITE_WEP104:
 		if (WARN_ON_ONCE(fips_enabled))
 			return -EINVAL;
+		break;
 	case WLAN_CIPHER_SUITE_CCMP:
 	case WLAN_CIPHER_SUITE_CCMP_256:
 	case WLAN_CIPHER_SUITE_AES_CMAC:
@@ -3307,6 +3308,7 @@ static int ieee80211_set_csa_beacon(struct ieee80211_sub_if_data *sdata,
 			if (cfg80211_get_chandef_type(&params->chandef) !=
 			    cfg80211_get_chandef_type(&sdata->u.ibss.chandef))
 				return -EINVAL;
+			break;
 		case NL80211_CHAN_WIDTH_5:
 		case NL80211_CHAN_WIDTH_10:
 		case NL80211_CHAN_WIDTH_20_NOHT:
-- 
2.27.0

