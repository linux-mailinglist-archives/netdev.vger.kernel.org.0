Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370B1483F57
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 10:45:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230231AbiADJpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 04:45:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230185AbiADJpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 04:45:13 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E7AC061761
        for <netdev@vger.kernel.org>; Tue,  4 Jan 2022 01:45:12 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id r16-20020a17090a0ad000b001b276aa3aabso27142815pje.0
        for <netdev@vger.kernel.org>; Tue, 04 Jan 2022 01:45:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FsqQlUu/lqloZgcg5HQ7Xf9l7My4+VsXYDpbXTUquc8=;
        b=PpMO++BQdk9NBCK3FkJv+UB35d6WZ6XqaZ7CPmo8IN9lx8I8Hb7h9wgojzaGjeFAWH
         trvWCv36CodueGMoiluUD1gla/+uFj3B7rlRpSrV6/PfkYRJVdAoGgero1BzbajBm1lL
         WToLGzgKunQ6lC2mIetsYU0RIE14YIFWDwo984Ld7l+9Tm1Zx6UAhzXaQ//JXVp7+tFc
         s0LzCQKZslC7mwLFNoB1fMJH77C50/ZI+29nG4JuNCjHYmDl5MqPnuS8hX7Q4Fx5YMXh
         IFF9jYgRSjZb2Jswx8YCNLTh+umJ5BbDzFimVqeupXZ9xuBP73rBuW//tdsHXJUGAqPD
         MYdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FsqQlUu/lqloZgcg5HQ7Xf9l7My4+VsXYDpbXTUquc8=;
        b=UnkSrNX0RCU53lggYes9SOQw4JsaTTrkJQQndtqAEMo3gqWbgZ5Z6sDTqJ/sYUGc9h
         O3oijZ3I2sCPw1+WdB7seV5Ccdzt9KB9DAomFA6caP8TA9UqYZqv7C0bZv+HYVsMMjCq
         6PVII5jsYWSG7uGHA2j6JwGdpz95nrQTzJuDrFO8As07YqzlMwurf69GBmCZDghedwfr
         dhbHUR4PhKruoa7V+1ZGlukgfULeFNM8v9+7twxQgNskwf2JwQXl1BBElkBWX1itOAO8
         y5o9SmPPlyB6plS9YgPM19UHbjDz7MiWMlzZS/LX1RaYfS/y4Yuj+OU1S2foBOepfado
         cLhw==
X-Gm-Message-State: AOAM531xXt7TTc4OIfatkGvASmEH6WAmVq+g5AtOiF6UAy6SzDHpStHA
        tI99CYz7+vfQaygtPTOlM78=
X-Google-Smtp-Source: ABdhPJwl6q1EIUCOXgQT7LsBj2dBcZlj1nOpMTxTuPQp+0qqUeKt1mgtApbomG0ikeXF/TO1S3Um4w==
X-Received: by 2002:a17:903:120d:b0:149:ab6c:75d4 with SMTP id l13-20020a170903120d00b00149ab6c75d4mr18205380plh.3.1641289512169;
        Tue, 04 Jan 2022 01:45:12 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:823c:b112:bdfb:7ef1])
        by smtp.gmail.com with ESMTPSA id l22sm42263353pfc.167.2022.01.04.01.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 01:45:11 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: [PATCH net] sch_qfq: prevent shift-out-of-bounds in qfq_init_qdisc
Date:   Tue,  4 Jan 2022 01:45:08 -0800
Message-Id: <20220104094508.3312096-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.1.448.ga2b2bfdf31-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

tx_queue_len can be set to ~0U, we need to be more
careful about overflows.

__fls(0) is undefined, as this report shows:

UBSAN: shift-out-of-bounds in net/sched/sch_qfq.c:1430:24
shift exponent 51770272 is too large for 32-bit type 'int'
CPU: 0 PID: 25574 Comm: syz-executor.0 Not tainted 5.16.0-rc7-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x201/0x2d8 lib/dump_stack.c:106
 ubsan_epilogue lib/ubsan.c:151 [inline]
 __ubsan_handle_shift_out_of_bounds+0x494/0x530 lib/ubsan.c:330
 qfq_init_qdisc+0x43f/0x450 net/sched/sch_qfq.c:1430
 qdisc_create+0x895/0x1430 net/sched/sch_api.c:1253
 tc_modify_qdisc+0x9d9/0x1e20 net/sched/sch_api.c:1660
 rtnetlink_rcv_msg+0x934/0xe60 net/core/rtnetlink.c:5571
 netlink_rcv_skb+0x200/0x470 net/netlink/af_netlink.c:2496
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x814/0x9f0 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0xaea/0xe60 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:704 [inline]
 sock_sendmsg net/socket.c:724 [inline]
 ____sys_sendmsg+0x5b9/0x910 net/socket.c:2409
 ___sys_sendmsg net/socket.c:2463 [inline]
 __sys_sendmsg+0x280/0x370 net/socket.c:2492
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: 462dbc9101ac ("pkt_sched: QFQ Plus: fair-queueing service at DRR cost")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
 net/sched/sch_qfq.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 0b7f9ba28deb057afb1e689eafbb848cbbe2aa90..d4ce58c90f9fbab1a4f35e08213b11f87cce92af 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -1421,10 +1421,8 @@ static int qfq_init_qdisc(struct Qdisc *sch, struct nlattr *opt,
 	if (err < 0)
 		return err;
 
-	if (qdisc_dev(sch)->tx_queue_len + 1 > QFQ_MAX_AGG_CLASSES)
-		max_classes = QFQ_MAX_AGG_CLASSES;
-	else
-		max_classes = qdisc_dev(sch)->tx_queue_len + 1;
+	max_classes = min_t(u64, (u64)qdisc_dev(sch)->tx_queue_len + 1,
+			    QFQ_MAX_AGG_CLASSES);
 	/* max_cl_shift = floor(log_2(max_classes)) */
 	max_cl_shift = __fls(max_classes);
 	q->max_agg_classes = 1<<max_cl_shift;
-- 
2.34.1.448.ga2b2bfdf31-goog

