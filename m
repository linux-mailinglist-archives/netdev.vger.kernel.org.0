Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBE0615313
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 21:19:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbiKAUTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 16:19:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbiKAUTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 16:19:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB31962DD;
        Tue,  1 Nov 2022 13:19:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EA9DB81EAC;
        Tue,  1 Nov 2022 20:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A65C433C1;
        Tue,  1 Nov 2022 20:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667333983;
        bh=u9GEg3aVkZhSlBq5l4HhWxMmMTW6emU2oZ1Zd97ij5I=;
        h=From:To:Cc:Subject:Date:From;
        b=tbggohFdWsmd4HDsXgf1oWM9rmbjwU6yjS9gQ8wS0g8hNZROzvhQuUR2U8ca+u9QJ
         TUfaU5WChMrwRajFJRYojgYSdnZpxojTHOjX9MnzFx0+gSMdqnkt+ChkBhNxOKwo8G
         Na9u3QsgXXlXT267sBNuprRR8y5f/HBj6x9VzQ56NqGOdtQ3RB19zQ9g6xAPfHDDfe
         Q5oKUydPQS8epo7vL1j5gmakacC/MlCxaXdXCxi9J4iicg27PoeYUEqxDWNvQKJU+4
         tHg2apVnLSRTmH0KRicdpnAfTjjrH9pz4tYZFuB7go0J3YagkhZ5veRpa6z+BSmwuH
         N1/cDHCvHsIqQ==
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     johannes@sipsolutions.net
Cc:     dinguyen@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] wifi: cfg80211: fix a possible memory leak
Date:   Tue,  1 Nov 2022 15:19:31 -0500
Message-Id: <20221101201931.119136-1-dinguyen@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Klockworks reported a possible memory leak when
cfg80211_inform_single_bss_data() return on an error and ies is left
allocated.

Fixes: 0e227084aee3 ("cfg80211: clarify BSS probe response vs. beacon data")
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 net/wireless/scan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 806a5f1330ff..3c81dc17e079 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2015,8 +2015,10 @@ cfg80211_inform_single_bss_data(struct wiphy *wiphy,
 
 	signal_valid = data->chan == channel;
 	res = cfg80211_bss_update(wiphy_to_rdev(wiphy), &tmp, signal_valid, ts);
-	if (!res)
+	if (!res) {
+		kfree(ies);
 		return NULL;
+	}
 
 	if (channel->band == NL80211_BAND_60GHZ) {
 		bss_type = res->pub.capability & WLAN_CAPABILITY_DMG_TYPE_MASK;
-- 
2.25.1

