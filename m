Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A35B253FF5B
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 14:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244086AbiFGMsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 08:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244191AbiFGMsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 08:48:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9931313EBD;
        Tue,  7 Jun 2022 05:48:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A785B81F6E;
        Tue,  7 Jun 2022 12:48:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C4BC385A5;
        Tue,  7 Jun 2022 12:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654606083;
        bh=/6NsrWgjW5XlNWz0DHm3gy/B2YKwhVrCWYTDLXV0/wY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ft8NqcJkj3muFkOVLl48cCAFdAVtWn0E8vVnW3Hjr9QU2xjxq1MKc0Y6tDdGGrej9
         Dg3pXdkEcl5SM5881fV/2jXnUDKt3l1huSZzw2dbIB3pgNcYT24ONH7P22viyD7qNc
         AMC2zLuiuYjKCpcL8moTgno/78YukP6BOLgfxeGISEBllwViSvBhrTWvLZFfZTnAzX
         URZQEly3ksAyy1J+ls4AiQMMT7eFa0xt3XxnbyCSlTyGot1nQC4ylLFd6KgAaY1NyH
         GkFLTk+GewI9k6ECmRE9JLUmzKKtmYz3GWGMla+yYWc4otqCmWTdPSuuUpI/7iGUiI
         wfBu2EPrc9xvA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 1/3] net/mlx5: Introduce header-modify-pattern ICM properties
Date:   Tue,  7 Jun 2022 15:47:43 +0300
Message-Id: <66f4096ce4d4c8451f0b781284c650f97e545d41.1654605768.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1654605768.git.leonro@nvidia.com>
References: <cover.1654605768.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Added new fields for device memory capabilities, in order to
support creation of ICM memory for modify header patterns.

Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 006836ae7e43..4e41b3164dc8 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1086,11 +1086,14 @@ struct mlx5_ifc_device_mem_cap_bits {
 	u8         log_sw_icm_alloc_granularity[0x6];
 	u8         log_steering_sw_icm_size[0x8];
 
-	u8         reserved_at_120[0x20];
+	u8         reserved_at_120[0x18];
+	u8         log_header_modify_pattern_sw_icm_size[0x8];
 
 	u8         header_modify_sw_icm_start_address[0x40];
 
-	u8         reserved_at_180[0x80];
+	u8         reserved_at_180[0x40];
+
+	u8         header_modify_pattern_sw_icm_start_address[0x40];
 
 	u8         memic_operations[0x20];
 
-- 
2.36.1

