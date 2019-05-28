Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C53882D2A2
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 02:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727850AbfE1X77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 19:59:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44672 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727846AbfE1X76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 19:59:58 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4SNqiXO029305
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 16:59:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Z8QUMoZBJDcZivsDChRc/dcLxihSDVp0aN33J2yWAso=;
 b=dP6G2Pt16LDHbHB/5j3jhrfvtfY8WuRPUvTA8yMbt52dMJv9fiUSoQGnnbK4L3jO4pjP
 kNtzKATyRBFLxAGADX5pNYlq6XqoQXkUoxs+15Gq7XYyHgGQxl5XGFvfgtFM55ENG7fe
 M344cd0NP0BqHbPF4p1+GyfnVIv2fUjeEkw= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2ss6cst1rh-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 May 2019 16:59:57 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 28 May 2019 16:59:55 -0700
Received: by devbig009.ftw2.facebook.com (Postfix, from userid 10340)
        id D54505AE2482; Tue, 28 May 2019 16:59:52 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   brakmo <brakmo@fb.com>
Smtp-Origin-Hostname: devbig009.ftw2.facebook.com
To:     netdev <netdev@vger.kernel.org>
CC:     Martin Lau <kafai@fb.com>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 4/6] bpf: Update BPF_CGROUP_RUN_PROG_INET_EGRESS calls
Date:   Tue, 28 May 2019 16:59:38 -0700
Message-ID: <20190528235940.1452963-5-brakmo@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190528235940.1452963-1-brakmo@fb.com>
References: <20190528235940.1452963-1-brakmo@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-28_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=758 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905280151
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update BPF_CGROUP_RUN_PROG_INET_EGRESS() callers to support returning
congestion notifications from the BPF programs.

Signed-off-by: Lawrence Brakmo <brakmo@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 net/ipv4/ip_output.c  | 34 +++++++++++++++++++++++-----------
 net/ipv6/ip6_output.c | 26 +++++++++++++++++---------
 2 files changed, 40 insertions(+), 20 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index bfd0ca554977..1217a53381c2 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -287,16 +287,9 @@ static int ip_finish_output_gso(struct net *net, struct sock *sk,
 	return ret;
 }
 
-static int ip_finish_output(struct net *net, struct sock *sk, struct sk_buff *skb)
+static int __ip_finish_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	unsigned int mtu;
-	int ret;
-
-	ret = BPF_CGROUP_RUN_PROG_INET_EGRESS(sk, skb);
-	if (ret) {
-		kfree_skb(skb);
-		return ret;
-	}
 
 #if defined(CONFIG_NETFILTER) && defined(CONFIG_XFRM)
 	/* Policy lookup after SNAT yielded a new policy */
@@ -315,18 +308,37 @@ static int ip_finish_output(struct net *net, struct sock *sk, struct sk_buff *sk
 	return ip_finish_output2(net, sk, skb);
 }
 
+static int ip_finish_output(struct net *net, struct sock *sk, struct sk_buff *skb)
+{
+	int ret;
+
+	ret = BPF_CGROUP_RUN_PROG_INET_EGRESS(sk, skb);
+	switch (ret) {
+	case NET_XMIT_SUCCESS:
+		return __ip_finish_output(net, sk, skb);
+	case NET_XMIT_CN:
+		return __ip_finish_output(net, sk, skb) ? : ret;
+	default:
+		kfree_skb(skb);
+		return ret;
+	}
+}
+
 static int ip_mc_finish_output(struct net *net, struct sock *sk,
 			       struct sk_buff *skb)
 {
 	int ret;
 
 	ret = BPF_CGROUP_RUN_PROG_INET_EGRESS(sk, skb);
-	if (ret) {
+	switch (ret) {
+	case NET_XMIT_SUCCESS:
+		return dev_loopback_xmit(net, sk, skb);
+	case NET_XMIT_CN:
+		return dev_loopback_xmit(net, sk, skb) ? : ret;
+	default:
 		kfree_skb(skb);
 		return ret;
 	}
-
-	return dev_loopback_xmit(net, sk, skb);
 }
 
 int ip_mc_output(struct net *net, struct sock *sk, struct sk_buff *skb)
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index adef2236abe2..a75bc21d8c88 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -128,16 +128,8 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 	return -EINVAL;
 }
 
-static int ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff *skb)
+static int __ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	int ret;
-
-	ret = BPF_CGROUP_RUN_PROG_INET_EGRESS(sk, skb);
-	if (ret) {
-		kfree_skb(skb);
-		return ret;
-	}
-
 #if defined(CONFIG_NETFILTER) && defined(CONFIG_XFRM)
 	/* Policy lookup after SNAT yielded a new policy */
 	if (skb_dst(skb)->xfrm) {
@@ -154,6 +146,22 @@ static int ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
 		return ip6_finish_output2(net, sk, skb);
 }
 
+static int ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff *skb)
+{
+	int ret;
+
+	ret = BPF_CGROUP_RUN_PROG_INET_EGRESS(sk, skb);
+	switch (ret) {
+	case NET_XMIT_SUCCESS:
+		return __ip6_finish_output(net, sk, skb);
+	case NET_XMIT_CN:
+		return __ip6_finish_output(net, sk, skb) ? : ret;
+	default:
+		kfree_skb(skb);
+		return ret;
+	}
+}
+
 int ip6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct net_device *dev = skb_dst(skb)->dev;
-- 
2.17.1

