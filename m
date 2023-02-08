Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37A8768E515
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 01:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjBHAiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 19:38:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjBHAhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 19:37:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 023083F287
        for <netdev@vger.kernel.org>; Tue,  7 Feb 2023 16:37:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BDE1B81B96
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 00:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC1CC433EF;
        Wed,  8 Feb 2023 00:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675816652;
        bh=4lrRFB2eXvoCeRnIkKjx5t2hqzsF8IsJXDnBMr0cbnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SO7sJRnehanCto4q2AuEvETZLaSmy2BOLTpAddPkcaIFh0icy0c4a5oulcs/6Co4q
         w99kfw7rCuwtaqWBNs2nYAZ97sKSUEGa9pCafY3/aVUnK5dhZyqCGq8hSF2Aru7B+U
         gJbYMZ93vIQrWA8eaDucahzb+Py8knsvg7/6X9yQ9fhBsgEOSU4Z8g4P9wHJJjqWz0
         0hCXCkdimk7ZMD1cQIYBCK/yBLw2rvUE4SCUJJs3WImoA6YHQ2YWuZRK/lAu1veVkA
         jTnTzp8djXkKnjIIJfS55PmyTDPvFW+h52Ze6gNbhGVFKZGpNl1A5rNfgxisI/bRzu
         Up9aVrpmzKF2g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Moshe Shemesh <moshe@nvidia.com>
Subject: [net-next 15/15] net/mlx5: fw_tracer, Add support for unrecognized string
Date:   Tue,  7 Feb 2023 16:37:12 -0800
Message-Id: <20230208003712.68386-16-saeed@kernel.org>
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

In case FW is publishing a string which isn't found in the driver's
string DBs, keep the string as raw data.

Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/diag/fw_tracer.c       | 25 +++++++++++++++++--
 .../mellanox/mlx5/core/diag/fw_tracer.h       |  1 +
 2 files changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 46f1e866bf64..f7864d51d4c4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -465,6 +465,7 @@ static void poll_trace(struct mlx5_fw_tracer *tracer,
 
 	tracer_event->event_id = MLX5_GET(tracer_event, trace, event_id);
 	tracer_event->lost_event = MLX5_GET(tracer_event, trace, lost);
+	tracer_event->out = trace;
 
 	switch (tracer_event->event_id) {
 	case TRACER_EVENT_TYPE_TIMESTAMP:
@@ -587,6 +588,26 @@ void mlx5_tracer_print_trace(struct tracer_string_format *str_frmt,
 	mlx5_tracer_clean_message(str_frmt);
 }
 
+static int mlx5_tracer_handle_raw_string(struct mlx5_fw_tracer *tracer,
+					 struct tracer_event *tracer_event)
+{
+	struct tracer_string_format *cur_string;
+
+	cur_string = mlx5_tracer_message_insert(tracer, tracer_event);
+	if (!cur_string)
+		return -1;
+
+	cur_string->event_id = tracer_event->event_id;
+	cur_string->timestamp = tracer_event->string_event.timestamp;
+	cur_string->lost = tracer_event->lost_event;
+	cur_string->string = "0x%08x%08x";
+	cur_string->num_of_params = 2;
+	cur_string->params[0] = upper_32_bits(*tracer_event->out);
+	cur_string->params[1] = lower_32_bits(*tracer_event->out);
+	list_add_tail(&cur_string->list, &tracer->ready_strings_list);
+	return 0;
+}
+
 static int mlx5_tracer_handle_string_trace(struct mlx5_fw_tracer *tracer,
 					   struct tracer_event *tracer_event)
 {
@@ -595,7 +616,7 @@ static int mlx5_tracer_handle_string_trace(struct mlx5_fw_tracer *tracer,
 	if (tracer_event->string_event.tdsn == 0) {
 		cur_string = mlx5_tracer_get_string(tracer, tracer_event);
 		if (!cur_string)
-			return -1;
+			return mlx5_tracer_handle_raw_string(tracer, tracer_event);
 
 		cur_string->num_of_params = mlx5_tracer_get_num_of_params(cur_string->string);
 		cur_string->last_param_num = 0;
@@ -610,7 +631,7 @@ static int mlx5_tracer_handle_string_trace(struct mlx5_fw_tracer *tracer,
 		if (!cur_string) {
 			pr_debug("%s Got string event for unknown string tmsn: %d\n",
 				 __func__, tracer_event->string_event.tmsn);
-			return -1;
+			return mlx5_tracer_handle_raw_string(tracer, tracer_event);
 		}
 		cur_string->last_param_num += 1;
 		if (cur_string->last_param_num > TRACER_MAX_PARAMS) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
index 873c1eb38e49..5c548bb74f07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.h
@@ -166,6 +166,7 @@ struct tracer_event {
 		struct tracer_string_event string_event;
 		struct tracer_timestamp_event timestamp_event;
 	};
+	u64 *out;
 };
 
 struct mlx5_ifc_tracer_event_bits {
-- 
2.39.1

