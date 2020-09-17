Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8661826D365
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 08:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgIQGFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 02:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbgIQGFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 02:05:39 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABF9C06174A;
        Wed, 16 Sep 2020 23:05:39 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z18so556340pfg.0;
        Wed, 16 Sep 2020 23:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pbPHu2PuH4qcHADJrXkNowzKC39J0pwMZtsiGih/dV4=;
        b=TOwQXSDXw5HygVk495IeVn+i2S8342sbCNL+0eyJPD7bXkQF9WNJUeWCX+UZWJ992k
         GBgeYN0+YizUPScQE+M384a9pMMLdgXz+uxslfARL/gCZ7bVfPZXo9Wbjhu7XltaYlpH
         6m/4AL4UkQOw90csermz2RsBIl8QyGYfUwf0O8NRpLnGONLFIta8/bY5bDY7xQbEo5QB
         1P7LSbnJBhyPxj0adxRnfGp9psuqXHSfFQLtvgjYaDI6US0rte9cm5xh+0Qa6JQ0I5e7
         MXa7Kv7v7me5dwprzf1PYpTEVUTWNSaOk7liAWpayRdWiSzbdor1GenFjtFxEXMb9smY
         M4ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pbPHu2PuH4qcHADJrXkNowzKC39J0pwMZtsiGih/dV4=;
        b=E4YnoQX/g+A4TB3y9XksTtzXbQhwTwGufLpUweD7hAKmovZhdYPcLerYRhjKpoEYhq
         H7aWVABKaWN2MA1TBmbtnaaKKna0JOrvTWdRM+YVAgoKs+bZAV3WxyRNKgi6fVs1emtQ
         6FdzfYPj4XU4KmIcUQ0vbwnQ/zq/ubJUiyzIWA37QNy+Q2UGw9Huus3sWmv1RvcTu9dP
         vNsbpv8YBuEnX8DKpUR58z0ANsoiOy8g3UPTioZXJuEDEXA0TPS9QvYWyy6JH7Hfsp3r
         Uysocd0r/oNt5MnI/b4wxEiTQcppbrcUpZlDhpdCJW8WFtn1GarHDeepY8zXBjmvaJCR
         UQ0g==
X-Gm-Message-State: AOAM530mn1f/Q/D664SckNRsS5PQ3qk9Tu2cNlmb32rxoIwlg8XrM/hy
        Tb/rKxqbNHZUGcL6Gyz7RvLRYxqzrhbicw==
X-Google-Smtp-Source: ABdhPJyTSzRIHL37V9LwkQ+z+94onYUaCMywPIGgjkoTfvAjwyVN3s2v/XSsCR7PoVZXhZS9ehAuww==
X-Received: by 2002:a62:7747:0:b029:13f:d779:5f95 with SMTP id s68-20020a6277470000b029013fd7795f95mr19039059pfc.2.1600322738752;
        Wed, 16 Sep 2020 23:05:38 -0700 (PDT)
Received: from localhost.localdomain ([115.192.213.183])
        by smtp.gmail.com with ESMTPSA id m12sm4587060pjs.34.2020.09.16.23.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2020 23:05:38 -0700 (PDT)
From:   Xiaoyong Yan <yanxiaoyong5@gmail.com>
To:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiaoyong Yan <yanxiaoyong5@gmail.com>
Subject: [PATCH] [PATCH] net/sched : cbs : fix calculation error of idleslope credits
Date:   Wed, 16 Sep 2020 23:05:33 -0700
Message-Id: <20200917060533.73217-1-yanxiaoyong5@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

in the function cbs_dequeue_soft, when q->credits <0, [now - q->last]
should be accounted for sendslope,not idleslope.

so the solution as follows: when q->credits is less than 0, directly
calculate delay time, activate hrtimer and when hrtimer fires,
calculate idleslope credits and update it to q->credits.

because of the lack of self-defined qdisc_watchdog_func, so in the
generic sch_api, add qdisc_watchdog_init_func and
qdisc_watchdog_init_clockid_func, so sch_cbs can use it to define its
own process.

the patch is changed based on v5.4.42,and the test result as follows:
the NIC is 100Mb/s ,full duplex.

