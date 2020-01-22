Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8F73145F2C
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 00:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbgAVXgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 18:36:55 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6324 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725911AbgAVXgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 18:36:55 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00MNapUa016398
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 15:36:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=XT5IkrVRupAHo/aUuqRVvnQ86J6I/Jzxxaw8c1a0b3Q=;
 b=HhXJYHMoItWCfPitqflAHfwtLvOdOWJeQi1FvTfyzUafigSTr63+57NYvelkaHy4bobt
 yUvFez5rzzvmC3n837nRvoaJ4GSmKqxJw4vs7MRznnGlG/8TXZPw+iK1p9iCfMqDbS17
 GHhsxdJEU0pZBn2liYHzw/gra1vDkXA85kQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xpt0aswnq-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 15:36:54 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 22 Jan 2020 15:36:45 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id C8FB02944F6C; Wed, 22 Jan 2020 15:36:39 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Martin KaFai Lau <kafai@fb.com>
Smtp-Origin-Hostname: devbig005.ftw2.facebook.com
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 0/3] bpf: tcp: Add bpf_cubic example
Date:   Wed, 22 Jan 2020 15:36:39 -0800
Message-ID: <20200122233639.903041-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-22_08:2020-01-22,2020-01-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=855 clxscore=1015 suspectscore=1
 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-2001220196
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set adds bpf_cubic.c example.  It was separated from the
earlier BPF STRUCT_OPS series.  Some highlights since the
last post:

1. It is based on EricD recent fixes to the kernel tcp_cubic. [1]
2. The bpf jiffies reading helper is inlined by the verifier.
   Different from the earlier version, it only reads jiffies alone
   and does not do usecs/jiffies conversion.
3. The bpf .kconfig map is used to read CONFIG_HZ.

[1]: https://patchwork.ozlabs.org/cover/1215066/

v3:
- Remove __weak from CONFIG_HZ in patch 3. (Andrii)

v2:
- Move inlining to fixup_bpf_calls() in patch 1. (Daniel)
- It is inlined for 64 BITS_PER_LONG and jit_requested
  as the map_gen_lookup().  Other cases could be
  considered together with map_gen_lookup() if needed.
- Use usec resolution in bictcp_update() calculation in patch 3.
  usecs_to_jiffies() is then removed().  (Eric)

Martin KaFai Lau (3):
  bpf: Add BPF_FUNC_jiffies64
  bpf: Sync uapi bpf.h to tools/
  bpf: tcp: Add bpf_cubic example

 include/linux/bpf.h                           |   1 +
 include/uapi/linux/bpf.h                      |   9 +-
 kernel/bpf/core.c                             |   1 +
 kernel/bpf/helpers.c                          |  12 +
 kernel/bpf/verifier.c                         |  24 +
 net/core/filter.c                             |   2 +
 tools/include/uapi/linux/bpf.h                |   9 +-
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |  16 +
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     |  25 +
 tools/testing/selftests/bpf/progs/bpf_cubic.c | 544 ++++++++++++++++++
 10 files changed, 641 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_cubic.c

-- 
2.17.1

