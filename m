Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A82336EA140
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 03:51:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233212AbjDUBvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 21:51:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbjDUBvb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 21:51:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352AA6E87
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 18:51:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B233E64C08
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 01:51:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEC9C433D2;
        Fri, 21 Apr 2023 01:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682041886;
        bh=6Cj2ID1mSv7BJ7IXoADQfgQI6/Xck+gyUHb2iyToktE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bVGa2AZO0gVXcZlpw7+m6d691vZxf80hlylolvVYd4AwrWSa6EhbNmyvxZJfHhfv5
         Gz3TPJinirQSsMHAOz04ZRibJ2L4T+Yax52OLGz+/Vo45X/8Dlo/QJn0qhfMcNrngB
         arl/RzUP57MdvoyCP+svHrr93QmyCacNlwvLrSc7k0IcXmKItcOKQoUY6+3CVtCbEa
         mMQArQRXoAP+LuhL/mzlDPdESVUV9swda5hJBdye1h7rIlbwEW64oJq/hYGub6gW9C
         xg7bscrwXEIF6TAvsE4ncRwFDrdfgEiKe7+RYdAsBT4Gf5C7thQlJBdbTRkw7vkAwT
         Qh61MDoR93J8Q==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>, Chris Mi <cmi@nvidia.com>,
        Maor Dickman <maord@nvidia.com>
Subject: [net V2 05/10] net/mlx5: Release tunnel device after tc update skb
Date:   Thu, 20 Apr 2023 18:50:52 -0700
Message-Id: <20230421015057.355468-6-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230421015057.355468-1-saeed@kernel.org>
References: <20230421015057.355468-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

