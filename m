Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC06571D8E
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 17:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233829AbiGLPAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 11:00:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233842AbiGLO7P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 10:59:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E0E6E093
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 07:59:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657637953;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zoTGpT5wz2asFihF9G/fqHRbU5urP9svL59pFAfNHLA=;
        b=UgxHijq6yluCynhMrJrJq3YLnIUFIkQ4mAGuGMTBfuMrRtq5eKVUMlStUks8s5z1SsSLkB
        N/XsNILdYnhByUW99FjapMOxYqa400ME95NPDh89q3fUjRxw8ErLKZIdyda3opTPUpNHaP
        acM7j5DxCFqB7BiO0pmlWMjbKwu3FHs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-534-5vbabllaPHGUlWIAX2oLDw-1; Tue, 12 Jul 2022 10:59:02 -0400
X-MC-Unique: 5vbabllaPHGUlWIAX2oLDw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 25881811E75;
        Tue, 12 Jul 2022 14:59:01 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.195.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB9882166B26;
        Tue, 12 Jul 2022 14:58:57 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v6 00/23] Introduce eBPF support for HID devices
Date:   Tue, 12 Jul 2022 16:58:27 +0200
Message-Id: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

and after a little bit of time, here comes the v6 of the HID-BPF series.

Again, for a full explanation of HID-BPF, please refer to the last patch
in this series (23/23).

This version sees some improvements compared to v5 on top of the
usual addressing of the previous comments:
- now I think every eBPF core change has a matching selftest added
- the kfuncs declared in syscall can now actually access the memory of
  the context
- the code to retrieve the BTF ID of the various HID hooks is much
  simpler (just a plain use of the BTF_ID() API instead of
  loading/unloading of a tracing program)
- I also added my HID Surface Dial example that I use locally to provide
  a fuller example to users

Cheers,
Benjamin

Benjamin Tissoires (23):
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
 drivers/hid/Kconfig                           |   2 +
 drivers/hid/Makefile                          |   2 +
 drivers/hid/bpf/Kconfig                       |  19 +
 drivers/hid/bpf/Makefile                      |  11 +
 drivers/hid/bpf/entrypoints/Makefile          |  88 ++
 drivers/hid/bpf/entrypoints/README            |   4 +
 drivers/hid/bpf/entrypoints/entrypoints.bpf.c |  66 ++
 .../hid/bpf/entrypoints/entrypoints.lskel.h   | 682 ++++++++++++
 drivers/hid/bpf/hid_bpf_dispatch.c            | 554 ++++++++++
 drivers/hid/bpf/hid_bpf_dispatch.h            |  28 +
 drivers/hid/bpf/hid_bpf_jmp_table.c           | 577 ++++++++++
 drivers/hid/hid-core.c                        |  49 +-
 include/linux/bpf.h                           |  10 +-
 include/linux/btf.h                           |  14 +
 include/linux/hid.h                           |  38 +-
 include/linux/hid_bpf.h                       | 145 +++
 include/uapi/linux/hid.h                      |  26 +-
 include/uapi/linux/hid_bpf.h                  |  25 +
 kernel/bpf/btf.c                              |  67 +-
 kernel/bpf/syscall.c                          |  10 +-
 kernel/bpf/verifier.c                         |  67 +-
 net/bpf/test_run.c                            |  23 +
 samples/bpf/.gitignore                        |   2 +
 samples/bpf/Makefile                          |  27 +
 samples/bpf/hid_mouse.bpf.c                   | 134 +++
 samples/bpf/hid_mouse.c                       | 150 +++
 samples/bpf/hid_surface_dial.bpf.c            | 161 +++
 samples/bpf/hid_surface_dial.c                | 216 ++++
 tools/include/uapi/linux/hid.h                |  62 ++
 tools/include/uapi/linux/hid_bpf.h            |  25 +
 tools/lib/bpf/skel_internal.h                 |  23 +
 tools/testing/selftests/bpf/Makefile          |   5 +-
 tools/testing/selftests/bpf/config            |   5 +-
 tools/testing/selftests/bpf/prog_tests/hid.c  | 990 ++++++++++++++++++
 .../selftests/bpf/prog_tests/kfunc_call.c     |  68 ++
 tools/testing/selftests/bpf/progs/hid.c       | 206 ++++
 .../selftests/bpf/progs/kfunc_call_test.c     | 116 ++
 39 files changed, 5150 insertions(+), 60 deletions(-)
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

