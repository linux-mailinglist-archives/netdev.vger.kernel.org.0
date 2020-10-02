Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 548A5281E48
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725841AbgJBWZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725766AbgJBWZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:25:45 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7627C0613E2
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 15:25:43 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id 125so2147586qkh.4
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 15:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=VoT3IBpFIUfj3LGz+u23OWtCKeHsMR5qZdla+sIEeXA=;
        b=ioQ9MZRbEK6VRYUJwz+R2Qke5oQ6403brWCQiXGKzHCV2GVifB4b1t/En/Sn15a8JY
         bKCkmPM1XJUOy/DtmsVpnX9jut+XvEaLrVhM8+gOq14rfPyTQw2fU2HlZbuWhkErc56d
         v/yEEhSe/V4j7o0P1lY9Bw9Wt8GBDFWKlX2b8WCpuANlSmFFC7WNqCa31Kt+cdKRSRQj
         /s45NvxgU6gqxewlEDyNbODGcX+4fpK4gBFI7nt+tIv8ILmQBH7Gff9rSz8c6ofTEkgc
         FPHxEF6wX7XqhjTkhZBK9bA4/Xs6PqrT8zge0Y64CHfRtugWVw9KBjK2tNh2ZsNG4bjV
         Uw6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VoT3IBpFIUfj3LGz+u23OWtCKeHsMR5qZdla+sIEeXA=;
        b=Qx1cpfrHs+pWPABBzjKc5rgHx/4S4zaD7uLBggy/OAPt+1CWVtYUneXNlSU/T6opuv
         IDxx3wjznFIG5VI8YTqbSMU77vuN3udro5HvijXW70cDsHql9jas+c+PA8mrMcGjbseV
         ylq83JcpzZGEqVFzLGD46O0yOT3YwU/N36wb+VYPec1cr+k9KQiVE3SinUf+UDZ9erfk
         J0FpKp9d1DJ+VhPhnHSXQiGQoNTidYubHxl0qfiFy/34vMC7pa6OKo3b7MglBHpMwZWF
         VQYyljJ+XkqtskwtgErJcIjnLHTnocgd264S5fMdFYXuQUG3MzjFFfFm4RhEayCQWzWc
         qu/w==
X-Gm-Message-State: AOAM532tUTa0RRpXYeKX7uO1bmVumUkh9/RNe1VY/MFYPpzYW/UcU1Pa
        mT6ZEJjQ+JpNM/gao9DpWCsK9X0ZLH8=
X-Google-Smtp-Source: ABdhPJxgeXinEVt/mA+qo4mI1RA4URIBvqQRnP06iK6me7KzHgpCO+vFGxdxSJDmPmM204OtDrtEX6jxlVc=
Sender: "weiwan via sendgmr" <weiwan@weiwan.svl.corp.google.com>
X-Received: from weiwan.svl.corp.google.com ([2620:15c:2c4:201:1ea0:b8ff:fe75:cf08])
 (user=weiwan job=sendgmr) by 2002:ad4:58c7:: with SMTP id dh7mr4399684qvb.20.1601677543100;
 Fri, 02 Oct 2020 15:25:43 -0700 (PDT)
Date:   Fri,  2 Oct 2020 15:25:14 -0700
In-Reply-To: <20201002222514.1159492-1-weiwan@google.com>
Message-Id: <20201002222514.1159492-6-weiwan@google.com>
Mime-Version: 1.0
References: <20201002222514.1159492-1-weiwan@google.com>
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH net-next v2 5/5] net: improve napi threaded config
From:   Wei Wang <weiwan@google.com>
To:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Felix Fietkau <nbd@nbd.name>, Wei Wang <weiwan@google.com>
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
Changes since v1:
replaced kthread_create() with kthread_run()

Changes since RFC:
changed the thread name to napi/<dev>-<napi-id>

 net/core/dev.c       | 53 ++++++++++++++++++++++++++------------------
 net/core/net-sysfs.c |  9 +++-----
 2 files changed, 35 insertions(+), 27 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index b4f33e442b5e..e89a7f869c73 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1490,17 +1490,28 @@ EXPORT_SYMBOL(netdev_notify_peers);
 
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
@@ -1532,9 +1543,6 @@ static int __dev_open(struct net_device *dev, struct netlink_ext_ack *extack)
 	if (!ret && ops->ndo_open)
 		ret = ops->ndo_open(dev);
 
-	list_for_each_entry(n, &dev->napi_list, dev_list)
-		napi_thread_start(n);
-
 	netpoll_poll_enable(dev);
 
 	if (ret)
@@ -1585,6 +1593,7 @@ static void napi_thread_stop(struct napi_struct *n)
 	if (!n->thread)
 		return;
 	kthread_stop(n->thread);
+	clear_bit(NAPI_STATE_THREADED, &n->state);
 	n->thread = NULL;
 }
 
@@ -4267,7 +4276,7 @@ int gro_normal_batch __read_mostly = 8;
 static inline void ____napi_schedule(struct softnet_data *sd,
 				     struct napi_struct *napi)
 {
-	if (napi->thread) {
+	if (test_bit(NAPI_STATE_THREADED, &napi->state)) {
 		wake_up_process(napi->thread);
 		return;
 	}
@@ -6687,25 +6696,25 @@ static void init_gro_hash(struct napi_struct *napi)
 
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
 
@@ -6750,6 +6759,7 @@ void napi_disable(struct napi_struct *n)
 		msleep(1);
 
 	hrtimer_cancel(&n->timer);
+	napi_thread_stop(n);
 
 	clear_bit(NAPI_STATE_DISABLE, &n->state);
 }
@@ -6870,6 +6880,7 @@ static int napi_thread_wait(struct napi_struct *napi)
 
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
2.28.0.806.g8561365e88-goog

