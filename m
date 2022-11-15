Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5603C6293EF
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237881AbiKOJLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:11:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237882AbiKOJLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:11:12 -0500
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB164220C7
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:11:11 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-368e6c449f2so129312467b3.5
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 01:11:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IzTEGInsc651trn1H4eivMKji6foEGR4+N7CqOcQ3T8=;
        b=lGwe+6lwEiQlGp/jWFijhh3QcJd08W/LJl/piDQ+ZuLryzNE2eqwUQ4obk1dzN8O0C
         lSyuOhsaneuIzPOMDNRFmtKVhl7af/B0Yd8cbDm3hhHpWUqoBfnBpaOHCpzlJISYw4Pv
         QLadFkk7gG/oynzOiWLIm0InaJZuiczzsM4tlLEPkRvfoMVJxn7RoTopInfCo84W6w8m
         aKYxROC4hrRx8EC+78yucZF+VRhYY4QqaFAxqXqF0djT9CKIb/vwq53tWXV5gLAax8sP
         uFFTKtMyqIcr6VbBOxouNVssEs7El9dgPGfxU4Zv+RbTZt+sDv1ZzTjhmr91oI+usLf3
         ES0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IzTEGInsc651trn1H4eivMKji6foEGR4+N7CqOcQ3T8=;
        b=gJbavJpzEa79pkqI9Knb2TS5gkOqIYWPMr0tKe/L9gWYROyOfLiMwZCFttyUqnL3UH
         0QJ4z0l87GHZmmiBCGJ3j3Mrf8l8udo2Z4Cnp+MXxnp3BmxWAvveYqhQ1iVp6lqpm5I2
         eugu7ZJcQq/mbIrWJKqmpzbYuNRPV5qY1PU9U0hGwcSTksL2G2tmUTKVVKEzPGQmKoy/
         Eb9HmsJZTs4i47Eks9VpemIDLJfBMllYCZs+NZJipSwT+o6BVFbX9peqxXndamUcn93Z
         vmQp6RCjI40mqKnemBICGcHCXEzz674ncWopngYIXJtg9zMcJW2IE6io1CLhP4MYNPXH
         dksA==
X-Gm-Message-State: ACrzQf06m+mg3B8IPTCNtEZyDSLTsZjpqB1bezaxXWbVMRtyfYA+q+xE
        j3onY7fbkEyYjeSH2H65sr18vcj4RsDJAg==
X-Google-Smtp-Source: AMsMyM4MBxsH1nQbav9mkjyf92C0Am6VF/DT/16xjtPhluXoX5eEcWD3zyHowGC87u8erRVEOS4rr3DdWnfmVQ==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a0d:f182:0:b0:370:7d9b:a54e with SMTP id
 a124-20020a0df182000000b003707d9ba54emr54734296ywf.133.1668503470497; Tue, 15
 Nov 2022 01:11:10 -0800 (PST)
Date:   Tue, 15 Nov 2022 09:10:59 +0000
In-Reply-To: <20221115091101.2234482-1-edumazet@google.com>
Mime-Version: 1.0
References: <20221115091101.2234482-1-edumazet@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221115091101.2234482-5-edumazet@google.com>
Subject: [PATCH net-next 4/6] net: adopt try_cmpxchg() in napi_schedule_prep()
 and napi_complete_done()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This makes the code slightly more efficient.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/dev.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 10b56648a9d4a0a709f8e23bb3e114854a4a1b69..0c12c7ad04f21da05fef4c60ca5570bff48ec491 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5979,10 +5979,9 @@ EXPORT_SYMBOL(__napi_schedule);
  */
 bool napi_schedule_prep(struct napi_struct *n)
 {
-	unsigned long val, new;
+	unsigned long new, val = READ_ONCE(n->state);
 
 	do {
-		val = READ_ONCE(n->state);
 		if (unlikely(val & NAPIF_STATE_DISABLE))
 			return false;
 		new = val | NAPIF_STATE_SCHED;
@@ -5995,7 +5994,7 @@ bool napi_schedule_prep(struct napi_struct *n)
 		 */
 		new |= (val & NAPIF_STATE_SCHED) / NAPIF_STATE_SCHED *
 						   NAPIF_STATE_MISSED;
-	} while (cmpxchg(&n->state, val, new) != val);
+	} while (!try_cmpxchg(&n->state, &val, new));
 
 	return !(val & NAPIF_STATE_SCHED);
 }
@@ -6063,9 +6062,8 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 		local_irq_restore(flags);
 	}
 
+	val = READ_ONCE(n->state);
 	do {
-		val = READ_ONCE(n->state);
-
 		WARN_ON_ONCE(!(val & NAPIF_STATE_SCHED));
 
 		new = val & ~(NAPIF_STATE_MISSED | NAPIF_STATE_SCHED |
@@ -6078,7 +6076,7 @@ bool napi_complete_done(struct napi_struct *n, int work_done)
 		 */
 		new |= (val & NAPIF_STATE_MISSED) / NAPIF_STATE_MISSED *
 						    NAPIF_STATE_SCHED;
-	} while (cmpxchg(&n->state, val, new) != val);
+	} while (!try_cmpxchg(&n->state, &val, new));
 
 	if (unlikely(val & NAPIF_STATE_MISSED)) {
 		__napi_schedule(n);
-- 
2.38.1.431.g37b22c650d-goog

