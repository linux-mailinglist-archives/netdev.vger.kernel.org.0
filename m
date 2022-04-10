Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6FB4FACDE
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 10:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbiDJIci (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 04:32:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235825AbiDJIcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 04:32:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F0515A167;
        Sun, 10 Apr 2022 01:29:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 97986B80B00;
        Sun, 10 Apr 2022 08:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E041DC385A8;
        Sun, 10 Apr 2022 08:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649579383;
        bh=LcNcvXY1H0V/a6HPGqdU+Q0J3NwQRZtCm5/SuuFPHF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THxYrhk3PBsS4KuXHxcYHnbb9T4tZHumHkmx96GhuOXN+R5JjKIIAs504AeI7t6HT
         x8PWUgd0xwIcvYFYq+268IH0Wc73SR7p1ofVZxPCAFMF8PN8Lx9R9q43jbynhcWb7o
         Sbo3VFd8QU8JP3SjGZhaGHnQVk7PXwpFe68EL++pLj0wzavS1wd4t8aIZ7sJI9b3el
         AtqTSZt2clXLeYwyqRpVysoQAY4uqptoLY5o2i3k9F3NM6xPOWs0MJlXP7I/D4Oc/f
         FkdAOhMLOxAeiUGlT3gdk182Cfe3w//E1+po6bSCfm5zaNNBrwLhwO8li/RCdQTRF+
         f1nkgnxJSQthg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH mlx5-next 16/17] net/mlx5: Allow future addition of IPsec object modifiers
Date:   Sun, 10 Apr 2022 11:28:34 +0300
Message-Id: <84f5b82c38733623a3962df6627c787f03a33eb4.1649578827.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649578827.git.leonro@nvidia.com>
References: <cover.1649578827.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Currently, all released FW versions support only two IPsec object
modifiers, and modify_field_select get and set same value with
proper bits.

However, it is not future compatible, as new FW can have more
modifiers and "default" will cause to overwrite not-changed fields.

Fix it by setting explicitly fields that need to be overwritten.

Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c   | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index 2f32d53761b1..e079f86fae33 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -180,6 +180,9 @@ static int mlx5_modify_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry,
 		return -EOPNOTSUPP;
 
 	obj = MLX5_ADDR_OF(modify_ipsec_obj_in, in, ipsec_object);
+	MLX5_SET64(ipsec_obj, obj, modify_field_select,
+		   MLX5_MODIFY_IPSEC_BITMASK_ESN_OVERLAP |
+			   MLX5_MODIFY_IPSEC_BITMASK_ESN_MSB);
 	MLX5_SET(ipsec_obj, obj, esn_msb, attrs->esn);
 	if (attrs->flags & MLX5_ACCEL_ESP_FLAGS_ESN_STATE_OVERLAP)
 		MLX5_SET(ipsec_obj, obj, esn_overlap, 1);
-- 
2.35.1

