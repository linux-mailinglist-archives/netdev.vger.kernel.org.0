Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF112B8552
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 21:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgKRUHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 15:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgKRUH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 15:07:28 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAB0C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:07:28 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id i20so2343227qtr.0
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 12:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=xlHZPWU+bbDS9e6CXR8uTghGetIA9/oXojkEATLlN2Q=;
        b=OwsxSjN1pAb1/UqydZ1pl1jhQP4tYy32uUuSI/kiYsQknyd1m6PFQ0YkMZE4NgC0GE
         6DafeJE9SCkKLpoh3363IXue+lHI23zax7IcGKzgnIvdJsRQZvq2kCxspYOF9sAHlMBI
         zQi9a7ESb0JLp/WyJq1NiL+0ZSmYV3LJnQ/IL5DjFZvTfnETwwqHWTj22p4llIYm7Y0K
         3sxnGoDTK2bDJFesvE30Vt9ZqoNwlUo4gxI9G9gH7qmTUNJgaGaXaahCvN/d2lCbQckc
         32ADVNunsD1CLQG4v+vdW44M1MlMVrKcG8mM1Hr+rQy5F1o1vYc8BlSco5OL3GxqR210
         82Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xlHZPWU+bbDS9e6CXR8uTghGetIA9/oXojkEATLlN2Q=;
        b=MKLA53me4nvLHTl4nYd6vQv9soWDWOiHfoIs4+wIpqAzKQ8FBN4XYA7ZK4J4I2B1me
         njIAvY8nom2FBXWKzZ9MYiVwLtzDeSQBcgQaEBVcABr22SXBXiuccaiCqL2v3O8sx0sc
         JL27Of7mqybrcR9ZgxHA2ezb5jHmNQku7YhEpgq2cOX9Rn4PnagYSrjVPIkXactToJg1
         pxe3ryFEKUpaoBbaKPtBy8HBIUMUPdQ8pcgEj6Hd0lHZ0TJybn2fLi1cygytCaymeg2I
         PEhHXWiPyhF1yIZKrkN4BUVLpEdjEeo98zF3tgn56EM2ULM8x64QX9v71uwkash4+iDW
         yKWA==
X-Gm-Message-State: AOAM533kAsMVdL0NEQv1MciM1AsFr+YnT5MQTM2yLUiCK8+xcNmUlHdw
        rnjw/nN5OQMf7L9x1J4X5+tMXJ/LPdo=
X-Google-Smtp-Source: ABdhPJzfkty8I1w4D5hP3Z95e2Fz7aEiqf2db3Wvt/6TducWu7yd8ACV4j7Vo54og0areNe0qXvV7pRas74=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a0c:fb4a:: with SMTP id b10mr6753589qvq.1.1605730047898;
 Wed, 18 Nov 2020 12:07:27 -0800 (PST)
Date:   Wed, 18 Nov 2020 11:10:09 -0800
In-Reply-To: <20201118191009.3406652-1-weiwan@google.com>
Message-Id: <20201118191009.3406652-6-weiwan@google.com>
Mime-Version: 1.0
References: <20201118191009.3406652-1-weiwan@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH net-next v3 5/5] net: improve napi threaded config
From:   Wei Wang <weiwan@google.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>, Felix Fietkau <nbd@nbd.name>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Hillf Danton <hdanton@sina.com>, Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit mainly addresses the threaded config to make the switch
between softirq based and kthread based NAPI processing not require
a device down/up.
It also moves the kthread_run() call to the sysfs handler when user
tries to enable "threaded" on napi, and properly handles the
kthread_run() failure. This is because certain drivers do not have
the napi created and linked to the dev when dev_open() is called. So
the previous implementation does not work properly there.

Signed-off-by: Wei Wang <weiwan@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c       | 53 ++++++++++++++++++++++++++------------------
 net/core/net-sysfs.c |  9 +++-----
 2 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 88437cdf29f1..7788899b100f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1491,17 +1491,28 @@ EXPORT_SYMBOL(netdev_notify_peers);
 
 static int napi_threaded_poll(void *data);
 
-static void napi_thread_start(struct napi_struct *n)
+static int napi_kthread_create(struct napi_struct *n)
 {
-	if (test_bit(NAPI_STATE_THREADED, &n->state) && !n->thread)
-		n->thread = kthread_create(napi_threaded_poll, n, "%s-%d",
-					   n->dev->name, n->napi_id);
+	int err = 0;
+
+	/* Create and wake up the kthread once to put it in
+	 * TASK_INTERRUPTIBLE mode to avoid the blocked task
+	 * warning and work with loadavg.
+	 */
+	n->thread = kthread_run(napi_threaded_poll, n, "napi/%s-%d",
+				n->dev->name, n->napi_id);
+	if (IS_ERR(n->thread)) {
+		err = PTR_ERR(n->thread);
+		pr_err("kthread_run failed with err %d\n", err);
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
@@ -1533,9 +1544,6 @@ static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 	if (!ret && ops->ndo_open)
 		ret = ops->ndo_open(dev);
 
-	list_for_each_entry(n, &dev->napi_list, dev_list)
-		napi_thread_start(n);
-
 	netpoll_poll_enable(dev);
 
 	if (ret)
@@ -1586,6 +1594,7 @@ static void napi_thread_stop(struct napi_struct *n)
 	if (!n->thread)
 		return;
 	kthread_stop(n->thread);
+	clear_bit(NAPI_STATE_THREADED, &n->state);
 	n->thread = NULL;
 }
 
@@ -4271,7 +4280,7 @@ int gro_normal_batch __read_mostly = 8;
 static inline void ____napi_schedule(struct softnet_data *sd,
 				     struct napi_struct *napi)
 {
-	if (napi->thread) {
+	if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
 		wake_up_process(napi->thread);
 		return;
 	}
@@ -6700,25 +6709,25 @@ static void init_gro_hash(struct napi_struct *napi)
 
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
 
@@ -6763,6 +6772,7 @@ void napi_disable(struct napi_struct *n)
 		msleep(1);
 
 	hrtimer_cancel(&n->timer);
+	napi_thread_stop(n);
 
 	clear_bit(NAPI_STATE_DISABLE, &n->state);
 }
@@ -6883,6 +6893,7 @@ static int napi_thread_wait(struct napi_struct *napi)
 
 	while (!kthread_should_stop() && !napi_disable_pending(napi)) {
 		if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
+			WARN_ON(!list_empty(&napi->poll_list));
 			__set_current_state(TASK_RUNNING);
 			return 0;
 		}
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index df8dd25e5e4b..1e24c1e81ad8 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -609,11 +609,6 @@ static ssize_t threaded_store(struct device *dev,
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
@@ -626,7 +621,9 @@ static ssize_t threaded_store(struct device *dev,
 
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
2.29.2.454.gaff20da3a2-goog

