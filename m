Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7BA347B795
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbhLUCAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:00:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233846AbhLUB7d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 20:59:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CC19C0698C5;
        Mon, 20 Dec 2021 17:59:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E73546134A;
        Tue, 21 Dec 2021 01:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556C8C36AEA;
        Tue, 21 Dec 2021 01:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051970;
        bh=eqWTnAp3ia26EsQ3I4FpKK4gnacNjnVF8JJ5oq1EA+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EnCu+uyR++1ud2nni7tRfIPLktE3FpLW7Xf11U6U6L7IgTLPpQOequdKaXu6v4Tgz
         ljd/HQdnqxJS3HDJG2GvHUxZbdXYllB0Cn25g0tSGmAF4NSW/Z/46TVIGGL0VZXaf7
         gU5DxR3LR2X+XpELAMoF65XsxmE+fJdBRMQUE4gD0qOwT3Bqd4mV0kj7XnDhzUv9Z7
         W4waYGTgqL4VYJi0784Z+U/5sQlwL9a1Nkm/oldmYhTM5tIIhCQdiTxr0pG/eDR6b5
         SI1BZz86feUlvdwQqHkG8G9jHNiMp+8wiq9AMKCpSk+uyatFtHek4Sp8ig4lRWqq/T
         A1IS6a3yIiLkQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 10/19] mac80211: Fix the size used for building probe request
Date:   Mon, 20 Dec 2021 20:59:05 -0500
Message-Id: <20211221015914.116767-10-sashal@kernel.org>
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

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit f22d981386d12d1513bd2720fb4387b469124d4b ]

Instead of using the hard-coded value of '100' use the correct
scan IEs length as calculated during HW registration to mac80211.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211129152938.0a82d6891719.I8ded1f2e0bccb9e71222c945666bcd86537f2e35@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index fbf56a203c0e8..5dfa26b533802 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2040,7 +2040,7 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 		chandef.chan = chan;
 
 	skb = ieee80211_probereq_get(&local->hw, src, ssid, ssid_len,
-				     100 + ie_len);
+				     local->scan_ies_len + ie_len);
 	if (!skb)
 		return NULL;
 
-- 
2.34.1

