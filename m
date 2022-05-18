Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DADCC52B1E9
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 07:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbiERFa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 01:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiERFaw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 01:30:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF204B45
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 22:30:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5E0D4B81D1B
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 05:30:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61A64C385A9;
        Wed, 18 May 2022 05:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652851847;
        bh=NgwaJRVBbD9LMlJNHoD0FohSksPTHWoCqnTJaCRo0mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PpPLFJ/lMhXqt1av5Wpt659ITrRmJ4WXmRuGkxxTuUy3sjCPJ+35oUtKMQ0f09Kx/
         J3C1zO1n4ScNjQf7OaBN57lBK3ocbUFlJK5E3hcvQ0bQaKimITJvArnCNcn2uj30aa
         Lv7ydh8vyYthND4K5kqIjsNjGeWh3DlPLW0ugx86xU2iLUrm/md4KZP3Ckmnd45bWO
         ceWcHb/uMTmB99uunOTnCOdTEsPhNeuDPbXMnHbnSRQcCFaSk2vqA+V6fKRlebwSp4
         ZnaXxlHggTFCi1eB2f1BlfQ4x5EXtG1Fb0IBPK7APTNwLDM7/uJs121GBxYCnIvyNV
         Ra5NaE7+RXVzA==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH ipsec-next v1 1/6] xfrm: add new full offload flag
Date:   Wed, 18 May 2022 08:30:21 +0300
Message-Id: <33ff013376bd29fd0320933bfe0f45fdc2835120.1652851393.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1652851393.git.leonro@nvidia.com>
References: <cover.1652851393.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 736c349de8bf..77e06e8208d8 100644
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
index 65e13a099b1a..9caec9b562e1 100644
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
index 35c7e89b2e7d..8eb100162863 100644
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
 		dev_put_track(dev, &xso->dev_tracker);
+		xso->type = XFRM_DEV_OFFLOAD_UNSPECIFIED;
 
 		if (err != -EOPNOTSUPP)
 			return err;
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 6a58fec6a1fb..0df71449abe9 100644
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
2.36.1

