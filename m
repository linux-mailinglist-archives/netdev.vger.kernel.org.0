Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 759CBD6C2D
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 01:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbfJNXtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 19:49:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13128 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726583AbfJNXtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 19:49:35 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9ENkBJZ010896
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 16:49:34 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=/Y34Gl4NO/thxGDBO77tFvS+J+fXMhOvfAghB3O5lhA=;
 b=BXAAI1oNcms563bnohUX8Rj1omuApcS9dC69onYmdZWcr44Gn+woDuo+r5EsHI9XxZfn
 u1PDxP7MIWJcOUF5CEHEt/fO2eO3kf6pl8zUMp8ti1JZbIYW3IJjjtMV3e9P3KrKDB/M
 ZrjaY87WZK8ycfetpisCYlSRITpqzzWB5XQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vkxhc70wu-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 16:49:33 -0700
Received: from 2401:db00:30:6012:face:0:17:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 14 Oct 2019 16:49:32 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 791518618F6; Mon, 14 Oct 2019 16:49:30 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH bpf-next 0/5] Add CO-RE support for field existence relos
Date:   Mon, 14 Oct 2019 16:49:23 -0700
Message-ID: <20191014234928.561043-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-14_11:2019-10-11,2019-10-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 adultscore=0 priorityscore=1501 malwarescore=0 bulkscore=0 impostorscore=0
 phishscore=0 mlxscore=0 clxscore=1015 mlxlogscore=937 spamscore=0
 suspectscore=8 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910140199
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set generalizes libbpf's CO-RE relocation support. It not supports field existence relocations, in addition to existing field's byte offset relocation.

This patch set upgrades the format of .BTF.ext's relocation record to match
latest Clang's format (12 -> 16 bytes). This is not a breaking change, as the
previous format hasn't been released yet as part of official Clang version
release.

Andrii Nakryiko (5):
  libbpf: update BTF reloc support to latest Clang format
  libbpf: refactor bpf_object__open APIs to use common opts
  libbpf: add support for field existance CO-RE relocation
  libbpf: add BPF-side definitions of supported field relocation kinds
  selftests/bpf: add field existence CO-RE relocs tests

 tools/lib/bpf/bpf_core_read.h                 |  12 ++
 tools/lib/bpf/btf.c                           |  16 +-
 tools/lib/bpf/btf.h                           |   4 +-
 tools/lib/bpf/libbpf.c                        | 169 +++++++++++-------
 tools/lib/bpf/libbpf.h                        |   4 +-
 tools/lib/bpf/libbpf_internal.h               |  25 ++-
 .../selftests/bpf/prog_tests/core_reloc.c     |  76 +++++++-
 .../bpf/progs/btf__core_reloc_existence.c     |   3 +
 ...ore_reloc_existence___err_wrong_arr_kind.c |   3 +
 ...loc_existence___err_wrong_arr_value_type.c |   3 +
 ...ore_reloc_existence___err_wrong_int_kind.c |   3 +
 ..._core_reloc_existence___err_wrong_int_sz.c |   3 +
 ...ore_reloc_existence___err_wrong_int_type.c |   3 +
 ..._reloc_existence___err_wrong_struct_type.c |   3 +
 .../btf__core_reloc_existence___minimal.c     |   3 +
 .../selftests/bpf/progs/core_reloc_types.h    |  56 ++++++
 .../bpf/progs/test_core_reloc_existence.c     |  79 ++++++++
 17 files changed, 381 insertions(+), 84 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_kind.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_arr_value_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_kind.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_sz.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_int_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___err_wrong_struct_type.c
 create mode 100644 tools/testing/selftests/bpf/progs/btf__core_reloc_existence___minimal.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_reloc_existence.c

-- 
2.17.1

