Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9790B31737
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 00:29:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfEaW3T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 18:29:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51440 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726807AbfEaW3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 18:29:18 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4VMOSox021941
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 15:29:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=UeYP0V9VYfVdhnHUlBAh6ZYekB7STWuJ6qgH5+rL3+0=;
 b=bN9i/OSLxCkdrgEYnPXOmurWS5tznlqrChpyHRRZcPKBzyQgYH1jfzE/VkX5AvCrzKSk
 9/MNqXWacGOQ2zB3pY10FGfIYW9IWU9cxL9h4Fy5OZPSB81q5zAeWGQuUpclUe5Y2DtP
 BqgW7gV1XPvBnPs0pSgZBtD3j7Qlsqebghs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2su6aa9gad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 15:29:17 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 31 May 2019 15:29:16 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 9E1E72941A0E; Fri, 31 May 2019 15:29:13 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        Tom Herbert <tom@herbertland.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 2/2] bpf: udp: Avoid calling reuseport's bpf_prog from udp_gro
Date:   Fri, 31 May 2019 15:29:13 -0700
Message-ID: <20190531222913.2500781-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190531222910.2499861-1-kafai@fb.com>
References: <20190531222910.2499861-1-kafai@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-31_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=778 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905310138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the commit a6024562ffd7 ("udp: Add GRO functions to UDP socket")
added udp[46]_lib_lookup_skb to the udp_gro code path, it broke
the reuseport_select_sock() assumption that skb->data is pointing
to the transport header.

This patch follows an earlier __udp6_lib_err() fix by
passing a NULL skb to avoid calling the reuseport's bpf_prog.

Fixes: a6024562ffd7 ("udp: Add GRO functions to UDP socket")
Cc: Tom Herbert <tom@herbertland.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv4/udp.c | 6 +++++-
 net/ipv6/udp.c | 2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 8fb250ed53d4..85db0e3d7f3f 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -503,7 +503,11 @@ static inline struct sock *__udp4_lib_lookup_skb(struct sk_buff *skb,
 struct sock *udp4_lib_lookup_skb(struct sk_buff *skb,
 				 __be16 sport, __be16 dport)
 {
-	return __udp4_lib_lookup_skb(skb, sport, dport, &udp_table);
+	const struct iphdr *iph = ip_hdr(skb);
+
+	return __udp4_lib_lookup(dev_net(skb->dev), iph->saddr, sport,
+				 iph->daddr, dport, inet_iif(skb),
+				 inet_sdif(skb), &udp_table, NULL);
 }
 EXPORT_SYMBOL_GPL(udp4_lib_lookup_skb);
 
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 133e6370f89c..4e52c37bb836 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -243,7 +243,7 @@ struct sock *udp6_lib_lookup_skb(struct sk_buff *skb,
 
 	return __udp6_lib_lookup(dev_net(skb->dev), &iph->saddr, sport,
 				 &iph->daddr, dport, inet6_iif(skb),
-				 inet6_sdif(skb), &udp_table, skb);
+				 inet6_sdif(skb), &udp_table, NULL);
 }
 EXPORT_SYMBOL_GPL(udp6_lib_lookup_skb);
 
-- 
2.17.1

