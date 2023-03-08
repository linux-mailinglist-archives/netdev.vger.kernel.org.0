Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2480B6B10FC
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 19:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbjCHS0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 13:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCHS0v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 13:26:51 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C744C1C3C
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 10:26:50 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5395c8fc4a1so176178967b3.5
        for <netdev@vger.kernel.org>; Wed, 08 Mar 2023 10:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678300009;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=f683pxzicURAxXmgmqS7vLteyYNdzwQ20DM2v6k13W8=;
        b=THAQ3NHm8qdpVz15oeqSmJdEX6KZ8FmlBenICaLiHkhoxzODuyUJQWaCsD9xRm9pi+
         YgSrYsieASJOFFdQcDmQNZgFm4OIwYCtsNzbM2rp2OKJPzLk7s6IWUoLrqB6lBYJAJJZ
         wymukh0dxLp6JXjyFTZy0SOxuwhLDfpUpUvynDMuH39A/GIqJZAfafBEiIkka5q6bwWN
         Ltl7jBgDjcGEQvWU5icY0yefKUx6ZspeslP4IDNHI7F9ccBP9usje8uDpnO24nq6o088
         THi40PvZr0r/r1+7qPPOPiczl0juVbS2+Ar/bm8wyPHXz90bvPehsjSP8sk6ifY9gfM/
         /JDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678300009;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f683pxzicURAxXmgmqS7vLteyYNdzwQ20DM2v6k13W8=;
        b=Z3q5P2ozzcnfHeOVl+S64+gtoIG17aYpUrheo4sGinp6tU7QaZgeBs9nRWhazJcScm
         q1Owkw/YpBPHXQc257gWxifQ39zZidvkZ52fIFueTlorqizQjBA1G3+ACHZg7+kprRsF
         QCgqNR7yQyB7NPGhq+fEmcK8OiUntgi+At7QfamOV32ZfYAcf436XPVTXexu0VGPscKz
         4j4rNtkEaG5J1DmC3gLIBqbK2QUolo9y1XJvibPV5/poA9Im4LRiKfcgclgZqMyXhVgZ
         uTmKDR70Ra1dk76JXiwcf3ZZhrps1S9v6zyNCUDm6TKgPg+1JLLJ3vPg943J9ne1JIKE
         7PmA==
X-Gm-Message-State: AO0yUKVPxxGMd8L1iYOOmcPRE6bWUDvH1m0aqSTf8rcyMlZF8hdTsmIN
        Hao6uk65fbbvNBbRzKhrHVG6ArJ1lWRrsA==
X-Google-Smtp-Source: AK7set+kPTWQ8Q6PIdy91ueFMDZVix/G7PuF3+A9MKOQFE477eb/Wm2ZwHuWuBB3Qf/FvNXftsqCnvzLxyK5vQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:4d1:b0:8dd:4f2c:ede4 with SMTP
 id v17-20020a05690204d100b008dd4f2cede4mr11659078ybs.2.1678300009511; Wed, 08
 Mar 2023 10:26:49 -0800 (PST)
Date:   Wed,  8 Mar 2023 18:26:48 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
Message-ID: <20230308182648.1150762-1-edumazet@google.com>
Subject: [PATCH net-next] net: sched: remove qdisc_watchdog->last_expires
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This field mirrors hrtimer softexpires, we can instead
use the existing helpers.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/pkt_sched.h | 1 -
 net/sched/sch_api.c     | 6 ++++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 2016839991a428d951c8f7bf2e43e4cb5dd71f4c..bb0bd69fb655d462bdc49934e2e094602ab45394 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -64,7 +64,6 @@ static inline psched_time_t psched_get_time(void)
 }
 
 struct qdisc_watchdog {
-	u64		last_expires;
 	struct hrtimer	timer;
 	struct Qdisc	*qdisc;
 };
diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index aba789c30a2eb50d339b8a888495b794825e1775..fdb8f429333d26a1380063445ebfc9afad3aef84 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -639,14 +639,16 @@ void qdisc_watchdog_schedule_range_ns(struct qdisc_watchdog *wd, u64 expires,
 		return;
 
 	if (hrtimer_is_queued(&wd->timer)) {
+		u64 softexpires;
+
+		softexpires = ktime_to_ns(hrtimer_get_softexpires(&wd->timer));
 		/* If timer is already set in [expires, expires + delta_ns],
 		 * do not reprogram it.
 		 */
-		if (wd->last_expires - expires <= delta_ns)
+		if (softexpires - expires <= delta_ns)
 			return;
 	}
 
-	wd->last_expires = expires;
 	hrtimer_start_range_ns(&wd->timer,
 			       ns_to_ktime(expires),
 			       delta_ns,
-- 
2.40.0.rc1.284.g88254d51c5-goog

