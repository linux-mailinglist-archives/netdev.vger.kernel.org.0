Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 878871FE853
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 04:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387932AbgFRCrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 22:47:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:37210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728426AbgFRBKM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 21:10:12 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FEAB21D90;
        Thu, 18 Jun 2020 01:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442612;
        bh=8cYg6YWaQ92yyXv7/1wtOlTaxEGIiAIY8Tv1LNlbrn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RJ3w3U6QqyAvhzqVcQgb4prhQqLwHiuYMVKqfir2OFf7LQHMDQi06jV7048n+D6U5
         UF8zPqLYkAt/sF14VATYvtJ/0zuQ7wp9iuewYG4ecNwjY1Sq3uapL/aI72K1uFkCnT
         lgsgVvpGW6r/8jAjCl2ILS/pKgDbHsp707JpNjaw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        kernel test robot <lkp@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 093/388] net: mdiobus: Disable preemption upon u64_stats update
Date:   Wed, 17 Jun 2020 21:03:10 -0400
Message-Id: <20200618010805.600873-93-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Ahmed S. Darwish" <a.darwish@linutronix.de>

[ Upstream commit c7e261d81783387a0502878cd229327e7c54322e ]

The u64_stats mechanism uses sequence counters to protect against 64-bit
values tearing on 32-bit architectures. Updating u64_stats is thus a
sequence counter write side critical section where preemption must be
disabled.

For mdiobus_stats_acct(), disable preemption upon the u64_stats update.
It is called from process context through mdiobus_read() and
mdiobus_write().

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mdio_bus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 7a4eb3f2cb74..a1a4dee2a033 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -757,6 +757,7 @@ EXPORT_SYMBOL(mdiobus_scan);
 
 static void mdiobus_stats_acct(struct mdio_bus_stats *stats, bool op, int ret)
 {
+	preempt_disable();
 	u64_stats_update_begin(&stats->syncp);
 
 	u64_stats_inc(&stats->transfers);
@@ -771,6 +772,7 @@ static void mdiobus_stats_acct(struct mdio_bus_stats *stats, bool op, int ret)
 		u64_stats_inc(&stats->writes);
 out:
 	u64_stats_update_end(&stats->syncp);
+	preempt_enable();
 }
 
 /**
-- 
2.25.1

