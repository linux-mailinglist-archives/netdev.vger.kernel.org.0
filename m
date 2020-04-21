Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D57A1B25C8
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 14:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728576AbgDUMSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 08:18:53 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:48544 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726018AbgDUMSw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 08:18:52 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01355;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TwElGzd_1587471526;
Received: from localhost(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0TwElGzd_1587471526)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 21 Apr 2020 20:18:46 +0800
From:   Cambda Zhu <cambda@linux.alibaba.com>
To:     netdev <netdev@vger.kernel.org>
Cc:     Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Cambda Zhu <cambda@linux.alibaba.com>
Subject: [PATCH net-next] net: Add TCP_FORCE_LINGER2 to TCP setsockopt
Date:   Tue, 21 Apr 2020 20:17:37 +0800
Message-Id: <20200421121737.3269-1-cambda@linux.alibaba.com>
X-Mailer: git-send-email 2.16.6
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a new TCP socket option named TCP_FORCE_LINGER2. The
option has same behavior as TCP_LINGER2, except the tp->linger2 value
can be greater than sysctl_tcp_fin_timeout if the user_ns is capable
with CAP_NET_ADMIN.

As a server, different sockets may need different FIN-WAIT timeout and
in most cases the system default value will be used. The timeout can
be adjusted by setting TCP_LINGER2 but cannot be greater than the
system default value. If one socket needs a timeout greater than the
default, we have to adjust the sysctl which affects all sockets using
the system default value. And if we want to adjust it for just one
socket and keep the original value for others, all the other sockets
have to set TCP_LINGER2. But with TCP_FORCE_LINGER2, the net admin can
set greater tp->linger2 than the default for one socket and keep
the sysctl_tcp_fin_timeout unchanged.

Signed-off-by: Cambda Zhu <cambda@linux.alibaba.com>
---
 include/uapi/linux/capability.h | 1 +
 include/uapi/linux/tcp.h        | 1 +
 net/ipv4/tcp.c                  | 9 +++++++++
 3 files changed, 11 insertions(+)

diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
index 272dc69fa080..0e30c9756a04 100644
--- a/include/uapi/linux/capability.h
+++ b/include/uapi/linux/capability.h
@@ -199,6 +199,7 @@ struct vfs_ns_cap_data {
 /* Allow multicasting */
 /* Allow read/write of device-specific registers */
 /* Allow activation of ATM control sockets */
+/* Allow setting TCP_LINGER2 regardless of sysctl_tcp_fin_timeout */
 
 #define CAP_NET_ADMIN        12
 
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index f2acb2566333..e21e0ce98ca1 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -128,6 +128,7 @@ enum {
 #define TCP_CM_INQ		TCP_INQ
 
 #define TCP_TX_DELAY		37	/* delay outgoing packets by XX usec */
+#define TCP_FORCE_LINGER2	38	/* Set TCP_LINGER2 regardless of sysctl_tcp_fin_timeout */
 
 
 #define TCP_REPAIR_ON		1
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 6d87de434377..898a675d863e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3149,6 +3149,15 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 			tcp_enable_tx_delay();
 		tp->tcp_tx_delay = val;
 		break;
+	case TCP_FORCE_LINGER2:
+		if (val < 0)
+			tp->linger2 = -1;
+		else if (val > net->ipv4.sysctl_tcp_fin_timeout / HZ &&
+			 !ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
+			tp->linger2 = 0;
+		else
+			tp->linger2 = val * HZ;
+		break;
 	default:
 		err = -ENOPROTOOPT;
 		break;
-- 
2.16.6

