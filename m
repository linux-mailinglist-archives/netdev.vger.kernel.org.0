Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5C861D823
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 08:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiKEHLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Nov 2022 03:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiKEHLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Nov 2022 03:11:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5514A2FC28
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 00:10:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D50FCB80682
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 07:10:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6933AC433B5;
        Sat,  5 Nov 2022 07:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667632245;
        bh=6pIZP/jKC3ZVZlyTRgfW+sifjVGnnRn7fktayp6Os8g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jb/Yq5Dt2Roz9N76kCrTM33Bo4TZC+aAx67jW6y3wVpDdpIY8mBc2JGQPKvpXAqod
         0Vs2dxYiL3cBSNoXQZkKH8u5iXPLt2habYT0amuECH/xLPFKv7DHTXFxhdVA9eLlJc
         3GAqodlbHrGYDNZKdYyh2pQp/BF7cBvyxePDNMFWpT8bReE32W+IHNsXuTzfjsJU1j
         1A9V5fyMcZauCsty9JUxdoMtEgSRjLibaUQoIle/fzbAVdlgwXzgWf3NEGj6XuBAh2
         p8Xov3IYZ5xeE1or1MjN+X8nl+7rNZamks1M7+hLj2cy/Rp6ximCSVTmH/AYZXy9ZE
         w7Fez5vUC3NXg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [V2 net 11/11] net/mlx5e: TC, Fix slab-out-of-bounds in parse_tc_actions
Date:   Sat,  5 Nov 2022 00:10:28 -0700
Message-Id: <20221105071028.578594-12-saeed@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221105071028.578594-1-saeed@kernel.org>
References: <20221105071028.578594-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

