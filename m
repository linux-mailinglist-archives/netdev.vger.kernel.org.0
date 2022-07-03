Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49CDE5649A3
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 21:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiGCTv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 15:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiGCTv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 15:51:28 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E312EB7;
        Sun,  3 Jul 2022 12:51:26 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id pk21so13364294ejb.2;
        Sun, 03 Jul 2022 12:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=onHiE085umurs2Ia7yNhkMPRjch81x5DVPVGIjclApc=;
        b=lqYs6Owxf+xwD4BujbUx5L/JW93fFfkv402JQnsd2Ivmy7YKUKxpvbI13wVAZ1EQL0
         SHWUFaEibPQ2r7wb2CdZ883hnnBsk489Wp0s6T5uWV4il5mkSGHFFfvSZ7d/libskyDp
         8KClxqMHJYwncccjdmmhM1YdParV1mBg9qRtiRHQPvFX5OhJ10JaKtscZntWNuUd9gjZ
         vuX6Hf/pm3mefC4xLpai0hfK8EaC4XCDqgeYVUpB5qUCFEgyqsNcbLYmex8Rzh1zFBif
         5uJVJ7UhF9oxvP/ofPt1G3gaDmhnktDi8oFqMzFOPt/LDXHwmTCyHsQfabXg1eNTCT5C
         Yn8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=onHiE085umurs2Ia7yNhkMPRjch81x5DVPVGIjclApc=;
        b=4wBJtjiX60uYnxyo3yzFxwZXCWCmMkwMRRZoSLokN5EkUGqnaXZiZeANUHbEGoYQ/v
         7N5N4p2nYJJMgiZwPfIx9LuqufcGTQ+AsWCT7wuU9l31O+ygJ1LvQ5251X70LVN19CDV
         kDQLQoZW8BsZDdwitHnfmVuiTeGMeCEPemA7nO1PFgVtYokWoVOAbAj9i00FihYeo6ml
         /GjfVlSrWBLZGt7BVRWisIATaz2F9weaywIv6tth1DxYjnm92D97lj1YodYjXQgBoAXd
         fSicZCgm8xHltVnLT+Wzdv1NtqPMEmUtLnQ4CQrUEvlHITjCsHLaEL7Uc01cxbq8HAnS
         Yh8Q==
X-Gm-Message-State: AJIora/Z/h9Y38i173mXScz3YhwPtgK7yU+6T2/oO3fJYRvNm9TMumTv
        KsLRwu0zGT4T2vdj/oY7dk4=
X-Google-Smtp-Source: AGRyM1s4ubghOPGD9ZnkBdEkwpz2WOQrAV8Bai4xYSIbBHGk/AT51c/k9LA1hUG/2nIgngadyHoc3w==
X-Received: by 2002:a17:907:eaa:b0:726:a3ab:f000 with SMTP id ho42-20020a1709070eaa00b00726a3abf000mr25958139ejc.382.1656877884654;
        Sun, 03 Jul 2022 12:51:24 -0700 (PDT)
Received: from localhost.localdomain ([2a04:241e:502:a080:adb9:a498:761a:afd0])
        by smtp.gmail.com with ESMTPSA id f26-20020a056402005a00b004358f6e0570sm19201254edu.17.2022.07.03.12.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jul 2022 12:51:24 -0700 (PDT)
From:   Leonard Crestez <cdleonard@gmail.com>
To:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC] tcp: diag: Also support for FIN_WAIT1 sockets for tcp_abort()
Date:   Sun,  3 Jul 2022 22:51:03 +0300
Message-Id: <338ea07266aedd2e416a830ab3fe8f4224d07a30.1656877534.git.cdleonard@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Aborting tcp connections via ss -K doesn't work in TCP_FIN_WAIT1 state,
this happens because the SOCK_DEAD flag is set. Fix by ignoring that flag
for this special case.

Signed-off-by: Leonard Crestez <cdleonard@gmail.com>

---
 net/ipv4/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

I tested that this fixes the problem but not certain about correctness.

Support for TCP_TIME_WAIT was added recently but it doesn't fix
TCP_FIN_WAIT1.

See: https://lore.kernel.org/netdev/20220627121038.226500-1-edumazet@google.com/

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index d9dd998fdb76..215e7d3fed13 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4661,11 +4661,11 @@ int tcp_abort(struct sock *sk, int err)
 
 	/* Don't race with BH socket closes such as inet_csk_listen_stop. */
 	local_bh_disable();
 	bh_lock_sock(sk);
 
-	if (!sock_flag(sk, SOCK_DEAD)) {
+	if (sk->sk_state == TCP_FIN_WAIT1 || !sock_flag(sk, SOCK_DEAD)) {
 		sk->sk_err = err;
 		/* This barrier is coupled with smp_rmb() in tcp_poll() */
 		smp_wmb();
 		sk_error_report(sk);
 		if (tcp_need_reset(sk->sk_state))
-- 
2.25.1

