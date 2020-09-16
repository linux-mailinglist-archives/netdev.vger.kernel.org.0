Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA11526E13D
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 18:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728553AbgIQQyl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 12:54:41 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59042 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728680AbgIQQyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 12:54:10 -0400
Received: from pps.filterd (m0042983.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08HGmtDY032619
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 09:54:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=Ff2/c16+I+e92ISm3FuaKk/HvBMPggiELUmtAn3CwIw=;
 b=ElPK/uw1VLMxDeiz0aRxnjMxFAceGVyHHjEmh2haSilTKntqtOZIJxabmhJOFkcbjx9x
 tUZqudMCyYSENKcSOhUgFR2SY6oFmQVCFR1mv4Tm4takk0rkcUoBNebz0CbjLF6a08CB
 FhyWcK7UKdMRZmCyDXrsuzwBLWNihPgr1Rs= 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-00082601.pphosted.com with ESMTP id 33m9wg96py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 09:54:09 -0700
Received: from pps.reinject (m0042983.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08HGricV020415
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 09:54:08 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33k5nt5yub-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 13:44:55 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 16 Sep 2020 13:44:54 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 61D442945DBE; Wed, 16 Sep 2020 13:44:53 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf-next] bpf: Use hlist_add_head_rcu when linking to local_storage
Date:   Wed, 16 Sep 2020 13:44:53 -0700
Message-ID: <20200916204453.2003915-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-16_13:2020-09-16,2020-09-16 signatures=0
X-FB-Internal: deliver
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-17_12:2020-09-16,2020-09-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 mlxlogscore=856 mlxscore=0 lowpriorityscore=0 adultscore=0 impostorscore=0
 suspectscore=13 phishscore=0 priorityscore=1501 malwarescore=0 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=2
 engine=8.12.0-2006250000 definitions=main-2009170127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The local_storage->list will be traversed by rcu reader in parallel.
Thus, hlist_add_head_rcu() is needed in bpf_selem_link_storage_nolock().
This patch fixes it.

This part of the code has recently been refactored in bpf-next
and this patch makes changes to the new file "bpf_local_storage.c".
Instead of using the original offending commit in the Fixes tag,
the commit that created the file "bpf_local_storage.c" is used.

A separate fix has been provided to the bpf tree.

Fixes: 450af8d0f6be ("bpf: Split bpf_local_storage to bpf_sk_storage")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 kernel/bpf/bpf_local_storage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storag=
e.c
index ffa7d11fc2bd..5d3a7af9ba9b 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -159,7 +159,7 @@ void bpf_selem_link_storage_nolock(struct bpf_local_s=
torage *local_storage,
 				   struct bpf_local_storage_elem *selem)
 {
 	RCU_INIT_POINTER(selem->local_storage, local_storage);
-	hlist_add_head(&selem->snode, &local_storage->list);
+	hlist_add_head_rcu(&selem->snode, &local_storage->list);
 }
=20
 void bpf_selem_unlink_map(struct bpf_local_storage_elem *selem)
--=20
2.24.1

