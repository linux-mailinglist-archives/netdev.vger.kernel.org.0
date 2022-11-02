Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287EE6162A4
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 13:23:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbiKBMXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 08:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiKBMXT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 08:23:19 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE6228729;
        Wed,  2 Nov 2022 05:23:18 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4N2Qym37bnzbc7c;
        Wed,  2 Nov 2022 20:23:12 +0800 (CST)
Received: from huawei.com (10.175.101.6) by kwepemi500015.china.huawei.com
 (7.221.188.92) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 2 Nov
 2022 20:23:15 +0800
From:   Lu Wei <luwei32@huawei.com>
To:     <edumazet@google.com>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <xemul@parallels.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [patch net v3] tcp: prohibit TCP_REPAIR_OPTIONS if data was already sent
Date:   Wed, 2 Nov 2022 21:28:11 +0800
Message-ID: <20221102132811.70858-1-luwei32@huawei.com>
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

If setsockopt with option name of TCP_REPAIR_OPTIONS and opt_code
of TCPOPT_SACK_PERM is called to enable sack after data is sent
and before data is acked, it will trigger a warning in function
tcp_verify_left_out() as follows:

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

The warning is caused in the following steps:
1. a socket named socketA is created
2. socketA enters repair mode without build a connection
3. socketA calls connect() and its state is changed to TCP_ESTABLISHED
   directly
4. socketA leaves repair mode
5. socketA calls sendmsg() to send data, packets_out and sack_outs(dup
   ack receives) increase
6. socketA enters repair mode again
7. socketA calls setsockopt with TCPOPT_SACK_PERM to enable sack
8. retransmit timer expires, it calls tcp_timeout_mark_lost(), lost_out
   increases
9. sack_outs + lost_out > packets_out triggers since lost_out and
   sack_outs increase repeatly

In function tcp_timeout_mark_lost(), tp->sacked_out will be cleared if
Step7 not happen and the warning will not be triggered. As suggested by
Denis and Eric, TCP_REPAIR_OPTIONS should be prohibited if data was
already sent. So this patch checks tp->segs_out, only TCP_REPAIR_OPTIONS
can be set only if tp->segs_out is 0.

socket-tcp tests in CRIU has been tested as follows:
$ sudo ./test/zdtm.py run -t zdtm/static/socket-tcp*  --keep-going \
       --ignore-taint

socket-tcp* represent all socket-tcp tests in test/zdtm/static/.

Fixes: b139ba4e90dc ("tcp: Repair connection-time negotiated parameters")
Signed-off-by: Lu Wei <luwei32@huawei.com>
---
 net/ipv4/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index ef14efa1fb70..1f5cc32cf0cc 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3647,7 +3647,7 @@ int do_tcp_setsockopt(struct sock *sk, int level, int optname,
 	case TCP_REPAIR_OPTIONS:
 		if (!tp->repair)
 			err = -EINVAL;
-		else if (sk->sk_state == TCP_ESTABLISHED)
+		else if (sk->sk_state == TCP_ESTABLISHED && !tp->segs_out)
 			err = tcp_repair_options_est(sk, optval, optlen);
 		else
 			err = -EPERM;
-- 
2.31.1

