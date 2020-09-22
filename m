Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3169273BD5
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 09:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbgIVH2u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 03:28:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58306 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729748AbgIVH2u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 03:28:50 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08M6xNAJ024839
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:04:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=/fx4Yk9egZlmgSZ1F5w/+EHqLwnISXP0lx6/9pDfrjw=;
 b=hQ0AHYXYXnRRpc2NeneU1tYKHKvgEruTlx2oNzt3LowsJO64NWLLgvCrzSZVTpTzmA0j
 OfOyFXTv23vNuCBd8enN6J8cgOu0DXNAl3q5kHlj4SfCs1gGlja+A4It/hWch2YpAsDc
 NcLwkZRpFIFb/3jL3lu0Df3ZdWxA1n2h+kM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 33nftgv5b3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 00:04:12 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 22 Sep 2020 00:04:11 -0700
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id 9F87B294641C; Tue, 22 Sep 2020 00:04:09 -0700 (PDT)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>, <netdev@vger.kernel.org>
Subject: [PATCH v3 bpf-next 00/11] bpf: Enable bpf_skc_to_* sock casting helper to networking prog type
Date:   Tue, 22 Sep 2020 00:04:09 -0700
Message-ID: <20200922070409.1914988-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-22_05:2020-09-21,2020-09-22 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 impostorscore=0 mlxscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 suspectscore=13 lowpriorityscore=0 mlxlogscore=697 bulkscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009220056
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This set allows networking prog type to directly read fields from
the in-kernel socket type, e.g. "struct tcp_sock".

Patch 2 has the details on the use case.

v3:
- ARG_PTR_TO_SOCK_COMMON_OR_NULL was attempted in v2.  The _OR_NULL was
  needed because the PTR_TO_BTF_ID could be NULL but note that a could be=
 NULL
  PTR_TO_BTF_ID is not a scalar NULL to the verifier.  "_OR_NULL" implici=
tly
  gives an expectation that the helper can take a scalar NULL which does
  not make sense in most (except one) helpers.  Passing scalar NULL
  should be rejected at the verification time.

  Thus, this patch uses ARG_PTR_TO_BTF_ID_SOCK_COMMON to specify that the
  helper can take both the btf-id ptr or the legacy PTR_TO_SOCK_COMMON bu=
t
  not scalar NULL.  It requires the func_proto to explicitly specify the
  arg_btf_id such that there is a very clear expectation that the helper
  can handle a NULL PTR_TO_BTF_ID.

v2:
- Add ARG_PTR_TO_SOCK_COMMON_OR_NULL (Lorenz)

Martin KaFai Lau (11):
  bpf: Move the PTR_TO_BTF_ID check to check_reg_type()
  bpf: Enable bpf_skc_to_* sock casting helper to networking prog type
  bpf: Change bpf_sk_release and bpf_sk_*cgroup_id to accept
    ARG_PTR_TO_BTF_ID_SOCK_COMMON
  bpf: Change bpf_sk_storage_*() to accept ARG_PTR_TO_BTF_ID_SOCK_COMMON
  bpf: Change bpf_tcp_*_syncookie to accept
    ARG_PTR_TO_BTF_ID_SOCK_COMMON
  bpf: Change bpf_sk_assign to accept ARG_PTR_TO_BTF_ID_SOCK_COMMON
  bpf: selftest: Add ref_tracking verifier test for bpf_skc casting
  bpf: selftest: Move sock_fields test into test_progs
  bpf: selftest: Adapt sock_fields test to use skel and global variables
  bpf: selftest: Use network_helpers in the sock_fields test
  bpf: selftest: Use bpf_skc_to_tcp_sock() in the sock_fields test

 include/linux/bpf.h                           |   1 +
 include/net/bpf_sk_storage.h                  |   2 -
 include/uapi/linux/bpf.h                      |   1 +
 kernel/bpf/bpf_lsm.c                          |   4 +-
 kernel/bpf/verifier.c                         |  93 ++--
 net/core/bpf_sk_storage.c                     |  31 +-
 net/core/filter.c                             | 112 ++--
 net/ipv4/bpf_tcp_ca.c                         |  23 +-
 tools/include/uapi/linux/bpf.h                |   1 +
 tools/testing/selftests/bpf/Makefile          |   2 +-
 .../selftests/bpf/prog_tests/sock_fields.c    | 361 +++++++++++++
 ..._sock_fields_kern.c =3D> test_sock_fields.c} | 165 +++---
 .../testing/selftests/bpf/test_sock_fields.c  | 482 ------------------
 .../selftests/bpf/verifier/ref_tracking.c     |  47 ++
 14 files changed, 633 insertions(+), 692 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/sock_fields.c
 rename tools/testing/selftests/bpf/progs/{test_sock_fields_kern.c =3D> t=
est_sock_fields.c} (61%)
 delete mode 100644 tools/testing/selftests/bpf/test_sock_fields.c

--=20
2.24.1

