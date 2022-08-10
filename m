Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDAF58F23F
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 20:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232237AbiHJSWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 14:22:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbiHJSWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 14:22:20 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A403C79A66
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 11:22:17 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-329a474c437so81379557b3.18
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 11:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:from:to:cc;
        bh=gdupFrKwqrxy2D6s4J2QLDd44V5Ti3d3q1x7ctQNM3I=;
        b=mHmAwK/RupMIv/t9H7K4pTOueZ8vvl7JOX/NwxQsHj2sgfZezNrma5Y2Fo28qjsqmx
         Q8Ug3pv2ZDkSdUus80ZZjRQxdIFEOZNMR7SmVhL7PkD5qLY6NzH2gvXKnip2a/EsmEJ3
         5W0HY7Qc8iCRS5FfLYvvdnnyO6ibLGaA6ryw8J/GwpaMUWlELbLHgzYwlt+OxcNwnCyG
         uDvBFjB4hpfi9U2wcdHWSb+Cg9XDuZw0VrHKd+E/AFMIuhA4UPGSHbLoaBOPM0mq7HvF
         AuYzy211SpNU4lVNSK4+VN3AXSSSyfWjROSvoZp5rKwM9anNS2dCG9i/ceGqf6pV8fxp
         zb5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc;
        bh=gdupFrKwqrxy2D6s4J2QLDd44V5Ti3d3q1x7ctQNM3I=;
        b=y1pnpv76w8N9RUNNoJxX2DYem8wgIGVdK8x+2EHtrdnh3LjjFAteSNuALKkz0nCUbL
         Tf4Qkjj8JSGP+Va7RaICnArAUH4OzJGCw/omBkOijx+d6jXcJqRtzA+7Jzvf47kEQYhW
         sSa8dBvJzeQlecC+89LeyoI8S3N67RA4hTTGewVbIpBNntK+/mpxGadR5LE9GaVyhHA2
         4Q7v18eZ9umiDKwMpFLqsefRzSXCoXD0FFyCbKBR81K3yvLyQh42K0WsRhLFD/wdpryT
         MaUTr1GOTgky42l5P8MOCVMvHL2BvIYDT8Wttpm6jEKDCUp+u9jNg9pyLSIJNLBvuvhr
         glLA==
X-Gm-Message-State: ACgBeo1yZNzl4X+cB+/5xa21ZGhM/1V1CUg6iFGbibEeLa+ZniL7uGFw
        VJH1Xk46TjdOi5gIGAMbJhXNTrqwM1EWARJT0EY=
X-Google-Smtp-Source: AA6agR4P9QMv5THo+I3soYiEoYYg1VWm9dX7Pk745IyEz4MXWLXZBChw8yt9wje1yXrK21K1DJBp6eR8GvoiwQ8WALg=
X-Received: from obsessiveorange-c1.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3039])
 (user=benedictwong job=sendgmr) by 2002:a81:4994:0:b0:31f:612f:e3b5 with SMTP
 id w142-20020a814994000000b0031f612fe3b5mr29813006ywa.99.1660155736977; Wed,
 10 Aug 2022 11:22:16 -0700 (PDT)
Reply-To: Benedict Wong <benedictwong@google.com>
Date:   Wed, 10 Aug 2022 18:22:10 +0000
In-Reply-To: <20220810182210.721493-1-benedictwong@google.com>
Message-Id: <20220810182210.721493-3-benedictwong@google.com>
Mime-Version: 1.0
References: <20220810182210.721493-1-benedictwong@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH ipsec 2/2] xfrm: Skip checking of already-verified secpath entries
From:   Benedict Wong <benedictwong@google.com>
To:     steffen.klassert@secunet.com, netdev@vger.kernel.org
Cc:     nharold@google.com, benedictwong@google.com, lorenzo@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change fixes a bug where inbound packets to nested IPsec tunnels
fails to pass policy checks due to the inner tunnel's policy checks
not having a reference to the outer policy/template. This causes the
policy check to fail, since the first entries in the secpath correlate
to the outer tunnel, while the templates being verified are for the
inner tunnel.

