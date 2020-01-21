Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADAD91434E2
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 01:54:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbgAUAx6 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 20 Jan 2020 19:53:58 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:45304 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728512AbgAUAx6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 19:53:58 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00L0qCLB012423
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 16:53:57 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xmjeuphar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 20 Jan 2020 16:53:57 -0800
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 20 Jan 2020 16:53:56 -0800
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 98D6E760B6E; Mon, 20 Jan 2020 16:53:48 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/3] bpf: Program extensions or dynamic re-linking
Date:   Mon, 20 Jan 2020 16:53:45 -0800
Message-ID: <20200121005348.2769920-1-ast@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-20_10:2020-01-20,2020-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 phishscore=0 suspectscore=1 clxscore=1034 mlxlogscore=291
 lowpriorityscore=0 mlxscore=0 spamscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001210004
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The last few month BPF community has been discussing an approach to call
chaining, since exiting bpt_tail_call() mechanism used in production XDP
programs has plenty of downsides. The outcome of these discussion was a
conclusion to implement dynamic re-linking of BPF programs. Where rootlet XDP
program attached to a netdevice can programmatically define a policy of
execution of other XDP programs. Such rootlet would be compiled as normal XDP
program and provide a number of placeholder global functions which later can be
replaced with future XDP programs. BPF trampoline, function by function
verification were building blocks towards that goal. The patch 1 is a final
building block. It introduces dynamic program extensions. A number of
improvements like more flexible function by function verification and better
libbpf api will be implemented in future patches.

v1->v2:
- addressed Andrii's comments
- rebase

Alexei Starovoitov (3):
  bpf: Introduce dynamic program extensions
  libbpf: Add support for program extensions
  selftests/bpf: Add tests for program extensions

 include/linux/bpf.h                           |  10 +-
 include/linux/bpf_types.h                     |   2 +
 include/linux/btf.h                           |   5 +
 include/uapi/linux/bpf.h                      |   1 +
 kernel/bpf/btf.c                              | 152 +++++++++++++++++-
 kernel/bpf/syscall.c                          |  15 +-
 kernel/bpf/trampoline.c                       |  41 ++++-
 kernel/bpf/verifier.c                         |  85 +++++++---
 tools/include/uapi/linux/bpf.h                |   1 +
 tools/lib/bpf/bpf.c                           |   3 +-
 tools/lib/bpf/libbpf.c                        |  13 +-
 tools/lib/bpf/libbpf.h                        |   2 +
 tools/lib/bpf/libbpf.map                      |   2 +
 tools/lib/bpf/libbpf_probes.c                 |   1 +
 .../selftests/bpf/prog_tests/fexit_bpf2bpf.c  |  20 ++-
 .../selftests/bpf/progs/fexit_bpf2bpf.c       |  57 +++++++
 .../selftests/bpf/progs/test_pkt_access.c     |   8 +-
 17 files changed, 384 insertions(+), 34 deletions(-)

-- 
2.23.0

