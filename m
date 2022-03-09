Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEAD4D3C32
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 22:39:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238418AbiCIVjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 16:39:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238228AbiCIVjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 16:39:10 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B253C71C90
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 13:38:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D51C3CE2130
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0802EC340EE;
        Wed,  9 Mar 2022 21:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646861888;
        bh=1BhwWXLEgEDQ01Pm0RgJOjB6qwyh75ig3ZoTTpp1oeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wtzl+Aurvb5LTamuuP2FXl18KxC1kBlMUmrkbaqQ1rX+5IKTquncw/Gjq/QONnH3Z
         8j3elrDeBa1Rok/ZRvX4HKDshYiY0I3SYgII2io10ay2zQPTFa+k+Mqz8EuZg1G3y1
         1lozLFElgKxvY7L79NuFUYUC1i0a7yiB+ATNgYm96A6FccclTy/0h5CTlJ+K0N+hSS
         72ySSH7/Qq4hJ9Ock141FrnmEinpm1VNhYxdZLofpIZoqkv00cttByZAqeRL1W1FRC
         /Khzg1/Y0kOEff0DjyNsDq76rd9//oOph6ZVmkYSnGU9wgO9IRkK89oH1pEkbAJsjF
         Uy/M7IXd+hI7g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Moshe Shemesh <moshe@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 06/16] net/mlx5: Change release_all_pages cap bit location
Date:   Wed,  9 Mar 2022 13:37:45 -0800
Message-Id: <20220309213755.610202-7-saeed@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220309213755.610202-1-saeed@kernel.org>
References: <20220309213755.610202-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@nvidia.com>

mlx5 FW has changed release_all_pages cap bit by one bit offset to
reflect a fix in the FW flow for release_all_pages. The driver should
use the new bit to ensure it calls release_all_pages only if the FW fix
is there.

Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index ea65131835ab..69985e4d8dfe 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -1419,8 +1419,9 @@ struct mlx5_ifc_cmd_hca_cap_bits {
 	u8         reserved_at_130[0xa];
 	u8         log_max_ra_res_dc[0x6];
 
-	u8         reserved_at_140[0x6];
+	u8         reserved_at_140[0x5];
 	u8         release_all_pages[0x1];
+	u8         must_not_use[0x1];
 	u8         reserved_at_147[0x2];
 	u8         roce_accl[0x1];
 	u8         log_max_ra_req_qp[0x6];
-- 
2.35.1

