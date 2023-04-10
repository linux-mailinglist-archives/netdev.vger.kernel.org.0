Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0B66DC37A
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 08:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjDJGT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 02:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDJGTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 02:19:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F8740D5
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 23:19:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0478B60FE5
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 06:19:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0D33C433EF;
        Mon, 10 Apr 2023 06:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681107562;
        bh=GFD201yhDvBCKljVnihyJxUpkTCDHL0ZaglX2oSd8Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KqubDaHMUKULBtARLMxE158aFB7MuqtT5O8ZV3OJ3lxQJc7+eTh6eUTg/1YbzdSlZ
         2zjzbGxvsQheyCGAFo8IDKFIjLRrc4pQFd2zoOTBuGzJp0eqnZ8ZvxLyk3YLCupSdH
         aIu337fanSPuPGpvwHSTmpYIavcsGNLcvo0qCxxX49SOH6s3iRMnzOZfIDK5dAC5yN
         ehqMyVBKxnJp4sYTG/8eCqniKFOdhIcMFuSxbm/KNXGCpGY2OKf1kGA7vTjiBWV7rW
         NucvjmeZ0al/kKgkeDCGGZzb+jT7mOtqqEbmEf+3MMGN/YKP3Ns7wLyg9yCMcQf3Yv
         pmNZm2hr3yBCQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next 01/10] net/mlx5e: Add IPsec packet offload tunnel bits
Date:   Mon, 10 Apr 2023 09:19:03 +0300
Message-Id: <08b748bc72bc0256fee7c2280245ac2ab4e874c3.1681106636.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681106636.git.leonro@nvidia.com>
References: <cover.1681106636.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Extend packet reformat types and flow table capabilities with
IPsec packet offload tunnel bits.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/linux/mlx5/mlx5_ifc.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index e47d6c58da35..3e899844e84c 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -456,9 +456,11 @@ struct mlx5_ifc_flow_table_prop_layout_bits {
 	u8         max_ft_level[0x8];
 
 	u8         reformat_add_esp_trasport[0x1];
-	u8         reserved_at_41[0x2];
+	u8         reformat_l2_to_l3_esp_tunnel[0x1];
+	u8         reserved_at_42[0x1];
 	u8         reformat_del_esp_trasport[0x1];
-	u8         reserved_at_44[0x2];
+	u8         reformat_l3_esp_tunnel_to_l2[0x1];
+	u8         reserved_at_45[0x1];
 	u8         execute_aso[0x1];
 	u8         reserved_at_47[0x19];
 
@@ -6599,7 +6601,9 @@ enum mlx5_reformat_ctx_type {
 	MLX5_REFORMAT_TYPE_L3_TUNNEL_TO_L2 = 0x3,
 	MLX5_REFORMAT_TYPE_L2_TO_L3_TUNNEL = 0x4,
 	MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV4 = 0x5,
+	MLX5_REFORMAT_TYPE_L2_TO_L3_ESP_TUNNEL = 0x6,
 	MLX5_REFORMAT_TYPE_DEL_ESP_TRANSPORT = 0x8,
+	MLX5_REFORMAT_TYPE_L3_ESP_TUNNEL_TO_L2 = 0x9,
 	MLX5_REFORMAT_TYPE_ADD_ESP_TRANSPORT_OVER_IPV6 = 0xb,
 	MLX5_REFORMAT_TYPE_INSERT_HDR = 0xf,
 	MLX5_REFORMAT_TYPE_REMOVE_HDR = 0x10,
-- 
2.39.2

