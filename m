Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACC1F6E77BA
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 12:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbjDSKtw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 06:49:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbjDSKtt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 06:49:49 -0400
Received: from hust.edu.cn (mail.hust.edu.cn [202.114.0.240])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8C36A4E;
        Wed, 19 Apr 2023 03:49:44 -0700 (PDT)
Received: from localhost.localdomain ([222.20.126.128])
        (user=ysxu@hust.edu.cn mech=LOGIN bits=0)
        by mx1.hust.edu.cn  with ESMTP id 33JAk3vV011645-33JAk3vW011645
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Wed, 19 Apr 2023 18:46:07 +0800
From:   Yingsha Xu <ysxu@hust.edu.cn>
To:     Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Yingsha Xu <ysxu@hust.edu.cn>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mac80211: remove return value check of debugfs_create_dir()
Date:   Wed, 19 Apr 2023 18:45:47 +0800
Message-Id: <20230419104548.30124-1-ysxu@hust.edu.cn>
X-Mailer: git-send-email 2.17.1
X-FEAS-AUTH-USER: ysxu@hust.edu.cn
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Smatch complains that:
debugfs_hw_add() warn: 'statsd' is an error pointer or valid

Debugfs checks are generally not supposed to be checked for errors
and it is not necessary here.

Just delete the dead code.

Signed-off-by: Yingsha Xu <ysxu@hust.edu.cn>
Reviewed-by: Dongliang Mu <dzm91@hust.edu.cn>
---
NOTES: The issue is found by static analysis and remains untested.
---

 net/mac80211/debugfs.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index dfb9f55e2685..207f772bd8ce 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -673,10 +673,6 @@ void debugfs_hw_add(struct ieee80211_local *local)
 
 	statsd = debugfs_create_dir("statistics", phyd);
 
-	/* if the dir failed, don't put all the other things into the root! */
-	if (!statsd)
-		return;
-
 #ifdef CONFIG_MAC80211_DEBUG_COUNTERS
 	DEBUGFS_STATS_ADD(dot11TransmittedFragmentCount);
 	DEBUGFS_STATS_ADD(dot11MulticastTransmittedFrameCount);
-- 
2.17.1

