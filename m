Return-Path: <netdev+bounces-540-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4798A6F80A6
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 12:16:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 82FBF1C2175D
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 10:16:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB95C79E6;
	Fri,  5 May 2023 10:16:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D8D3FC7
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 10:16:24 +0000 (UTC)
Received: from mail.codelabs.ch (mail.codelabs.ch [IPv6:2a02:168:860f:1::35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796F11161C
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 03:16:22 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by mail.codelabs.ch (Postfix) with ESMTP id 3806B220003;
	Fri,  5 May 2023 12:16:18 +0200 (CEST)
Received: from mail.codelabs.ch ([127.0.0.1])
	by localhost (fenrir.codelabs.ch [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bPttuwfKguDg; Fri,  5 May 2023 12:16:16 +0200 (CEST)
Received: from [IPV6:2a01:8b81:5400:f500:5a14:752d:ad56:7b58] (unknown [IPv6:2a01:8b81:5400:f500:5a14:752d:ad56:7b58])
	by mail.codelabs.ch (Postfix) with ESMTPSA id D59AC220002;
	Fri,  5 May 2023 12:16:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=strongswan.org;
	s=default; t=1683281776;
	bh=AbCK0NiqA7dqcjKE2/g8kj0mSnSFV+mBp8DceZmEb/c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LxcP/3LJs4bzJN04E3NBP6VsrQ+ws27N+RuHbnVPsMnfJWBo3SPmKJSti1/5hHX/D
	 Z0zzi2a4MaQe7hTipkv8yfo+l+3IY0fWRycAkcmKOZnn3vvQxAIYlm1oPPKfv2wrnh
	 n/szEI5oXVAgq0oaN4kw6EeMQEHTmgdJwDfH9MrRGoizuMygLgIp41V8QOGD/Bjc6b
	 jf5ZGOK87s/NEguWZaSeN8DfAmm7/e8FXPLUMvZrNx/XR4EqOm3SRDNdjMk9tjEQmd
	 fbnpUOZEECNJEevlpPhpFeBIkQU4Thnl+v2ZNV+oSCQuegE8of98T7L5D49DzCZ05T
	 tInEfCv97RgmA==
Message-ID: <5d5bf4d9-5b63-ae0d-2f65-770e911ea7d6@strongswan.org>
Date: Fri, 5 May 2023 12:16:16 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: [PATCH ipsec] xfrm: Reject optional tunnel/BEET mode templates in
 outbound policies
Content-Language: en-US, de-CH-frami
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, netdev@vger.kernel.org,
 "David S . Miller" <davem@davemloft.net>
References: <6dcb6a58-2699-9cde-3e34-57c142dbcf14@strongswan.org>
 <ZEdmdDAwnuslrdvA@gondor.apana.org.au>
 <8b8dbbc4-f956-8cbf-3700-1da366357a6f@strongswan.org>
 <ZEePE9LMA0pWxz9r@gondor.apana.org.au>
From: Tobias Brunner <tobias@strongswan.org>
In-Reply-To: <ZEePE9LMA0pWxz9r@gondor.apana.org.au>
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
  net/xfrm/xfrm_user.c | 14 +++++++++-----
  1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index af8fbcbfbe69..6794b9dea27a 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1768,7 +1768,7 @@ static void copy_templates(struct xfrm_policy *xp, struct xfrm_user_tmpl *ut,
  }
  
  static int validate_tmpl(int nr, struct xfrm_user_tmpl *ut, u16 family,
-			 struct netlink_ext_ack *extack)
+			 int dir, struct netlink_ext_ack *extack)
  {
  	u16 prev_family;
  	int i;
@@ -1794,6 +1794,10 @@ static int validate_tmpl(int nr, struct xfrm_user_tmpl *ut, u16 family,
  		switch (ut[i].mode) {
  		case XFRM_MODE_TUNNEL:
  		case XFRM_MODE_BEET:
+			if (ut[i].optional && dir == XFRM_POLICY_OUT) {
+				NL_SET_ERR_MSG(extack, "Mode in optional template not allowed in outbound policy");
+				return -EINVAL;
+			}
  			break;
  		default:
  			if (ut[i].family != prev_family) {
@@ -1831,7 +1835,7 @@ static int validate_tmpl(int nr, struct xfrm_user_tmpl *ut, u16 family,
  }
  
  static int copy_from_user_tmpl(struct xfrm_policy *pol, struct nlattr **attrs,
-			       struct netlink_ext_ack *extack)
+			       int dir, struct netlink_ext_ack *extack)
  {
  	struct nlattr *rt = attrs[XFRMA_TMPL];
  
@@ -1842,7 +1846,7 @@ static int copy_from_user_tmpl(struct xfrm_policy *pol, struct nlattr **attrs,
  		int nr = nla_len(rt) / sizeof(*utmpl);
  		int err;
  
-		err = validate_tmpl(nr, utmpl, pol->family, extack);
+		err = validate_tmpl(nr, utmpl, pol->family, dir, extack);
  		if (err)
  			return err;
  
@@ -1919,7 +1923,7 @@ static struct xfrm_policy *xfrm_policy_construct(struct net *net,
  	if (err)
  		goto error;
  
-	if (!(err = copy_from_user_tmpl(xp, attrs, extack)))
+	if (!(err = copy_from_user_tmpl(xp, attrs, p->dir, extack)))
  		err = copy_from_user_sec_ctx(xp, attrs);
  	if (err)
  		goto error;
@@ -3498,7 +3502,7 @@ static struct xfrm_policy *xfrm_compile_policy(struct sock *sk, int opt,
  		return NULL;
  
  	nr = ((len - sizeof(*p)) / sizeof(*ut));
-	if (validate_tmpl(nr, ut, p->sel.family, NULL))
+	if (validate_tmpl(nr, ut, p->sel.family, p->dir, NULL))
  		return NULL;
  
  	if (p->dir > XFRM_POLICY_OUT)
-- 
2.34.1



