Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4605A607D31
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 19:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbiJURIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 13:08:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiJURIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 13:08:45 -0400
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA7D1290E28
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 10:08:31 -0700 (PDT)
Received: by mail-vk1-xa2a.google.com with SMTP id s185so1800120vkb.0
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 10:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lGxs4bTCNBes7JabdUp0rwsftiLD0AyYzTAgP+Q6IVo=;
        b=Yzipg2+XfV4mRdCEeQEHLNqKLmljtWWAFNUXjx+SMWcq7irrrLqvSqGz6/Hyp+XUo0
         gitMdcPap+KdSe5vYMO5poHh6/z2em4zgR0QOV0fj73+PRdqBIGQSW4hZr1gVtD7WYIg
         RZyOtVnhD9YXYH/PeLQmHsnW++D2rvqn3OLv/lD3zD7sVSc/yNdqKoq79W/GYrvzyPh6
         EsItS2uhqyiAuYbxLycsw73qpQAOCdyMc7WyI0c70SVrIwL/neP2hcJWUn3snW+WdzWO
         dhMVAttsevt/gmMBKnkbgsH7OpanwM4gJiuyUmbdWYGvl5O2LeyWfxQC7KWS3CLsnMoc
         toog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lGxs4bTCNBes7JabdUp0rwsftiLD0AyYzTAgP+Q6IVo=;
        b=ngA8ErgP/I+lKdPgStiadUmpDiWYGJXkJt4BWDzHA39uLuT6DaPSNNEqTIZbJtU3S1
         Ro4n1cKLVG7oXu7cSpjdsPjwAJn6ziuEBYXYN9hOiVq5LDjb4wZuNbvnf4fPT4JY9n1f
         LG8AY5zUvB8Ie2QWS31ye503cLlR6OqQvjT8sL8GjH4AAWAeUGPy7pE7kalgbOdVf8Y/
         9saOyyaJLVV9gSUMG6EA6AdJWb5bOZa3yx18rmLmidl525oCBjWcGYv5a0YG4QrAP4im
         o2Kpfs9mSKydj2lPSuWL9F5fSAVrlIW5uXrASFECxqXAsId8qhit5LINf6VRvjGfyYVX
         NwPA==
X-Gm-Message-State: ACrzQf1Uyl1nhwDHEnoD/kQ6Ef3N35ar/L7l/1yD0b6HRNWpY9tGhHBu
        kfhpRQ/irXsjUyHoiacJwv2gBssjeVU=
X-Google-Smtp-Source: AMsMyM7N6BXdtlen2Dft5pYwXc06+cbeUELnLT1k1/Npz8YUnAEtLMwCvuXvXTxuWX60aRKpWWxqbA==
X-Received: by 2002:a1f:5c0a:0:b0:3ab:9b92:1185 with SMTP id q10-20020a1f5c0a000000b003ab9b921185mr13212623vkb.10.1666372110878;
        Fri, 21 Oct 2022 10:08:30 -0700 (PDT)
Received: from ahoy.c.googlers.com.com (107.172.196.104.bc.googleusercontent.com. [104.196.172.107])
        by smtp.gmail.com with ESMTPSA id n35-20020ab013e6000000b003f05a273e56sm458406uae.4.2022.10.21.10.08.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 10:08:29 -0700 (PDT)
From:   Neal Cardwell <ncardwell.kernel@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Neil Spring <ntspring@fb.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: [PATCH net] tcp: fix indefinite deferral of RTO with SACK reneging
Date:   Fri, 21 Oct 2022 17:08:21 +0000
Message-Id: <20221021170821.1093930-1-ncardwell.kernel@gmail.com>
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>

This commit fixes a bug that can cause a TCP data sender to repeatedly
defer RTOs when encountering SACK reneging.

The bug is that when we're in fast recovery in a scenario with SACK
reneging, every time we get an ACK we call tcp_check_sack_reneging()
and it can note the apparent SACK reneging and rearm the RTO timer for
srtt/2 into the future. In some SACK reneging scenarios that can
happen repeatedly until the receive window fills up, at which point
the sender can't send any more, the ACKs stop arriving, and the RTO
fires at srtt/2 after the last ACK. But that can take far too long
(O(10 secs)), since the connection is stuck in fast recovery with a
low cwnd that cannot grow beyond ssthresh, even if more bandwidth is
available.

This fix changes the logic in tcp_check_sack_reneging() to only rearm
the RTO timer if data is cumulatively ACKed, indicating forward
progress. This avoids this kind of nearly infinite loop of RTO timer
re-arming. In addition, this meets the goals of
tcp_check_sack_reneging() in handling Windows TCP behavior that looks
temporarily like SACK reneging but is not really.

Many thanks to Jakub Kicinski and Neil Spring, who reported this issue
and provided critical packet traces that enabled root-causing this
issue. Also, many thanks to Jakub Kicinski for testing this fix.

Fixes: 5ae344c949e7 ("tcp: reduce spurious retransmits due to transient SACK reneging")
Reported-by: Jakub Kicinski <kuba@kernel.org>
Reported-by: Neil Spring <ntspring@fb.com>
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Cc: Yuchung Cheng <ycheng@google.com>
Tested-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ipv4/tcp_input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index bc2ea12221f95..0640453fce54b 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2192,7 +2192,8 @@ void tcp_enter_loss(struct sock *sk)
  */
 static bool tcp_check_sack_reneging(struct sock *sk, int flag)
 {
-	if (flag & FLAG_SACK_RENEGING) {
+	if (flag & FLAG_SACK_RENEGING &&
+	    flag & FLAG_SND_UNA_ADVANCED) {
 		struct tcp_sock *tp = tcp_sk(sk);
 		unsigned long delay = max(usecs_to_jiffies(tp->srtt_us >> 4),
 					  msecs_to_jiffies(10));
-- 
2.38.0.135.g90850a2211-goog

