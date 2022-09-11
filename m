Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 025EC5B4CD3
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 11:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiIKJDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 05:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbiIKJDT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 05:03:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D93A8399FB;
        Sun, 11 Sep 2022 02:03:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5829960F3C;
        Sun, 11 Sep 2022 09:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB60EC433D6;
        Sun, 11 Sep 2022 09:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662886995;
        bh=rTvQIbrU8zayFPKG6ZUyF2mG4VPXoXeA1CW6REYuqB4=;
        h=From:To:Cc:Subject:Date:From;
        b=L2jx8OlSyrruY2VcSfA4xJt2feLDZovdI2FOUHu56hA6MEO0lEgJy0WCxP78DtwBQ
         fb3Ci9pX2go/O5TbYJWsoGbHevQKVgqj4/VldC0tN+M9JsQbq/MxJLy8+RPrsPjLpS
         Em0zC2gNgE5Mrg2CJZrZVQPwngOV0KcL52VpYWrx00tNrHzc9v3Vhs7ir5oh2YpWXP
         1Xmw2Fj3Qy942ArwOVlHky8+5/3Ow1TaeNldYQJGPohuzN9jPcHjQykAvmGR90xAUO
         lNEM0CvEW9mOQrfFsWkVDYTEng8KyqKn0EPPvOiJ96+TxFMkjhDtmwiTH2ctB9DTSD
         EweLI+q4MtV4w==
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
Subject: [PATCH net-next v2] net/mlx5e: Ensure macsec_rule is always initiailized in macsec_fs_{r,t}x_add_rule()
Date:   Sun, 11 Sep 2022 01:57:50 -0700
Message-Id: <20220911085748.461033-1-nathan@kernel.org>
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
Initialize it to NULL at the top of each function so that it cannot be
used uninitialized.

Fixes: e467b283ffd5 ("net/mlx5e: Add MACsec TX steering rules")
Fixes: 3b20949cb21b ("net/mlx5e: Add MACsec RX steering rules")
Link: https://github.com/ClangBuiltLinux/linux/issues/1706
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

v1 -> v2: https://lore.kernel.org/20220908153207.4048871-1-nathan@kernel.org/

* Don't use a label and goto, just initialize it to NULL at the top of
  the functions (Raed).

Tom, I did not carry forward your reviewed-by tag, even though this is a
pretty obvious fix.

Blurb from v1:

I thought netdev was doing testing with clang so that new warnings do
not show up. Did something break or stop working since this is the
second time in two weeks that new warnings have appeared in -next?

 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
index 608fbbaa5a58..13dc628b988a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
@@ -518,9 +518,9 @@ macsec_fs_tx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 	struct mlx5_pkt_reformat_params reformat_params = {};
 	struct mlx5e_macsec_tx *tx_fs = macsec_fs->tx_fs;
 	struct net_device *netdev = macsec_fs->netdev;
+	union mlx5e_macsec_rule *macsec_rule = NULL;
 	struct mlx5_flow_destination dest = {};
 	struct mlx5e_macsec_tables *tx_tables;
-	union mlx5e_macsec_rule *macsec_rule;
 	struct mlx5e_macsec_tx_rule *tx_rule;
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *rule;
@@ -1112,10 +1112,10 @@ macsec_fs_rx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 	u8 action[MLX5_UN_SZ_BYTES(set_add_copy_action_in_auto)] = {};
 	struct mlx5e_macsec_rx *rx_fs = macsec_fs->rx_fs;
 	struct net_device *netdev = macsec_fs->netdev;
+	union mlx5e_macsec_rule *macsec_rule = NULL;
 	struct mlx5_modify_hdr *modify_hdr = NULL;
 	struct mlx5_flow_destination dest = {};
 	struct mlx5e_macsec_tables *rx_tables;
-	union mlx5e_macsec_rule *macsec_rule;
 	struct mlx5e_macsec_rx_rule *rx_rule;
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5e_flow_table *ft_crypto;

base-commit: 169ccf0e40825d9e465863e4707d8e8546d3c3cb
-- 
2.37.3

