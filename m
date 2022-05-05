Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4932851BCD5
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 12:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350167AbiEEKLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 06:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355021AbiEEKK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 06:10:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D86C517ED
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 03:07:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9E92B8279B
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 10:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C8CEC385A4;
        Thu,  5 May 2022 10:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651745236;
        bh=yH0duYjC6i5BVPwRe67fyQrYY2GTxtYC+kYEVhMVlmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ngSGJ7YmTyAkl6xK5D9spDCwVofsSaZAsQGUry3dJ5iuYIknhflr1q/1acWaqUqG2
         ZKFYdg0GGcSfKqlf0jtyCYwZtcGI7qLKol476Omu0DRRRvLb9n1EZqzI7HBVJQrwTR
         sPw1DE31A5F6BrpnTa46MFIEDnyhF51Jkz8R31eDPYIh0xgPlkeIwc8XKuPFeTT9az
         X8n5xBAD/YIlBZxE9+JCgh7S5K6IE0JChEHodWXNAD5it3w8Hr5I/hJqWvSWk06JDg
         mSFqyA9decBuRGawB9SIXPoYXfPFvBlU/K4lD3n7Sewoe85VVopiGUcCMBp09mjSHK
         WXOt4FOBOhN5w==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        intel-wired-lan@lists.osuosl.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>
Subject: [PATCH ipsec-next 4/8] xfrm: store and rely on direction to construct offload flags
Date:   Thu,  5 May 2022 13:06:41 +0300
Message-Id: <79ebb257828b880c4ad9bf81734053ba0f14e3e0.1651743750.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651743750.git.leonro@nvidia.com>
References: <cover.1651743750.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

XFRM state doesn't need anything from flags except to understand
direction, so store it separately. For future patches, such change
will allow us to reuse xfrm_dev_offload for policy offload too, which
has three possible directions instead of two.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/xfrm.h     | 6 ++++++
 net/xfrm/xfrm_device.c | 8 +++++++-
 net/xfrm/xfrm_user.c   | 3 ++-
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index bb20278d689c..45422f7be0c5 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -126,12 +126,18 @@ struct xfrm_state_walk {
 	struct xfrm_address_filter *filter;
 };
 
+enum {
+	XFRM_DEV_OFFLOAD_IN = 1,
+	XFRM_DEV_OFFLOAD_OUT,
+};
+
 struct xfrm_dev_offload {
 	struct net_device	*dev;
 	netdevice_tracker	dev_tracker;
 	struct net_device	*real_dev;
 	unsigned long		offload_handle;
 	u8			flags;
+	u8			dir : 2;
 };
 
 struct xfrm_mode {
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 6e4d3cb2e24d..c818afca9137 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -117,7 +117,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 
 	sp = skb_sec_path(skb);
 	x = sp->xvec[sp->len - 1];
-	if (xo->flags & XFRM_GRO || x->xso.flags & XFRM_OFFLOAD_INBOUND)
+	if (xo->flags & XFRM_GRO || x->xso.dir == XFRM_DEV_OFFLOAD_IN)
 		return skb;
 
 	/* This skb was already validated on the upper/virtual dev */
@@ -267,10 +267,16 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	/* Don't forward bit that is not implemented */
 	xso->flags = xuo->flags & ~XFRM_OFFLOAD_IPV6;
 
+	if (xuo->flags & XFRM_OFFLOAD_INBOUND)
+		xso->dir = XFRM_DEV_OFFLOAD_IN;
+	else
+		xso->dir = XFRM_DEV_OFFLOAD_OUT;
+
 	err = dev->xfrmdev_ops->xdo_dev_state_add(x);
 	if (err) {
 		xso->flags = 0;
 		xso->dev = NULL;
+		xso->dir = 0;
 		xso->real_dev = NULL;
 		dev_put_track(dev, &xso->dev_tracker);
 
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 7217c57a76e9..6a58fec6a1fb 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -852,7 +852,8 @@ static int copy_user_offload(struct xfrm_dev_offload *xso, struct sk_buff *skb)
 	xuo = nla_data(attr);
 	memset(xuo, 0, sizeof(*xuo));
 	xuo->ifindex = xso->dev->ifindex;
-	xuo->flags = xso->flags;
+	if (xso->dir == XFRM_DEV_OFFLOAD_IN)
+		xuo->flags = XFRM_OFFLOAD_INBOUND;
 
 	return 0;
 }
-- 
2.35.1

