Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B68ED6A1C8F
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 13:59:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjBXM7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 07:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjBXM7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 07:59:52 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 800FE16AE6;
        Fri, 24 Feb 2023 04:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
        Resent-Message-ID:In-Reply-To:References;
        bh=Jlgy46vRWm38XE44THWJNwk9UlLs82ccZrXvZt59/ZY=; t=1677243580; x=1678453180; 
        b=pd8tOzEa68iDArorQNvjGeWQUMiqha2b9SsDWBPjUBD+sD3j4BFHkhL2aSwDS9lHwog2cLlKjrN
        ekrM+eqgue8aay0ux6Wg6UjGY7Nh5tw27ENsehxHkytnGpJ7IxDtZP6Hd7MhnH7JKJfsKpbnZvwwC
        YML7egFD0edmTY6QK0dsN/2zd/gJDeWheIeWP49Oz2soA5zG4bSiOxLGVoqWHbLZtPdZTrQfSYtDc
        8LtAqZ+mbBEsKMpZ3r66vr29O7Acs7v/9XXYjduDVTHOWOciuJC+Mt/xebFcp473obHsYd6jkix7U
        OqBohAKVjBROyCChhWd7UKeOGWjHG12+k9Gg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pVXfl-004CST-1G;
        Fri, 24 Feb 2023 13:59:37 +0100
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        Nicolas Cavallari <Nicolas.Cavallari@green-communications.fr>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wifi: wext: warn about usage only once
Date:   Fri, 24 Feb 2023 13:59:34 +0100
Message-Id: <20230224135933.94104aeda1a0.Ie771c6a66d7d6c3cf67da5f3b0c66cea66fd514c@changeid>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Warn only once since the ratelimit parameters are still
allowing too many messages to happen. This will no longer
tell you all the different processes, but still gives a
heads-up of sorts.

Also modify the message to note that wext stops working
for future Wi-Fi 7 hardware, this is already implemented
in commit 4ca69027691a ("wifi: wireless: deny wireless
extensions on MLO-capable devices") and is maybe of more
relevance to users than the fact that we'd like to have
wireless extensions deprecated.

The issue with Wi-Fi 7 is that you can now have multiple
connections to the same AP, so a whole bunch of things
now become per link rather than per netdev, which can't
really be handled in wireless extensions.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
Not really sure I see a better solution ...

 - tracking it per task would be nice in a way I guess,
   but is also awful;
 - adjusting the rate limit will lead us into an endless
   bikeshedding discussion about the parameters;
 - removing the warning will leave us with no indiciation
   of what happens with Wi-Fi 7 hardware, although most of
   the processes using them now (like Chrome browser??)
   probably ignore failures from it
 - trying to support a 30+ year old technology on modern
   Wi-Fi 7 hardware will be "interesting" and lead to all
   kinds of hacks there
---
 net/wireless/wext-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index 13a72b17248e..a125fd1fa134 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -641,8 +641,8 @@ static void wireless_warn_cfg80211_wext(void)
 {
 	char name[sizeof(current->comm)];
 
-	pr_warn_ratelimited("warning: `%s' uses wireless extensions that are deprecated for modern drivers; use nl80211\n",
-			    get_task_comm(name, current));
+	pr_warn_once("warning: `%s' uses wireless extensions which will stop working for Wi-Fi 7 hardware; use nl80211\n",
+		     get_task_comm(name, current));
 }
 #endif
 
-- 
2.39.2

