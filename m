Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC7A61290
	for <lists+netdev@lfdr.de>; Sat,  6 Jul 2019 20:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfGFSGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jul 2019 14:06:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17274 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726983AbfGFSGg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jul 2019 14:06:36 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x66I3M7B029691
        for <netdev@vger.kernel.org>; Sat, 6 Jul 2019 11:06:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=qqmpWc7ks1QPuHnwMRNuDTRQOIx5n88NQxQfMfMn/5I=;
 b=S2jCScYCJXSEB0iIv+PXWW1IO6fabSh4yotP8xm4n4YcQWAuQEIZVEm58QExaly5tYX+
 Rp3EYAPgJ3XDx5mzYV+yaafkTkPPPViRlnXXyz6gN+sCwzHsiEoLHWIIefvatdo3cjUE
 /GZU5YBnC7cyIsHkcL1+1IX69msR60Zi2VY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tjrrah58c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 06 Jul 2019 11:06:35 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 6 Jul 2019 11:06:32 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id D9BAC86170E; Sat,  6 Jul 2019 11:06:28 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <bpf@vger.kernel.org>,
        <netdev@vger.kernel.org>, <ast@fb.com>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v7 bpf-next 0/5] libbpf: add perf buffer abstraction and API
Date:   Sat, 6 Jul 2019 11:06:23 -0700
Message-ID: <20190706180628.3919653-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-06_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907060240
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset adds a high-level API for setting up and polling perf buffers
associated with BPF_MAP_TYPE_PERF_EVENT_ARRAY map. Details of APIs are
described in corresponding commit.

Patch #1 adds a set of APIs to set up and work with perf buffer.
Patch #2 enhances libbpf to support auto-setting PERF_EVENT_ARRAY map size.
Patch #3 adds test.
Patch #4 converts bpftool map event_pipe to new API.
Patch #5 updates README to mention perf_buffer_ prefix.

v6->v7:
- __x64_ syscall prefix (Yonghong);
v5->v6:
- fix C99 for loop variable initialization usage (Yonghong);
v4->v5:
- initialize perf_buffer_raw_opts in bpftool map event_pipe (Jakub);
- add perf_buffer_ to README;
v3->v4:
- fixed bpftool event_pipe cmd error handling (Jakub);
v2->v3:
- added perf_buffer__new_raw for more low-level control;
- converted bpftool map event_pipe to new API (Daniel);
- fixed bug with error handling in create_maps (Song);
v1->v2:
- add auto-sizing of PERF_EVENT_ARRAY maps;

Andrii Nakryiko (5):
  libbpf: add perf buffer API
  libbpf: auto-set PERF_EVENT_ARRAY size to number of CPUs
  selftests/bpf: test perf buffer API
  tools/bpftool: switch map event_pipe to libbpf's perf_buffer
  libbpf: add perf_buffer_ prefix to README

 tools/bpf/bpftool/map_perf_ring.c             | 201 +++------
 tools/lib/bpf/README.rst                      |   3 +-
 tools/lib/bpf/libbpf.c                        | 397 +++++++++++++++++-
 tools/lib/bpf/libbpf.h                        |  49 +++
 tools/lib/bpf/libbpf.map                      |   4 +
 .../selftests/bpf/prog_tests/perf_buffer.c    | 100 +++++
 .../selftests/bpf/progs/test_perf_buffer.c    |  25 ++
 7 files changed, 634 insertions(+), 145 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/perf_buffer.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_perf_buffer.c

-- 
2.17.1

