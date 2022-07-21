Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB2D57CF5F
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 17:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbiGUPhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 11:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232520AbiGUPgm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 11:36:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 069621C91B
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 08:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658417796;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=E9vNgely/RNeXoTi/6KXKEKS3Vm4HrmO6DZ21V4RiOg=;
        b=SkxTaCGJP5nkoCaxcouCFAWIhO7INSfXbcfMsitpUyu/lEpw7GT+RxrSXABcqFId33Quj5
        NBgm2ZrmZafcqXgqPegf3f12lKd0K7j4sUEWF5z8Iy3YNCDN/jjRBKUoB7Xndyx2JN5TUM
        DFSh0jFMfImCy86MLiAB5Iy7KVVq8LA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-443-yU1vkqs-P36TDaFyBVoQAw-1; Thu, 21 Jul 2022 11:36:32 -0400
X-MC-Unique: yU1vkqs-P36TDaFyBVoQAw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B00B1019C8D;
        Thu, 21 Jul 2022 15:36:31 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.194.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5DCC42166B26;
        Thu, 21 Jul 2022 15:36:28 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v7 00/24] Introduce eBPF support for HID devices
Date:   Thu, 21 Jul 2022 17:36:01 +0200
Message-Id: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here comes the v7 of the HID-BPF series.

Again, for a full explanation of HID-BPF, please refer to the last patch
in this series (24/24).

This version sees some minor improvements compared to v6, only
focusing on the reviews I got.

I also wanted to mention that I have started working on the userspace
side to "see" how the BPF programs would look when automatically loaded.
See the udev-hid-bpf project[0] for the code.

The idea is to define the HID-BPF userspace programs so we can reuse
the same semantic in the kernel.
I am quite happy with the results: this looks pretty similar to a kernel
module in term of design. The .bpf.c file is a standalone compilation
unit, and instead of having a table of ids, the filename is used (based
on the modalias). This allows to have a "probe" like function that we
can run to decide if the program needs to be attached or not.

All in all, the end result is that we can write the bpf program, compile
it locally, and send the result to the user. The user needs to drop the
.bpf.o in a local folder, and udev-hid-bpf will pick it up the next time
the device is plugged in. No other operations is required.

Next step will be to drop the same source file in the kernel source
tree, and have some magic to automatically load the compiled program
when the device is loaded.

Cheers,
Benjamin

[0] https://gitlab.freedesktop.org/bentiss/udev-hid-bpf (warning: probably
not the best rust code ever)