step1:
tc qdisc add dev ens33 root cbs idleslope 75 sendslope -25 hicredit 1000000 locredit -1000000 offload 0
step2:
root@ubuntu:/home/yxy/kernel/linux-stable# iperf -c 192.168.1.114 -i 1
------------------------------------------------------------
Client connecting to 192.168.1.114, TCP port 5001
TCP window size:  246 KByte (default)
------------------------------------------------------------
[  3] local 192.168.1.120 port 42004 connected with 192.168.1.114 port 5001
[ ID] Interval       Transfer     Bandwidth
[  3]  0.0- 1.0 sec  9.00 MBytes  75.5 Mbits/sec
[  3]  1.0- 2.0 sec  8.50 MBytes  71.3 Mbits/sec
[  3]  2.0- 3.0 sec  8.50 MBytes  71.3 Mbits/sec
[  3]  3.0- 4.0 sec  8.38 MBytes  70.3 Mbits/sec
[  3]  4.0- 5.0 sec  8.38 MBytes  70.3 Mbits/sec
[  3]  5.0- 6.0 sec  8.50 MBytes  71.3 Mbits/sec
[  3]  6.0- 7.0 sec  8.50 MBytes  71.3 Mbits/sec
[  3]  7.0- 8.0 sec  8.62 MBytes  72.4 Mbits/sec
[  3]  8.0- 9.0 sec  8.50 MBytes  71.3 Mbits/sec
[  3]  9.0-10.0 sec  8.62 MBytes  72.4 Mbits/sec
[  3]  0.0-10.0 sec  85.5 MBytes  71.5 Mbits/sec

Signed-off-by: Xiaoyong Yan <yanxiaoyong5@gmail.com>
---
 include/net/pkt_sched.h |  7 +++++++
 net/sched/sch_api.c     | 20 ++++++++++++++++++--
 net/sched/sch_cbs.c     | 41 +++++++++++++++++++++++++----------------
 3 files changed, 50 insertions(+), 18 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 6a70845bd9ab..5fec23b15e1c 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -9,6 +9,7 @@
 #include <net/sch_generic.h>
 #include <net/net_namespace.h>
 #include <uapi/linux/pkt_sched.h>
+#include <linux/hrtimer.h>

#define DEFAULT_TX_QUEUE_LEN	1000

@@ -72,6 +73,12 @@ struct qdisc_watchdog {
 	struct Qdisc	*qdisc;
 };

+typedef enum hrtimer_restart (*qdisc_watchdog_func_t)(struct hrtimer *timer);
+void qdisc_watchdog_init_clockid_func(struct qdisc_watchdog *wd, struct Qdisc *qdisc,
+		 clockid_t clockid,qdisc_watchdog_func_t func);
+void qdisc_watchdog_init_func(struct qdisc_watchdog *wd,struct Qdisc *qdisc,qdisc_watchdog_func_t func);
+enum hrtimer_restart qdisc_watchdog(struct hrtimer *timer);
+
 void qdisc_watchdog_init_clockid(struct qdisc_watchdog *wd, struct Qdisc *qdisc,
 				 clockid_t clockid);
 void qdisc_watchdog_init(struct qdisc_watchdog *wd, struct Qdisc *qdisc);
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 50794125bf02..fea08d10c811 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -22,7 +22,6 @@
 #include <linux/seq_file.h>
 #include <linux/kmod.h>
 #include <linux/list.h>
-#include <linux/hrtimer.h>
 #include <linux/slab.h>
 #include <linux/hashtable.h>

@@ -591,7 +590,7 @@ void qdisc_warn_nonwc(const char *txt, struct Qdisc *qdisc)
 }
 EXPORT_SYMBOL(qdisc_warn_nonwc);

-static enum hrtimer_restart qdisc_watchdog(struct hrtimer *timer)
+enum hrtimer_restart qdisc_watchdog(struct hrtimer *timer)
 {
 	struct qdisc_watchdog *wd = container_of(timer, struct qdisc_watchdog,
 						 timer);
@@ -602,7 +601,24 @@ static enum hrtimer_restart qdisc_watchdog(struct hrtimer *timer)

 	return HRTIMER_NORESTART;
 }
+EXPORT_SYMBOL(qdisc_watchdog);

