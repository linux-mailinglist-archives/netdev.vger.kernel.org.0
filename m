Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFE1359E860
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343655AbiHWRBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344386AbiHWRBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:01:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A9885AB2
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 06:32:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA9C0614C4
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 13:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD21EC433D7;
        Tue, 23 Aug 2022 13:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661261542;
        bh=7CWFJPDYmNTO1tgfwh7HDem3FSnpzBD/Ih5sSJH6BCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T4wme9Zz9k5vZR1544YAl2/Gc9JE7fvQsW1wL/Pqiofv8doxUjZ60f49tkMEPQo61
         s3Pv52yVZJCA9zEgBCkNirlBFLzp560FTKozfQYI9I1eJjczGteZ+GEBvQuV4Utq4M
         neJ1uY4Eslk8ps3NuinGmB9NpNTJI8TUgpIMBqP4l+mQdMXIJiXBWNIuizWR1NsW2b
         q2v1KU24ZaNpgv74PDtQWUOet7vlheknXswQ3NK0C1C9UInLYAYvM69MpvNkx8X5gR
         YXB0jBEjssplgN1aYypzRmIQUOFRH/asf6p1g2JqlIZ49JANxZeN+STevp2Y7Za2ti
         7SMWmpJDLlmmw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH xfrm-next v3 1/6] xfrm: add new full offload flag
Date:   Tue, 23 Aug 2022 16:31:58 +0300
Message-Id: <2b6fdc02be2619455d98bde3b55ba8b71638ac33.1661260787.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1661260787.git.leonro@nvidia.com>
References: <cover.1661260787.git.leonro@nvidia.com>
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

In the next patches, the xfrm core code will be extended to support
new type of offload - full offload. In that mode, both policy and state
should be specially configured in order to perform whole offloaded data
path.

Full offload takes care of encryption, decryption, encapsulation and
other operations with headers.

As this mode is new for XFRM policy flow, we can "start fresh" with flag
bits and release first and second bit for future use.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 include/net/xfrm.h        | 7 +++++++
 include/uapi/linux/xfrm.h | 6 ++++++
 net/xfrm/xfrm_device.c    | 3 +++
 net/xfrm/xfrm_user.c      | 2 ++
 4 files changed, 18 insertions(+)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 6e8fa98f786f..b4d487053dfd 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -131,12 +131,19 @@ enum {
 	XFRM_DEV_OFFLOAD_OUT,
 };
 
+enum {
+	XFRM_DEV_OFFLOAD_UNSPECIFIED,
+	XFRM_DEV_OFFLOAD_CRYPTO,
+	XFRM_DEV_OFFLOAD_FULL,
+};
+
 struct xfrm_dev_offload {
 	struct net_device	*dev;
 	netdevice_tracker	dev_tracker;
 	struct net_device	*real_dev;
 	unsigned long		offload_handle;
 	u8			dir : 2;
+	u8			type : 2;
 };
 
 struct xfrm_mode {
diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index b1f3e6a8f11a..3b084246d610 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -519,6 +519,12 @@ struct xfrm_user_offload {
  */
 #define XFRM_OFFLOAD_IPV6	1
 #define XFRM_OFFLOAD_INBOUND	2
+/* Two bits above are relevant for state path only, while
+ * offload is used for both policy and state flows.
+ *
+ * In policy offload mode, they are free and can be safely reused.
+ */
+#define XFRM_OFFLOAD_FULL	4
 
 struct xfrm_userpolicy_default {
 #define XFRM_USERPOLICY_UNSPEC	0
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 637ca8838436..6d1124eb1ec8 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -270,12 +270,15 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	else
 		xso->dir = XFRM_DEV_OFFLOAD_OUT;
 
+	xso->type = XFRM_DEV_OFFLOAD_CRYPTO;
+
 	err = dev->xfrmdev_ops->xdo_dev_state_add(x);
 	if (err) {
 		xso->dev = NULL;
 		xso->dir = 0;
 		xso->real_dev = NULL;
 		netdev_put(dev, &xso->dev_tracker);
+		xso->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
 
 		if (err != -EOPNOTSUPP)
 			return err;
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 2ff017117730..9c0aef815730 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -854,6 +854,8 @@ static int copy_user_offload(struct xfrm_dev_offload *xso, struct sk_buff *skb)
 	xuo->ifindex = xso->dev->ifindex;
 	if (xso->dir == XFRM_DEV_OFFLOAD_IN)
 		xuo->flags = XFRM_OFFLOAD_INBOUND;
+	if (xso->type == XFRM_DEV_OFFLOAD_FULL)
+		xuo->flags |= XFRM_OFFLOAD_FULL;
 
 	return 0;
 }
-- 
2.37.2

