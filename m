Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7872E258
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 18:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfE2Qff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 12:35:35 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:43262 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726140AbfE2Qfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 12:35:33 -0400
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4TGW05i031017;
        Wed, 29 May 2019 17:35:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : in-reply-to :
 references; s=jan2016.eng;
 bh=Mn+5Ib4Ft4ANoJIMBz5pg5bx3qQ8PQVv+Ij1bTPWDxA=;
 b=c96nyjqHuhPDsIvTxavGeIwi8xGrC6Jqar7mSublt8V4oY/F7+9ZdyNsq/2A8ndx0uMD
 RdKuV+XbdJBptv5X0P0Y8odsVvU8WaUtSgFoqR9jI2yYNWwlTXoyH24PiU869Kce06qX
 2gGZPyl59W+Yx5r5J8YPtVfvoW7vMR02lgwQWeZFUGT3RryiaepupKG+G5kvGh32q5wu
 hkANk5ZBmpoQsARCnRWT/KadHoATVS2CPklishTvRrZ7BVp0tBQ1DrtIREgogq1Re9kg
 bJtUeQaMJJW92WxYOAQP1aKFLWB6mp/PJ7H27hDUIciT7yvzH7Sdu60V4yfPDrlSHnnf bQ== 
Received: from prod-mail-ppoint3 (prod-mail-ppoint3.akamai.com [96.6.114.86] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2ss8uec46j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 May 2019 17:35:28 +0100
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x4TGVxUD028623;
        Wed, 29 May 2019 12:35:27 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint3.akamai.com with ESMTP id 2sq11ys532-1;
        Wed, 29 May 2019 12:35:26 -0400
Received: from bos-lpjec.kendall.corp.akamai.com (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 4B7F31FC6E;
        Wed, 29 May 2019 16:35:17 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net, edumazet@google.com, ycheng@google.com
Cc:     cpaasch@apple.com, ilubashe@akamai.com, netdev@vger.kernel.org
Subject: [PATCH net-next v2 3/6] tcp: add support to TCP_FASTOPEN_KEY for optional backup key
Date:   Wed, 29 May 2019 12:33:58 -0400
Message-Id: <128b609619cddd293eec5b619057d9e528ff9bef.1559146812.git.jbaron@akamai.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1559146812.git.jbaron@akamai.com>
References: <cover.1559146812.git.jbaron@akamai.com>
In-Reply-To: <cover.1559146812.git.jbaron@akamai.com>
References: <cover.1559146812.git.jbaron@akamai.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1905290108
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-29_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1905290108
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for get/set of an optional backup key via TCP_FASTOPEN_KEY, in
addition to the current 'primary' key. The primary key is used to encrypt
and decrypt TFO cookies, while the backup is only used to decrypt TFO
cookies. The backup key is used to maximize successful TFO connections when
TFO keys are rotated.

Currently, TCP_FASTOPEN_KEY allows a single 16-byte primary key to be set.
This patch now allows a 32-byte value to be set, where the first 16 bytes
are used as the primary key and the second 16 bytes are used for the backup
key. Similarly, for getsockopt(), we can receive a 32-byte value as output
if requested. If a 16-byte value is used to set the primary key via
TCP_FASTOPEN_KEY, then any previously set backup key will be removed.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
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

