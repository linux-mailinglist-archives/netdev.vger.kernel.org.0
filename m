Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9FDE28691F
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 22:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728630AbgJGUbJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 7 Oct 2020 16:31:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20802 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728601AbgJGUbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 16:31:09 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 097KTEBY018847
        for <netdev@vger.kernel.org>; Wed, 7 Oct 2020 13:31:08 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 33xmypddsx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 13:31:08 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 7 Oct 2020 13:30:01 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id CF9CB2EC7B90; Wed,  7 Oct 2020 13:29:47 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Tony Ambardar <tony.ambardar@gmail.com>
Subject: [PATCH v2 bpf-next 0/4] libbpf: auto-resize relocatable LOAD/STORE instructions
Date:   Wed, 7 Oct 2020 13:29:42 -0700
Message-ID: <20201007202946.3684483-1-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
X-FB-Internal: Safe
Content-Type: text/plain
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-07_10:2020-10-07,2020-10-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 adultscore=0 bulkscore=0 mlxlogscore=589 spamscore=0
 mlxscore=0 phishscore=0 malwarescore=0 impostorscore=0 suspectscore=8
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010070131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch set implements logic in libbpf to auto-adjust memory size (1-, 2-, 4-,
8-bytes) of load/store (LD/ST/STX) instructions which have BPF CO-RE field
offset relocation associated with it. In practice this means transparent
handling of 32-bit kernels, both pointer and unsigned integers. Signed
integers are not relocatable with zero-extending loads/stores, so libbpf
poisons them and generates a warning. If/when BPF gets support for
sign-extending loads/stores, it would be possible to automatically relocate
them as well.

All the details are contained in patch #2 comments and commit message.
Patch #3 is a simple change in libbpf to make advanced testing with custom BTF
easier. Patch #4 validates correct uses of auto-resizable loads, as well as
check that libbpf fails invalid uses. Patch #1 skips CO-RE relocation for
programs that had bpf_program__set_autoload(prog, false) set on them, reducing
warnings and noise.

v1->v2:
  - more consistent names for instruction mem size convertion routines (Alexei);
  - extended selftests to use relocatable STX instructions (Alexei);
  - added a fix for skipping CO-RE relocation for non-loadable programs.

Cc: Luka Perkov <luka.perkov@sartura.hr>
Cc: Tony Ambardar <tony.ambardar@gmail.com>

Andrii Nakryiko (4):
  libbpf: skip CO-RE relocations for not loaded BPF programs
  libbpf: support safe subset of load/store instruction resizing with
    CO-RE
  libbpf: allow specifying both ELF and raw BTF for CO-RE BTF override
  selftests/bpf: validate libbpf's auto-sizing of LD/ST/STX instructions

 tools/lib/bpf/libbpf.c                        | 151 +++++++++++-
 .../selftests/bpf/prog_tests/core_autosize.c  | 225 ++++++++++++++++++
 .../selftests/bpf/progs/test_core_autosize.c  | 172 +++++++++++++
 3 files changed, 539 insertions(+), 9 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/core_autosize.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_core_autosize.c

-- 
2.24.1

