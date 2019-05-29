Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 878062E254
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 18:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbfE2Qf2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 12:35:28 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:43246 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726140AbfE2Qf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 12:35:28 -0400
Received: from pps.filterd (m0122333.ppops.net [127.0.0.1])
        by mx0a-00190b01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4TGW05g031017;
        Wed, 29 May 2019 17:35:20 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : in-reply-to :
 references; s=jan2016.eng;
 bh=ng+jJ2oz7PloVRWizUB9w6BcpGy0TOZuqmNlP2JOQGE=;
 b=d9LWAu7zXX3hLd0xO/TLiktyVs8JlHRThPs8kKI8vQ2kk0J1K6faH6iSjxN+udVcFjGJ
 AifnWCIX0OoE/MkOFgGagvRjSOFXRRP41bdSKMTZ5PKWXbFXwXz0Z5zMqPyepSKK+rKT
 aE7bthOPW3RjTrF/qp+8Neh2s82UWiAuerPhcPNMaNuAvmEPCeeSLkB3rkVJHDOMpkNT
 fK+p+MzXJhzEA12HZVp8HRys1fN5wZq6pW3x3pHgK7ob4A2GVm5EeaSzFYDgS6e2O50z
 n9yu6AsjkRjDNp/ZlMdfWnZYFRUIA6FFc3OWagqkg684zsz6pGH5SQ4W20h32vu+tDAj vw== 
Received: from prod-mail-ppoint4 (prod-mail-ppoint4.akamai.com [96.6.114.87] (may be forged))
        by mx0a-00190b01.pphosted.com with ESMTP id 2ss8uec465-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 May 2019 17:35:20 +0100
Received: from pps.filterd (prod-mail-ppoint4.akamai.com [127.0.0.1])
        by prod-mail-ppoint4.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x4TGW0WT009212;
        Wed, 29 May 2019 12:35:19 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint4.akamai.com with ESMTP id 2sq11vu8f9-1;
        Wed, 29 May 2019 12:35:18 -0400
Received: from bos-lpjec.kendall.corp.akamai.com (bos-lpjec.kendall.corp.akamai.com [172.29.170.83])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id EB6281FC6C;
        Wed, 29 May 2019 16:35:17 +0000 (GMT)
From:   Jason Baron <jbaron@akamai.com>
To:     davem@davemloft.net, edumazet@google.com, ycheng@google.com
Cc:     cpaasch@apple.com, ilubashe@akamai.com, netdev@vger.kernel.org
Subject: [PATCH net-next v2 4/6] tcp: add support for optional TFO backup key to net.ipv4.tcp_fastopen_key
Date:   Wed, 29 May 2019 12:33:59 -0400
Message-Id: <211626cb7946c0cb5b3a0314ed74894f77112fc5.1559146812.git.jbaron@akamai.com>
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

Add the ability to add a backup TFO key as:

# echo "x-x-x-x,x-x-x-x" > /proc/sys/net/ipv4/tcp_fastopen_key

The key before the comma acks as the primary TFO key and the key after the
comma is the backup TFO key. This change is intended to be backwards
compatible since if only one key is set, userspace will simply read back
that single key as follows:

# echo "x-x-x-x" > /proc/sys/net/ipv4/tcp_fastopen_key
# cat /proc/sys/net/ipv4/tcp_fastopen_key
x-x-x-x

Signed-off-by: Jason Baron <jbaron@akamai.com>
Signed-off-by: Christoph Paasch <cpaasch@apple.com>
Acked-by: Yuchung Cheng <ycheng@google.com>
---
 net/ipv4/sysctl_net_ipv4.c | 95 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 71 insertions(+), 24 deletions(-)

diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 72dc8ca..90f09e4 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -277,55 +277,97 @@ static int proc_allowed_congestion_control(struct ctl_table *ctl,
 	return ret;
 }
 
