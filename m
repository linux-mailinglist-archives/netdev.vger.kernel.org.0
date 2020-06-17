Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309041FCBAA
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 13:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgFQLCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 07:02:49 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:34040 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726541AbgFQLCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 07:02:47 -0400
Received: from mxbackcorp1o.mail.yandex.net (mxbackcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::301])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id BF7772E15D7;
        Wed, 17 Jun 2020 14:02:44 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by mxbackcorp1o.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id 8bVd2SQGLV-2gaiHWLh;
        Wed, 17 Jun 2020 14:02:44 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1592391764; bh=5DydsKYe2yyQXWLg6DiPRgeyXzchovJ5c/vHirY2OBM=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=lWUE07ugra6C9j8QsZ9UHg5NJpWMfzr4VEAJi046ySUvGuVZB+WjLSeIupsOu+bIo
         bdkM2PXP2pjfZCpQzkgDRmMX/AlAbyprpKe/NcL4bR1GDXsc5jOCpOs/BQ4Hd2RdB4
         gZbxDWgttRWFYnWs58vbwxS2gc2jYqRC09tXsC90=
Authentication-Results: mxbackcorp1o.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 37.9.89.23-iva.dhcp.yndx.net (37.9.89.23-iva.dhcp.yndx.net [37.9.89.23])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id XJqgFOjlJF-2gkiJtj6;
        Wed, 17 Jun 2020 14:02:42 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     daniel@iogearbox.net, alexei.starovoitov@gmail.com
Cc:     davem@davemloft.net, brakmo@fb.com, eric.dumazet@gmail.com,
        kafai@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v4 3/3] bpf: add SO_KEEPALIVE and related options to bpf_setsockopt
Date:   Wed, 17 Jun 2020 14:02:17 +0300
Message-Id: <20200617110217.35669-3-zeil@yandex-team.ru>
In-Reply-To: <20200617110217.35669-1-zeil@yandex-team.ru>
References: <20200617110217.35669-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support of SO_KEEPALIVE flag and TCP related options
to bpf_setsockopt() routine. This is helpful if we want to enable or tune
TCP keepalive for applications which don't do it in the userspace code.

v2:
  - update kernel-doc (Nikita Vetoshkin <nekto0n@yandex-team.ru>)

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 include/uapi/linux/bpf.h |  7 +++++--
 net/core/filter.c        | 36 +++++++++++++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index b9ed9f1..3b8815d 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -1621,10 +1621,13 @@ union bpf_attr {
  *
  * 		* **SOL_SOCKET**, which supports the following *optname*\ s:
  * 		  **SO_RCVBUF**, **SO_SNDBUF**, **SO_MAX_PACING_RATE**,
- * 		  **SO_PRIORITY**, **SO_RCVLOWAT**, **SO_MARK**.
+ * 		  **SO_PRIORITY**, **SO_RCVLOWAT**, **SO_MARK**,
+ * 		  **SO_BINDTODEVICE**, **SO_KEEPALIVE**.
  * 		* **IPPROTO_TCP**, which supports the following *optname*\ s:
  * 		  **TCP_CONGESTION**, **TCP_BPF_IW**,
- * 		  **TCP_BPF_SNDCWND_CLAMP**.
+ * 		  **TCP_BPF_SNDCWND_CLAMP**, **TCP_SAVE_SYN**,
+ * 		  **TCP_KEEPIDLE**, **TCP_KEEPINTVL**, **TCP_KEEPCNT**,
+ * 		  **TCP_SYNCNT**, **TCP_USER_TIMEOUT**.
  * 		* **IPPROTO_IP**, which supports *optname* **IP_TOS**.
  * 		* **IPPROTO_IPV6**, which supports *optname* **IPV6_TCLASS**.
  * 	Return
diff --git a/net/core/filter.c b/net/core/filter.c
index ae82bcb..674272c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4249,10 +4249,10 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 			   char *optval, int optlen, u32 flags)
 {
 	char devname[IFNAMSIZ];
+	int val, valbool;
 	struct net *net;
 	int ifindex;
 	int ret = 0;
-	int val;
 
 	if (!sk_fullsock(sk))
 		return -EINVAL;
@@ -4263,6 +4263,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 		if (optlen != sizeof(int) && optname != SO_BINDTODEVICE)
 			return -EINVAL;
 		val = *((int *)optval);
+		valbool = val ? 1 : 0;
 
 		/* Only some socketops are supported */
 		switch (optname) {
@@ -4324,6 +4325,11 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 			ret = sock_bindtoindex(sk, ifindex, false);
 #endif
 			break;
+		case SO_KEEPALIVE:
+			if (sk->sk_prot->keepalive)
+				sk->sk_prot->keepalive(sk, valbool);
+			sock_valbool_flag(sk, SOCK_KEEPOPEN, valbool);
+			break;
 		default:
 			ret = -EINVAL;
 		}
@@ -4384,6 +4390,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 			ret = tcp_set_congestion_control(sk, name, false,
 							 reinit, true);
 		} else {
+			struct inet_connection_sock *icsk = inet_csk(sk);
 			struct tcp_sock *tp = tcp_sk(sk);
 
 			if (optlen != sizeof(int))
@@ -4412,6 +4419,33 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 				else
 					tp->save_syn = val;
 				break;
+			case TCP_KEEPIDLE:
+				ret = tcp_sock_set_keepidle_locked(sk, val);
+				break;
+			case TCP_KEEPINTVL:
+				if (val < 1 || val > MAX_TCP_KEEPINTVL)
+					ret = -EINVAL;
+				else
+					tp->keepalive_intvl = val * HZ;
+				break;
+			case TCP_KEEPCNT:
+				if (val < 1 || val > MAX_TCP_KEEPCNT)
+					ret = -EINVAL;
+				else
+					tp->keepalive_probes = val;
+				break;
+			case TCP_SYNCNT:
+				if (val < 1 || val > MAX_TCP_SYNCNT)
+					ret = -EINVAL;
+				else
+					icsk->icsk_syn_retries = val;
+				break;
+			case TCP_USER_TIMEOUT:
+				if (val < 0)
+					ret = -EINVAL;
+				else
+					icsk->icsk_user_timeout = val;
+				break;
 			default:
 				ret = -EINVAL;
 			}
-- 
2.7.4

