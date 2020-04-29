Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E46C1BD10B
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 02:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726493AbgD2A1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 20:27:51 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62114 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726472AbgD2A1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 20:27:51 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03T0E2Lp018232
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 17:27:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type :
 content-transfer-encoding; s=facebook;
 bh=WWOi9Sa8TGzIhz+O2MSIYrDd5x3t5m5RrLT5Z2qvlns=;
 b=pb/rOpNveO4AzBA5F5YfsgnIBSCTBSHHnT8z/C2rqunnY1gnKX2e+3VG3i2vH/+BiIDQ
 7mX/e0+DDptdYgvhy909/+4fl63w7YX7m7XWMKb8HbAHbVtDxVdq/Yc13+pKahtsQ4HZ
 EfPxwTnDO89Q7h787QR7Sqrn7TqmRMAEqr4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30mk1gpx0t-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 28 Apr 2020 17:27:49 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 28 Apr 2020 17:27:47 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 5840A2EC30C5; Tue, 28 Apr 2020 17:27:44 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <toke@redhat.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 0/3] Add BTF-defined map-in-map support to libbpf
Date:   Tue, 28 Apr 2020 17:27:36 -0700
Message-ID: <20200429002739.48006-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_15:2020-04-28,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 suspectscore=8 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 mlxscore=0 malwarescore=0 bulkscore=0 spamscore=0 adultscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004290000
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set teaches libbpf how to declare and initialize ARRAY_OF_MAPS=
 and
HASH_OF_MAPS maps. See patch #3 for all the details.

Patch #1 refactors parsing BTF definition of map to re-use it cleanly for
inner map definition parsing.

Patch #2 refactors map creation and destruction logic for reuse. It also =
fixes
existing bug with not closing successfully created maps when bpf_object m=
ap
creation overall fails.

Patch #3 adds support for an extension of BTF-defined map syntax, as well=
 as
parsing, recording, and use of relocations to allow declaratively initial=
ize
outer maps with references to inner maps.

v1->v2:
  - rename __inner to __array (Alexei).

Andrii Nakryiko (3):
  libbpf: refactor BTF-defined map definition parsing logic
  libbpf: refactor map creation logic and fix cleanup leak
  libbpf: add BTF-defined map-in-map support

 tools/lib/bpf/bpf_helpers.h                   |   1 +
 tools/lib/bpf/libbpf.c                        | 698 ++++++++++++------
 .../selftests/bpf/prog_tests/btf_map_in_map.c |  49 ++
 .../selftests/bpf/progs/test_btf_map_in_map.c |  76 ++
 4 files changed, 606 insertions(+), 218 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/btf_map_in_map=
.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_btf_map_in_map=
.c

--=20
2.24.1