Benjamin Tissoires (24):
  selftests/bpf: fix config for CLS_BPF
  bpf/verifier: allow kfunc to read user provided context
  bpf/verifier: do not clear meta in check_mem_size
  selftests/bpf: add test for accessing ctx from syscall program type
  bpf/verifier: allow kfunc to return an allocated mem
  selftests/bpf: Add tests for kfunc returning a memory pointer
  bpf: prepare for more bpf syscall to be used from kernel and user
    space.
  libbpf: add map_get_fd_by_id and map_delete_elem in light skeleton
  HID: core: store the unique system identifier in hid_device
  HID: export hid_report_type to uapi
  HID: convert defines of HID class requests into a proper enum
  HID: Kconfig: split HID support and hid-core compilation
  HID: initial BPF implementation
  selftests/bpf: add tests for the HID-bpf initial implementation
  HID: bpf: allocate data memory for device_event BPF programs
  selftests/bpf/hid: add test to change the report size
  HID: bpf: introduce hid_hw_request()
  selftests/bpf: add tests for bpf_hid_hw_request
  HID: bpf: allow to change the report descriptor
  selftests/bpf: add report descriptor fixup tests
  selftests/bpf: Add a test for BPF_F_INSERT_HEAD
  samples/bpf: add new hid_mouse example
  HID: bpf: add Surface Dial example
  Documentation: add HID-BPF docs

 Documentation/hid/hid-bpf.rst                 | 512 +++++++++
 Documentation/hid/index.rst                   |   1 +
 drivers/Makefile                              |   2 +-
 drivers/hid/Kconfig                           |  20 +-
 drivers/hid/Makefile                          |   2 +
 drivers/hid/bpf/Kconfig                       |  18 +
 drivers/hid/bpf/Makefile                      |  11 +
 drivers/hid/bpf/entrypoints/Makefile          |  93 ++
 drivers/hid/bpf/entrypoints/README            |   4 +
 drivers/hid/bpf/entrypoints/entrypoints.bpf.c |  66 ++
 .../hid/bpf/entrypoints/entrypoints.lskel.h   | 682 ++++++++++++
 drivers/hid/bpf/hid_bpf_dispatch.c            | 553 ++++++++++
 drivers/hid/bpf/hid_bpf_dispatch.h            |  28 +
 drivers/hid/bpf/hid_bpf_jmp_table.c           | 577 ++++++++++
 drivers/hid/hid-core.c                        |  49 +-
 include/linux/bpf.h                           |   9 +-
 include/linux/btf.h                           |  10 +
 include/linux/hid.h                           |  38 +-
 include/linux/hid_bpf.h                       | 148 +++
 include/uapi/linux/hid.h                      |  26 +-
 include/uapi/linux/hid_bpf.h                  |  25 +
 kernel/bpf/btf.c                              |  91 +-
 kernel/bpf/syscall.c                          |  10 +-
 kernel/bpf/verifier.c                         |  65 +-
 net/bpf/test_run.c                            |  23 +
 samples/bpf/.gitignore                        |   2 +
 samples/bpf/Makefile                          |  27 +
 samples/bpf/hid_mouse.bpf.c                   | 134 +++
 samples/bpf/hid_mouse.c                       | 147 +++
 samples/bpf/hid_surface_dial.bpf.c            | 161 +++
 samples/bpf/hid_surface_dial.c                | 212 ++++
 tools/include/uapi/linux/hid.h                |  62 ++
 tools/include/uapi/linux/hid_bpf.h            |  25 +
 tools/lib/bpf/skel_internal.h                 |  23 +
 tools/testing/selftests/bpf/Makefile          |   5 +-
 tools/testing/selftests/bpf/config            |   5 +-
 tools/testing/selftests/bpf/prog_tests/hid.c  | 990 ++++++++++++++++++
 .../selftests/bpf/prog_tests/kfunc_call.c     |  76 ++
 tools/testing/selftests/bpf/progs/hid.c       | 206 ++++
 .../selftests/bpf/progs/kfunc_call_test.c     | 125 +++
 40 files changed, 5184 insertions(+), 79 deletions(-)
 create mode 100644 Documentation/hid/hid-bpf.rst
 create mode 100644 drivers/hid/bpf/Kconfig
 create mode 100644 drivers/hid/bpf/Makefile
 create mode 100644 drivers/hid/bpf/entrypoints/Makefile
 create mode 100644 drivers/hid/bpf/entrypoints/README
 create mode 100644 drivers/hid/bpf/entrypoints/entrypoints.bpf.c
 create mode 100644 drivers/hid/bpf/entrypoints/entrypoints.lskel.h
 create mode 100644 drivers/hid/bpf/hid_bpf_dispatch.c
 create mode 100644 drivers/hid/bpf/hid_bpf_dispatch.h
 create mode 100644 drivers/hid/bpf/hid_bpf_jmp_table.c
 create mode 100644 include/linux/hid_bpf.h
 create mode 100644 include/uapi/linux/hid_bpf.h
 create mode 100644 samples/bpf/hid_mouse.bpf.c
 create mode 100644 samples/bpf/hid_mouse.c
 create mode 100644 samples/bpf/hid_surface_dial.bpf.c
 create mode 100644 samples/bpf/hid_surface_dial.c
 create mode 100644 tools/include/uapi/linux/hid.h
 create mode 100644 tools/include/uapi/linux/hid_bpf.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/hid.c
 create mode 100644 tools/testing/selftests/bpf/progs/hid.c

-- 
2.36.1

