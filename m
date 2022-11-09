Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63083622BEC
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 13:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbiKIMyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 07:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiKIMyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 07:54:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92970175A9
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 04:54:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A18F61A87
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 12:54:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF80DC433D6;
        Wed,  9 Nov 2022 12:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667998484;
        bh=LrhI8FVbYFio06JOlqmlD6Or5Dag8XI4A4p1sDJtON0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pED8+JwsVe5lYVyvds/YddpwimNIIO2rg6G9IzHpHOaxPMEQGJPthRzpdsWcdMSFx
         ftbeKDCsDbagSYYJsKNL5qDm+dUQCQ5r69gkmjLVpTzqMCQfi9GU15rMRE3h/pwlwD
         hy5TZeZRqf9Kq0wQKpfk8wQ08y046YNwmbn3H4frr84Uin+XRQ4C7sJy/8ySDDqywV
         XjM2au7OesjsZlbEaPueABAp+B8HgMefyCB8VDLttoCt9q4AlZ3UeEt/0F7GQRQfM8
         fGIeM4Yv2zByxKoK84NpIC8V8jCv84wM8MFiNWdutto9qekrcqRM3uVpJtuxehv2rQ
         DFntGz7tOAHWA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>
Subject: [PATCH xfrm-next v7 1/8] xfrm: add new packet offload flag
Date:   Wed,  9 Nov 2022 14:54:29 +0200
Message-Id: <2e07ab72ceebd127663e151d533ad40e2d7f12f9.1667997522.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1667997522.git.leonro@nvidia.com>
References: <cover.1667997522.git.leonro@nvidia.com>
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

