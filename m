Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B734D5C9B
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 08:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347242AbiCKHlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 02:41:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344825AbiCKHls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 02:41:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A123C1B7570
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 23:40:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58AFCB82AE1
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 07:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ED93C340F3;
        Fri, 11 Mar 2022 07:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646984443;
        bh=YueKU+eAiD0wkJcIy23m3O5aVSIo0ZrgWwbaTg/vv9Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xgh5OvAkwJHNL7P24OI0d2wDiiEhutvpZkKMWvomSk+l9tmiVHdzh0HzQOc5Y6Bi7
         UlGAJloT8hstWBqZt4CB5fD5bLlWc7qn5V5OqhzV88hT4wn02AdmishRp7+yhZVuuj
         hh0EPc1VjJr4L2sVrowX/+ahFDRrS9/YdIRSOdV7G3T6Dzmo0XMf0Gb0hVVwFXCo8D
         Rrjig+rD+i/7vyQocY+rZaixvt+OyGpWnc/HEt6RHG8VL/EsU1gCK8VTKmxNU7WLVA
         Tbey0LNbbgTH7TFKYIDkKmGkA3uV4dfZh5SJHsxRhmo/xq+qlqDjxukRfgQHVuKv6E
         PyDYwlbS/f7og==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/15] net/mlx5: Node-aware allocation for the EQ table
Date:   Thu, 10 Mar 2022 23:40:20 -0800
Message-Id: <20220311074031.645168-5-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220311074031.645168-1-saeed@kernel.org>
References: <20220311074031.645168-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>

Prefer the aware allocation, use the device NUMA node.

Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index cb4730cb456a..316105378188 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -438,7 +438,8 @@ int mlx5_eq_table_init(struct mlx5_core_dev *dev)
 	struct mlx5_eq_table *eq_table;
 	int i;
 
-	eq_table = kvzalloc(sizeof(*eq_table), GFP_KERNEL);
+	eq_table = kvzalloc_node(sizeof(*eq_table), GFP_KERNEL,
+				 dev->priv.numa_node);
 	if (!eq_table)
 		return -ENOMEM;
 
-- 
2.35.1

