Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBEC1269381
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 19:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgINR15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 13:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgINR0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 13:26:34 -0400
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5DE0C061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 10:26:32 -0700 (PDT)
Received: by mail-pj1-x1049.google.com with SMTP id hr13so499024pjb.3
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 10:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=PQr51oLt7gFvXdGEi4RaoFMJAvJLCKvLDQkYyMQ+TnE=;
        b=ukPXw99fFce5QP/Wfa0z3Q4vl+10VKzHKklnQFvqoY4iIz+W4BJ7MKf8BlEEkxu2dn
         2J1jBCybOoPXBnkqri7YFsAwoqX8lQERggtl10pCRV7UEXqsotC2UbPGXIvpn5clOgSX
         +u1TDy1kPwIdJJkTxqOvjpVveO/Vec7pH/DNpsANWAJyj5BsbIcUSRzc9WKdEruxTRrY
         g230U8qUlWTEyxP7UaVZ8TFkOL2edjyHs9od9WFqvMPpTI27M4NWYn+LQLVBdFpfpqNJ
         f5N1KSOwaToDrTMoh4Ea9rgMx6gVNHQMmM8i/zrkI/nL5gxzZtQJ9W1FsJPvljOUHQNR
         OB4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PQr51oLt7gFvXdGEi4RaoFMJAvJLCKvLDQkYyMQ+TnE=;
        b=X6kbyJMivy+ccR/TuAwLTy19gN6b/emhxKRdb7ZmqGOWI1apmOGyZLBtoXYDJpTQAO
         lQ10iQnU9VaA0F/FtyaEx7ewm7oGBc3iCG2x92usAVvDJF/zWy2gcaUz9hLMw9IgpU9Z
         O+Zp6uofCHT1huTHTlb8XHBdGwiRp0VtApVKZhwuCQv8dKQ6+B6eE1hk+kgMxKtP9pLx
         lkoIxJxQkuSC22av3bDCjRz08pQTQrE1NA7L6/W9b2nY273HXLziMXwlAmSz4oxRjAsy
         oVOo/4HqEkC9NCiEZCHAdKQPvoLiNXqAdq78wYNzf5yJBYwu0HKgdU8cStjqvcOncDTB
         YI8A==
X-Gm-Message-State: AOAM532y+XjeHMB6zhSD9qBO+gtfbkQi5c+FMRh39WTNtKOmyzduY9Kz
        mxii+sGHYm2mveroP0MWVt8IVy2y9Ng=
X-Google-Smtp-Source: ABdhPJy5d2Vp/j9Lr4okRSrVE8uSrBJKS+z9eiiFHItwr39nG+gSO+Ru8FEdpGtrDul1Q8DgiI92lMrPIVE=
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a17:902:ab88:b029:d1:9be2:c683 with SMTP id
 f8-20020a170902ab88b02900d19be2c683mr15031435plr.24.1600104391252; Mon, 14
 Sep 2020 10:26:31 -0700 (PDT)
Date:   Mon, 14 Sep 2020 10:24:53 -0700
In-Reply-To: <20200914172453.1833883-1-weiwan@google.com>
Message-Id: <20200914172453.1833883-7-weiwan@google.com>
Mime-Version: 1.0
References: <20200914172453.1833883-1-weiwan@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [RFC PATCH net-next 6/6] net: improve napi threaded config
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit mainly addresses the threaded config to make the switch
between softirq based and kthread based NAPI processing not require
a device down/up.
It also moves the kthread_create() call to the sysfs handler when user
tries to enable "threaded" on napi, and properly handles the
kthread_create() failure. This is because certain drivers do not have
the napi created and linked to the dev when dev_open() is called. So
the previous implementation does not work properly there.

Signed-off-by: Wei Wang <weiwan@google.com>
---
 net/core/dev.c       | 49 +++++++++++++++++++++++++-------------------
 net/core/net-sysfs.c |  9 +++-----
 2 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index ab8af727058b..9f7df61f7c9a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1489,17 +1489,24 @@ EXPORT_SYMBOL(netdev_notify_peers);
 
 static int napi_threaded_poll(void *data);
 
