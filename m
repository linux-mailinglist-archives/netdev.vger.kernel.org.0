Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D9857CA2F
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 14:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233251AbiGUMDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 08:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232422AbiGUMDb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 08:03:31 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C39584EF7
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 05:03:26 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id q43-20020a17090a17ae00b001f1f67e053cso1257609pja.4
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 05:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=I3xj1BUk6Tym4ioS2voa2TkINCfgZutqc6Q9iZDdzh0=;
        b=C1p4rzCce0frvmIWTfKnoeEqYnv2yH1Q2Vy9F+PwGMmdqHCASOYAht20I7mpRbDqq4
         1sjFM/VfuRrkDHoA9OPlblEV+ceqc80419guEaPxMtkvh8LZ224aOT2TbLBAJaPbzGpr
         SpeebEVnQjhpocTHZsu3zgvJ85YrEd8zvdfBM44JpzIiFCaXtIFHzObh1nFi8qCIwUYw
         Z8YX6vXy9enGw7LnLQI8qoMAJ3ncvk7F5Bx4p9qwWLLWPp1DoQNAQuoWUEmdp3USo3jy
         QXRISmP0mS3lYO4D+pNso5t2uM1sYzqL6qK8kylHc1mH89nZ8dY1ZnV+eJ16Vo0NBmJq
         CghA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=I3xj1BUk6Tym4ioS2voa2TkINCfgZutqc6Q9iZDdzh0=;
        b=HdYXdt2rxI0tiLINRx78FJIK0TGPdZqsYN27Myp9djPLj5lQ+jLFowyNzePYG2bi0H
         o1ot83TdHvEiIdipjWsOwrGswVgzTrI4mfS0auMUvK9h5FXrZN9fiUKxDr+OuOnof2ta
         kvGZGVFHSTeXDUFsSt8Ij6KvtIuZw2vqj0tNA7C4W+mJvA9FoTO23jQUf/1fD8AeSC2/
         D4xkiSKCK90OWoU/e0fCDBqUY9yptmNthT3ifxFWf8rPVYNGxyKP7aXX+oQ2etCQeEwq
         ZL81eYBOkcCXk7cKunM578y+EprJ+IbetQmkMJ2WTdi6ChSpuutbpBiJsl7DkBAdSSmk
         JASw==
X-Gm-Message-State: AJIora/4b6E+p9i7QQ1aAP9m8dgxXpBz4yIi/avS9uKY6jMrelGIW8l1
        IRjENZXSGYHptb/JQWCFFwQ=
X-Google-Smtp-Source: AGRyM1v+yat+8LDBHdMjh5r4C4wDC+bnFi4BUvq8gjHydd2RREnIBkPd2ylzpwiswjIkYBDRDD+TWw==
X-Received: by 2002:a17:90a:ba86:b0:1f0:98b:89fa with SMTP id t6-20020a17090aba8600b001f0098b89famr11282539pjr.26.1658405005675;
        Thu, 21 Jul 2022 05:03:25 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id s20-20020a170902a51400b001620960f1dfsm1466831plq.198.2022.07.21.05.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 05:03:24 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] net: mld: do not use system_wq in the mld
Date:   Thu, 21 Jul 2022 12:03:16 +0000
Message-Id: <20220721120316.17070-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mld works are supposed to be executed in mld_wq.
But mld_{query | report}_work() calls schedule_delayed_work().
schedule_delayed_work() internally uses system_wq.
So, this would cause the reference count leak.

splat looks like:
 unregister_netdevice: waiting for br1 to become free. Usage count = 2
 leaked reference.
  ipv6_add_dev+0x3a5/0x1070
  addrconf_notify+0x4f3/0x1760
  notifier_call_chain+0x9e/0x180
  register_netdevice+0xd10/0x11e0
  br_dev_newlink+0x27/0x100 [bridge]
  __rtnl_newlink+0xd85/0x14e0
  rtnl_newlink+0x5f/0x90
  rtnetlink_rcv_msg+0x335/0x9a0
  netlink_rcv_skb+0x121/0x350
  netlink_unicast+0x439/0x710
  netlink_sendmsg+0x75f/0xc00
  ____sys_sendmsg+0x694/0x860
  ___sys_sendmsg+0xe9/0x160
  __sys_sendmsg+0xbe/0x150
  do_syscall_64+0x3b/0x90
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: f185de28d9ae ("mld: add new workqueues for process mld events")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/ipv6/mcast.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 7f695c39d9a8..87c699d57b36 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -1522,7 +1522,6 @@ static void mld_query_work(struct work_struct *work)
 
 		if (++cnt >= MLD_MAX_QUEUE) {
 			rework = true;
-			schedule_delayed_work(&idev->mc_query_work, 0);
 			break;
 		}
 	}
@@ -1533,8 +1532,10 @@ static void mld_query_work(struct work_struct *work)
 		__mld_query_work(skb);
 	mutex_unlock(&idev->mc_lock);
 
-	if (!rework)
-		in6_dev_put(idev);
+	if (rework && queue_delayed_work(mld_wq, &idev->mc_query_work, 0))
+		return;
+
+	in6_dev_put(idev);
 }
 
 /* called with rcu_read_lock() */
@@ -1624,7 +1625,6 @@ static void mld_report_work(struct work_struct *work)
 
 		if (++cnt >= MLD_MAX_QUEUE) {
 			rework = true;
-			schedule_delayed_work(&idev->mc_report_work, 0);
 			break;
 		}
 	}
@@ -1635,8 +1635,10 @@ static void mld_report_work(struct work_struct *work)
 		__mld_report_work(skb);
 	mutex_unlock(&idev->mc_lock);
 
-	if (!rework)
-		in6_dev_put(idev);
+	if (rework && queue_delayed_work(mld_wq, &idev->mc_report_work, 0))
+		return;
+
+	in6_dev_put(idev);
 }
 
 static bool is_in(struct ifmcaddr6 *pmc, struct ip6_sf_list *psf, int type,
-- 
2.17.1

