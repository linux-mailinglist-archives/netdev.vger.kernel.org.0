Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B01F1184D85
	for <lists+netdev@lfdr.de>; Fri, 13 Mar 2020 18:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgCMRX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 13:23:57 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51378 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726622AbgCMRX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 13:23:57 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02DHB48a023328
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 10:23:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=gI52US9aXmz37kJdgNeU0syNsz/V0ALuBiLanz7q7LQ=;
 b=bUhWFzjYFGL6YCH1KqC18te3O+KVpxaeKWjPrG2uhGwtGqd+aCIJnGlJ5wg8CKuLgGai
 mJxK5T7XJSCamIawzpmzuEBr/775fTgW4CMycMcsVMPcqKtB2KbQl4jEbYjZKGJwtJnf
 Fx3IDtHbZ6n3u7/DlttMecv1Xnq69AoeAHE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2yqt80w7kj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 10:23:56 -0700
Received: from intmgw002.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 13 Mar 2020 10:23:54 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 969512EC2DE4; Fri, 13 Mar 2020 10:23:49 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/4] CO-RE candidate matching fix and tracing test
Date:   Fri, 13 Mar 2020 10:23:32 -0700
Message-ID: <20200313172336.1879637-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-13_06:2020-03-12,2020-03-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 malwarescore=0 clxscore=1015 adultscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003130085
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set fixes bug in CO-RE relocation candidate finding logic, which
currently allows matching against forward declarations, functions, and other
named types, even though it makes no sense to even attempt. As part of
verifying the fix, add test using vmlinux.h with preserve_access_index
attribute and utilizing struct pt_regs heavily to trace nanosleep syscall
using 5 different types of tracing BPF programs.

This test also demonstrated problems using struct pt_regs in syscall
tracepoints and required a new set of macro, which were added in patch #3 into
bpf_tracing.h.

Patch #1 fixes annoying issue with selftest failure messages being out of
sync.

v1->v2:
- drop unused handle__probed() function (Martin).

Andrii Nakryiko (4):
  selftests/bpf: ensure consistent test failure output
  libbpf: ignore incompatible types with matching name during CO-RE
    relocation
  libbpf: provide CO-RE variants of PT_REGS macros
  selftests/bpf: add vmlinux.h selftest exercising tracing of syscalls

 tools/lib/bpf/bpf_tracing.h                   | 103 ++++++++++++++++++
 tools/lib/bpf/libbpf.c                        |   4 +
 tools/testing/selftests/bpf/Makefile          |   7 +-
 .../selftests/bpf/prog_tests/vmlinux.c        |  43 ++++++++
 .../selftests/bpf/progs/test_vmlinux.c        |  84 ++++++++++++++
 tools/testing/selftests/bpf/test_progs.c      |  10 +-
 tools/testing/selftests/bpf/test_progs.h      |   8 +-
 7 files changed, 249 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/vmlinux.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_vmlinux.c

-- 
2.17.1

