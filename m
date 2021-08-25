Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 275F83F7CE7
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 21:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhHYT7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 15:59:19 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60840 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230301AbhHYT7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 15:59:19 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17PJm4AE015535
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 12:58:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=ppzl12XIXXdF6lrhtCyadV6Yuf7hv9PvvXVSD+QLf3Y=;
 b=qldT6Yft1pBxL3BWY/dqdvKoVtvA+EmfT/G7kBDaYLbDVJoggZocYqqQ14sgqrRoZ+dj
 dNtDsVkR4xi7AR01A68vYu32UzURLarjjsw0HW8yRpysFtDt6XXsA5tYKzZhkfsey2pb
 R/eNn02Uai0fQKWp/xByRa1hPW1Ij5ZHra4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3an8n4y8mm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 25 Aug 2021 12:58:32 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 25 Aug 2021 12:58:31 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id A46535A34E51; Wed, 25 Aug 2021 12:58:26 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v2 bpf-next 0/6] bpf: implement variadic printk helper
Date:   Wed, 25 Aug 2021 12:58:17 -0700
Message-ID: <20210825195823.381016-1-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: hnyq6rztXvufUzykrsdpXKNHYT0SjEiM
X-Proofpoint-ORIG-GUID: hnyq6rztXvufUzykrsdpXKNHYT0SjEiM
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-25_07:2021-08-25,2021-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 bulkscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108250117
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces a new helper, bpf_trace_vprintk, which functions
like bpf_trace_printk but supports > 3 arguments via a pseudo-vararg u64
array. The bpf_printk libbpf convenience macro is modified to use
bpf_trace_vprintk when > 3 varargs are passed, otherwise the previous
behavior - using bpf_trace_printk - is retained.

Helper functions and macros added during the implementation of
bpf_seq_printf and bpf_snprintf do most of the heavy lifting for
bpf_trace_vprintk. There's no novel format string wrangling here.

Usecase here is straightforward: Giving BPF program writers a more
powerful printk will ease development of BPF programs, particularly
during debugging and testing, where printk tends to be used.

This feature was proposed by Andrii in libbpf mirror's issue tracker
[1].

[1] https://github.com/libbpf/libbpf/issues/315


v1 -> v2:

* Naming conversation seems to have gone in favor of keeping
  bpf_trace_vprintk, names are unchanged

* Patch 3 now modifies bpf_printk convenience macro to choose between
  __bpf_printk and __bpf_vprintk 'implementation' macros based on arg
  count. __bpf_vprintk is a renaming of bpf_vprintk convenience macro
  from v1, __bpf_printk is the existing bpf_printk implementation.

  This patch could use some scrutiny as I think current implementation
  may regress developer experience in a specific case, turning a
  compile-time error into a load-time error. Unclear to me how
  common the case is, or whether the macro magic I chose is ideal.

* char ___fmt[] to static const char ___fmt[] change was not done,
  wanted to leave __bpf_printk 'implementation' macro unchanged for v2
  to ease discussion of above point

* Removed __always_inline from __set_printk_clr_event [Andrii]
* Simplified bpf_trace_printk docstring to refer to other functions
  instead of copy/pasting and avoid specifying 12 vararg limit [Andrii]
* Migrated trace_printk selftest to use ASSERT_ instead of CHECK
  * Adds new patch 5, previous patch 5 is now 6
* Migrated trace_vprintk selftest to use ASSERT_ instead of CHECK,
  open_and_load instead of separate open, load [Andrii]
* Patch 2's commit message now correctly mentions trace_pipe instead of
  dmesg [Andrii]


Dave Marchevsky (6):
  bpf: merge printk and seq_printf VARARG max macros
  bpf: add bpf_trace_vprintk helper
  libbpf: Modify bpf_printk to choose helper based on arg count
  bpftool: only probe trace_vprintk feature in 'full' mode
  selftests/bpf: Migrate prog_tests/trace_printk CHECKs to ASSERTs
  selftests/bpf: add trace_vprintk test prog

 include/linux/bpf.h                           |  3 +
 include/uapi/linux/bpf.h                      |  9 +++
 kernel/bpf/core.c                             |  5 ++
 kernel/bpf/helpers.c                          |  6 +-
 kernel/trace/bpf_trace.c                      | 54 ++++++++++++++-
 tools/bpf/bpftool/feature.c                   |  1 +
 tools/include/uapi/linux/bpf.h                |  9 +++
 tools/lib/bpf/bpf_helpers.h                   | 45 ++++++++++---
 tools/testing/selftests/bpf/Makefile          |  3 +-
 .../selftests/bpf/prog_tests/trace_printk.c   | 24 +++----
 .../selftests/bpf/prog_tests/trace_vprintk.c  | 65 +++++++++++++++++++
 .../selftests/bpf/progs/trace_vprintk.c       | 25 +++++++
 tools/testing/selftests/bpf/test_bpftool.py   | 22 +++----
 13 files changed, 228 insertions(+), 43 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_vprintk.c
 create mode 100644 tools/testing/selftests/bpf/progs/trace_vprintk.c

--=20
2.30.2

