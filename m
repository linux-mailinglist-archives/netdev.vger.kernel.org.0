Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E115BFAB1
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 11:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231608AbiIUJU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 05:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiIUJUA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 05:20:00 -0400
Received: from out29-196.mail.aliyun.com (out29-196.mail.aliyun.com [115.124.29.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BD1B9080E;
        Wed, 21 Sep 2022 02:19:19 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.190038|-1;BR=01201311R781S98rulernew998_84748_2000303;CH=blue;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0916624-0.0191534-0.889184;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047212;MF=arda@allwinnertech.com;NM=1;PH=DS;RN=9;RT=9;SR=0;TI=SMTPD_---.PKrbnBk_1663751956;
Received: from SunxiBot.allwinnertech.com(mailfrom:arda@allwinnertech.com fp:SMTPD_---.PKrbnBk_1663751956)
          by smtp.aliyun-inc.com;
          Wed, 21 Sep 2022 17:19:17 +0800
From:   Aran Dalton <arda@allwinnertech.com>
To:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     johannes.berg@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] cfg80211: fix dead lock for nl80211_new_interface()
Date:   Wed, 21 Sep 2022 17:19:12 +0800
Message-Id: <20220921091913.110749-1-arda@allwinnertech.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both nl80211_new_interface and cfg80211_netdev_notifier_call hold the
same wiphy_lock, then cause deadlock.

The main call stack as bellow:

nl80211_new_interface() takes wiphy_lock
 -> _nl80211_new_interface:
  -> rdev_add_virtual_intf
   -> rdev->ops->add_virtual_intf
    -> register_netdevice
     -> call_netdevice_notifiers(NETDEV_REGISTER, dev);
      -> call_netdevice_notifiers_extack
       -> call_netdevice_notifiers_info
        -> raw_notifier_call_chain
         -> cfg80211_netdev_notifier_call
          -> wiphy_lock(&rdev->wiphy), cfg80211_register_wdev

Fixes: ea6b2098dd02 ("cfg80211: fix locking in netlink owner interface destruction")
Signed-off-by: Aran Dalton <arda@allwinnertech.com>
---
 net/wireless/nl80211.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 2705e3ee8fc4..bdacddc3ffa3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4260,9 +4260,7 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	/* to avoid failing a new interface creation due to pending removal */
 	cfg80211_destroy_ifaces(rdev);
 
-	wiphy_lock(&rdev->wiphy);
 	ret = _nl80211_new_interface(skb, info);
-	wiphy_unlock(&rdev->wiphy);
 
 	return ret;
 }
-- 
2.29.0

