Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 476FFD832F
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 00:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733240AbfJOWEY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 18:04:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8936 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733175AbfJOWEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 18:04:23 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9FM0cTL019126
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 15:04:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=jjMnzXVW5jk4CavRtoymuxKo6oU/CkH0AIhB5qK9jLs=;
 b=EFe+ah5EHM8/J5rw63C7+Rle0nODqXrnOXbPois458cTCQE3pzObQmsvgCAPi3n/oWM0
 hm+xkjFIoj88vB/QIxTbSyT4YTKgnYCZScsaMu0F1B9ZDNMrR5Wz1weukUm+pJnewOPv
 5cxDafLUeyQcDUJ8ycW8sRbXjrPCUEDzyfs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vnkjd0whp-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 15:04:22 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 15 Oct 2019 15:03:55 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 53C2A861987; Tue, 15 Oct 2019 15:03:54 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 0/6] Fix, clean up, and revamp selftests/bpf Makefile
Date:   Tue, 15 Oct 2019 15:03:46 -0700
Message-ID: <20191015220352.435884-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-15_08:2019-10-15,2019-10-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 spamscore=0 suspectscore=8 mlxlogscore=999 mlxscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 clxscore=1015
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910150189
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set extensively revamps selftests/bpf's Makefile to generalize test
runner concept and apply it uniformly to test_maps and test_progs test
runners, along with test_progs' few build "flavors", exercising various ways
to build BPF programs.

As we do that, we fix dependencies between various phases of test runners, and
simplify some one-off rules and dependencies currently present in Makefile.
test_progs' flavors are now built into root $(OUTPUT) directory and can be run
without any extra steps right from there. E.g., test_progs-alu32 is built and
is supposed to be run from $(OUTPUT). It will cd into alu32/ subdirectory to
load correct set of BPF object files (which are different from the ones built
for test_progs).

Outline:
- patch #1 teaches test_progs about flavor sub-directories;
- patch #2 fixes one of CO-RE tests to not depend strictly on process name;
- patch #3 changes test_maps's usage of map_tests/tests.h to be the same as
  test_progs' one;
- patch #4 adds convenient short `make test_progs`-like targets to build only
  individual tests, if necessary;
- patch #5 is a main patch in the series; it uses a bunch of make magic
  (mainly $(call) and $(eval)) to define test runner "skeleton" and apply it
  to 5 different test runners, lots more details in corresponding commit
  description;
- patch #6 does a bit of post-clean up for test_queue_map and test_stack_map
  BPF programs.

Andrii Nakryiko (6):
  selftest/bpf: teach test_progs to cd into subdir
  selftests/bpf: make CO-RE reloc test impartial to test_progs flavor
  selftests/bpf: switch test_maps to test_progs' test.h format
  selftests/bpf: add simple per-test targets to Makefile
  selftests/bpf: replace test_progs and test_maps w/ general rule
  selftests/bpf: move test_queue_stack_map.h into progs/ where it
    belongs

 tools/testing/selftests/bpf/.gitignore        |   6 +-
 tools/testing/selftests/bpf/Makefile          | 344 ++++++++++--------
 .../selftests/bpf/prog_tests/core_reloc.c     |   4 +-
 .../selftests/bpf/progs/core_reloc_types.h    |   2 +-
 .../bpf/progs/test_core_reloc_kernel.c        |   3 +-
 .../bpf/{ => progs}/test_queue_stack_map.h    |   0
 tools/testing/selftests/bpf/test_maps.c       |   8 +-
 tools/testing/selftests/bpf/test_progs.c      |  33 +-
 8 files changed, 242 insertions(+), 158 deletions(-)
 rename tools/testing/selftests/bpf/{ => progs}/test_queue_stack_map.h (100%)

-- 
2.17.1

