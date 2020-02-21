Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F94A1686F0
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 19:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729642AbgBUSrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 13:47:19 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64390 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729604AbgBUSrS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 13:47:18 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01LIhpSk021594
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 10:47:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=LK+pub1dFGZxqXkFkasmWT5yGcMcCcr3z3qsbw6kn5A=;
 b=SDMsrKVaQHHozKECv66vZpQsRFptMTkf8FiKstY73KOS6hocUQuA4YnzvPJi1IPa2SVx
 F1J3hvCKSWpcw2PNPLn5g65pYSqviApNlV62E31ESBiSo3WojwxbCLpDpKjLCy9m6/13
 x7qJfshYm9mVa14teWCdOxA3tNbubWwOHHM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yaj9u0vf3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 21 Feb 2020 10:47:17 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 21 Feb 2020 10:47:16 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id A93F329406D6; Fri, 21 Feb 2020 10:47:15 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 4/4] bpf: inet_diag: Dump bpf_sk_storages in inet_diag_dump()
Date:   Fri, 21 Feb 2020 10:47:15 -0800
Message-ID: <20200221184715.24186-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200221184650.21920-1-kafai@fb.com>
References: <20200221184650.21920-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-21_06:2020-02-21,2020-02-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 suspectscore=38 clxscore=1015
 mlxlogscore=999 impostorscore=0 mlxscore=0 adultscore=0 spamscore=0
 bulkscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002210142
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch will dump out the bpf_sk_storages of a sk
if the request has the INET_DIAG_REQ_SK_BPF_STORAGES nlattr.

An array of SK_DIAG_BPF_STORAGE_REQ_MAP_FD can be specified in
INET_DIAG_REQ_SK_BPF_STORAGES to select which bpf_sk_storage to dump.
If no map_fd is specified, all bpf_sk_storages of a sk will be dumped.

bpf_sk_storages can be added to the system at runtime.  It is difficult
to find a proper static value for cb->min_dump_alloc.

This patch learns the nlattr size required to dump the bpf_sk_storages
of a sk.  If it happens to be the very first nlmsg of a dump and it
cannot fit the needed bpf_sk_storages,  it will try to expand the
skb by "pskb_expand_head()".

Instead of expanding it in inet_sk_diag_fill(), it is expanded at a
sleepable context in __inet_diag_dump() so __GFP_DIRECT_RECLAIM can
be used.  In __inet_diag_dump(), it will retry as long as the
skb is empty and the cb->min_dump_alloc becomes larger than before.
cb->min_dump_alloc is bounded by KMALLOC_MAX_SIZE.

The updated cb->min_dump_alloc will also be used to allocate the skb in
the next dump.  This logic already exists in netlink_dump().

Here is the sample output of a locally modified 'ss' and it could be made
more readable by using BTF later:
[root@arch-fb-vm1 ~]# ss --bpf-map-id 14 --bpf-map-id 13 -t6an 'dst [::1]:8989'
State Recv-Q Send-Q Local Address:Port  Peer Address:PortProcess
ESTAB 0      0              [::1]:51072        [::1]:8989
	 bpf_map_id:14 value:[ 3feb ]
	 bpf_map_id:13 value:[ 3f ]
ESTAB 0      0              [::1]:51070        [::1]:8989
	 bpf_map_id:14 value:[ 3feb ]
	 bpf_map_id:13 value:[ 3f ]

[root@arch-fb-vm1 ~]# ~/devshare/github/iproute2/misc/ss --bpf-maps -t6an 'dst [::1]:8989'
State         Recv-Q         Send-Q                   Local Address:Port                    Peer Address:Port         Process
ESTAB         0              0                                [::1]:51072                          [::1]:8989
	 bpf_map_id:14 value:[ 3feb ]
	 bpf_map_id:13 value:[ 3f ]
	 bpf_map_id:12 value:[ 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000... total:65407 ]
