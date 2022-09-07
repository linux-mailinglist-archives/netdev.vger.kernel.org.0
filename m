Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCC8A5B107D
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 01:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiIGXhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 19:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbiIGXhP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 19:37:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7527C1CF;
        Wed,  7 Sep 2022 16:37:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6A008CE1E05;
        Wed,  7 Sep 2022 23:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95474C433D7;
        Wed,  7 Sep 2022 23:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662593830;
        bh=Xy/P04BxUZSe9boIeJFProSOXcQrLF/gu7yicfUSKlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbqHrQB8DN1dSafiw5lAUFS8i+GnFOIpjHqntRGihFWiDBlgHWhceYVLKYlrpan16
         /RMnrQdlbLDKtoU5xAneeblEW6q9xrRIX3LDrrEn1lpBJRZBfDQBRGyZ+rcdzmBE9N
         Zxo0Zky33YXNTPi6UfDl0bB6vBE5WMYShKS3NaorTZO4XmUV3C1EzWdkmICo3+SYVH
         HNa+SGxzVLw6M5bybRmaYem79lVQXrq7ZrWGtKbp8+5okAq6RnpSL8rqyzTokQAaS4
         1NxYNsRdNhJ2t0Losu1IACdkbIb4qMcS9yb9+GqfG7BR4KOLjCPdq+iZ87f3i541Yy
         BA3GP7diRfu1A==
From:   Saeed Mahameed <saeed@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>
Subject: [PATCH mlx5-next 01/14] net/mlx5: Expose NPPS related registers
Date:   Wed,  7 Sep 2022 16:36:23 -0700
Message-Id: <20220907233636.388475-2-saeed@kernel.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220907233636.388475-1-saeed@kernel.org>
References: <20220907233636.388475-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add management capability bits indicating firmware may support N pulses
per second. Add corresponding fields in MTPPS register.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 4acd5610e96b..e2f71c8d9bd7 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -9789,7 +9789,9 @@ struct mlx5_ifc_pcam_reg_bits {
 struct mlx5_ifc_mcam_enhanced_features_bits {
 	u8         reserved_at_0[0x5d];
 	u8         mcia_32dwords[0x1];
-	u8         reserved_at_5e[0xc];
+	u8         out_pulse_duration_ns[0x1];
+	u8         npps_period[0x1];
+	u8         reserved_at_60[0xa];
 	u8         reset_state[0x1];
 	u8         ptpcyc2realtime_modify[0x1];
 	u8         reserved_at_6c[0x2];
@@ -10289,7 +10291,12 @@ struct mlx5_ifc_mtpps_reg_bits {
 	u8         reserved_at_18[0x4];
 	u8         cap_max_num_of_pps_out_pins[0x4];
 
-	u8         reserved_at_20[0x24];
+	u8         reserved_at_20[0x13];
+	u8         cap_log_min_npps_period[0x5];
+	u8         reserved_at_38[0x3];
+	u8         cap_log_min_out_pulse_duration_ns[0x5];
+
+	u8         reserved_at_40[0x4];
 	u8         cap_pin_3_mode[0x4];
 	u8         reserved_at_48[0x4];
 	u8         cap_pin_2_mode[0x4];
@@ -10308,7 +10315,9 @@ struct mlx5_ifc_mtpps_reg_bits {
 	u8         cap_pin_4_mode[0x4];
 
 	u8         field_select[0x20];
-	u8         reserved_at_a0[0x60];
+	u8         reserved_at_a0[0x20];
+
+	u8         npps_period[0x40];
 
 	u8         enable[0x1];
 	u8         reserved_at_101[0xb];
@@ -10317,7 +10326,8 @@ struct mlx5_ifc_mtpps_reg_bits {
 	u8         pin_mode[0x4];
 	u8         pin[0x8];
 
-	u8         reserved_at_120[0x20];
+	u8         reserved_at_120[0x2];
+	u8         out_pulse_duration_ns[0x1e];
 
 	u8         time_stamp[0x40];
 
-- 
2.37.2

