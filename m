Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76EC39A764
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232427AbhFCRLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:11:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232206AbhFCRKu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 13:10:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE29F61408;
        Thu,  3 Jun 2021 17:09:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740145;
        bh=rBdCQKo4oTB5NfIG2Xln7Et4gcFivtkkr+NcTYq4zbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tsNBQrmepkekfwrMItawmE6KQHWqUwgWfd44zITk8sqdYGQlhOMtJKTqXugIXpwTd
         Bk+sQse7cvMoj99CAorz1BsCccuzu8d1bXw98O3RqmfI+EZ8mlndEmfXh92kRQ0hXU
         d2ZTLWev0W/5DAUI6BTf8nnLtu+sQG9wOHBxNIe94yYw9KSMEjrND+s6Dl93zIcO+L
         +ldspyBWGvg6yZHqxZsvfh4PYjT+1XbE6pJ+W50vyEREYb+usX2E8OeRcfDA+efo2E
         Iw/co6N4P+Gv7uYoRENXpt40ONrO154SGGsN/aI5kxkBA/sFh8+U2QVyVy/WlYnfiq
         sTFmWLxT7S9ug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zong Li <zong.li@sifive.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 29/39] net: macb: ensure the device is available before accessing GEMGXL control registers
Date:   Thu,  3 Jun 2021 13:08:19 -0400
Message-Id: <20210603170829.3168708-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170829.3168708-1-sashal@kernel.org>
References: <20210603170829.3168708-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zong Li <zong.li@sifive.com>

[ Upstream commit 5eff1461a6dec84f04fafa9128548bad51d96147 ]

If runtime power menagement is enabled, the gigabit ethernet PLL would
be disabled after macb_probe(). During this period of time, the system
would hang up if we try to access GEMGXL control registers.

We can't put runtime_pm_get/runtime_pm_put/ there due to the issue of
sleep inside atomic section (7fa2955ff70ce453 ("sh_eth: Fix sleeping
function called from invalid context"). Add netif_running checking to
ensure the device is available before accessing GEMGXL device.

Changed in v2:
 - Use netif_running instead of its own flag

Signed-off-by: Zong Li <zong.li@sifive.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 390f45e49eaf..1e8bf6b9834b 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2709,6 +2709,9 @@ static struct net_device_stats *gem_get_stats(struct macb *bp)
 	struct gem_stats *hwstat = &bp->hw_stats.gem;
 	struct net_device_stats *nstat = &bp->dev->stats;
 
+	if (!netif_running(bp->dev))
+		return nstat;
+
 	gem_update_stats(bp);
 
 	nstat->rx_errors = (hwstat->rx_frame_check_sequence_errors +
-- 
2.30.2

