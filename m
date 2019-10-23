Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8653DE1EFD
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 17:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406564AbfJWPMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 11:12:01 -0400
Received: from mx0b-00190b01.pphosted.com ([67.231.157.127]:36810 "EHLO
        mx0b-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390140AbfJWPMA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 11:12:00 -0400
Received: from pps.filterd (m0122330.ppops.net [127.0.0.1])
        by mx0b-00190b01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9NF8M78001014;
        Wed, 23 Oct 2019 16:10:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references; s=jan2016.eng;
 bh=u/JjyQIcoV4c93KQJJgHN/CIzsf6K7Yn0dv80OiAIRA=;
 b=NFKi0BhC1sUkGbG7yQ4czWXLK9OUROXEQcQWPNLnuqfzOii4i7t/QJC2lr7vvGm0Waay
 EJbGpM3CUPXvg6VGcLOxYV1hbmssSCAhnjFoPKezfVjDe+fHYhiiRijm9qqHRO3qKQcS
 FourdJPIKXOyNH8l4R4/b/t7auWLn0BnE12mF6GqVHoRXXm15Z7mxJB+SDdCQvfFawgu
 hQVRVN7wJEL5pge/QTQqjhTkYLBN5qhzdCkdKW3cdKAvQe5sXBqXKrJe0GmslyDs4I+R
 msvM1zeLpQs05G7oeyoKmPVWW4fc7Km6XMQ7ue7TkZWedfwcekGd1Z51OM4vXwKMM45I eQ== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by mx0b-00190b01.pphosted.com with ESMTP id 2vqt4v315f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Oct 2019 16:10:53 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x9NF2EFT020093;
        Wed, 23 Oct 2019 11:10:52 -0400
Received: from prod-mail-relay10.akamai.com ([172.27.118.251])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2vqwtwt04q-1;
        Wed, 23 Oct 2019 11:10:51 -0400
Received: from bos-lpjec.kendall.corp.akamai.com (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay10.akamai.com (Postfix) with ESMTP id 88F3B1FCD8;
        Wed, 23 Oct 2019 15:10:51 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     netdev@vger.kernel.org, Neal Cardwell <ncardwell@google.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: [net-next v2] tcp: add TCP_INFO status for failed client TFO
Date:   Wed, 23 Oct 2019 11:09:26 -0400
Message-Id: <1571843366-14691-1-git-send-email-jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <2166c3ff-e08d-e89d-4753-01c8bd2d9505@akamai.com>
References: <2166c3ff-e08d-e89d-4753-01c8bd2d9505@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-23_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910230152
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-23_04:2019-10-23,2019-10-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 malwarescore=0 adultscore=0 priorityscore=1501 mlxscore=0
 bulkscore=0 spamscore=0 suspectscore=2 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1910230153
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

The newly added tcpi_fastopen_client_fail status is 2 bits and has the
following 4 states:

1) TFO_STATUS_UNSPEC

Catch-all state which includes when TFO is disabled via black hole
detection, which is indicated via LINUX_MIB_TCPFASTOPENBLACKHOLE.

2) TFO_COOKIE_UNAVAILABLE

If TFO_CLIENT_NO_COOKIE mode is off, this state indicates that no cookie
is available in the cache.

3) TFO_DATA_NOT_ACKED

Data was sent with SYN, we received a SYN/ACK but it did not cover the data
portion. Cookie is not accepted by server because the cookie may be invalid
or the server may be overloaded.

4) TFO_SYN_RETRANSMITTED

Data was sent with SYN, we received a SYN/ACK which did not cover the data
after at least 1 additional SYN was sent (without data). It may be the case
that a middle-box is dropping data-in-SYN packets. Thus, it would be more
efficient to not use TFO on this connection to avoid extra retransmits
during connection establishment.

These new fields do not cover all the cases where TFO may fail, but other
failures, such as SYN/ACK + data being dropped, will result in the
connection not becoming established. And a connection blackhole after
session establishment shows up as a stalled connection.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Cc: Christoph Paasch <cpaasch@apple.com>
Cc: Yuchung Cheng <ycheng@google.com>
---
v2:
  -use tp->total_retrans instead of syn_drop for the non-tfo case
  -improve state naming (Neal Cardwell)
  -s/TFO_NO_COOKIE_SENT/TFO_COOKIE_UNAVAILABLE - exclude black-hole
   from this state

 net/ipv4/tcp_fastopen.c  |  5 ++++-
 net/ipv4/tcp_input.c     |  4 ++++
 5 files changed, 20 insertions(+), 3 deletions(-)

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
index 81e6979..74af1f7 100644
--- a/include/uapi/linux/tcp.h
+++ b/include/uapi/linux/tcp.h
@@ -155,6 +155,14 @@ enum {
 	TCP_QUEUES_NR,
 };
 
+/* why fastopen failed from client perspective */
+enum tcp_fastopen_client_fail {
+	TFO_STATUS_UNSPEC, /* catch-all */
+	TFO_COOKIE_UNAVAILABLE, /* if not in TFO_CLIENT_NO_COOKIE mode */
+	TFO_DATA_NOT_ACKED, /* SYN-ACK did not ack SYN data */
+	TFO_SYN_RETRANSMITTED, /* SYN-ACK did not ack SYN data after timeout */
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
index 9f41a76..bb5fc97 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2657,6 +2657,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	/* Clean up fastopen related fields */
 	tcp_free_fastopen_req(tp);
 	inet->defer_connect = 0;
+	tp->fastopen_client_fail = 0;
 
 	WARN_ON(inet->inet_num && !icsk->icsk_bind_hash);
 
@@ -3296,6 +3297,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
 	info->tcpi_reord_seen = tp->reord_seen;
 	info->tcpi_rcv_ooopack = tp->rcv_ooopack;
 	info->tcpi_snd_wnd = tp->snd_wnd;
+	info->tcpi_fastopen_client_fail = tp->fastopen_client_fail;
 	unlock_sock_fast(sk, slow);
 }
 EXPORT_SYMBOL_GPL(tcp_get_info);
diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index 3fd4512..dabd2f1 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -422,7 +422,10 @@ bool tcp_fastopen_cookie_check(struct sock *sk, u16 *mss,
 		cookie->len = -1;
 		return true;
 	}
-	return cookie->len > 0;
+	if (cookie->len > 0)
+		return true;
+	tcp_sk(sk)->fastopen_client_fail = TFO_COOKIE_UNAVAILABLE;
+	return false;
 }
 
 /* This function checks if we want to defer sending SYN until the first
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 3578357a..d562774 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5812,6 +5812,10 @@ static bool tcp_rcv_fastopen_synack(struct sock *sk, struct sk_buff *synack,
 	tcp_fastopen_cache_set(sk, mss, cookie, syn_drop, try_exp);
 
 	if (data) { /* Retransmit unacked data in SYN */
+		if (tp->total_retrans)
+			tp->fastopen_client_fail = TFO_SYN_RETRANSMITTED;
+		else
+			tp->fastopen_client_fail = TFO_DATA_NOT_ACKED;
 		skb_rbtree_walk_from(data) {
 			if (__tcp_retransmit_skb(sk, data, 1))
 				break;
-- 
2.7.4

