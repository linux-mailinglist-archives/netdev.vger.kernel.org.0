Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1400C313ADE
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:26:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232964AbhBHR0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:26:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:34900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234800AbhBHRV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Feb 2021 12:21:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA31564EB8;
        Mon,  8 Feb 2021 17:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612804787;
        bh=gRrWc7kvhk/DZiBYnZAAhJguwua33p7z3XuR3MwFUTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j4ynVEPHuAGU/BVeCDcWY5qsenSbCVVgsn1/csFH3nFntFzthYW1/9KvRhPGRv1zy
         /d8UEYZ5O3Pz26mgGVBOW37n/j6Mgo4eIfDGxVhbDEFbWayZ2OGD9xQqaLoUrFcVfy
         YD5o1vStY3+LlBlllVFRHFtHQuQxJ9riTU4xd4ObLEHM8qhrYQJ+tD9kNsfRl/GeIj
         LFFftdwOCDBPK4H4dHR0afWQ24kDEypeZnk3Owcx6qzgo61yypoMauJ+mko6UV0JJq
         IblIAPPitPqiVLcFicEnPuULfY/zL205MY5EtK/ugPgvQ0JqmnNbUVqG7NfHwK8gO0
         dIPoSaO0Qg2XA==
From:   Antoine Tenart <atenart@kernel.org>
To:     davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com
Cc:     Antoine Tenart <atenart@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 11/12] net: improve queue removal readability in __netif_set_xps_queue
Date:   Mon,  8 Feb 2021 18:19:16 +0100
Message-Id: <20210208171917.1088230-12-atenart@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210208171917.1088230-1-atenart@kernel.org>
References: <20210208171917.1088230-1-atenart@kernel.org>
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
index 9b91e0d0895c..7c3ac6736bb6 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2766,13 +2766,16 @@ int __netif_set_xps_queue(struct net_device *dev, const unsigned long *mask,
 
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

