Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24ED223ABA
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 13:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726104AbgGQLn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 07:43:28 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:50624 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725950AbgGQLn1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 07:43:27 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E4C21B12F534FAB3EA07;
        Fri, 17 Jul 2020 19:43:22 +0800 (CST)
Received: from [127.0.0.1] (10.174.177.32) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Fri, 17 Jul 2020
 19:43:13 +0800
To:     <edumazet@google.com>, <davem@davemloft.net>,
        <kuznet@ms2.inr.ac.ru>, <yoshfuji@linux-ipv6.org>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <wangxiaogang3@huawei.com>,
        <jinyiting@huawei.com>, <xuhanbing@huawei.com>,
        <zhengshaoyu@huawei.com>
From:   hujunwei <hujunwei4@huawei.com>
Subject: [PATCH net-next] tcp: Optimize the recovery of tcp when lack of SACK
Message-ID: <66945532-2470-4240-b213-bc36791b934b@huawei.com>
Date:   Fri, 17 Jul 2020 19:43:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.32]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Junwei Hu <hujunwei4@huawei.com>

In the document of RFC2582(https://tools.ietf.org/html/rfc2582)
introduced two separate scenarios for tcp congestion control:
There are two separate scenarios in which the TCP sender could
receive three duplicate acknowledgements acknowledging "send_high"
but no more than "send_high".  One scenario would be that the data
sender transmitted four packets with sequence numbers higher than
"send_high", that the first packet was dropped in the network, and
the following three packets triggered three duplicate
acknowledgements acknowledging "send_high".  The second scenario
would be that the sender unnecessarily retransmitted three packets
below "send_high", and that these three packets triggered three
duplicate acknowledgements acknowledging "send_high".  In the absence
of SACK, the TCP sender in unable to distinguish between these two
scenarios.

We encountered the second scenario when the third-party switches
does not support SACK, and I use kprobes to find that tcp kept in
CA_Loss state when high_seq equal to snd_nxt.

All of the packets is acked if high_seq equal to snd_nxt, the TCP
sender is able to distinguish between these two scenarios in
described RFC2582. So the current state can be switched.

This patch enhance the TCP congestion control algorithm for lack
of SACK.

Signed-off-by: Junwei Hu <hujunwei4@huawei.com>
Reviewed-by: XiaoGang Wang <wangxiaogang3@huawei.com>
Reviewed-by: Yiting Jin <jinyiting@huawei.com>
---
 net/ipv4/tcp_input.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 9615e72..d5573123 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2385,7 +2385,8 @@ static bool tcp_try_undo_recovery(struct sock *sk)
 	} else if (tp->rack.reo_wnd_persist) {
 		tp->rack.reo_wnd_persist--;
 	}
-	if (tp->snd_una == tp->high_seq && tcp_is_reno(tp)) {
+	if (tp->snd_una == tp->high_seq &&
+	    tcp_is_reno(tp) && tp->snd_nxt > tp->high_seq) {
 		/* Hold old state until something *above* high_seq
 		 * is ACKed. For Reno it is MUST to prevent false
 		 * fast retransmits (RFC2582). SACK TCP is safe. */
-- 
1.7.12.4

