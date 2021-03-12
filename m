Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 746153390B7
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232216AbhCLPFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:05:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:43764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232067AbhCLPFP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 10:05:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9783264F78;
        Fri, 12 Mar 2021 15:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615561515;
        bh=t7v9Cnk0wuYPToBbUmRLJDu4jjX6yO2eMC/jsZiBq/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XLXvDXK96sDsCd4pWqwnqKJRP0jFCMprcOnt8GVAgh1Gbm7DnqTsCB6ht9hMcI08G
         Es086gL2ON0cTo7L0Ay/4ZK0WlnSTQwj0hH/Q6zyj2pjNCgPAiVXPHkjTZPXf73GIu
         UlMirfY2Pkn5GSDT6nocx1I13QJvGHLqdOE3nrgFrMmkVANEYOmQP2DhI6eMTkH/n4
         0Rc18NYIBWM802+NtBkTugtyueCFrf8Si7y3zdNXRUKGFRt/LQogZEr6+FFiUGjK0a
         3j0PqQco6fNn17e3JJReHtVS3KndQT1cPeWbkCb2EV+ps09MFK9jA5Mj4Tlth2ckG5
         Qbzkc/YYGtFTg==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 10/16] net: improve queue removal readability in __netif_set_xps_queue
Date:   Fri, 12 Mar 2021 16:04:38 +0100
Message-Id: <20210312150444.355207-11-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210312150444.355207-1-atenart@kernel.org>
References: <20210312150444.355207-1-atenart@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Improve the readability of the loop removing tx-queue from unused
CPUs/rx-queues in __netif_set_xps_queue. The change should only be
cosmetic.

Signed-off-by: Antoine Tenart <atenart@kernel.org>
---
 net/core/dev.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 4d39938417c4..052797ca65f6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2786,13 +2786,16 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 
 	/* removes tx-queue from unused CPUs/rx-queues */
 	for (j = 0; j < dev_maps->nr_ids; j++) {
-		for (i = tc, tci = j * dev_maps->num_tc; i--; tci++)
-			active |= remove_xps_queue(dev_maps, tci, index);
-		if (!netif_attr_test_mask(j, mask, dev_maps->nr_ids) ||
-		    !netif_attr_test_online(j, online_mask, dev_maps->nr_ids))
-			active |= remove_xps_queue(dev_maps, tci, index);
-		for (i = dev_maps->num_tc - tc, tci++; --i; tci++)
+		tci = j * dev_maps->num_tc;
+
+		for (i = 0; i < dev_maps->num_tc; i++, tci++) {
+			if (i == tc &&
+			    netif_attr_test_mask(j, mask, dev_maps->nr_ids) &&
+			    netif_attr_test_online(j, online_mask, dev_maps->nr_ids))
+				continue;
+
 			active |= remove_xps_queue(dev_maps, tci, index);
+		}
 	}
 
 	/* free map if not active */
-- 
2.29.2

