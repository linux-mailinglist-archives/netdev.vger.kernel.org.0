Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B985B227E
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 17:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231388AbiIHPgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 11:36:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiIHPgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 11:36:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0C0F9FA0;
        Thu,  8 Sep 2022 08:36:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3312661D68;
        Thu,  8 Sep 2022 15:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE05C433C1;
        Thu,  8 Sep 2022 15:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662651382;
        bh=48cGN8TDwQU3HkIVSAghRCofC+Nvm7oCFW08RXG/d5s=;
        h=From:To:Cc:Subject:Date:From;
        b=cue2mWFFpCububM7EIhHuVhSVpRUNmld2Ooql8iSfwNz0nRL9LJxfbAk4sruTmrEp
         vc/kjS6+SdxqFXFDFjUyK8VuOBUajMS8m/V5ubUY/5P+FzFju66t9/EDQ36ANfay1R
         R9HRO/1H5cSfbaU+Pf+khu2EK1kBw2L252+Y9arFCH4g/uIt0o9MZded4X1mIxdW3A
         LaRouybKDofp2PIMIm060IZnzsTW7Rs9CnVg8jObcK5ELcPF97OFBUp9z+u29oLnZe
         KClND5CBL2/K9x0EhXgYz+WlMocO/RvJ3wfG48531yyyTcabWUQCu7d9FwtyLKD0Lb
         xuCmH3XdMV+hw==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, Boris Pismenny <borisp@nvidia.com>,
        Raed Salem <raeds@nvidia.com>,
        Lior Nahmanson <liorna@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH net-next] net/mlx5e: Ensure macsec_rule is always initiailized in macsec_fs_{r,t}x_add_rule()
Date:   Thu,  8 Sep 2022 08:32:08 -0700
Message-Id: <20220908153207.4048871-1-nathan@kernel.org>
X-Mailer: git-send-email 2.37.3
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

  drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:539:6: error: variable 'macsec_rule' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
          if (err)
              ^~~
  drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:598:9: note: uninitialized use occurs here
          return macsec_rule;
                ^~~~~~~~~~~
  drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:539:2: note: remove the 'if' if its condition is always false
          if (err)
          ^~~~~~~~
  drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:523:38: note: initialize the variable 'macsec_rule' to silence this warning
          union mlx5e_macsec_rule *macsec_rule;
                                              ^
                                              = NULL
  drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:1131:6: error: variable 'macsec_rule' is used uninitialized whenever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
          if (err)
              ^~~
  drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:1215:9: note: uninitialized use occurs here
          return macsec_rule;
                ^~~~~~~~~~~
  drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:1131:2: note: remove the 'if' if its condition is always false
          if (err)
          ^~~~~~~~
  drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c:1118:38: note: initialize the variable 'macsec_rule' to silence this warning
          union mlx5e_macsec_rule *macsec_rule;
                                              ^
                                              = NULL
  2 errors generated.

If macsec_fs_{r,t}x_ft_get() fail, macsec_rule will be uninitialized.
Use the existing initialization to NULL in the existing error path to
ensure macsec_rule is always initialized.

Fixes: e467b283ffd5 ("net/mlx5e: Add MACsec TX steering rules")
Fixes: 3b20949cb21b ("net/mlx5e: Add MACsec RX steering rules")
Link: https://github.com/ClangBuiltLinux/linux/issues/1706
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

The other fix I considered was shuffling the two if statements so that
the allocation of macsec_rule came before the call to
macsec_fs_{r,t}x_ft_get() but I was not sure what the implications of
that change were.

Also, I thought netdev was doing testing with clang so that new warnings
do not show up. Did something break or stop working since this is the
second time in two weeks that new warnings have appeared in -next?

 .../net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c    | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
index 608fbbaa5a58..4467e88d7e7f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
@@ -537,7 +537,7 @@ macsec_fs_tx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 
 	err = macsec_fs_tx_ft_get(macsec_fs);
 	if (err)
-		goto out_spec;
+		goto out_spec_no_rule;
 
 	macsec_rule = kzalloc(sizeof(*macsec_rule), GFP_KERNEL);
 	if (!macsec_rule) {
@@ -591,6 +591,7 @@ macsec_fs_tx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 
 err:
 	macsec_fs_tx_del_rule(macsec_fs, tx_rule);
+out_spec_no_rule:
 	macsec_rule = NULL;
 out_spec:
 	kvfree(spec);
@@ -1129,7 +1130,7 @@ macsec_fs_rx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 
 	err = macsec_fs_rx_ft_get(macsec_fs);
 	if (err)
-		goto out_spec;
+		goto out_spec_no_rule;
 
 	macsec_rule = kzalloc(sizeof(*macsec_rule), GFP_KERNEL);
 	if (!macsec_rule) {
@@ -1209,6 +1210,7 @@ macsec_fs_rx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 
 err:
 	macsec_fs_rx_del_rule(macsec_fs, rx_rule);
+out_spec_no_rule:
 	macsec_rule = NULL;
 out_spec:
 	kvfree(spec);

base-commit: 75554fe00f941c3c3d9344e88708093a14d2b4b8
-- 
2.37.3

