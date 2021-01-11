Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C067C2F24EA
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405340AbhALAZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390857AbhAKW6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 17:58:04 -0500
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E15C061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 14:57:24 -0800 (PST)
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
        by m0050093.ppops.net-00190b01. (8.16.0.43/8.16.0.43) with SMTP id 10BMF6Hc014068;
        Mon, 11 Jan 2021 22:24:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=/kB/hFZbGTXdfuCH87IQQIikycIjycJyFT/A4uTpOqg=;
 b=MLDGYDOmoN7RfKBzzm18ctT7iwaFhF4CjItOZ4GUZkIfuKG/9gkL/Dzr0r4XpjXng3+v
 PoBMRtY9aYq9Y1A2DzGT/buo8kJopRYYkytRomY4+O6Vm+VGkJjVzCHjjtafxSMcbwOl
 cG8aCBcywCVo3+gVJd+0if+oyrPlbR9ihwzP8XhxKyWFcODY4IZlh6LWCs0AoP6tYIOv
 R2j5upYkMQQUWSnLvLyE+oKYHECeTr/5oFh5zxIqYryohu9XjjHO31TrxoVgdhAf2Gje
 gqFytBpH9Wi+LuyptFG5iP86Zf/5789UsAF/jHM0QvEr1hCdbjhgKNBHEvsWvUbktfjA Ew== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by m0050093.ppops.net-00190b01. with ESMTP id 3605h7vkp9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 22:24:17 +0000
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 10BMJoMr002704;
        Mon, 11 Jan 2021 17:24:15 -0500
Received: from email.msg.corp.akamai.com ([172.27.123.32])
        by prod-mail-ppoint1.akamai.com with ESMTP id 35y8q2vu4u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 17:24:15 -0500
Received: from usma1ex-cas5.msg.corp.akamai.com (172.27.123.53) by
 usma1ex-dag3mb5.msg.corp.akamai.com (172.27.123.55) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Mon, 11 Jan 2021 17:24:14 -0500
Received: from bos-lhvedt.bos01.corp.akamai.com (172.28.223.201) by
 usma1ex-cas5.msg.corp.akamai.com (172.27.123.53) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Mon, 11 Jan 2021 17:24:14 -0500
Received: by bos-lhvedt.bos01.corp.akamai.com (Postfix, from userid 33863)
        id AF12616004E; Mon, 11 Jan 2021 17:24:14 -0500 (EST)
From:   Heath Caldwell <hcaldwel@akamai.com>
To:     <netdev@vger.kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Josh Hunt <johunt@akamai.com>, Ji Li <jli@akamai.com>,
        Heath Caldwell <hcaldwel@akamai.com>
Subject: [PATCH net-next 2/4] net: tcp: consistently account for overhead for SO_RCVBUF for TCP
Date:   Mon, 11 Jan 2021 17:24:09 -0500
Message-ID: <20210111222411.232916-3-hcaldwel@akamai.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210111222411.232916-1-hcaldwel@akamai.com>
References: <20210111222411.232916-1-hcaldwel@akamai.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_32:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=948
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110124
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_32:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=892 adultscore=0
 clxscore=1015 bulkscore=0 spamscore=0 impostorscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101110124
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.18)
 smtp.mailfrom=hcaldwel@akamai.com smtp.helo=prod-mail-ppoint1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When setting SO_RCVBUF for TCP sockets, account for overhead in accord with
sysctl_tcp_adv_win_scale.  This makes the receive buffer overhead
accounting for SO_RCVBUF consistent with how it is accounted elsewhere for
TCP sockets.

Signed-off-by: Heath Caldwell <hcaldwel@akamai.com>
---
 include/net/tcp.h | 17 +++++++++++++++++
 net/core/sock.c   |  6 ++++++
 2 files changed, 23 insertions(+)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 78d13c88720f..9961de3fbf09 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1408,6 +1408,23 @@ static inline int tcp_win_from_space(const struct sock *sk, int space)
 		space - (space>>tcp_adv_win_scale);
 }
 
+/* Calculate the amount of buffer space which would allow for the advertisement
+ * of a window size of win, accounting for overhead.
+ *
+ * This is the inverse of tcp_win_from_space().
+ */
+static inline int tcp_space_from_win(const struct sock *sk, int win)
+{
+	int tcp_adv_win_scale = sock_net(sk)->ipv4.sysctl_tcp_adv_win_scale;
+
+	return tcp_adv_win_scale <= 0 ?
+		win<<(-tcp_adv_win_scale) :
+		/* Division by zero is avoided because the above expression is
+		 * used when tcp_adv_win_scale == 0.
+		 */
+		(win<<tcp_adv_win_scale) / ((1<<tcp_adv_win_scale) - 1);
+}
+
 /* Note: caller must be prepared to deal with negative returns */
 static inline int tcp_space(const struct sock *sk)
 {
diff --git a/net/core/sock.c b/net/core/sock.c
index 0a9c19f52989..e919f62d5d34 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -783,6 +783,9 @@ EXPORT_SYMBOL(sock_set_keepalive);
  */
 static inline int sock_buf_size_to_available(struct sock *sk, int buf_size)
 {
+	if (sk->sk_protocol == IPPROTO_TCP)
+		return tcp_win_from_space(sk, buf_size);
+
 	return buf_size / 2;
 }
 
@@ -792,6 +795,9 @@ static inline int sock_buf_size_to_available(struct sock *sk, int buf_size)
  */
 static inline int sock_available_to_buf_size(struct sock *sk, int available)
 {
+	if (sk->sk_protocol == IPPROTO_TCP)
+		return tcp_space_from_win(sk, available);
+
 	return available * 2;
 }
 
-- 
2.28.0

