Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74FD11EB876
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 11:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgFBJ1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 05:27:09 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:55974 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726217AbgFBJ1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 05:27:07 -0400
Received: from mxbackcorp1j.mail.yandex.net (mxbackcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::162])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id E26502E1490;
        Tue,  2 Jun 2020 12:27:04 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by mxbackcorp1j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id 8njmU6Kz7y-R3euAj23;
        Tue, 02 Jun 2020 12:27:04 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1591090024; bh=fu0qBkaW2WkzHgmrz6s1/QO253a20SDKF+LHS3iIv1I=;
        h=In-Reply-To:Message-Id:References:Date:Subject:To:From:Cc;
        b=ObMN2gcRo/b5YomirQ5Sc+ykR0X9OGNUxHZj3p2fYgWBiNBhWtzFD9FQUpbgO5Xhw
         cI8bcFe5HOHnS/Z1xqctjPgfj9Dr/H5xo7twPEwobGc88GAfYROF5o7cnNl4dwN8CQ
         3shJcqV2+l5b+HQMZC8r5nAGiMx8kQkolXcr6LQw=
Authentication-Results: mxbackcorp1j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [178.154.185.106])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id FNNM5B9k9b-R3WSxbb6;
        Tue, 02 Jun 2020 12:27:03 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com
Cc:     davem@davemloft.net, brakmo@fb.com, eric.dumazet@gmail.com,
        kafai@fb.com, bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next v3 3/3] bpf: add SO_KEEPALIVE and related options to bpf_setsockopt
Date:   Tue,  2 Jun 2020 12:26:48 +0300
Message-Id: <20200602092648.50440-3-zeil@yandex-team.ru>
In-Reply-To: <20200602092648.50440-1-zeil@yandex-team.ru>
References: <20200602092648.50440-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support of SO_KEEPALIVE flag and TCP related options
to bpf_setsockopt() routine. This is helpful if we want to enable or tune
TCP keepalive for applications which don't do it in the userspace code.

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
Acked-by: Martin KaFai Lau <kafai@fb.com>
---
 net/core/filter.c | 36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

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

