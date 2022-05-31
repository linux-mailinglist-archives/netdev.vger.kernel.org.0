Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1BAB539847
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 22:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347792AbiEaUzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 16:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245656AbiEaUzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 16:55:13 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED929D04A
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 13:55:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0AA10CE1801
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 20:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320CFC385A9;
        Tue, 31 May 2022 20:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654030508;
        bh=+oesD9fpT/gTTGjffXg+Y0Lt9uhlK0Try960NqmUnic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jV+uoXK97vxeBUSafKhKmq2xj6yZN/CBkSnWT2ZO2JH8bXHMXzDhQzchHvWQpRqMg
         WXVxX4WxmIMsjuZoROYT3KzpALJIobptKW2EU4NW99RFbKSXxuTgKD8I39qI9jOXDR
         m7WD1Rgq65d88Qz3j9TqMJu0yTT1mfN3e4j6AXM506pa1uQGApuwt3GAaLGrEkBpex
         NML9OjbElLMdTPfg7jwxhYCYKqpJMszreILUmPrVYIHcOqpa08hTYToUg/EjWUzhlv
         /1xIoDUOots6h+b39HT7MdQE7A5B/kEYtYrQUy48TRcBQ1fs0Vtt/F7HL1vZPUt2Er
         hMm1fzCeBEBpA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Changcheng Liu <jerrliu@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net 5/7] net/mlx5: correct ECE offset in query qp output
Date:   Tue, 31 May 2022 13:54:45 -0700
Message-Id: <20220531205447.99236-6-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220531205447.99236-1-saeed@kernel.org>
References: <20220531205447.99236-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Changcheng Liu <jerrliu@nvidia.com>

ECE field should be after opt_param_mask in query qp output.

Fixes: 6b646a7e4af6 ("net/mlx5: Add ability to read and write ECE options")
Signed-off-by: Changcheng Liu <jerrliu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 78b3d3465dd7..2cd7d611e7b3 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -5176,12 +5176,11 @@ struct mlx5_ifc_query_qp_out_bits {
 
 	u8         syndrome[0x20];
 
-	u8         reserved_at_40[0x20];
-	u8         ece[0x20];
+	u8         reserved_at_40[0x40];
 
 	u8         opt_param_mask[0x20];
 
-	u8         reserved_at_a0[0x20];
+	u8         ece[0x20];
 
 	struct mlx5_ifc_qpc_bits qpc;
 
-- 
2.36.1

