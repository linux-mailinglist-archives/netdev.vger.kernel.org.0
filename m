Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7AAC609B4
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726012AbfGEPuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:50:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23334 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726069AbfGEPuU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:50:20 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x65FlE81001288
        for <netdev@vger.kernel.org>; Fri, 5 Jul 2019 08:50:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=xkfVDaA/seYp3oZaorvGYgYRxTjVCnsA6u4Wt+j/r9M=;
 b=obExs04OZ6ecakDthNKtM705T/9fLuaj2isPozbxR3bN7yA6DryY5872E7pgIb2fEDdk
 ZpIpazgY35ET4Z3HvALLolQJswr8gAiY9uli8mWDnAb9uyMSeqlLlf9pf3AG7nNNvIZF
 98dTeyLkY3jd2D2ic7RRu+Pdm8utDNJLVdA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2tj6yd0kr3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 05 Jul 2019 08:50:18 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 5 Jul 2019 08:50:18 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 39587861628; Fri,  5 Jul 2019 08:50:16 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>, <ast@fb.com>,
        <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v5 bpf-next 0/4] capture integers in BTF type info for map defs
Date:   Fri, 5 Jul 2019 08:50:08 -0700
Message-ID: <20190705155012.3539722-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-05_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=988 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907050193
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

v4->v5:
- revert sample_map_ret0.c, which is loaded with iproute2 (kernel test robot);
v3->v4:
- add acks;
- fix int -> uint type in commit message;
v2->v3:
- rename __int into __uint (Yonghong);
v1->v2:
- split bpf_helpers.h change from libbpf change (Song).

Andrii Nakryiko (4):
  libbpf: capture value in BTF type info for BTF-defined map defs
  selftests/bpf: add __uint and __type macro for BTF-defined maps
  selftests/bpf: convert selftests using BTF-defined maps to new syntax
  selftests/bpf: convert legacy BPF maps to BTF-defined ones

 tools/lib/bpf/libbpf.c                        |  58 +++++----
 tools/testing/selftests/bpf/bpf_helpers.h     |   3 +
 tools/testing/selftests/bpf/progs/bpf_flow.c  |  28 ++---
 .../selftests/bpf/progs/get_cgroup_id_kern.c  |  26 ++---
 .../testing/selftests/bpf/progs/netcnt_prog.c |  20 ++--
 tools/testing/selftests/bpf/progs/pyperf.h    |  90 +++++++-------
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
 33 files changed, 559 insertions(+), 760 deletions(-)

-- 
2.17.1

