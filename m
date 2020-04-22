Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A029C1B49F5
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 18:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgDVQNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 12:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbgDVQNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 12:13:41 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E786C03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 09:13:41 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id u137so2474296pfc.1
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 09:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jhLMwp8j2QUu9Vc+R58C4mu34Hprg+54YPbp/VZSXto=;
        b=BCGyhKFUNK3CmKeJa438SkP46ET4JI+Z1S6eZIYnt5yebVQizx3MPSABIVpK2H62HM
         YlEU9SfVAxChsZNWZBMWK4Ps6KHdPQl1B12pg42nqmF4CipBPWp8SFgEJ4zeg2UQJMII
         VH2YRzNURHXDfrbnTFGVELCfk/vd2Ety25TVuHccmpHvby1QGYIJDnYmt6gRTTr97xZu
         7FA7um3DfKYYs2fr5EEL65Et7eq1Hu9DJ9im1G2sgrWoShqy/zCNss465vli+zwvSBmd
         b3w54QOdNfwGbNyItLu73yILTKW5G020HHtGhiItwfg+dDJA7vflFrIY2SvHomkctkWp
         kneg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jhLMwp8j2QUu9Vc+R58C4mu34Hprg+54YPbp/VZSXto=;
        b=iNsYFXt0HELO/cd82I2K5JYV91EENSxaiJvwu4Lr3xDXOkgEl2JTfala1kcxX8mR29
         z1pzUApAv/lcyyGcg9ZFE/P+POo4elcaOLk3CWczBlnAVOhp2GVu+WU9n+Xwh9ZjZ2qE
         6LbqSU4/EavqXHPiugFywwHMujlOh81xye6UuVNsO+KGiSaRQAFH/FrP44bCSZeLn9ef
         rbvL4xNmW01azCyVcnmVXNa2dNDQJOqrCcJszWBbnOiiuWkpuPQWlsS3Xbx7b0BzdhPh
         UKgTvPGNVlDaTTRyNynkLYmtAeyjR3xA3ERk+4Xi0VmSNsJbrFDW/wbr4cWqNsXv18j/
         o51w==
X-Gm-Message-State: AGi0PuZddDCMgaz/9RGctOiTxuN+nOVWVv83jE/1lopUGrdfbZIzG+Wv
        w0TaZY7YwcYkiKBklwEFiLSKR5CjlWc2jA==
X-Google-Smtp-Source: APiQypLfDizoBlPykOdRHdX43jUhTgPT/2de9a5Yh+EG56BIe3ZSez/HlbjWPpIl6Hw0w8iULU0q/xV+T8unQw==
X-Received: by 2002:a17:90a:8d02:: with SMTP id c2mr12614550pjo.113.1587572021127;
 Wed, 22 Apr 2020 09:13:41 -0700 (PDT)
Date:   Wed, 22 Apr 2020 09:13:27 -0700
In-Reply-To: <20200422161329.56026-1-edumazet@google.com>
Message-Id: <20200422161329.56026-2-edumazet@google.com>
Mime-Version: 1.0
References: <20200422161329.56026-1-edumazet@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH net-next 1/3] net: napi: add hard irqs deferral feature
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Luigi Rizzo <lrizzo@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Back in commit 3b47d30396ba ("net: gro: add a per device gro flush timer")
we added the ability to arm one high resolution timer, that we used
to keep not-complete packets in GRO engine a bit longer, hoping that further
frames might be added to them.

Since then, we added the napi_complete_done() interface, and commit
364b6055738b ("net: busy-poll: return busypolling status to drivers")
allowed drivers to avoid re-arming NIC interrupts if we made a promise
that their NAPI poll() handler would be called in the near future.

This infrastructure can be leveraged, thanks to a new device parameter,
which allows to arm the napi hrtimer, instead of re-arming the device
hard IRQ.

We have noticed that on some servers with 32 RX queues or more, the chit-chat
between the NIC and the host caused by IRQ delivery and re-arming could hurt
throughput by ~20% on 100Gbit NIC.

In contrast, hrtimers are using local (percpu) resources and might have lower
cost.

The new tunable, named napi_defer_hard_irqs, is placed in the same hierarchy
than gro_flush_timeout (/sys/class/net/ethX/)

By default, both gro_flush_timeout and napi_defer_hard_irqs are zero.

This patch does not change the prior behavior of gro_flush_timeout
if used alone : NIC hard irqs should be rearmed as before.

One concrete usage can be :

echo 20000 >/sys/class/net/eth1/gro_flush_timeout
echo 10 >/sys/class/net/eth1/napi_defer_hard_irqs

If at least one packet is retired, then we will reset napi counter
to 10 (napi_defer_hard_irqs), ensuring at least 10 periodic scans
of the queue.

On busy queues, this should avoid NIC hard IRQ, while before this patch IRQ
avoidance was only possible if napi->poll() was exhausting its budget
and not call napi_complete_done().

This feature also can be used to work around some non-optimal NIC irq
coalescing strategies.

Having the ability to insert XX usec delays between each napi->poll()
can increase cache efficiency, since we increase batch sizes.

