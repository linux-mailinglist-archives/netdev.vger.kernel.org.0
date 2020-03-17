Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB561877BA
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 03:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726399AbgCQCNA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 22:13:00 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:44567 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgCQCNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 22:13:00 -0400
Received: by mail-pl1-f201.google.com with SMTP id c7so11539021plr.11
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 19:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hjXTbZ9IR5FA3dvQi37uICZa1G9fdsOo4rBuWdq92qw=;
        b=MuiulF6gHc2JFDwqeHWPsH7FheQuyjLdY/nPJ0k6Yf9s6y/uukg2RD7kubBP//bC6d
         3zSu/7qABOXKAAjyTTuPAiK2wV77Ku06VqZhjn2SrEJiZSlgsWHMLj/mt2ZBlw4YRzA2
         MUzhJ3CbunedMcIle3Vgos2YYylfSp5IksgBA5tiO7SV4wKZwVAlP7wCF19dxvuWGtSB
         QXWAUUlVLO/ZAff1idbXyksA2QHISZaaEObd7b8SBrVploqpxsGeEqr2ZRumGV9w1Wcl
         FcagWpuDF/zHutZhgdaSgDboOIonclA32ezjHIAaW6uUZ1/K3oGXJLdgdltquAOe4/pu
         ZhGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hjXTbZ9IR5FA3dvQi37uICZa1G9fdsOo4rBuWdq92qw=;
        b=K/7FO0NDoSMVw7DXXkAXWfU2PDjc3NKGJhcC2MiUSbHJPpTA66e0x/HUi4qB8EK+OG
         8TcKMwFeZIKnor5wt8PwusC1kiG6/P/JQt3PLXf2s2HwJga4ZiKAEctxz7Ux2Z8mB5lN
         K/Xebx6C9THByXk2gneVNqN76wyD9BORJmEVW9z1H6FePZ4eFKBT4NJ+GovFnHOjANh8
         PV/fE152En8LRtgZSFXUAzQ6MzI0xoXusDKm80bd+ewWg+ZdYcvqZKisG5b0zKaMWzQ5
         FQcysCghV5x44cXYZalBL5JT0jIVveJ83eotMdrKtrDH/MkPVLViZbHRGH3phjigzR4m
         03ug==
X-Gm-Message-State: ANhLgQ1saPBwWDBlPHRrV1EC8li2Xrzjl9X2uX7ON5JXpRsKtxu+4cwJ
        B5YYGQkVDvObY0tEUIVTjtCSg0tiBzHOZQ==
X-Google-Smtp-Source: ADFU+vsmDZiJouq8qY/92eLSu5OpLcpayYXN3gvYjITSTL9hhmrPGFiosAzm2AORXN+DPRbhKUqrEMb5mwDsyg==
X-Received: by 2002:a63:450b:: with SMTP id s11mr2697953pga.45.1584411177237;
 Mon, 16 Mar 2020 19:12:57 -0700 (PDT)
Date:   Mon, 16 Mar 2020 19:12:49 -0700
In-Reply-To: <20200317021251.75190-1-edumazet@google.com>
Message-Id: <20200317021251.75190-2-edumazet@google.com>
Mime-Version: 1.0
References: <20200317021251.75190-1-edumazet@google.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH v2 net-next 1/3] net_sched: add qdisc_watchdog_schedule_range_ns()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
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

