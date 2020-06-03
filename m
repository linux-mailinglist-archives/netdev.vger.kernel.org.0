Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451931ED800
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 23:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgFCVVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 17:21:19 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38575 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgFCVVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 17:21:18 -0400
Received: by mail-ed1-f66.google.com with SMTP id c35so2977286edf.5
        for <netdev@vger.kernel.org>; Wed, 03 Jun 2020 14:21:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=N4RHE2Pz6xp5cPcmriwBAQ1l4eJNFbGMloA69yBMRA0=;
        b=h1HUQ8PBVdl7FBKa79jeujRmLF0KFER4I5G7BQXsH9TvrpcINeZ051z9FcU1cMQbiL
         wlP18iwi6PmUyaUcdGZRSfEYKBEL+abRDggP7e+NlUKCekhwrzkIhdNisrv7gcPLgg+S
         0SJ4uztp4of6IsrOB9D9r10YLnUBwUmgNY978Uz9bXfUNEfkas6cvctgdXqTW3nOucMz
         B/UIXEU1uYr2ABeUcxqctITmlqaIMb8Y8H32SGoQwXixZ6Ab1DZb0laEj7uwcUOmDsw1
         ZfPQP3XWJthlk4Siav1q6E5BxeNEMIfEF7P0NKiY2kca6LfZfh+Hl7myvd4OuFnYOHlO
         +i+w==
X-Gm-Message-State: AOAM533+iJ0ee1eC08yAWhyJWoIPNEO0zA+OvVBvyDGYE0ukOWcQb5v8
        1v770u0LmGEi9b1TqN4W9aQUcv1gRuOsmw==
X-Google-Smtp-Source: ABdhPJyPNwQkdEqDLC9U3JvbyCmQ9Wn647NKNrrtk7SYfaTMaZhC2LYSPlNCFnzFYIxNWc1kbEx/ag==
X-Received: by 2002:a50:c017:: with SMTP id r23mr1459017edb.120.1591219275350;
        Wed, 03 Jun 2020 14:21:15 -0700 (PDT)
Received: from zenbook-val.localdomain (bbcs-65-74.pub.wingo.ch. [144.2.65.74])
        by smtp.gmail.com with ESMTPSA id f19sm386737edq.14.2020.06.03.14.21.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 14:21:14 -0700 (PDT)
From:   Valentin Longchamp <valentin@longchamp.me>
To:     netdev@vger.kernel.org
Cc:     jiri@resnulli.us, xiyou.wangcong@gmail.com, jhs@mojatatu.com,
        Valentin Longchamp <valentin@longchamp.me>
Subject: [PATCH] net: sched: make the watchdog functions more coherent
Date:   Wed,  3 Jun 2020 23:21:13 +0200
Message-Id: <20200603212113.11801-1-valentin@longchamp.me>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove dev_watchdog_up() that directly called __netdev_watchdog_up() and
rename dev_watchdog_down() to __netdev_watchdog_down() for symmetry.

Signed-off-by: Valentin Longchamp <valentin@longchamp.me>
---
 net/sched/sch_generic.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 2efd5b61acef..f3cb740a2941 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -465,12 +465,7 @@ void __netdev_watchdog_up(struct net_device *dev)
 	}
 }
 
-static void dev_watchdog_up(struct net_device *dev)
-{
-	__netdev_watchdog_up(dev);
-}
-
-static void dev_watchdog_down(struct net_device *dev)
+static void __netdev_watchdog_down(struct net_device *dev)
 {
 	netif_tx_lock_bh(dev);
 	if (del_timer(&dev->watchdog_timer))
@@ -1111,7 +1106,7 @@ void dev_activate(struct net_device *dev)
 
 	if (need_watchdog) {
 		netif_trans_update(dev);
-		dev_watchdog_up(dev);
+		__netdev_watchdog_up(dev);
 	}
 }
 EXPORT_SYMBOL(dev_activate);
@@ -1198,7 +1193,7 @@ void dev_deactivate_many(struct list_head *head)
 			dev_deactivate_queue(dev, dev_ingress_queue(dev),
 					     &noop_qdisc);
 
-		dev_watchdog_down(dev);
+		__netdev_watchdog_down(dev);
 	}
 
 	/* Wait for outstanding qdisc-less dev_queue_xmit calls.
-- 
2.25.1

