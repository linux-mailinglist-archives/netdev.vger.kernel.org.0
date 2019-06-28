Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAAB959ECA
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 17:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbfF1PZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 11:25:44 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7308 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726762AbfF1PZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 11:25:44 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SFOeJK018312
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 08:25:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=tKu7DMjohIpPgkoU2QT6W/+9x5SF+HZbH9KSRajuLPo=;
 b=Io5HoV0wcSLwfIuWmtnurVynDSJqMDsOH6rB0HVclU/Y9PQAzXOZDPSCAAk8WdXNK6Lu
 dZElxky0DfIXweX2wI2MOH8VJ8qTkES0l6fALoTEMDkhT+5bXjXnnSLkbVFHN5qxZU+i
 MxutR4AWHgVU8B+GZ4LZzO8MR4Aq+ihoW0o= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tdes51efj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 08:25:43 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 28 Jun 2019 08:25:41 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id F0968861486; Fri, 28 Jun 2019 08:25:40 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 0/4] capture integers in BTF type info for map defs
Date:   Fri, 28 Jun 2019 08:25:35 -0700
Message-ID: <20190628152539.3014719-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=896 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280178
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set implements an update to how BTF-defined maps are specified. The
change is in how integer attributes, e.g., type, max_entries, map_flags, are
specified: now they are captured as part of map definition struct's BTF type
information (using array dimension), eliminating the need for compile-time
data initialization and keeping all the metadata in one place.

All existing selftests that were using BTF-defined maps are updated, along
with some other selftests, that were switched to new syntax.

v1->v2:
- split bpf_helpers.h change from libbpf change (Song).

Andrii Nakryiko (4):
  libbpf: capture value in BTF type info for BTF-defined map defs
  selftests/bpf: add __int and __type macro for BTF-defined maps
  selftests/bpf: convert selftests using BTF-defined maps to new syntax
  selftests/bpf: convert legacy BPF maps to BTF-defined ones

 tools/lib/bpf/libbpf.c                        |  58 +++++----
 tools/testing/selftests/bpf/bpf_helpers.h     |   3 +
 tools/testing/selftests/bpf/progs/bpf_flow.c  |  28 ++---
 .../selftests/bpf/progs/get_cgroup_id_kern.c  |  26 ++---
 .../testing/selftests/bpf/progs/netcnt_prog.c |  20 ++--
 tools/testing/selftests/bpf/progs/pyperf.h    |  90 +++++++-------
 .../selftests/bpf/progs/sample_map_ret0.c     |  24 ++--
 .../selftests/bpf/progs/socket_cookie_prog.c  |  13 +--
 .../bpf/progs/sockmap_verdict_prog.c          |  48 ++++----
 .../testing/selftests/bpf/progs/strobemeta.h  |  68 +++++------
 .../selftests/bpf/progs/test_btf_newkv.c      |  13 +--
 .../bpf/progs/test_get_stack_rawtp.c          |  39 +++----
 .../selftests/bpf/progs/test_global_data.c    |  37 +++---
 tools/testing/selftests/bpf/progs/test_l4lb.c |  65 ++++-------
 .../selftests/bpf/progs/test_l4lb_noinline.c  |  65 ++++-------
 .../selftests/bpf/progs/test_map_in_map.c     |  30 ++---
 .../selftests/bpf/progs/test_map_lock.c       |  26 ++---
 .../testing/selftests/bpf/progs/test_obj_id.c |  12 +-
 .../bpf/progs/test_select_reuseport_kern.c    |  67 ++++-------
 .../bpf/progs/test_send_signal_kern.c         |  26 ++---
 .../bpf/progs/test_sock_fields_kern.c         |  78 +++++--------
 .../selftests/bpf/progs/test_spin_lock.c      |  36 +++---
 .../bpf/progs/test_stacktrace_build_id.c      |  55 ++++-----
 .../selftests/bpf/progs/test_stacktrace_map.c |  52 +++------
 .../selftests/bpf/progs/test_tcp_estats.c     |  13 +--
 .../selftests/bpf/progs/test_tcpbpf_kern.c    |  26 ++---
 .../selftests/bpf/progs/test_tcpnotify_kern.c |  28 ++---
 tools/testing/selftests/bpf/progs/test_xdp.c  |  26 ++---
 .../selftests/bpf/progs/test_xdp_loop.c       |  26 ++---
 .../selftests/bpf/progs/test_xdp_noinline.c   |  81 +++++--------
 .../selftests/bpf/progs/xdp_redirect_map.c    |  12 +-
 .../testing/selftests/bpf/progs/xdping_kern.c |  12 +-
 .../selftests/bpf/test_queue_stack_map.h      |  30 ++---
 .../testing/selftests/bpf/test_sockmap_kern.h | 110 +++++++++---------
 34 files changed, 571 insertions(+), 772 deletions(-)

-- 
2.17.1

