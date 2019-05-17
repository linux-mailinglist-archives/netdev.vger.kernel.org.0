Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD5221F8B
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 23:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbfEQVVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 17:21:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57182 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728819AbfEQVVX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 17:21:23 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4HLLLK7032106
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 14:21:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=OXgeQjHWxjNADiBxwwCMTSG4oGavHM4IWZbmPSc/t3o=;
 b=gxGQ3OF4yxb7Cvu1VZOjaqMcEkeDlDr3/flnS5WhjnpPCBEV3mZucASM4LqAcuj/BEA5
 6Wwd+LxJq1AHZ7xrt+W7UCasWiP3aqWqWySYUR7t900w/xnFpg126hAmSu9Au/kL9mgD
 7dvkP/CH84O+nKJI9Sub/NwZcq6BegqgHJM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0b-00082601.pphosted.com with ESMTP id 2sht77a59e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 14:21:22 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 17 May 2019 14:21:19 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id AD41F2941EC2; Fri, 17 May 2019 14:21:17 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Joe Stringer <joe@isovalent.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf] bpf: Check sk_fullsock() before returning from bpf_sk_lookup()
Date:   Fri, 17 May 2019 14:21:17 -0700
Message-ID: <20190517212117.2792415-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-17_14:,,
 signatures=0
X-Proofpoint-Spam-Reason: safe
X-FB-Internal: Safe
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BPF_FUNC_sk_lookup_xxx helpers return RET_PTR_TO_SOCKET_OR_NULL.
Meaning a fullsock ptr and its fullsock's fields in bpf_sock can be
accessed, e.g. type, protocol, mark and priority.
Some new helper, like bpf_sk_storage_get(), also expects
ARG_PTR_TO_SOCKET is a fullsock.

bpf_sk_lookup() currently calls sk_to_full_sk() before returning.
However, the ptr returned from sk_to_full_sk() is not guaranteed
to be a fullsock.  For example, it cannot get a fullsock if sk
is in TCP_TIME_WAIT.

This patch checks for sk_fullsock() before returning. If it is not
a fullsock, sock_gen_put() is called if needed and then returns NULL.

Fixes: 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
Cc: Joe Stringer <joe@isovalent.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/core/filter.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 55bfc941d17a..85def5a20aaf 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5337,8 +5337,14 @@ __bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 	struct sock *sk = __bpf_skc_lookup(skb, tuple, len, caller_net,
 					   ifindex, proto, netns_id, flags);
 
-	if (sk)
+	if (sk) {
 		sk = sk_to_full_sk(sk);
+		if (!sk_fullsock(sk)) {
+			if (!sock_flag(sk, SOCK_RCU_FREE))
+				sock_gen_put(sk);
+			return NULL;
+		}
+	}
 
 	return sk;
 }
@@ -5369,8 +5375,14 @@ bpf_sk_lookup(struct sk_buff *skb, struct bpf_sock_tuple *tuple, u32 len,
 	struct sock *sk = bpf_skc_lookup(skb, tuple, len, proto, netns_id,
 					 flags);
 
-	if (sk)
+	if (sk) {
 		sk = sk_to_full_sk(sk);
+		if (!sk_fullsock(sk)) {
+			if (!sock_flag(sk, SOCK_RCU_FREE))
+				sock_gen_put(sk);
+			return NULL;
+		}
+	}
 
 	return sk;
 }
-- 
2.17.1

