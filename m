Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 524B147B7C4
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 03:03:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234873AbhLUCBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 21:01:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234372AbhLUCAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 21:00:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2043AC061A08;
        Mon, 20 Dec 2021 18:00:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B9B3BB8110A;
        Tue, 21 Dec 2021 02:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65866C36AE5;
        Tue, 21 Dec 2021 02:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640052022;
        bh=Gw6UeiUH2+kw+PAZbOZfb+mp0ortwcexKlRJEU1oCyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YSA9Z/Y9TfddWdz2uOKRHQ6se4NpBipy/tb6Bx6fi25nncualqlYoQscLwQO7IG7y
         q9kz71n49bCJLIX4qGb+pDhknYGwZrh+F5M6IA40M+XZKAyZSpuLf86nf76owBjFwv
         L6a9GZeaC854YbSgYEPo8wMnsVzf0yGJFyCrASw+cl1ghqq/MvyO9ttb7q7hprX547
         iaOxMzpXYwQ1v3oeU6YZ6biLcwVmTGNdOo49tTf1L2Jsj3DjySib+n6NzfvcuzQX0F
         /LoJP9+TFSIEx/j+SHg7jcshD0jxbuMfkONi0InYB8AkRxHygBO1M2fLPFMQHc7+WU
         0V/2SpV/eF0Qg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 09/14] mac80211: Fix the size used for building probe request
Date:   Mon, 20 Dec 2021 20:59:47 -0500
Message-Id: <20211221015952.117052-9-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015952.117052-1-sashal@kernel.org>
References: <20211221015952.117052-1-sashal@kernel.org>
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
index decd46b383938..fc326a3fc2e64 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1901,7 +1901,7 @@ struct sk_buff *ieee80211_build_probe_req(struct ieee80211_sub_if_data *sdata,
 		chandef.chan = chan;
 
 	skb = ieee80211_probereq_get(&local->hw, src, ssid, ssid_len,
-				     100 + ie_len);
+				     local->scan_ies_len + ie_len);
 	if (!skb)
 		return NULL;
 
-- 
2.34.1

