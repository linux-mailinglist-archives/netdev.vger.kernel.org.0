Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39336A6D0D
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 14:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbjCANcy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 08:32:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCANcx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 08:32:53 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBF48699
        for <netdev@vger.kernel.org>; Wed,  1 Mar 2023 05:32:51 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id l24-20020a25b318000000b007eba3f8e3baso273366ybj.4
        for <netdev@vger.kernel.org>; Wed, 01 Mar 2023 05:32:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677677570;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=jAF5ywvz4PTuwTf1oGMAqhM+HsiHCV+LLEpgHI/vUxM=;
        b=E8q6mifWchHIbVsJlDmFYahcv937vRW7059iD63LKMPzdMRMMqa4Ysj6zyQ6aq0Wg/
         3Myp+ebmicC5xim3fFejitHHOoIi43xFcpsvm+6sGJ7slg0thJ21mzYkoIMsgT8+3+4C
         oHqEn/bocgFufYXNJkQ+bf4udNjK24Ee+MOdA+HFL6yN4XsXBlpZfW8k46VxGKZrCwlj
         YDx/MI0c+bo7Mn0VnROZ8grgprnqRRj/xioiYb45HExVMmSBg0tk+82j5DQtckoM2z2r
         CMiGLW1wqkfuhNB8pC3Q3uYUoYOHUawv/Sj5/gJxDYl8boiOq8C0lDSL4mk9XWcGdS0A
         suvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677677570;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jAF5ywvz4PTuwTf1oGMAqhM+HsiHCV+LLEpgHI/vUxM=;
        b=2gKHkbh88L9xmnXrwahlf9YeSXQmddDQPW4eIm5lhwtHxzaVW58QRm9WiPrscMaN+2
         yCaId/aDkxwDc10t/gjfRx7pEbYSqMB5DxzXQB4+wJHOG+tzgbeocsGkcgyInkYxHi29
         ANmCGnJtgwFsYpFST+0LuVko/XFY1u1uKhzuRT+uFS79i4mgVf47GvlfF0ENeA4P+OOt
         EGV6XAYdBk753KbgluZtxuOwStykTVIJQYOVHICxBf5CUILAAPl4UIU80+UWZvRlAha4
         YQxY2vKPqTLkkZS/GcRLeDjoAjw57gZlDfdIksn/qiBN963HkYnvN9AFXGE7l6iYzFU9
         ZXmQ==
X-Gm-Message-State: AO0yUKWwk5VHi/pO4G+6UNEGEw4+rBlBUIHRGK/yzjZ2OS9ZrQjUl+Kx
        65EUQt7zxXPGk2ymDWL4QI5YJ4MSM/vk9g==
X-Google-Smtp-Source: AK7set/mHF0+LtzlESnbaX6nlia1p+nMEr9Led30bj6Jl1RCv2Ga22C6Sv/iTk5IRZbtOhjRfIZU/WSepR7HHw==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:9f0a:0:b0:a36:3875:564a with SMTP id
 n10-20020a259f0a000000b00a363875564amr3366922ybq.2.1677677570343; Wed, 01 Mar
 2023 05:32:50 -0800 (PST)
Date:   Wed,  1 Mar 2023 13:32:47 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230301133247.2346111-1-edumazet@google.com>
Subject: [PATCH net] net: use indirect calls helpers for sk_exit_memory_pressure()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Brian Vazquez <brianvv@google.com>,
        Florian Westphal <fw@strlen.de>,
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

From: Brian Vazquez <brianvv@google.com>

Florian reported a regression and sent a patch with the following
changelog:

<quote>
 There is a noticeable tcp performance regression (loopback or cross-netns),
 seen with iperf3 -Z (sendfile mode) when generic retpolines are needed.

 With SK_RECLAIM_THRESHOLD checks gone number of calls to enter/leave
 memory pressure happen much more often. For TCP indirect calls are
 used.

 We can't remove the if-set-return short-circuit check in
 tcp_enter_memory_pressure because there are callers other than
 sk_enter_memory_pressure.  Doing a check in the sk wrapper too
 reduces the indirect calls enough to recover some performance.

 Before,
 0.00-60.00  sec   322 GBytes  46.1 Gbits/sec                  receiver

 After:
 0.00-60.04  sec   359 GBytes  51.4 Gbits/sec                  receiver

 "iperf3 -c $peer -t 60 -Z -f g", connected via veth in another netns.
</quote>

It seems we forgot to upstream this indirect call mitigation we
had for years, lets do this instead.

[edumazet] - It seems we forgot to upstream this indirect call
             mitigation we had for years, let's do this instead.
           - Changed to INDIRECT_CALL_INET_1() to avoid bots reports.

Fixes: 4890b686f408 ("net: keep sk->sk_forward_alloc as small as possible")
Reported-by: Florian Westphal <fw@strlen.de>
Link: https://lore.kernel.org/netdev/20230227152741.4a53634b@kernel.org/T/
Signed-off-by: Brian Vazquez <brianvv@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/core/sock.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 341c565dbc262fcece1c5b410609d910a68edcb0..c258887953905c340ad6deab8b66cbf45ecbf178 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2818,7 +2818,8 @@ static void sk_enter_memory_pressure(struct sock *sk)
 static void sk_leave_memory_pressure(struct sock *sk)
 {
 	if (sk->sk_prot->leave_memory_pressure) {
-		sk->sk_prot->leave_memory_pressure(sk);
+		INDIRECT_CALL_INET_1(sk->sk_prot->leave_memory_pressure,
+				     tcp_leave_memory_pressure, sk);
 	} else {
 		unsigned long *memory_pressure = sk->sk_prot->memory_pressure;
 
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

