Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75703609292
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 14:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbiJWMGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 08:06:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiJWMGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 08:06:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00AB458B4B
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 05:06:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D43CB80B51
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 12:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDCF5C43148;
        Sun, 23 Oct 2022 12:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666526788;
        bh=y1hEzzMV9eK0WTR2Isz/Tv4PO0UwnikO/Pt42xPlypo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EeGtxzuj8IA9yE7tOweWNk6e1SuiEXouRkMK5IRtB8L1luQlSbXoi5OlQQr7mHwWB
         8SwYUm8OyL8FTuMlE7ElLp3JPFps3AQyhye8cvMnVUlhldveq+ytCCzaj2VxeHAehp
         VXKI6uITde/VAETp4YCYj+cHNBLMk7VUpo01dTHhYXi9ddYmbsO1ZthkJo94Fth0QT
         8s7VvN+sIEfPhHIOtCX1YkKHKIZ8yHWgswjSzZCcscXMcmUAWW7QbDvLt/AWSSGDEz
         E4XMz74B3bc+dCQNMUX+yXxcMbgN7PtlNFNwmWLJwGm3RkDUoN1rfWjQx6EwLU3dkM
         /ljdQIYM6Iokw==
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Bharat Bhushan <bbhushan2@marvell.com>
Subject: [PATCH xfrm-next v5 6/8] xfrm: Speed-up lookup of HW policies
Date:   Sun, 23 Oct 2022 15:05:58 +0300
Message-Id: <09577c71179027f7ffb99bace5a4608e7e857c82.1666525321.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <cover.1666525321.git.leonro@nvidia.com>
References: <cover.1666525321.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Devices that implement IPsec full offload mode should offload policies
too. In RX path, it causes to the situation that HW will always have
higher priority over any SW policies.

It means that we don't need to perform any search of inexact policies
and/or priority checks if HW policy was discovered. In such situation,
the HW will catch the packets anyway and HW can still implement inexact
lookups.

In case specific policy is not found, we will continue with full lookup and
check for existence of HW policies in inexact list.

HW policies are added to the head of SPD to ensure fast lookup, as XFRM
iterates over all policies in the loop.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 net/xfrm/xfrm_policy.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index b07ed169f501..aa73e630aef5 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1562,9 +1562,12 @@ static struct xfrm_policy *xfrm_policy_insert_list(struct hlist_head *chain,
 			break;
 	}
 
-	if (newpos)
+	if (newpos && policy->xdo.type != XFRM_DEV_OFFLOAD_FULL)
 		hlist_add_behind_rcu(&policy->bydst, &newpos->bydst);
 	else
+		/* Full offload policies are enteded
+		 * to the head to speed-up lookups.
+		 */
 		hlist_add_head_rcu(&policy->bydst, chain);
 
 	return delpol;
@@ -2180,6 +2183,9 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 			break;
 		}
 	}
+	if (!ret && ret->xdo.type == XFRM_DEV_OFFLOAD_FULL)
+		goto skip_inexact;
+
 	bin = xfrm_policy_inexact_lookup_rcu(net, type, family, dir, if_id);
 	if (!bin || !xfrm_policy_find_inexact_candidates(&cand, bin, saddr,
 							 daddr))
-- 
2.37.3

