Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6296E7983
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 14:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232773AbjDSMTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 08:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232470AbjDSMTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 08:19:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0C77AAE
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 05:19:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2319A631D4
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 12:19:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094F4C433EF;
        Wed, 19 Apr 2023 12:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681906767;
        bh=YC2ypSlkTdZgoIRj1Ud4Ek7EkGyqOwKwjg1cXP4oGSs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o7PbC1YVdau1BoDvqp1gNh77XrdfNMEF+DFHDAYuUDvPLQFV5pM2H+rqmWlQhCQ2Q
         gGdn1uiwDVevjis4TCXCg6tK+oFHpynvNfZJkyVKwRKYYUljeQf/rQ09Sb9ZHTTzLn
         //un4Kx5U0ItiR2/PbFVMli84WMT9kzSlxt3lizPyGpr9rwDRqESRnDKQ9I1MlmQrq
         /QdOVcjCB8avh9viJ3EC9epOv0TPBm60+8VEbVYjHUIen8gbvijFvolEsipIhrKMsX
         KGxexV0jzHo56ziCI91o74OYdPr1ayG/jMhZNnsBlDN0iPA6o23Ru2f2yHnAVzSP1d
         S7OpisckYCjJA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>
Subject: [PATCH xfrm 2/2] xfrm: Fix leak of dev tracker
Date:   Wed, 19 Apr 2023 15:19:08 +0300
Message-Id: <dc1db7b00f7a9f18edfe4148dffacc2a5381e824.1681906552.git.leon@kernel.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1681906552.git.leon@kernel.org>
References: <cover.1681906552.git.leon@kernel.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

At the stage of direction checks, the netdev reference tracker is
already initialized, but released with wrong *_put() call.

Fixes: 919e43fad516 ("xfrm: add an interface to offload policy")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/xfrm/xfrm_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index bef28c6187eb..408f5e55744e 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -378,7 +378,7 @@ int xfrm_dev_policy_add(struct net *net, struct xfrm_policy *xp,
 		break;
 	default:
 		xdo->dev = NULL;
-		dev_put(dev);
+		netdev_put(dev, &xdo->dev_tracker);
 		NL_SET_ERR_MSG(extack, "Unrecognized offload direction");
 		return -EINVAL;
 	}
-- 
2.40.0

