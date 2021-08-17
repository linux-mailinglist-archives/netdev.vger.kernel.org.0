Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2353EEAB0
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 12:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239500AbhHQKNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 06:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239243AbhHQKNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 06:13:06 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE55C0613C1;
        Tue, 17 Aug 2021 03:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=BSLDGgwU3Io+1t6RHfAUzJKmFh2J1hKUUHjH+rZAW3U=; t=1629195153; x=1630404753; 
        b=CpO0tjDdPGiQxXMwHFwJZZgx+ShSP4qmsaJzLLMv8e+vPHX5k6n9N/U3tkGkil3EdC3omoflZek
        g36WKedQkDl+g4R7ty8uJVkr7Ap+3zKGMBfLQ6EvsSB0nzFhWLttxKmuL4UkRizaMmTvkONk68RqV
        fMYps4c2GJRFXM+Dh5vgnXwjwRtCJTldoXNysjmyCG54jIkXk5lCidrY+usWGFXCpu+i56FzFCFga
        c/C/A55QnhsFcg605aoj+XONkj4ppJLqnNMJbr1NCRHfO0igMxkmqzaHloznMZb119ctj99+u0hp7
        bnu+ciLZWL5RMfLxQ3bQd1gmD2MqlkOltlDg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1mFw56-00CDW8-1F; Tue, 17 Aug 2021 12:12:28 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH net] mac80211: fix locking in ieee80211_restart_work()
Date:   Tue, 17 Aug 2021 12:12:22 +0200
Message-Id: <20210817121210.47bdb177064f.Ib1ef79440cd27f318c028ddfc0c642406917f512@changeid>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Ilan's change to move locking around accidentally lost the
wiphy_lock() during some porting, add it back.

Fixes: 45daaa131841 ("mac80211: Properly WARN on HW scan before restart")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Can you please apply this directly to net? I don't have any
other patches, so not much sense in sending a pull request.
---
 net/mac80211/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 05f4c3c72619..fcae76ddd586 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -260,6 +260,8 @@ static void ieee80211_restart_work(struct work_struct *work)
 	flush_work(&local->radar_detected_work);
 
 	rtnl_lock();
+	/* we might do interface manipulations, so need both */
+	wiphy_lock(local->hw.wiphy);
 
 	WARN(test_bit(SCAN_HW_SCANNING, &local->scanning),
 	     "%s called with hardware scan in progress\n", __func__);
-- 
2.31.1

