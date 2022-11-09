Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFDA6232B6
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 19:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231393AbiKISlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 13:41:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231387AbiKISlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 13:41:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7272B25B
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 10:41:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C70BB81F90
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 18:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCA2C433C1;
        Wed,  9 Nov 2022 18:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668019267;
        bh=6pIZP/jKC3ZVZlyTRgfW+sifjVGnnRn7fktayp6Os8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PttHExc5nlDoqQC1jhYYXvOBC7ovP1HjFaMggl+xrq5xQtijs4KePfSDuQg9CbBKf
         MePtsHtcYPIDegj3hA+RWVf999pRUV8xQWCG8uo9yDw/4CWy3cALJQw3cbJEHioSBQ
         adJgLJoAODv/Vpsgusq8v4aWB06xhlcClo0rAKzfq7C4aZ1qvQGFR1Hs6/KfzMq05/
         Ihn86GDap36isGbmEkYqvq/0YWZqVGO7blXRRYCIxBav/CEKSiUNIxKQvLyyiK2mBp
         nMGqHv0rHtyj7DQ1Ppe1w0go8Jzgv/HNt4fw/HL0QrRjeHZhsJkYHWdJuZPLlRcHK7
         /ffhTRvU0ydig==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [V3 net 10/10] net/mlx5e: TC, Fix slab-out-of-bounds in parse_tc_actions
Date:   Wed,  9 Nov 2022 10:40:50 -0800
Message-Id: <20221109184050.108379-11-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221109184050.108379-1-saeed@kernel.org>
References: <20221109184050.108379-1-saeed@kernel.org>
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

From: Roi Dayan <roid@nvidia.com>

esw_attr is only allocated if namespace is fdb.

BUG: KASAN: slab-out-of-bounds in parse_tc_actions+0xdc6/0x10e0 [mlx5_core]
Write of size 4 at addr ffff88815f185b04 by task tc/2135

CPU: 5 PID: 2135 Comm: tc Not tainted 6.1.0-rc2+ #2
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x57/0x7d
 print_report+0x170/0x471
 ? parse_tc_actions+0xdc6/0x10e0 [mlx5_core]
 kasan_report+0xbc/0xf0
 ? parse_tc_actions+0xdc6/0x10e0 [mlx5_core]
 parse_tc_actions+0xdc6/0x10e0 [mlx5_core]

Fixes: 94d651739e17 ("net/mlx5e: TC, Fix cloned flow attr instance dests are not zeroed")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 372dfb89e396..5a6aa61ec82a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3633,10 +3633,14 @@ mlx5e_clone_flow_attr_for_post_act(struct mlx5_flow_attr *attr,
 	attr2->action = 0;
 	attr2->flags = 0;
 	attr2->parse_attr = parse_attr;
-	attr2->esw_attr->out_count = 0;
-	attr2->esw_attr->split_count = 0;
 	attr2->dest_chain = 0;
 	attr2->dest_ft = NULL;
+
+	if (ns_type == MLX5_FLOW_NAMESPACE_FDB) {
+		attr2->esw_attr->out_count = 0;
+		attr2->esw_attr->split_count = 0;
+	}
+
 	return attr2;
 }
 
-- 
2.38.1

