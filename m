Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8830A19E1D8
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 02:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726328AbgDDAKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 20:10:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32038 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726297AbgDDAKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 20:10:10 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03406RWX004748
        for <netdev@vger.kernel.org>; Fri, 3 Apr 2020 17:10:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=hBjcMRU7riISgtiFRtriFrlPdfTfhWVZDohI9vKZYa0=;
 b=UUsBSnYsH7GbB115b2qoLnYVnfzlFlBwcSA2kmy2ifn/tDStI2frXbMUH3uRcNATlmTp
 ET7BeBqOsVIc7mMRezYjF2hdrQN8kUAljwrmzoq59OA3Arqw9M5ukShpI8qw0KAiQBfC
 u7C83N2bPiC+dJZ0evoWoehjwdzBhoTp1Qo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3067152kgg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 17:10:09 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 3 Apr 2020 17:10:07 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8C1D92EC2885; Fri,  3 Apr 2020 17:09:58 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 0/8] bpf_link observability APIs
Date:   Fri, 3 Apr 2020 17:09:39 -0700
Message-ID: <20200404000948.3980903-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-03_19:2020-04-03,2020-04-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=314
 spamscore=0 clxscore=1015 phishscore=0 mlxscore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=8 malwarescore=0
 priorityscore=1501 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004030183
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
  - makes LINK_UPDATE operation allowed only for writable bpf_links and a=
llows
    to pin bpf_link as read-only file;
  - implements `bpf link show` command which lists all active bpf_links i=
n the
    system;
  - implements `bpf link pin` allowing to pin bpf_link by ID or from othe=
r
    pinned path.

This RFC series is missing selftests and only limited amount of manual te=
sting
was performed. But kernel implementation is hopefully in a good shape and
won't change much (unless some big issues are identified with the current
approach). It would be great to get feedback on approach and implementati=
on,
before I invest more time in writing tests.

Andrii Nakryiko (8):
  bpf: refactor bpf_link update handling
  bpf: allow bpf_link pinning as read-only and enforce LINK_UPDATE
  bpf: allocate ID for bpf_link
  bpf: support GET_FD_BY_ID and GET_NEXT_ID for bpf_link
  bpf: add support for BPF_OBJ_GET_INFO_BY_FD for bpf_link
  libbpf: add low-level APIs for new bpf_link commands
  bpftool: expose attach_type-to-string array to non-cgroup code
  bpftool: add bpf_link show and pin support

 include/linux/bpf-cgroup.h     |  14 --
 include/linux/bpf.h            |  34 ++-
 include/linux/bpf_types.h      |   6 +
 include/uapi/linux/bpf.h       |  31 +++
 kernel/bpf/btf.c               |   2 +
 kernel/bpf/cgroup.c            |  89 +++++++-
 kernel/bpf/inode.c             |  30 ++-
 kernel/bpf/syscall.c           | 387 +++++++++++++++++++++++++------
 kernel/bpf/verifier.c          |   2 +
 kernel/cgroup/cgroup.c         |  27 ---
 tools/bpf/bpftool/cgroup.c     |  28 +--
 tools/bpf/bpftool/link.c       | 403 +++++++++++++++++++++++++++++++++
 tools/bpf/bpftool/main.c       |   2 +
 tools/bpf/bpftool/main.h       |  37 +++
 tools/include/uapi/linux/bpf.h |  31 +++
 tools/lib/bpf/bpf.c            |  19 +-
 tools/lib/bpf/bpf.h            |   4 +-
 tools/lib/bpf/libbpf.map       |   6 +
 18 files changed, 983 insertions(+), 169 deletions(-)
 create mode 100644 tools/bpf/bpftool/link.c

--=20
2.24.1

