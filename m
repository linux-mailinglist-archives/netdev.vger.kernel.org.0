Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9BE94954AC
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 20:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377410AbiATTNV convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 20 Jan 2022 14:13:21 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:13442 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377418AbiATTNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 14:13:20 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20KHwR41013259
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 11:13:20 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3dpy7m4xth-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 11:13:20 -0800
Received: from twshared3205.02.ash9.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 20 Jan 2022 11:13:17 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 2144328324561; Thu, 20 Jan 2022 11:13:13 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <peterz@infradead.org>, <x86@kernel.org>,
        Song Liu <song@kernel.org>
Subject: [PATCH v5 bpf-next 0/7] bpf_prog_pack allocator
Date:   Thu, 20 Jan 2022 11:12:58 -0800
Message-ID: <20220120191306.1801459-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: xS67tkogBf05b0O4HAupE7dOjwdFMTRE
X-Proofpoint-GUID: xS67tkogBf05b0O4HAupE7dOjwdFMTRE
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-20_07,2022-01-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 phishscore=0
 priorityscore=1501 mlxlogscore=654 impostorscore=0 adultscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 bulkscore=0
 mlxscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201200097
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
 arch/x86/net/bpf_jit_comp.c          | 136 +++++++++++++----
 include/linux/bpf.h                  |   4 +-
 include/linux/filter.h               |  23 ++-
 kernel/bpf/core.c                    | 211 ++++++++++++++++++++++++---
 kernel/bpf/trampoline.c              |   6 +-
 8 files changed, 356 insertions(+), 58 deletions(-)

--
2.30.2