ESTAB         0              0                                [::1]:51070                          [::1]:8989
	 bpf_map_id:14 value:[ 3feb ]
	 bpf_map_id:13 value:[ 3f ]
	 bpf_map_id:12 value:[ 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000 0000... total:65407 ]

Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 include/linux/inet_diag.h      |  4 ++
 include/linux/netlink.h        |  4 +-
 include/uapi/linux/inet_diag.h |  2 +
 net/ipv4/inet_diag.c           | 71 ++++++++++++++++++++++++++++++++++
 4 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/include/linux/inet_diag.h b/include/linux/inet_diag.h
index 1bb94cac265f..e4ba25d63913 100644
--- a/include/linux/inet_diag.h
+++ b/include/linux/inet_diag.h
@@ -38,9 +38,13 @@ struct inet_diag_handler {
 	__u16		idiag_info_size;
 };
 
+struct bpf_sk_storage_diag;
 struct inet_diag_dump_data {
 	struct nlattr *req_nlas[__INET_DIAG_REQ_MAX];
 #define inet_diag_nla_bc req_nlas[INET_DIAG_REQ_BYTECODE]
+#define inet_diag_nla_bpf_stgs req_nlas[INET_DIAG_REQ_SK_BPF_STORAGES]
+
+	struct bpf_sk_storage_diag *bpf_stg_diag;
 };
 
 struct inet_connection_sock;
diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 205fa7b1f07a..788969ccbbde 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -188,10 +188,10 @@ struct netlink_callback {
 	struct module		*module;
 	struct netlink_ext_ack	*extack;
 	u16			family;
-	u16			min_dump_alloc;
-	bool			strict_check;
 	u16			answer_flags;
+	u32			min_dump_alloc;
 	unsigned int		prev_seq, seq;
+	bool			strict_check;
 	union {
 		u8		ctx[48];
 
diff --git a/include/uapi/linux/inet_diag.h b/include/uapi/linux/inet_diag.h
index bab9a9f8da12..75dffd78363a 100644
--- a/include/uapi/linux/inet_diag.h
+++ b/include/uapi/linux/inet_diag.h
@@ -64,6 +64,7 @@ struct inet_diag_req_raw {
 enum {
 	INET_DIAG_REQ_NONE,
 	INET_DIAG_REQ_BYTECODE,
+	INET_DIAG_REQ_SK_BPF_STORAGES,
 	__INET_DIAG_REQ_MAX,
 };
 
@@ -155,6 +156,7 @@ enum {
 	INET_DIAG_CLASS_ID,	/* request as INET_DIAG_TCLASS */
 	INET_DIAG_MD5SIG,
 	INET_DIAG_ULP_INFO,
+	INET_DIAG_SK_BPF_STORAGES,
 	__INET_DIAG_MAX,
 };
 
diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 4bce8a477699..8ca4d54d7c5a 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -23,6 +23,7 @@
 #include <net/inet_hashtables.h>
 #include <net/inet_timewait_sock.h>
 #include <net/inet6_hashtables.h>
+#include <net/bpf_sk_storage.h>
 #include <net/netlink.h>
 
 #include <linux/inet.h>
@@ -156,6 +157,8 @@ int inet_diag_msg_attrs_fill(struct sock *sk, struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(inet_diag_msg_attrs_fill);
 
+#define MAX_DUMP_ALLOC_SIZE (KMALLOC_MAX_SIZE - SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
+
 int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 		      struct sk_buff *skb, struct netlink_callback *cb,
 		      const struct inet_diag_req_v2 *req,
@@ -163,12 +166,14 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 {
 	const struct tcp_congestion_ops *ca_ops;
 	const struct inet_diag_handler *handler;
+	struct inet_diag_dump_data *cb_data;
 	int ext = req->idiag_ext;
 	struct inet_diag_msg *r;
 	struct nlmsghdr  *nlh;
 	struct nlattr *attr;
 	void *info = NULL;
 
+	cb_data = cb->data;
 	handler = inet_diag_table[req->sdiag_protocol];
 	BUG_ON(!handler);
 
@@ -302,6 +307,48 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 			goto errout;
 	}
 
+	/* Keep it at the end for potential retry with a larger skb,
+	 * or else do best-effort fitting, which is only done for the
+	 * first_nlmsg.
+	 */
+	if (cb_data->bpf_stg_diag) {
+		bool first_nlmsg = ((unsigned char *)nlh == skb->data);
+		unsigned int prev_min_dump_alloc;
+		unsigned int total_nla_size = 0;
+		unsigned int msg_len;
+		int err;
+
+		msg_len = skb_tail_pointer(skb) - (unsigned char *)nlh;
+		err = bpf_sk_storage_diag_put(cb_data->bpf_stg_diag, sk, skb,
+					      INET_DIAG_SK_BPF_STORAGES,
+					      &total_nla_size);
+
+		if (!err)
+			goto out;
+
+		total_nla_size += msg_len;
+		prev_min_dump_alloc = cb->min_dump_alloc;
+		if (total_nla_size > prev_min_dump_alloc)
+			cb->min_dump_alloc = min_t(u32, total_nla_size,
+						   MAX_DUMP_ALLOC_SIZE);
+
+		if (!first_nlmsg)
+			goto errout;
+
+		if (cb->min_dump_alloc > prev_min_dump_alloc)
+			/* Retry with pskb_expand_head() with
+			 * __GFP_DIRECT_RECLAIM
+			 */
+			goto errout;
+
+		WARN_ON_ONCE(total_nla_size <= prev_min_dump_alloc);
+
+		/* Send what we have for this sk
+		 * and move on to the next sk in the following
+		 * dump()
+		 */
+	}
+
 out:
 	nlmsg_end(skb, nlh);
 	return 0;
@@ -1022,8 +1069,11 @@ static int __inet_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 			    const struct inet_diag_req_v2 *r)
 {
 	const struct inet_diag_handler *handler;
+	u32 prev_min_dump_alloc;
 	int err = 0;
 
+again:
+	prev_min_dump_alloc = cb->min_dump_alloc;
 	handler = inet_diag_lock_handler(r->sdiag_protocol);
 	if (!IS_ERR(handler))
 		handler->dump(skb, cb, r);
@@ -1031,6 +1081,12 @@ static int __inet_diag_dump(struct sk_buff *skb, struct netlink_callback *cb,
 		err = PTR_ERR(handler);
 	inet_diag_unlock_handler(handler);
 
+	if (!skb->len && cb->min_dump_alloc > prev_min_dump_alloc) {
+		err = pskb_expand_head(skb, 0, cb->min_dump_alloc, GFP_KERNEL);
+		if (!err)
+			goto again;
+	}
+
 	return err ? : skb->len;
 }
 
@@ -1068,6 +1124,18 @@ static int __inet_diag_dump_start(struct netlink_callback *cb, int hdrlen)
 		}
 	}
 
+	nla = cb_data->inet_diag_nla_bpf_stgs;
+	if (nla) {
+		struct bpf_sk_storage_diag *bpf_stg_diag;
+
+		bpf_stg_diag = bpf_sk_storage_diag_alloc(nla);
+		if (IS_ERR(bpf_stg_diag)) {
+			kfree(cb_data);
+			return PTR_ERR(bpf_stg_diag);
+		}
+		cb_data->bpf_stg_diag = bpf_stg_diag;
+	}
+
 	cb->data = cb_data;
 	return 0;
 }
@@ -1084,6 +1152,9 @@ static int inet_diag_dump_start_compat(struct netlink_callback *cb)
 
 static int inet_diag_dump_done(struct netlink_callback *cb)
 {
+	struct inet_diag_dump_data *cb_data = cb->data;
+
+	bpf_sk_storage_diag_free(cb_data->bpf_stg_diag);
 	kfree(cb->data);
 
 	return 0;
-- 
2.17.1

