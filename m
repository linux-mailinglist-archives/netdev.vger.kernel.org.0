Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928E253810F
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 16:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238093AbiE3N73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 09:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236819AbiE3N5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 09:57:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF16A8B088;
        Mon, 30 May 2022 06:38:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AE7260F3B;
        Mon, 30 May 2022 13:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714DFC385B8;
        Mon, 30 May 2022 13:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917930;
        bh=LPSSCwqGaNrNkqp/n9QTqw04SGRP8OwOqgtrF6QVz+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cNlwpIR9bJPpoizcltsWki95qBzjkp2WixAzpcDOvX3SrWovSrGPJI5JQ02vTw3Gy
         H6aeap0tGCZjDhRTEkAqJ85KhOY9B2o6PVN3+TFdgQydG2EbAQcIyS+UKwYGsmAs6J
         +y2q1FbmA3S7xRoCdbbLUyjnOaaW2rQCypAl7FzK59tiejIdfsoWRSiEIS+utR5CaX
         UYRs1Hlc/YB8/dHNCmqKd71EfxeiVRPkB0JoZgT4ppxigxDfwonJgUlGiw3dLNKTBW
         7PAP+Z6EEpKNm6T6wl0TrpWuMFCz1LRBabjP64zeIG4jaN+nICdATMS3WEeKi7lETI
         n8ISdy1aPU3sQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Niels Dossche <dossche.niels@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 010/109] ipv6: fix locking issues with loops over idev->addr_list
Date:   Mon, 30 May 2022 09:36:46 -0400
Message-Id: <20220530133825.1933431-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133825.1933431-1-sashal@kernel.org>
References: <20220530133825.1933431-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Niels Dossche <dossche.niels@gmail.com>

[ Upstream commit 51454ea42c1ab4e0c2828bb0d4d53957976980de ]

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
Link: https://lore.kernel.org/r/20220403231523.45843-1-dossche.niels@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/if_inet6.h |  8 ++++++++
 net/ipv6/addrconf.c    | 30 ++++++++++++++++++++++++------
 2 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
index 653e7d0f65cb..8ec0878a90a7 100644
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
index 3a8838b79bb6..1ba5ff21412c 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -798,6 +798,7 @@ static void dev_forward_change(struct inet6_dev *idev)
 {
 	struct net_device *dev;
 	struct inet6_ifaddr *ifa;
+	LIST_HEAD(tmp_addr_list);
 
 	if (!idev)
 		return;
@@ -816,14 +817,24 @@ static void dev_forward_change(struct inet6_dev *idev)
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

