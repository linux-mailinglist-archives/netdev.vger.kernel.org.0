Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2500E491BBC
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345654AbiARDI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:08:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352606AbiARDAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 22:00:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47765C02980C;
        Mon, 17 Jan 2022 18:46:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 294AB61315;
        Tue, 18 Jan 2022 02:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A59DC36AEB;
        Tue, 18 Jan 2022 02:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642474005;
        bh=ETlyL1vGfKy3FMGxoeXWr/m02+CklHI/tETSSripquc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCq1PszaAw1NJaRvIpPUboQTAZ1TuYlRynJ98/dAJWh+mboee9/ZvjERx/wr2QnGf
         05/eNcEhStRsgkLnuv8c9ll/lbcISTQX3KEZUlB/kX7oYd8Mrpom3cfPVoh5rZ3abD
         QS7U9/xQQVaVzuR3FwNhHjqWsLP69Juz+1ox2gOUPFAGpowGLsiGspY2Ll38hxGAJT
         BA7YieP3cDvpP1LRzuMm9oUf0uKLbfvHpcUZPFEMT7t4YXbnyeBh8wx1WkhgUbVrK8
         qLBHz6td2ElO5YqMte9T9eOMY5z9ebjwqdRDHaf9DIG57k6B3Ebjnp/5uv/dpvmKm9
         ut4hiERdpP20Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 64/73] mac80211: allow non-standard VHT MCS-10/11
Date:   Mon, 17 Jan 2022 21:44:23 -0500
Message-Id: <20220118024432.1952028-64-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
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
index 282bf336b15a4..464029892478f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -4693,7 +4693,7 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
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

