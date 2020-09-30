Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43F3927F287
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbgI3TWk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:22:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgI3TWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 15:22:39 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD6BC061755
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 12:22:39 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id c3so1497293pgj.5
        for <netdev@vger.kernel.org>; Wed, 30 Sep 2020 12:22:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=n4uTXHq/VXo3p/L7IiyvP0BEIy/QSB4yopeNBchJpbc=;
        b=i7lsK89OH5r95QLDz5rYzro50jPEcdrdYbXQvOV6qGAIEIUJ5h5ZBS19FEG3Nc34Fi
         a584nr63at+T5B1MkX3bsPrhT4EsRsTLfOwBYkN0XpV6x1F/67GRw9jvEs+NhEB7IEDC
         JzjVLg0P8pqZ4ieiz0tC8sUlNK8rQb0ZtKV3xRa7R/JK4Lh1f/CygQik1I33DlnFaNg/
         OMGQy0Sg1of+MhtC77xyrZWploPpAUGXdlYtLnlGSjn3O+PhW3YfWLYFXmzRVWl/iKQ/
         6bRk9sjr4SDzZQ3m5xT2H/8yM8AwHINKt0Kxhp+HuzrGaRgZudHuP4j9E+zYWJV61HUj
         H6lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=n4uTXHq/VXo3p/L7IiyvP0BEIy/QSB4yopeNBchJpbc=;
        b=Ml8sKSrQxsD56XZXNu+k3M83+Nf79EPDrgx8B3VF3OFgStXZsr0hcBWwvI2VH8d+av
         qcRXGXIz98EA0TJYkm2NOcxb7hJ2fCyAymYd/R/xz2GzRZtB5LTxGAKpQAVcWAOnRTeQ
         uwWtAdn6Tvu3DUC+5fRyr0ECJOcSJoEvNdXx0tT2jYlkM4erdkHgGwfDjJrJJVdPPpOl
         MKcRudQzh4eIrlVN+OgeTK2gbzo0q2cYqwlULUgzFrKHdqF2drVs0IJuwyf5XFcq695w
         iye6I/HujuWYnT7+6XcoNq5qHrBOHqJy48C9SvDqKNacFazKJp5+F0KEt3OC5DnCtUlj
         6pwg==
X-Gm-Message-State: AOAM531lCid9VnPhUUhdt235KoLyDI2MLzPkVRLnWe15LjM/rGV4Ho6o
        vLofs17tpMOLpzoIm0gEa9+SfWRycDQ=
X-Google-Smtp-Source: ABdhPJw8wC8pvvboZWM66xoE8mrarejzvWPhRhJL5X3clX7INctokupYTBPu7AxCv5Fa1/DrA+gtCYmbA+w=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:a17:902:ba8c:b029:d2:ab25:5425 with SMTP id
 k12-20020a170902ba8cb02900d2ab255425mr4174932pls.0.1601493759117; Wed, 30 Sep
 2020 12:22:39 -0700 (PDT)
Date:   Wed, 30 Sep 2020 12:21:40 -0700
In-Reply-To: <20200930192140.4192859-1-weiwan@google.com>
Message-Id: <20200930192140.4192859-6-weiwan@google.com>
Mime-Version: 1.0
References: <20200930192140.4192859-1-weiwan@google.com>
X-Mailer: git-send-email 2.28.0.709.gb0816b6eb0-goog
Subject: [PATCH net-next 5/5] net: improve napi threaded config
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        Wei Wang <weiwan@google.com>
Content-Type: text/plain; charset="UTF-8"
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
Changes since RFC:
changed the thread name to napi/<dev>-<napi-id>

 net/core/dev.c       | 49 +++++++++++++++++++++++++-------------------
 net/core/net-sysfs.c |  9 +++-----
 2 files changed, 31 insertions(+), 27 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b4f33e442b5e..bf878d3a9d89 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1490,17 +1490,24 @@ EXPORT_SYMBOL(netdev_notify_peers);
 
 static int napi_threaded_poll(void *data);
 
-static void napi_thread_start(struct napi_struct *n)
+static int napi_kthread_create(struct napi_struct *n)
 {
-	if (test_bit(NAPI_STATE_THREADED, &n->state) && !n->thread)
-		n->thread = kthread_create(napi_threaded_poll, n, "%s-%d",
-					   n->dev->name, n->napi_id);
+	int err = 0;
+
+	n->thread = kthread_create(napi_threaded_poll, n, "napi/%s-%d",
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
@@ -1532,9 +1539,6 @@ static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 	if (!ret && ops->ndo_open)
 		ret = ops->ndo_open(dev);
 
-	list_for_each_entry(n, &dev->napi_list, dev_list)
-		napi_thread_start(n);
-
 	netpoll_poll_enable(dev);
 
 	if (ret)
@@ -1585,6 +1589,7 @@ static void napi_thread_stop(struct napi_struct *n)
 	if (!n->thread)
 		return;
 	kthread_stop(n->thread);
+	clear_bit(NAPI_STATE_THREADED, &n->state);
 	n->thread = NULL;
 }
 
@@ -4267,7 +4272,7 @@ int gro_normal_batch __read_mostly = 8;
 static inline void ____napi_schedule(struct softnet_data *sd,
 				     struct napi_struct *napi)
 {
-	if (napi->thread) {
+	if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
 		wake_up_process(napi->thread);
 		return;
 	}
@@ -6687,25 +6692,25 @@ static void init_gro_hash(struct napi_struct *napi)
 
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
 
@@ -6750,6 +6755,7 @@ void napi_disable(struct napi_struct *n)
 		msleep(1);
 
 	hrtimer_cancel(&n->timer);
+	napi_thread_stop(n);
 
 	clear_bit(NAPI_STATE_DISABLE, &n->state);
 }
@@ -6870,6 +6876,7 @@ static int napi_thread_wait(struct napi_struct *napi)
 
 	while (!kthread_should_stop() && !napi_disable_pending(napi)) {
 		if (test_bit(NAPI_STATE_SCHED, &napi->state)) {
+			WARN_ON(!list_empty(&napi->poll_list));
 			__set_current_state(TASK_RUNNING);
 			return 0;
 		}
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index fe81b344447d..b54dbccf00be 100644
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
2.28.0.709.gb0816b6eb0-goog

