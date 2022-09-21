Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A21A5BFAB4
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 11:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbiIUJUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 05:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230403AbiIUJUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 05:20:15 -0400
Received: from out29-148.mail.aliyun.com (out29-148.mail.aliyun.com [115.124.29.148])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 995EE239;
        Wed, 21 Sep 2022 02:19:28 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.08073047|-1;BR=01201311R111S08rulernew998_84748_2000303;CH=blue;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0363558-0.00159698-0.962047;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047190;MF=arda@allwinnertech.com;NM=1;PH=DS;RN=9;RT=9;SR=0;TI=SMTPD_---.PKrbnDF_1663751957;
Received: from SunxiBot.allwinnertech.com(mailfrom:arda@allwinnertech.com fp:SMTPD_---.PKrbnDF_1663751957)
          by smtp.aliyun-inc.com;
          Wed, 21 Sep 2022 17:19:25 +0800
From:   Aran Dalton <arda@allwinnertech.com>
To:     johannes@sipsolutions.net, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     johannes.berg@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] cfg80211: fix dead lock for nl80211_del_interface()
Date:   Wed, 21 Sep 2022 17:19:13 +0800
Message-Id: <20220921091913.110749-2-arda@allwinnertech.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20220921091913.110749-1-arda@allwinnertech.com>
References: <20220921091913.110749-1-arda@allwinnertech.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both nl80211_del_interface and cfg80211_netdev_notifier_call hold the
same wiphy_lock, then cause deadlock.

The main call stack as bellow:

nl80211_del_interface() takes wiphy_lock
 -> cfg80211_remove_virtual_intf
  -> rdev_del_virtual_intf
   -> rdev->ops->del_virtual_intf
    -> cfg80211_unregister_netdevice
     -> cfg80211_unregister_wdev
      -> _cfg80211_unregister_wdev
       -> unregister_netdevice
        -> unregister_netdevice_queue
         -> unregister_netdevice_many
          -> call_netdevice_notifiers(NETDEV_UNREGISTER, dev);
           -> call_netdevice_notifiers_extack
            -> call_netdevice_notifiers_info
             -> raw_notifier_call_chain
              -> cfg80211_netdev_notifier_call
               -> wiphy_lock(&rdev->wiphy), _cfg80211_unregister_wdev

Fixes: a05829a7222e ("cfg80211: avoid holding the RTNL when calling the driver")
Signed-off-by: Aran Dalton <arda@allwinnertech.com>
---
 net/wireless/nl80211.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bdacddc3ffa3..664bf977b7bc 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4269,6 +4269,7 @@ static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct wireless_dev *wdev = info->user_ptr[1];
+	int ret;
 
 	if (!rdev->ops->del_virtual_intf)
 		return -EOPNOTSUPP;
@@ -4296,9 +4297,11 @@ static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
 	else
 		dev_close(wdev->netdev);
 
+	ret = cfg80211_remove_virtual_intf(rdev, wdev);
+
 	mutex_lock(&rdev->wiphy.mtx);
 
-	return cfg80211_remove_virtual_intf(rdev, wdev);
+	return ret;
 }
 
 static int nl80211_set_noack_map(struct sk_buff *skb, struct genl_info *info)
-- 
2.29.0

