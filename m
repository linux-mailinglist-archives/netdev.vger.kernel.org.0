Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD1E5A1853
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242734AbiHYSGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 14:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236470AbiHYSGv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:06:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB275BD10A;
        Thu, 25 Aug 2022 11:06:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B1567B828F5;
        Thu, 25 Aug 2022 18:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3AD3C433D6;
        Thu, 25 Aug 2022 18:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661450805;
        bh=vdTPPyDbO3DHcZ5e2uNSt88PKKTHBmt6XSFXJAjrnZY=;
        h=From:To:Cc:Subject:Date:From;
        b=GbTSocz+aD9OF41KTFJ8PQlEKuvLWQzcPEkSeVJK0zzw1bzVGw5Fu2PogX5Jgxyq4
         R9vYsoSXSuIdjBa8KIgvg5QuB8K3w/pL9tWXFtozyMULZ8OxcgT80BrtD6O5EvmSpi
         0jZgpNCco6IF5COMAiPRQ8TeBN/VrWloMguq8+tLkz3BLDmw04Y1VWoOOrXaFWboXy
         sDXFBScj9Ft9HNv+wYLWz1RFMx+pE9h3rxhyPUqUAhUUenO4Bxn0Ob5VomVxc62OlY
         GuqV8qmnuLxr4kv0cRZHO42CfwtAejK6AaywH2JQfIyLUwGQ8HJovK+CMNXdtEkjMo
         Eho7kmM7DA8xA==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH net-next] net/mlx5e: Do not use err uninitialized in mlx5e_rep_add_meta_tunnel_rule()
Date:   Thu, 25 Aug 2022 11:06:07 -0700
Message-Id: <20220825180607.2707947-1-nathan@kernel.org>
X-Mailer: git-send-email 2.37.2
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

Clang warns:

  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:481:6: error: variable 'err' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
          if (IS_ERR(flow_rule)) {
              ^~~~~~~~~~~~~~~~~
  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:489:9: note: uninitialized use occurs here
          return err;
                ^~~
  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:481:2: note: remove the 'if' if its condition is always true
          if (IS_ERR(flow_rule)) {
          ^~~~~~~~~~~~~~~~~~~~~~~
  drivers/net/ethernet/mellanox/mlx5/core/en_rep.c:474:9: note: initialize the variable 'err' to silence this warning
          int err;
                ^
                  = 0
  1 error generated.

There is little reason to have the 'goto + error variable' construct in
this function. Get rid of it and just return the PTR_ERR value in the if
statement and 0 at the end.

Fixes: 430e2d5e2a98 ("net/mlx5: E-Switch, Move send to vport meta rule creation")
Link: https://github.com/ClangBuiltLinux/linux/issues/1695
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index c8617a62e542..a977804137a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -471,22 +471,18 @@ mlx5e_rep_add_meta_tunnel_rule(struct mlx5e_priv *priv)
 	struct mlx5_eswitch_rep *rep = rpriv->rep;
 	struct mlx5_flow_handle *flow_rule;
 	struct mlx5_flow_group *g;
-	int err;
 
 	g = esw->fdb_table.offloads.send_to_vport_meta_grp;
 	if (!g)
 		return 0;
 
 	flow_rule = mlx5_eswitch_add_send_to_vport_meta_rule(esw, rep->vport);
-	if (IS_ERR(flow_rule)) {
-		err = PTR_ERR(flow_rule);
-		goto out;
-	}
+	if (IS_ERR(flow_rule))
+		return PTR_ERR(flow_rule);
 
 	rpriv->send_to_vport_meta_rule = flow_rule;
 
-out:
-	return err;
+	return 0;
 }
 
 static void

base-commit: c19d893fbf3f2f8fa864ae39652c7fee939edde2
-- 
2.37.2

