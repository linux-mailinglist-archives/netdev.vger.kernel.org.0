Return-Path: <netdev+bounces-5207-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 779D9710375
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 05:51:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECC05280CBA
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 03:51:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7E2C1FD6;
	Thu, 25 May 2023 03:49:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FB06FBF
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 03:49:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07F8CC433D2;
	Thu, 25 May 2023 03:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684986549;
	bh=dskzsDioASS1zNdKp6eTWbZDGoxJSJfHBtE+3LFm0XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJj4tEtSGpuje7yVkXRBfV7fdvUJxhkocIEj5FiOLbkzgbXLFHp5WA3k5bxcx/BSF
	 jxbsL4pR7gVtI04jTCjuP8KjxerIHtqzdGF2tsxdDTShDUNnQKcMxPbx+10GtBLUDg
	 Rq7jE71qo/g2AQQ+NCRdgIL/k5h9h3Ljgr3Arhf9Py1Ide7WqKlKaJxX3OqQxBEeQB
	 t+EfYAcUuhvkdec+OiHSWuac4CFXRFEMSYRNDPHau9p/QLSKI+uUQAPtxKnz5TsbY0
	 S/J/PZAMbtbXaY7BIWsGhYsc7wKRiah0h3d9ogVYL7Q1ltEJLCgcARZZSD63A/z36N
	 fj/Ue8sbGT4Gg==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>
Subject: [net 07/17] net/mlx5: fw_tracer, Fix event handling
Date: Wed, 24 May 2023 20:48:37 -0700
Message-Id: <20230525034847.99268-8-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230525034847.99268-1-saeed@kernel.org>
References: <20230525034847.99268-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

mlx5 driver needs to parse traces with event_id inside the range of
first_string_trace and num_string_trace. However, mlx5 is parsing all
events with event_id >= first_string_trace.

Fix it by checking for the correct range.

Fixes: c71ad41ccb0c ("net/mlx5: FW tracer, events handling")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index f40497823e65..7c0f2adbea00 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -490,7 +490,7 @@ static void poll_trace(struct mlx5_fw_tracer *tracer,
 				(u64)timestamp_low;
 		break;
 	default:
-		if (tracer_event->event_id >= tracer->str_db.first_string_trace ||
+		if (tracer_event->event_id >= tracer->str_db.first_string_trace &&
 		    tracer_event->event_id <= tracer->str_db.first_string_trace +
 					      tracer->str_db.num_string_trace) {
 			tracer_event->type = TRACER_EVENT_TYPE_STRING;
-- 
2.40.1


