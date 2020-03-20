Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B165C18D97F
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 21:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgCTUga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 16:36:30 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43428 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726829AbgCTUg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 16:36:29 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02KKaMX5001787
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 13:36:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Z3SY+JmABAHgg0NODEo2+2c0yyWwsRBYA2ipAg5I3iE=;
 b=dz8wz+vCNrFXEO8Vd+va7N6rUdvIhBtBdamHoHjNW6MVpP4cUzurG1EniCiHL9cvQDGs
 iH629Nq0OA0mDuYyc0CdX3GDHIeN23fGrYMZyFczWehO1cKrAa/wwKScIPA0Nf9RmSpl
 yJBBmXWBq/3PoAhnRE7SyjFWNS8LufGLfeA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yvu8yu2ps-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Mar 2020 13:36:28 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 20 Mar 2020 13:36:25 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C69302EC2E57; Fri, 20 Mar 2020 13:36:23 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/6] bpf: factor out attach_type to prog_type mapping for attach/detach
Date:   Fri, 20 Mar 2020 13:36:10 -0700
Message-ID: <20200320203615.1519013-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200320203615.1519013-1-andriin@fb.com>
References: <20200320203615.1519013-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-20_07:2020-03-20,2020-03-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 clxscore=1015 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 adultscore=0 impostorscore=0 mlxlogscore=978 suspectscore=8
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003200082
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out logic mapping expected program attach type to program type and
subsequent handling of program attach/detach. Also list out all supported
cgroup BPF program types explicitly to prevent accidental bugs once more
program types are added to a mapping. Do the same for prog_query API.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/syscall.c | 153 +++++++++++++++++++------------------------
 1 file changed, 66 insertions(+), 87 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 85567a6ea5f9..fd4181939064 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2535,36 +2535,18 @@ static int bpf_prog_attach_check_attach_type(const struct bpf_prog *prog,
 	}
 }
 
