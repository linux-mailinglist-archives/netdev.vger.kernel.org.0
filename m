Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DE3668E517
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:39:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjBHAi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:38:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbjBHAip (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:38:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7036742BDD
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:38:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 193DBB819FF
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A61ECC4339E;
        Wed,  8 Feb 2023 00:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675816650;
        bh=0XaZq5DMDv1C8A0HgLhBwrnjmMNJL49MLCGJxMqjYQI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RVG/tc+CAtQqVguKAOjTVcOtS6TK2hfjg1xMVhuSDaLaAbUmgNvgkI5FW7eUYVPju
         dT4tHtQfSaRPl7Zwo4Yo3olF0L3fvkPvWhg+G2Gs0Mhy9bcodItv2ilAU3T4V6g4hi
         yCFgl6aOM0HkjIoOPBTcxph1Zfr+v0QYDxr2dcMX57BXHgvcNsmWowzLuUHx2AeZWK
         8v/gbo2tsb6yiyKSCGC7BfyVMMH2rd/Jbb0vbAxi5C8PO6KWEPaAXpTJVLUxj4RAUY
         VHpBSvYMnO5YpqeYE2TH7NffhT/4IRfex2ABWVwfhKSgU0WeKFDCfRviJbQYWG9zdp
         X+D0g+Xui/mOg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 13/15] net/mlx5: fw_tracer, allow 0 size string DBs
Date:   Tue,  7 Feb 2023 16:37:10 -0800
Message-Id: <20230208003712.68386-14-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208003712.68386-1-saeed@kernel.org>
References: <20230208003712.68386-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Drory <shayd@nvidia.com>

Device can expose string DB of size 0 which means this string DB is
currently not in use. Therefore, allow for 0 size string DBs.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 4ce75cef46c8..de98357dfd14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -233,6 +233,8 @@ static int mlx5_fw_tracer_allocate_strings_db(struct mlx5_fw_tracer *tracer)
 	int i;
 
 	for (i = 0; i < num_string_db; i++) {
+		if (!string_db_size_out[i])
+			continue;
 		tracer->str_db.buffer[i] = kzalloc(string_db_size_out[i], GFP_KERNEL);
 		if (!tracer->str_db.buffer[i])
 			goto free_strings_db;
@@ -278,6 +280,8 @@ static void mlx5_tracer_read_strings_db(struct work_struct *work)
 	}
 
 	for (i = 0; i < num_string_db; i++) {
+		if (!tracer->str_db.size_out[i])
+			continue;
 		offset = 0;
 		MLX5_SET(mtrc_stdb, in, string_db_index, i);
 		num_of_reads = tracer->str_db.size_out[i] /
@@ -384,6 +388,8 @@ static struct tracer_string_format *mlx5_tracer_get_string(struct mlx5_fw_tracer
 	str_ptr = tracer_event->string_event.string_param;
 
 	for (i = 0; i < tracer->str_db.num_string_db; i++) {
+		if (!tracer->str_db.size_out[i])
+			continue;
 		if (str_ptr > tracer->str_db.base_address_out[i] &&
 		    str_ptr < tracer->str_db.base_address_out[i] +
 		    tracer->str_db.size_out[i]) {
-- 
2.39.1