+static int sscanf_key(char *buf, __le32 *key)
+{
+	u32 user_key[4];
+	int i, ret = 0;
+
+	if (sscanf(buf, "%x-%x-%x-%x", user_key, user_key + 1,
+		   user_key + 2, user_key + 3) != 4) {
+		ret = -EINVAL;
+	} else {
+		for (i = 0; i < ARRAY_SIZE(user_key); i++)
+			key[i] = cpu_to_le32(user_key[i]);
+	}
+	pr_debug("proc TFO key set 0x%x-%x-%x-%x <- 0x%s: %u\n",
+		 user_key[0], user_key[1], user_key[2], user_key[3], buf, ret);
+
+	return ret;
+}
+
 static int proc_tcp_fastopen_key(struct ctl_table *table, int write,
 				 void __user *buffer, size_t *lenp,
 				 loff_t *ppos)
 {
 	struct net *net = container_of(table->data, struct net,
 	    ipv4.sysctl_tcp_fastopen);
-	struct ctl_table tbl = { .maxlen = (TCP_FASTOPEN_KEY_LENGTH * 2 + 10) };
-	struct tcp_fastopen_context *ctxt;
-	u32  user_key[4]; /* 16 bytes, matching TCP_FASTOPEN_KEY_LENGTH */
-	__le32 key[4];
-	int ret, i;
+	/* maxlen to print the list of keys in hex (*2), with dashes
+	 * separating doublewords and a comma in between keys.
+	 */
+	struct ctl_table tbl = { .maxlen = ((TCP_FASTOPEN_KEY_LENGTH *
+					    2 * TCP_FASTOPEN_KEY_MAX) +
+					    (TCP_FASTOPEN_KEY_MAX * 5)) };
+	struct tcp_fastopen_context *ctx;
+	u32 user_key[TCP_FASTOPEN_KEY_MAX * 4];
+	__le32 key[TCP_FASTOPEN_KEY_MAX * 4];
+	char *backup_data;
+	int ret, i = 0, off = 0, n_keys = 0;
 
 	tbl.data = kmalloc(tbl.maxlen, GFP_KERNEL);
 	if (!tbl.data)
 		return -ENOMEM;
 
 	rcu_read_lock();
-	ctxt = rcu_dereference(net->ipv4.tcp_fastopen_ctx);
-	if (ctxt)
-		memcpy(key, ctxt->key, TCP_FASTOPEN_KEY_LENGTH);
-	else
-		memset(key, 0, sizeof(key));
+	ctx = rcu_dereference(net->ipv4.tcp_fastopen_ctx);
+	if (ctx) {
+		n_keys = tcp_fastopen_context_len(ctx);
+		memcpy(&key[0], &ctx->key[0], TCP_FASTOPEN_KEY_LENGTH * n_keys);
+	}
 	rcu_read_unlock();
 
-	for (i = 0; i < ARRAY_SIZE(key); i++)
+	if (!n_keys) {
+		memset(&key[0], 0, TCP_FASTOPEN_KEY_LENGTH);
+		n_keys = 1;
+	}
+
+	for (i = 0; i < n_keys * 4; i++)
 		user_key[i] = le32_to_cpu(key[i]);
 
-	snprintf(tbl.data, tbl.maxlen, "%08x-%08x-%08x-%08x",
-		user_key[0], user_key[1], user_key[2], user_key[3]);
+	for (i = 0; i < n_keys; i++) {
+		off += snprintf(tbl.data + off, tbl.maxlen - off,
+				"%08x-%08x-%08x-%08x",
+				user_key[i * 4],
+				user_key[i * 4 + 1],
+				user_key[i * 4 + 2],
+				user_key[i * 4 + 3]);
+		if (i + 1 < n_keys)
+			off += snprintf(tbl.data + off, tbl.maxlen - off, ",");
+	}
+
 	ret = proc_dostring(&tbl, write, buffer, lenp, ppos);
 
 	if (write && ret == 0) {
-		if (sscanf(tbl.data, "%x-%x-%x-%x", user_key, user_key + 1,
-			   user_key + 2, user_key + 3) != 4) {
+		backup_data = strchr(tbl.data, ',');
+		if (backup_data) {
+			*backup_data = '\0';
+			backup_data++;
+		}
+		if (sscanf_key(tbl.data, key)) {
 			ret = -EINVAL;
 			goto bad_key;
 		}
-
-		for (i = 0; i < ARRAY_SIZE(user_key); i++)
-			key[i] = cpu_to_le32(user_key[i]);
-
-		tcp_fastopen_reset_cipher(net, NULL, key, NULL,
+		if (backup_data) {
+			if (sscanf_key(backup_data, key + 4)) {
+				ret = -EINVAL;
+				goto bad_key;
+			}
+		}
+		tcp_fastopen_reset_cipher(net, NULL, key,
+					  backup_data ? key + 4 : NULL,
 					  TCP_FASTOPEN_KEY_LENGTH);
 	}
 
 bad_key:
-	pr_debug("proc FO key set 0x%x-%x-%x-%x <- 0x%s: %u\n",
-		user_key[0], user_key[1], user_key[2], user_key[3],
-	       (char *)tbl.data, ret);
 	kfree(tbl.data);
 	return ret;
 }
@@ -933,7 +975,12 @@ static struct ctl_table ipv4_net_table[] = {
 		.procname	= "tcp_fastopen_key",
 		.mode		= 0600,
 		.data		= &init_net.ipv4.sysctl_tcp_fastopen,
-		.maxlen		= ((TCP_FASTOPEN_KEY_LENGTH * 2) + 10),
+		/* maxlen to print the list of keys in hex (*2), with dashes
+		 * separating doublewords and a comma in between keys.
+		 */
+		.maxlen		= ((TCP_FASTOPEN_KEY_LENGTH *
+				   2 * TCP_FASTOPEN_KEY_MAX) +
+				   (TCP_FASTOPEN_KEY_MAX * 5)),
 		.proc_handler	= proc_tcp_fastopen_key,
 	},
 	{
-- 
2.7.4

