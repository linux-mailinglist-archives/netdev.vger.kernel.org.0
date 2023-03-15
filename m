Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C7CB6BC052
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 23:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232909AbjCOW7S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 18:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232884AbjCOW7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 18:59:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4759DE09
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 15:58:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5CC161EA9
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 22:58:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD1BC4339C;
        Wed, 15 Mar 2023 22:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678921139;
        bh=QDZwZeC/hVIfHW6hUnvSHSN6t4xBNVfG+HH6glUzg0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkipm2Zj3CYM0r9bffyojccDqp3J7lMPvmiDAGfhYeUGLSG8wXa9z5I9UEXbrKvxq
         /vm7KXDs36LQ/+RJYYASeqDCG71pywKrca3I6+DvsvQH5sIXk7pjDo7TIuhSQPyXnF
         OWyORDOnXpkCxIDdjwKhpn8Vqv6fal8YL37rGf2CBCTmbHDadSt5QlWJsOFrdvJSM3
         R4wmk68Fk6yU34sniot8OSTWwKIx/Ns3UPw02SSPhVHLR++/x/obT1/5/Kn5Cv2kwT
         R4x7y1p0qUNqWgmb+u9tQnncmkr9PeNSCB4l5AaaeHBpNB5yGNINBJMvngSE6973Jz
         epWNxq1YIj2EQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Oz Shlomo <ozsh@nvidia.com>,
        Paul Blakey <paulb@nvidia.com>
Subject: [net V2 13/14] net/mlx5e: TC, fix cloned flow attribute
Date:   Wed, 15 Mar 2023 15:58:46 -0700
Message-Id: <20230315225847.360083-14-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230315225847.360083-1-saeed@kernel.org>
References: <20230315225847.360083-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oz Shlomo <ozsh@nvidia.com>

Currently the cloned flow attr resets the original tc action cookies
count.
Fix that by resetting the cloned flow attribute.

Fixes: cca7eac13856 ("net/mlx5e: TC, store tc action cookies per attr")
Signed-off-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index d2e191ee0704..6bfed633343a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3752,7 +3752,7 @@ mlx5e_clone_flow_attr_for_post_act(struct mlx5_flow_attr *attr,
 	parse_attr->filter_dev = attr->parse_attr->filter_dev;
 	attr2->action = 0;
 	attr2->counter = NULL;
-	attr->tc_act_cookies_count = 0;
+	attr2->tc_act_cookies_count = 0;
 	attr2->flags = 0;
 	attr2->parse_attr = parse_attr;
 	attr2->dest_chain = 0;
-- 
2.39.2

