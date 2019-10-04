Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2787FCB363
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 05:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731296AbfJDDBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 23:01:04 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46046 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730699AbfJDDBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 23:01:03 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x942Nt8F015358
        for <netdev@vger.kernel.org>; Thu, 3 Oct 2019 20:01:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=ry7uGk2pvEOmHIRzfhCW4AeNGhraKP1gsnpmqAu7Hq4=;
 b=UCVq6wbgylYQ2hFxIZUZC4K7m38PGryyezozk04GPN5RFkztSo9YwQJzewJlp2nfqvYS
 hnYn1pyE0TJUyXO5RIiQwExXYvzEFH/P/2fQ2WNSja7QCCGhwyqMtMYozNY0dKsxxvsC
 W4M4ZY3TiIrhKXyQBSFbTfaH05LcSM6Hkbs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vdjr2k2d0-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 20:01:02 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 3 Oct 2019 20:01:01 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 1313A861895; Thu,  3 Oct 2019 20:01:00 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 0/2] Add new-style bpf_object__open APIs
Date:   Thu, 3 Oct 2019 20:00:56 -0700
Message-ID: <20191004030058.2248514-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-04_01:2019-10-03,2019-10-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 mlxlogscore=999 priorityscore=1501 adultscore=0 spamscore=0
 clxscore=1015 mlxscore=0 suspectscore=8 lowpriorityscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910040018
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

Andrii Nakryiko (2):
  libbpf: stop enforcing kern_version, populate it for users
  libbpf: add bpf_object__open_{file,mem} w/ extensible opts

 tools/lib/bpf/libbpf.c                        | 128 +++++++++---------
 tools/lib/bpf/libbpf.h                        |  37 ++++-
 tools/lib/bpf/libbpf.map                      |   3 +
 tools/lib/bpf/libbpf_internal.h               |  31 +++++
 .../selftests/bpf/progs/test_attach_probe.c   |   1 -
 .../bpf/progs/test_get_stack_rawtp.c          |   1 -
 .../selftests/bpf/progs/test_perf_buffer.c    |   1 -
 .../selftests/bpf/progs/test_stacktrace_map.c |   1 -
 8 files changed, 131 insertions(+), 72 deletions(-)

-- 
2.17.1

