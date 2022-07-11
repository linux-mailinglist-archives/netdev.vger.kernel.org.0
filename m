Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A5156FE6A
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 12:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234696AbiGKKLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 06:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbiGKKKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 06:10:33 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 150C9BCB6;
        Mon, 11 Jul 2022 02:33:17 -0700 (PDT)
Received: from rustam-GF63-Thin-9RCX.intra.ispras.ru (unknown [83.149.199.65])
        by mail.ispras.ru (Postfix) with ESMTPS id 692F740737A7;
        Mon, 11 Jul 2022 09:33:11 +0000 (UTC)
From:   Rustam Subkhankulov <subkhankulov@ispras.ru>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Rustam Subkhankulov <subkhankulov@ispras.ru>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maor Gottlieb <maorg@mellanox.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH] net/mlx5e: Removed useless code in function
Date:   Mon, 11 Jul 2022 12:33:03 +0300
Message-Id: <20220711093303.14511-1-subkhankulov@ispras.ru>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Comparison of eth_ft->ft with NULL is useless, because
get_flow_table() returns either pointer 'eth_ft'
such that eth_ft->ft != NULL, or an erroneous value that is
handled on return, causing mlx5e_ethtool_flow_replace()
to terminate before checking whether eth_ft->ft equals NULL.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
Fixes: 6dc6071cfcde ("net/mlx5e: Add ethtool flow steering support")
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
index ad0d234632a3..9466202fd97b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs_ethtool.c
@@ -742,10 +742,7 @@ mlx5e_ethtool_flow_replace(struct mlx5e_priv *priv,
 
 	eth_rule->flow_spec = *fs;
 	eth_rule->eth_ft = eth_ft;
-	if (!eth_ft->ft) {
-		err = -EINVAL;
-		goto del_ethtool_rule;
-	}
+
 	rule = add_ethtool_flow_rule(priv, eth_rule, eth_ft->ft, fs, rss_context);
 	if (IS_ERR(rule)) {
 		err = PTR_ERR(rule);
-- 
2.25.1

