Return-Path: <netdev+bounces-9763-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 980B872A7A2
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:43:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E31141C21129
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 01:43:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E95491FAB;
	Sat, 10 Jun 2023 01:43:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A291876
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 01:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5409C4339C;
	Sat, 10 Jun 2023 01:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686361387;
	bh=TJTJ/KWfcXL2DF6hggeAD5/t44VMoCRfFeFThHsm8vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yq2vwrXnRS2oCeF3YztydkMSKN88Rs6dT3akDsQovupXkwpTU6cY3SB7FcZK42k2t
	 n+2pjIi9MCXG9vOeq6JiOA4ffPQhTZtbEk4AneX9YDcatcQZTsXSFPJj0wF2bcJjR0
	 4ns7Ql/WAWdHJHYvsn//C4+8xggkQp/tc7XZMEQZ/COYWh9YsyVIXnpNt42gdqHwh0
	 ECz0ZUpDtza0ycCtXiu90vFJYy/ppcyj405XbO6yJMk3sOghtUPIIOdbdidK5ra6Yp
	 mdg5eXU/lyvOOk+DLCyfJNvGocJdMTypNBw8qGOk610IWAQgQvUaCYsM59JhI7iZf6
	 8zrrsS3e2LL8w==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Daniel Jurgens <danielj@nvidia.com>,
	Bodong Wang <bodong@nvidia.com>,
	William Tu <witu@nvidia.com>
Subject: [net-next 02/15] net/mlx5: mlx5_ifc updates for embedded CPU SRIOV
Date: Fri,  9 Jun 2023 18:42:41 -0700
Message-Id: <20230610014254.343576-3-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230610014254.343576-1-saeed@kernel.org>
References: <20230610014254.343576-1-saeed@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Daniel Jurgens <danielj@nvidia.com>

Add ec_vf_vport_base to HCA Capabilities 2. This indicates the base vport
of embedded CPU virtual functions that are connected to the eswitch.

Add ec_vf_function to query/set_hca_caps. If set this indicates
accessing a virtual function on the embedded CPU by function ID. This
should only be used with other_function set to 1.

Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: Bodong Wang <bodong@nvidia.com>
Reviewed-by: William Tu <witu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index af3a92ad2e6b..1f4f62cb9f34 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1992,7 +1992,10 @@ struct mlx5_ifc_cmd_hca_cap_2_bits {
 	u8	   ts_cqe_metadata_size2wqe_counter[0x5];
 	u8	   reserved_at_250[0x10];
 
-	u8	   reserved_at_260[0x5a0];
+	u8	   reserved_at_260[0x120];
+	u8	   reserved_at_380[0x10];
+	u8	   ec_vf_vport_base[0x10];
+	u8	   reserved_at_3a0[0x460];
 };
 
 enum mlx5_ifc_flow_destination_type {
@@ -4805,7 +4808,8 @@ struct mlx5_ifc_set_hca_cap_in_bits {
 	u8         op_mod[0x10];
 
 	u8         other_function[0x1];
-	u8         reserved_at_41[0xf];
+	u8         ec_vf_function[0x1];
+	u8         reserved_at_42[0xe];
 	u8         function_id[0x10];
 
 	u8         reserved_at_60[0x20];
@@ -5956,7 +5960,8 @@ struct mlx5_ifc_query_hca_cap_in_bits {
 	u8         op_mod[0x10];
 
 	u8         other_function[0x1];
-	u8         reserved_at_41[0xf];
+	u8         ec_vf_function[0x1];
+	u8         reserved_at_42[0xe];
 	u8         function_id[0x10];
 
 	u8         reserved_at_60[0x20];
-- 
2.40.1


