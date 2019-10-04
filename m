Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63E4ACC5F9
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 00:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729528AbfJDWkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 18:40:47 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35886 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728172AbfJDWkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 18:40:47 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x94MdEAd024851
        for <netdev@vger.kernel.org>; Fri, 4 Oct 2019 15:40:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=+mMPVu1/CBaOPtbKIohA6WHuTjr8vdASGx8MvW25Y4U=;
 b=IZNo3OKp/7OQ+hNT+DKRj1v/kMrm8ZgOqvidkLkt+oGIveq37veL/VPsdXwPjeMHVuCZ
 SDc/Mhzpq6MJ3n/N9rfm7qFCGqm3wrW2XavLxtPVEem2EDjyxDFRWALIBjlxwOrIVzjG
 JqLS6w4zXjeni5AUcoScV8UDajaP5FvrFxQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ve79tac2r-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 15:40:45 -0700
Received: from 2401:db00:30:6007:face:0:1:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 4 Oct 2019 15:40:40 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 561F78617D0; Fri,  4 Oct 2019 15:40:39 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 0/4] Add new-style bpf_object__open APIs
Date:   Fri, 4 Oct 2019 15:40:33 -0700
Message-ID: <20191004224037.1625049-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-04_13:2019-10-03,2019-10-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 mlxscore=0
 impostorscore=0 phishscore=0 suspectscore=8 spamscore=0 malwarescore=0
 clxscore=1015 mlxlogscore=999 priorityscore=1501 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910040191
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_object__open_file() and bpf_object__open_mem() APIs that use a new
approach to providing future-proof non-ABI-breaking API changes. It relies on
APIs accepting optional self-describing "opts" struct, containing its own
size, filled out and provided by potentially outdated (as well as
newer-than-libbpf) user application. A set of internal helper macros
(OPTS_VALID, OPTS_HAS, and OPTS_GET) streamline and simplify a graceful
handling forward and backward compatibility for user applications dynamically
linked against different versions of libbpf shared library.

Users of libbpf are provided with convenience macro LIBBPF_OPTS that takes
care of populating correct structure size and zero-initializes options struct,
which helps avoid obscure issues of unitialized padding. Uninitialized padding
in a struct might turn into garbage-populated new fields understood by future
versions of libbpf.

Patch #1 removes enforcement of kern_version in libbpf and always populates
correct one on behalf of users.
Patch #2 defines necessary infrastructure for options and two new open APIs
relying on it.
Patch #3 fixes bug in bpf_object__name().
Patch #4 switches two of test_progs' tests to use new APIs as a validation
that they work as expected.

v2->v3:
- fix LIBBPF_OPTS() to ensure zero-initialization of padded bytes;
- pass through name override and relaxed maps flag for open_file() (Toke);
- fix bpf_object__name() to actually return object name;
- don't bother parsing and verifying version section (John);

v1->v2:
- use better approach for tracking last field in opts struct;
- convert few tests to new APIs for validation;
- fix bug with using offsetof(last_field) instead of offsetofend(last_field).

Andrii Nakryiko (4):
  libbpf: stop enforcing kern_version, populate it for users
  libbpf: add bpf_object__open_{file,mem} w/ extensible opts
  libbpf: fix bpf_object__name() to actually return object name
  selftests/bpf: switch tests to new bpf_object__open_{file,mem}() APIs

 tools/lib/bpf/libbpf.c                        | 183 +++++++++---------
 tools/lib/bpf/libbpf.h                        |  48 ++++-
 tools/lib/bpf/libbpf.map                      |   3 +
 tools/lib/bpf/libbpf_internal.h               |  32 +++
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../selftests/bpf/prog_tests/attach_probe.c   |  49 ++++-
 .../bpf/prog_tests/reference_tracking.c       |  16 +-
 .../selftests/bpf/progs/test_attach_probe.c   |   1 -
 .../bpf/progs/test_get_stack_rawtp.c          |   1 -
 .../selftests/bpf/progs/test_perf_buffer.c    |   1 -
 .../selftests/bpf/progs/test_stacktrace_map.c |   1 -
 11 files changed, 226 insertions(+), 111 deletions(-)

-- 
2.17.1

