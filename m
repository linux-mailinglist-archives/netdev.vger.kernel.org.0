Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BA01B6F8A
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 10:06:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgDXIGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 04:06:40 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:52800 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726056AbgDXIGk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 04:06:40 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07488;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TwV6G4f_1587715597;
Received: from localhost(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0TwV6G4f_1587715597)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 24 Apr 2020 16:06:37 +0800
From:   Cambda Zhu <cambda@linux.alibaba.com>
To:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Cambda Zhu <cambda@linux.alibaba.com>
Subject: [PATCH net-next v3] net: Replace the limit of TCP_LINGER2 with TCP_FIN_TIMEOUT_MAX
Date:   Fri, 24 Apr 2020 16:06:16 +0800
Message-Id: <20200424080616.85447-1-cambda@linux.alibaba.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <20200423073529.92152-1-cambda@linux.alibaba.com>
References: <20200423073529.92152-1-cambda@linux.alibaba.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes the behavior of TCP_LINGER2 about its limit. The
sysctl_tcp_fin_timeout used to be the limit of TCP_LINGER2 but now it's
only the default value. A new macro named TCP_FIN_TIMEOUT_MAX is added
as the limit of TCP_LINGER2, which is 2 minutes.

Since TCP_LINGER2 used sysctl_tcp_fin_timeout as the default value
and the limit in the past, the system administrator cannot set the
default value for most of sockets and let some sockets have a greater
timeout. It might be a mistake that let the sysctl to be the limit of
the TCP_LINGER2. Maybe we can add a new sysctl to set the max of
TCP_LINGER2, but FIN-WAIT-2 timeout is usually no need to be too long
and 2 minutes are legal considering TCP specs.

Changes in v3:
- Remove the new socket option and change the TCP_LINGER2 behavior so
  that the timeout can be set to value between sysctl_tcp_fin_timeout
  and 2 minutes.

Changes in v2:
- Add int overflow check for the new socket option.

Changes in v1:
- Add a new socket option to set timeout greater than
  sysctl_tcp_fin_timeout.

Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
---
 include/net/tcp.h | 1 +
 net/ipv4/tcp.c    | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 5fa9eacd965a..cde8a1f75caa 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -126,6 +126,7 @@ void tcp_time_wait(struct sock *sk, int state, int timeo);
 				  * to combine FIN-WAIT-2 timeout with
 				  * TIME-WAIT timer.
 				  */
+#define TCP_FIN_TIMEOUT_MAX (120 * HZ) /* max TCP_LINGER2 value (two minutes) */
 
 #define TCP_DELACK_MAX	((unsigned)(HZ/5))	/* maximal time to delay before sending an ACK */
 #if HZ >= 100
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6d87de434377..8c1250103959 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3035,8 +3035,8 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 	case TCP_LINGER2:
 		if (val < 0)
 			tp->linger2 = -1;
-		else if (val > net->ipv4.sysctl_tcp_fin_timeout / HZ)
-			tp->linger2 = 0;
+		else if (val > TCP_FIN_TIMEOUT_MAX / HZ)
+			tp->linger2 = TCP_FIN_TIMEOUT_MAX;
 		else
 			tp->linger2 = val * HZ;
 		break;
-- 
2.16.6

