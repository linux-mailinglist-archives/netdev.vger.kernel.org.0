Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60EE1210418
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 08:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgGAGpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 02:45:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:16778 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727943AbgGAGpc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 02:45:32 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0616duob014756
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 23:45:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=6ahtOnzc8oMo0v0y+QQ+BQUGjdqT6t2aJ6YMPMb9+KE=;
 b=XLLs9SHEE4XD4tlpdo7mmzIzTXM8y/J0RbsFXW/eY+Lj1DileaXdTCKpff6iDR44GlCZ
 jzSe7eTBbkGgIkINTENDxDaKkGLGZc8W0FzXnLmRbznzDgpnYK9EyqAMXkrVmHUa8YRZ
 BeOT6lpnZzkYVnfpk4RPyC2XNMN+8ApY4n8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 320anf2gur-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 23:45:31 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 30 Jun 2020 23:45:30 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 1A2D22EC3A2B; Tue, 30 Jun 2020 23:45:29 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Anton Protopopov <a.s.protopopov@gmail.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 0/3] Strip away modifiers from BPF skeleton global variables
Date:   Tue, 30 Jun 2020 23:45:22 -0700
Message-ID: <20200701064527.3158178-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-01_03:2020-07-01,2020-07-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 mlxlogscore=690 lowpriorityscore=0 adultscore=0 mlxscore=0
 priorityscore=1501 cotscore=-2147483648 phishscore=0 impostorscore=0
 spamscore=0 bulkscore=0 malwarescore=0 clxscore=1015 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007010047
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix bpftool logic of stripping away const/volatile modifiers for all glob=
al
variables during BPF skeleton generation. See patch #1 for details on whe=
n
existing logic breaks and why it's important. Support special .strip_mods=
=3Dtrue
mode in btf_dump. Add selftests validating that everything works as expec=
ted.

Recent example of when this has caused problems can be found in [0].

  [0] https://github.com/iovisor/bcc/pull/2994#issuecomment-650588533

Cc: Anton Protopopov <a.s.protopopov@gmail.com>

Andrii Nakryiko (3):
  libbpf: support stripping modifiers for btf_dump
  selftests/bpf: add selftest validating btf_dump's mod-stripping output
  tools/bpftool: strip away modifiers from global variables

 tools/bpf/bpftool/gen.c                       | 13 ++---
 tools/lib/bpf/btf.h                           |  6 +++
 tools/lib/bpf/btf_dump.c                      | 18 +++++--
 .../selftests/bpf/prog_tests/btf_dump.c       |  5 +-
 .../selftests/bpf/prog_tests/skeleton.c       |  6 +--
 .../bpf/progs/btf_dump_test_case_strip_mods.c | 50 +++++++++++++++++++
 .../selftests/bpf/progs/test_skeleton.c       |  6 ++-
 7 files changed, 84 insertions(+), 20 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/progs/btf_dump_test_case_=
strip_mods.c

--=20
2.24.1

