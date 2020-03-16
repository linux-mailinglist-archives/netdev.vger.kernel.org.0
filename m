Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 885D3187600
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 00:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732905AbgCPXCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 19:02:37 -0400
Received: from mail-vs1-f74.google.com ([209.85.217.74]:37014 "EHLO
        mail-vs1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732846AbgCPXCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 19:02:36 -0400
Received: by mail-vs1-f74.google.com with SMTP id g7so112760vsg.4
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 16:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bWU1KUea0PGdJyaHhg5e5jGP5H6rVnCR+piA28aOiVQ=;
        b=rB/P5L0E2j+fEkVZZSb1yB1WPOCy07BCtvETq1E73hMdku5l5H6Ah3MSFW4Xa2xAvK
         uGCEQiLKxZPKTcga99CzqdlrpxTCkQeQ/9bTJ7pSINViOJ1YlZ1Yl3xunkWyH8STiQ3K
         8cUOifVZKCMYWDnjy4D+KuKDbr4erL/dYBBreB7HDoHJnTlq94LreL9Uf3njlmqhu1uK
         wFabW0sgs3TmCmhrJOunZD2mRnl9FsFcUQ6ZeX7mGqkhZWbpmtXxwN7G5NuLeBG5ASGj
         lDw5wi7TScAH5InCxh48jE1uiHNU1/bCyeYIYiQVKV8hpUmhrwEV10U8jPFcyKwmKXh1
         ADww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bWU1KUea0PGdJyaHhg5e5jGP5H6rVnCR+piA28aOiVQ=;
        b=S1AIRuDtZ2h+3DGgslU+PH4Ly8YmKeB58G+TKdRZfJZrXvKbUTLnegcotBXaNzD5Kp
         O1TEqXwhezisaW89rA5wLT9wN/5idlYpPNmV8PM1aMIbtjBSlGYDnDz2FMk6HCgWdVjI
         GFsaz4gb8dBj9iU+/QTPlJkUVEfB9NBayRb9M7wl7I+1jgKBdofgRrd4akeI02QwhGUe
         zkoDtpN6cgaeh9IPEGCUox/HsFE2KutY2/4LjGXAqJXXCl7+7Y6NMQLlwH0HZ56qlEvh
         Uw1X3RXeUlAOI3T3EcZioy1rj4OPC3jonpTLDRITMR295blVh80/29Q31k4MJavmSkSO
         neXQ==
X-Gm-Message-State: ANhLgQ2jx2uQwihraJVaookRXq+h/FpYUepnLT2L6v8pIxbQPSf2zDNR
        SNms4P1XpqXTv96kxcicXvqbDtG1sOZYhQ==
X-Google-Smtp-Source: ADFU+vvn9qZH1/r8UQFzzEZZXap6Vumh9PiBo5sB0hp3X1k4t4f9TJfXJYM63IukSzF7zUh62syXG9uj+2iRHQ==
X-Received: by 2002:a1f:abc7:: with SMTP id u190mr1888423vke.65.1584399753906;
 Mon, 16 Mar 2020 16:02:33 -0700 (PDT)
Date:   Mon, 16 Mar 2020 16:02:22 -0700
In-Reply-To: <20200316230223.242532-1-edumazet@google.com>
Message-Id: <20200316230223.242532-3-edumazet@google.com>
Mime-Version: 1.0
References: <20200316230223.242532-1-edumazet@google.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH net-next 2/3] net_sched: do not reprogram a timer about to expire
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

qdisc_watchdog_schedule_range_ns() can use the newly added slack
and avoid rearming the hrtimer a bit earlier than the current
value. This patch has no effect if delta_ns parameter
is zero.

Note that this means the max slack is potentially doubled.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/sched/sch_api.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 83984be04f57d93b4efc50bb9cf390b116101fdd..0d99df1e764db812f5dfc78a9c54832c0f676f70 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -625,8 +625,13 @@ void qdisc_watchdog_schedule_range_ns(struct qdisc_watchdog *wd, u64 expires,
 		     &qdisc_root_sleeping(wd->qdisc)->state))
 		return;
 
-	if (wd->last_expires == expires)
-		return;
+	if (hrtimer_is_queued(&wd->timer)) {
+		/* If timer is already set in [expires, expires + delta_ns],
+		 * do not reprogram it.
+		 */
+		if (wd->last_expires - expires <= delta_ns)
+			return;
+	}
 
 	wd->last_expires = expires;
 	hrtimer_start_range_ns(&wd->timer,
-- 
2.25.1.481.gfbce0eb801-goog

