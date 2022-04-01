Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E8A4EFA39
	for <lists+netdev@lfdr.de>; Fri,  1 Apr 2022 20:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351447AbiDATAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Apr 2022 15:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241935AbiDATAb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Apr 2022 15:00:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA16964D0
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 11:58:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CDFD614F9
        for <netdev@vger.kernel.org>; Fri,  1 Apr 2022 18:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D408C2BBE4;
        Fri,  1 Apr 2022 18:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648839519;
        bh=SwLUjluPBxgTPt6SbAvhhtI+EBfSOUIjsKZh4LXqAiA=;
        h=From:To:Cc:Subject:Date:From;
        b=TTPGOHBit418hNFkf3xP6x1KMixfg+vh6lEVwC0Jp5J7HdoJEEU9DkiJjtrVOnNEv
         lfNAnYmQ6ZZ7kAFREc8bk3FWym9cTE2zaolgNfSynySD4LQJBN+D+DVurRB4Oo/Ge6
         FHCJaM7aV6J8K1/ZJMGn1gQUU02mKTq01sLZ3mbu5XPDjcb+m32/mQj+a3li4GUfGx
         Q4OMc9XSOhUEkWsYuxrpX/MI+eTvS89jS5QCJwpSNt6YC5ozi0eaB5uE4Rh6ifaNmD
         0XngPbW8CsFvpWCrp+6PvQB7mBCerVvaL2p+VQgB8uo8FCkwiJHXUHMg56+WKNJSMj
         l4Fux75YSutcA==
From:   David Ahern <dsahern@kernel.org>
To:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        pabeni@redhat.com
Cc:     oliver.sang@intel.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, David Ahern <dsahern@kernel.org>
Subject: [PATCH net] xfrm: Pass flowi_oif or l3mdev as oif to xfrm_dst_lookup
Date:   Fri,  1 Apr 2022 12:58:37 -0600
Message-Id: <20220401185837.40626-1-dsahern@kernel.org>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
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

The commit referenced in the Fixes tag no longer changes the
flow oif to the l3mdev ifindex. A xfrm use case was expecting
the flowi_oif to be the VRF if relevant and the change broke
that test. Update xfrm_bundle_create to pass oif if set and any
potential flowi_l3mdev if oif is not set.

Fixes: 40867d74c374 ("net: Add l3mdev index to flow struct and avoid oif reset for port devices")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
---
 net/xfrm/xfrm_policy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 19aa994f5d2c..00bd0ecff5a1 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2593,12 +2593,14 @@ static struct dst_entry *xfrm_bundle_create(struct xfrm_policy *policy,
 
 		if (xfrm[i]->props.mode != XFRM_MODE_TRANSPORT) {
 			__u32 mark = 0;
+			int oif;
 
 			if (xfrm[i]->props.smark.v || xfrm[i]->props.smark.m)
 				mark = xfrm_smark_get(fl->flowi_mark, xfrm[i]);
 
 			family = xfrm[i]->props.family;
-			dst = xfrm_dst_lookup(xfrm[i], tos, fl->flowi_oif,
+			oif = fl->flowi_oif ? : fl->flowi_l3mdev;
+			dst = xfrm_dst_lookup(xfrm[i], tos, oif,
 					      &saddr, &daddr, family, mark);
 			err = PTR_ERR(dst);
 			if (IS_ERR(dst))
-- 
2.24.3 (Apple Git-128)

