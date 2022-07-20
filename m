Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA2057ACA5
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 03:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241807AbiGTBYH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 21:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241699AbiGTBXG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 21:23:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B49271BC3;
        Tue, 19 Jul 2022 18:17:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9736B81DED;
        Wed, 20 Jul 2022 01:17:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D87C341CE;
        Wed, 20 Jul 2022 01:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658279822;
        bh=QK4ZLMxYz6lMUO+AZMfvI9GivhdaN3+TxEVjJVTs2xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K7HFsDJqT+kEWrj89W4A4AyGE6gCUVSuMDalwrkoZ7omXNuy+6l7atgWuVnogMO8v
         E3hDt86eOscFsMf2GE/J1TuUUpEJlSsdxBX5kXKqVV+TOKmitc0NQkNRpXVUJ1yHjd
         SGXWTe9sTUM8hxYyOnOn8+C8f+QfvHFl88WeMQzliCxL20BAQhoYlOvhhVIYxWUnZL
         vchMRDIO/yIVr3g49GsrEzOhAdC8HYFq+4Qh3rq3+dOkm+7y2NrCgfk9LhHQjRSs3D
         vxRSQu1ynCDcakEFn+1UCRhdGLGe0ffkJxpOTSdBxKTULZLB4qApjqyVAbx6uqv5nN
         h/rAUpwfyrYZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vinayak Yadawad <vinayak.yadawad@broadcom.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>, johannes@sipsolutions.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 12/25] wifi: cfg80211: Allow P2P client interface to indicate port authorization
Date:   Tue, 19 Jul 2022 21:16:03 -0400
Message-Id: <20220720011616.1024753-12-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220720011616.1024753-1-sashal@kernel.org>
References: <20220720011616.1024753-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinayak Yadawad <vinayak.yadawad@broadcom.com>

[ Upstream commit 8d70f33ed7207e82e51d5a4436c8ba2268a83b14 ]

In case of 4way handshake offload, cfg80211_port_authorized
enables driver to indicate successful 4way handshake to cfg80211 layer.
Currently this path of port authorization is restricted to
interface type NL80211_IFTYPE_STATION. This patch extends
the use of port authorization API for P2P client as well.

Signed-off-by: Vinayak Yadawad <vinayak.yadawad@broadcom.com>
Link: https://lore.kernel.org/r/ef25cb49fcb921df2e5d99e574f65e8a009cc52c.1655905440.git.vinayak.yadawad@broadcom.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/sme.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 060e365c8259..cfece7e616ef 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1034,7 +1034,8 @@ void __cfg80211_port_authorized(struct wireless_dev *wdev, const u8 *bssid)
 {
 	ASSERT_WDEV_LOCK(wdev);
 
-	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
+	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION &&
+		    wdev->iftype != NL80211_IFTYPE_P2P_CLIENT))
 		return;
 
 	if (WARN_ON(!wdev->current_bss) ||
-- 
2.35.1

