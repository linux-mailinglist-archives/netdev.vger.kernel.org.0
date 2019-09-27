Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7A8EC0E38
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 01:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfI0XAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 19:00:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5880 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725815AbfI0XAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 19:00:36 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8RMwcZW009900
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 16:00:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=VKMKIZp6czVphkRfDcXmgg7ZIf5Rm+i92JhZbpyCX+I=;
 b=hFniaq+AymvOvhjW1lKTBYn2Kf2rIvNkshIJ3ZcTakoB+4ks8REitOlfg4U1KOeJ2ZoV
 wUic4JGvN0VUls68TNbtWxohD/QNWD65uFspZqZKKkTVCApfgCOW4l2PKtpUb/rYyuzF
 cnAEEyNBYWJYdN+/m+bfyjxeUra3wBkwz3Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2v9tdc0cfj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 16:00:34 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 27 Sep 2019 16:00:33 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id A731C2943B68; Fri, 27 Sep 2019 16:00:31 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <netdev@vger.kernel.org>
CC:     David Miller <davem@davemloft.net>, <kernel-team@fb.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH net] net: Unpublish sk from sk_reuseport_cb before call_rcu
Date:   Fri, 27 Sep 2019 16:00:31 -0700
Message-ID: <20190927230031.3859970-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-09-27_09:2019-09-25,2019-09-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=3
 spamscore=0 mlxscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1015
 phishscore=0 mlxlogscore=920 impostorscore=0 adultscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1909270198
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "reuse->sock[]" array is shared by multiple sockets.  The going away
sk must unpublish itself from "reuse->sock[]" before making call_rcu()
call.  However, this unpublish-action is currently done after a grace
period and it may cause use-after-free.

The fix is to move reuseport_detach_sock() to sk_destruct().
Due to the above reason, any socket with sk_reuseport_cb has
to go through the rcu grace period before freeing it.

It is a rather old bug (~3 yrs).  The Fixes tag is not necessary
the right commit but it is the one that introduced the SOCK_RCU_FREE
logic and this fix is depending on it.

Fixes: a4298e4522d6 ("net: add SOCK_RCU_FREE socket flag")
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/core/sock.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 07863edbe6fc..e23ec80a67bf 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1700,8 +1700,6 @@ static void __sk_destruct(struct rcu_head *head)
 		sk_filter_uncharge(sk, filter);
 		RCU_INIT_POINTER(sk->sk_filter, NULL);
 	}
-	if (rcu_access_pointer(sk->sk_reuseport_cb))
-		reuseport_detach_sock(sk);
 
 	sock_disable_timestamp(sk, SK_FLAGS_TIMESTAMP);
 
@@ -1728,7 +1726,14 @@ static void __sk_destruct(struct rcu_head *head)
 
 void sk_destruct(struct sock *sk)
 {
-	if (sock_flag(sk, SOCK_RCU_FREE))
+	bool use_call_rcu = sock_flag(sk, SOCK_RCU_FREE);
+
+	if (rcu_access_pointer(sk->sk_reuseport_cb)) {
+		reuseport_detach_sock(sk);
+		use_call_rcu = true;
+	}
+
+	if (use_call_rcu)
 		call_rcu(&sk->sk_rcu, __sk_destruct);
 	else
 		__sk_destruct(&sk->sk_rcu);
-- 
2.17.1

