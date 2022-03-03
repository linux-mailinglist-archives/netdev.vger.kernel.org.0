Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F7D4CC413
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 18:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiCCRiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 12:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiCCRiU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 12:38:20 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D41A2C128
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 09:37:34 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id 6so591340pgg.0
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 09:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IqBk163J54tSLaRPxp7ot55KxhOG2acpdqBW8vh7NA8=;
        b=PHcJ7LzmBRqt9YYI48V9uzjBOoDhhWjYcQHm3r8W+I/o4ongECCAso+cXD6ERUBMGh
         lEEogQn5zcd8iF+El+Y3gYa9RZPhMNASZSw6I6se23vtVeeSs2K2ML19VAomRHZKALns
         ghE5Yb1FTynLnZ+XoCM6PurMUjTGB/At3NxFpQjzc2qgnYeOylZ2CWBuev/gFSrjreTi
         VClnAHaB8Mp8OARlnqVZX4juTgwmmYfp1c833h3jVowz2EAdFeUOLT6vtIeY4I6iI6mw
         LbTCPBqg4qL5d8UMHoyWaS/HtKJjJAMxdPWwWlP6VWARrhOnSpm7R+MOfxetuk/wpPi3
         xVDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IqBk163J54tSLaRPxp7ot55KxhOG2acpdqBW8vh7NA8=;
        b=FlHsWadFjEvvGmhjE2eM1jia+F/puHwfsQW2QmAWCJ0VLJe7QgtUPmOpEysv5ixGDd
         CfGM/gBrTyUccRgOrxG6DzsP6oSV80HGJpkgkNDNpNlS65dqDdz2sOdRgMqzpt2/+NPr
         7u4sg1iGUyL8ohc5je1DaEDuEtsLP4Eyu24k2P/YWgOu1Aeql3uRk1N6YgxBZ8ji8fag
         rxccKOqKoLpP7DLCwK3sLjWV94kRbXwbiWMs49OeTEaKblHpX4Q7HIyKhRtHI246Y4XM
         dICi8KdhMj2MgnB2LECKHMCOButgZqWIT1MQQsP2VtjR/5/2fp8kfAVV4dXH42rnXWzW
         dk0Q==
X-Gm-Message-State: AOAM532LskVs3H9BVfuh+ZG7T+dlM+1bf/WgzYSYY2bxGY7QlezVgheE
        tDoXWLUk3jDuDxdI2TC5WHU=
X-Google-Smtp-Source: ABdhPJy0VYuXX3/Rb3L1Xbit8rRi4leLFWNqh41fZxGoLJHrNROciZRIm812XIm9dBXvDFqtGsVYcQ==
X-Received: by 2002:a05:6a00:a8f:b0:4e1:2619:11a2 with SMTP id b15-20020a056a000a8f00b004e1261911a2mr39109278pfl.53.1646329053585;
        Thu, 03 Mar 2022 09:37:33 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:87fe:92b5:3de5:d71e])
        by smtp.gmail.com with ESMTPSA id b3-20020a056a00114300b004cc39630bfcsm3107412pfm.207.2022.03.03.09.37.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 09:37:33 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@kernel.org>
Subject: [PATCH net] ipv6: fix skb drops in igmp6_event_query() and igmp6_event_report()
Date:   Thu,  3 Mar 2022 09:37:28 -0800
Message-Id: <20220303173728.937869-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

While investigating on why a synchronize_net() has been added recently
in ipv6_mc_down(), I found that igmp6_event_query() and igmp6_event_report()
might drop skbs in some cases.

Discussion about removing synchronize_net() from ipv6_mc_down()
will happen in a different thread.

Fixes: f185de28d9ae ("mld: add new workqueues for process mld events")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Taehee Yoo <ap420073@gmail.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: David Ahern <dsahern@kernel.org>
---
 include/net/ndisc.h |  4 ++--
 net/ipv6/mcast.c    | 32 ++++++++++++--------------------
 2 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 53cb8de0e589cec4161051a3cfd27de138b282ff..47ffb360ddfac154372d5cf8729a113e5ef736a0 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -475,9 +475,9 @@ int igmp6_late_init(void);
 void igmp6_cleanup(void);
 void igmp6_late_cleanup(void);
 
-int igmp6_event_query(struct sk_buff *skb);
+void igmp6_event_query(struct sk_buff *skb);
 
-int igmp6_event_report(struct sk_buff *skb);
+void igmp6_event_report(struct sk_buff *skb);
 
 
 #ifdef CONFIG_SYSCTL
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index a8861db52c1877e8bb94a0eee9154af7340d1ba1..909f937befd71fce194517d44cb9a4c5e2876360 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1371,27 +1371,23 @@ static void mld_process_v2(struct inet6_dev *idev, struct mld2_query *mld,
 }
 
 /* called with rcu_read_lock() */
-int igmp6_event_query(struct sk_buff *skb)
+void igmp6_event_query(struct sk_buff *skb)
 {
 	struct inet6_dev *idev = __in6_dev_get(skb->dev);
 
-	if (!idev)
-		return -EINVAL;
-
-	if (idev->dead) {
-		kfree_skb(skb);
-		return -ENODEV;
-	}
+	if (!idev || idev->dead)
+		goto out;
 
 	spin_lock_bh(&idev->mc_query_lock);
 	if (skb_queue_len(&idev->mc_query_queue) < MLD_MAX_SKBS) {
 		__skb_queue_tail(&idev->mc_query_queue, skb);
 		if (!mod_delayed_work(mld_wq, &idev->mc_query_work, 0))
 			in6_dev_hold(idev);
+		skb = NULL;
 	}
 	spin_unlock_bh(&idev->mc_query_lock);
-
-	return 0;
+out:
+	kfree_skb(skb);
 }
 
 static void __mld_query_work(struct sk_buff *skb)
@@ -1542,27 +1538,23 @@ static void mld_query_work(struct work_struct *work)
 }
 
 /* called with rcu_read_lock() */
-int igmp6_event_report(struct sk_buff *skb)
+void igmp6_event_report(struct sk_buff *skb)
 {
 	struct inet6_dev *idev = __in6_dev_get(skb->dev);
 
-	if (!idev)
-		return -EINVAL;
-
-	if (idev->dead) {
-		kfree_skb(skb);
-		return -ENODEV;
-	}
+	if (!idev || idev->dead)
+		goto out;
 
 	spin_lock_bh(&idev->mc_report_lock);
 	if (skb_queue_len(&idev->mc_report_queue) < MLD_MAX_SKBS) {
 		__skb_queue_tail(&idev->mc_report_queue, skb);
 		if (!mod_delayed_work(mld_wq, &idev->mc_report_work, 0))
 			in6_dev_hold(idev);
+		skb = NULL;
 	}
 	spin_unlock_bh(&idev->mc_report_lock);
-
-	return 0;
+out:
+	kfree_skb(skb);
 }
 
 static void __mld_report_work(struct sk_buff *skb)
-- 
2.35.1.616.g0bdcbb4464-goog

