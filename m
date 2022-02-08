Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31114ADAF2
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 15:14:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377820AbiBHOOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 09:14:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236378AbiBHOOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 09:14:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54250C03FECE
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 06:14:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2BB460C03
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 14:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF9AC004E1;
        Tue,  8 Feb 2022 14:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644329683;
        bh=/wTHbazoy43dlmwREh8/tP9+JzCg/oD15pmkhMvYpIo=;
        h=From:To:Cc:Subject:Date:From;
        b=prK/Zbu0cj6g5NWiQ0KKw7afTzS6Z+9LcFQy4tCdfpCwq+rrIqKgB9P6DKIqWB+on
         9vbq/s3NErE84iv56UwVjNLHKEvasvye6oB9VFvf8omIKAXiQ4YySVl2xQ1ifJWKQx
         yGGCq9Le4jtHKBTrqf8b/AyRnTnGystaRIdJsS+RZRiKIfiMN9YHu4ac8cCU60rl7z
         9l1Wm6qHZnr39Q3Kr4nsPF3Rbd3aVxwP0Qqq/UQtN8mpfbbaLAKS+PkS4QEnsrRFu6
         q+s9uMxn15KbZmNMnhAicVbbsxLWfq2zxtdog3uEbOKOWyae+0mdVNcdGJ6KwRj20r
         MmEaItgBSy8eQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Subject: [PATCH ipsec-rc] xfrm: enforce validity of offload input flags
Date:   Tue,  8 Feb 2022 16:14:32 +0200
Message-Id: <8e526e4814f0c4da5a965567d3b8dce3a9ac2470.1644329331.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.34.1
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

struct xfrm_user_offload has flags variable that received user input,
but kernel didn't check if valid bits were provided. It caused a situation
where not sanitized input was forwarded directly to the drivers.

For example, XFRM_OFFLOAD_IPV6 define that was exposed, was used by
strongswan, but not implemented in the kernel at all.

As a solution, check and sanitize input flags to forward
XFRM_OFFLOAD_INBOUND to the drivers.

Fixes: d77e38e612a0 ("xfrm: Add an IPsec hardware offloading API")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Another variant of https://lore.kernel.org/all/31811e3cf276ae2af01574f4fbcb127b88d9c6b5.1643307803.git.leonro@nvidia.com
It is -rc fix now.
---
 include/uapi/linux/xfrm.h | 6 ++++++
 net/xfrm/xfrm_device.c    | 6 +++++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/xfrm.h b/include/uapi/linux/xfrm.h
index 4e29d7851890..65e13a099b1a 100644
--- a/include/uapi/linux/xfrm.h
+++ b/include/uapi/linux/xfrm.h
@@ -511,6 +511,12 @@ struct xfrm_user_offload {
 	int				ifindex;
 	__u8				flags;
 };
+/* This flag was exposed without any kernel code that supporting it.
+ * Unfortunately, strongswan has the code that uses sets this flag,
+ * which makes impossible to reuse this bit.
+ *
+ * So leave it here to make sure that it won't be reused by mistake.
+ */
 #define XFRM_OFFLOAD_IPV6	1
 #define XFRM_OFFLOAD_INBOUND	2
 
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 3fa066419d37..39bce5d764de 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -223,6 +223,9 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	if (x->encap || x->tfcpad)
 		return -EINVAL;
 
+	if (xuo->flags & ~(XFRM_OFFLOAD_IPV6 | XFRM_OFFLOAD_INBOUND))
+		return -EINVAL;
+
 	dev = dev_get_by_index(net, xuo->ifindex);
 	if (!dev) {
 		if (!(xuo->flags & XFRM_OFFLOAD_INBOUND)) {
@@ -262,7 +265,8 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	netdev_tracker_alloc(dev, &xso->dev_tracker, GFP_ATOMIC);
 	xso->real_dev = dev;
 	xso->num_exthdrs = 1;
-	xso->flags = xuo->flags;
+	/* Don't forward bit that is not implemented */
+	xso->flags = xuo->flags & ~XFRM_OFFLOAD_IPV6;
 
 	err = dev->xfrmdev_ops->xdo_dev_state_add(x);
 	if (err) {
-- 
2.34.1

