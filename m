Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C08146BE57
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 15:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238313AbhLGPBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238310AbhLGPBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:01:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615EBC061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 06:57:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1EA64B817EC
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 14:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9563C341C1;
        Tue,  7 Dec 2021 14:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638889052;
        bh=O47jmrRDjOqYaVTsMs5uVIXRfmyBjANilOvVR8A0lVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BOGDVLAQtLPYfTYXafDw9t5is/FCsw9C4UUlC3x1lV7iGTDQNb1H7PnQd7LC32nAV
         pIYQRHKqWNCzmRpvDJOkc2LRniwwQS6sWqEjs7eC2/URqR29aLL7Z9FAx0FI/UoVE3
         Gikw53ruDMi9E3PYc2dbXWYosRVnSIc/LaiEHT3gg3O8rgl9sygaTiFJ1kcMN2Kg4m
         BNJKTNAY4Tskp4mVG1Wz7F5GcNXRC5Xxgvr5FAWbFNVQAHT5i3ESVSmO8VNsNWjSo8
         /3dfZlFgf78R2mXerA+2+EDfowxAkUWeoDrSZkcJ/ach4TPYbCXpmcRr0xLYHMcfyH
         5LM+KBDtSFPfg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Antoine Tenart <atenart@kernel.org>, alexander.duyck@gmail.com,
        netdev@vger.kernel.org
Subject: [PATCH net-next 1/2] net-sysfs: update the queue counts in the unregistration path
Date:   Tue,  7 Dec 2021 15:57:24 +0100
Message-Id: <20211207145725.352657-2-atenart@kernel.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211207145725.352657-1-atenart@kernel.org>
References: <20211207145725.352657-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When updating Rx and Tx queue kobjects, the queue count should always be
updated to match the queue kobjects count. This was not done in the net
device unregistration path, fix it. Tracking all queue count updates
will allow in a following up patch to detect illegal updates.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/net-sysfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 3b2cdbbdc858..33f408c24205 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -1808,6 +1808,9 @@ static void remove_queue_kobjects(struct net_device *dev)
 
 	net_rx_queue_update_kobjects(dev, real_rx, 0);
 	netdev_queue_update_kobjects(dev, real_tx, 0);
+
+	dev->real_num_rx_queues = 0;
+	dev->real_num_tx_queues = 0;
 #ifdef CONFIG_SYSFS
 	kset_unregister(dev->queues_kset);
 #endif
-- 
2.33.1

