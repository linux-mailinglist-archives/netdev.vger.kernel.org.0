Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4D9488BB3
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 19:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236546AbiAISlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 13:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiAISlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 13:41:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88150C06173F
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 10:41:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B67E560F5A
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 18:41:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D88AC36AE5;
        Sun,  9 Jan 2022 18:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641753710;
        bh=DhHzHYHI8CzD4kAoVKsT3+WaK9MP+48ahwTwN98njWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rB95zz0SlFbQE/BHOwuoL0GZzbSHPErUjkNkqr5ugA4fzEKxtK2Ixy3Vk/c4/JcaW
         Hul3PgQssXACpPgnOzYbNGCodo1kO6hPOgNngc7nacWxpDfSFab9MqOpN7tDi2nOmU
         TTNPcGic07ZBHCxFKPYj8nREZqt/DUpKlfdBmyXNF8iTYhWuohhATSrs81/ujLfvss
         k0Ljun4njlUshVf3qtEhVvAON4nQViJ+m3ZpmP8rH6eQw8T7QxCKrLhYiSjZ27oCai
         90QnHlnmPdOnI2pez71F3msHQxEOy5udHvOsZCJyHhgsXiJhYZKjltif/yt4dFn7TD
         BwT8MGd6PBm9A==
From:   Leon Romanovsky <leon@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2-next 1/2] rdma: Limit copy data by the destination size
Date:   Sun,  9 Jan 2022 20:41:38 +0200
Message-Id: <45c181f5a18f9159f9b0ef58d7f003b9ce583e9a.1641753491.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1641753491.git.leonro@nvidia.com>
References: <cover.1641753491.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The strncat() function will copy upto n bytes supplied as third
argument. The n bytes shouldn't be no more than destination and
not the source.

This change fixes the following clang compilation warnings:

res-srq.c:75:25: warning: size argument in 'strncat' call appears to be size of the source [-Wstrncat-size]
                        strncat(qp_str, tmp, sizeof(tmp) - 1);
                                             ^~~~~~~~~~~~~~~
res-srq.c:99:23: warning: size argument in 'strncat' call appears to be size of the source [-Wstrncat-size]
        strncat(qp_str, tmp, sizeof(tmp) - 1);
                             ^~~~~~~~~~~~~~~
res-srq.c:142:25: warning: size argument in 'strncat' call appears to be size of the source [-Wstrncat-size]
                        strncat(qp_str, tmp, sizeof(tmp) - 1);
                                             ^~~~~~~~~~~~~~~

Fixes: 9b272e138d23 ("rdma: Add SRQ resource tracking information")
Reported-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 rdma/res-srq.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/rdma/res-srq.c b/rdma/res-srq.c
index 5d8f3842..3038c352 100644
--- a/rdma/res-srq.c
+++ b/rdma/res-srq.c
@@ -70,9 +70,8 @@ static int filter_srq_range_qps(struct rd *rd, struct nlattr **qp_line,
 					 *delimiter, tmp_min_range,
 					 tmp_max_range);
 
-			if (strlen(qp_str) + strlen(tmp) >= MAX_QP_STR_LEN)
-				return -EINVAL;
-			strncat(qp_str, tmp, sizeof(tmp) - 1);
+			strncat(qp_str, tmp,
+				MAX_QP_STR_LEN - strlen(qp_str) - 1);
 
 			memset(tmp, 0, strlen(tmp));
 			*delimiter = ",";
@@ -94,9 +93,7 @@ static int filter_srq_range_qps(struct rd *rd, struct nlattr **qp_line,
 		snprintf(tmp, sizeof(tmp), "%s%d-%d", *delimiter,
 			 tmp_min_range, tmp_max_range);
 
-	if (strlen(qp_str) + strlen(tmp) >= MAX_QP_STR_LEN)
-		return -EINVAL;
-	strncat(qp_str, tmp, sizeof(tmp) - 1);
+	strncat(qp_str, tmp, MAX_QP_STR_LEN - strlen(qp_str) - 1);
 	*delimiter = ",";
 	return 0;
 }
@@ -137,9 +134,8 @@ static int get_srq_qps(struct rd *rd, struct nlattr *qp_table,  char *qp_str)
 					qp_line[RDMA_NLDEV_ATTR_RES_LQPN]))
 				continue;
 			snprintf(tmp, sizeof(tmp), "%s%d", delimiter, qpn);
-			if (strlen(qp_str) + strlen(tmp) >= MAX_QP_STR_LEN)
-				goto out;
-			strncat(qp_str, tmp, sizeof(tmp) - 1);
+			strncat(qp_str, tmp,
+				MAX_QP_STR_LEN - strlen(qp_str) - 1);
 			delimiter = ",";
 		} else if (qp_line[RDMA_NLDEV_ATTR_MIN_RANGE] &&
 			   qp_line[RDMA_NLDEV_ATTR_MAX_RANGE]) {
-- 
2.33.1

