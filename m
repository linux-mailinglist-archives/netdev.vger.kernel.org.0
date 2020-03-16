Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3FF71875FF
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 00:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732900AbgCPXCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 19:02:32 -0400
Received: from mail-qv1-f73.google.com ([209.85.219.73]:51753 "EHLO
        mail-qv1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732854AbgCPXCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 19:02:31 -0400
Received: by mail-qv1-f73.google.com with SMTP id j5so3332871qvo.18
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 16:02:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hjXTbZ9IR5FA3dvQi37uICZa1G9fdsOo4rBuWdq92qw=;
        b=qwJUVXEPuC/av1Jr0sqiVz+dvVWR6yLtkOMKn+flTD7aB7CQG6yiJ/1PIJyoL0Ow2+
         eEFb461uilKdjKDq1ZOEMktszzk0+wCCwBBvCuPVkMWiM57mEKRLUrN/lAkaUPcBrxVP
         SPJNhhDbjNCLIQgIsB+W28X4mslpv5JVYeDxJ1ZqVw93q8EHVPBDASFyaf1kh+KkD7sh
         huO3BiC4If2cqTofHJlOtsRobJa0JKl481gpZykozFdCWA5uZtcbmNpmqmAJBaeoZPmg
         BzgCUV+ewuB6MmrvWWFxVjhYD6+tizsuO8nz0mMAuPDUhgyFqjCLUXMpgU7p5b9COT9q
         +lhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hjXTbZ9IR5FA3dvQi37uICZa1G9fdsOo4rBuWdq92qw=;
        b=qwr9rFvkhvVefA/e45Eoinc1+UVyXoL7NxUuR7EX7LNKYjWrncy/7XAUcbvg8HSs17
         r0Akc7+zeouuy4VjAXp06RpRH80bLPh/cx+J746qCeryUP5FRNklt0LzBrMAKUjjm5bY
         BHyxzi1IyJFuQTwMiDaTB8KFIUr6+PiNnEQAn/dhvJx8OEurupYx6RgNOenrjeE39EzS
         LQUAUazlw1HoOf4J41EL95BNVFOcOPCnfgEWphO41NvIhJ53ny3C9UIZJl3gJpvAL5xe
         DZJFwLWWXD3vAL8Ihuam2BKuayG9qtzbKwREDEW5fjJ9mWSNVR2zAzQmOT+FBoR2ZuTM
         ijrw==
X-Gm-Message-State: ANhLgQ2uvLSMXqBh4QSC1FcGxfkUcBSD9u9xU4cY+/qa73LD+OK8/H7y
        CNTUJzllTGuFVxz0gShx/Qb0N9O5FoQUKw==
X-Google-Smtp-Source: ADFU+vsL98/sif6rEpL0hnW/uy3HLU6a6UdwBP4G0OgurVHosmH3buDWW7Tp5p1HnY09B+3AIUC1+0DmKYwqnw==
X-Received: by 2002:ac8:6f50:: with SMTP id n16mr2624102qtv.5.1584399750504;
 Mon, 16 Mar 2020 16:02:30 -0700 (PDT)
Date:   Mon, 16 Mar 2020 16:02:21 -0700
In-Reply-To: <20200316230223.242532-1-edumazet@google.com>
Message-Id: <20200316230223.242532-2-edumazet@google.com>
Mime-Version: 1.0
References: <20200316230223.242532-1-edumazet@google.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH net-next 1/3] net_sched: add qdisc_watchdog_schedule_range_ns()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some packet schedulers might want to add a slack
when programming hrtimers. This can reduce number
of interrupts and increase batch sizes and thus
give good xmit_more savings.

This commit adds qdisc_watchdog_schedule_range_ns()
helper, with an extra delta_ns parameter.

Legacy qdisc_watchdog_schedule_n() becomes an inline
passing a zero slack.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/pkt_sched.h | 10 +++++++++-
 net/sched/sch_api.c     | 12 +++++++-----
 2 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 20d2c6419612fd4d35b0960456394ea69ced7e7d..9092e697059e775af307be69a879386ebfd9924f 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -75,7 +75,15 @@ struct qdisc_watchdog {
 void qdisc_watchdog_init_clockid(struct qdisc_watchdog *wd, struct Qdisc *qdisc,
 				 clockid_t clockid);
 void qdisc_watchdog_init(struct qdisc_watchdog *wd, struct Qdisc *qdisc);
-void qdisc_watchdog_schedule_ns(struct qdisc_watchdog *wd, u64 expires);
+
+void qdisc_watchdog_schedule_range_ns(struct qdisc_watchdog *wd, u64 expires,
+				      u64 delta_ns);
+
+static inline void qdisc_watchdog_schedule_ns(struct qdisc_watchdog *wd,
+					      u64 expires)
+{
+	return qdisc_watchdog_schedule_range_ns(wd, expires, 0ULL);
+}
 
 static inline void qdisc_watchdog_schedule(struct qdisc_watchdog *wd,
 					   psched_time_t expires)
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 50794125bf0240031c142045d09b429cf945029f..83984be04f57d93b4efc50bb9cf390b116101fdd 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -618,7 +618,8 @@ void qdisc_watchdog_init(struct qdisc_watchdog *wd, struct Qdisc *qdisc)
 }
 EXPORT_SYMBOL(qdisc_watchdog_init);
 
-void qdisc_watchdog_schedule_ns(struct qdisc_watchdog *wd, u64 expires)
+void qdisc_watchdog_schedule_range_ns(struct qdisc_watchdog *wd, u64 expires,
+				      u64 delta_ns)
 {
 	if (test_bit(__QDISC_STATE_DEACTIVATED,
 		     &qdisc_root_sleeping(wd->qdisc)->state))
@@ -628,11 +629,12 @@ void qdisc_watchdog_schedule_ns(struct qdisc_watchdog *wd, u64 expires)
 		return;
 
 	wd->last_expires = expires;
-	hrtimer_start(&wd->timer,
-		      ns_to_ktime(expires),
-		      HRTIMER_MODE_ABS_PINNED);
+	hrtimer_start_range_ns(&wd->timer,
+			       ns_to_ktime(expires),
+			       delta_ns,
+			       HRTIMER_MODE_ABS_PINNED);
 }
-EXPORT_SYMBOL(qdisc_watchdog_schedule_ns);
+EXPORT_SYMBOL(qdisc_watchdog_schedule_range_ns);
 
 void qdisc_watchdog_cancel(struct qdisc_watchdog *wd)
 {
-- 
2.25.1.481.gfbce0eb801-goog

