Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 805B73C7092
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 14:43:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236205AbhGMMqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 08:46:15 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:24985 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236098AbhGMMqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 08:46:14 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R491e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=chengshuyi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0UfgPhp1_1626180194;
Received: from localhost(mailfrom:chengshuyi@linux.alibaba.com fp:SMTPD_---0UfgPhp1_1626180194)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 13 Jul 2021 20:43:22 +0800
From:   Shuyi Cheng <chengshuyi@linux.alibaba.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Shuyi Cheng <chengshuyi@linux.alibaba.com>
Subject: [PATCH bpf-next v4 0/3] Add btf_custom_path in bpf_obj_open_opts
Date:   Tue, 13 Jul 2021 20:42:36 +0800
Message-Id: <1626180159-112996-1-git-send-email-chengshuyi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set adds the ability to point to a custom BTF for the
purposes of BPF CO-RE relocations. This is useful for using BPF CO-RE
on old kernels that don't yet natively support kernel (vmlinux) BTF
and thus libbpf needs application's help in locating kernel BTF
generated separately from the kernel itself. This was already possible
to do through bpf_object__load's attribute struct, but that makes it
inconvenient to use with BPF skeleton, which only allows to specify
bpf_object_open_opts during the open step. Thus, add the ability to
override vmlinux BTF at open time.

Patch #1 adds libbpf changes. 
Patch #2 fixes pre-existing memory leak detected during the code review. 
Patch #3 switches existing selftests to using open_opts for custom BTF.

Changelog:
----------

v3: https://lore.kernel.org/bpf/CAEf4BzY2cdT44bfbMus=gei27ViqGE1BtGo6XrErSsOCnqtVJg@mail.gmail.com/T/#m877eed1d4cf0a1d3352d3f3d6c5ff158be45c542
v3->v4:
--- Follow Andrii's suggestion to modify cover letter description.
--- Delete function bpf_object__load_override_btf.
--- Follow Dan's suggestion to add fixes tag and modify commit msg to patch #2.
--- Add pathch #3 to switch existing selftests to using open_opts.

v2: https://lore.kernel.org/bpf/CAEf4Bza_ua+tjxdhyy4nZ8Boeo+scipWmr_1xM1pC6N5wyuhAA@mail.gmail.com/T/#mf9cf86ae0ffa96180ac29e4fd12697eb70eccd0f
v2->v3:
--- Load the BTF specified by btf_custom_path to btf_vmlinux_override 
    instead of btf_bmlinux.
--- Fix the memory leak that may be introduced by the second version 
    of the patch.
--- Add a new patch to fix the possible memory leak caused by 
    obj->kconfig.

v1: https://lore.kernel.org/bpf/CAEf4BzaGjEC4t1OefDo11pj2-HfNy0BLhs_G2UREjRNTmb2u=A@mail.gmail.com/t/#m4d9f7c6761fbd2b436b5dfe491cd864b70225804
v1->v2:
-- Change custom_btf_path to btf_custom_path.
-- If the length of btf_custom_path of bpf_obj_open_opts is too long, 
   return ERR_PTR(-ENAMETOOLONG).
-- Add `custom BTF is in addition to vmlinux BTF`
   with btf_custom_path field.

Shuyi Cheng (3):
  libbpf: Introduce 'btf_custom_path' to 'bpf_obj_open_opts'
  libbpf: Fix the possible memory leak on error
  selftests/bpf: switches existing selftests to using open_opts for custom BTF

 tools/lib/bpf/libbpf.c                             | 42 +++++++++++++++++-----
 tools/lib/bpf/libbpf.h                             |  9 ++++-
 .../selftests/bpf/prog_tests/core_autosize.c       | 22 ++++++------
 .../testing/selftests/bpf/prog_tests/core_reloc.c  | 28 +++++++--------
 4 files changed, 66 insertions(+), 35 deletions(-)

-- 
1.8.3.1

