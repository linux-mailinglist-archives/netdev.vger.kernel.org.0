Return-Path: <netdev+bounces-560-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F1E306F8223
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 13:36:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 47C811C216B2
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 11:36:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 844916FAE;
	Fri,  5 May 2023 11:36:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726491FAB
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 11:36:22 +0000 (UTC)
X-Greylist: delayed 4800 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 05 May 2023 04:36:20 PDT
Received: from mail.codelabs.ch (mail.codelabs.ch [109.202.192.35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C26E61BF
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 04:36:20 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.codelabs.ch (Postfix) with ESMTP id E9371220003;
	Fri,  5 May 2023 13:36:18 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
	by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DtohbODggEv4; Fri,  5 May 2023 13:36:16 +0200 (CEST)
Received: from [IPV6:2a01:8b81:5400:f500:5a14:752d:ad56:7b58] (unknown [IPv6:2a01:8b81:5400:f500:5a14:752d:ad56:7b58])
	by mail.codelabs.ch (Postfix) with ESMTPSA id 65C92220002;
	Fri,  5 May 2023 13:36:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=strongswan.org;
	s=default; t=1683286576;
	bh=sgfbc8tbS1FLvNiLwdeQhT6ijGOpFmRlwdgHqVZ5PTM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SmhpKfQp6WdxXl3OEX6OgDIzp2YQQydLDfbMDAcwz5ac2Ls/PmiMsxtBRcTv6K5tU
	 oIDiu2mVVHVNY42QVmmimWI/wrHLnmmahXceZqwqrTndvMwO5D2G7kF1Vw7aCfEt0w
	 3L9/5f2gc3Oo98QFzydzaFF7XoFFEqxLmAtFboJNyg6htSqWe4QI6sNaYnlHxrb6YK
	 WYxiq9iZbui7NL8MGr1t+D0ByTjvaH47DyqgAa63klokxCKcO/WuHVX2ZfSQ0vuoRC
	 Ky5w6lTLsDTsPkfqKc5i/s9OIRnIrQEAxQ0Au2Ur3UvACjh1RLLTOLAl+NPiV2s1ha
	 1CeVybFOw/UKA==
Message-ID: <46fcb205-989e-4ea7-463d-e72b85db9e71@strongswan.org>
Date: Fri, 5 May 2023 13:36:15 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: [PATCH ipsec] af_key: Reject optional tunnel/BEET mode templates in
 outbound policies
Content-Language: en-US, de-CH-frami
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org,
 "David S . Miller" <davem@davemloft.net>
References: <6dcb6a58-2699-9cde-3e34-57c142dbcf14@strongswan.org>
 <ZEdmdDAwnuslrdvA@gondor.apana.org.au>
 <8b8dbbc4-f956-8cbf-3700-1da366357a6f@strongswan.org>
 <ZEePE9LMA0pWxz9r@gondor.apana.org.au>
 <5d5bf4d9-5b63-ae0d-2f65-770e911ea7d6@strongswan.org>
 <ZFTd459F8fi+KfxM@gondor.apana.org.au>
From: Tobias Brunner <tobias@strongswan.org>
In-Reply-To: <ZFTd459F8fi+KfxM@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

xfrm_state_find() uses `encap_family` of the current template with
the passed local and remote addresses to find a matching state.
If an optional tunnel or BEET mode template is skipped in a mixed-family
scenario, there could be a mismatch causing an out-of-bounds read as
the addresses were not replaced to match the family of the next template.

While there are theoretical use cases for optional templates in outbound
policies, the only practical one is to skip IPComp states in inbound
policies if uncompressed packets are received that are handled by an
implicitly created IPIP state instead.

Signed-off-by: Tobias Brunner <tobias@strongswan.org>
---
  net/key/af_key.c | 12 ++++++++----
  1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/key/af_key.c b/net/key/af_key.c
index a815f5ab4c49..31ab12fd720a 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -1940,7 +1940,8 @@ static u32 gen_reqid(struct net *net)
  }
  
  static int
-parse_ipsecrequest(struct xfrm_policy *xp, struct sadb_x_ipsecrequest *rq)
+parse_ipsecrequest(struct xfrm_policy *xp, struct sadb_x_policy *pol,
+		   struct sadb_x_ipsecrequest *rq)
  {
  	struct net *net = xp_net(xp);
  	struct xfrm_tmpl *t = xp->xfrm_vec + xp->xfrm_nr;
@@ -1958,9 +1959,12 @@ parse_ipsecrequest(struct xfrm_policy *xp, struct sadb_x_ipsecrequest *rq)
  	if ((mode = pfkey_mode_to_xfrm(rq->sadb_x_ipsecrequest_mode)) < 0)
  		return -EINVAL;
  	t->mode = mode;
-	if (rq->sadb_x_ipsecrequest_level == IPSEC_LEVEL_USE)
+	if (rq->sadb_x_ipsecrequest_level == IPSEC_LEVEL_USE) {
+		if ((mode == XFRM_MODE_TUNNEL || mode == XFRM_MODE_BEET) &&
+		    pol->sadb_x_policy_dir == IPSEC_DIR_OUTBOUND)
+			return -EINVAL;
  		t->optional = 1;
-	else if (rq->sadb_x_ipsecrequest_level == IPSEC_LEVEL_UNIQUE) {
+	} else if (rq->sadb_x_ipsecrequest_level == IPSEC_LEVEL_UNIQUE) {
  		t->reqid = rq->sadb_x_ipsecrequest_reqid;
  		if (t->reqid > IPSEC_MANUAL_REQID_MAX)
  			t->reqid = 0;
@@ -2002,7 +2006,7 @@ parse_ipsecrequests(struct xfrm_policy *xp, struct sadb_x_policy *pol)
  		    rq->sadb_x_ipsecrequest_len < sizeof(*rq))
  			return -EINVAL;
  
-		if ((err = parse_ipsecrequest(xp, rq)) < 0)
+		if ((err = parse_ipsecrequest(xp, pol, rq)) < 0)
  			return err;
  		len -= rq->sadb_x_ipsecrequest_len;
  		rq = (void*)((u8*)rq + rq->sadb_x_ipsecrequest_len);
-- 
2.34.1



