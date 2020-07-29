Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 938222327D1
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 01:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727969AbgG2XF1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 19:05:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56708 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726876AbgG2XF1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 19:05:27 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06TN2HIL031472
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 16:05:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=/hhCF6MZJuvinSbI9wmwXOWE2F//8gxgoNrpXt19vKk=;
 b=lA3URE0WUwTCDDScxSMzfq/oQXlHRMqoSwJmFXq8XRYDC5tRdvfTgrMPeJuKeJT+362i
 TVjlrWBk5rJxWNpHPPyPGtGJBsW6ad77m3XpYq2dYKIhIdH9K+BL4fR8HgUX7t+aanSc
 wK0n0Ft2DYpogaiXWQ22uXy+KSePeUOt1sY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32juqwnvny-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 16:05:26 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 29 Jul 2020 16:05:26 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 731822EC4E37; Wed, 29 Jul 2020 16:05:23 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/5] BPF link force-detach support
Date:   Wed, 29 Jul 2020 16:05:15 -0700
Message-ID: <20200729230520.693207-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-29_17:2020-07-29,2020-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 malwarescore=0 phishscore=0 clxscore=1015 adultscore=0 impostorscore=0
 mlxscore=0 bulkscore=0 priorityscore=1501 lowpriorityscore=0
 mlxlogscore=693 suspectscore=8 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007290156
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

Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

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
 tools/bpf/bpftool/link.c                      | 35 ++++++++++++-
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
 20 files changed, 206 insertions(+), 34 deletions(-)

--=20
2.24.1

