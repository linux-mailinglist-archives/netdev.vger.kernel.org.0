Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7F8174212
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 23:40:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726527AbgB1Wj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 17:39:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9836 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725957AbgB1Wj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 17:39:59 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01SMYf9J030950
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 14:39:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=zDehWwikSQaXUxo0aRpmXyOUwQq7YSORUYoa4prAgW8=;
 b=YUx2BW3Z8nPBOthq8Z1g/eePwLr8KcC7zgOVdTLEy8lYkPz4qivxHOKHky5xGBcDc3we
 GS0sMZJoDufA35+cS3D1oydbGaddEcNQ3vqsXgZo5n+v5wlNRuKLtgBHWQ8QIV7ObtaP
 V5R0X55Vka05CrZp5fHLieL48iSiDPjdxvw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yepvgwvuy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 14:39:57 -0800
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 28 Feb 2020 14:39:57 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id EF1882EC2D20; Fri, 28 Feb 2020 14:39:50 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/3] Introduce pinnable bpf_link kernel abstraction
Date:   Fri, 28 Feb 2020 14:39:45 -0800
Message-ID: <20200228223948.360936-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-28_08:2020-02-28,2020-02-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=8 mlxscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 mlxlogscore=583
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002280162
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series adds bpf_link abstraction, analogous to libbpf's already
existing bpf_link abstraction. This formalizes and makes more uniform existing
bpf_link-like BPF program link (attachment) types (raw tracepoint and tracing
links), which are FD-based objects that are automatically detached when last
file reference is closed. These types of BPF program links are switched to
using bpf_link framework.

FD-based bpf_link approach provides great safety guarantees, by ensuring there
is not going to be an abandoned BPF program attached, if user process suddenly
exits or forgets to clean up after itself. This is especially important in
production environment and is what all the recent new BPF link types followed.

One of the previously existing  inconveniences of FD-based approach, though,
was the scenario in which user process wants to install BPF link and exit, but
let attached BPF program run. Now, with bpf_link abstraction in place, it's
easy to support pinning links in BPF FS, which is done as part of the same
patch #1. This allows FD-based BPF program links to survive exit of a user
process and original file descriptor being closed, by creating an file entry
in BPF FS. This provides great safety by default, with simple way to opt out
for cases where it's needed.

Corresponding libbpf APIs are added in the same patch set, as well as
selftests for this functionality.

Other types of BPF program attachments (XDP, cgroup, perf_event, etc) are
going to be converted in subsequent patches to follow similar approach.

Andrii Nakryiko (3):
  bpf: introduce pinnable bpf_link abstraction
  libbpf: add bpf_link pinning/unpinning
  selftests/bpf: add link pinning selftests

 include/linux/bpf.h                           |  13 ++
 kernel/bpf/inode.c                            |  42 +++-
 kernel/bpf/syscall.c                          | 209 +++++++++++++++---
 tools/lib/bpf/libbpf.c                        | 131 ++++++++---
 tools/lib/bpf/libbpf.h                        |   5 +
 tools/lib/bpf/libbpf.map                      |   5 +
 .../selftests/bpf/prog_tests/link_pinning.c   | 105 +++++++++
 .../selftests/bpf/progs/test_link_pinning.c   |  25 +++
 8 files changed, 470 insertions(+), 65 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/link_pinning.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_link_pinning.c

-- 
2.17.1

