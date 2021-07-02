Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9993BA466
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 21:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhGBTnt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 15:43:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229676AbhGBTns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 15:43:48 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 766CCC061762;
        Fri,  2 Jul 2021 12:41:15 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id cx9-20020a17090afd89b0290170a3e085edso6820448pjb.0;
        Fri, 02 Jul 2021 12:41:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iRPcc3KZxFiOquaZxV8pj049/M7XwQEX+qEAJ1CThqY=;
        b=jZYFtq8t0vu44PTn5Z+yPEuzQOUQUUfO4KZHYczUuYxuQxlT4x311ea4GnY64XtRt1
         e2HxrA7+vGA1rplFWjjwUmAkd2hx2jivqmUPtGQfw5WRIhW7A/GmvuGePBxZARebMzKF
         7vvCHUkjjoGYS6Ps96IocB+M7G69jbvKx08ssSLuX5HBAyAfuwEPRM/TXm9VzqUbXY1P
         LoSHna5097UuNkbBsV1kzOIlD4apjTmwBYjNKcz8Vf+Mjw26+EkJ7/WlZSDqi1W2RfNT
         n99tM3lE+taucZKU5xko37/Ozy2M90SzNb12AXsjRrbLFijk6QitmrrCFMDp9ZmUz6S4
         uIMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iRPcc3KZxFiOquaZxV8pj049/M7XwQEX+qEAJ1CThqY=;
        b=CfNHPb9k0YWFSlUBi5GtCfNXUK4lvfw86N0IAVmV/Vx1TpjRJG+l7fxJoiGBSCQ5aH
         xlwdBZ0wBnsAeEwmU5P8/QDk7JT+amsb+EulcXMe9hscH77GVxeQ68GV0HJwujYffaWx
         ynxWuWT1GGyCDzo7UNG6+OWIh+vzXCtS1t02ZzhfWYpULsV61YAL1znMH3izOahp5Gjk
         1NTSK3i59VLRRrjESaTS8hpY1nMWnww7fKzGkLpHnkxoCPDGv5it5RJq7FrQTOUkI2S3
         lH97bi0CRK25gYq1Ql9TDU+wDIsDRIADaq894/ahx91uiyEEWImkTK6JpiCXA9yZegbf
         wMeA==
X-Gm-Message-State: AOAM532KQwWZsY5hH51KKh/hz5DvhR19FW4lDjX2SDRJJ2E/yapymnRy
        ztPwJ1yORKaKTO1t0bfD5nk=
X-Google-Smtp-Source: ABdhPJwlqv/SX20NxLLJQWxL029/6T76a5hMovPA8WKZ7PJNpejCd2IOwTKiiocwnq+RNntcwk1dqw==
X-Received: by 2002:a17:90a:dc06:: with SMTP id i6mr1263098pjv.65.1625254874773;
        Fri, 02 Jul 2021 12:41:14 -0700 (PDT)
Received: from pn-hyperv.lan (bb42-60-144-185.singnet.com.sg. [42.60.144.185])
        by smtp.gmail.com with ESMTPSA id t14sm5283132pgm.9.2021.07.02.12.41.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 12:41:14 -0700 (PDT)
From:   Nguyen Dinh Phi <phind.uet@gmail.com>
To:     edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     Nguyen Dinh Phi <phind.uet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com
Subject: [PATCH v2] tcp: fix tcp_init_transfer() to not reset icsk_ca_initialized
Date:   Sat,  3 Jul 2021 03:40:33 +0800
Message-Id: <20210702194033.1370634-1-phind.uet@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit fixes a bug (found by syzkaller) that could cause spurious
double-initializations for congestion control modules, which could cause
memory leaks orother problems for congestion control modules (like CDG)
that allocate memory in their init functions.

The buggy scenario constructed by syzkaller was something like:

(1) create a TCP socket
(2) initiate a TFO connect via sendto()
(3) while socket is in TCP_SYN_SENT, call setsockopt(TCP_CONGESTION),
    which calls:
       tcp_set_congestion_control() ->
         tcp_reinit_congestion_control() ->
           tcp_init_congestion_control()
(4) receive ACK, connection is established, call tcp_init_transfer(),
    set icsk_ca_initialized=0 (without first calling cc->release()),
    call tcp_init_congestion_control() again.

Note that in this sequence tcp_init_congestion_control() is called
twice without a cc->release() call in between. Thus, for CC modules
that allocate memory in their init() function, e.g, CDG, a memory leak
may occur. The syzkaller tool managed to find a reproducer that
triggered such a leak in CDG.

The bug was introduced when that commit 8919a9b31eb4 ("tcp: Only init
congestion control if not initialized already")
introduced icsk_ca_initialized and set icsk_ca_initialized to 0 in
tcp_init_transfer(), missing the possibility for a sequence like the
one above, where a process could call setsockopt(TCP_CONGESTION) in
state TCP_SYN_SENT (i.e. after the connect() or TFO open sendmsg()),
which would call tcp_init_congestion_control(). It did not intend to
reset any initialization that the user had already explicitly made;
it just missed the possibility of that particular sequence (which
syzkaller managed to find).

Fixes: commit 8919a9b31eb4 ("tcp: Only init congestion control if not
initialized already")
Reported-by: syzbot+f1e24a0594d4e3a895d3@syzkaller.appspotmail.com
Signed-off-by: Nguyen Dinh Phi <phind.uet@gmail.com>
---
V2:	- Modify the Subject line.
	- Adjust the commit message.
	- Add Fixes: tag.

 net/ipv4/tcp_input.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 7d5e59f688de..855ada2be25e 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5922,7 +5922,6 @@ void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb)
 		tp->snd_cwnd = tcp_init_cwnd(tp, __sk_dst_get(sk));
 	tp->snd_cwnd_stamp = tcp_jiffies32;

-	icsk->icsk_ca_initialized = 0;
 	bpf_skops_established(sk, bpf_op, skb);
 	if (!icsk->icsk_ca_initialized)
 		tcp_init_congestion_control(sk);
--
2.25.1

