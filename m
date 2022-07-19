Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935E757A84A
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 22:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239732AbiGSUfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 16:35:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239758AbiGSUft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 16:35:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF35E481EA
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 13:35:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 35CA061995
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 20:35:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 620F1C341C6;
        Tue, 19 Jul 2022 20:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658262944;
        bh=D49eyNCrpbX5JrJKggHX+6Nc8eh1Q6IJt/IQlRjx31s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZfEkq9XPNHqLsFv17HyCNkQiDo5tpOMpD2pOZFjhuU89iyNohOvZPbpqWHjJxnSV
         5g5y7Sw1TzpirmRxZM0uyxNuPIIm0T57rzyCKQ+Pr/2cVcq947d9NQ/8ho+589GIba
         GreFrmu4TzUvHZgWCWptCku6MouwwSwKFgZUrd06yWG7O7pHpjEk6nTtKJlS4oxKLQ
         tbB6KWgOd9ERNkXEd3VnUuHVnl5qI4pcEJv79VRr59VmJtHeJvRTIYU9cbao/1HMkF
         HIqwMlIkwndxeGiuL0Riub7vQdw3ysYBRqlW5qxdY+4tYuegJasnLWUiTUGRG4chS+
         HsCvOaYiUkhIQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [net-next V2 11/13] net/mlx5: Expose ts_cqe_metadata_size2wqe_counter
Date:   Tue, 19 Jul 2022 13:35:27 -0700
Message-Id: <20220719203529.51151-12-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220719203529.51151-1-saeed@kernel.org>
References: <20220719203529.51151-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Add capability field which indicates the mask for wqe_counter which
connects between loopback CQE and the original WQE. With this connection
the driver can identify lost of the loopback CQE and reply PTP
synchronization with timestamp given in the original CQE.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 254cc22f5eec..51b4e71017ee 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1833,7 +1833,11 @@ struct mlx5_ifc_cmd_hca_cap_2_bits {
 	u8	   sw_vhca_id[0xe];
 	u8	   reserved_at_230[0x10];
 
-	u8	   reserved_at_240[0x5c0];
+	u8	   reserved_at_240[0xb];
+	u8	   ts_cqe_metadata_size2wqe_counter[0x5];
+	u8	   reserved_at_250[0x10];
+
+	u8	   reserved_at_260[0x5a0];
 };
 
 enum mlx5_ifc_flow_destination_type {
-- 
2.36.1

