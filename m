Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 492B0133C31
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 08:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgAHHZv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 8 Jan 2020 02:25:51 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49996 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726697AbgAHHZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 02:25:51 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0087PKQS031129
        for <netdev@vger.kernel.org>; Tue, 7 Jan 2020 23:25:50 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xd5ah9cn7-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 07 Jan 2020 23:25:50 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 7 Jan 2020 23:25:49 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id A7FA2760DB5; Tue,  7 Jan 2020 23:25:38 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/6] bpf: Introduce global functions
Date:   Tue, 7 Jan 2020 23:25:32 -0800
Message-ID: <20200108072538.3359838-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-08_01:2020-01-07,2020-01-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 mlxlogscore=474 impostorscore=0 suspectscore=1 priorityscore=1501
 malwarescore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001080063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Introduce static vs global functions and function by function verification.
This is another step toward dynamic re-linking (or replacement) of global
functions. See patch 3 for details. The rest are supporting patches.

Alexei Starovoitov (6):
  libbpf: Sanitize BTF_KIND_FUNC linkage
  libbpf: Collect static vs global info about functions
  bpf: Introduce function-by-function verification
  selftests/bpf: Add fexit-to-skb test for global funcs
  selftests/bpf: Add a test for a large global function
  selftests/bpf: Modify a test to check global functions

 include/linux/bpf.h                           |   7 +-
 include/linux/bpf_verifier.h                  |   7 +-
 include/uapi/linux/btf.h                      |   6 +
 kernel/bpf/btf.c                              | 147 ++++++++---
 kernel/bpf/verifier.c                         | 228 ++++++++++++++----
 tools/include/uapi/linux/btf.h                |   6 +
 tools/lib/bpf/libbpf.c                        | 150 +++++++++++-
 .../bpf/prog_tests/bpf_verif_scale.c          |   2 +
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  |   1 +
 .../selftests/bpf/progs/fexit_bpf2bpf.c       |  15 ++
 tools/testing/selftests/bpf/progs/pyperf.h    |   9 +-
 .../selftests/bpf/progs/pyperf_global.c       |   5 +
 .../selftests/bpf/progs/test_pkt_access.c     |  28 +++
 .../selftests/bpf/progs/test_xdp_noinline.c   |   4 +-
 14 files changed, 528 insertions(+), 87 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/pyperf_global.c

-- 
2.23.0

