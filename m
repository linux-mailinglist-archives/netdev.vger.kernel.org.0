Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B79E0772D1
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 22:37:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfGZUhz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 16:37:55 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54412 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726305AbfGZUhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 16:37:55 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x6QKT1fw013550
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 13:37:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=VdZqT49/ay0o0Kgz1NPOxtjgssHjlm3z8/vB2LgHSmw=;
 b=PzVBHO9xmcBAoWec8s8GNCK3uXsT+0ULWKqLUkaZgKojpaqSxDhmhZPwZmdbB2G4XJYz
 rwRkhA+fHH5YTPmOXwm+wCW0jx3acA5G1vlwxdR6KCr4T/bI3nW4uNhtr54f9Mp+XUei
 4/UI8BoydZ/p03ZKAbz1NaIh6KEe/dAvxtI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2u04gfs1m1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 26 Jul 2019 13:37:53 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 26 Jul 2019 13:37:53 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id BA80D861663; Fri, 26 Jul 2019 13:37:52 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 0/9] Revamp test_progs as a test running framework
Date:   Fri, 26 Jul 2019 13:37:38 -0700
Message-ID: <20190726203747.1124677-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-26_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=8 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=930 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907260234
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

Patch #4 adds libbpf_swap_print() API allowing to temporarily replace current
print callback and then set it back. This is necessary for some tests that
want more control over libbpf logging.

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

Andrii Nakryiko (9):
  selftests/bpf: prevent headers to be compiled as C code
  selftests/bpf: revamp test_progs to allow more control
  selftests/bpf: add test selectors by number and name to test_progs
  libbpf: add libbpf_swap_print to get previous print func
  selftest/bpf: centralize libbpf logging management for test_progs
  selftests/bpf: abstract away test log output
  selftests/bpf: add sub-tests support for test_progs
  selftests/bpf: convert bpf_verif_scale.c to sub-tests API
  selftests/bpf: convert send_signal.c to use subtests

 tools/lib/bpf/libbpf.c                        |   8 +
 tools/lib/bpf/libbpf.h                        |   1 +
 tools/lib/bpf/libbpf.map                      |   5 +
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
 17 files changed, 501 insertions(+), 102 deletions(-)

-- 
2.17.1

