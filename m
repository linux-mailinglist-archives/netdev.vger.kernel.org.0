Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A294F0CE9
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 01:16:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356986AbiDCXSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 19:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbiDCXSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 19:18:20 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2C636179;
        Sun,  3 Apr 2022 16:16:25 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id c42so1634907edf.3;
        Sun, 03 Apr 2022 16:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NhhW2Eyu1xu1QDZrrHqw8LVLz1fDQ3LIeut0tE9Tbvw=;
        b=loyfmZqxTivg6+bxWj4cW0YYrqXhD1JBH3Ikj0x9drhE/NRGkp41JNcKxfLeQQKTpZ
         9PIcrAq/ct6KMv+OnnKQXlR/9pID0HGU7aW3ssJBx/LW5rNQHqbt/xXx6RQ/J7JBD8xi
         GVOGY1eMK5KLNQDuCJFAvN3xtWcmJyNBjya4rUNjVRkUe2Kt9j3t/D0175E1KNMWO1Z3
         zras9ZpRrHdWEfaq7xVbGn9SfT5L/bsNWchSyoP8CCSyeu0HeGyxWssKi3yjeSaXSJ2d
         c+cdpz3HLWIJToLaXcVn9FcF2BfS74Q02JWOsANaeUdUxluL5eEUX38DHBMFn6b75fNw
         IAfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NhhW2Eyu1xu1QDZrrHqw8LVLz1fDQ3LIeut0tE9Tbvw=;
        b=4tQQtiqtzdYPEXeE4tAWNH69rVrgB3DVahp7ayjFtMuebM5iwKWYtyB8BowgvoiQ1K
         Is+TXtRK5cUe/oJCDnwjyJlh8b1C002cn8hiqLkJFvF7tRTZR7LGo2T1xaZ5pwvZ8Rwz
         /ZRCNTg1v3Cb/8v8kVdy1j3lmioRJ0pXG+J34mPw9HtMTeVhtyF2l2uLbp/TSyV9GX/v
         AcjNS3sk03f8Hg/4krkb/i2NFh8EJm0Q2WzEH0jhG6CBmh8HWMnll9Pgl6+TCBGsr2Mg
         N6lXvavchdGJj9C+YruAytW4722vSCsbhAZ7kcvl3uLflTnmeCx3cYvvrf94h56YY9Iz
         lnCw==
X-Gm-Message-State: AOAM533l7lhYt2foK0Z/7xC5baJiZj/+Sij32lPT8eP8jtMZCVTQnu6o
        v9sC+8nxO7uEiJkitULnbHTsB9agWHQ=
X-Google-Smtp-Source: ABdhPJw8NDaI15GPUjURdL3JQ7v/765I3hRLmEC+Bw3j7Dl+xmX4T2zDKj6cv/NhueOQiUQNm5zZHQ==
X-Received: by 2002:a05:6402:3496:b0:419:82d5:f1d9 with SMTP id v22-20020a056402349600b0041982d5f1d9mr30695304edc.36.1649027783382;
        Sun, 03 Apr 2022 16:16:23 -0700 (PDT)
Received: from nlaptop.localdomain (ptr-dtfv0poj8u7zblqwbt6.18120a2.ip6.access.telenet.be. [2a02:1811:cc83:eef0:f2b6:6987:9238:41ca])
        by smtp.gmail.com with ESMTPSA id o5-20020a170906974500b006dfc781498dsm3687004ejy.37.2022.04.03.16.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 16:16:22 -0700 (PDT)
From:   Niels Dossche <dossche.niels@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Niels Dossche <dossche.niels@gmail.com>
Subject: [PATCH net-next v2] ipv6: fix locking issues with loops over idev->addr_list
Date:   Mon,  4 Apr 2022 01:15:24 +0200
Message-Id: <20220403231523.45843-1-dossche.niels@gmail.com>
X-Mailer: git-send-email 2.35.1
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

idev->addr_list needs to be protected by idev->lock. However, it is not
always possible to do so while iterating and performing actions on
inet6_ifaddr instances. For example, multiple functions (like
addrconf_{join,leave}_anycast) eventually call down to other functions
that acquire the idev->lock. The current code temporarily unlocked the
idev->lock during the loops, which can cause race conditions. Moving the
locks up is also not an appropriate solution as the ordering of lock
acquisition will be inconsistent with for example mc_lock.

This solution adds an additional field to inet6_ifaddr that is used
to temporarily add the instances to a temporary list while holding
idev->lock. The temporary list can then be traversed without holding
idev->lock. This change was done in two places. In addrconf_ifdown, the
list_for_each_entry_safe variant of the list loop is also no longer
necessary as there is no deletion within that specific loop.

