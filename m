Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E79D17AC10
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 18:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727938AbgCERSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 12:18:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:42426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728117AbgCERPf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 12:15:35 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3015421739;
        Thu,  5 Mar 2020 17:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428534;
        bh=7EZFA0yEFYm/NUSzTiHK2MXkr9twqygEe+mMb0V/yWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mvLsdfTm1WOt1yORKmrZEVT0Syp/rWy2nXoBAxYvfxliDFnk3G64LROa0yD8MmjOV
         TAQMgrMoebLtUAsjxnsVqcgAR7KFe4nG6UhzRNwt+4AK0WE1j0aQn1N21OIE2WJS4e
         0FrRM2lGXMl6f1WEwwjSH4Q6pXs92XeBqj8VJY1g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haiyang Zhang <haiyangz@microsoft.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 14/31] hv_netvsc: Fix unwanted wakeup in netvsc_attach()
Date:   Thu,  5 Mar 2020 12:14:58 -0500
Message-Id: <20200305171516.30028-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171516.30028-1-sashal@kernel.org>
References: <20200305171516.30028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

[ Upstream commit f6f13c125e05603f68f5bf31f045b95e6d493598 ]

When netvsc_attach() is called by operations like changing MTU, etc.,
an extra wakeup may happen while netvsc_attach() calling
rndis_filter_device_add() which sends rndis messages when queue is
stopped in netvsc_detach(). The completion message will wake up queue 0.

We can reproduce the issue by changing MTU etc., then the wake_queue
counter from "ethtool -S" will increase beyond stop_queue counter:
     stop_queue: 0
     wake_queue: 1
The issue causes queue wake up, and counter increment, no other ill
effects in current code. So we didn't see any network problem for now.

To fix this, initialize tx_disable to true, and set it to false when
the NIC is ready to be attached or registered.

Fixes: 7b2ee50c0cd5 ("hv_netvsc: common detach logic")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc.c     | 2 +-
 drivers/net/hyperv/netvsc_drv.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index dbfd3a0c97d3b..77a9a753d9794 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -110,7 +110,7 @@ static struct netvsc_device *alloc_net_device(void)
 
 	init_waitqueue_head(&net_device->wait_drain);
 	net_device->destroy = false;
-	net_device->tx_disable = false;
+	net_device->tx_disable = true;
 
 	net_device->max_pkt = RNDIS_MAX_PKT_DEFAULT;
 	net_device->pkt_align = RNDIS_PKT_ALIGN_DEFAULT;
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index 7ab576d8b6227..bdb55db4523b1 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -984,6 +984,7 @@ static int netvsc_attach(struct net_device *ndev,
 	}
 
 	/* In any case device is now ready */
+	nvdev->tx_disable = false;
 	netif_device_attach(ndev);
 
 	/* Note: enable and attach happen when sub-channels setup */
@@ -2336,6 +2337,8 @@ static int netvsc_probe(struct hv_device *dev,
 	else
 		net->max_mtu = ETH_DATA_LEN;
 
+	nvdev->tx_disable = false;
+
 	ret = register_netdevice(net);
 	if (ret != 0) {
 		pr_err("Unable to register netdev.\n");
-- 
2.20.1