-static void napi_thread_start(struct napi_struct *n)
+static int napi_kthread_create(struct napi_struct *n)
 {
-	if (test_bit(NAPI_STATE_THREADED, &n->state) && !n->thread)
-		n->thread = kthread_create(napi_threaded_poll, n, "%s-%d",
-					   n->dev->name, n->napi_id);
+	int err = 0;
+
+	n->thread = kthread_create(napi_threaded_poll, n, "%s-%d",
+				   n->dev->name, n->napi_id);
+	if (IS_ERR(n->thread)) {
+		err = PTR_ERR(n->thread);
+		pr_err("kthread_create failed with err %d\n", err);
+		n->thread = NULL;
+	}
+
+	return err;
 }
 
 static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
-	struct napi_struct *n;
 	int ret;
 
 	ASSERT_RTNL();
@@ -1531,9 +1538,6 @@ static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 	if (!ret && ops->ndo_open)
 		ret = ops->ndo_open(dev);
 
-	list_for_each_entry(n, &dev->napi_list, dev_list)
-		napi_thread_start(n);
-
 	netpoll_poll_enable(dev);
 
 	if (ret)
@@ -1584,6 +1588,7 @@ static void napi_thread_stop(struct napi_struct *n)
 	if (!n->thread)
 		return;
 	kthread_stop(n->thread);
+	clear_bit(NAPI_STATE_THREADED, &n->state);
 	n->thread = NULL;
 }
 
@@ -4266,7 +4271,7 @@ int gro_normal_batch __read_mostly = 8;
 static inline void ____napi_schedule(struct softnet_data *sd,
 				     struct napi_struct *napi)
 {
-	if (napi->thread) {
+	if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
 		wake_up_process(napi->thread);
 		return;
 	}
@@ -6623,25 +6628,25 @@ static void init_gro_hash(struct napi_struct *napi)
 
 int napi_set_threaded(struct napi_struct *n, bool threaded)
 {
-	ASSERT_RTNL();
+	int err = 0;
 
-	if (n->dev->flags & IFF_UP)
-		return -EBUSY;
+	ASSERT_RTNL();
 
 	if (threaded == !!test_bit(NAPI_STATE_THREADED, &n->state))
 		return 0;
-	if (threaded)
+	if (threaded) {
+		if (!n->thread) {
+			err = napi_kthread_create(n);
+			if (err)
+				goto out;
+		}
 		set_bit(NAPI_STATE_THREADED, &n->state);
-	else
+	} else {
 		clear_bit(NAPI_STATE_THREADED, &n->state);
+	}
 
-	/* if the device is initializing, nothing todo */
-	if (test_bit(__LINK_STATE_START, &n->dev->state))
-		return 0;
-
-	napi_thread_stop(n);
-	napi_thread_start(n);
-	return 0;
+out:
+	return err;
 }
 EXPORT_SYMBOL(napi_set_threaded);
 
@@ -6686,6 +6691,7 @@ void napi_disable(struct napi_struct *n)
 		msleep(1);
 
 	hrtimer_cancel(&n->timer);
+	napi_thread_stop(n);
 
 	clear_bit(NAPI_STATE_DISABLE, &n->state);
 }
@@ -6806,6 +6812,7 @@ static int napi_thread_wait(struct napi_struct *napi)
 
 	while (!kthread_should_stop() && !napi_disable_pending(napi)) {
 		if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
+			WARN_ON(!list_empty(&napi->poll_list));
 			__set_current_state(TASK_RUNNING);
 			return 0;
 		}
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 0172457a1bfe..48b7582a0372 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -608,11 +608,6 @@ static ssize_t threaded_store(struct device *dev,
 		goto unlock;
 	}
 
-	if (netdev->flags & IFF_UP) {
-		ret = -EBUSY;
-		goto unlock;
-	}
-
 	bmap = __alloc_thread_bitmap(netdev, &bits);
 	if (!bmap) {
 		ret = -ENOMEM;
@@ -625,7 +620,9 @@ static ssize_t threaded_store(struct device *dev,
 
 	i = 0;
 	list_for_each_entry(n, &netdev->napi_list, dev_list) {
-		napi_set_threaded(n, test_bit(i, bmap));
+		ret = napi_set_threaded(n, test_bit(i, bmap));
+		if (ret)
+			goto free_unlock;
 		i++;
 	}
 	ret = len;
-- 
2.28.0.618.gf4bc123cb7-goog

