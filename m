Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A80E25B771
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 01:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726936AbgIBXxq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 19:53:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57956 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726877AbgIBXxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 19:53:43 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 082Ndilg014499
        for <netdev@vger.kernel.org>; Wed, 2 Sep 2020 16:53:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=6KVYEGgVE+DggEcnHSuNeaQ8HkmYRRdai6MNZex9/Jk=;
 b=RkGQncISZHck1f4VLlMmsqAEzfXBCrVV/mbFxEulqY/dLfzId2mCBbYLGMJ5fePrg6u/
 DFbnEnchUYdeirGqgLV+tOy6Z/Kx81lKCSXSg5ZYrGKKfJ34ykZG7qwzv0wL1DW7dTau
 M2IK1YXKJrfKhKcwYXEQD4fUcoyjrQPwNYs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33879nvgu2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 16:53:43 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 2 Sep 2020 16:53:42 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 407F63704F6D; Wed,  2 Sep 2020 16:53:40 -0700 (PDT)
From:   Yonghong Song <yhs@fb.com>
To:     <bpf@vger.kernel.org>, Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Subject: [PATCH bpf 0/2] bpf: do not use bucket_lock for hashmap iterator
Date:   Wed, 2 Sep 2020 16:53:40 -0700
Message-ID: <20200902235340.2001300-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-02_17:2020-09-02,2020-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 mlxlogscore=570 spamscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 phishscore=0 mlxscore=0
 clxscore=1015 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009020222
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the bpf hashmap iterator takes a bucket_lock, a spin_lock,
before visiting each element in the bucket. This will cause a deadlock
if a map update/delete operates on an element with the same
bucket id of the visited map.

To avoid the deadlock, let us just use rcu_read_lock instead of
bucket_lock. This may result in visiting stale elements, missing some ele=
ments,
or repeating some elements, if concurrent map delete/update happens for t=
he
same map. I think using rcu_read_lock is a reasonable compromise.
For users caring stale/missing/repeating element issues, bpf map batch
access syscall interface can be used.

Note that another approach is during bpf_iter link stage, we check
whether the iter program might be able to do update/delete to the visited
map. If it is, reject the link_create. Verifier needs to record whether
an update/delete operation happens for each map for this approach.
I just feel this checking is too specialized, hence still prefer
rcu_read_lock approach.

Patch #1 has the kernel implementation and Patch #2 added a selftest
which can trigger deadlock without Patch #1.

Yonghong Song (2):
  bpf: do not use bucket_lock for hashmap iterator
  selftests/bpf: add bpf_{update,delete}_map_elem in hashmap iter
    program

 kernel/bpf/hashtab.c                              | 15 ++++-----------
 .../selftests/bpf/progs/bpf_iter_bpf_hash_map.c   | 15 +++++++++++++++
 2 files changed, 19 insertions(+), 11 deletions(-)

--=20
2.24.1

