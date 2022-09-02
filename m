Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D66A25AB260
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 15:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237563AbiIBN5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 09:57:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237536AbiIBN5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 09:57:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D1F6717F
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 06:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662125392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=lzxLFwuf/sIbhXE8ylkRHPZIoLPKTHRY8OYjNIVtYi0=;
        b=bgZ09rk5ahecxYjhS0LosL7OKOTTSI03csdy2b25WW+1JAwBHUaEZrBXE4fTn6x5/bkmNt
        qYLI17zPtOE+AxzEY5eRWAzI59twkQHAbVjDKqaSKjMjxuGtZV5fhBfWnf0DcVsiwTCl1J
        /a4xDnNwCrgG274tsjXSczFj15+ClGs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-326-rU2S2oHGPvalT-aTdDn89g-1; Fri, 02 Sep 2022 09:29:45 -0400
X-MC-Unique: rU2S2oHGPvalT-aTdDn89g-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ECC3E1C05AC2;
        Fri,  2 Sep 2022 13:29:44 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.193.218])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8F39D492C3B;
        Fri,  2 Sep 2022 13:29:41 +0000 (UTC)
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
Subject: [PATCH bpf-next v10 00/23] Introduce eBPF support for HID devices
Date:   Fri,  2 Sep 2022 15:29:15 +0200
Message-Id: <20220902132938.2409206-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here comes the v10 of the HID-BPF series.

Again, for a full explanation of HID-BPF, please refer to the last patch
in this series (23/23).

Hopefully we are getting closer to merging the bpf-core changes that
are pre-requesite of the HID work.

This revision of the series focused on those bpf-core changes with
a hopefully proper way of fixing access to ctx pointers, and a few more
selftests to cover those changes.

Once those bpf changes are in, the HID changes are pretty much self
consistent, which is a good thing, but I still wonder how we are going
to merge the selftests. I'd rather have the selftests in the bpf tree to
prevent any regression on bpf-core changes, but that might require some
coordination between the HID and bpf trees.

Anyway, let's hope we are getting closer to the end of those revisions :)

Cheers,
Benjamin


Benjamin Tissoires (23):
  selftests/bpf: regroup and declare similar kfuncs selftests in an
    array
  bpf: split btf_check_subprog_arg_match in two
  bpf/verifier: allow all functions to read user provided context
  selftests/bpf: add test for accessing ctx from syscall program type
  bpf/btf: bump BTF_KFUNC_SET_MAX_CNT
  bpf/verifier: allow kfunc to return an allocated mem
  selftests/bpf: Add tests for kfunc returning a memory pointer
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
  samples/bpf: HID: add new hid_mouse example
  samples/bpf: HID: add Surface Dial example
  Documentation: add HID-BPF docs

 Documentation/hid/hid-bpf.rst                 | 513 +++++++++
 Documentation/hid/index.rst                   |   1 +
 drivers/Makefile                              |   2 +-
 drivers/hid/Kconfig                           |  20 +-
 drivers/hid/Makefile                          |   2 +
 drivers/hid/bpf/Kconfig                       |  17 +
 drivers/hid/bpf/Makefile                      |  11 +
 drivers/hid/bpf/entrypoints/Makefile          |  93 ++
 drivers/hid/bpf/entrypoints/README            |   4 +
 drivers/hid/bpf/entrypoints/entrypoints.bpf.c |  66 ++
 .../hid/bpf/entrypoints/entrypoints.lskel.h   | 682 ++++++++++++
 drivers/hid/bpf/hid_bpf_dispatch.c            | 526 ++++++++++
 drivers/hid/bpf/hid_bpf_dispatch.h            |  28 +
 drivers/hid/bpf/hid_bpf_jmp_table.c           | 577 ++++++++++
 drivers/hid/hid-core.c                        |  49 +-
 include/linux/bpf.h                           |  11 +-
 include/linux/bpf_verifier.h                  |   2 +
 include/linux/btf.h                           |  10 +
 include/linux/hid.h                           |  38 +-
 include/linux/hid_bpf.h                       | 148 +++
 include/uapi/linux/hid.h                      |  26 +-
 include/uapi/linux/hid_bpf.h                  |  25 +
 kernel/bpf/btf.c                              | 149 ++-
 kernel/bpf/verifier.c                         |  66 +-
 net/bpf/test_run.c                            |  37 +
 samples/bpf/.gitignore                        |   2 +
 samples/bpf/Makefile                          |  27 +
 samples/bpf/hid_mouse.bpf.c                   | 134 +++
 samples/bpf/hid_mouse.c                       | 161 +++
 samples/bpf/hid_surface_dial.bpf.c            | 161 +++
 samples/bpf/hid_surface_dial.c                | 232 ++++
 tools/include/uapi/linux/hid.h                |  62 ++
 tools/include/uapi/linux/hid_bpf.h            |  25 +
 tools/testing/selftests/bpf/Makefile          |   2 +-
 tools/testing/selftests/bpf/config            |   3 +
 tools/testing/selftests/bpf/prog_tests/hid.c  | 990 ++++++++++++++++++
 .../selftests/bpf/prog_tests/kfunc_call.c     | 182 +++-
 tools/testing/selftests/bpf/progs/hid.c       | 206 ++++
 .../selftests/bpf/progs/kfunc_call_fail.c     | 160 +++
 .../selftests/bpf/progs/kfunc_call_test.c     |  71 ++
 40 files changed, 5416 insertions(+), 105 deletions(-)
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
 create mode 100644 tools/testing/selftests/bpf/progs/kfunc_call_fail.c

-- 
2.36.1

