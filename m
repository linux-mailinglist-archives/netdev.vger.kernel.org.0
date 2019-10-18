Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3CFADCEEC
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436538AbfJRTDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:03:38 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:19542 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727542AbfJRTDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 15:03:37 -0400
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x9IJ2VS6000409;
        Fri, 18 Oct 2019 20:03:31 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=BNh/r0+u2z6yrVQMe5Xm6iQKkEv+yiZObK7tKz8l10U=;
 b=MVjLUNcqHzKcwHDiso2q5/DOsDEHliK9DaeZCOR3yE+HuB+zw0B/4HB2wNQ5GHtHN8qM
 wBQaam+ZjwqQShAt7yhqR5Xo78OdcFOeXNL8ygGGR2+rG69aQYYEmHYNPf+ohBdUlzF+
 5Kgrve4UQhscRsILXuBo1/8a0WG6QTtizW5/Or1ah3aMK3A4YGuLDJNMkP/r9TyduVlw
 pa4/AqT6WENHMHQSVszlg5HRh+3Y2hmHmGqNwYXtSgGeutQ2cbeSwkP5sDhcWJ/rL1Zq
 TJTarXe7bPsmGvdql52HczWRB8A4EiBZLirbTJE/HVsvNJz3ZN2ti+yN1yszt/k2aiOo FQ== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by m0050095.ppops.net-00190b01. with ESMTP id 2vnp4qg045-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Oct 2019 20:03:28 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x9IJ2Bsr011973;
        Fri, 18 Oct 2019 15:03:27 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2vka5xmtrg-1;
        Fri, 18 Oct 2019 15:03:27 -0400
Received: from bos-lpjec.kendall.corp.akamai.com (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id 806C91FCAA;
        Fri, 18 Oct 2019 19:03:27 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Christoph Paasch <cpaasch@apple.com>
Subject: [net-next] tcp: add TCP_INFO status for failed client TFO
Date:   Fri, 18 Oct 2019 15:02:20 -0400
Message-Id: <1571425340-7082-1-git-send-email-jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-18_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910180169
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-18_04:2019-10-18,2019-10-18 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 priorityscore=1501
 spamscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 suspectscore=0 adultscore=0 clxscore=1011 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1910180169
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The TCPI_OPT_SYN_DATA bit as part of tcpi_options currently reports whether
or not data-in-SYN was ack'd on both the client and server side. We'd like
to gather more information on the client-side in the failure case in order
to indicate the reason for the failure. This can be useful for not only
debugging TFO, but also for creating TFO socket policies. For example, if
a middle box removes the TFO option or drops a data-in-SYN, we can
can detect this case, and turn off TFO for these connections saving the
extra retransmits.

The newly added tcpi_fastopen_client_fail status is 2 bits and has 4
states:

1) TFO_STATUS_UNSPEC

catch-all.

2) TFO_NO_COOKIE_SENT

If TFO_CLIENT_NO_COOKIE mode is off, this state indicates that no cookie
was sent because we don't have one yet, its not in cache or black-holing
may be enabled (already indicated by the global
LINUX_MIB_TCPFASTOPENBLACKHOLE).

3) TFO_NO_SYN_DATA

Data was sent with SYN, we received a SYN/ACK but it did not cover the data
portion. Cookie is not accepted by server because the cookie may be invalid
or the server may be overloaded.


4) TFO_NO_SYN_DATA_TIMEOUT

Data was sent with SYN, we received a SYN/ACK which did not cover the data
after at least 1 additional SYN was sent (without data). It may be the case
that a middle-box is dropping data-in-SYN packets. Thus, it would be more
efficient to not use TFO on this connection to avoid extra retransmits
during connection establishment.

These new fields certainly not cover all the cases where TFO may fail, but
other failures, such as SYN/ACK + data being dropped, will result in the
connection not becoming established. And a connection blackhole after
session establishment shows up as a stalled connection.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Christoph Paasch <cpaasch@apple.com>
---
 include/linux/tcp.h      |  2 +-
 include/uapi/linux/tcp.h | 10 +++++++++-
 net/ipv4/tcp.c           |  1 +
 net/ipv4/tcp_fastopen.c  |  9 +++++++--
 net/ipv4/tcp_input.c     |  5 +++++
 5 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/include/linux/tcp.h b/include/linux/tcp.h
