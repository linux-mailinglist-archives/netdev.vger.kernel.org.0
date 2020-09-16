Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2857226E220
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 19:19:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgIQRTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 13:19:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5476 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726477AbgIQRTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 13:19:07 -0400
Received: from pps.filterd (m0042983.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HHItCZ015818
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:18:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=OWYSlkIJXevIyxTLYTwCwcQtfwAY4Xrjlyq2L3EmK8k=;
 b=SOc2UMtvQiJ8ZVB2+l9D/vfs5omFMaeniF8p328KKaNSh3lKN9fLK9zn1VOofxst6vzY
 R67Wd377x0UngOLKuAJUudG8SzPbDcMuyWcBk6/gAXZrY7LQl4EV0K1xHkmehDfrpfMy
 2ckSo7UBuILBlphOqYB4l4Smvzqb4g0f0AI= 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-00082601.pphosted.com with ESMTP id 33m9wg9e4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:18:57 -0700
Received: from pps.reinject (m0042983.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08HHHZce011472
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 10:17:57 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 33k5n7dtje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 13:09:28 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Sep 2020 13:09:26 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id BFE6C2945ACA; Wed, 16 Sep 2020 13:09:25 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf] bpf: Use hlist_add_head_rcu when linking to sk_storage
Date:   Wed, 16 Sep 2020 13:09:25 -0700
Message-ID: <20200916200925.1803161-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-16_12:2020-09-16,2020-09-16 signatures=0
X-FB-Internal: deliver
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_12:2020-09-16,2020-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 mlxlogscore=732 mlxscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 suspectscore=13 phishscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=2
 engine=8.12.0-2006250000 definitions=main-2009170129
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sk_storage->list will be traversed by rcu reader in parallel.
Thus, hlist_add_head_rcu() is needed in __selem_link_sk().  This
patch fixes it.

This part of the code has recently been refactored in bpf-next.
A separate fix will be provided for the bpf-next tree.

Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 net/core/bpf_sk_storage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index b988f48153a4..d4d2a56e9d4a 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -219,7 +219,7 @@ static void __selem_link_sk(struct bpf_sk_storage *sk=
_storage,
 			    struct bpf_sk_storage_elem *selem)
 {
 	RCU_INIT_POINTER(selem->sk_storage, sk_storage);
-	hlist_add_head(&selem->snode, &sk_storage->list);
+	hlist_add_head_rcu(&selem->snode, &sk_storage->list);
 }
=20
 static void selem_unlink_map(struct bpf_sk_storage_elem *selem)
--=20
2.24.1

