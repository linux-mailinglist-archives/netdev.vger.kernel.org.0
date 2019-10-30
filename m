Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9112EA633
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 23:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726962AbfJ3WcQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 18:32:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1436 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726377AbfJ3WcQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 18:32:16 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9UMW96C018821
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 15:32:15 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2vxwf8xgpw-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 30 Oct 2019 15:32:15 -0700
Received: from 2401:db00:2050:5076:face:0:1f:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 30 Oct 2019 15:32:14 -0700
Received: by devbig007.ftw2.facebook.com (Postfix, from userid 572438)
        id 1DD5F760903; Wed, 30 Oct 2019 15:32:12 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Alexei Starovoitov <ast@kernel.org>
Smtp-Origin-Hostname: devbig007.ftw2.facebook.com
To:     <davem@davemloft.net>
CC:     <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/2] bpf: cleanup BTF-enabled raw_tp
Date:   Wed, 30 Oct 2019 15:32:10 -0700
Message-ID: <20191030223212.953010-1-ast@kernel.org>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-30_09:2019-10-30,2019-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 malwarescore=0 mlxlogscore=636 spamscore=0 impostorscore=0 clxscore=1015
 adultscore=0 phishscore=0 priorityscore=1501 bulkscore=0 suspectscore=1
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910300200
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v1->v2: addressed Andrii's feedback

When BTF-enabled raw_tp were introduced the plan was to follow up
with BTF-enabled kprobe and kretprobe reusing PROG_RAW_TRACEPOINT
and PROG_KPROBE types. But k[ret]probe expect pt_regs while
BTF-enabled program ctx will be the same as raw_tp.
kretprobe is indistinguishable from kprobe while BTF-enabled
kretprobe will have access to retval while kprobe will not.
Hence PROG_KPROBE type is not reusable and reusing
PROG_RAW_TRACEPOINT no longer fits well.
Hence introduce 'umbrella' prog type BPF_PROG_TYPE_TRACING
that will cover different BTF-enabled tracing attach points.
The changes make libbpf side cleaner as well.
check_attach_btf_id() is cleaner too.

Alexei Starovoitov (2):
  bpf: replace prog_raw_tp+btf_id with prog_tracing
  libbpf: add support for prog_tracing

 include/linux/bpf.h            |  5 +++
 include/linux/bpf_types.h      |  1 +
 include/uapi/linux/bpf.h       |  2 +
 kernel/bpf/syscall.c           |  6 +--
 kernel/bpf/verifier.c          | 34 ++++++++++-----
 kernel/trace/bpf_trace.c       | 44 +++++++++++++++----
 tools/include/uapi/linux/bpf.h |  2 +
 tools/lib/bpf/bpf.c            |  8 ++--
 tools/lib/bpf/bpf.h            |  5 ++-
 tools/lib/bpf/libbpf.c         | 79 ++++++++++++++++++++++++----------
 tools/lib/bpf/libbpf.h         |  2 +
 tools/lib/bpf/libbpf.map       |  2 +
 tools/lib/bpf/libbpf_probes.c  |  1 +
 13 files changed, 142 insertions(+), 49 deletions(-)

-- 
2.17.1

