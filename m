Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449226E8731
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 03:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbjDTBKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 21:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbjDTBKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 21:10:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F9A55B8
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 18:10:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A4A664447
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 01:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2F24C433D2;
        Thu, 20 Apr 2023 01:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681953028;
        bh=6Cj2ID1mSv7BJ7IXoADQfgQI6/Xck+gyUHb2iyToktE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXikVUoQt1bBRFwEFNgRrYTVq4Q70L7B3v5Q3MiDqHyexxk38s9VfLezchGEsAQJ1
         /k20XRCfdaxh4BNDVSJJqLwkrj6sMf/IF9uMQOhQRgp32sL2wgMZMWtF4242jmWvLR
         ZH5NW9Z1KKFNliRzuk0mt7bumZGPs+T1d3zZilLllu2Th/nubZq8rWUfwAEw4A+W7x
         UTYnuXblnsXKu/vBs29AgyU1/zRmsY4ZfKpZ9epLd6UWhxYeRmRBvE0kp2WiViAu5R
         vEWsu+XJLkZPvmn0yPLtPWCnH0wpeyexJNLOjVfcjI4QqFD8r1ckflDSsr0FNUrpts
         ezAd/Bk6v/7jQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net 05/10] net/mlx5: Release tunnel device after tc update skb
Date:   Wed, 19 Apr 2023 18:09:54 -0700
Message-Id: <20230420010959.276760-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230420010959.276760-1-saeed@kernel.org>
References: <20230420010959.276760-1-saeed@kernel.org>
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

From: Chris Mi <cmi@nvidia.com>

The cited commit causes a regression. Tunnel device is not released
after tc update skb if skb needs to be freed. The following error
message will be printed:

  unregister_netdevice: waiting for vxlan1 to become free. Usage count = 11

Fix it by releasing tunnel device if skb needs to be freed.

Fixes: 93a1ab2c545b ("net/mlx5: Refactor tc miss handling to a single function")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
index 8f7452dc00ee..668fdee9cf05 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
@@ -715,5 +715,6 @@ void mlx5e_rep_tc_receive(struct mlx5_cqe64 *cqe, struct mlx5e_rq *rq,
 	return;
 
 free_skb:
+	dev_put(tc_priv.fwd_dev);
 	dev_kfree_skb_any(skb);
 }
-- 
2.39.2

