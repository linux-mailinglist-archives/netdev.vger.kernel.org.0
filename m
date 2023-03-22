Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58D6B6C5551
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbjCVT5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjCVT5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:57:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E8462B6B;
        Wed, 22 Mar 2023 12:56:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFCF8B81DE7;
        Wed, 22 Mar 2023 19:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40798C433EF;
        Wed, 22 Mar 2023 19:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679515002;
        bh=3aVYDWmzpbb9KN/Q4bFfppLaKmIbQSdRnvS68o5FyZI=;
        h=From:To:Cc:Subject:Date:From;
        b=NiC5xhnHhmgBtWF+wklFpCueBln3wmpv8Khlb2RTXy2s/XXUhKDQaLOL/MR3ozidg
         Q4s2ztPn6wMpv1nKInAvbiB35ZjBoqGhirNw9TU1xrQAYjCJsm+ieZsj2Gpk9N2YEl
         UG84kNpEcIBA6m1NnV9hHOKqxwpvgkSVZlTI8/vtYuaDl6OfeOATrvZ5PORG5w9k9R
         bqxKx0XFnRBllmh3XmX7Bl13BI9ls+NkReVwLhOnguQ7qoyqFLX1HsZ5f9zprQBJ18
         RjEJ1VkkcYaO4H/EvvJp1r7/zasKTg/oYNoGcMEPMltidsY5Jc280BYMDsLni9AV6j
         RbmmDF0dEO9Vg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        syzbot+fa5414772d5c445dac3c@syzkaller.appspotmail.com,
        Hyunwoo Kim <v4bel@theori.io>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 01/45] xfrm: Zero padding when dumping algos and encap
Date:   Wed, 22 Mar 2023 15:55:55 -0400
Message-Id: <20230322195639.1995821-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Herbert Xu <herbert@gondor.apana.org.au>

[ Upstream commit 8222d5910dae08213b6d9d4bc9a7f8502855e624 ]

When copying data to user-space we should ensure that only valid
data is copied over.  Padding in structures may be filled with
random (possibly sensitve) data and should never be given directly
to user-space.

This patch fixes the copying of xfrm algorithms and the encap
template in xfrm_user so that padding is zeroed.

Reported-by: syzbot+fa5414772d5c445dac3c@syzkaller.appspotmail.com
Reported-by: Hyunwoo Kim <v4bel@theori.io>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 45 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index cf5172d4ce68c..103af2b3e986f 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1012,7 +1012,9 @@ static int copy_to_user_aead(struct xfrm_algo_aead *aead, struct sk_buff *skb)
 		return -EMSGSIZE;
 
 	ap = nla_data(nla);
-	memcpy(ap, aead, sizeof(*aead));
+	strscpy_pad(ap->alg_name, aead->alg_name, sizeof(ap->alg_name));
+	ap->alg_key_len = aead->alg_key_len;
+	ap->alg_icv_len = aead->alg_icv_len;
 
 	if (redact_secret && aead->alg_key_len)
 		memset(ap->alg_key, 0, (aead->alg_key_len + 7) / 8);
@@ -1032,7 +1034,8 @@ static int copy_to_user_ealg(struct xfrm_algo *ealg, struct sk_buff *skb)
 		return -EMSGSIZE;
 
 	ap = nla_data(nla);
-	memcpy(ap, ealg, sizeof(*ealg));
+	strscpy_pad(ap->alg_name, ealg->alg_name, sizeof(ap->alg_name));
+	ap->alg_key_len = ealg->alg_key_len;
 
 	if (redact_secret && ealg->alg_key_len)
 		memset(ap->alg_key, 0, (ealg->alg_key_len + 7) / 8);
@@ -1043,6 +1046,40 @@ static int copy_to_user_ealg(struct xfrm_algo *ealg, struct sk_buff *skb)
 	return 0;
 }
 
+static int copy_to_user_calg(struct xfrm_algo *calg, struct sk_buff *skb)
+{
+	struct nlattr *nla = nla_reserve(skb, XFRMA_ALG_COMP, sizeof(*calg));
+	struct xfrm_algo *ap;
+
+	if (!nla)
+		return -EMSGSIZE;
+
+	ap = nla_data(nla);
+	strscpy_pad(ap->alg_name, calg->alg_name, sizeof(ap->alg_name));
+	ap->alg_key_len = 0;
+
+	return 0;
+}
+
+static int copy_to_user_encap(struct xfrm_encap_tmpl *ep, struct sk_buff *skb)
+{
+	struct nlattr *nla = nla_reserve(skb, XFRMA_ENCAP, sizeof(*ep));
+	struct xfrm_encap_tmpl *uep;
+
+	if (!nla)
+		return -EMSGSIZE;
+
+	uep = nla_data(nla);
+	memset(uep, 0, sizeof(*uep));
+
+	uep->encap_type = ep->encap_type;
+	uep->encap_sport = ep->encap_sport;
+	uep->encap_dport = ep->encap_dport;
+	uep->encap_oa = ep->encap_oa;
+
+	return 0;
+}
+
 static int xfrm_smark_put(struct sk_buff *skb, struct xfrm_mark *m)
 {
 	int ret = 0;
@@ -1098,12 +1135,12 @@ static int copy_to_user_state_extra(struct xfrm_state *x,
 			goto out;
 	}
 	if (x->calg) {
-		ret = nla_put(skb, XFRMA_ALG_COMP, sizeof(*(x->calg)), x->calg);
+		ret = copy_to_user_calg(x->calg, skb);
 		if (ret)
 			goto out;
 	}
 	if (x->encap) {
-		ret = nla_put(skb, XFRMA_ENCAP, sizeof(*x->encap), x->encap);
+		ret = copy_to_user_encap(x->encap, skb);
 		if (ret)
 			goto out;
 	}
-- 
2.39.2

