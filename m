Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1695A928
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 07:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726719AbfF2FxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 01:53:16 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:43910 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726156AbfF2FxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 01:53:15 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5T5q2Eq003419
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 22:53:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=1ilmoBs7hcwSPLB7uN9c79wtqYPeISJvq6Wrwl45EgI=;
 b=k30i4tcUoxIkBVNp0FysuTEYEapL6o/+ocdMc/qSzS1nVH/t9o58cT2uRkkTNwoZEkQA
 9f72+hdCjc3QipTRgLz8riM4O7PlW4vdO9RdpkreMRh5j74docnSEeaECdcoMiWkH//s
 BF2TqdssMnTRYREUrbM4lR6XH0eza3m/Lw0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0b-00082601.pphosted.com with ESMTP id 2tdmv3jg5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 22:53:14 -0700
Received: from mx-out.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 28 Jun 2019 22:53:13 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id B6B7186145A; Fri, 28 Jun 2019 22:53:11 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <andrii.nakryiko@gmail.com>, <ast@fb.com>, <daniel@iogearbox.net>,
        <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-team@fb.com>, <songliubraving@fb.com>
CC:     Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v3 bpf-next 0/4] libbpf: add perf buffer abstraction and API
Date:   Fri, 28 Jun 2019 22:53:05 -0700
Message-ID: <20190629055309.1594755-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-29_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906290073
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

v2->v3:
- added perf_buffer__new_raw for more low-level control;
- converted bpftool map event_pipe to new API (Daniel);
- fixed bug with error handling in create_maps (Song);

v1->v2:
- add auto-sizing of PERF_EVENT_ARRAY maps;

Andrii Nakryiko (4):
  libbpf: add perf buffer API
  libbpf: auto-set PERF_EVENT_ARRAY size to number of CPUs
  selftests/bpf: test perf buffer API
  tools/bpftool: switch map event_pipe to libbpf's perf_buffer

 tools/bpf/bpftool/map_perf_ring.c             | 207 +++------
 tools/lib/bpf/libbpf.c                        | 397 +++++++++++++++++-
 tools/lib/bpf/libbpf.h                        |  49 +++
 tools/lib/bpf/libbpf.map                      |   4 +
 .../selftests/bpf/prog_tests/perf_buffer.c    |  94 +++++
 .../selftests/bpf/progs/test_perf_buffer.c    |  29 ++
 6 files changed, 634 insertions(+), 146 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/perf_buffer.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_perf_buffer.c

-- 
2.17.1

