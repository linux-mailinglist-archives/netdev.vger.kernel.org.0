Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 064C46B8AC1
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 06:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjCNFnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 01:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbjCNFnT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 01:43:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D3C848DD
        for <netdev@vger.kernel.org>; Mon, 13 Mar 2023 22:43:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 13CF9B8189D
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6370C433EF;
        Tue, 14 Mar 2023 05:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678772578;
        bh=XZO4imjCX26wnbFxLVdSSxf7Dys5z8KsTMrfLInxPao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eNnA8RzgrnGhkR7u9PsUlhwuwnppR5ZWjBxxYXO3wa4FRcgPNR+7MNOGTGlr1XR+K
         WPeImZakhLhVZr+fjgQFB0NWE44nUoDUx809E+MfvF3NQ4H/AbdQSsfkchRRAwsjFh
         Xrusqjxa+j4t5s8U649uIeKZws5M2Sa+ohw6qkIT07gD5UyprsiQAM/IKj4GNj4QiY
         GTwwP1iyAW8P207YAz19lUivP8ap4t4VXfWSCGrcCVaaPsE5st8zLxO0QCWvCYJjzT
         +R30hbVCW92Pq8wj7FhWu8Db4VpCSln04deeOKuAm/4zWpTXtshQojAOKwO5W5FzQK
         Be8pKLblgQ0zg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Dickman <maord@nvidia.com>, Roi Dayan <roid@nvidia.com>
Subject: [net-next 15/15] net/mlx5e: Enable TC offload for egress MACVLAN over bond
Date:   Mon, 13 Mar 2023 22:42:34 -0700
Message-Id: <20230314054234.267365-16-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230314054234.267365-1-saeed@kernel.org>
References: <20230314054234.267365-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maor Dickman <maord@nvidia.com>

Support offloading of TC rules that mirror/redirect egress traffic to a
MACVLAN device, which is attached to bond device which master mlx5 devices.

Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
index 07cc65596f89..291193f7120d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/act/mirred.c
@@ -234,6 +234,9 @@ parse_mirred(struct mlx5e_tc_act_parse_state *parse_state,
 	if (mlx5_lag_mpesw_do_mirred(priv->mdev, out_dev, extack))
 		return -EOPNOTSUPP;
 
+	if (netif_is_macvlan(out_dev))
+		out_dev = macvlan_dev_real_dev(out_dev);
+
 	out_dev = get_fdb_out_dev(uplink_dev, out_dev);
 	if (!out_dev)
 		return -ENODEV;
@@ -250,9 +253,6 @@ parse_mirred(struct mlx5e_tc_act_parse_state *parse_state,
 			return err;
 	}
 
-	if (netif_is_macvlan(out_dev))
-		out_dev = macvlan_dev_real_dev(out_dev);
-
 	err = verify_uplink_forwarding(priv, attr, out_dev, extack);
 	if (err)
 		return err;
-- 
2.39.2

