Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B9E11B6D3A
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 07:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbgDXFfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 01:35:11 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16554 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725852AbgDXFfL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 01:35:11 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03O5XPJ3006374
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 22:35:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=qU9vewTtncg/IN0qS/3ljOwnC0VYC7eibsqX+kps56g=;
 b=Zy0dWTCyOBg1TORgXKvaKBQU14B+3ocn5h8/QpSvEGXxUOUiST3CD3gfgJBMbr0sv+c2
 DvNMTseWjoGCN1g9o7FmCs/ceznCX3YOjo9HcdTwBCOG6uHybVSxmvkny0xhcYrN//Oy
 ph3xMj4vWXbwqDgDoHdYZ/F+/SIFztf+HuM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 30k6gcq34u-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 22:35:10 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Thu, 23 Apr 2020 22:35:09 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id E32462EC2C8E; Thu, 23 Apr 2020 22:35:07 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 00/10] bpf_link observability APIs
Date:   Thu, 23 Apr 2020 22:34:55 -0700
Message-ID: <20200424053505.4111226-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_01:2020-04-23,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 spamscore=0 phishscore=0 clxscore=1015 suspectscore=8 impostorscore=0
 mlxscore=0 bulkscore=0 adultscore=0 malwarescore=0 mlxlogscore=373
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004240040
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds various observability APIs to bpf_link:
  - each bpf_link now gets ID, similar to bpf_map and bpf_prog, by which
    user-space can iterate over all existing bpf_links and create limited=
 FD
    from ID;
  - allows to get extra object information with bpf_link general and
    type-specific information;
  - implements `bpf link show` command which lists all active bpf_links i=
n the
    system;
  - implements `bpf link pin` allowing to pin bpf_link by ID or from othe=
r
    pinned path.

rfc->v1:
  - dropped read-only bpf_links (Alexei);
  - fixed bug in bpf_link_cleanup() not removing ID;
  - fixed bpftool link pinning search logic;
  - added bash-completion and man page.

Andrii Nakryiko (10):
  bpf: refactor bpf_link update handling
  bpf: allocate ID for bpf_link
  bpf: support GET_FD_BY_ID and GET_NEXT_ID for bpf_link
  bpf: add support for BPF_OBJ_GET_INFO_BY_FD for bpf_link
  libbpf: add low-level APIs for new bpf_link commands
  selftests/bpf: test bpf_link's get_next_id, get_fd_by_id, and
    get_obj_info
  bpftool: expose attach_type-to-string array to non-cgroup code
  bpftool: add bpf_link show and pin support
  bpftool: add bpftool-link manpage
  bpftool: add link bash completions

 include/linux/bpf-cgroup.h                    |  14 -
 include/linux/bpf.h                           |  28 +-
 include/linux/bpf_types.h                     |   6 +
 include/uapi/linux/bpf.h                      |  31 ++
 kernel/bpf/btf.c                              |   2 +
 kernel/bpf/cgroup.c                           |  89 +++-
 kernel/bpf/syscall.c                          | 363 +++++++++++++---
 kernel/bpf/verifier.c                         |   2 +
 kernel/cgroup/cgroup.c                        |  27 --
 .../bpftool/Documentation/bpftool-link.rst    | 119 ++++++
 tools/bpf/bpftool/bash-completion/bpftool     |  39 ++
 tools/bpf/bpftool/cgroup.c                    |  28 +-
 tools/bpf/bpftool/common.c                    |   2 +
 tools/bpf/bpftool/link.c                      | 402 ++++++++++++++++++
 tools/bpf/bpftool/main.c                      |   6 +-
 tools/bpf/bpftool/main.h                      |  37 ++
 tools/include/uapi/linux/bpf.h                |  31 ++
 tools/lib/bpf/bpf.c                           |  19 +-
 tools/lib/bpf/bpf.h                           |   4 +-
 tools/lib/bpf/libbpf.map                      |   6 +
 .../selftests/bpf/prog_tests/bpf_obj_id.c     | 110 ++++-
 .../testing/selftests/bpf/progs/test_obj_id.c |  14 +-
 22 files changed, 1203 insertions(+), 176 deletions(-)
 create mode 100644 tools/bpf/bpftool/Documentation/bpftool-link.rst
 create mode 100644 tools/bpf/bpftool/link.c

--=20
2.24.1

