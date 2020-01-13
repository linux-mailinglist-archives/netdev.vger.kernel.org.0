Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEF8138C5C
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 08:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728833AbgAMHb5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 02:31:57 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:56352 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728824AbgAMHb5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 02:31:57 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00D7Ue8a008138
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 23:31:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=3ZuO5EhurhLFcYIPSjVf/WUd5KQLbelHpDdICp9YuXw=;
 b=kkTvqbrBQVGIbDkZ2JYwO49gSgjUYSyibOHepIT8bi5HHLjCs914Aj/kbyfpF46nFtYg
 BctqAW1pbAVWmhdq9PTdSjDrCw7XTVy8AWnN3tpSrIS6DU2Y3jQJePE1IxycwjOigTuU
 VJwWcMEjqwfz5QwqT1SMw4BXt6QyxhGj0bc= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xfydnb4va-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 12 Jan 2020 23:31:55 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sun, 12 Jan 2020 23:31:55 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 475422EC2329; Sun, 12 Jan 2020 23:31:48 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 0/6] Implement runqslower BCC tool with BPF CO-RE
Date:   Sun, 12 Jan 2020 23:31:37 -0800
Message-ID: <20200113073143.1779940-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-13_01:2020-01-13,2020-01-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0
 mlxlogscore=999 spamscore=0 impostorscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 clxscore=1015 priorityscore=1501 malwarescore=0 phishscore=0
 suspectscore=9 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001130063
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Based on recent BPF CO-RE, tp_btf, and BPF skeleton changes, re-implement
BCC-based runqslower tool as a portable pre-compiled BPF CO-RE-based tool.
Make sure it's built as part of selftests to ensure it doesn't bit rot.

As part of this patch set, augment `format c` output of `bpftool btf dump`
sub-command with applying `preserve_access_index` attribute to all structs and
unions. This makes all such structs and unions automatically relocatable under
BPF CO-RE, which improves user experience of writing TRACING programs with
direct kernel memory read access.

Also, further clean up selftest/bpf Makefile output and make it conforming to
libbpf and bpftool succinct output format.

v1->v2:
- build in-tree bpftool for runqslower (Yonghong);
- drop `format core` and augment `format c` instead (Alexei);
- move runqslower under tools/bpf (Daniel).

Andrii Nakryiko (6):
  tools: sync uapi/linux/if_link.h
  libbpf: clean up bpf_helper_defs.h generation output
  selftests/bpf: conform selftests/bpf Makefile output to libbpf and
    bpftool
  bpftool: apply preserve_access_index attribute to all types in BTF
    dump
  tools/bpf: add runqslower tool to tools/bpf
  selftests/bpf: build runqslower from selftests

 scripts/bpf_helpers_doc.py            |   2 -
 tools/bpf/Makefile                    |  20 ++-
 tools/bpf/bpftool/btf.c               |   8 ++
 tools/bpf/runqslower/.gitignore       |   1 +
 tools/bpf/runqslower/Makefile         |  80 +++++++++++
 tools/bpf/runqslower/runqslower.bpf.c | 100 ++++++++++++++
 tools/bpf/runqslower/runqslower.c     | 187 ++++++++++++++++++++++++++
 tools/bpf/runqslower/runqslower.h     |  13 ++
 tools/include/uapi/linux/if_link.h    |   1 +
 tools/lib/bpf/Makefile                |   2 +-
 tools/testing/selftests/bpf/Makefile  |  54 ++++----
 11 files changed, 437 insertions(+), 31 deletions(-)
 create mode 100644 tools/bpf/runqslower/.gitignore
 create mode 100644 tools/bpf/runqslower/Makefile
 create mode 100644 tools/bpf/runqslower/runqslower.bpf.c
 create mode 100644 tools/bpf/runqslower/runqslower.c
 create mode 100644 tools/bpf/runqslower/runqslower.h

-- 
2.17.1

