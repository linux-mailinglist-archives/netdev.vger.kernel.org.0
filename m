Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81F675A03CF
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 00:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbiHXWNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 18:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiHXWNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 18:13:08 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52D17CB4B
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 15:13:05 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id i191-20020a6387c8000000b0042b44ad723bso401153pge.19
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 15:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=jb99RodiI+WU16IcT6CXLp9CnBkyr2LtMQhOPJ79YSg=;
        b=nUss7YRreV9GLEMCFtc39RiHCj7DKGc0PpHHP9vfCb8G5MHeh/G8HmDv0Lkj4Ht1Sf
         q0+rd3ZZCq5Vl0qElzGjsrALK0I+6cYmUJKVnw+JXOucWHDVVlkMAGXlFh+P29idpeCk
         ktDKk+p6ss8WYRC1riIG4x7b5G3cCILh/sM5Vm4cSMu3ded4RT5wwUFxQow2l2lAkeJ+
         h9KWRR0biZ/DKsihwspo4NiHxpozXtIiGXRIO261BtsfRFSq+Tu+rbCA+0+MEP8pgvhb
         Y0T/8Kita4cT9rCdV/Z22O1bR1ijpWg/hhbwqmx0Peb4H2SrEoLlo06LL76EWbajb+CM
         H8og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=jb99RodiI+WU16IcT6CXLp9CnBkyr2LtMQhOPJ79YSg=;
        b=i4DsIZdrL+TaZ46oDKQVxWT0kd2vHpvlJ8Z8YJ04JA894odR2UjgTFlVJ8jefzJq/i
         kbbeO9zQFb1ilBuGQTnOH7ZuUgoQqKqpMyisk7431t+yA7LVhxrn+uQL+guEGHno9prE
         U0xn2B+Ejl1dvQA9yOqlkHDZag6u138+mAbLGZMHRBvt3Q+QFfDZekIxA7/Ixzhm/q1p
         gGZqizTDLYmG1L62heybiwisAAHz0m34uqeJb3lL6xgCefazrpjyBsoQpLiWQ8V2rghd
         aIesD8AmhlNwGxMUsN5y3+JxH0PJ0PBDXuCm7L5oszwHUzL3xCBP3abbz19efqcCuh6f
         iBtw==
X-Gm-Message-State: ACgBeo2ZownQRiMU68LlopbBgy6bgKGBFMVkLPaLZd+d9BmvscoPkf8R
        gq6Iio/KmWCneDZ0QWYnxwm4JRjVL0h5obRszZo=
X-Google-Smtp-Source: AA6agR7skmm80CIcsY7zGmElnaP7RZWXtjdbpFgxlc6nm3guIrQ/iSnwXrJSxXC8uvXMDW5zySqh1Q4xndLa0j8ByR8=
X-Received: from obsessiveorange-c1.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3039])
 (user=benedictwong job=sendgmr) by 2002:a63:1e48:0:b0:429:e6ee:780d with SMTP
 id p8-20020a631e48000000b00429e6ee780dmr730253pgm.383.1661379185090; Wed, 24
 Aug 2022 15:13:05 -0700 (PDT)
Date:   Wed, 24 Aug 2022 22:12:51 +0000
In-Reply-To: <20220824221252.4130836-1-benedictwong@google.com>
Message-Id: <20220824221252.4130836-2-benedictwong@google.com>
Mime-Version: 1.0
References: <20220824221252.4130836-1-benedictwong@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v2 ipsec 1/2] xfrm: Skip checking of already-verified secpath entries
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
searchable, the policy checks must be done incrementally between each
decryption step. As such, this marks secpath entries as having been
successfully matched, skipping them (treating as optional) on subsequent
policy checks

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
---
 include/net/xfrm.h     |  1 +
 net/xfrm/xfrm_input.c  |  1 +
 net/xfrm/xfrm_policy.c | 13 ++++++++++++-
 3 files changed, 14 insertions(+), 1 deletion(-)

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
index 144238a50f3d..bcb9ee25474b 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -129,6 +129,7 @@ struct sec_path *secpath_set(struct sk_buff *skb)
 	memset(sp->ovec, 0, sizeof(sp->ovec));
 	sp->olen = 0;
 	sp->len = 0;
+	sp->verified_cnt = 0;
 
 	return sp;
 }
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index f1a0bab920a5..71a5beebb6a0 100644
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
 
@@ -3274,6 +3274,13 @@ xfrm_policy_ok(const struct xfrm_tmpl *tmpl, const struct sec_path *sp, int star
 		if (xfrm_state_ok(tmpl, sp->xvec[idx], family))
 			return ++idx;
 		if (sp->xvec[idx]->props.mode != XFRM_MODE_TRANSPORT) {
+			if (idx < sp->verified_cnt) {
+				/* Secpath entry previously verified, consider optional and
+				 * continue searching
+				 */
+				continue;
+			}
+
 			if (start == -1)
 				start = -2-idx;
 			break;
@@ -3650,6 +3657,8 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		 * Order is _important_. Later we will implement
 		 * some barriers, but at the moment barriers
 		 * are implied between each two transformations.
+		 * Upon success, marks secpath entries as having been verified to allow
+		 * them to be skipped in future policy checks (e.g. nested tunnels).
 		 */
 		for (i = xfrm_nr-1, k = 0; i >= 0; i--) {
 			k = xfrm_policy_ok(tpp[i], sp, k, family);
@@ -3668,6 +3677,8 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		}
 
 		xfrm_pols_put(pols, npols);
+		sp->verified_cnt = k;
+
 		return 1;
 	}
 	XFRM_INC_STATS(net, LINUX_MIB_XFRMINPOLBLOCK);
-- 
2.37.1.595.g718a3a8f04-goog

