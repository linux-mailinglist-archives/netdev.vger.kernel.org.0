Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF711877BB
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 03:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgCQCND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 22:13:03 -0400
Received: from mail-pf1-f201.google.com ([209.85.210.201]:36732 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726112AbgCQCNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 22:13:02 -0400
Received: by mail-pf1-f201.google.com with SMTP id h125so14359762pfg.3
        for <netdev@vger.kernel.org>; Mon, 16 Mar 2020 19:13:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bWU1KUea0PGdJyaHhg5e5jGP5H6rVnCR+piA28aOiVQ=;
        b=TOqp2n01FKTeFK520GLY+WDAEcu9crKqz960lzwr24J08ZWMeKbnzdkQRge3Int5aT
         ZJoEIE5IgO2V0sOg/O2CKxMX139vxuwmRvTKbBJxqQpdrKVlk2RLUFdKFK8pyx63gZ84
         F82cNsnk9TPCgXqEAAJRptbvnPcLMKtw5HOxe8gNc7vNecg/MjmWC27ztzScfy5r37Km
         SjnvqYoCWeYspxfB2GPS+joH/rabcngTQEiaLYqvl0Wl18TrhLNpF6hOXVWFDPoOZJRD
         0V9XQFqXuzLONEM0akOr8hkI9IzklI+Wqeugfh6a9nKN+LTHJJOcfoeu+0kBfgxAcc23
         P5GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bWU1KUea0PGdJyaHhg5e5jGP5H6rVnCR+piA28aOiVQ=;
        b=Jr1sWkWj+akOBTnj0adFkwglqRnB8OZh85mcG5iaYTIOzFgTiMQyUMo1TAdDj2T6DQ
         oLlk0mXle6/dVy/flkRNznKk7/fMisXTRXaEJSRhgUVtMlmbngHvxp3jXOnvoyxmcB9n
         E0ebXAQnHDv6SXt7+CzfXzVzKrvKG2evb8lSTs5zOJpVrNysOQBIMEGMj8n4uesFKaC6
         4jrzemXlJkHcbHaHgXmHobQFjiYkJX8aZrddXzJ3GUr2VexH2ThsfJJNbgzbyoSENiYv
         /ecZOVEe7os74NDkP0xZx1ufrnCYDjFXrx+/OlEv5h3IA0S+2PbEhdGjUXx3Eh2x1P0W
         LjYg==
X-Gm-Message-State: ANhLgQ0/cUuipwwFPnJ42W2dBDIOfc231IYPdE1CS7ssoLS8YQ8sO45y
        kpwXiRoa1kk4r6t45KC0lEo0+6emzU6gXQ==
X-Google-Smtp-Source: ADFU+vtTfY6e6ff0PTgX0yLHgM4rwQ6U2JK4WraLRTkFiLA6gBGS4uXfT/jQK/h+QVN8CG01CjI9VNobIUAMHg==
X-Received: by 2002:a17:90b:1b01:: with SMTP id nu1mr2577135pjb.129.1584411180109;
 Mon, 16 Mar 2020 19:13:00 -0700 (PDT)
Date:   Mon, 16 Mar 2020 19:12:50 -0700
In-Reply-To: <20200317021251.75190-1-edumazet@google.com>
Message-Id: <20200317021251.75190-3-edumazet@google.com>
Mime-Version: 1.0
References: <20200317021251.75190-1-edumazet@google.com>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
Subject: [PATCH v2 net-next 2/3] net_sched: do not reprogram a timer about to expire
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

