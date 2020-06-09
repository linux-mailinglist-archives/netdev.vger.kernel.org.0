Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293701F3394
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 07:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727122AbgFIFoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 01:44:18 -0400
Received: from mail-ej1-f68.google.com ([209.85.218.68]:46075 "EHLO
        mail-ej1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgFIFoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 01:44:17 -0400
Received: by mail-ej1-f68.google.com with SMTP id o15so20893271ejm.12
        for <netdev@vger.kernel.org>; Mon, 08 Jun 2020 22:44:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ciN7ZcRr4oIdU2pWpEV0PZyVR7mU2CdgAPLb8ibyRao=;
        b=FoxkPjaPi8Dim5UcplpCYHVNa2KATrs2j6XJIo9nfwC1Xq/RLoXVC/1rlKVmPnIHoo
         FBm8O86p1Bk3S1bT9/hyP7IuMP1WNq8J6IyYsjyXpXI3ZS5gzDAsZIIXbfTXTVJvjHtk
         p480+TzvkcgqKKxe+Pzby2/iCzzqfSJnUJHvIueZn5zaHxWWhHPJXyak7TUxEQbkrGKg
         bxypt8ccifyGvhmeMS0P9kGCBjm3ZpU91mhuGNC0ReEo9yHomGMrqIprwctmn9A3dqB6
         KP1DvXDoU6J/mSbVTz7zzFwbf0FZdJcoswhZygjw5kQB++CRY23HjcG2z5yu0jJopZjS
         uJFQ==
X-Gm-Message-State: AOAM533NtTenn9lJk2GNOebdbJetJFTVy996xdEndEC0peobfd8pNXSl
        J/wW5FBFbkUD1yYbJgyM7rwuLbMa
X-Google-Smtp-Source: ABdhPJys27OIFhdSCcTLLQbWA4lVlLNSAKdmK4IV2ltCpSlTS+R7Zk37NAHA2oDdGs77xQuIiWL3VA==
X-Received: by 2002:a17:906:1d5b:: with SMTP id o27mr23736412ejh.344.1591681455702;
        Mon, 08 Jun 2020 22:44:15 -0700 (PDT)
Received: from zenbook-val.localdomain (bbcs-65-74.pub.wingo.ch. [144.2.65.74])
        by smtp.gmail.com with ESMTPSA id g13sm14004652edy.27.2020.06.08.22.44.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 22:44:15 -0700 (PDT)
From:   Valentin Longchamp <valentin@longchamp.me>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, Valentin Longchamp <valentin@longchamp.me>
Subject: [PATCH v2 2/2] net: sched: make the watchdog functions more coherent
Date:   Tue,  9 Jun 2020 07:43:51 +0200
Message-Id: <20200609054351.21725-2-valentin@longchamp.me>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200609054351.21725-1-valentin@longchamp.me>
References: <20200609054351.21725-1-valentin@longchamp.me>
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
index 265a61d011df..b4d5548492ec 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -466,12 +466,7 @@ void __netdev_watchdog_up(struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(__netdev_watchdog_up);
 
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
@@ -1124,7 +1119,7 @@ void dev_activate(struct net_device *dev)
 
 	if (need_watchdog) {
 		netif_trans_update(dev);
-		dev_watchdog_up(dev);
+		__netdev_watchdog_up(dev);
 	}
 }
 EXPORT_SYMBOL(dev_activate);
@@ -1210,7 +1205,7 @@ void dev_deactivate_many(struct list_head *head)
 			dev_deactivate_queue(dev, dev_ingress_queue(dev),
 					     &noop_qdisc);
 
-		dev_watchdog_down(dev);
+		__netdev_watchdog_down(dev);
 	}
 
 	/* Wait for outstanding qdisc-less dev_queue_xmit calls.
-- 
2.25.1

