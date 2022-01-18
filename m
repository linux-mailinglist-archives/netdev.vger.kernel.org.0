Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DE7491DD9
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:44:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345763AbiARDnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:43:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345804AbiARCz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:55:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3737FC02B865;
        Mon, 17 Jan 2022 18:44:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98BFD61294;
        Tue, 18 Jan 2022 02:44:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF949C36AEB;
        Tue, 18 Jan 2022 02:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473847;
        bh=xU/E0UOkkueNXhNTpQtFR0kqDRHiSMIPw0I95vr7Xqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fpeHFriLclUmbQqd+USw0jaJrRQCUpqtZ/I6VlzmRQJwSvWAxfULN+s+NHCyz0MzP
         9Xf1cQN5+EFuxLaBRyDDsjY1qpzMrVmnWYSCbqD3MVMbl/kgyxRJKdIWq4U5CzBVX/
         58ndZ+yTZEDynMxVJiso4M9QYDgIq9OMdS87zcqwMY1L4uLuSyZpuflWvbU26cvunB
         u2v/XwvVowzLbPIykENJxQVhS/oyTg6sCdrtlmer1zBZenzliTpn7UAnd5Bzd6JkF3
         Q1QgPkI0zvmYcASJA0QJ2Bri5V7FuwOZjsrkstJeZ+y6aq5uccGUF2zz+6HJPZgOFT
         wMDwYFxLPUvOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 102/116] mac80211: allow non-standard VHT MCS-10/11
Date:   Mon, 17 Jan 2022 21:39:53 -0500
Message-Id: <20220118024007.1950576-102-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit 04be6d337d37400ad5b3d5f27ca87645ee5a18a3 ]

Some AP can possibly try non-standard VHT rate and mac80211 warns and drops
packets, and leads low TCP throughput.

    Rate marked as a VHT rate but data is invalid: MCS: 10, NSS: 2
    WARNING: CPU: 1 PID: 7817 at net/mac80211/rx.c:4856 ieee80211_rx_list+0x223/0x2f0 [mac8021

Since commit c27aa56a72b8 ("cfg80211: add VHT rate entries for MCS-10 and MCS-11")
has added, mac80211 adds this support as well.

After this patch, throughput is good and iw can get the bitrate:
    rx bitrate:	975.1 MBit/s VHT-MCS 10 80MHz short GI VHT-NSS 2
or
    rx bitrate:	1083.3 MBit/s VHT-MCS 11 80MHz short GI VHT-NSS 2

Buglink: https://bugzilla.suse.com/show_bug.cgi?id=1192891
Reported-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://lore.kernel.org/r/20220103013623.17052-1-pkshih@realtek.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6a24431b90095..d27c444a19ed1 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4800,7 +4800,7 @@ void ieee80211_rx_list(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 				goto drop;
 			break;
 		case RX_ENC_VHT:
-			if (WARN_ONCE(status->rate_idx > 9 ||
+			if (WARN_ONCE(status->rate_idx > 11 ||
 				      !status->nss ||
 				      status->nss > 8,
 				      "Rate marked as a VHT rate but data is invalid: MCS: %d, NSS: %d\n",
-- 
2.34.1

