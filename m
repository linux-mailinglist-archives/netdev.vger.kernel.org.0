Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6183521255
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 12:37:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239932AbiEJKlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 06:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239960AbiEJKlP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 06:41:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD0F262657
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 03:37:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B74661794
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 10:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F69C385C6;
        Tue, 10 May 2022 10:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652179036;
        bh=RoxrUxn0E7WRJFGY1ju/uONbh/lxAqz9paDbP4cbDzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KwVh8GEA2mBpD9CcYbnA4B3fHf6n5NEK54sexodJ6XH3a0rmwJJf9Ol7fl1tEYXpd
         RlsOuOQPhD6LJtmA59F3Q5E4Z448UGGV/LHwa62fr+jBFodcvcyZcpZRZ9VfUZTo7t
         bfe/R+su3FHv5KVLhPvnA6N3xdg7dUh+aFQtd2zg5/c9vVMbkORotTsKisPt7IJsfk
         7KrEQnFBGob0zYXtufzRxl2ufLMTXAyefY2O9pZHh+IKgssdAujje2ZdCEZIqW8pYS
         ef3fUBLt5Zxh/xuYDnPqKFRBqFl2x/N2yRx28fhYyU1x7nvzjMugNj/YKEp267LtCS
         FTYdN26qaiX1w==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        ipsec-devel <devel@linux-ipsec.org>
Subject: [PATCH ipsec-next 4/6] xfrm: add TX datapath support for IPsec full offload mode
Date:   Tue, 10 May 2022 13:36:55 +0300
Message-Id: <905b8e8032d5cdb48ef63cb153fd86552c8a6a7d.1652176932.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1652176932.git.leonro@nvidia.com>
References: <cover.1652176932.git.leonro@nvidia.com>
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
2.35.1

