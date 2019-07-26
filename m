Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4751376908
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 15:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbfGZNsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 09:48:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:53372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388458AbfGZNoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 09:44:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0255D22CD3;
        Fri, 26 Jul 2019 13:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148694;
        bh=HNdcrqsHlssrUlXQcjsWqatBEMppPGypVvJfeyrDWH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZibfS+AxdB0d5VkbcYDEmV1fm2JNq6Vi1RVZ1SCvujzKL/FZtG6jzHvjsCNehrZv+
         PnMPm/gqx+P358g6sQbP5Nsm++skHzeBQJYd1QLk6GqKhkTqSES7GBjiz4KddrJbIL
         zZqZvJQil/LiO65QFSN+GZaAamEyV37Prcsg/XoE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Poirier <bpoirier@suse.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 16/30] be2net: Signal that the device cannot transmit during reconfiguration
Date:   Fri, 26 Jul 2019 09:44:18 -0400
Message-Id: <20190726134432.12993-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134432.12993-1-sashal@kernel.org>
References: <20190726134432.12993-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Benjamin Poirier <bpoirier@suse.com>

[ Upstream commit 7429c6c0d9cb086d8e79f0d2a48ae14851d2115e ]

While changing the number of interrupt channels, be2net stops adapter
operation (including netif_tx_disable()) but it doesn't signal that it
cannot transmit. This may lead dev_watchdog() to falsely trigger during
that time.

Add the missing call to netif_carrier_off(), following the pattern used in
many other drivers. netif_carrier_on() is already taken care of in
be_open().

Signed-off-by: Benjamin Poirier <bpoirier@suse.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index b2eeecb26939..289560b0f643 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -4701,8 +4701,12 @@ int be_update_queues(struct be_adapter *adapter)
 	struct net_device *netdev = adapter->netdev;
 	int status;
 
-	if (netif_running(netdev))
+	if (netif_running(netdev)) {
+		/* device cannot transmit now, avoid dev_watchdog timeouts */
+		netif_carrier_off(netdev);
+
 		be_close(netdev);
+	}
 
 	be_cancel_worker(adapter);
 
-- 
2.20.1

