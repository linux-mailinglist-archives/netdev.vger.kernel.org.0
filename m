Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4E99FD38E
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 05:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbfKOEDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 23:03:07 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36780 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727077AbfKOEDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 23:03:07 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xAF42wfU013923
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 20:03:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=NjD6iYWWXMn0edcBKgfvhlw6MnG/DFIs2+m4hGfsSm8=;
 b=mb2EJDZ2qIR1UaujUnsf79m7DMkoNimJb/5DQEK8D2NSTjn0i+bc2Imw/zcUSnHU8sLO
 rMaoXzQG6DASVc1kxQXQ9mkGAMgal+0tIk2Rr3odjwJ6SgRcH23rLRkKPDY1LGOiI7U6
 1q0u7YxuLYhoWCGawdwqSOxH597PdUwAIp8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2w9gffu7n2-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 20:03:05 -0800
Received: from 2401:db00:2120:81ca:face:0:31:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 14 Nov 2019 20:02:53 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 4057F2EC1AEC; Thu, 14 Nov 2019 20:02:49 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 0/4] Add support for memory-mapping BPF array maps
Date:   Thu, 14 Nov 2019 20:02:21 -0800
Message-ID: <20191115040225.2147245-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-14_07:2019-11-14,2019-11-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 mlxscore=0 clxscore=1015 malwarescore=0 mlxlogscore=521
 suspectscore=8 lowpriorityscore=0 phishscore=0 adultscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911150035
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds ability to memory-map BPF array maps (single- and
multi-element). The primary use case is memory-mapping BPF array maps, created
to back global data variables, created by libbpf implicitly. This allows for
much better usability, along with avoiding syscalls to read or update data
completely.

Due to memory-mapping requirements, BPF array map that is supposed to be
memory-mapped, has to be created with special BPF_F_MMAPABLE attribute, which
triggers slightly different memory allocation strategy internally. See
patch 1 for details.

Libbpf is extended to detect kernel support for this flag, and if supported,
will specify it for all global data maps automatically.

Patch #1 refactors bpf_map_inc() and converts bpf_map's refcnt to atomic64_t
to make refcounting never fail.

v3->v4:
- add mmap's open() callback to fix refcounting (Johannes);
- switch to remap_vmalloc_pages() instead of custom fault handler (Johannes);
- converted bpf_map's refcnt/usercnt into atomic64_t;
- provide default bpf_map_default_vmops handling open/close properly;

v2->v3:
- change allocation strategy to avoid extra pointer dereference (Jakub);

v1->v2:
- fix map lookup code generation for BPF_F_MMAPABLE case;
- prevent BPF_F_MMAPABLE flag for all but plain array map type;
- centralize ref-counting in generic bpf_map_mmap();
- don't use uref counting (Alexei);
- use vfree() directly;
- print flags with %x (Song);
- extend tests to verify bpf_map_{lookup,update}_elem() logic as well.


Andrii Nakryiko (4):
  bpf: switch bpf_map ref counter to 64bit so bpf_map_inc never fails
  bpf: add mmap() support for BPF_MAP_TYPE_ARRAY
  libbpf: make global data internal arrays mmap()-able, if possible
  selftests/bpf: add BPF_TYPE_MAP_ARRAY mmap() tests

 .../net/ethernet/netronome/nfp/bpf/offload.c  |   4 +-
 include/linux/bpf.h                           |  21 +-
 include/linux/vmalloc.h                       |   1 +
 include/uapi/linux/bpf.h                      |   3 +
 kernel/bpf/arraymap.c                         |  59 ++++-
 kernel/bpf/inode.c                            |   2 +-
 kernel/bpf/map_in_map.c                       |   2 +-
 kernel/bpf/syscall.c                          | 150 +++++++++---
 kernel/bpf/verifier.c                         |   6 +-
 kernel/bpf/xskmap.c                           |   6 +-
 mm/vmalloc.c                                  |  20 ++
 net/core/bpf_sk_storage.c                     |   2 +-
 tools/include/uapi/linux/bpf.h                |   3 +
 tools/lib/bpf/libbpf.c                        |  32 ++-
 .../selftests/bpf/prog_tests/core_reloc.c     |  45 ++--
 tools/testing/selftests/bpf/prog_tests/mmap.c | 220 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_mmap.c |  45 ++++
 17 files changed, 540 insertions(+), 81 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/mmap.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_mmap.c

-- 
2.17.1

