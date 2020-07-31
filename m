Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287B0234B01
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 20:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387886AbgGaS2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 14:28:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58346 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387680AbgGaS2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 14:28:37 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06VIFkBd023635
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 11:28:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=KqJIq725uq/HnQgvV55bIPsHwEMCXKUIsjnJYCPw/KY=;
 b=VUKziRaCkW0C976VR373ufk0F457N/CZ1hgiR8/PvuX6nAfrB6iflE9taDrVzuQSvCzo
 vMr0SpR7EYe4J1lUgoxyqsfcDECO+MNPbwsgeSvHxW5ctdzhPoyN0jsb+CPzH4uelDig
 tezzZsI0jDXj36JBiAOx/D5XGutD4rRND5k= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32kcbv3m6h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 31 Jul 2020 11:28:36 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 31 Jul 2020 11:28:34 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D16682EC4E02; Fri, 31 Jul 2020 11:28:31 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/5] BPF link force-detach support
Date:   Fri, 31 Jul 2020 11:28:25 -0700
Message-ID: <20200731182830.286260-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_07:2020-07-31,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=689
 bulkscore=0 clxscore=1015 suspectscore=8 phishscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007310137
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds new BPF link operation, LINK_DETACH, allowing process=
es
with BPF link FD to force-detach it from respective BPF hook, similarly h=
ow
BPF link is auto-detached when such BPF hook (e.g., cgroup, net_device, n=
etns,
etc) is removed. This facility allows admin to forcefully undo BPF link
attachment, while process that created BPF link in the first place is lef=
t
intact.

Once force-detached, BPF link stays valid in the kernel as long as there =
is at
least one FD open against it. It goes into defunct state, just like
auto-detached BPF link.

bpftool also got `link detach` command to allow triggering this in
non-programmatic fashion.

v1->v2:
- improve error reporting in `bpftool link detach` (Song).

Andrii Nakryiko (5):
  bpf: add support for forced LINK_DETACH command
  libbpf: add bpf_link detach APIs
  selftests/bpf: add link detach tests for cgroup, netns, and xdp
    bpf_links
  tools/bpftool: add `link detach` subcommand
  tools/bpftool: add documentation and bash-completion for `link detach`

 include/linux/bpf.h                           |  1 +
 include/uapi/linux/bpf.h                      |  5 ++
 kernel/bpf/cgroup.c                           | 15 +++++-
 kernel/bpf/net_namespace.c                    |  8 +++
 kernel/bpf/syscall.c                          | 26 ++++++++++
 net/core/dev.c                                | 11 +++-
 .../bpftool/Documentation/bpftool-link.rst    |  8 +++
 tools/bpf/bpftool/bash-completion/bpftool     |  4 +-
 tools/bpf/bpftool/link.c                      | 37 +++++++++++++-
 tools/include/uapi/linux/bpf.h                |  5 ++
 tools/lib/bpf/bpf.c                           | 10 ++++
 tools/lib/bpf/bpf.h                           |  2 +
 tools/lib/bpf/libbpf.c                        |  5 ++
 tools/lib/bpf/libbpf.h                        |  1 +
 tools/lib/bpf/libbpf.map                      |  2 +
 .../selftests/bpf/prog_tests/cgroup_link.c    | 20 +++++++-
 .../selftests/bpf/prog_tests/sk_lookup.c      | 51 +++++++++----------
 .../selftests/bpf/prog_tests/xdp_link.c       | 14 +++++
 tools/testing/selftests/bpf/testing_helpers.c | 14 +++++
 tools/testing/selftests/bpf/testing_helpers.h |  3 ++
 20 files changed, 208 insertions(+), 34 deletions(-)

--=20
2.24.1