It also keeps serving cpus not idle too long, reducing tail latencies.

Co-developed-by: Luigi Rizzo <lrizzo@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 29 ++++++++++++++++++-----------
 net/core/net-sysfs.c      | 18 ++++++++++++++++++
 3 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 0750b54b37651890eb297e9f97fc956fb5cc48c7..5a8d40f1ffe2afce7ca36c290786d87eb730b8fc 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -329,6 +329,7 @@ struct napi_struct {
 
 	unsigned long		state;
 	int			weight;
+	int			defer_hard_irqs_count;
 	unsigned long		gro_bitmask;
 	int			(*poll)(struct napi_struct *, int);
 #ifdef CONFIG_NETPOLL
@@ -1995,6 +1996,7 @@ struct net_device {
 
 	struct bpf_prog __rcu	*xdp_prog;
 	unsigned long		gro_flush_timeout;
+	int			napi_defer_hard_irqs;
 	rx_handler_func_t __rcu	*rx_handler;
 	void __rcu		*rx_handler_data;
 
diff --git a/net/core/dev.c b/net/core/dev.c
index fb61522b1ce163963f8d0bf54c7c5fa58fce7b9a..67585484ad32b698c6bc4bf17f5d87c345d77502 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6227,7 +6227,8 @@ EXPORT_SYMBOL(__napi_schedule_irqoff);
 
 bool napi_complete_done(struct napi_struct *n, int work_done)
 {
-	unsigned long flags, val, new;
+	unsigned long flags, val, new, timeout = 0;
+	bool ret = true;
 
 	/*
 	 * 1) Don't let napi dequeue from the cpu poll list
@@ -6239,20 +6240,23 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 				 NAPIF_STATE_IN_BUSY_POLL)))
 		return false;
 
-	if (n->gro_bitmask) {
-		unsigned long timeout = 0;
-
-		if (work_done)
+	if (work_done) {
+		if (n->gro_bitmask)
 			timeout = n->dev->gro_flush_timeout;
-
+		n->defer_hard_irqs_count = n->dev->napi_defer_hard_irqs;
+	}
+	if (n->defer_hard_irqs_count > 0) {
+		n->defer_hard_irqs_count--;
+		timeout = n->dev->gro_flush_timeout;
+		if (timeout)
+			ret = false;
+	}
+	if (n->gro_bitmask) {
 		/* When the NAPI instance uses a timeout and keeps postponing
 		 * it, we need to bound somehow the time packets are kept in
 		 * the GRO layer
 		 */
 		napi_gro_flush(n, !!timeout);
-		if (timeout)
-			hrtimer_start(&n->timer, ns_to_ktime(timeout),
-				      HRTIMER_MODE_REL_PINNED);
 	}
 
 	gro_normal_list(n);
@@ -6284,7 +6288,10 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 		return false;
 	}
 
-	return true;
+	if (timeout)
+		hrtimer_start(&n->timer, ns_to_ktime(timeout),
+			      HRTIMER_MODE_REL_PINNED);
+	return ret;
 }
 EXPORT_SYMBOL(napi_complete_done);
 
@@ -6464,7 +6471,7 @@ static enum hrtimer_restart napi_watchdog(struct hrtimer *timer)
 	/* Note : we use a relaxed variant of napi_schedule_prep() not setting
 	 * NAPI_STATE_MISSED, since we do not react to a device IRQ.
 	 */
-	if (napi->gro_bitmask && !napi_disable_pending(napi) &&
+	if (!napi_disable_pending(napi) &&
 	    !test_and_set_bit(NAPI_STATE_SCHED, &napi->state))
 		__napi_schedule_irqoff(napi);
 
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 0d9e46de205e9e5338b56ecd9441338929e07bc1..f3b650cd09231fd99604f6f66bab454eabaa06be 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -382,6 +382,23 @@ static ssize_t gro_flush_timeout_store(struct device *dev,
 }
 NETDEVICE_SHOW_RW(gro_flush_timeout, fmt_ulong);
 
+static int change_napi_defer_hard_irqs(struct net_device *dev, unsigned long val)
+{
+	dev->napi_defer_hard_irqs = val;
+	return 0;
+}
+
+static ssize_t napi_defer_hard_irqs_store(struct device *dev,
+					  struct device_attribute *attr,
+					  const char *buf, size_t len)
+{
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	return netdev_store(dev, attr, buf, len, change_napi_defer_hard_irqs);
+}
+NETDEVICE_SHOW_RW(napi_defer_hard_irqs, fmt_dec);
+
 static ssize_t ifalias_store(struct device *dev, struct device_attribute *attr,
 			     const char *buf, size_t len)
 {
@@ -545,6 +562,7 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_flags.attr,
 	&dev_attr_tx_queue_len.attr,
 	&dev_attr_gro_flush_timeout.attr,
+	&dev_attr_napi_defer_hard_irqs.attr,
 	&dev_attr_phys_port_id.attr,
 	&dev_attr_phys_port_name.attr,
 	&dev_attr_phys_switch_id.attr,
-- 
2.26.1.301.g55bc3eb7cb9-goog

