Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3C860E2AC
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 15:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbiJZNyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 09:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233977AbiJZNxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 09:53:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26DE1106921
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 06:53:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B541461EB1
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 13:53:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4D0C433C1;
        Wed, 26 Oct 2022 13:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666792381;
        bh=ea9+mvIPS2DY34sTnpzGry2VsVROAjau+PY83Aj+Rtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hAo1UbzoNHHSXppKbQPSScKjzKT/CHuyVWjVkqkJ+XqdUQ+bOc7dmhRJ6tffylH6+
         MbJhK0Bk6wc4v32jN4BR+Y1mIAotj2cpNdMC/8C34U8E55htbWJyGyeCpYAyWKRQNY
         +FhkXYN8bl8k3Mh1AYcod7aF7kuGA+WLeCfTUAHMDVJZWpX1a5+kdPqa2VI/swjzzV
         kuihaqzQ+veN5qwHplz1YztgdzObObIzMsF1xz18gCDZMQFMyqOdmwAVXsXMvnTQ4c
         dpVzxCwuiWnBfwAMqtmjC4y5CArplgxoCb1RfDctKoBPPk5ZUloo6vi4w4IFButFaf
         kroywCKEedmxw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [V4 net 14/15] net/mlx5e: Fix wrong bitwise comparison usage in macsec_fs_rx_add_rule function
Date:   Wed, 26 Oct 2022 14:51:52 +0100
Message-Id: <20221026135153.154807-15-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221026135153.154807-1-saeed@kernel.org>
References: <20221026135153.154807-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

The cited commit produces a sparse check error of type
"sparse: error: restricted __be64 degrades to integer". The
offending line wrongly did a bitwise operation between two different
storage types one of 64 bit when the other smaller side is 16 bit
which caused the above sparse error, furthermore bitwise operation
usage here is wrong in the first place as the constant MACSEC_PORT_ES
is not a bitwise field.

Fix by using the right mask to get the lower 16 bit if the sci number,
and use comparison operator '==' instead of bitwise '&' operator.

Fixes: 3b20949cb21b ("net/mlx5e: Add MACsec RX steering rules")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
index 13dc628b988a..1ac0cf04e811 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/macsec_fs.c
@@ -1180,7 +1180,7 @@ macsec_fs_rx_add_rule(struct mlx5e_macsec_fs *macsec_fs,
 	rx_rule->rule[0] = rule;
 
 	/* Rx crypto table without SCI rule */
-	if (cpu_to_be64((__force u64)attrs->sci) & ntohs(MACSEC_PORT_ES)) {
+	if ((cpu_to_be64((__force u64)attrs->sci) & 0xFFFF) == ntohs(MACSEC_PORT_ES)) {
 		memset(spec, 0, sizeof(struct mlx5_flow_spec));
 		memset(&dest, 0, sizeof(struct mlx5_flow_destination));
 		memset(&flow_act, 0, sizeof(flow_act));
-- 
2.37.3

