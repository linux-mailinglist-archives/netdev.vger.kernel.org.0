Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBDE05FC68C
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 15:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiJLNef (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 09:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiJLNe3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 09:34:29 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78A7CF87B
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 06:34:27 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id o4-20020a258d84000000b006bcfc1aafbdso16065890ybl.14
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 06:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=wT5hQfznKkVoD+X5pY+mA2o+4Og1/F5b18WV/Hx5kXY=;
        b=O8o0NXlZQ/wzPxTUyeTNCKurtj2d18KtZeNGjFu4M4XIk4xSUG9C8OquSCusduFgmy
         oddFoqcpsD/qxwq7O+HW+NvXAuym7zKbHFxjg9+kVoKinfSqUNh8v2LcTYU6U8haWB9F
         2J1Wytj6DGDPdqHynDwesp41Mz1OLToD8yTMfNFHuQyxUviOIItl98e6jCwY38P86hhP
         QXMMQJjb1kdFGvhVucquMuOjNYHAZaelF4crVVCm9EFVfpwn0UWu/q6o/6BpjieSe3Cu
         cmqmNW5Y7xeXHONAdBdhGV2N75qSIQngr6myGs/vsrJ2ujbw21wcrcWU/Xy7x8+vdU+l
         823Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wT5hQfznKkVoD+X5pY+mA2o+4Og1/F5b18WV/Hx5kXY=;
        b=GiOcFZPwG6FdT5lrOaVW+tCdkkJX8tWLiwMJU4mhnrynRVLWCAfZ+iIbGw4ACY4u9u
         3ZMbBFqJBBH/bauh7dnyRyDIHEnteWKn3/BKlKAsWPl+GegbxQGmOiCF7+lJY6lXw4/w
         9FSWsHVsnOzJc+GaY3roU+kQlLiCYG71svUsGMTAPEAN3GtEy9zgwTBeL/fVKvE2nCPp
         6F56exWhe0l187NI5uUBu4uUemtQVit6iXNhdF/Dy2mP7qtqK4SEE0379lmXa2rFfaia
         F1/WbuYQPdYnapoRfIRyRC0fQDzOjfxonktXnkDH5/7huHkr++TB8VvDSOLex1IaRVTL
         16ZA==
X-Gm-Message-State: ACrzQf02wl6fOB1w6xI71xaFGsBuHMZ4UeEQTcknW8BBvhHhjKMsOQyg
        JuMO8GkUpZjhAKAfaHIAqU12GuS3xLdqhw==
X-Google-Smtp-Source: AMsMyM5PnL+1hM31Wxqrt8Pm0LHltkF7V/nxdZ+wRRN0oWA/3/e+RFqF9DSOFhbcMo8y6ZwmPSYfCxSYNZQ7Vg==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a25:d0c3:0:b0:6be:1ae5:5996 with SMTP id
 h186-20020a25d0c3000000b006be1ae55996mr26833626ybg.580.1665581666756; Wed, 12
 Oct 2022 06:34:26 -0700 (PDT)
Date:   Wed, 12 Oct 2022 13:34:12 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
Message-ID: <20221012133412.519394-1-edumazet@google.com>
Subject: [PATCH net] kcm: avoid potential race in kcm_tx_work
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>,
        Tom Herbert <tom@herbertland.com>
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

syzbot found that kcm_tx_work() could crash [1] in:

	/* Primarily for SOCK_SEQPACKET sockets */
	if (likely(sk->sk_socket) &&
	    test_bit(SOCK_NOSPACE, &sk->sk_socket->flags)) {
<<*>>	clear_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
		sk->sk_write_space(sk);
	}

I think the reason is that another thread might concurrently
run in kcm_release() and call sock_orphan(sk) while sk is not
locked. kcm_tx_work() find sk->sk_socket being NULL.

[1]
BUG: KASAN: null-ptr-deref in instrument_atomic_write include/linux/instrumented.h:86 [inline]
BUG: KASAN: null-ptr-deref in clear_bit include/asm-generic/bitops/instrumented-atomic.h:41 [inline]
BUG: KASAN: null-ptr-deref in kcm_tx_work+0xff/0x160 net/kcm/kcmsock.c:742
Write of size 8 at addr 0000000000000008 by task kworker/u4:3/53

CPU: 0 PID: 53 Comm: kworker/u4:3 Not tainted 5.19.0-rc3-next-20220621-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: kkcmd kcm_tx_work
Call Trace:
<TASK>
__dump_stack lib/dump_stack.c:88 [inline]
dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
kasan_report+0xbe/0x1f0 mm/kasan/report.c:495
check_region_inline mm/kasan/generic.c:183 [inline]
kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
instrument_atomic_write include/linux/instrumented.h:86 [inline]
clear_bit include/asm-generic/bitops/instrumented-atomic.h:41 [inline]
kcm_tx_work+0xff/0x160 net/kcm/kcmsock.c:742
process_one_work+0x996/0x1610 kernel/workqueue.c:2289
worker_thread+0x665/0x1080 kernel/workqueue.c:2436
kthread+0x2e9/0x3a0 kernel/kthread.c:376
ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
</TASK>

Fixes: ab7ac4eb9832 ("kcm: Kernel Connection Multiplexor module")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tom Herbert <tom@herbertland.com>
---
 net/kcm/kcmsock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/kcm/kcmsock.c b/net/kcm/kcmsock.c
index 1215c863e1c410fa9ba5b9c3706152decfb3ebac..27725464ec08fe2b5f2e86202636cbc895568098 100644
--- a/net/kcm/kcmsock.c
+++ b/net/kcm/kcmsock.c
@@ -1838,10 +1838,10 @@ static int kcm_release(struct socket *sock)
 	kcm = kcm_sk(sk);
 	mux = kcm->mux;
 
+	lock_sock(sk);
 	sock_orphan(sk);
 	kfree_skb(kcm->seq_skb);
 
-	lock_sock(sk);
 	/* Purge queue under lock to avoid race condition with tx_work trying
 	 * to act when queue is nonempty. If tx_work runs after this point
 	 * it will just return.
-- 
2.38.0.rc1.362.ged0d419d3c-goog

