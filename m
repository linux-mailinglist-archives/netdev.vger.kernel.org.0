Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B600A2327
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:13:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbfH2SNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:13:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:55444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728490AbfH2SNp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:13:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5885023405;
        Thu, 29 Aug 2019 18:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102424;
        bh=JqJfHtTLl3cwcE+vmBm9Cyl5Qi9vXylINoDckON63Ak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0ntnSFsnOr14HKpFNEItgGa8N6sK4lpj4kB/vQ8Q/rvP722qc1i2ib4TLywm+kC0
         AWAlIE++pF8u4rSUA8LjTFsvVUEDGTxDXt/m8gGIGj8lPzbkEmJpy/pe+1k/oGEC72
         q6Rf83NpPhUtTSdn1aVwNjR2K2sFh7a7L4TuNuOQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dexuan Cui <decui@microsoft.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 16/76] hv_netvsc: Fix a warning of suspicious RCU usage
Date:   Thu, 29 Aug 2019 14:12:11 -0400
Message-Id: <20190829181311.7562-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dexuan Cui <decui@microsoft.com>

[ Upstream commit 6d0d779dca73cd5acb649c54f81401f93098b298 ]

This fixes a warning of "suspicious rcu_dereference_check() usage"
when nload runs.

Fixes: 776e726bfb34 ("netvsc: fix RCU warning in get_stats")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc_drv.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 3544e19915792..e8fce6d715ef0 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1239,12 +1239,15 @@ static void netvsc_get_stats64(struct net_device *net,
 			       struct rtnl_link_stats64 *t)
 {
 	struct net_device_context *ndev_ctx = netdev_priv(net);
-	struct netvsc_device *nvdev = rcu_dereference_rtnl(ndev_ctx->nvdev);
+	struct netvsc_device *nvdev;
 	struct netvsc_vf_pcpu_stats vf_tot;
 	int i;
 
+	rcu_read_lock();
+
+	nvdev = rcu_dereference(ndev_ctx->nvdev);
 	if (!nvdev)
-		return;
+		goto out;
 
 	netdev_stats_to_stats64(t, &net->stats);
 
@@ -1283,6 +1286,8 @@ static void netvsc_get_stats64(struct net_device *net,
 		t->rx_packets	+= packets;
 		t->multicast	+= multicast;
 	}
+out:
+	rcu_read_unlock();
 }
 
 static int netvsc_set_mac_addr(struct net_device *ndev, void *p)
-- 
2.20.1

