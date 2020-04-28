Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1E031BB5FF
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 07:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgD1FuH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 01:50:07 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7360 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726276AbgD1FuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 01:50:06 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03S5nuQN016944
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 22:50:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=SC/Z+FDbrYy/rHtsmiAIoXe4UdehF4nsaJNdgyfOiis=;
 b=LJxij4hO7s62o6xQePDNLIlxpio+sgaoGHbtzNqP0ilLHSFJa8aGni8IDfTApA0TzD63
 9na8w1kQYsNgtvr2eBUnXfKX/7U7g/X1z9UrC2wrCKI61+E6+KeQRC25HOrZDpH1nKeo
 7wNm88VpjryRVLg6HezxdXaL7XpW2OHf+sA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30n57pcufe-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 22:50:06 -0700
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 27 Apr 2020 22:49:49 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 5AEE22EC3228; Mon, 27 Apr 2020 22:49:48 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 00/10] bpf_link observability APIs
Date:   Mon, 27 Apr 2020 22:49:34 -0700
Message-ID: <20200428054944.4015462-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_02:2020-04-27,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=1 priorityscore=1501
 impostorscore=0 mlxscore=1 malwarescore=0 suspectscore=8 mlxlogscore=226
 lowpriorityscore=0 adultscore=0 bulkscore=0 spamscore=1 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280049
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

v1->v2:
  - simplified `bpftool link show` implementation (Quentin);
  - fixed formatting of bpftool-link.rst (Quentin);
  - fixed attach type printing logic (Quentin);
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
 kernel/bpf/cgroup.c                           |  89 ++++-
 kernel/bpf/syscall.c                          | 363 ++++++++++++++----
 kernel/bpf/verifier.c                         |   2 +
 kernel/cgroup/cgroup.c                        |  27 --
 .../bpftool/Documentation/bpftool-link.rst    | 118 ++++++
 tools/bpf/bpftool/bash-completion/bpftool     |  39 ++
 tools/bpf/bpftool/cgroup.c                    |  48 +--
 tools/bpf/bpftool/common.c                    |   2 +
 tools/bpf/bpftool/link.c                      | 333 ++++++++++++++++
 tools/bpf/bpftool/main.c                      |   6 +-
 tools/bpf/bpftool/main.h                      |  37 ++
 tools/include/uapi/linux/bpf.h                |  31 ++
 tools/lib/bpf/bpf.c                           |  19 +-
 tools/lib/bpf/bpf.h                           |   4 +-
 tools/lib/bpf/libbpf.map                      |   6 +
 .../selftests/bpf/prog_tests/bpf_obj_id.c     | 110 +++++-
 .../testing/selftests/bpf/progs/test_obj_id.c |  14 +-
 22 files changed, 1145 insertions(+), 184 deletions(-)
 create mode 100644 tools/bpf/bpftool/Documentation/bpftool-link.rst
 create mode 100644 tools/bpf/bpftool/link.c

--=20
2.24.1

