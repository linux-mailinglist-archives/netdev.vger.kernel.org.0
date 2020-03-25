Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4B9192169
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 07:59:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbgCYG7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 02:59:38 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43602 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725878AbgCYG7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 02:59:38 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02P6oU1i007464
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 23:59:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=74a7pOOsCM70AzpDeaR2fZ1MUtlbhPJJbT1GkbJMYXM=;
 b=UDZGP0kIUZPGxxJJCA21NjA4dNtOiwQMRsADYpH/055v8REUIASEqwqGRgQAKdBfTQrb
 UxZBPnCyebrmth5y8SDO3ykA7QJWQvbkRgAsExSYRQZuzgdadHhn3Zr5s3t216knSmaU
 sLYMQxFaM+DDJNt9zd2uTg7mNbG4q+XIroc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2ywgem1k6s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 23:59:36 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 24 Mar 2020 23:59:35 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 9DAE92EC34F3; Tue, 24 Mar 2020 23:59:29 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <rdna@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/6] Add support for cgroup bpf_link
Date:   Tue, 24 Mar 2020 23:57:40 -0700
Message-ID: <20200325065746.640559-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_01:2020-03-23,2020-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003250056
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_link abstraction itself was formalized in [0] with justifications for why
its semantics is a good fit for attaching BPF programs of various types. This
patch set adds bpf_link-based BPF program attachment mechanism for cgroup BPF
programs.

Cgroup BPF link implements all the modes and semantics of existing BPF program
attachment: exclusive, exclusive overridable and multi-attachment. Thus cgroup
bpf_link can co-exist with legacy BPF program multi-attachment. See patch #4
for detailed explanation of inter-operability between legacy and
bpf_link-based attachments.

bpf_link is destroyed and automatically detached when the last open FD holding
the reference to bpf_link is closed. This means that by default, when the
process that created bpf_link exits, attached BPF program will be
automatically detached due to bpf_link's clean up code. Cgroup bpf_link, like
any other bpf_link, can be pinned in BPF FS and by those means survive the
exit of process that created the link. This is useful in many scenarios to
provide long-living BPF program attachments. Pinning also means that there
could be many owners of bpf_link through independent FDs.

Additionally, auto-detachmet of cgroup bpf_link is implemented. When cgroup is
dying it will automatically detach all active bpf_links. This ensures that
cgroup clean up is not delayed due to active bpf_link even despite no chance
for any BPF program to be run for a given cgroup. In that sense it's similar
to existing behavior of dropping refcnt of attached bpf_prog. But in the case
of bpf_link, bpf_link is not destroyed and is still available to user as long
as at least one active FD is still open (or if it's pinned in BPF FS).

There are two main cgroup-specific differences between bpf_link-based and
direct bpf_prog-based attachment.

First, as opposed to direct bpf_prog attachment, cgroup itself doesn't "own"
bpf_link, which makes it possible to auto-clean up attached bpf_link when user
process abruptly exits without explicitly detaching BPF program. This makes
for a safe default behavior proven in BPF tracing program types. But bpf_link
doesn't bump cgroup->bpf.refcnt as well and because of that doesn't prevent
cgroup from cleaning up its BPF state.

Second, only owners of bpf_link (those who created bpf_link in the first place
or obtained a new FD by opening bpf_link from BPF FS) can detach and/or update
it. This makes sure that no other process can accidentally remove/replace BPF
program.

This patch set also implements LINK_UPDATE sub-command, which allows to
replace bpf_link's underlying bpf_prog, similarly to BPF_F_REPLACE flag
behavior for direct bpf_prog cgroup attachment. Similarly to LINK_CREATE, it
is supposed to be generic command for different types of bpf_links.

  [0] https://lore.kernel.org/bpf/20200228223948.360936-1-andriin@fb.com/

v1->v2:
  - implement exclusive and overridable exclusive modes (Andrey Ignatov);
  - fix build for !CONFIG_CGROUP_BPF build;
  - add more selftests for non-multi mode and inter-operability;

Andrii Nakryiko (6):
  bpf: factor out cgroup storages operations
  bpf: factor out attach_type to prog_type mapping for attach/detach
  bpf: implement bpf_link-based cgroup BPF program attachment
  bpf: implement bpf_prog replacement for an active bpf_cgroup_link
  libbpf: add support for bpf_link-based cgroup attachment
  selftests/bpf: test FD-based cgroup attachment

 include/linux/bpf-cgroup.h                    |  40 +-
 include/linux/bpf.h                           |  10 +-
 include/uapi/linux/bpf.h                      |  22 +-
 kernel/bpf/cgroup.c                           | 518 ++++++++++++++----
 kernel/bpf/syscall.c                          | 267 +++++----
 kernel/cgroup/cgroup.c                        |  41 +-
 tools/include/uapi/linux/bpf.h                |  22 +-
 tools/lib/bpf/bpf.c                           |  35 ++
 tools/lib/bpf/bpf.h                           |  20 +
 tools/lib/bpf/libbpf.c                        |  49 ++
 tools/lib/bpf/libbpf.h                        |   9 +-
 tools/lib/bpf/libbpf.map                      |   4 +
 .../selftests/bpf/prog_tests/cgroup_link.c    | 235 ++++++++
 .../selftests/bpf/progs/test_cgroup_link.c    |  24 +
 14 files changed, 1067 insertions(+), 229 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_link.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cgroup_link.c

-- 
2.17.1

