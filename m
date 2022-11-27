Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBB18639A0B
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 12:18:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiK0LSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 06:18:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiK0LS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 06:18:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039626575
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 03:18:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9256B60C90
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 11:18:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F131C433D7;
        Sun, 27 Nov 2022 11:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669547908;
        bh=LrhI8FVbYFio06JOlqmlD6Or5Dag8XI4A4p1sDJtON0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QV048U6y9lzBJf/mblr0IPKmtowSBEaDwUIz8MicqS5gA11BCDP2QAwfH3q94GLg3
         6Vp2YK2qAdikr37S2AypjRQZqRYUd5sGM5KvIDgkghbxa9zRHDWXL8zYtR1iF5SU6b
         1GY9HbgDfTEMsaxiDpPelYCtRG/utBypkqWT+ApcAFeZvTwzDdoFaplguztNnUnWc+
         K5ONVeZ5qWDRQrGVyi/iRHxu5XnweYR8g+SkUACBMPM+gKJp6letShpcJAh+fTOHF3
         VMPm09WVO2ZeBEBBSQafzWw3gwj1vO3EELwXWCuLWQ7uwXZBqI8jSWnqlkOezOeMhh
         RtgsVquMAwe8A==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bharat Bhushan <bbhushan2@marvell.com>,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH xfrm-next v9 1/8] xfrm: add new packet offload flag
Date:   Sun, 27 Nov 2022 13:18:11 +0200
Message-Id: <f6727b3ff04f05a7c4f808b88c4a4eab638b0f16.1669547603.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669547603.git.leonro@nvidia.com>
References: <cover.1669547603.git.leonro@nvidia.com>
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

From: Leon Romanovsky <leonro@nvidia.com>

In the next patches, the xfrm core code will be extended to support
new type of offload - packet offload. In that mode, both policy and state
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
index dbc81f5eb553..304001b76fc5 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -131,12 +131,19 @@ enum {
 	XFRM_DEV_OFFLOAD_OUT,
 };
 
+enum {
+	XFRM_DEV_OFFLOAD_UNSPECIFIED,
+	XFRM_DEV_OFFLOAD_CRYPTO,
+	XFRM_DEV_OFFLOAD_PACKET,
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
index 4f84ea7ee14c..23543c33fee8 100644
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
+#define XFRM_OFFLOAD_PACKET	4
 
 struct xfrm_userpolicy_default {
 #define XFRM_USERPOLICY_UNSPEC	0
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 5f5aafd418af..7c4e0f14df27 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -278,12 +278,15 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
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
 
 		if (err != -EOPNOTSUPP) {
 			NL_SET_ERR_MSG(extack, "Device failed to offload this state");
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index e73f9efc54c1..573b60873b60 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -943,6 +943,8 @@ static int copy_user_offload(struct xfrm_dev_offload *xso, struct sk_buff *skb)
 	xuo->ifindex = xso->dev->ifindex;
 	if (xso->dir == XFRM_DEV_OFFLOAD_IN)
 		xuo->flags = XFRM_OFFLOAD_INBOUND;
+	if (xso->type == XFRM_DEV_OFFLOAD_PACKET)
+		xuo->flags |= XFRM_OFFLOAD_PACKET;
 
 	return 0;
 }
-- 
2.38.1

