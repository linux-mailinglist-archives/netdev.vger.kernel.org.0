Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96D154E9E36
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 19:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240218AbiC1RyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 13:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244764AbiC1Rwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 13:52:53 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0113CA56;
        Mon, 28 Mar 2022 10:51:11 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KS0Zg0mQtz67Mmd;
        Tue, 29 Mar 2022 01:49:47 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 28 Mar 2022 19:51:08 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <corbet@lwn.net>, <viro@zeniv.linux.org.uk>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kpsingh@kernel.org>,
        <shuah@kernel.org>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@foss.st.com>, <zohar@linux.ibm.com>
CC:     <linux-doc@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 00/18] bpf: Secure and authenticated preloading of eBPF programs
Date:   Mon, 28 Mar 2022 19:50:15 +0200
Message-ID: <20220328175033.2437312-1-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

eBPF already allows programs to be preloaded and kept running without
intervention from user space. There is a dedicated kernel module called
bpf_preload, which contains the light skeleton of the iterators_bpf eBPF
program. If this module is enabled in the kernel configuration, its loading
will be triggered when the bpf filesystem is mounted (unless the module is
built-in), and the links of iterators_bpf are pinned in that filesystem
(they will appear as the progs.debug and maps.debug files).

However, the current mechanism, if used to preload an LSM, would not offer
the same security guarantees of LSMs integrated in the security subsystem.
Also, it is not generic enough to be used for preloading arbitrary eBPF
programs, unless the bpf_preload code is heavily modified.

More specifically, the security problems are:
- any program can be pinned to the bpf filesystem without limitations
  (unless a MAC mechanism enforces some restrictions);
- programs being executed can be terminated at any time by deleting the
  pinned objects or unmounting the bpf filesystem.

The usability problems are:
- only a fixed amount of links can be pinned;
- only links can be pinned, other object types are not supported;
- code to pin objects has to be written manually;
- preloading multiple eBPF programs is not practical, bpf_preload has to be
  modified to include additional light skeletons.

Solve the security problems by mounting the bpf filesystem from the kernel,
by preloading authenticated kernel modules (e.g. with module.sig_enforce)
and by pinning objects to that filesystem. This particular filesystem
instance guarantees that desired eBPF programs run until the very end of
the kernel lifecycle, since even root cannot interfere with it.

Solve the usability problems by generalizing the pinning function, to
handle not only links but also maps and progs. Also increment the object
reference count and call the pinning function directly from the preload
method (currently in the bpf_preload kernel module) rather than from the
bpf filesystem code itself, so that a generic eBPF program can do those
operations depending on its objects (this also avoids the limitation of the
fixed-size array for storing the objects to pin).

Then, simplify the process of pinning objects defined by a generic eBPF
program by automatically generating the required methods in the light
skeleton. Also, generate a separate kernel module for each eBPF program to
preload, so that existing ones don't have to be modified. Finally, support
preloading multiple eBPF programs by allowing users to specify a list from
the kernel configuration, at build time, or with the new kernel option
bpf_preload_list=, at run-time.

To summarize, this patch set makes it possible to plug in out-of-tree LSMs
matching the security guarantees of their counterpart in the security
subsystem, without having to modify the kernel itself. The same benefits
are extended to other eBPF program types.

Only one remaining problem is how to support auto-attaching eBPF programs
with LSM type. It will be solved with a separate patch set.

Patches 1-2 export some definitions, to build out-of-tree kernel modules
with eBPF programs to preload. Patches 3-4 allow eBPF programs to pin
objects by themselves. Patches 5-10 automatically generate the methods for
preloading in the light skeleton. Patches 11-14 make it possible to preload
multiple eBPF programs. Patch 15 automatically generates the kernel module
for preloading an eBPF program, patch 16 does a kernel mount of the bpf
filesystem, and finally patches 17-18 test the functionality introduced.

Roberto Sassu (18):
  bpf: Export bpf_link_inc()
  bpf-preload: Move bpf_preload.h to include/linux
  bpf-preload: Generalize object pinning from the kernel
  bpf-preload: Export and call bpf_obj_do_pin_kernel()
  bpf-preload: Generate static variables
  bpf-preload: Generate free_objs_and_skel()
  bpf-preload: Generate preload()
  bpf-preload: Generate load_skel()
  bpf-preload: Generate code to pin non-internal maps
  bpf-preload: Generate bpf_preload_ops
  bpf-preload: Store multiple bpf_preload_ops structures in a linked
    list
  bpf-preload: Implement new registration method for preloading eBPF
    programs
  bpf-preload: Move pinned links and maps to a dedicated directory in
    bpffs
  bpf-preload: Switch to new preload registration method
  bpf-preload: Generate code of kernel module to preload
  bpf-preload: Do kernel mount to ensure that pinned objects don't
    disappear
  bpf-preload/selftests: Add test for automatic generation of preload
    methods
  bpf-preload/selftests: Preload a test eBPF program and check pinned
    objects

 .../admin-guide/kernel-parameters.txt         |   8 +
 fs/namespace.c                                |   1 +
 include/linux/bpf.h                           |   5 +
 include/linux/bpf_preload.h                   |  37 ++
 init/main.c                                   |   2 +
 kernel/bpf/inode.c                            | 295 +++++++++--
 kernel/bpf/preload/Kconfig                    |  25 +-
 kernel/bpf/preload/bpf_preload.h              |  16 -
 kernel/bpf/preload/bpf_preload_kern.c         |  85 +---
 kernel/bpf/preload/iterators/Makefile         |   9 +-
 .../bpf/preload/iterators/iterators.lskel.h   | 466 +++++++++++-------
 kernel/bpf/syscall.c                          |   1 +
 .../bpf/bpftool/Documentation/bpftool-gen.rst |  13 +
 tools/bpf/bpftool/bash-completion/bpftool     |   6 +-
 tools/bpf/bpftool/gen.c                       | 331 +++++++++++++
 tools/bpf/bpftool/main.c                      |   7 +-
 tools/bpf/bpftool/main.h                      |   1 +
 tools/testing/selftests/bpf/Makefile          |  32 +-
 .../bpf/bpf_testmod_preload/.gitignore        |   7 +
 .../bpf/bpf_testmod_preload/Makefile          |  20 +
 .../gen_preload_methods.expected.diff         |  97 ++++
 .../bpf/prog_tests/test_gen_preload_methods.c |  27 +
 .../bpf/prog_tests/test_preload_methods.c     |  69 +++
 .../selftests/bpf/progs/gen_preload_methods.c |  23 +
 24 files changed, 1246 insertions(+), 337 deletions(-)
 create mode 100644 include/linux/bpf_preload.h
 delete mode 100644 kernel/bpf/preload/bpf_preload.h
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod_preload/.gitignore
 create mode 100644 tools/testing/selftests/bpf/bpf_testmod_preload/Makefile
 create mode 100644 tools/testing/selftests/bpf/prog_tests/gen_preload_methods.expected.diff
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_gen_preload_methods.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_preload_methods.c
 create mode 100644 tools/testing/selftests/bpf/progs/gen_preload_methods.c

-- 
2.32.0