+void qdisc_watchdog_init_clockid_func(struct qdisc_watchdog *wd,struct Qdisc *qdisc,clockid_t clockid,qdisc_watchdog_func_t func)
+{
+	hrtimer_init(&wd->timer,clockid,HRTIMER_MODE_ABS_PINNED);
+	if(!func)
+		wd->timer.function = qdisc_watchdog;
+	else
+		wd->timer.function = func;
+	wd->qdisc = qdisc;
+}
+EXPORT_SYMBOL(qdisc_watchdog_init_clockid_func);
+
+void qdisc_watchdog_init_func(struct qdisc_watchdog *wd,struct Qdisc *qdisc,qdisc_watchdog_func_t func)
+{
+	qdisc_watchdog_init_clockid_func(wd,qdisc,CLOCK_MONOTONIC,func);
+}
+EXPORT_SYMBOL(qdisc_watchdog_init_func);
 void qdisc_watchdog_init_clockid(struct qdisc_watchdog *wd, struct Qdisc *qdisc,
 				 clockid_t clockid)
 {
diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index 2eaac2ff380f..351d3927e107 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -187,21 +187,15 @@ static struct sk_buff *cbs_dequeue_soft(struct Qdisc *sch)
 		return NULL;
 	}
 	if (q->credits < 0) {
-		credits = timediff_to_credits(now - q->last, q->idleslope);
+		s64 delay;
+
+		delay = delay_from_credits(q->credits, q->idleslope);
+		qdisc_watchdog_schedule_ns(&q->watchdog, now + delay);

-		credits = q->credits + credits;
-		q->credits = min_t(s64, credits, q->hicredit);
-
-		if (q->credits < 0) {
-			s64 delay;
-
-			delay = delay_from_credits(q->credits, q->idleslope);
-			qdisc_watchdog_schedule_ns(&q->watchdog, now + delay);
-
-			q->last = now;
+		q->last = now;

-			return NULL;
-		}
+		return NULL;
+
 	}
 	skb = cbs_child_dequeue(sch, qdisc);
 	if (!skb)
@@ -212,11 +206,12 @@ static struct sk_buff *cbs_dequeue_soft(struct Qdisc *sch)
 	/* As sendslope is a negative number, this will decrease the
 	 * amount of q->credits.
 	 */
+
 	credits = credits_from_len(len, q->sendslope,
 				   atomic64_read(&q->port_rate));
 	credits += q->credits;

-	q->credits = max_t(s64, credits, q->locredit);
+	q->credits = clamp_t(s64, credits, q->locredit,q->hicredit);
 	/* Estimate of the transmission of the last byte of the packet in ns */
 	if (unlikely(atomic64_read(&q->port_rate) == 0))
 		q->last = now;
@@ -323,7 +318,7 @@ static void cbs_set_port_rate(struct net_device *dev, struct cbs_sched_data *q)
 	port_rate = speed * 1000 * BYTES_PER_KBIT;

 	atomic64_set(&q->port_rate, port_rate);
-	netdev_dbg(dev, "cbs: set %s's port_rate to: %lld, linkspeed: %d\n",
+	netdev_dbg(dev,"cbs: set %s's port_rate to: %lld, linkspeed: %d\n",
 		   dev->name, (long long)atomic64_read(&q->port_rate),
 		   ecmd.base.speed);
 }
@@ -396,7 +391,21 @@ static int cbs_change(struct Qdisc *sch, struct nlattr *opt,

 	return 0;
 }
+static enum hrtimer_restart cbs_qdisc_watchdog(struct hrtimer *timer)
+{
+	struct qdisc_watchdog *wd = container_of(timer,struct qdisc_watchdog,timer);
+	struct Qdisc *sch = wd->qdisc;
+	struct cbs_sched_data *q = qdisc_priv(sch);
+	s64 now = ktime_get_ns();
+	s64 credits;
+
+	credits  = timediff_to_credits(now-q->last,q->idleslope);
+	credits = q->credits+credits;
+	q->credits = clamp_t(s64,credits,q->locredit,q->hicredit);
+	q->last = now;

+	return qdisc_watchdog(timer);
+}
 static int cbs_init(struct Qdisc *sch, struct nlattr *opt,
 		    struct netlink_ext_ack *extack)
 {
@@ -424,7 +433,7 @@ static int cbs_init(struct Qdisc *sch, struct nlattr *opt,
 	q->enqueue = cbs_enqueue_soft;
 	q->dequeue = cbs_dequeue_soft;

-	qdisc_watchdog_init(&q->watchdog, sch);
+	qdisc_watchdog_init_func(&q->watchdog, sch,cbs_qdisc_watchdog);

 	return cbs_change(sch, opt, extack);
 }
--
2.25.1

