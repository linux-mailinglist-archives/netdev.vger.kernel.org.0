Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0301E3767
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 06:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgE0Ef6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 00:35:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbgE0Efy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 00:35:54 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889FCC03E97C
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 21:35:54 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a5so996829pjh.2
        for <netdev@vger.kernel.org>; Tue, 26 May 2020 21:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Crj7sbDK7PaDWu0bCbcXaPNiIUryNGZmk7oGGcvN3WU=;
        b=pgTvx6D/qCq/UStmrQx4kDl+puCDqmCEfMzjjQXwwuZnCxJSUTUCBFVASfpP1zH5CX
         kbfXokfgYjdC3jhSThX9l1+HgdR8KRWoDzTUX4aeaswoAdiST9wN3Lbfc5M8ddIHsFPg
         tYaHpiRpOfltSdD/q9ECY+tZ5ta468RcAgNdeddaI8jAz+54tv4gQGA+OWalAE+4bJdv
         Mr3X4rMVAuu7tSoRSEMANLdbulCKMsYXhBOOlgeKTrcB5SmJhKWDgqosXedDLZeQXPBZ
         lsUJTXUTvCu60hrIN0iISLgNHBxwALIotStBL3KH3kMW5izoWUcYwjQ9pq4/3CTV+m6A
         4/Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Crj7sbDK7PaDWu0bCbcXaPNiIUryNGZmk7oGGcvN3WU=;
        b=Ys7M1GYJaEO0JyOQj5jfc1LvIuPe1OCHAOadM3JZTwEz2nc6nTvaNStBlnSJMx8Bnv
         lfwjNgFVQUsPizN8Hj0bf6STmDrmbcFVuSHtCfxOGW7ZsCXSdjFtgz7cvkBGkETzNukr
         RhEsf6+DDY5IXQkqobLd6fcLzspbjbRfKaUV3HBOVgCksevUuD4h1QcURYgEXEAmpklS
         0Z6KTsF7bmwK9Drm0DDKUN3Vz2b6VcXdZzHtl+o55ZLX4sAw+ptZlL76+GpgNSuJuNBO
         Sz8hVE1jUz6M3/9bSneTTfyZlBY7s8nVWDPWzQFxmpT9solw6rx4gDACOcm54QhB7dsc
         73JA==
X-Gm-Message-State: AOAM533X53ehWEBh1iOGvsM71BfZi//whJ/9u7Wh9ZSmGTfROrfW+C3n
        k2LNuBcjlKgppYOWFqhaKfzUqFq0
X-Google-Smtp-Source: ABdhPJxJkA/oT5b9wDErJZwntFfM3T8QqeZgdoyGzTXqrjUdthiIRax6xAMHdW9LEsrYz3/cs5FWTw==
X-Received: by 2002:a17:902:9044:: with SMTP id w4mr4301644plz.83.1590554153868;
        Tue, 26 May 2020 21:35:53 -0700 (PDT)
Received: from MacBookAir.linux-6brj.site (99-174-169-255.lightspeed.sntcca.sbcglobal.net. [99.174.169.255])
        by smtp.gmail.com with ESMTPSA id 62sm884990pfc.204.2020.05.26.21.35.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 21:35:53 -0700 (PDT)
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     netdev@vger.kernel.org
Cc:     vaclav.zindulka@tlapnet.cz, Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [Patch net-next 5/5] net_sched: get rid of unnecessary dev_qdisc_reset()
Date:   Tue, 26 May 2020 21:35:27 -0700
Message-Id: <20200527043527.12287-6-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527043527.12287-1-xiyou.wangcong@gmail.com>
References: <20200527043527.12287-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Resetting old qdisc on dev_queue->qdisc_sleeping in
dev_qdisc_reset() is redundant, because this qdisc,
even if not same with dev_queue->qdisc, is reset via
qdisc_put() right after calling dev_graft_qdisc() when
hitting refcnt 0.

This is very easy to observe with qdisc_reset() tracepoint
and stack traces.

Reported-by: Václav Zindulka <vaclav.zindulka@tlapnet.cz>
Tested-by: Václav Zindulka <vaclav.zindulka@tlapnet.cz>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 net/sched/sch_generic.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index d13e27467470..b19a0021a0bd 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1191,16 +1191,6 @@ static bool some_qdisc_is_busy(struct net_device *dev)
 	return false;
 }
 
-static void dev_qdisc_reset(struct net_device *dev,
-			    struct netdev_queue *dev_queue,
-			    void *none)
-{
-	struct Qdisc *qdisc = dev_queue->qdisc_sleeping;
-
-	if (qdisc)
-		qdisc_reset(qdisc);
-}
-
 /**
  * 	dev_deactivate_many - deactivate transmissions on several devices
  * 	@head: list of devices to deactivate
@@ -1237,12 +1227,6 @@ void dev_deactivate_many(struct list_head *head)
 			 */
 			schedule_timeout_uninterruptible(1);
 		}
-		/* The new qdisc is assigned at this point so we can safely
-		 * unwind stale skb lists and qdisc statistics
-		 */
-		netdev_for_each_tx_queue(dev, dev_qdisc_reset, NULL);
-		if (dev_ingress_queue(dev))
-			dev_qdisc_reset(dev, dev_ingress_queue(dev), NULL);
 	}
 }
 
-- 
2.26.2

