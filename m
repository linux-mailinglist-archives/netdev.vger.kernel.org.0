Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52BED6BD12E
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 14:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjCPNpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 09:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbjCPNpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 09:45:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B188ADC02;
        Thu, 16 Mar 2023 06:45:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D72EF62033;
        Thu, 16 Mar 2023 13:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45DDC433EF;
        Thu, 16 Mar 2023 13:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678974331;
        bh=WFQtdL4V2S1yAHQBzT78b/okR1+SYRcNfEUPzFVVhgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XYdD83c6Qpw4YiNIUurVjOlI9g7kqTqo1G8ld8bACsOrPyzjLnA2rmkOSwlVndVxw
         FPcC0Ghdqb3vTHnQfhTKxmKUrAE5vmRfX4nRfzGBOlMLqFPCcmG9SkRYGF/dJQOdmJ
         FL5LJysVrOHyS0M6tYkdQmobdN04GD1YXiBD6+ku5v5s3eJQox894jBiKH+YqbynTQ
         gSuv5OqTAUbQI5aPjy1M/C4ZsFJr25F8OdlldsoObMswo4mGkT7x1BtQZO7RNDABeZ
         O2iczaLMP8lwKMHsa7J4+hytXGEwfzhUKTXjFS50lL8YPmManS22D1z5to/cFDJhn7
         CKmxtpn4DMVJA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Patrisious Haddad <phaddad@nvidia.com>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH mlx5-next 1/2] net/mlx5: Introduce other vport query for Q-counters
Date:   Thu, 16 Mar 2023 15:45:20 +0200
Message-Id: <fd7bd8bf9fd4e86f198807581fadf4045a63bc03.1678974109.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678974109.git.leon@kernel.org>
References: <cover.1678974109.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 66d76e97a087..15a850f52ef2 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1726,7 +1726,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         log_max_transport_domain[0x5];
 	u8         reserved_at_328[0x3];
 	u8         log_max_pd[0x5];
-	u8         reserved_at_330[0xb];
+	u8         reserved_at_330[0x9];
+	u8         q_counter_aggregation[0x1];
+	u8         q_counter_other_vport[0x1];
 	u8         log_max_xrcd[0x5];
 
 	u8         nic_receive_steering_discard[0x1];
@@ -5599,10 +5601,15 @@ struct mlx5_ifc_query_q_counter_in_bits {
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

