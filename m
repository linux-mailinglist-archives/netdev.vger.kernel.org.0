Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD6F39D8EE
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 11:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230265AbhFGJhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 05:37:39 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:50717 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229436AbhFGJhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 05:37:38 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=chengshuyi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UbaGK7H_1623058536;
Received: from localhost(mailfrom:chengshuyi@linux.alibaba.com fp:SMTPD_---0UbaGK7H_1623058536)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Jun 2021 17:35:44 +0800
From:   Shuyi Cheng <chengshuyi@linux.alibaba.com>
To:     chengshuyi@linux.alibaba.com, edumazet@google.com,
        davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: tcp:  Updating MSS, when the sending window is smaller than MSS.
Date:   Mon,  7 Jun 2021 17:35:34 +0800
Message-Id: <1623058534-78782-1-git-send-email-chengshuyi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the lo network card is used for communication, the tcp server
reduces the size of the receiving buffer, causing the tcp client
to have a delay of 200ms. Examples are as follows:

Suppose that the MTU of the lo network card is 65536, and the tcp server
sets the receive buffer size to 42KB. According to the
tcp_bound_to_half_wnd function, the MSS of the server and client is
21KB. Then, the tcp server sets the buffer size of the connection to
16KB. At this time, the MSS of the server is 8KB, and the MSS of the
client is still 21KB. But it will cause the client to fail to send the
message, that is, tcp_write_xmit fails. Mainly because tcp_snd_wnd_test
failed, and then entered the zero window detection phase, resulting in a
200ms delay.

Therefore, we mainly modify two places. One is the tcp_current_mss
function. When the sending window is smaller than the current mss, mss
needs to be updated. The other is the tcp_bound_to_half_wnd function.
When the sending window is smaller than the current mss, the mss value
should be calculated according to the current sending window, not
max_window.

Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
---
 include/net/tcp.h     | 11 ++++++++---
 net/ipv4/tcp_output.c |  3 ++-
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index e668f1b..fcdef16 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -641,6 +641,11 @@ static inline void tcp_clear_xmit_timers(struct sock *sk)
 static inline int tcp_bound_to_half_wnd(struct tcp_sock *tp, int pktsize)
 {
 	int cutoff;
+	int window;
+
+	window = tp->max_window;
+	if (tp->snd_wnd && tp->snd_wnd < pktsize)
+		window = tp->snd_wnd;
 
 	/* When peer uses tiny windows, there is no use in packetizing
 	 * to sub-MSS pieces for the sake of SWS or making sure there
@@ -649,10 +654,10 @@ static inline int tcp_bound_to_half_wnd(struct tcp_sock *tp, int pktsize)
 	 * On the other hand, for extremely large MSS devices, handling
 	 * smaller than MSS windows in this way does make sense.
 	 */
-	if (tp->max_window > TCP_MSS_DEFAULT)
-		cutoff = (tp->max_window >> 1);
+	if (window > TCP_MSS_DEFAULT)
+		cutoff = (window >> 1);
 	else
-		cutoff = tp->max_window;
+		cutoff = window;
 
 	if (cutoff && pktsize > cutoff)
 		return max_t(int, cutoff, 68U - tp->tcp_header_len);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index bde781f..88dcdf2 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1833,7 +1833,8 @@ unsigned int tcp_current_mss(struct sock *sk)
 
 	if (dst) {
 		u32 mtu = dst_mtu(dst);
-		if (mtu != inet_csk(sk)->icsk_pmtu_cookie)
+		if (mtu != inet_csk(sk)->icsk_pmtu_cookie ||
+		    (tp->snd_wnd && tp->snd_wnd < mss_now))
 			mss_now = tcp_sync_mss(sk, mtu);
 	}
 
-- 
1.8.3.1

