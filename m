Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D05552C504
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 23:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242829AbiERU7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 16:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242800AbiERU7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 16:59:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A8E82265FB
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652907575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bdXZF7hJLZXmO2O05XdZLuUQ0VoAMlOFXmkOZbjXtSI=;
        b=UotNzwT6oyWF+uUaaXsHQfqmlB8cJoPkd6HxLctwMnIuXqu1csCE/78ol3ef4YnVcfmpKk
        i0Ocji4PLZ87QbF6IoO13XRB5plw3M4xBTMfc2s/ZeNOEPUb6DA3YhDBUcNhgxT29O1DXj
        1/7SwYLe4Hhu4vDexXvVULvxdmJQPa8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-541-TubvXEPFPX2YkucnXM8Arw-1; Wed, 18 May 2022 16:59:32 -0400
X-MC-Unique: TubvXEPFPX2YkucnXM8Arw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 01E603801FE1;
        Wed, 18 May 2022 20:59:31 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.58])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9906B2166B25;
        Wed, 18 May 2022 20:59:26 +0000 (UTC)
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
Subject: [PATCH bpf-next v5 00/17] Introduce eBPF support for HID devices
Date:   Wed, 18 May 2022 22:59:07 +0200
Message-Id: <20220518205924.399291-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

And here comes the v5 of the HID-BPF series.

I managed to achive the same functionalities than v3 this time.
Handling per-device BPF program was "interesting" to say the least,
but I don't know if we can have a generic BPF way of handling such
situation.

The interesting bits is that now the BPF core changes are rather small,
and I am mostly using existing facilities.
I didn't managed to write selftests for the RET_PTR_TO_MEM kfunc,
because I can not call kmalloc while in a SEC("tc") program to match
what the other kfunc tests are doing.
And AFAICT, the most interesting bits would be to implement verifier
selftests, which are way out of my league, given that they are
implemented as plain bytecode.

The logic is the following (see also the last patch for some more
documentation):
- hid-bpf first preloads a BPF program in the kernel that does a few
  things:
   * find out which attach_btf_id are associated with our trace points
   * adds a bpf_tail_call() BPF program that I can use to "call" any
     other BPF program stored into a jump table
   * monitors the releases of struct bpf_prog, and when there are no
     other users than us, detach the bpf progs from the HID devices
- users then declare their tracepoints and then call
  hid_bpf_attach_prog() in a SEC("syscall") program
- hid-bpf then calls multiple time the bpf_tail_call() program with a
  different index in the jump table whenever there is an event coming
  from a matching HID device

Note that I am tempted to pin an "attach_hid_program" in the bpffs so
that users don't need to declare one, but I am afraid this will be one
more API to handle, so maybe not.

I am also wondering if I should not strip out hid_bpf_jmp_table of most
of its features and implement everything as a BPF program. This might
remove the need to add the kernel light skeleton implementations of map
modifications, and might also possibly be more re-usable for other
subsystems. But every plan I do in my head involves a lot of back and
forth between the kernel and BPF to achieve the same, which doesn't feel
right. The tricky part is the RCU list of programs that is stored in each
device and also the global state of the jump table.
Anyway, something to look for in a next version if there is a push for it.

FWIW, patch 1 is something I'd like to get merged sooner. With 2
colleagues, we are also working on supporting the "revoke" functionality
of a fd for USB and for hidraw. While hidraw can be emulated with the
current features, we need the syscall kfuncs for USB, because when we
revoke a USB access, we also need to kick out the user, and for that, we
need to actually execute code in the kernel from a userspace event.

Anyway, happy reviewing.

Cheers,
Benjamin

[Patch series based on commit 68084a136420 ("selftests/bpf: Fix building bpf selftests statically")
in the bpf-next tree]

Benjamin Tissoires (17):
  bpf/btf: also allow kfunc in tracing and syscall programs
  bpf/verifier: allow kfunc to return an allocated mem
  bpf: prepare for more bpf syscall to be used from kernel and user
    space.
  libbpf: add map_get_fd_by_id and map_delete_elem in light skeleton
  HID: core: store the unique system identifier in hid_device
  HID: export hid_report_type to uapi
  HID: initial BPF implementation
  selftests/bpf: add tests for the HID-bpf initial implementation
  HID: bpf: allocate data memory for device_event BPF programs
  selftests/bpf/hid: add test to change the report size
  HID: bpf: introduce hid_hw_request()
  selftests/bpf: add tests for bpf_hid_hw_request
  HID: bpf: allow to change the report descriptor
  selftests/bpf: add report descriptor fixup tests
  samples/bpf: add new hid_mouse example
  selftests/bpf: Add a test for BPF_F_INSERT_HEAD
  Documentation: add HID-BPF docs

 Documentation/hid/hid-bpf.rst                 | 528 ++++++++++
 Documentation/hid/index.rst                   |   1 +
 drivers/hid/Kconfig                           |   2 +
 drivers/hid/Makefile                          |   2 +
 drivers/hid/bpf/Kconfig                       |  19 +
 drivers/hid/bpf/Makefile                      |  11 +
 drivers/hid/bpf/entrypoints/Makefile          |  88 ++
 drivers/hid/bpf/entrypoints/README            |   4 +
 drivers/hid/bpf/entrypoints/entrypoints.bpf.c |  78 ++
 .../hid/bpf/entrypoints/entrypoints.lskel.h   | 782 ++++++++++++++
 drivers/hid/bpf/hid_bpf_dispatch.c            | 565 ++++++++++
 drivers/hid/bpf/hid_bpf_dispatch.h            |  28 +
 drivers/hid/bpf/hid_bpf_jmp_table.c           | 587 +++++++++++
 drivers/hid/hid-core.c                        |  43 +-
 include/linux/btf.h                           |   7 +
 include/linux/hid.h                           |  29 +-
 include/linux/hid_bpf.h                       | 144 +++
 include/uapi/linux/hid.h                      |  12 +
 include/uapi/linux/hid_bpf.h                  |  25 +
 kernel/bpf/btf.c                              |  47 +-
 kernel/bpf/syscall.c                          |  10 +-
 kernel/bpf/verifier.c                         |  72 +-
 samples/bpf/.gitignore                        |   1 +
 samples/bpf/Makefile                          |  23 +
 samples/bpf/hid_mouse.bpf.c                   | 134 +++
 samples/bpf/hid_mouse.c                       | 157 +++
 tools/lib/bpf/skel_internal.h                 |  23 +
 tools/testing/selftests/bpf/config            |   3 +
 tools/testing/selftests/bpf/prog_tests/hid.c  | 990 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/hid.c       | 222 ++++
 30 files changed, 4593 insertions(+), 44 deletions(-)
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
 create mode 100644 tools/testing/selftests/bpf/prog_tests/hid.c
 create mode 100644 tools/testing/selftests/bpf/progs/hid.c

-- 
2.36.1

