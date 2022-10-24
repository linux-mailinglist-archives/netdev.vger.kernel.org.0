Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8DD660A54F
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 14:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbiJXMXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 08:23:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233374AbiJXMVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 08:21:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22597C1D0
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 04:59:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8043B811DD
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 11:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F331BC433D6;
        Mon, 24 Oct 2022 11:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666612518;
        bh=ea9+mvIPS2DY34sTnpzGry2VsVROAjau+PY83Aj+Rtc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q8hJ2/VrIqiYUjakgtt7kf7vrUnbpuGmkIEFRj2qrvQ2dEwqBu0+OUvhIKSy17x5i
         O1ycFafVTGuaik5Pcudg9DlgKl4UBRsOonXdzrx4aHUSVTu7tqtGWHubB2udbF7He1
         2v2bOfa9s9vKGFamzv3ZMbNQd1n4Zl3+KbAHBUosGeymGLLDG8CB5GHsu0bak5AtNW
         Py4ombZuxqd3FM8fBaVmoKBh15blOO5Zl8MW/WJWndK3MVPJrCqZjHaLP7B/uO9+2E
         kMBtzJPKwVV2Tah6SmsUXTN3tHdw9OQIzVUnMOuhh9ZW/aXDUHETsOfqDtnU3vwlWn
         HauCIybMo35kA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Raed Salem <raeds@nvidia.com>
Subject: [V3 net 15/16] net/mlx5e: Fix wrong bitwise comparison usage in macsec_fs_rx_add_rule function
Date:   Mon, 24 Oct 2022 12:53:56 +0100
Message-Id: <20221024115357.37278-16-saeed@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221024115357.37278-1-saeed@kernel.org>
References: <20221024115357.37278-1-saeed@kernel.org>
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

