Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B981B55DE
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 09:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgDWHf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 03:35:59 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:56877 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725562AbgDWHf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 03:35:59 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=cambda@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0TwPIeUI_1587627354;
Received: from localhost(mailfrom:cambda@linux.alibaba.com fp:SMTPD_---0TwPIeUI_1587627354)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 23 Apr 2020 15:35:55 +0800
From:   Cambda Zhu <cambda@linux.alibaba.com>
To:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Dust Li <dust.li@linux.alibaba.com>,
        Tony Lu <tonylu@linux.alibaba.com>,
        Cambda Zhu <cambda@linux.alibaba.com>
Subject: [PATCH net-next v2] net: Add TCP_FORCE_LINGER2 to TCP setsockopt
Date:   Thu, 23 Apr 2020 15:35:29 +0800
Message-Id: <20200423073529.92152-1-cambda@linux.alibaba.com>
X-Mailer: git-send-email 2.16.6
In-Reply-To: <eea2a2c3-79dc-131c-4ef5-ee027b30b701@gmail.com>
References: <eea2a2c3-79dc-131c-4ef5-ee027b30b701@gmail.com>
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
 Changes in v2:
   - Add int overflow check.

 include/uapi/linux/capability.h |  1 +
 include/uapi/linux/tcp.h        |  1 +
 net/ipv4/tcp.c                  | 11 +++++++++++
 3 files changed, 13 insertions(+)

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
index 6d87de434377..d8cd1fd66bc1 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3149,6 +3149,17 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 			tcp_enable_tx_delay();
 		tp->tcp_tx_delay = val;
 		break;
+	case TCP_FORCE_LINGER2:
+		if (val < 0)
+			tp->linger2 = -1;
+		else if (val > INT_MAX / HZ)
+			err = -EINVAL;
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

