Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D5346C6483
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 11:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjCWKOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 06:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbjCWKOP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 06:14:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE14C19C49
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 03:14:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B0632CE2123
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 10:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66209C433D2;
        Thu, 23 Mar 2023 10:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679566446;
        bh=Fmmv6XOvnnnXdnxatsEAEv+vY0M1SMELUjcXrHsyQoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BK9HJYN7YKcncfMJmWDmLACVaxFx2pKdOumZoNPd/hx7ARRfFTBNAGLAd/2GET0T2
         K0Axs3Lhd5kuel/IXthGiCEorIgO1Us1NfbhnUnYj1t/1x+sv0Vospd2GhVY2OIW+N
         TkbuO30jLYCQCpra9lpqjPOHbk+lYQA2/obQ0XxpmeHUD4+FGV4bpvutukpvs2ZZc9
         0RUkpsyIMYwR0++xIT4iTiN7AdJHSqHQGoFuldVaM67UNaIN39bLTJiWF4YoKMjrOr
         ea329y62usPEvDVQgGPrQqpdR8mp4jXJqcj6N/kBLqudn2C0ddWwmN5fFMUkNKX+I3
         OxbsdSKb0gIsA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Patrisious Haddad <phaddad@nvidia.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next v1 1/2] net/mlx5: Introduce other vport query for Q-counters
Date:   Thu, 23 Mar 2023 12:13:51 +0200
Message-Id: <75c73a4a0e60f18c37b35a4a11ca2e2415e4a6f3.1679566038.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1679566038.git.leon@kernel.org>
References: <cover.1679566038.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patrisious Haddad <phaddad@nvidia.com>

These new fields in QUERY_Q_COUNTER command allow us to access
another vport counters during the query command, which is specially
useful to query representor vports.

In addition also add the required caps to check if this capability
is actually supported.

Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 62039b147432..e4306cd87cd7 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1729,7 +1729,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         log_max_transport_domain[0x5];
 	u8         reserved_at_328[0x3];
 	u8         log_max_pd[0x5];
-	u8         reserved_at_330[0xb];
+	u8         reserved_at_330[0x9];
+	u8         q_counter_aggregation[0x1];
+	u8         q_counter_other_vport[0x1];
 	u8         log_max_xrcd[0x5];
 
 	u8         nic_receive_steering_discard[0x1];
@@ -5603,10 +5605,15 @@ struct mlx5_ifc_query_q_counter_in_bits {
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
 
-	u8         reserved_at_40[0x80];
+	u8         other_vport[0x1];
+	u8         reserved_at_41[0xf];
+	u8         vport_number[0x10];
+
+	u8         reserved_at_60[0x60];
 
 	u8         clear[0x1];
-	u8         reserved_at_c1[0x1f];
+	u8         aggregate[0x1];
+	u8         reserved_at_c2[0x1e];
 
 	u8         reserved_at_e0[0x18];
 	u8         counter_set_id[0x8];
-- 
2.39.2