Suggested-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Niels Dossche <dossche.niels@gmail.com>
Acked-by: Paolo Abeni <pabeni@redhat.com>
---

Changes in v2:
 - Applied the code style suggestions
 - Made sure the lines don't exceed 80 chars such that checkpatch
   becomes happy

 include/net/if_inet6.h |  8 ++++++++
 net/ipv6/addrconf.c    | 30 ++++++++++++++++++++++++------
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 4cfdef6ca4f6..c8490729b4ae 100644
--- a/include/net/if_inet6.h
+++ b/include/net/if_inet6.h
@@ -64,6 +64,14 @@ struct inet6_ifaddr {
 
 	struct hlist_node	addr_lst;
 	struct list_head	if_list;
+	/*
+	 * Used to safely traverse idev->addr_list in process context
+	 * if the idev->lock needed to protect idev->addr_list cannot be held.
+	 * In that case, add the items to this list temporarily and iterate
+	 * without holding idev->lock.
+	 * See addrconf_ifdown and dev_forward_change.
+	 */
+	struct list_head	if_list_aux;
 
 	struct list_head	tmp_list;
 	struct inet6_ifaddr	*ifpub;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index b22504176588..1afc4c024981 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -797,6 +797,7 @@ static void dev_forward_change(struct inet6_dev *idev)
 {
 	struct net_device *dev;
 	struct inet6_ifaddr *ifa;
+	LIST_HEAD(tmp_addr_list);
 
 	if (!idev)
 		return;
@@ -815,14 +816,24 @@ static void dev_forward_change(struct inet6_dev *idev)
 		}
 	}
 
+	read_lock_bh(&idev->lock);
 	list_for_each_entry(ifa, &idev->addr_list, if_list) {
 		if (ifa->flags&IFA_F_TENTATIVE)
 			continue;
+		list_add_tail(&ifa->if_list_aux, &tmp_addr_list);
+	}
+	read_unlock_bh(&idev->lock);
+
+	while (!list_empty(&tmp_addr_list)) {
+		ifa = list_first_entry(&tmp_addr_list,
+				       struct inet6_ifaddr, if_list_aux);
+		list_del(&ifa->if_list_aux);
 		if (idev->cnf.forwarding)
 			addrconf_join_anycast(ifa);
 		else
 			addrconf_leave_anycast(ifa);
 	}
+
 	inet6_netconf_notify_devconf(dev_net(dev), RTM_NEWNETCONF,
 				     NETCONFA_FORWARDING,
 				     dev->ifindex, &idev->cnf);
@@ -3728,7 +3739,8 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 	unsigned long event = unregister ? NETDEV_UNREGISTER : NETDEV_DOWN;
 	struct net *net = dev_net(dev);
 	struct inet6_dev *idev;
-	struct inet6_ifaddr *ifa, *tmp;
+	struct inet6_ifaddr *ifa;
+	LIST_HEAD(tmp_addr_list);
 	bool keep_addr = false;
 	bool was_ready;
 	int state, i;
@@ -3820,16 +3832,23 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 		write_lock_bh(&idev->lock);
 	}
 
-	list_for_each_entry_safe(ifa, tmp, &idev->addr_list, if_list) {
+	list_for_each_entry(ifa, &idev->addr_list, if_list)
+		list_add_tail(&ifa->if_list_aux, &tmp_addr_list);
+	write_unlock_bh(&idev->lock);
+
+	while (!list_empty(&tmp_addr_list)) {
 		struct fib6_info *rt = NULL;
 		bool keep;
 
+		ifa = list_first_entry(&tmp_addr_list,
+				       struct inet6_ifaddr, if_list_aux);
+		list_del(&ifa->if_list_aux);
+
 		addrconf_del_dad_work(ifa);
 
 		keep = keep_addr && (ifa->flags & IFA_F_PERMANENT) &&
 			!addr_is_local(&ifa->addr);
 
-		write_unlock_bh(&idev->lock);
 		spin_lock_bh(&ifa->lock);
 
 		if (keep) {
@@ -3860,15 +3879,14 @@ static int addrconf_ifdown(struct net_device *dev, bool unregister)
 			addrconf_leave_solict(ifa->idev, &ifa->addr);
 		}
 
-		write_lock_bh(&idev->lock);
 		if (!keep) {
+			write_lock_bh(&idev->lock);
 			list_del_rcu(&ifa->if_list);
+			write_unlock_bh(&idev->lock);
 			in6_ifa_put(ifa);
 		}
 	}
 
-	write_unlock_bh(&idev->lock);
-
 	/* Step 5: Discard anycast and multicast list */
 	if (unregister) {
 		ipv6_ac_destroy_dev(idev);
-- 
2.35.1

