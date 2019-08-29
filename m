Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89C24A23AC
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbfH2SRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:59088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729890AbfH2SQ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:16:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63E0423403;
        Thu, 29 Aug 2019 18:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102618;
        bh=D+8zjNwZ8CrhkbgQn80DEiwKxkuOAmXsZZc/8oApyLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qg+FCSZ5qx4Ax/MUUknRBG+s2FtfvaCwNkJDUF25kSi9sWA+F5xlbD3wlxFSHQkp+
         OaGhH8qBpO60vLqu/RsJ77DYMV+atztU55vCCatudQkDL5IpwlMZdsQhu4sF7D2Dp0
         iSIlHhfAXm8BrfcwEQ3BhPLpg8OyfR+25K0fIGn8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dexuan Cui <decui@microsoft.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 02/27] hv_netvsc: Fix a warning of suspicious RCU usage
Date:   Thu, 29 Aug 2019 14:16:28 -0400
Message-Id: <20190829181655.8741-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181655.8741-1-sashal@kernel.org>
References: <20190829181655.8741-1-sashal@kernel.org>
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
index eb92720dd1c4a..33c1f6548fb79 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1170,12 +1170,15 @@ static void netvsc_get_stats64(struct net_device *net,
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
 
@@ -1214,6 +1217,8 @@ static void netvsc_get_stats64(struct net_device *net,
 		t->rx_packets	+= packets;
 		t->multicast	+= multicast;
 	}
+out:
+	rcu_read_unlock();
 }
 
 static int netvsc_set_mac_addr(struct net_device *ndev, void *p)
-- 
2.20.1

