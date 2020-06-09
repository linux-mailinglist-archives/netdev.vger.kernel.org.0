Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E721F3393
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 07:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgFIFoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 01:44:09 -0400
Received: from mail-ej1-f66.google.com ([209.85.218.66]:34031 "EHLO
        mail-ej1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725770AbgFIFoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jun 2020 01:44:08 -0400
Received: by mail-ej1-f66.google.com with SMTP id l27so20944663ejc.1;
        Mon, 08 Jun 2020 22:44:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NZeC2/l48nupjKZvZ1jifZHSazauyXFgX8W5icrG39c=;
        b=hiHJvP2Oz2DMMgl27Rro/HLbzxi0eFdhL6rX5Qh/MMI3oa8GNDuNxpBwjTDE59oad1
         LdsLqVmOJl1o1eZUHxjmFexrKgMm9m23wAYsZE9FJS/EHg/mkvaO7e3d+RdLd0Fx/BkD
         x5stO24EUhj1Q3dAMZar17CrZw6NA3wMNpux6kzttnEtkwMYz6qhOjbP6qQsVgstv7NH
         +fOM0JPXE4GgmteCt75hALEw4wlLdEtnrdyJ+QySletvysdYl3WFFFRb2R3WHRGvdiAa
         ZO3iyvwlB1Rq8bKUXehEaXrjEX4FEZqiLs4WhiOc33ZCN/upqf1c//BePvxTUlmLu2ib
         c5vQ==
X-Gm-Message-State: AOAM533wVPr+SO3nhZ04axXoerO0P5jSFJkQAX5JW9+LDuKSGo/3pM6k
        P65F9o5pKPtmC2WclTfru8/2E3Jr
X-Google-Smtp-Source: ABdhPJwBZUsfBN+emWGyLy+h3uIerzOeMndGA5PEhloRNP2IpAjxVh7Ct2PlfRPRsZdK9GwZfHxjqg==
X-Received: by 2002:a17:906:2bd8:: with SMTP id n24mr25455206ejg.83.1591681446481;
        Mon, 08 Jun 2020 22:44:06 -0700 (PDT)
Received: from zenbook-val.localdomain (bbcs-65-74.pub.wingo.ch. [144.2.65.74])
        by smtp.gmail.com with ESMTPSA id g13sm14004652edy.27.2020.06.08.22.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2020 22:44:05 -0700 (PDT)
From:   Valentin Longchamp <valentin@longchamp.me>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, xiyou.wangcong@gmail.com,
        jhs@mojatatu.com, Valentin Longchamp <valentin@longchamp.me>,
        stable@vger.kernel.org
Subject: [PATCH v2 1/2] net: sched: export __netdev_watchdog_up()
Date:   Tue,  9 Jun 2020 07:43:50 +0200
Message-Id: <20200609054351.21725-1-valentin@longchamp.me>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the quiesce/activate rework, __netdev_watchdog_up() is directly
called in the ucc_geth driver.

Unfortunately, this function is not available for modules and thus
ucc_geth cannot be built as a module anymore. Fix it by exporting
__netdev_watchdog_up().

Since the commit introducing the regression was backported to stable
branches, this one should ideally be as well.

Fixes: 79dde73cf9bc ("net/ethernet/freescale: rework quiesce/activate for ucc_geth")
Cc: <stable@vger.kernel.org>
Signed-off-by: Valentin Longchamp <valentin@longchamp.me>
---
 net/sched/sch_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index b19a0021a0bd..265a61d011df 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -464,6 +464,7 @@ void __netdev_watchdog_up(struct net_device *dev)
 			dev_hold(dev);
 	}
 }
+EXPORT_SYMBOL_GPL(__netdev_watchdog_up);
 
 static void dev_watchdog_up(struct net_device *dev)
 {
-- 
2.25.1

