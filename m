Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6795ECEB5
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 22:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233196AbiI0Ug7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 16:36:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbiI0Ugm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 16:36:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF97380483
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 13:36:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EB61B81C16
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156F8C433C1;
        Tue, 27 Sep 2022 20:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664310999;
        bh=eSPKrGD6TaxW3GiJRzmnuH2mXny6w77OdIh4QuGa8B8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uGAc242B9D0AelV3hp0cglasMJ6RMvBZDZF7YDLaGmX/xgy10y6Uq86B3aGWcULLk
         gKf9+U/uHlIbG5ER71wCIY7KL6k9D1dvpJH/UojENj+75OpaJBWU7Z2EiUDayj8PQZ
         V2ekiAiLJDg2g/Whqtka+aPZhxTOmo+XSg4XMXvl6u00q+z45oqfwyexrl8rUYD4xB
         8QFDcHR1zpT+PnxbXZzhm9NtMXA89Pl7i5yQTegDmFAD6jtKLBu6MkMA4JPxoK+7iM
         J/BTrsCf6RxOFE9guO/xx+I1el3pIdHHb4dBDmjGBUjaRpiP1c1zhUpkBN7fjG0zOB
         1w1PFpUKzQCbw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>
Subject: [net-next 01/16] net/mlx5: Add the log_min_mkey_entity_size capability
Date:   Tue, 27 Sep 2022 13:35:56 -0700
Message-Id: <20220927203611.244301-2-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220927203611.244301-1-saeed@kernel.org>
References: <20220927203611.244301-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

Add the capability that will allow the driver to determine the minimal
MTT page size to be able to map the smallest possible pages in XSK. The
older firmwares that don't have this capability default to 12 (i.e.
4096-byte pages).

Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index bd577b99b146..28c07557bd99 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1856,7 +1856,13 @@ struct mlx5_ifc_cmd_hca_cap_2_bits {
 	u8	   max_reformat_remove_size[0x8];
 	u8	   max_reformat_remove_offset[0x8];
 
-	u8	   reserved_at_c0[0x160];
+	u8	   reserved_at_c0[0xe0];
+
+	u8	   reserved_at_1a0[0xb];
+	u8	   log_min_mkey_entity_size[0x5];
+	u8	   reserved_at_1b0[0x10];
+
+	u8	   reserved_at_1c0[0x60];
 
 	u8	   reserved_at_220[0x1];
 	u8	   sw_vhca_id_valid[0x1];
-- 
2.37.3

