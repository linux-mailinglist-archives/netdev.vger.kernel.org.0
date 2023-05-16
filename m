Return-Path: <netdev+bounces-2853-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B609F7044AC
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 07:25:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B699F1C20D73
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 05:25:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8A8319E73;
	Tue, 16 May 2023 05:24:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE03E1DDC9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 05:24:14 +0000 (UTC)
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E75830C3
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 22:24:13 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by a.mx.secunet.com (Postfix) with ESMTP id A0DD0206BC;
	Tue, 16 May 2023 07:24:10 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
	by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sMVSv2e5eFUX; Tue, 16 May 2023 07:24:10 +0200 (CEST)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by a.mx.secunet.com (Postfix) with ESMTPS id 56B85207A5;
	Tue, 16 May 2023 07:24:09 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
	by mailout1.secunet.com (Postfix) with ESMTP id 51B4780004A;
	Tue, 16 May 2023 07:24:09 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 16 May 2023 07:24:09 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.23; Tue, 16 May
 2023 07:24:08 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
	id C4F563182CA3; Tue, 16 May 2023 07:24:07 +0200 (CEST)
From: Steffen Klassert <steffen.klassert@secunet.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
CC: Herbert Xu <herbert@gondor.apana.org.au>, Steffen Klassert
	<steffen.klassert@secunet.com>, <netdev@vger.kernel.org>
Subject: [PATCH 5/7] xfrm: Reject optional tunnel/BEET mode templates in outbound policies
Date: Tue, 16 May 2023 07:24:03 +0200
Message-ID: <20230516052405.2677554-6-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230516052405.2677554-1-steffen.klassert@secunet.com>
References: <20230516052405.2677554-1-steffen.klassert@secunet.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Tobias Brunner <tobias@strongswan.org>

xfrm_state_find() uses `encap_family` of the current template with
the passed local and remote addresses to find a matching state.
If an optional tunnel or BEET mode template is skipped in a mixed-family
scenario, there could be a mismatch causing an out-of-bounds read as
the addresses were not replaced to match the family of the next template.

While there are theoretical use cases for optional templates in outbound
policies, the only practical one is to skip IPComp states in inbound
policies if uncompressed packets are received that are handled by an
implicitly created IPIP state instead.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Tobias Brunner <tobias@strongswan.org>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
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


