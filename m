Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA1C12B7F0
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:52:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728106AbfL0RnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:43:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:40434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbfL0RnG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:43:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E4D52173E;
        Fri, 27 Dec 2019 17:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468585;
        bh=uFvVNQ0ST9CDv74Dab0CJbZ4XEODJPVqosS+Ii1lLvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BeOQ25WOE9Prt8OOtsMW9x3kEkEWI9E6CgFVESgAvHbHktlHZSxG5rysIcBFoKA2q
         v2AsgcyJ3WV0D2Vu424njsg+BS1EkrUNEtmqOp+4xYpxEXtbefmolvt1hNXC9PHKWy
         DAU7ER8RzubG1NR5nnlDA8ZLdS+7L7JgWPsFn2TM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haiyang Zhang <haiyangz@microsoft.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Sasha Levin <sashal@kernel.org>, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 108/187] hv_netvsc: Fix tx_table init in rndis_set_subchannel()
Date:   Fri, 27 Dec 2019 12:39:36 -0500
Message-Id: <20191227174055.4923-108-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

[ Upstream commit c39ea5cba5a2e97fc01b78c85208bf31383b399c ]

Host can provide send indirection table messages anytime after RSS is
enabled by calling rndis_filter_set_rss_param(). So the host provided
table values may be overwritten by the initialization in
rndis_set_subchannel().

To prevent this problem, move the tx_table initialization before calling
rndis_filter_set_rss_param().

Fixes: a6fb6aa3cfa9 ("hv_netvsc: Set tx_table to equal weight after subchannels open")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/rndis_filter.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index abaf8156d19d..e3d3c9097ff1 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1165,6 +1165,9 @@ int rndis_set_subchannel(struct net_device *ndev,
 	wait_event(nvdev->subchan_open,
 		   atomic_read(&nvdev->open_chn) == nvdev->num_chn);
 
+	for (i = 0; i < VRSS_SEND_TAB_SIZE; i++)
+		ndev_ctx->tx_table[i] = i % nvdev->num_chn;
+
 	/* ignore failures from setting rss parameters, still have channels */
 	if (dev_info)
 		rndis_filter_set_rss_param(rdev, dev_info->rss_key);
@@ -1174,9 +1177,6 @@ int rndis_set_subchannel(struct net_device *ndev,
 	netif_set_real_num_tx_queues(ndev, nvdev->num_chn);
 	netif_set_real_num_rx_queues(ndev, nvdev->num_chn);
 
-	for (i = 0; i < VRSS_SEND_TAB_SIZE; i++)
-		ndev_ctx->tx_table[i] = i % nvdev->num_chn;
-
 	return 0;
 }
 
-- 
2.20.1

