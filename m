Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2A5D52B1EF
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 07:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiERFba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 01:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230274AbiERFbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 01:31:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2D3A13E1D
        for <netdev@vger.kernel.org>; Tue, 17 May 2022 22:31:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61A10B81D1B
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 05:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D286DC385AA;
        Wed, 18 May 2022 05:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652851881;
        bh=sjXIWdqKbkceZEAaQ9sbXSesEHo/fxlSWvtamWGPcPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gl9fRC5uXCh/33LwrNzrdVqhF7ITO/qdhKbtflSS3ZE1s9y/30aDQJa26eL5T74rY
         mQN70kw+772ae1AENTEB11XRctzqgtws5AasRr8tza4iHs1+rgwoYqFYnpPAkpubAA
         HkXxf+roidZTF7rurQvqt8UZwYofUAmvsXfhhTSfWeDJ3f7oLnaTvaMwX4ZFFC10ET
         VLSKc9Q9voc5Cd/BS9xKgUvZ1AiXF8FvRGe58iqmWxHIfuKQEqSMia+VYHCvDIA7fQ
         qM+3JorX61f+ijdY5OHxDyVYSkDktzL+rxJvnAQ023Zye2GpdW2U8lRO1UlYhO/Mvm
         1TCIB/vRZwJ/g==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH ipsec-next v1 4/6] xfrm: add TX datapath support for IPsec full offload mode
Date:   Wed, 18 May 2022 08:30:24 +0300
Message-Id: <0a4d4dea1bbac084c2c26fe3d0e38edae9ffe6c8.1652851393.git.leonro@nvidia.com>
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

In IPsec full mode, the device is going to encrypt and encapsulate
packets that are associated with offloaded policy. After successful
policy lookup to indicate if packets should be offloaded or not,
the stack forwards packets to the device to do the magic.

Signed-off-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Huy Nguyen <huyn@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/xfrm/xfrm_output.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index d4935b3b9983..2599f3dbac08 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -718,6 +718,25 @@ int xfrm_output(struct sock *sk, struct sk_buff *skb)
 		break;
 	}
 
+	if (x->xso.type == XFRM_DEV_OFFLOAD_FULL) {
+		struct dst_entry *dst = skb_dst_pop(skb);
+
+		if (!dst) {
+			XFRM_INC_STATS(net, LINUX_MIB_XFRMOUTERROR);
+			return -EHOSTUNREACH;
+		}
+
+		skb_dst_set(skb, dst);
+		err = skb_dst(skb)->ops->local_out(net, skb->sk, skb);
+		if (unlikely(err != 1))
+			return err;
+
+		if (!skb_dst(skb)->xfrm)
+			return dst_output(net, skb->sk, skb);
+
+		return 0;
+	}
+
 	secpath_reset(skb);
 
 	if (xfrm_dev_offload_ok(skb, x)) {
-- 
2.36.1

