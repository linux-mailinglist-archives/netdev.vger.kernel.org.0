Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAE64965DD
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 20:49:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231643AbiAUTtg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 21 Jan 2022 14:49:36 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:61996 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229454AbiAUTtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 14:49:36 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20LFs2Gr009614
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 11:49:35 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dqj0cdm3c-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 11:49:35 -0800
Received: from twshared3115.02.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 21 Jan 2022 11:49:33 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 9EEAB284A5F0B; Fri, 21 Jan 2022 11:49:29 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <peterz@infradead.org>, <x86@kernel.org>,
        Song Liu <song@kernel.org>
Subject: [PATCH v6 bpf-next 0/7] bpf_prog_pack allocator
Date:   Fri, 21 Jan 2022 11:49:19 -0800
Message-ID: <20220121194926.1970172-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: aidWJet1-yEwPBcXZ8eXVx3Tj03dCKxy
X-Proofpoint-ORIG-GUID: aidWJet1-yEwPBcXZ8eXVx3Tj03dCKxy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_09,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 bulkscore=0 priorityscore=1501 spamscore=0 clxscore=1034 impostorscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=632 lowpriorityscore=0
 malwarescore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201210128
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes v5 => v6:
1. Make jit_hole_buffer 128 byte long. Only fill the first and last 128
   bytes of header with INT3. (Alexei)
2. Use kvmalloc for temporary buffer. (Alexei)
3. Rename tmp_header/tmp_image => rw_header/rw_image. Remove tmp_image from
   x64_jit_data. (Alexei)
4. Change fall back round_up_to in bpf_jit_binary_alloc_pack() from
   BPF_PROG_MAX_PACK_PROG_SIZE to PAGE_SIZE.

Changes v4 => v5:
1. Do not use atomic64 for bpf_jit_current. (Alexei)

Changes v3 => v4:
1. Rename text_poke_jit() => text_poke_copy(). (Peter)
2. Change comment style. (Peter)

Changes v2 => v3:
1. Fix tailcall.

Changes v1 => v2:
1. Use text_poke instead of writing through linear mapping. (Peter)
2. Avoid making changes to non-x86_64 code.

Most BPF programs are small, but they consume a page each. For systems
with busy traffic and many BPF programs, this could also add significant
pressure to instruction TLB.

This set tries to solve this problem with customized allocator that pack
multiple programs into a huge page.

Patches 1-5 prepare the work. Patch 6 contains key logic of the allocator.
Patch 7 uses this allocator in x86_64 jit compiler.

Song Liu (7):
  x86/Kconfig: select HAVE_ARCH_HUGE_VMALLOC with HAVE_ARCH_HUGE_VMAP
  bpf: use bytes instead of pages for bpf_jit_[charge|uncharge]_modmem
  bpf: use size instead of pages in bpf_binary_header
  bpf: add a pointer of bpf_binary_header to bpf_prog
  x86/alternative: introduce text_poke_copy
  bpf: introduce bpf_prog_pack allocator
  bpf, x86_64: use bpf_prog_pack allocator

 arch/x86/Kconfig                     |   1 +
 arch/x86/include/asm/text-patching.h |   1 +
 arch/x86/kernel/alternative.c        |  32 ++++
 arch/x86/net/bpf_jit_comp.c          | 143 ++++++++++++++----
 include/linux/bpf.h                  |   4 +-
 include/linux/filter.h               |  23 ++-
 kernel/bpf/core.c                    | 210 ++++++++++++++++++++++++---
 kernel/bpf/trampoline.c              |   6 +-
 8 files changed, 363 insertions(+), 57 deletions(-)

--
2.30.2
