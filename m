Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8D5977B53
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 21:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388141AbfG0TB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 15:01:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64020 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388052AbfG0TB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 15:01:59 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6RIxZlr007075
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 12:01:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=jFojJCoFnhK9uHRbCMvQbyV+gQMZpNsx7e9lOHpLln8=;
 b=onDuyr4f4L+KdZYjCPSikjpFgHvTv6nNn/5VIHTW20vBocoRSNNKo971ay0OC5R7EViU
 hDjzxxOrjyKUjrdRCB/CGgdGQJt0IZjw6P5nf/tQtXX2dau8hS1L69oHN7z/VLpJWei8
 aBhraiCF8W+85IpArrsEj5njB5uosSX4v7M= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u0mbe94sb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 27 Jul 2019 12:01:57 -0700
Received: from mx-out.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Sat, 27 Jul 2019 12:01:56 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id BB06F861672; Sat, 27 Jul 2019 12:01:53 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <sdf@fomichev.me>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 0/9] Revamp test_progs as a test running framework
Date:   Sat, 27 Jul 2019 12:01:41 -0700
Message-ID: <20190727190150.649137-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-27_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=847 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907270237
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set makes a number of changes to test_progs selftest, which is
a collection of many other tests (and sometimes sub-tests as well), to provide
better testing experience and allow to start convering many individual test
programs under selftests/bpf into a single and convenient test runner.

Patch #1 fixes issue with Makefile, which makes prog_tests/test.h compiled as
a C code. This fix allows to change how test.h is generated, providing ability
to have more control on what and how tests are run.

Patch #2 changes how test.h is auto-generated, which allows to have test
definitions, instead of just running test functions. This gives ability to do
more complicated test run policies.

Patch #3 adds `-t <test-name>` and `-n <test-num>` selectors to run only
subset of tests.

Patch #4 changes libbpf_set_print() to return previously set print callback,
allowing to temporarily replace current print callback and then set it back.
This is necessary for some tests that want more control over libbpf logging.

Patch #5 sets up and takes over libbpf logging from individual tests to
test_prog runner, adding -vv verbosity to capture debug output from libbpf.
This is useful when debugging failing tests.

Patch #6 furthers test output management and buffers it by default, emitting
log output only if test fails. This give succinct and clean default test
output. It's possible to bypass this behavior with -v flag, which will turn
off test output buffering.

Patch #7 adds support for sub-tests. It also enhances -t and -n selectors to
both support ability to specify sub-test selectors, as well as enhancing
number selector to accept sets of test, instead of just individual test
number.

Patch #8 converts bpf_verif_scale.c test to use sub-test APIs.

Patch #9 converts send_signal.c tests to use sub-test APIs.

v1->v2:
  - drop libbpf_swap_print, instead return previous function from
    libbpf_set_print (Stanislav);

Andrii Nakryiko (9):
  selftests/bpf: prevent headers to be compiled as C code
  selftests/bpf: revamp test_progs to allow more control
  selftests/bpf: add test selectors by number and name to test_progs
  libbpf: return previous print callback from libbpf_set_print
  selftest/bpf: centralize libbpf logging management for test_progs
  selftests/bpf: abstract away test log output
  selftests/bpf: add sub-tests support for test_progs
  selftests/bpf: convert bpf_verif_scale.c to sub-tests API
  selftests/bpf: convert send_signal.c to use subtests

 tools/lib/bpf/libbpf.c                        |   5 +-
 tools/lib/bpf/libbpf.h                        |   2 +-
 tools/testing/selftests/bpf/Makefile          |  14 +-
 .../selftests/bpf/prog_tests/bpf_obj_id.c     |   6 +-
 .../bpf/prog_tests/bpf_verif_scale.c          |  90 +++--
 .../bpf/prog_tests/get_stack_raw_tp.c         |   4 +-
 .../selftests/bpf/prog_tests/l4lb_all.c       |   2 +-
 .../selftests/bpf/prog_tests/map_lock.c       |  10 +-
 .../bpf/prog_tests/reference_tracking.c       |  15 +-
 .../selftests/bpf/prog_tests/send_signal.c    |  17 +-
 .../selftests/bpf/prog_tests/spinlock.c       |   2 +-
 .../bpf/prog_tests/stacktrace_build_id.c      |   4 +-
 .../bpf/prog_tests/stacktrace_build_id_nmi.c  |   4 +-
 .../selftests/bpf/prog_tests/xdp_noinline.c   |   3 +-
 tools/testing/selftests/bpf/test_progs.c      | 373 +++++++++++++++++-
 tools/testing/selftests/bpf/test_progs.h      |  45 ++-
 16 files changed, 492 insertions(+), 104 deletions(-)

-- 
2.17.1

