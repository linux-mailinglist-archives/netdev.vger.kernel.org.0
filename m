Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1531148E83
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbfFQT1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:27:12 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34370 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728954AbfFQT1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:27:11 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5HJF32Y005030
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:27:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=qDy0sM9VLQMfAUN4kzCl+M5xeWtMLf9D5WRTvdYOVbY=;
 b=BH3oCflIpSQDR5zw6LuGzUGk1BzRjvRxgk8qJk+iK5dh8yQg0BJq5JSGk+MQW8NYI9nF
 XV9EhJAZN0jwvPOzCyaIbGsQiGhgFtDqrshouTk1/VC2ezKN/rrUbQ3kM+EvyuzamCJ8
 6WbSx93dIE/bnk5w8cAS0zDmhpEIxNGmyPY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2t68gv9ujx-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 12:27:10 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 17 Jun 2019 12:27:03 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 96DC986173A; Mon, 17 Jun 2019 12:27:01 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 00/11] BTF-defined BPF map definitions
Date:   Mon, 17 Jun 2019 12:26:49 -0700
Message-ID: <20190617192700.2313445-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-17_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906170171
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set implements initial version (as discussed at LSF/MM2019
conference) of a new way to specify BPF maps, relying on BTF type information,
which allows for easy extensibility, preserving forward and backward
compatibility. See details and examples in description for patch #6.

[0] contains an outline of follow up extensions to be added after this basic
set of features lands. They are useful by itself, but also allows to bring
libbpf to feature-parity with iproute2 BPF loader. That should open a path
forward for BPF loaders unification.

Patch #1 centralizes commonly used min/max macro in libbpf_internal.h.
Patch #2 extracts .BTF and .BTF.ext loading loging from elf_collect().
Patch #3 simplifies elf_collect() error-handling logic.
Patch #4 refactors map initialization logic into user-provided maps and global
data maps, in preparation to adding another way (BTF-defined maps).
Patch #5 adds support for map definitions in multiple ELF sections and
deprecates bpf_object__find_map_by_offset() API which doesn't appear to be
used anymore and makes assumption that all map definitions reside in single
ELF section.
Patch #6 splits BTF intialization from sanitization/loading into kernel to
preserve original BTF at the time of map initialization.
Patch #7 adds support for BTF-defined maps.
Patch #8 adds new test for BTF-defined map definition.
Patches #9-11 convert test BPF map definitions to use BTF way.

[0] https://lore.kernel.org/bpf/CAEf4BzbfdG2ub7gCi0OYqBrUoChVHWsmOntWAkJt47=FE+km+A@mail.gmail.com/

v1->v2:
- more BTF-sanity checks in parsing map definitions (Song);
- removed confusing usage of "attribute", switched to "field;
- split off elf_collect() refactor from btf loading refactor (Song);
- split selftests conversion into 3 patches (Stanislav):
  1. test already relying on BTF;
  2. tests w/ custom types as key/value (so benefiting from BTF);
  3. all the rest tests (integers as key/value, special maps w/o BTF support).
- smaller code improvements (Song);

rfc->v1:
- error out on unknown field by default (Stanislav, Jakub, Lorenz);
 
Andrii Nakryiko (11):
  libbpf: add common min/max macro to libbpf_internal.h
  libbpf: extract BTF loading logic
  libbpf: streamline ELF parsing error-handling
  libbpf: refactor map initialization
  libbpf: identify maps by section index in addition to offset
  libbpf: split initialization and loading of BTF
  libbpf: allow specifying map definitions using BTF
  selftests/bpf: add test for BTF-defined maps
  selftests/bpf: switch BPF_ANNOTATE_KV_PAIR tests to BTF-defined maps
  selftests/bpf: convert tests w/ custom values to BTF-defined maps
  selftests/bpf: convert remaining selftests to BTF-defined maps

 tools/lib/bpf/bpf.c                           |   7 +-
 tools/lib/bpf/bpf_prog_linfo.c                |   5 +-
 tools/lib/bpf/btf.c                           |   3 -
 tools/lib/bpf/btf.h                           |   1 +
 tools/lib/bpf/btf_dump.c                      |   3 -
 tools/lib/bpf/libbpf.c                        | 781 +++++++++++++-----
 tools/lib/bpf/libbpf_internal.h               |   7 +
 tools/testing/selftests/bpf/progs/bpf_flow.c  |  18 +-
 .../selftests/bpf/progs/get_cgroup_id_kern.c  |  18 +-
 .../testing/selftests/bpf/progs/netcnt_prog.c |  22 +-
 .../selftests/bpf/progs/sample_map_ret0.c     |  18 +-
 .../selftests/bpf/progs/socket_cookie_prog.c  |  11 +-
 .../bpf/progs/sockmap_verdict_prog.c          |  36 +-
 .../selftests/bpf/progs/test_btf_newkv.c      |  73 ++
 .../bpf/progs/test_get_stack_rawtp.c          |  27 +-
 .../selftests/bpf/progs/test_global_data.c    |  27 +-
 tools/testing/selftests/bpf/progs/test_l4lb.c |  45 +-
 .../selftests/bpf/progs/test_l4lb_noinline.c  |  45 +-
 .../selftests/bpf/progs/test_map_in_map.c     |  20 +-
 .../selftests/bpf/progs/test_map_lock.c       |  22 +-
 .../testing/selftests/bpf/progs/test_obj_id.c |   9 +-
 .../bpf/progs/test_select_reuseport_kern.c    |  45 +-
 .../bpf/progs/test_send_signal_kern.c         |  22 +-
 .../bpf/progs/test_skb_cgroup_id_kern.c       |   9 +-
 .../bpf/progs/test_sock_fields_kern.c         |  60 +-
 .../selftests/bpf/progs/test_spin_lock.c      |  33 +-
 .../bpf/progs/test_stacktrace_build_id.c      |  44 +-
 .../selftests/bpf/progs/test_stacktrace_map.c |  40 +-
 .../testing/selftests/bpf/progs/test_tc_edt.c |   9 +-
 .../bpf/progs/test_tcp_check_syncookie_kern.c |   9 +-
 .../selftests/bpf/progs/test_tcp_estats.c     |   9 +-
 .../selftests/bpf/progs/test_tcpbpf_kern.c    |  18 +-
 .../selftests/bpf/progs/test_tcpnotify_kern.c |  18 +-
 tools/testing/selftests/bpf/progs/test_xdp.c  |  18 +-
 .../selftests/bpf/progs/test_xdp_noinline.c   |  60 +-
 tools/testing/selftests/bpf/test_btf.c        |  10 +-
 .../selftests/bpf/test_queue_stack_map.h      |  20 +-
 .../testing/selftests/bpf/test_sockmap_kern.h |  72 +-
 38 files changed, 1199 insertions(+), 495 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/test_btf_newkv.c

-- 
2.17.1

