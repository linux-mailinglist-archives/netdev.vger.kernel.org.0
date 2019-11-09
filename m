Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4C44F5DF8
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 09:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfKIIGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 03:06:37 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:12736 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726194AbfKIIGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 03:06:37 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA986Z0i011235
        for <netdev@vger.kernel.org>; Sat, 9 Nov 2019 00:06:36 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=WrXskj98wPwxipTZZJZVOxl503bQP5STNNc4fgs3reI=;
 b=nY71equcCKGF5p8EmssGlzaLJ13LIrBj+nfKZmuEPM4/NV/OrfrNq6xF0yWhhWZ/G1Kn
 LoS9nDCumEypQwfSg5v/mWBhZ7LUbFnnYAX2eJmmIPxSsn/RuBK2ecigzqUXNI0feQCM
 afdvB7BHX8Rz4/nvdFX0tks7+crcRuuGW4k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w5snc0010-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 00:06:36 -0800
Received: from 2401:db00:2050:5076:face:0:7:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 9 Nov 2019 00:06:34 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0942F2EC1AC6; Sat,  9 Nov 2019 00:06:33 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/3] Add support for memory-mapping BPF array maps
Date:   Sat, 9 Nov 2019 00:06:29 -0800
Message-ID: <20191109080633.2855561-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-09_02:2019-11-08,2019-11-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=8 mlxlogscore=608
 priorityscore=1501 mlxscore=0 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911090085
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

 include/linux/bpf.h                           |   9 +-
 include/uapi/linux/bpf.h                      |   3 +
 kernel/bpf/arraymap.c                         | 111 ++++++++++--
 kernel/bpf/syscall.c                          |  47 +++++
 tools/include/uapi/linux/bpf.h                |   3 +
 tools/lib/bpf/libbpf.c                        |  31 +++-
 .../selftests/bpf/prog_tests/core_reloc.c     |  45 +++--
 tools/testing/selftests/bpf/prog_tests/mmap.c | 170 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/test_mmap.c |  41 +++++
 9 files changed, 426 insertions(+), 34 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/mmap.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_mmap.c

-- 
2.17.1

