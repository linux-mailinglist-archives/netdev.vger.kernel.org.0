Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94A4D64195B
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 23:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiLCWNq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 17:13:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiLCWNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 17:13:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 955BE1C90E
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 14:13:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1257C60C51
        for <netdev@vger.kernel.org>; Sat,  3 Dec 2022 22:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5EEC433D7;
        Sat,  3 Dec 2022 22:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670105623;
        bh=sB8UyDTZ4nOLSJNu/0Ny2Pf5gOmTE9g6Dcg27OlksyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hYx3P1zV5FTalalmS8EtxVEmE1AR4Zqp2ARI+bqmez/6qk0HzV22mkG3QMSDNwJKL
         DJz3/ZE2WnKpbtE+QQPbSX8vsUQQxA/orFOA0AS2BMXJcsY3lRCUI4qOU3x1UZYjuU
         wQb6+TNwj4LZhxq/INNYpV739o0QeITUtxdV2WqdA5RSSxZ46wcMLq0+ODZP2ZWKvo
         C1P1jyQdpAeLfBiyYOEU06816b0r19LOzEbQTRxoacMA63QEo72+tpjEVQgP5cDpqN
         Fl3q2xw5fPDwAytqPhJ7fqUgAr/Y1hSg542/gCY3X97ZV6qLavZoolFyNEauhYq2Rw
         i7kugYspdrqBQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [net-next 01/15] net/mlx5e: E-Switch, handle flow attribute with no destinations
Date:   Sat,  3 Dec 2022 14:13:23 -0800
Message-Id: <20221203221337.29267-2-saeed@kernel.org>
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

Rules with drop action are not required to have a destination.
Currently the destination list is allocated with the maximum number of
destinations and passed to the fs_core layer along with the actual number
of destinations.

Remove redundant passing of dest pointer when count of dest is 0.

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 9b6fbb19c22a..db1e282900aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -640,6 +640,11 @@ mlx5_eswitch_add_offloaded_rule(struct mlx5_eswitch *esw,
 		goto err_esw_get;
 	}
 
+	if (!i) {
+		kfree(dest);
+		dest = NULL;
+	}
+
 	if (mlx5_eswitch_termtbl_required(esw, attr, &flow_act, spec))
 		rule = mlx5_eswitch_add_termtbl_rule(esw, fdb, spec, esw_attr,
 						     &flow_act, dest, i);
-- 
2.38.1

