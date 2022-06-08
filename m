Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EA1543D47
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 22:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbiFHUFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 16:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234918AbiFHUF2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 16:05:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E822B374278;
        Wed,  8 Jun 2022 13:05:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 792F261C5E;
        Wed,  8 Jun 2022 20:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BC2C34116;
        Wed,  8 Jun 2022 20:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654718726;
        bh=qSZ7c0PaCVngExyoBTV64R514xcCKTUwvjddtm4ngjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j+iW84UzSi9cA25QJe/Umv+WIF02rqQuRIjc/Sl5LmM5622ZL+QrVVP9/e7A/4GvE
         WjEclXaCrMW2HvzeeB6kxOKya/kQ2T3QIxMb+CNMoSVcNDp8LWq4tPOilguLqaOAvI
         f4wabkYQrmcS+gJHc0V4NuGdjXLymSxLGqTFXt7n7SvjrgpB5kiUytl38dREb0enxL
         BK0eaWR6GFHyIJSo+CfVGQ27Hritub55Y12pB5CXlpAFWtgiv1aSiquagRg5NMIYrA
         mLNmy2v9I6MhZsgOdC6nmVq89r3sdFz6EtFJ0Q5jVOL8QU8PWDaf6k3RekEIjdOBXg
         MxvufioEmEobw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>
Subject: [PATCH mlx5-next 2/6] net/mlx5: Add HW definitions of vport debug counters
Date:   Wed,  8 Jun 2022 13:04:48 -0700
Message-Id: <20220608200452.43880-3-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220608200452.43880-1-saeed@kernel.org>
References: <20220608200452.43880-1-saeed@kernel.org>
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

From: Saeed Mahameed <saeedm@nvidia.com>

total_q_under_processor_handle - number of queues in error state due to an
async error or errored command.

send_queue_priority_update_flow - number of QP/SQ priority/SL update
events.

cq_overrun - number of times CQ entered an error state due to an
overflow.

async_eq_overrun -number of time an EQ mapped to async events was
overrun.

comp_eq_overrun - number of time an EQ mapped to completion events was
overrun.

quota_exceeded_command - number of commands issued and failed due to quota
exceeded.

invalid_command - number of commands issued and failed dues to any reason
other than quota exceeded.

Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index a81f86620a10..585d246cef3b 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1438,7 +1438,8 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 
 	u8         reserved_at_120[0xa];
 	u8         log_max_ra_req_dc[0x6];
-	u8         reserved_at_130[0xa];
+	u8         reserved_at_130[0x9];
+	u8         vnic_env_cq_overrun[0x1];
 	u8         log_max_ra_res_dc[0x6];
 
 	u8         reserved_at_140[0x5];
@@ -1633,7 +1634,11 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         nic_receive_steering_discard[0x1];
 	u8         receive_discard_vport_down[0x1];
 	u8         transmit_discard_vport_down[0x1];
-	u8         reserved_at_343[0x5];
+	u8         eq_overrun_count[0x1];
+	u8         reserved_at_344[0x1];
+	u8         invalid_command_count[0x1];
+	u8         quota_exceeded_count[0x1];
+	u8         reserved_at_347[0x1];
 	u8         log_max_flow_counter_bulk[0x8];
 	u8         max_flow_counter_15_0[0x10];
 
@@ -3438,11 +3443,21 @@ struct mlx5_ifc_vnic_diagnostic_statistics_bits {
 
 	u8         transmit_discard_vport_down[0x40];
 
-	u8         reserved_at_140[0xa0];
+	u8         async_eq_overrun[0x20];
+
+	u8         comp_eq_overrun[0x20];
+
+	u8         reserved_at_180[0x20];
+
+	u8         invalid_command[0x20];
+
+	u8         quota_exceeded_command[0x20];
 
 	u8         internal_rq_out_of_buffer[0x20];
 
-	u8         reserved_at_200[0xe00];
+	u8         cq_overrun[0x20];
+
+	u8         reserved_at_220[0xde0];
 };
 
 struct mlx5_ifc_traffic_counter_bits {
-- 
2.36.1

