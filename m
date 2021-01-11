Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53BF02F24E9
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405345AbhALAZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390908AbhAKXCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 18:02:54 -0500
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B02DC061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 15:02:13 -0800 (PST)
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10BMNTNi010313;
        Mon, 11 Jan 2021 22:24:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=jan2016.eng;
 bh=q4ubsMsFa832LtHHGYTOI5j9eDgqlUJBNQI7iRUdbWo=;
 b=oS9I6huPEAc8IrdPYR+WrGpJwtUfwLANDhu93wLY91fNFuYMyevw03D//ppZZWTHMlR9
 LyD/aai7X00UOZrCRzBYZz3dv0sm3WNPoMeEkg/MkrQ2GjFqR6pzUSs74n/QB6nlZ4Bs
 0vEHBeblSIwoFJ/iFAyOZQ1gGsumd3qrVgCO/+qa/CSOPMhE0tmzTSDhYtWP+lhzJuc+
 a6M+YIvKTKOd4kFi2HvtH4g+cNgprvfqXmRVcXVXaIImSuZkIHZsrIKSOwhpFgYBINVn
 0g24qPmhbfVlA45pfmmoH+2snrJBjx1TWWmSgj1ZZAnVPizwqVNm4l1LUFIq0G6kvM5y iQ== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 35y5m4t82g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 22:24:16 +0000
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 10BMJeKl013411;
        Mon, 11 Jan 2021 14:24:15 -0800
Received: from email.msg.corp.akamai.com ([172.27.123.53])
        by prod-mail-ppoint5.akamai.com with ESMTP id 35ybbe4hpn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 11 Jan 2021 14:24:15 -0800
Received: from usma1ex-cas5.msg.corp.akamai.com (172.27.123.53) by
 usma1ex-dag3mb4.msg.corp.akamai.com (172.27.123.56) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Mon, 11 Jan 2021 17:24:14 -0500
Received: from bos-lhvedt.bos01.corp.akamai.com (172.28.223.201) by
 usma1ex-cas5.msg.corp.akamai.com (172.27.123.53) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Mon, 11 Jan 2021 17:24:14 -0500
Received: by bos-lhvedt.bos01.corp.akamai.com (Postfix, from userid 33863)
        id AC78316004D; Mon, 11 Jan 2021 17:24:14 -0500 (EST)
From:   Heath Caldwell <hcaldwel@akamai.com>
To:     <netdev@vger.kernel.org>
CC:     Eric Dumazet <edumazet@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Josh Hunt <johunt@akamai.com>, Ji Li <jli@akamai.com>,
        Heath Caldwell <hcaldwel@akamai.com>
Subject: [PATCH net-next 1/4] net: account for overhead when restricting SO_RCVBUF
Date:   Mon, 11 Jan 2021 17:24:08 -0500
Message-ID: <20210111222411.232916-2-hcaldwel@akamai.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210111222411.232916-1-hcaldwel@akamai.com>
References: <20210111222411.232916-1-hcaldwel@akamai.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_32:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110124
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-11_32:2021-01-11,2021-01-11 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 clxscore=1015
 phishscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0 suspectscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101110125
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.60)
 smtp.mailfrom=hcaldwel@akamai.com smtp.helo=prod-mail-ppoint5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When restricting the value supplied for SO_RCVBUF to be no greater than
what is specified by sysctl_rmem_max, properly cap the value to
the *available* space that sysctl_rmem_max would provide, rather than to
the raw value of sysctl_rmem_max.

Without this change, it is possible to cause sk_rcvbuf to be assigned a
value larger than sysctl_rmem_max via setsockopt() for SO_RCVBUF.

To illustrate:

    If an application calls setsockopt() to set SO_RCVBUF to some value, R,
    such that:

        sysctl_rmem_max / 2  <  R  <  sysctl_rmem_max

    and sk_rcvbuf will be assigned to some value, V, such that:

        V = R * 2

    which produces:

        R = V / 2

    Then,

        sysctl_rmem_max / 2  <  V / 2  <  sysctl_rmem_max

    which produces:

        sysctl_rmem_max  <  V  <  2 * sysctl_rmem_max

For example:

    If sysctl_rmem_max has a value of 212992,

    and an application calls setsockopt() to set SO_RCVBUF to 200000 (which
    is less than sysctl_rmem_max, but greater than sysctl_rmem_max/2),
    then,

    without this change, sk_rcvbuf would be set to 2*200000 = 400000, which
    is larger than sysctl_rmem_max.

This change restricts the domain of R to [0, sysctl_rmem_max/2], removing
the possibility for V to be greater than sysctl_rmem_max.

Also, abstract the actions of converting "buffer" space to and from
"available" space and clarify comments.

