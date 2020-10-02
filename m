Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FB8280BD0
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 03:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387495AbgJBBJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 21:09:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36414 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387430AbgJBBJW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 21:09:22 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0920nwgw026438
        for <netdev@vger.kernel.org>; Thu, 1 Oct 2020 18:09:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=njt3WnS71xR5PDicdRV1wmZWSDBTDgKhS2E2Vx02mkI=;
 b=YQQVsqLYiXF9bIoQNbj/3Fmn+mEhIjAYZIYhSx4Xx1+l0RC/xRaF9vLQuqTOlmcTiKTE
 nDMRvG6XSbuUoFgTpX6AfZnel+j44Xj7iLjpihzHTxZ3EMjNwClWJOju7PY/68C4I8qt
 XrFFUffwHN2htMWp2Cfx7xfru82R1HAX+yU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 33vvgrs4nm-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 18:09:21 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 1 Oct 2020 18:09:19 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 364042EC789D; Thu,  1 Oct 2020 18:09:15 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Tony Ambardar <tony.ambardar@gmail.com>
Subject: [PATCH bpf-next 0/3] libbpf: auto-resize relocatable LOAD/STORE instructions
Date:   Thu, 1 Oct 2020 18:06:30 -0700
Message-ID: <20201002010633.3706122-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-01_10:2020-10-01,2020-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 clxscore=1015 phishscore=0 mlxscore=0 bulkscore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 adultscore=0 mlxlogscore=591
 suspectscore=8 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2010020002
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch set implements logic in libbpf to auto-adjust memory size (1-, 2-, =
4-,
8-bytes) of load/store (LD/ST/STX) instructions which have BPF CO-RE fiel=
d
offset relocation associated with it. In practice this means transparent
handling of 32-bit kernels, both pointer and unsigned integers. Signed
integers are not relocatable with zero-extending loads/stores, so libbpf
poisons them and generates a warning. If/when BPF gets support for sign-e=
xtending
loads/stores, it would be possible to automatically relocate them as well=
.

All the details are contained in patch #1 comments and commit message.
Patch #2 is a simple change in libbpf to make advanced testing with custo=
m BTF
easier. Patch #3 validates correct uses of auto-resizable loads, as well =
as
check that libbpf fails invalid uses.

I'd really appreciate folks that use BPF on 32-bit architectures to test =
this
out with their BPF programs and report if there are any problems with the
approach.

Cc: Luka Perkov <luka.perkov@sartura.hr>
Cc: Tony Ambardar <tony.ambardar@gmail.com>

Andrii Nakryiko (3):
  libbpf: support safe subset of load/store instruction resizing with
    CO-RE
  libbpf: allow specifying both ELF and raw BTF for CO-RE BTF override
  selftests/bpf: validate libbpf's auto-sizing of LD/ST/STX instructions

 tools/lib/bpf/libbpf.c                        | 146 ++++++++++++-
 .../selftests/bpf/prog_tests/core_autosize.c  | 199 ++++++++++++++++++
 .../selftests/bpf/progs/test_core_autosize.c  | 148 +++++++++++++
 3 files changed, 483 insertions(+), 10 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_autosize.=
c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_autosize.=
c

--=20
2.24.1

