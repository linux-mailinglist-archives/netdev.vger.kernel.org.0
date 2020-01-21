Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37863144570
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 20:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgAUTyX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 14:54:23 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6214 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726926AbgAUTyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 14:54:22 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00LJqPdr026335
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 11:54:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=M9tKYq5S8olI+roSrIUlCjG3W5Rekg0pHlLXt2E0X4Q=;
 b=DgIy0B8CAzdXtWxUhYMjqchR8sF//x4nJi9a2/82tCbgt1fYoeGaKKLRdSUFzyDcn2h6
 lApCq2xHu5OOG8/udfat+SvdWL0l4JynayZZSwNL/L6Xbmw20mgQu0H3bZGCLdB/1yxo
 q3KiabSi9D7Qa7CH20e/8LaroxJLbBatE84= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2xp51m0y0v-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 11:54:21 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 21 Jan 2020 11:54:10 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 7254729420B3; Tue, 21 Jan 2020 11:54:08 -0800 (PST)
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
Subject: [PATCH bpf-next 0/3] bpf: tcp: Add bpf_cubic example
Date:   Tue, 21 Jan 2020 11:54:08 -0800
Message-ID: <20200121195408.3756734-1-kafai@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.634
 definitions=2020-01-21_06:2020-01-21,2020-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=929 malwarescore=0 suspectscore=1 priorityscore=1501
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 lowpriorityscore=0
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001210147
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
3. The bpf .kconfig map is used to read CONFIG_HZ which
   is then used in the usecs_to_jiffies() conversion.

[1]: https://patchwork.ozlabs.org/cover/1215066/

Martin KaFai Lau (3):
  bpf: Add BPF_FUNC_jiffies64
  bpf: Sync uapi bpf.h to tools/
  bpf: tcp: Add bpf_cubic example

 include/linux/bpf.h                           |   2 +
 include/uapi/linux/bpf.h                      |   9 +-
 kernel/bpf/core.c                             |   1 +
 kernel/bpf/helpers.c                          |  27 +
 kernel/bpf/verifier.c                         |  18 +
 net/core/filter.c                             |   2 +
 tools/include/uapi/linux/bpf.h                |   9 +-
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |  16 +
 .../selftests/bpf/prog_tests/bpf_tcp_ca.c     |  25 +
 tools/testing/selftests/bpf/progs/bpf_cubic.c | 573 ++++++++++++++++++
 10 files changed, 680 insertions(+), 2 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_cubic.c

-- 
2.17.1

