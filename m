Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9AD573FD9
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 00:59:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiGMW7o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 18:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230165AbiGMW73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 18:59:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10A229809
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 15:59:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75D13B821F1
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 22:59:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE46CC341CA;
        Wed, 13 Jul 2022 22:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657753161;
        bh=m/FrSgtfP8jQf81i44t7xX/TBrvN11CuJkRZ4VehV/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIegtiY5Vend3hgK05eXbr+28MDP62tqqvf8lUcNcIiMcBaiB3JoofO9jH2uGTDTR
         COZpR5Ac/MZta3H/0XZFUL2Y5mM62f/8HLT3HY3GS734pRRWNOraSmkfmZ+KADvoEX
         wWerS8NiTUvxxndvrXXp2tr1pxl6TGyUaKxRDqoU2IH47dsGfSmn/9egrvw0UD4RmG
         X3lGbGDS7qIvXXGCGg75hcWjSr6UTLXGlCkcrJxj74uY4r7xHztVZpgMO+RMz0xGoi
         JiEmJL3rbelB+MZFcMWfSgbt3fvQ31Kf3ETsnkANTowt6YsP1V67cU6Dtf482qBOEr
         +W5a45XM9+k0g==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Rustam Subkhankulov <subkhankulov@ispras.ru>
Subject: [net-next 11/15] net/mlx5e: Removed useless code in function
Date:   Wed, 13 Jul 2022 15:58:55 -0700
Message-Id: <20220713225859.401241-12-saeed@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220713225859.401241-1-saeed@kernel.org>
References: <20220713225859.401241-1-saeed@kernel.org>
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

From: Rustam Subkhankulov <subkhankulov@ispras.ru>

Comparison of eth_ft->ft with NULL is useless, because
get_flow_table() returns either pointer 'eth_ft'
such that eth_ft->ft != NULL, or an erroneous value that is
handled on return, causing mlx5e_ethtool_flow_replace()
to terminate before checking whether eth_ft->ft equals NULL.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rustam Subkhankulov <subkhankulov@ispras.ru>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
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
2.36.1

