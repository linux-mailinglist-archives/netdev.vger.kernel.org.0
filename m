Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB6DED8672
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 05:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389339AbfJPD3z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 23:29:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22156 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389257AbfJPD3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 23:29:55 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x9G3OlrH022673
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 20:29:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=Ihp6gM1Ne4D24tl6A+Pobs0oKjBtxXhU32mEmLbnM8g=;
 b=QhOFeYEshLV2WoBjnQ07xxz/WPs9LlZ1qIs8s+OILpA42pp5risP2rMXRXGZFErDCIcr
 ddweI5yZkTqyObLDK9Z1xcK19nsnqqd0Qj5YfCqWdQ7F8CnsvIAfzpu+kjS/7Z+xbmrS
 g8AQ+Kb58/jVIeKZ+FTC2JJVFwul69hfdu4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2vn6m8debc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 20:29:53 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 15 Oct 2019 20:29:52 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id F41DB861998; Tue, 15 Oct 2019 20:29:51 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 0/6] Fix, clean up, and revamp selftests/bpf Makefile
Date:   Tue, 15 Oct 2019 20:29:43 -0700
Message-ID: <20191016032949.1445888-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-16_01:2019-10-15,2019-10-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015 suspectscore=8
 lowpriorityscore=0 spamscore=0 priorityscore=1501 malwarescore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910160029
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
  to 4 different test runners, lots more details in corresponding commit
  description;
- patch #6 does a bit of post-clean up for test_queue_map and test_stack_map
  BPF programs.

v1->v2:
- drop test_progs-native causing compilation failures due to
  __builtin_preserve_field_access, add back test_xdp.o override, which will
  now emit rule re-definition warning.


Andrii Nakryiko (6):
  selftests/bpf: teach test_progs to cd into subdir
  selftests/bpf: make CO-RE reloc test impartial to test_progs flavor
  selftests/bpf: switch test_maps to test_progs' test.h format
  selftests/bpf: add simple per-test targets to Makefile
  selftests/bpf: replace test_progs and test_maps w/ general rule
  selftests/bpf: move test_queue_stack_map.h into progs/ where it
    belongs

 tools/testing/selftests/bpf/.gitignore        |   5 +-
 tools/testing/selftests/bpf/Makefile          | 336 ++++++++++--------
 .../selftests/bpf/prog_tests/core_reloc.c     |   4 +-
 .../selftests/bpf/progs/core_reloc_types.h    |   2 +-
 .../bpf/progs/test_core_reloc_kernel.c        |   3 +-
 .../bpf/{ => progs}/test_queue_stack_map.h    |   0
 tools/testing/selftests/bpf/test_maps.c       |   8 +-
 tools/testing/selftests/bpf/test_progs.c      |  33 +-
 8 files changed, 237 insertions(+), 154 deletions(-)
 rename tools/testing/selftests/bpf/{ => progs}/test_queue_stack_map.h (100%)

-- 
2.17.1

