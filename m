Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6114631735
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 00:29:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfEaW3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 18:29:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60276 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726450AbfEaW3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 18:29:16 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4VMNQi5006171
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 15:29:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=xtVdn+BzwkDr8Z7XRAl/ArbZJl/qgBo8EDjasCWUt+c=;
 b=YeATxUVpv+GMHADrDcYRCiiEeS7PYDieJ8D62K17rimc1SsI2zjJNNvvYkwczTE9wpie
 kS8H4OGDCRYsEPypHlGHlzEYQf25TH8242lTPY33jrxvMO1f0htboqH9mJ3ld1dzbk/f
 tphs2BjGU09LP2ESgVs+mj5xmkGOm+4LOqE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2suaucrfj4-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 15:29:14 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 31 May 2019 15:29:13 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 6F8BB2941A0E; Fri, 31 May 2019 15:29:11 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        Craig Gallek <kraig@google.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 1/2] bpf: udp: ipv6: Avoid running reuseport's bpf_prog from __udp6_lib_err
Date:   Fri, 31 May 2019 15:29:11 -0700
Message-ID: <20190531222911.2500496-1-kafai@fb.com>
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
 mlxlogscore=983 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905310138
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

__udp6_lib_err() may be called when handling icmpv6 message. For example,
the icmpv6 toobig(type=2).  __udp6_lib_lookup() is then called
which may call reuseport_select_sock().  reuseport_select_sock() will
call into a bpf_prog (if there is one).

reuseport_select_sock() is expecting the skb->data pointing to the
transport header (udphdr in this case).  For example, run_bpf_filter()
is pulling the transport header.

However, in the __udp6_lib_err() path, the skb->data is pointing to the
ipv6hdr instead of the udphdr.

One option is to pull and push the ipv6hdr in __udp6_lib_err().
Instead of doing this, this patch follows how the original
commit 538950a1b752 ("soreuseport: setsockopt SO_ATTACH_REUSEPORT_[CE]BPF")
was done in IPv4, which has passed a NULL skb pointer to
reuseport_select_sock().

Fixes: 538950a1b752 ("soreuseport: setsockopt SO_ATTACH_REUSEPORT_[CE]BPF")
Cc: Craig Gallek <kraig@google.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/ipv6/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 07fa579dfb96..133e6370f89c 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -515,7 +515,7 @@ int __udp6_lib_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	struct net *net = dev_net(skb->dev);
 
 	sk = __udp6_lib_lookup(net, daddr, uh->dest, saddr, uh->source,
-			       inet6_iif(skb), inet6_sdif(skb), udptable, skb);
+			       inet6_iif(skb), inet6_sdif(skb), udptable, NULL);
 	if (!sk) {
 		/* No socket for error: try tunnels before discarding */
 		sk = ERR_PTR(-ENOENT);
-- 
2.17.1