index 99617e5..7790f28 100644
--- a/include/linux/tcp.h
+++ b/include/linux/tcp.h
@@ -223,7 +223,7 @@ struct tcp_sock {
 		fastopen_connect:1, /* FASTOPEN_CONNECT sockopt */
 		fastopen_no_cookie:1, /* Allow send/recv SYN+data without a cookie */
 		is_sack_reneg:1,    /* in recovery from loss with SACK reneg? */
-		unused:2;
+		fastopen_client_fail:2; /* reason why fastopen failed */
 	u8	nonagle     : 4,/* Disable Nagle algorithm?             */
 		thin_lto    : 1,/* Use linear timeouts for thin streams */
 		recvmsg_inq : 1,/* Indicate # of bytes in queue upon recvmsg */
diff --git a/include/uapi/linux/tcp.h b/include/uapi/linux/tcp.h
index 81e6979..dbee3ed 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -155,6 +155,14 @@ enum {
 	TCP_QUEUES_NR,
 };
 
+/* why fastopen failed from client perspective */
+enum tcp_fastopen_client_fail {
+	TFO_STATUS_UNSPEC, /* catch-all */
+	TFO_NO_COOKIE_SENT, /* if not in TFO_CLIENT_NO_COOKIE mode */
+	TFO_NO_SYN_DATA, /* SYN-ACK did not ack SYN data */
+	TFO_NO_SYN_DATA_TIMEOUT /* SYN-ACK did not ack SYN data after timeout */
+};
+
 /* for TCP_INFO socket option */
 #define TCPI_OPT_TIMESTAMPS	1
 #define TCPI_OPT_SACK		2
@@ -211,7 +219,7 @@ struct tcp_info {
 	__u8	tcpi_backoff;
 	__u8	tcpi_options;
 	__u8	tcpi_snd_wscale : 4, tcpi_rcv_wscale : 4;
-	__u8	tcpi_delivery_rate_app_limited:1;
+	__u8	tcpi_delivery_rate_app_limited:1, tcpi_fastopen_client_fail:2;
 
 	__u32	tcpi_rto;
 	__u32	tcpi_ato;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9f41a76..764f623 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -3296,6 +3296,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
 	info->tcpi_reord_seen = tp->reord_seen;
 	info->tcpi_rcv_ooopack = tp->rcv_ooopack;
 	info->tcpi_snd_wnd = tp->snd_wnd;
+	info->tcpi_fastopen_client_fail = tp->fastopen_client_fail;
 	unlock_sock_fast(sk, slow);
 }
 EXPORT_SYMBOL_GPL(tcp_get_info);
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 3fd4512..d88286d 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -413,7 +413,7 @@ bool tcp_fastopen_cookie_check(struct sock *sk, u16 *mss,
 	/* Firewall blackhole issue check */
 	if (tcp_fastopen_active_should_disable(sk)) {
 		cookie->len = -1;
-		return false;
+		goto no_cookie;
 	}
 
 	dst = __sk_dst_get(sk);
@@ -422,7 +422,12 @@ bool tcp_fastopen_cookie_check(struct sock *sk, u16 *mss,
 		cookie->len = -1;
 		return true;
 	}
-	return cookie->len > 0;
+	if (cookie->len > 0)
+		return true;
+
+no_cookie:
+	tcp_sk(sk)->fastopen_client_fail = TFO_NO_COOKIE_SENT;
+	return false;
 }
 
 /* This function checks if we want to defer sending SYN until the first
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3578357a..357f757 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5819,6 +5819,11 @@ static bool tcp_rcv_fastopen_synack(struct sock *sk, struct sk_buff *synack,
 		tcp_rearm_rto(sk);
 		NET_INC_STATS(sock_net(sk),
 				LINUX_MIB_TCPFASTOPENACTIVEFAIL);
+		if (syn_drop)
+			tp->fastopen_client_fail = TFO_NO_SYN_DATA_TIMEOUT;
+		else
+			tp->fastopen_client_fail = TFO_NO_SYN_DATA;
+
 		return true;
 	}
 	tp->syn_data_acked = tp->syn_data;
-- 
2.7.4

