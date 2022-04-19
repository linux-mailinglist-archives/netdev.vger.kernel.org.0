Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03B9E50688B
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 12:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350589AbiDSKSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 06:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350600AbiDSKRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 06:17:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7EA15FD7
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 03:15:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2282AB81657
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42430C385A5;
        Tue, 19 Apr 2022 10:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650363306;
        bh=X5Eh2fdyAXvlFu6/ehzm3gEofGx33ygKtd4PkYP5ZZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LPojlG5BN5zVUlOBpZQYZq/EkB+Mp/Yt8I7ITy/aUGUHqMcTQJciiD4E4fN7KrA2Y
         OzizZHvCc20F8bUBoCOTYwbILs3ONuf5xY0MO+QlisI2oY28eduGGHsa0KLk/fLjCD
         e5tVR98dI5TZoj06h96GBWSLO5+8xJPsZNAbNp4bGQ/nrwrQaFO+xem/Jq6MqEus2i
         /F++WCOYY93ZfCIgp4YV4XKDg5dcy/BhkL7tAizAVWYpYpxwDEogaDpRH79+6izv4e
         l4Iu3aE7rMyTWRjRnD3IJBGU3seq9MCNz7JMTfoL9PADPSxK2cin/acESjSqFocQIV
         mpTD8LGRqRlGA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH net-next v1 16/17] net/mlx5: Allow future addition of IPsec object modifiers
Date:   Tue, 19 Apr 2022 13:13:52 +0300
Message-Id: <42e816e8fbd9cc0fff772c726c546acf92fc60f9.1650363043.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1650363043.git.leonro@nvidia.com>
References: <cover.1650363043.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

Currently, all released FW versions support only two IPsec object
modifiers, and modify_field_select get and set same value with
proper bits.

However, it is not future compatible, as new FW can have more
modifiers and "default" will cause to overwrite not-changed fields.

Fix it by setting explicitly fields that need to be overwritten.

Fixes: 7ed92f97a1ad ("net/mlx5e: IPsec: Add Connect-X IPsec ESN update offload support")
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c   | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
index b13e152fe9fc..792724ce7336 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_offload.c
@@ -179,6 +179,9 @@ static int mlx5_modify_ipsec_obj(struct mlx5e_ipsec_sa_entry *sa_entry,
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

