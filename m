Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35ADF2D2764
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgLHJVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:21:36 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:58571 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727151AbgLHJVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:21:36 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UHyyKRs_1607419253;
Received: from localhost(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0UHyyKRs_1607419253)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 08 Dec 2020 17:20:53 +0800
From:   Cambda Zhu <cambda@linux.alibaba.com>
To:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Cambda Zhu <cambda@linux.alibaba.com>
Subject: [PATCH net-next] net: Limit logical shift left of TCP probe0 timeout
Date:   Tue,  8 Dec 2020 17:19:10 +0800
Message-Id: <20201208091910.37618-1-cambda@linux.alibaba.com>
X-Mailer: git-send-email 2.16.6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For each TCP zero window probe, the icsk_backoff is increased by one and
its max value is tcp_retries2. If tcp_retries2 is greater than 63, the
probe0 timeout shift may exceed its max bits. On x86_64/ARMv8/MIPS, the
shift count would be masked to range 0 to 63. And on ARMv7 the result is
zero. If the shift count is masked, only several probes will be sent
with timeout shorter than TCP_RTO_MAX. But if the timeout is zero, it
needs tcp_retries2 times probes to end this false timeout. Besides,
bitwise shift greater than or equal to the width is an undefined
behavior.

This patch adds a limit to the backoff. The max value of max_when is
TCP_RTO_MAX and the min value of timeout base is TCP_RTO_MIN. The limit
is the backoff from TCP_RTO_MIN to TCP_RTO_MAX.

Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
---
 include/net/tcp.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index d4ef5bf94168..82044179c345 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1321,7 +1321,9 @@ static inline unsigned long tcp_probe0_base(const struct sock *sk)
 static inline unsigned long tcp_probe0_when(const struct sock *sk,
 					    unsigned long max_when)
 {
-	u64 when = (u64)tcp_probe0_base(sk) << inet_csk(sk)->icsk_backoff;
+	u8 backoff = min_t(u8, ilog2(TCP_RTO_MAX / TCP_RTO_MIN) + 1,
+			   inet_csk(sk)->icsk_backoff);
+	u64 when = (u64)tcp_probe0_base(sk) << backoff;
 
 	return (unsigned long)min_t(u64, when, max_when);
 }
-- 
2.16.6

