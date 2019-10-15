Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D03D7EFE
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 20:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfJOS2w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 14:28:52 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1388 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725871AbfJOS2w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 14:28:52 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9FIPhQF001828
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 11:28:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=LpJEAafYbc9AMPAzDfkgZaOCbYM7F4hhEQYX2fv0mQ4=;
 b=azHl25e0CnjQ8KfORcJXMdL6sozGSNpuP8C6bp96WMQtq66CyQntyWEHv8sx215dtP1U
 G1gQijmzlRcNkCru2BzrZUMble0iG4WUSTIr+7dmii8xy8Mf70q3apToiLs+0vQ1kzaA
 vyibHGZZQT1a93mtLG9/Y/h3wwesrf9DwKA= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vkxgeu9gv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 15 Oct 2019 11:28:51 -0700
Received: from 2401:db00:30:600c:face:0:1f:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 15 Oct 2019 11:28:50 -0700
Received: by dev101.prn2.facebook.com (Postfix, from userid 137359)
        id 57526861983; Tue, 15 Oct 2019 11:28:50 -0700 (PDT)
Smtp-Origin-Hostprefix: dev
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: dev101.prn2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: prn2c23
Subject: [PATCH v2 bpf-next 0/5] Add CO-RE support for field existence relos
Date:   Tue, 15 Oct 2019 11:28:44 -0700
Message-ID: <20191015182849.3922287-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-15_06:2019-10-15,2019-10-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 lowpriorityscore=0 spamscore=0 malwarescore=0 bulkscore=0 mlxscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 adultscore=0 impostorscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910150156
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set generalizes libbpf's CO-RE relocation support. In addition to
existing field's byte offset relocation, libbpf now supports field existence
relocations, which are emitted by Clang when using
__builtin_preserve_field_info(<field>, BPF_FIELD_EXISTS). A convenience
bpf_core_field_exists() macro is added to bpf_core_read.h BPF-side header,
along the bpf_field_info_kind enum containing currently supported types of
field information libbpf supports. This list will grow as libbpf gains support
for other relo kinds.

This patch set upgrades the format of .BTF.ext's relocation record to match
latest Clang's format (12 -> 16 bytes). This is not a breaking change, as the
previous format hasn't been released yet as part of official Clang version
release.

v1->v2:
- unify bpf_field_info_kind enum and naming changes (Alexei);
- added bpf_core_field_exists() to bpf_core_read.h.

Andrii Nakryiko (5):
  libbpf: update BTF reloc support to latest Clang format
  libbpf: refactor bpf_object__open APIs to use common opts
  libbpf: add support for field existance CO-RE relocation
  libbpf: add BPF-side definitions of supported field relocation kinds
  selftests/bpf: add field existence CO-RE relocs tests

 tools/lib/bpf/bpf_core_read.h                 |  24 ++-
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
 17 files changed, 392 insertions(+), 85 deletions(-)
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