In order to ensure that the appropriate policy and template context is
searchable, the policy checks must be done incrementally after each
decryption step. As such, this marks secpath entries as having been
successfully matched, skipping these on subsequent policy checks.

By skipping the immediate error return in the case where the secpath
entry had previously been validated, this change allows secpath entries
that matched a policy/template previously, while still requiring that
each searched template find a match in the secpath.

For security:
- All templates must have matching secpath entries
  - Unchanged by current patch; templates that do not match any secpath
    entry still return -1. This patch simply allows skipping earlier
    blocks of verified secpath entries
- All entries (except trailing transport mode entries) must have a
  matching template
  - Unvalidated entries, including transport-mode entries still return
    the errored index if it does not match the correct template.

Test: Tested against Android Kernel Unit Tests
Signed-off-by: Benedict Wong <benedictwong@google.com>
Change-Id: Ic32831cb00151d0de2e465f18ec37d5f7b680e54
---
 include/net/xfrm.h     |  1 +
 net/xfrm/xfrm_input.c  |  3 ++-
 net/xfrm/xfrm_policy.c | 11 ++++++++++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index c39d910d4b45..a2f2840aba6b 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1031,6 +1031,7 @@ struct xfrm_offload {
 struct sec_path {
 	int			len;
 	int			olen;
+	int			verified_cnt;
 
 	struct xfrm_state	*xvec[XFRM_MAX_DEPTH];
 	struct xfrm_offload	ovec[XFRM_MAX_OFFLOAD_DEPTH];
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index b24df8a44585..895935077a91 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -129,6 +129,7 @@ struct sec_path *secpath_set(struct sk_buff *skb)
 	memset(sp->ovec, 0, sizeof(sp->ovec));
 	sp->olen = 0;
 	sp->len = 0;
+	sp->verified_cnt = 0;
 
 	return sp;
 }
@@ -587,7 +588,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 
 		// If nested tunnel, check outer states before context is lost.
 		if (x->outer_mode.flags & XFRM_MODE_FLAG_TUNNEL
-				&& sp->len > 0
+				&& sp->len > sp->verified_cnt
 				&& !xfrm_policy_check(NULL, XFRM_POLICY_IN, skb, family)) {
 			goto drop;
 		}
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index f1a0bab920a5..ee620a856c6f 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3261,7 +3261,7 @@ xfrm_state_ok(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x,
  */
 static inline int
 xfrm_policy_ok(const struct xfrm_tmpl *tmpl, const struct sec_path *sp, int start,
-	       unsigned short family)
+			   unsigned short family)
 {
 	int idx = start;
 
@@ -3274,6 +3274,11 @@ xfrm_policy_ok(const struct xfrm_tmpl *tmpl, const struct sec_path *sp, int star
 		if (xfrm_state_ok(tmpl, sp->xvec[idx], family))
 			return ++idx;
 		if (sp->xvec[idx]->props.mode != XFRM_MODE_TRANSPORT) {
+			if (idx < sp->verified_cnt) {
+				// Secpath entry previously verified, continue searching
+				continue;
+			}
+
 			if (start == -1)
 				start = -2-idx;
 			break;
@@ -3650,6 +3655,8 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		 * Order is _important_. Later we will implement
 		 * some barriers, but at the moment barriers
 		 * are implied between each two transformations.
+		 * Skips verifying secpath entries that have already been
+		 * verified in the past.
 		 */
 		for (i = xfrm_nr-1, k = 0; i >= 0; i--) {
 			k = xfrm_policy_ok(tpp[i], sp, k, family);
@@ -3668,6 +3675,8 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		}
 
 		xfrm_pols_put(pols, npols);
+		sp->verified_cnt = k;
+
 		return 1;
 	}
 	XFRM_INC_STATS(net, LINUX_MIB_XFRMINPOLBLOCK);
-- 
2.37.1.595.g718a3a8f04-goog

