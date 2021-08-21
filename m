Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78713F382A
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 04:58:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232801AbhHUC7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 22:59:31 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:59344 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231847AbhHUC73 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 22:59:29 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17L2paqO013813
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 19:58:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=facebook; bh=6VZWc3kfnhg7YoVRzY4Hjl2QDh5y+aGM3/7y7Tdb9Lg=;
 b=Qy3efOA2BprW9uCqsKsWTHUVnaOaso9ORPLkaGJKSuLj/oX3oQG59bT4GitSiHErDIe2
 v0JfKlG4NBJv39KIBdHHYQzBCdpFAZn3ubEr4wlC40MnKVO31AINDkUsgXdNSew6xK3z
 MeQj8AHCH8O5Z4ZMKD8aHrYDDdfDruIFjj8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3ajfuh2x5v-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 19:58:51 -0700
Received: from intmgw002.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 20 Aug 2021 19:58:46 -0700
Received: by devbig030.frc3.facebook.com (Postfix, from userid 158236)
        id 85CD3573006D; Fri, 20 Aug 2021 19:58:44 -0700 (PDT)
From:   Dave Marchevsky <davemarchevsky@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Florent Revest <revest@chromium.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>
Subject: [PATCH bpf-next 0/5] bpf: implement variadic printk helper
Date:   Fri, 20 Aug 2021 19:58:32 -0700
Message-ID: <20210821025837.1614098-1-davemarchevsky@fb.com>
X-Mailer: git-send-email 2.30.2
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: 1rf_KOEKM5wWdFGdeykQgQRzwBdHCkOi
X-Proofpoint-ORIG-GUID: 1rf_KOEKM5wWdFGdeykQgQRzwBdHCkOi
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-20_11:2021-08-20,2021-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1011
 priorityscore=1501 mlxscore=0 suspectscore=0 lowpriorityscore=0
 phishscore=0 impostorscore=0 mlxlogscore=744 adultscore=0 bulkscore=0
 malwarescore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108210016
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces a new helper, bpf_trace_vprintk, which functions
like bpf_trace_printk but supports > 3 arguments via a pseudo-vararg u64
array. A libbpf convienience macro, bpf_vprintk, is added to support
true vararg calling style.

Helper functions and macros added during the implementation of
bpf_seq_printf and bpf_snprintf do most of the heavy lifting for
bpf_trace_vprintk. There's no novel format string wrangling here.

Usecase here is straightforward: Giving BPF program writers a more
powerful printk will ease development of BPF programs, particularly
during debugging and testing, where printk tends to be used.

Hypothetically libbpf's bpf_printk convenience macro could be modified
to use bpf_trace_vprintk under the hood. This patchset does not attempt
to do this, though, nor am I confident that it's desired.

This feature was proposed by Andrii in libbpf mirror's issue tracker
[1].

[1] https://github.com/libbpf/libbpf/issues/315

Dave Marchevsky (5):
  bpf: merge printk and seq_printf VARARG max macros
  bpf: add bpf_trace_vprintk helper
  libbpf: Add bpf_vprintk convenience macro
  bpftool: only probe trace_vprintk feature in 'full' mode
  selftests/bpf: add trace_vprintk test prog

 include/linux/bpf.h                           |  3 +
 include/uapi/linux/bpf.h                      | 23 ++++++
 kernel/bpf/core.c                             |  5 ++
 kernel/bpf/helpers.c                          |  6 +-
 kernel/trace/bpf_trace.c                      | 54 ++++++++++++-
 tools/bpf/bpftool/feature.c                   |  1 +
 tools/include/uapi/linux/bpf.h                | 23 ++++++
 tools/lib/bpf/bpf_helpers.h                   | 18 +++++
 tools/testing/selftests/bpf/Makefile          |  3 +-
 .../selftests/bpf/prog_tests/trace_vprintk.c  | 75 +++++++++++++++++++
 .../selftests/bpf/progs/trace_vprintk.c       | 25 +++++++
 tools/testing/selftests/bpf/test_bpftool.py   | 22 +++---
 12 files changed, 238 insertions(+), 20 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/trace_vprintk.c
 create mode 100644 tools/testing/selftests/bpf/progs/trace_vprintk.c

--=20
2.30.2

