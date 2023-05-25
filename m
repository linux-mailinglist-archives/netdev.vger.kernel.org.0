Return-Path: <netdev+bounces-5461-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 404A071150E
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:44:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F38F41C20FDB
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:44:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAF6723D62;
	Thu, 25 May 2023 18:44:02 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0516A23D5D
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA752C433D2;
	Thu, 25 May 2023 18:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685040240;
	bh=HVX1TG+Qa3cHR0WeqERurokfZJdHcyOndIbduqxdvnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rB0QsqSOWDVCiJZsW61taA0eSQPv6hLVHSTmeeDFNT0CBMB2t4CkQ6QSgzMEWy9Jr
	 f3ZXI91DiukW+sSwc0MwplWnxMsWkrkJk0PsbkYgvKOtEDchAl1HttwygEbzKDFslL
	 iVoHXbSnqzBL8Pya3bXiXSsHhP+YMfiCpbAWemLwdE1F1iqc+fRSwYe8UKOXPT1lFR
	 JUX3gsQyeCub1FW0Qdd1PTyMId5jcFUD5Ea6ZodOBmUV2e9W55/uELW7ZwMHqvNVoh
	 cE1EjTrkZCcz92edLR7YHf7/62d51PDah9kET9APWfuUb91bgGeuBwYRJoxx76mNKL
	 VqSbyPmXr6rQg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Benedict Wong <benedictwong@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/27] xfrm: Check if_id in inbound policy/secpath match
Date: Thu, 25 May 2023 14:43:28 -0400
Message-Id: <20230525184356.1974216-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230525184356.1974216-1-sashal@kernel.org>
References: <20230525184356.1974216-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Benedict Wong <benedictwong@google.com>

[ Upstream commit 8680407b6f8f5fba59e8f1d63c869abc280f04df ]

This change ensures that if configured in the policy, the if_id set in
the policy and secpath states match during the inbound policy check.
Without this, there is potential for ambiguity where entries in the
secpath differing by only the if_id could be mismatched.

Notably, this is checked in the outbound direction when resolving
templates to SAs, but not on the inbound path when matching SAs and
policies.

Test: Tested against Android kernel unit tests & CTS
Signed-off-by: Benedict Wong <benedictwong@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 1cd21a8c4deac..6fe578773a51d 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2240,7 +2240,7 @@ xfrm_secpath_reject(int idx, struct sk_buff *skb, const struct flowi *fl)
 
 static inline int
 xfrm_state_ok(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x,
-	      unsigned short family)
+	      unsigned short family, u32 if_id)
 {
 	if (xfrm_state_kern(x))
 		return tmpl->optional && !xfrm_state_addr_cmp(tmpl, x, tmpl->encap_family);
@@ -2251,7 +2251,8 @@ xfrm_state_ok(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x,
 		(tmpl->allalgs || (tmpl->aalgos & (1<<x->props.aalgo)) ||
 		 !(xfrm_id_proto_match(tmpl->id.proto, IPSEC_PROTO_ANY))) &&
 		!(x->props.mode != XFRM_MODE_TRANSPORT &&
-		  xfrm_state_addr_cmp(tmpl, x, family));
+		  xfrm_state_addr_cmp(tmpl, x, family)) &&
+		(if_id == 0 || if_id == x->if_id);
 }
 
 /*
@@ -2263,7 +2264,7 @@ xfrm_state_ok(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x,
  */
 static inline int
 xfrm_policy_ok(const struct xfrm_tmpl *tmpl, const struct sec_path *sp, int start,
-	       unsigned short family)
+	       unsigned short family, u32 if_id)
 {
 	int idx = start;
 
@@ -2273,7 +2274,7 @@ xfrm_policy_ok(const struct xfrm_tmpl *tmpl, const struct sec_path *sp, int star
 	} else
 		start = -1;
 	for (; idx < sp->len; idx++) {
-		if (xfrm_state_ok(tmpl, sp->xvec[idx], family))
+		if (xfrm_state_ok(tmpl, sp->xvec[idx], family, if_id))
 			return ++idx;
 		if (sp->xvec[idx]->props.mode != XFRM_MODE_TRANSPORT) {
 			if (start == -1)
@@ -2450,7 +2451,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		 * are implied between each two transformations.
 		 */
 		for (i = xfrm_nr-1, k = 0; i >= 0; i--) {
-			k = xfrm_policy_ok(tpp[i], sp, k, family);
+			k = xfrm_policy_ok(tpp[i], sp, k, family, if_id);
 			if (k < 0) {
 				if (k < -1)
 					/* "-2 - errored_index" returned */
-- 
2.39.2


