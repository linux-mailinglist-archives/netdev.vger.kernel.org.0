Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 389695A03CE
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 00:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiHXWNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 18:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiHXWNI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 18:13:08 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BF247CB48
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 15:13:07 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id g9-20020a056a00078900b005366c5fa183so4703197pfu.12
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 15:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=KkXOj1eAFdHB09XnfhAhnxpQFu2dBzAT2cdxHUI+wa4=;
        b=Scd89i/3a8X4YRFLdmChMONptS08ykvcKagzisTN3cQZp0hv0DNrorhfuWwmYd8V10
         7ke/0FOMM6+w2QU4sSJJylFI6nQJoQ2OvVRnWDrkZekDH+fdf7AjyuUKV+8ZBJgDHsSA
         mfIIFO/vBVWARva5T43B1wJDBHG6BrljweNQbBDf+T6KOvqJMpaCw9F63Vz9anQuAGb6
         QXEWH7RMKPmfPdAGdMLVH4S+xtlRluoO/wBOkhuwwFF/uS73MfMvoJ/lS+I7SXvkN2RM
         RkQ6FTVZBas51RFfvdnsTM13xdbwSOX0Xy8oldABPmekzQe9LLS/0qpXZN82xVvhy/kN
         NFQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=KkXOj1eAFdHB09XnfhAhnxpQFu2dBzAT2cdxHUI+wa4=;
        b=xSGJpaSlXhDSoZoyaWT3oAksqdgVuUAz/E6MQ4boSaH3qsbDNMj5mBwx31LEMkwAT7
         IAQYVgkJaIAigx3LAlDVEOZQMchDtSMY5Cnd1B6Eb4ewjnt53zKL9HK9yOKGRTUW53Yz
         8iv5ldv5KQOPQ0/yIn9bGLQvMmoPm3Hl4uxPLeb0UPAC19T6zbuivFh0Wstkxrx7njU+
         vrv2wfXfYkyTHVgUojPvYjuA2hMyHv0+x1uBVEkosKYr0qsZdLyTPWpAK+KML8og52BJ
         FmPMgsHTLe4kkm3MVt/pwhIOwJfFuwmYwH2bz+51owNWgjYVv6QFIMgUuacObzMydR6f
         0Ciw==
X-Gm-Message-State: ACgBeo3mai+ZYW9t9yEkfLQ4d+19BPFCf+2GhVy4xv2tq3tbyq67KSRx
        +gkKPt6uFOxajXsfn1T5iiWenT9EWSL6zVPJfao=
X-Google-Smtp-Source: AA6agR5TXCEiHuCDKEptv8GBPiFIAYMjGofzhG9bb92VPj65Q72YNYpTSG0X/OhFibAs4znR7JYjwrLIsd9LD0uD67E=
X-Received: from obsessiveorange-c1.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3039])
 (user=benedictwong job=sendgmr) by 2002:a05:6a00:330b:b0:536:a88a:b4b8 with
 SMTP id cq11-20020a056a00330b00b00536a88ab4b8mr1106842pfb.22.1661379187015;
 Wed, 24 Aug 2022 15:13:07 -0700 (PDT)
Date:   Wed, 24 Aug 2022 22:12:52 +0000
In-Reply-To: <20220824221252.4130836-1-benedictwong@google.com>
Message-Id: <20220824221252.4130836-3-benedictwong@google.com>
Mime-Version: 1.0
References: <20220824221252.4130836-1-benedictwong@google.com>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
Subject: [PATCH v2 ipsec 2/2] xfrm: Ensure policy checked for nested ESP tunnels
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

This change ensures that all nested XFRM packets have their policy
checked before decryption of the next layer, so that policies are
verified at each intermediate step of the decryption process.

Notably, raw ESP/AH packets do not perform policy checks inherently,
whereas all other encapsulated packets (UDP, TCP encapsulated) do policy
checks after calling xfrm_input handling in the respective encapsulation
layer.

This is necessary especially for nested tunnels, as the IP addresses,
protocol and ports may all change, thus not matching the previous
policies. In order to ensure that packets match the relevant inbound
templates, the xfrm_policy_check should be done before handing off to
the inner XFRM protocol to decrypt and decapsulate.

In order to prevent double-checking packets both here and in the
encapsulation layers, this check is currently limited to nested
tunnel-mode transforms and checked prior to decapsulation of inner
tunnel layers (prior to hitting a nested tunnel's xfrm_input, there
is no great way to detect a nested tunnel). This is primarily a
performance consideration, as a general blanket check at the end of
xfrm_input would suffice, but may result in multiple policy checks.

Test: Tested against Android Kernel Unit Tests
Signed-off-by: Benedict Wong <benedictwong@google.com>
---
 net/xfrm/xfrm_input.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index bcb9ee25474b..a3b55d109836 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -586,6 +586,20 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			goto drop;
 		}
 
+		/* If nested tunnel, check outer states before context is lost.
+		 * Only nested tunnels need to be checked, since IP addresses change
+		 * as a result of the tunnel mode decapsulation. Similarly, this check
+		 * is limited to nested tunnels to avoid performing another policy
+		 * check on non-nested tunnels. On success, this check also updates the
+		 * secpath's verified_cnt variable, skipping future verifications of
+		 * previously-verified secpath entries.
+		 */
+		if ((x->outer_mode.flags & XFRM_MODE_FLAG_TUNNEL) &&
+		    sp->verified_cnt < sp->len &&
+		    !xfrm_policy_check(NULL, XFRM_POLICY_IN, skb, family)) {
+			goto drop;
+		}
+
 		skb->mark = xfrm_smark_get(skb->mark, x);
 
 		sp->xvec[sp->len++] = x;
-- 
2.37.1.595.g718a3a8f04-goog

