Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A85091749F4
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 00:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbgB2XLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 18:11:21 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:61596 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726786AbgB2XLV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 18:11:21 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01TN5hgS016646
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 15:11:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=P1R6PlcUBhbW7iFB1PDhfa3Wd08SJbxVdl+ijmv4BMc=;
 b=B7raW3U++2pPpLXFPqehlZSFItV11YEHOdmLXuPn0Z0ed7ZYXhSJ1+VWUfb1HIQPpXYH
 CMlU9iteKA4IYIYApOkwZoDY93JHgTuIYDiGhn9wOa2ge2VDJfr88z6Yfcfb2VJvmZoD
 v85VKHA/xp2ia4FQ21PxtzMX2Fy/qBq8wgI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yfpjv9tgs-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 15:11:20 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sat, 29 Feb 2020 15:11:19 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AEB902EC2C66; Sat, 29 Feb 2020 15:11:14 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/4] Move BPF_PROG, BPF_KPROBE, and BPF_KRETPROBE to libbpf
Date:   Sat, 29 Feb 2020 15:11:08 -0800
Message-ID: <20200229231112.1240137-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-29_09:2020-02-28,2020-02-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 mlxlogscore=783 suspectscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 mlxscore=0 spamscore=0 impostorscore=0 phishscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2002290180
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move BPF_PROG, BPF_KPROBE, and BPF_KRETPROBE helper macros from private
selftests helpers to public libbpf ones. These helpers are extremely helpful
for writing tracing BPF applications and have been requested to be exposed for
easy use (e.g., [0]).

As part of this move, fix up BPF_KRETPROBE to not allow for capturing input
arguments (as it's unreliable and they will be often clobbered). Also, add
vmlinux.h header guard to allow multi-time inclusion, if necessary; but also
to let PT_REGS_PARM do proper detection of struct pt_regs field names on x86
arch. See relevant patches for more details.

  [0] https://github.com/iovisor/bcc/pull/2778#issue-381642907

Andrii Nakryiko (4):
  bpftool: add header guards to generated vmlinux.h
  libbpf: fix use of PT_REGS_PARM macros with vmlinux.h
  selftests/bpf: fix BPF_KRETPROBE macro and use it in attach_probe test
  libbpf: merge selftests' bpf_trace_helpers.h into libbpf's
    bpf_tracing.h

 tools/bpf/bpftool/btf.c                       |   5 +
 tools/lib/bpf/bpf_tracing.h                   | 120 +++++++++++++++++-
 tools/testing/selftests/bpf/bpf_tcp_helpers.h |   2 +-
 .../testing/selftests/bpf/bpf_trace_helpers.h | 120 ------------------
 tools/testing/selftests/bpf/progs/bpf_dctcp.c |   2 +-
 .../testing/selftests/bpf/progs/fentry_test.c |   2 +-
 .../selftests/bpf/progs/fexit_bpf2bpf.c       |   2 +-
 .../bpf/progs/fexit_bpf2bpf_simple.c          |   2 +-
 .../testing/selftests/bpf/progs/fexit_test.c  |   2 +-
 tools/testing/selftests/bpf/progs/kfree_skb.c |   2 +-
 .../selftests/bpf/progs/test_attach_probe.c   |   3 +-
 .../selftests/bpf/progs/test_overhead.c       |   7 +-
 .../selftests/bpf/progs/test_perf_branches.c  |   2 +-
 .../selftests/bpf/progs/test_perf_buffer.c    |   2 +-
 .../selftests/bpf/progs/test_probe_user.c     |   1 -
 .../bpf/progs/test_trampoline_count.c         |   3 +-
 .../selftests/bpf/progs/test_xdp_bpf2bpf.c    |   2 +-
 17 files changed, 140 insertions(+), 139 deletions(-)
 delete mode 100644 tools/testing/selftests/bpf/bpf_trace_helpers.h

-- 
2.17.1

