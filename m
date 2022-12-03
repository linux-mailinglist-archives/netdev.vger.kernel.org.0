Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4331A64195D
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiLCWNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiLCWNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:13:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F021C434
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 14:13:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 381C560B9B
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 22:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85203C4347C;
        Sat,  3 Dec 2022 22:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670105624;
        bh=qjRFLGZwn+0rFVQDM+NVB8pJHkNEIoi/YIwWyIUDVTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rA17limxZ7ZjHnDdp25ISIDaKpLCOqLqEpJRiw1w/Zcr6jhRr/T+ZqE8ibhontzno
         5kyoSIKOIwSXn5OrT6QIdUgs7MXftB3pr4XgZLKQDI/vPyzIWTMMIVScCxmaWcC8GD
         XvRed3OtRDcs5ZpnPg90JrNzIpmpgc+mSlDppBMzaDo/sNp12zr+y2djs7Tlrd+U6S
         mpYV/oi9HWnF7/h6B9srtLAESZhKGWunuNdWng6cPk/EbypbVRuzdRDD9JrdQ/J3LX
         FAai5YJMVSNd2QiXecx+57FmTE3ONCBVR10JvmeoRmpvgZekX+3Ql79ZsMSfVXrqgw
         EcLf0yRYpU3Cg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>, Mark Bloch <mbloch@nvidia.com>
Subject: [net-next 02/15] net/mlx5: fs, assert null dest pointer when dest_num is 0
Date:   Sat,  3 Dec 2022 14:13:24 -0800
Message-Id: <20221203221337.29267-3-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221203221337.29267-1-saeed@kernel.org>
References: <20221203221337.29267-1-saeed@kernel.org>
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

From: Oz Shlomo <ozsh@nvidia.com>

Currently create_flow_handle() assumes a null dest pointer when there
are no destinations.
This might not be the case as the caller may pass an allocated dest
array while setting the dest_num parameter to 0.

Assert null dest array for flow rules that have no destinations (e.g. drop
rule).

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index d53749248fa0..d53190f22871 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -1962,6 +1962,9 @@ _mlx5_add_flow_rules(struct mlx5_flow_table *ft,
 	if (flow_act->fg && ft->autogroup.active)
 		return ERR_PTR(-EINVAL);
 
+	if (dest && dest_num <= 0)
+		return ERR_PTR(-EINVAL);
+
 	for (i = 0; i < dest_num; i++) {
 		if (!dest_is_valid(&dest[i], flow_act, ft))
 			return ERR_PTR(-EINVAL);
-- 
2.38.1

