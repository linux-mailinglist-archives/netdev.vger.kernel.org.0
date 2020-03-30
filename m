Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 432731972B0
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 05:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729019AbgC3DAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 23:00:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33780 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728202AbgC3DAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 23:00:10 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02U2tgZa027465
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 20:00:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=x1w7kJTwaILAzFlbawLpJBSDeVPOYok+WbgG5itbqsQ=;
 b=hB5jLc4kxh15tG/XFj4GRPj+dRBnZnXAq7OfodQG6E9xK7x3Ze21ZQ+sJYhrytMMYgcP
 HTziCiX54dp7aCvUeqVUSmyJ2vRIZMTJWg87E1QF9UrWeixv+uTbARdUs9lk3lJIi8x2
 um51En5Ct+aacxsSeegH0fN29RCQLTMXBRM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 302pqvurmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 20:00:09 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 29 Mar 2020 20:00:08 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C6FEF2EC3214; Sun, 29 Mar 2020 20:00:02 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <rdna@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 0/4] Add support for cgroup bpf_link
Date:   Sun, 29 Mar 2020 19:59:57 -0700
Message-ID: <20200330030001.2312810-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-29_10:2020-03-27,2020-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 mlxlogscore=997 malwarescore=0 spamscore=0 clxscore=1015 suspectscore=0
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003300026
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

bpf_link abstraction itself was formalized in [0] with justifications for why
its semantics is a good fit for attaching BPF programs of various types. This
patch set adds bpf_link-based BPF program attachment mechanism for cgroup BPF
programs.

Cgroup BPF link is semantically compatible with current BPF_F_ALLOW_MULTI
semantics of attaching cgroup BPF programs directly. Thus cgroup bpf_link can
co-exist with legacy BPF program multi-attachment.

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

v2->v3:
  - revert back to just MULTI mode (Alexei);
  - fix tinyconfig compilation warning (kbuild test robot);

v1->v2:
  - implement exclusive and overridable exclusive modes (Andrey Ignatov);
  - fix build for !CONFIG_CGROUP_BPF build;
  - add more selftests for non-multi mode and inter-operability;


Andrii Nakryiko (4):
  bpf: implement bpf_link-based cgroup BPF program attachment
  bpf: implement bpf_prog replacement for an active bpf_cgroup_link
  libbpf: add support for bpf_link-based cgroup attachment
  selftests/bpf: test FD-based cgroup attachment

 include/linux/bpf-cgroup.h                    |  41 +-
 include/linux/bpf.h                           |  10 +-
 include/uapi/linux/bpf.h                      |  22 +-
 kernel/bpf/cgroup.c                           | 395 ++++++++++++++----
 kernel/bpf/syscall.c                          | 113 ++++-
 kernel/cgroup/cgroup.c                        |  41 +-
 tools/include/uapi/linux/bpf.h                |  22 +-
 tools/lib/bpf/bpf.c                           |  34 ++
 tools/lib/bpf/bpf.h                           |  19 +
 tools/lib/bpf/libbpf.c                        |  46 ++
 tools/lib/bpf/libbpf.h                        |   8 +-
 tools/lib/bpf/libbpf.map                      |   4 +
 .../selftests/bpf/prog_tests/cgroup_link.c    | 244 +++++++++++
 .../selftests/bpf/progs/test_cgroup_link.c    |  24 ++
 14 files changed, 924 insertions(+), 99 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_link.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_cgroup_link.c

-- 
2.17.1

