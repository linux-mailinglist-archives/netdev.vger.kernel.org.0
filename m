Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDAB5485EB3
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 03:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344749AbiAFCZx convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 5 Jan 2022 21:25:53 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38864 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1344706AbiAFCZw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 21:25:52 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.1.2/8.16.1.2) with ESMTP id 205NA58v026532
        for <netdev@vger.kernel.org>; Wed, 5 Jan 2022 18:25:51 -0800
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net (PPS) with ESMTPS id 3ddmrsrsqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 18:25:51 -0800
Received: from twshared7460.02.ash7.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 5 Jan 2022 18:25:51 -0800
Received: by devbig006.ftw2.facebook.com (Postfix, from userid 4523)
        id 9144A273E53FA; Wed,  5 Jan 2022 18:25:38 -0800 (PST)
From:   Song Liu <song@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kernel-team@fb.com>, <peterz@infradead.org>, <x86@kernel.org>,
        Song Liu <song@kernel.org>
Subject: [PATCH v3 bpf-next 0/7] bpf_prog_pack allocator
Date:   Wed, 5 Jan 2022 18:25:26 -0800
Message-ID: <20220106022533.2950016-1-song@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: DonoqlW6YQlrSJvoUbDvFMsRXSzKlFh4
X-Proofpoint-ORIG-GUID: DonoqlW6YQlrSJvoUbDvFMsRXSzKlFh4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-05_08,2022-01-04_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 lowpriorityscore=0
 bulkscore=0 phishscore=0 impostorscore=0 malwarescore=0 suspectscore=0
 adultscore=0 mlxlogscore=659 clxscore=1015 mlxscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2112160000 definitions=main-2201060011
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
  x86/alternative: introduce text_poke_jit
  bpf: introduce bpf_prog_pack allocator
  bpf, x86_64: use bpf_prog_pack allocator

 arch/x86/Kconfig                     |   1 +
 arch/x86/include/asm/text-patching.h |   1 +
 arch/x86/kernel/alternative.c        |  28 ++++
 arch/x86/net/bpf_jit_comp.c          | 133 +++++++++++++----
 include/linux/bpf.h                  |   4 +-
 include/linux/filter.h               |  23 ++-
 kernel/bpf/core.c                    | 213 ++++++++++++++++++++++++---
 kernel/bpf/trampoline.c              |   6 +-
 8 files changed, 350 insertions(+), 59 deletions(-)

--
2.30.2
