Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13FB552C8A3
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 02:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbiESAeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 20:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231816AbiESAeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 20:34:15 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8081666B4
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 17:34:14 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-2dc7bdd666fso32813237b3.7
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 17:34:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=jgBF5LixOPUxJaANXyNBggtsVV+vN23+liIB/dpceXw=;
        b=pS8PIobVrWzoXORlBAkd7Q8LSYrr3/6MX21ZsNDD3c4DcqudmlHaB65Y5XwMNKL8Km
         vcZSDJvGHChFAN4OO3EqHz5Qr7T2S39xkvjlkYWnSer5+Z/D0rNzF7Zak4zrGhZx+dJ7
         nZMhEag2CXiPcHgB+ybU0C3Cp9zyQveOkZgvQ95y8ZOztteXIGHF7zisIayvgWdP4feL
         vVvaAUCojTf06a4Wia3/dgAItglEfXP3z2sWpd6TQ+DgWvfXVhbhbGai21i4V/o9EIAX
         PXbeW9Kj3g9KA5P/nOvPf+jOFAFTshCvQwI4rV8I0LxWJlD79so6Pc53lGw7MUuxbEjw
         qREg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=jgBF5LixOPUxJaANXyNBggtsVV+vN23+liIB/dpceXw=;
        b=yhM2CPYvzkWlu3SFkfbuJJLdguMSSf6z7y5OvdCZcDrhc29phrBE1pTctF6zsPqgyM
         6zDNDmV7y0701DCihhvr047iADsR5ZRC9jN5v9HH4q5LgWsvluSpgw7TopCjhqS6l0GA
         Eca0z/9nr+PL9UE9lGqgxPTKw9+NQzm8MR4vW3IZISmE+nH9HjSoW1UQT2+VK0Gk9iLI
         yWcf5G0epJNFHEKNkKiM4Jzmy+ZhVKB8V3arEXhCjDoUyqw5bnCTfoO4R9IAbCSXqb2Y
         rtrIzw+kMSnhLE7vCVRXFblcnYErD+gpJm0bGYtrCMMefBX7lS9pVE2YaSpJwDVlZjRK
         JbBQ==
X-Gm-Message-State: AOAM531rZrR18g9iSMPDw+7ShfAMvJ408jgEegiVJUqBA9XPcqUpJyZl
        3xPwu4AgsY+oqA/iMPvlX1jwvneB7K8=
X-Google-Smtp-Source: ABdhPJyq0T4hI3tK9gf34uaORQsOtqiMEdn14V+FxWYbXDzRHQgLtfOwbOSIhylpxPaYD5TGiJLuMv28hcM=
X-Received: from ycheng.svl.corp.google.com ([2620:15c:2c4:201:6c:627f:da62:44e])
 (user=ycheng job=sendgmr) by 2002:a81:138a:0:b0:2ff:59da:4aa1 with SMTP id
 132-20020a81138a000000b002ff59da4aa1mr1973103ywt.212.1652920453670; Wed, 18
 May 2022 17:34:13 -0700 (PDT)
Date:   Wed, 18 May 2022 17:34:10 -0700
Message-Id: <20220519003410.2531936-1-ycheng@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.36.1.124.g0e6072fb45-goog
Subject: [PATCH net-next] tcp: improve PRR loss recovery
From:   Yuchung Cheng <ycheng@google.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com,
        Yuchung Cheng <ycheng@google.com>
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

This patch improves TCP PRR loss recovery behavior for a corner
case. Previously during PRR conservation-bound mode, it strictly
sends the amount equals to the amount newly acked or s/acked.

The patch changes s.t. PRR may send additional amount that was banked
previously (e.g. application-limited) in the conservation-bound
mode, similar to the slow-start mode. This unifies and simplifies the
algorithm further and may improve the recovery latency. This change
still follow the general packet conservation design principle and
always keep inflight/cwnd below the slow start threshold set
by the congestion control module.

PRR is described in RFC 6937. We'll include this change in the
latest revision rfc6937-bis as well.

Reported-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/tcp_input.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 97cfcd85f84e..3231af73e430 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2620,12 +2620,12 @@ void tcp_cwnd_reduction(struct sock *sk, int newly_acked_sacked, int newly_lost,
 		u64 dividend = (u64)tp->snd_ssthresh * tp->prr_delivered +
 			       tp->prior_cwnd - 1;
 		sndcnt = div_u64(dividend, tp->prior_cwnd) - tp->prr_out;
-	} else if (flag & FLAG_SND_UNA_ADVANCED && !newly_lost) {
-		sndcnt = min_t(int, delta,
-			       max_t(int, tp->prr_delivered - tp->prr_out,
-				     newly_acked_sacked) + 1);
 	} else {
-		sndcnt = min(delta, newly_acked_sacked);
+		sndcnt = max_t(int, tp->prr_delivered - tp->prr_out,
+			       newly_acked_sacked);
+		if (flag & FLAG_SND_UNA_ADVANCED && !newly_lost)
+			sndcnt++;
+		sndcnt = min(delta, sndcnt);
 	}
 	/* Force a fast retransmit upon entering fast recovery */
 	sndcnt = max(sndcnt, (tp->prr_out ? 0 : 1));
-- 
2.36.1.124.g0e6072fb45-goog