-#define BPF_PROG_ATTACH_LAST_FIELD replace_bpf_fd
-
-#define BPF_F_ATTACH_MASK \
-	(BPF_F_ALLOW_OVERRIDE | BPF_F_ALLOW_MULTI | BPF_F_REPLACE)
-
-static int bpf_prog_attach(const union bpf_attr *attr)
+static enum bpf_prog_type
+attach_type_to_prog_type(enum bpf_attach_type attach_type)
 {
-	enum bpf_prog_type ptype;
-	struct bpf_prog *prog;
-	int ret;
-
-	if (!capable(CAP_NET_ADMIN))
-		return -EPERM;
-
-	if (CHECK_ATTR(BPF_PROG_ATTACH))
-		return -EINVAL;
-
-	if (attr->attach_flags & ~BPF_F_ATTACH_MASK)
-		return -EINVAL;
-
-	switch (attr->attach_type) {
+	switch (attach_type) {
 	case BPF_CGROUP_INET_INGRESS:
 	case BPF_CGROUP_INET_EGRESS:
-		ptype = BPF_PROG_TYPE_CGROUP_SKB;
+		return BPF_PROG_TYPE_CGROUP_SKB;
 		break;
 	case BPF_CGROUP_INET_SOCK_CREATE:
 	case BPF_CGROUP_INET4_POST_BIND:
 	case BPF_CGROUP_INET6_POST_BIND:
-		ptype = BPF_PROG_TYPE_CGROUP_SOCK;
-		break;
+		return BPF_PROG_TYPE_CGROUP_SOCK;
 	case BPF_CGROUP_INET4_BIND:
 	case BPF_CGROUP_INET6_BIND:
 	case BPF_CGROUP_INET4_CONNECT:
@@ -2573,37 +2555,53 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_CGROUP_UDP6_SENDMSG:
 	case BPF_CGROUP_UDP4_RECVMSG:
 	case BPF_CGROUP_UDP6_RECVMSG:
-		ptype = BPF_PROG_TYPE_CGROUP_SOCK_ADDR;
-		break;
+		return BPF_PROG_TYPE_CGROUP_SOCK_ADDR;
 	case BPF_CGROUP_SOCK_OPS:
-		ptype = BPF_PROG_TYPE_SOCK_OPS;
-		break;
+		return BPF_PROG_TYPE_SOCK_OPS;
 	case BPF_CGROUP_DEVICE:
-		ptype = BPF_PROG_TYPE_CGROUP_DEVICE;
-		break;
+		return BPF_PROG_TYPE_CGROUP_DEVICE;
 	case BPF_SK_MSG_VERDICT:
-		ptype = BPF_PROG_TYPE_SK_MSG;
-		break;
+		return BPF_PROG_TYPE_SK_MSG;
 	case BPF_SK_SKB_STREAM_PARSER:
 	case BPF_SK_SKB_STREAM_VERDICT:
-		ptype = BPF_PROG_TYPE_SK_SKB;
-		break;
+		return BPF_PROG_TYPE_SK_SKB;
 	case BPF_LIRC_MODE2:
-		ptype = BPF_PROG_TYPE_LIRC_MODE2;
-		break;
+		return BPF_PROG_TYPE_LIRC_MODE2;
 	case BPF_FLOW_DISSECTOR:
-		ptype = BPF_PROG_TYPE_FLOW_DISSECTOR;
-		break;
+		return BPF_PROG_TYPE_FLOW_DISSECTOR;
 	case BPF_CGROUP_SYSCTL:
-		ptype = BPF_PROG_TYPE_CGROUP_SYSCTL;
-		break;
+		return BPF_PROG_TYPE_CGROUP_SYSCTL;
 	case BPF_CGROUP_GETSOCKOPT:
 	case BPF_CGROUP_SETSOCKOPT:
-		ptype = BPF_PROG_TYPE_CGROUP_SOCKOPT;
-		break;
+		return BPF_PROG_TYPE_CGROUP_SOCKOPT;
 	default:
-		return -EINVAL;
+		return BPF_PROG_TYPE_UNSPEC;
 	}
+}
+
+#define BPF_PROG_ATTACH_LAST_FIELD replace_bpf_fd
+
+#define BPF_F_ATTACH_MASK \
+	(BPF_F_ALLOW_OVERRIDE | BPF_F_ALLOW_MULTI | BPF_F_REPLACE)
+
+static int bpf_prog_attach(const union bpf_attr *attr)
+{
+	enum bpf_prog_type ptype;
+	struct bpf_prog *prog;
+	int ret;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	if (CHECK_ATTR(BPF_PROG_ATTACH))
+		return -EINVAL;
+
+	if (attr->attach_flags & ~BPF_F_ATTACH_MASK)
+		return -EINVAL;
+
+	ptype = attach_type_to_prog_type(attr->attach_type);
+	if (ptype == BPF_PROG_TYPE_UNSPEC)
+		return -EINVAL;
 
 	prog = bpf_prog_get_type(attr->attach_bpf_fd, ptype);
 	if (IS_ERR(prog))
@@ -2625,8 +2623,17 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
 		ret = skb_flow_dissector_bpf_prog_attach(attr, prog);
 		break;
-	default:
+	case BPF_PROG_TYPE_CGROUP_DEVICE:
+	case BPF_PROG_TYPE_CGROUP_SKB:
+	case BPF_PROG_TYPE_CGROUP_SOCK:
+	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
+	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
+	case BPF_PROG_TYPE_CGROUP_SYSCTL:
+	case BPF_PROG_TYPE_SOCK_OPS:
 		ret = cgroup_bpf_prog_attach(attr, ptype, prog);
+		break;
+	default:
+		ret = -EINVAL;
 	}
 
 	if (ret)
@@ -2646,53 +2653,27 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 	if (CHECK_ATTR(BPF_PROG_DETACH))
 		return -EINVAL;
 
-	switch (attr->attach_type) {
-	case BPF_CGROUP_INET_INGRESS:
-	case BPF_CGROUP_INET_EGRESS:
-		ptype = BPF_PROG_TYPE_CGROUP_SKB;
-		break;
-	case BPF_CGROUP_INET_SOCK_CREATE:
-	case BPF_CGROUP_INET4_POST_BIND:
-	case BPF_CGROUP_INET6_POST_BIND:
-		ptype = BPF_PROG_TYPE_CGROUP_SOCK;
-		break;
-	case BPF_CGROUP_INET4_BIND:
-	case BPF_CGROUP_INET6_BIND:
-	case BPF_CGROUP_INET4_CONNECT:
-	case BPF_CGROUP_INET6_CONNECT:
-	case BPF_CGROUP_UDP4_SENDMSG:
-	case BPF_CGROUP_UDP6_SENDMSG:
-	case BPF_CGROUP_UDP4_RECVMSG:
-	case BPF_CGROUP_UDP6_RECVMSG:
-		ptype = BPF_PROG_TYPE_CGROUP_SOCK_ADDR;
-		break;
-	case BPF_CGROUP_SOCK_OPS:
-		ptype = BPF_PROG_TYPE_SOCK_OPS;
-		break;
-	case BPF_CGROUP_DEVICE:
-		ptype = BPF_PROG_TYPE_CGROUP_DEVICE;
-		break;
-	case BPF_SK_MSG_VERDICT:
-		return sock_map_get_from_fd(attr, NULL);
-	case BPF_SK_SKB_STREAM_PARSER:
-	case BPF_SK_SKB_STREAM_VERDICT:
+	ptype = attach_type_to_prog_type(attr->attach_type);
+
+	switch (ptype) {
+	case BPF_PROG_TYPE_SK_MSG:
+	case BPF_PROG_TYPE_SK_SKB:
 		return sock_map_get_from_fd(attr, NULL);
-	case BPF_LIRC_MODE2:
+	case BPF_PROG_TYPE_LIRC_MODE2:
 		return lirc_prog_detach(attr);
-	case BPF_FLOW_DISSECTOR:
+	case BPF_PROG_TYPE_FLOW_DISSECTOR:
 		return skb_flow_dissector_bpf_prog_detach(attr);
-	case BPF_CGROUP_SYSCTL:
-		ptype = BPF_PROG_TYPE_CGROUP_SYSCTL;
-		break;
-	case BPF_CGROUP_GETSOCKOPT:
-	case BPF_CGROUP_SETSOCKOPT:
-		ptype = BPF_PROG_TYPE_CGROUP_SOCKOPT;
-		break;
+	case BPF_PROG_TYPE_CGROUP_DEVICE:
+	case BPF_PROG_TYPE_CGROUP_SKB:
+	case BPF_PROG_TYPE_CGROUP_SOCK:
+	case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
+	case BPF_PROG_TYPE_CGROUP_SOCKOPT:
+	case BPF_PROG_TYPE_CGROUP_SYSCTL:
+	case BPF_PROG_TYPE_SOCK_OPS:
+		return cgroup_bpf_prog_detach(attr, ptype);
 	default:
 		return -EINVAL;
 	}
-
-	return cgroup_bpf_prog_detach(attr, ptype);
 }
 
 #define BPF_PROG_QUERY_LAST_FIELD query.prog_cnt
@@ -2726,7 +2707,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_CGROUP_SYSCTL:
 	case BPF_CGROUP_GETSOCKOPT:
 	case BPF_CGROUP_SETSOCKOPT:
-		break;
+		return cgroup_bpf_prog_query(attr, uattr);
 	case BPF_LIRC_MODE2:
 		return lirc_prog_query(attr, uattr);
 	case BPF_FLOW_DISSECTOR:
@@ -2734,8 +2715,6 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	default:
 		return -EINVAL;
 	}
-
-	return cgroup_bpf_prog_query(attr, uattr);
 }
 
 #define BPF_PROG_TEST_RUN_LAST_FIELD test.ctx_out
-- 
2.17.1

