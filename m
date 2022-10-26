Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B586660E2F2
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbiJZOMr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:12:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234192AbiJZOMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:12:44 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FB710EE54;
        Wed, 26 Oct 2022 07:12:43 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4My9cn5CFzzVj66;
        Wed, 26 Oct 2022 22:07:53 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500015.china.huawei.com
 (7.221.188.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 26 Oct
 2022 22:12:40 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <edumazet@google.com>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <xemul@parallels.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] tcp: reset tp->sacked_out when sack is enabled
Date:   Wed, 26 Oct 2022 23:15:58 +0800
Message-ID: <20221026151558.4165020-1-luwei32@huawei.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The meaning of tp->sacked_out depends on whether sack is enabled
or not. If setsockopt is called to enable sack_ok via
tcp_repair_options_est(), tp->sacked_out should be cleared, or it
will trigger warning in tcp_verify_left_out as follows:

============================================
WARNING: CPU: 8 PID: 0 at net/ipv4/tcp_input.c:2132
tcp_timeout_mark_lost+0x154/0x160
tcp_enter_loss+0x2b/0x290
tcp_retransmit_timer+0x50b/0x640
tcp_write_timer_handler+0x1c8/0x340
tcp_write_timer+0xe5/0x140
call_timer_fn+0x3a/0x1b0
__run_timers.part.0+0x1bf/0x2d0
run_timer_softirq+0x43/0xb0
__do_softirq+0xfd/0x373
__irq_exit_rcu+0xf6/0x140

This warning occurs in several steps:
Step1. If sack is not enabled, when server receives dup-ack,
       it calls tcp_add_reno_sack() to increase tp->sacked_out.

Step2. Setsockopt() is called to enable sack

Step3. The retransmit timer expires, it calls tcp_timeout_mark_lost()
       to increase tp->lost_out but not clear tp->sacked_out because
       sack is enabled and tcp_is_reno() is false.

So tp->left_out is increased repeatly in Step1 and Step3 and it is
greater than tp->packets_out and trigger the warning. In function
tcp_timeout_mark_lost(), tp->sacked_out will be cleared if Step2 not
happen and the warning will not be triggered. So this patch clears
tp->sacked_out in tcp_repair_options_est().

Fixes: b139ba4e90dc ("tcp: Repair connection-time negotiated parameters")
Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 net/ipv4/tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ef14efa1fb70..188d5c0e440f 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3282,6 +3282,9 @@ static int tcp_repair_options_est(struct sock *sk, sockptr_t optbuf,
 			if (opt.opt_val != 0)
 				return -EINVAL;
 
+			if (tcp_is_reno(tp))
+				tp->sacked_out = 0;
+
 			tp->rx_opt.sack_ok |= TCP_SACK_SEEN;
 			break;
 		case TCPOPT_TIMESTAMP:
-- 
2.31.1

