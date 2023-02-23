Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95E596A1312
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 23:53:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjBWWxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 17:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBWWxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 17:53:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AF414228
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 14:53:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95FB1B81A93
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 22:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384A5C4339B;
        Thu, 23 Feb 2023 22:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677192779;
        bh=XTNWdIBvJH8L2As99un1L2ch0qP7xjhBSDJ+WfaG1Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l4QXgTDoI+x+3H3YIWtlW2o0ErICe6m6FZ/aCEOopJYk8zj6q1Za/0kZX2lorr70S
         AqGx2Dw5OhGltdv/R3m5fdzESNjxDwjdvbeIhy3VPuvI7DFAuY9AhtXAzllOJMaAQV
         PJpriONNvjNv1MFAeDZGSW8LhSUsfh/2jkaQs6KzDuw2MLHM9IRb/6DvgJnna0vX6d
         p+w1J8Cg710BDm5sdj9+fRQM2sJD6tN9rZVyl2mqSovlL8skQDnMks66T7mnKnfxf4
         bzsySDg4yoeFiYrEcMWtrMxAa8pdWH9ajnznBZkI+lQmgqNLU1j4ww1Yt0PgCTAepw
         sKl8ZCPNvXkkA==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: [net 04/10] net/mlx5e: xsk: Set napi_id to support busy polling on XSK RQ
Date:   Thu, 23 Feb 2023 14:52:41 -0800
Message-Id: <20230223225247.586552-5-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230223225247.586552-1-saeed@kernel.org>
References: <20230223225247.586552-1-saeed@kernel.org>
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

From: Maxim Mikityanskiy <maxtram95@gmail.com>

The cited commit missed setting napi_id on XSK RQs, it only affected
regular RQs. Add the missing part to support socket busy polling on XSK
RQs.

Fixes: a2740f529da2 ("net/mlx5e: xsk: Set napi_id to support busy polling")
Signed-off-by: Maxim Mikityanskiy <maxtram95@gmail.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 81a567e17264..bc6706aa8afc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -86,7 +86,7 @@ static int mlx5e_init_xsk_rq(struct mlx5e_channel *c,
 	if (err)
 		return err;
 
-	return  xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix, 0);
+	return xdp_rxq_info_reg(&rq->xdp_rxq, rq->netdev, rq_xdp_ix, c->napi.napi_id);
 }
 
 static int mlx5e_open_xsk_rq(struct mlx5e_channel *c, struct mlx5e_params *params,
-- 
2.39.1

