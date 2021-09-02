Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2613FF231
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 19:20:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346570AbhIBRVE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 13:21:04 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30816 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1346565AbhIBRVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 13:21:03 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 182HJ5IE006660
        for <netdev@vger.kernel.org>; Thu, 2 Sep 2021 10:20:05 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=33VCdYpStX0Sw+pn5ejIOQKBbirZXE8W/mvrljry0f4=;
 b=Rh6VhaOtPvPOPw7WG9+d6xCRhGbooigeF5IfnDucM0fB/rfMw7eDyDBwwgoU+5CBhhiP
 Y16hu38Fct6FkW2CY8YgqA8kdu77+ONGsDSFO0R0W69bjCau2O56bp5kFJo65sjjB8J9
 CvCCobgeqHaOxhGWPfxgRCPZt66uWSgVI4o= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3atdxvbbdx-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 02 Sep 2021 10:20:05 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Thu, 2 Sep 2021 10:20:03 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id E74ED5FE2452; Thu,  2 Sep 2021 10:19:49 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>, <netdev@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH v4 bpf-next 0/9] bpf: implement variadic printk helper
Date:   Thu, 2 Sep 2021 10:19:20 -0700
Message-ID: <20210902171929.3922667-1-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-ORIG-GUID: M1ce9iU_SAvH7AFNL-FLr36LWAJ6npEQ
X-Proofpoint-GUID: M1ce9iU_SAvH7AFNL-FLr36LWAJ6npEQ
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-02_04:2021-09-02,2021-09-02 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 impostorscore=0
 priorityscore=1501 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2108310000 definitions=main-2109020100
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

v3 -> v4:
* Add patch 2, which migrates reference_tracking prog_test away from=20
  bpf_program__load. Could be placed a bit later in the series, but=20
	wanted to keep the actual vprintk-related patches contiguous
* Add patch 9, which adds a program w/ 0 fmt arg bpf_printk to vprintk
  test
* bpf_printk convenience macro isn't multiline anymore, so simplify [Andrii]
* Add some comments to ___bpf_pick_printk to make it more obvious when
  implementation switches from printk to vprintk [Andrii]
* BPF_PRINTK_FMT_TYPE -> BPF_PRINTK_FMT_MOD for 'static const' fmt string
  in printk wrapper macro [Andrii]
	* checkpatch.pl doesn't like this, says "Macros with complex values=20
	  should be enclosed in parentheses". Strange that it didn't have similar
		complaints about v3's BPF_PRINTK_FMT_TYPE. Regardless, IMO the complaint
		is not highlighting a real issue in the case of this macro.
* Fix alignment of __bpf_vprintk and __bpf_pick_printk [Andrii]
* rebase

v2 -> v3:
* Clean up patch 3's commit message [Alexei]
* Add patch 4, which modifies __bpf_printk to use 'static const char' to
  store fmt string with fallback for older kernels [Andrii]
* rebase

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

Dave Marchevsky (9):
  bpf: merge printk and seq_printf VARARG max macros
  selftests/bpf: stop using bpf_program__load
  bpf: add bpf_trace_vprintk helper
  libbpf: Modify bpf_printk to choose helper based on arg count
  libbpf: use static const fmt string in __bpf_printk
  bpftool: only probe trace_vprintk feature in 'full' mode
  selftests/bpf: Migrate prog_tests/trace_printk CHECKs to ASSERTs
  selftests/bpf: add trace_vprintk test prog
  selftests/bpf: Add test for bpf_printk w/ 0 fmt args

 include/linux/bpf.h                           |  3 +
 include/uapi/linux/bpf.h                      |  9 +++
 kernel/bpf/core.c                             |  5 ++
 kernel/bpf/helpers.c                          |  6 +-
 kernel/trace/bpf_trace.c                      | 54 ++++++++++++++-
 tools/bpf/bpftool/feature.c                   |  1 +
 tools/include/uapi/linux/bpf.h                |  9 +++
 tools/lib/bpf/bpf_helpers.h                   | 51 ++++++++++++---
 tools/testing/selftests/bpf/Makefile          |  3 +-
 .../bpf/prog_tests/reference_tracking.c       | 39 ++++++++---
 .../selftests/bpf/prog_tests/trace_printk.c   | 24 +++----
 .../selftests/bpf/prog_tests/trace_vprintk.c  | 65 +++++++++++++++++++
 .../selftests/bpf/progs/trace_vprintk.c       | 32 +++++++++
 tools/testing/selftests/bpf/test_bpftool.py   | 22 +++----
 14 files changed, 272 insertions(+), 51 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_vprintk.c
 create mode 100644 tools/testing/selftests/bpf/progs/trace_vprintk.c

--=20
2.30.2


