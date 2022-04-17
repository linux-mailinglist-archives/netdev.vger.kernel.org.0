Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA7FD5048F2
	for <lists+netdev@lfdr.de>; Sun, 17 Apr 2022 20:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbiDQShO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Apr 2022 14:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234793AbiDQShN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Apr 2022 14:37:13 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7581C91B
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 11:34:37 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id j71so1567379pge.11
        for <netdev@vger.kernel.org>; Sun, 17 Apr 2022 11:34:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uONgKt3GgvDtPCtik386EiruUREVc+kLtgbjNUR2qfA=;
        b=ffQzhNiAU1qAErrGrdLDlfx9zKYtNv6uz1/odMHcBTqiiWgend+ThX9Y+a60W28WdP
         bI1lvDDYqHAc+tOFhvbQVeFb/0xAnN/woj9uiUegFxihVBxaHfzEUAue3IQj68Q6gMDn
         qsOnQ7aEJhc+fzAwxEBr1Ix6hz/CeLRBBP6Aqg+BrujBdQ12ogk0UYKlyLIi1/IvpC53
         pN7neH8YoYMigLbIGJUbxl7tMwpelWk8LaZ6J0NRL59mUWHULeIG3i/6ueCJ4bKicLvx
         pdr2RxJgfGcg8R2OHfBphJwgZ5J/isAO5eh5b3E6OacqJVl3C2/U8xbROBDxNQEJmSjb
         LfTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uONgKt3GgvDtPCtik386EiruUREVc+kLtgbjNUR2qfA=;
        b=OtbCEhopIRjGzu9rfbtsHXc1nudTOIje6XXmHq0Ortj/2YPJAp7U3Dpve/EiBK9bmw
         fkLv3s+8Dyx1e87/toHim5irJCcW9nGmZFKJgRNlZrQCZuKyABfvoy+/ZIYmzKTkL0NV
         sKNOLtzvOR3PDzW1lsYaH7uYMumcGsk9XjnIgcbx7cyouhFUA53dWvOg4qm1y+eh+AgA
         4vleV8P8kYhr24wyH46JlYHaFhtO03NCPg/540c9gySgDDZbkVsjvOkpcX6uteDNn6S1
         +vRxCZOQtzBo0BTzZGg4ugPugxJ5PfYX/fQ8xaepwqvWdRl8rvdMJiJOEd1hJkdas1G9
         zTgg==
X-Gm-Message-State: AOAM532IVhXAbDrtvJvNGVUeFk9NJpztmwBgkn6RhFXHQeS7h7xyPLrr
        0dGzhQFmAzccdF795oYjnXY=
X-Google-Smtp-Source: ABdhPJwCKseoTjRN808QsjPIoc3IaDJY0KAd9MrEP9A3sppPLc4hlBozc4OTvC3ZXfwiLwfp2KtYwg==
X-Received: by 2002:a63:2248:0:b0:39d:48fd:7d73 with SMTP id t8-20020a632248000000b0039d48fd7d73mr7365957pgm.372.1650220476778;
        Sun, 17 Apr 2022 11:34:36 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:e7a:3f3c:2676:804a])
        by smtp.gmail.com with ESMTPSA id b3-20020a17090a12c300b001d28859a758sm1881153pjg.31.2022.04.17.11.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Apr 2022 11:34:35 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        kernel test robot <lkp@intel.com>,
        Andreas Schwab <schwab@linux-m68k.org>
Subject: [PATCH v2 net-next] tcp: fix signed/unsigned comparison
Date:   Sun, 17 Apr 2022 11:34:32 -0700
Message-Id: <20220417183432.3952871-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Kernel test robot reported:

smatch warnings:
net/ipv4/tcp_input.c:5966 tcp_rcv_established() warn: unsigned 'reason' is never less than zero.

I actually had one packetdrill failing because of this bug,
and was about to send the fix :)

v2: Andreas Schwab also pointed out that @reason needs to be negated
    before we reach tcp_drop_reason()

Fixes: 4b506af9c5b8 ("tcp: add two drop reasons for tcp_ack()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Andreas Schwab <schwab@linux-m68k.org>
---
 net/ipv4/tcp_input.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index cf2dc19bb8c766c1d33406053fd61c0873f15489..daff631b94865ae95cbd49ed8ecf6782edaf16e7 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5959,9 +5959,10 @@ void tcp_rcv_established(struct sock *sk, struct sk_buff *skb)
 
 step5:
 	reason = tcp_ack(sk, skb, FLAG_SLOWPATH | FLAG_UPDATE_TS_RECENT);
-	if (reason < 0)
+	if ((int)reason < 0) {
+		reason = -reason;
 		goto discard;
-
+	}
 	tcp_rcv_rtt_measure_ts(sk, skb);
 
 	/* Process urgent data. */
-- 
2.36.0.rc0.470.gd361397f0d-goog

