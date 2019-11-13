Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DECB9FA767
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 04:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfKMDju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 22:39:50 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57198 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727597AbfKMDjt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 22:39:49 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xAD39D0B020113
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 19:15:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=sjvxiTL/ckYkzroQxbAPNyW+qzPGBEdDamqyHnjH28Y=;
 b=JwC4IZkdcKL5K2SIwYgjmqqy1n+FDg0JaPoRqHw/uuj/YjvYvKw2L2wL0GRzRyNsYXdQ
 gZVBMgFGakdIKIWKkHBjCr5xYwPxwTMBASmNpp3snPs20bVTvlg8UyZu1O4EwthYtrtq
 C2rGsszLOkMVLxhnaFNoEQvOJVI/JuzYHas= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2w7pr9wtam-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 19:15:25 -0800
Received: from 2401:db00:2050:5102:face:0:3b:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 12 Nov 2019 19:15:23 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 08FC02EC1B1D; Tue, 12 Nov 2019 19:15:22 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 0/3] Add support for memory-mapping BPF array maps
Date:   Tue, 12 Nov 2019 19:15:15 -0800
Message-ID: <20191113031518.155618-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-12_10:2019-11-11,2019-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 clxscore=1015 phishscore=0 spamscore=0 bulkscore=0 impostorscore=0
 malwarescore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 mlxlogscore=464 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911130026
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

Andrii Nakryiko (3):
  bpf: add mmap() support for BPF_MAP_TYPE_ARRAY
  libbpf: make global data internal arrays mmap()-able, if possible
  selftests/bpf: add BPF_TYPE_MAP_ARRAY mmap() tests

 include/linux/bpf.h                           |   6 +-
 include/uapi/linux/bpf.h                      |   3 +
 kernel/bpf/arraymap.c                         |  93 +++++++++-
 kernel/bpf/syscall.c                          |  47 +++++
 tools/include/uapi/linux/bpf.h                |   3 +
 tools/lib/bpf/libbpf.c                        |  32 +++-
 .../selftests/bpf/prog_tests/core_reloc.c     |  45 +++--
 tools/testing/selftests/bpf/prog_tests/mmap.c | 170 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_mmap.c |  41 +++++
 9 files changed, 413 insertions(+), 27 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/mmap.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_mmap.c

-- 
2.17.1