Signed-off-by: Heath Caldwell <hcaldwel@akamai.com>
---
 net/core/sock.c | 83 +++++++++++++++++++++++++++++++++++--------------
 1 file changed, 60 insertions(+), 23 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index bbcd4b97eddd..0a9c19f52989 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -778,25 +778,46 @@ void sock_set_keepalive(struct sock *sk)
 }
 EXPORT_SYMBOL(sock_set_keepalive);
 
+/* Convert a buffer size value (which accounts for overhead) to the amount of
+ * space which would be available for data in a buffer that size.
+ */
+static inline int sock_buf_size_to_available(struct sock *sk, int buf_size)
+{
+	return buf_size / 2;
+}
+
+/* Convert a size value for an amount of data ("available") to the size of
+ * buffer necessary to accommodate that amount of data (accounting for
+ * overhead).
+ */
+static inline int sock_available_to_buf_size(struct sock *sk, int available)
+{
+	return available * 2;
+}
+
+/* Applications likely assume that successfully setting SO_RCVBUF will allow for
+ * the requested amount of data to be received on the socket.  Applications are
+ * not expected to account for implementation specific overhead which may also
+ * take up space in the receive buffer.
+ *
+ * In other words: applications supply a value in "available" space - that is,
+ * *not* including overhead - to SO_RCVBUF, which must be converted to "buffer"
+ * space - that is, *including* overhead - to obtain the effective size
+ * required.
+ *
+ * val is in "available" space.
+ */
 static void __sock_set_rcvbuf(struct sock *sk, int val)
 {
-	/* Ensure val * 2 fits into an int, to prevent max_t() from treating it
-	 * as a negative value.
-	 */
-	val = min_t(int, val, INT_MAX / 2);
+	int buf_size;
+
+	/* Cap val to what would be available in a maximum sized buffer: */
+	val = min(val, sock_buf_size_to_available(sk, INT_MAX));
+	buf_size = sock_available_to_buf_size(sk, val);
+
 	sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
 
-	/* We double it on the way in to account for "struct sk_buff" etc.
-	 * overhead.   Applications assume that the SO_RCVBUF setting they make
-	 * will allow that much actual data to be received on that socket.
-	 *
-	 * Applications are unaware that "struct sk_buff" and other overheads
-	 * allocate from the receive buffer during socket buffer allocation.
-	 *
-	 * And after considering the possible alternatives, returning the value
-	 * we actually used in getsockopt is the most desirable behavior.
-	 */
-	WRITE_ONCE(sk->sk_rcvbuf, max_t(int, val * 2, SOCK_MIN_RCVBUF));
+	WRITE_ONCE(sk->sk_rcvbuf, max_t(int, buf_size, SOCK_MIN_RCVBUF));
 }
 
 void sock_set_rcvbuf(struct sock *sk, int val)
@@ -906,12 +927,27 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 		goto set_sndbuf;
 
 	case SO_RCVBUF:
-		/* Don't error on this BSD doesn't and if you think
-		 * about it this is right. Otherwise apps have to
-		 * play 'guess the biggest size' games. RCVBUF/SNDBUF
-		 * are treated in BSD as hints
+		/* val is in "available" space - that is, it is a requested
+		 * amount of space to be available in the receive buffer *not*
+		 * including any overhead.
+		 *
+		 * sysctl_rmem_max is in "buffer" space - that is, it specifies
+		 * a buffer size *including* overhead.  It must be scaled into
+		 * "available" space, which is what __sock_set_rcvbuf() expects.
+		 *
+		 * Don't return an error when val exceeds scaled sysctl_rmem_max
+		 * (or, maybe more clearly: when val scaled into "buffer" space
+		 * would exceed sysctl_rmem_max).  Instead, just cap the
+		 * requested value to what sysctl_rmem_max would make available.
+		 *
+		 * Floor negative values to 0.
 		 */
-		__sock_set_rcvbuf(sk, min_t(u32, val, sysctl_rmem_max));
+		__sock_set_rcvbuf(sk,
+		                  min(max(val, 0),
+		                      sock_buf_size_to_available(sk,
+		                                                 min_t(u32,
+		                                                       sysctl_rmem_max,
+		                                                       INT_MAX))));
 		break;
 
 	case SO_RCVBUFFORCE:
@@ -920,9 +956,6 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 			break;
 		}
 
-		/* No negative values (to prevent underflow, as val will be
-		 * multiplied by 2).
-		 */
 		__sock_set_rcvbuf(sk, max(val, 0));
 		break;
 
@@ -1333,6 +1366,10 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case SO_RCVBUF:
+		/* The actual value, in "buffer" space, is supplied for
+		 * getsockopt(), even though the value supplied to setsockopt()
+		 * is in "available" space.
+		 */
 		v.val = sk->sk_rcvbuf;
 		break;
 
-- 
2.28.0

