Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BABD7270EE
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730130AbfEVUll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:41:41 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:58566 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729528AbfEVUll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:41:41 -0400
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
        by m0050093.ppops.net-00190b01. (8.16.0.27/8.16.0.27) with SMTP id x4MKb0GX027057;
        Wed, 22 May 2019 21:41:35 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : in-reply-to :
 references; s=jan2016.eng;
 bh=vIhqgUtXPWTC7lhd/ZpuhMw7uiBerL4y+nrjGcCHw6k=;
 b=VAJOQUvKSfsf1OEXm0wK0limn5PG5xUrKFFSRxGN+h7p568NlW7Su8YXD52x6R7W8Y0j
 rmzR+hW6rhg+PAVQkDWnNXfGRLmcZ0CWKSv764SSmUlcOz4+7svjXvyAah0TYg/jLNqJ
 HRqIOAAto7RNHGAyzaY71zTvfiRrJiB1CtrPTWAgCSgUKAPc7Tc2xltTJJQXJkpB19wk
 VPcEfi6VY3ZLj70xNUex1y1jNIPuCkW4wcqr98ni5HHcNI96rdLqV85+cbfk1IPgTJoZ
 F5JWde1LkoW0rmGUbjwuTDlxsh+YPsUnwf3dSH/pvo/Loo+V6QLIBurAhauoOK2aWFYy 7g== 
Received: from prod-mail-ppoint1 (prod-mail-ppoint1.akamai.com [184.51.33.18] (may be forged))
        by m0050093.ppops.net-00190b01. with ESMTP id 2sn98pgvye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 May 2019 21:41:35 +0100
Received: from pps.filterd (prod-mail-ppoint1.akamai.com [127.0.0.1])
        by prod-mail-ppoint1.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x4MKXHGr011436;
        Wed, 22 May 2019 16:41:34 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint1.akamai.com with ESMTP id 2sjdcvsk0g-1;
        Wed, 22 May 2019 16:41:33 -0400
Received: from bos-lpjec.kendall.corp.akamai.com (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id B34A032A83;
        Wed, 22 May 2019 20:40:29 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net, edumazet@google.com
Cc:     ycheng@google.com, ilubashe@akamai.com, netdev@vger.kernel.org,
        Christoph Paasch <cpaasch@apple.com>
Subject: [PATCH net-next 3/6] tcp: add support to TCP_FASTOPEN_KEY for optional backup key
Date:   Wed, 22 May 2019 16:39:35 -0400
Message-Id: <07f1a5f628860cecadc0aa46de8641925617e476.1558557001.git.jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1558557001.git.jbaron@akamai.com>
References: <cover.1558557001.git.jbaron@akamai.com>
In-Reply-To: <cover.1558557001.git.jbaron@akamai.com>
References: <cover.1558557001.git.jbaron@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905220143
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-22_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905220144
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for get/set of an optional backup key via TCP_FASTOPEN_KEY, in
addition to the current 'primary' key. The primary key is used to encrypt
and decrypt TFO cookies, while the backup is only used to decrpt TFO
cookies. The backup key is used to maximize successful TFO connections when
TFO keys are rotated.

Currently, TCP_FASTOPEN_KEY allows a single 16-byte key to be set. The
first 16 bytes are used as the primary key and the second 16 bytes are used
for the backup key. Similarly, for getsockopt(), we can receive a 32-byte
value as output if requested. If a 16-byte value is used to set the primary
key via TCP_FASTOPEN_KEY, then any previously set backup key will be
removed.

Signed-off-by: Christoph Paasch <cpaasch@apple.com>
Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 net/ipv4/tcp.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index bca51a3..27ce13e 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2790,16 +2790,24 @@ static int do_tcp_setsockopt(struct sock *sk, int level,
 		return err;
 	}
 	case TCP_FASTOPEN_KEY: {
-		__u8 key[TCP_FASTOPEN_KEY_LENGTH];
+		__u8 key[TCP_FASTOPEN_KEY_BUF_LENGTH];
+		__u8 *backup_key = NULL;
 
-		if (optlen != sizeof(key))
+		/* Allow a backup key as well to facilitate key rotation
+		 * First key is the active one.
+		 */
+		if (optlen != TCP_FASTOPEN_KEY_LENGTH &&
+		    optlen != TCP_FASTOPEN_KEY_BUF_LENGTH)
 			return -EINVAL;
 
 		if (copy_from_user(key, optval, optlen))
 			return -EFAULT;
 
-		return tcp_fastopen_reset_cipher(net, sk, key, NULL,
-						 sizeof(key));
+		if (optlen == TCP_FASTOPEN_KEY_BUF_LENGTH)
+			backup_key = key + TCP_FASTOPEN_KEY_LENGTH;
+
+		return tcp_fastopen_reset_cipher(net, sk, key, backup_key,
+						 TCP_FASTOPEN_KEY_LENGTH);
 	}
 	default:
 		/* fallthru */
@@ -3453,21 +3461,23 @@ static int do_tcp_getsockopt(struct sock *sk, int level,
 		return 0;
 
 	case TCP_FASTOPEN_KEY: {
-		__u8 key[TCP_FASTOPEN_KEY_LENGTH];
+		__u8 key[TCP_FASTOPEN_KEY_BUF_LENGTH];
 		struct tcp_fastopen_context *ctx;
+		unsigned int key_len = 0;
 
 		if (get_user(len, optlen))
 			return -EFAULT;
 
 		rcu_read_lock();
 		ctx = rcu_dereference(icsk->icsk_accept_queue.fastopenq.ctx);
-		if (ctx)
-			memcpy(key, ctx->key, sizeof(key));
-		else
-			len = 0;
+		if (ctx) {
+			key_len = tcp_fastopen_context_len(ctx) *
+					TCP_FASTOPEN_KEY_LENGTH;
+			memcpy(&key[0], &ctx->key[0], key_len);
+		}
 		rcu_read_unlock();
 
-		len = min_t(unsigned int, len, sizeof(key));
+		len = min_t(unsigned int, len, key_len);
 		if (put_user(len, optlen))
 			return -EFAULT;
 		if (copy_to_user(optval, key, len))
-- 
2.7.4

