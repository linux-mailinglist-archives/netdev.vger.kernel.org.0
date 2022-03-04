Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E65B4CDA62
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 18:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239841AbiCDRaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 12:30:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238791AbiCDRaE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 12:30:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F37A14562B
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 09:29:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646414955;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=JLcaNFoE2+O0p0Og9VR8JqYYYchyQ3ie9yDd/O1/oyc=;
        b=Uftmb+VjS2N6+nd06Mc+vE1JOImM/86003dFyQEcGJRkLSQ13UvUxScsXboK2GFiDcO1BS
        JlVWkC5+4FGPPc37ekz7yYoNh2HS3+bia2zWWn+ESwka5dlSGHOLml66u9XcXuK0iepmDX
        PUgKONVBrtFsa45h2W/lgg+E/XlAUrU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-k_uNrN6uNGuz396T5P2sYg-1; Fri, 04 Mar 2022 12:29:12 -0500
X-MC-Unique: k_uNrN6uNGuz396T5P2sYg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CF521006AA5;
        Fri,  4 Mar 2022 17:29:09 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E74386599;
        Fri,  4 Mar 2022 17:28:58 +0000 (UTC)
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
        Joe Stringer <joe@cilium.io>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH bpf-next v2 00/28] Introduce eBPF support for HID devices
Date:   Fri,  4 Mar 2022 18:28:24 +0100
Message-Id: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is a followup of my v1 at [0].

The short summary of the previous cover letter and discussions is that
HID could benefit from BPF for the following use cases:

- simple fixup of report descriptor:
  benefits are faster development time and testing, with the produced
  bpf program being shipped in the kernel directly (the shipping part
  is *not* addressed here).

- Universal Stylus Interface:
  allows a user-space program to define its own kernel interface

- Surface Dial:
  somehow similar to the previous one except that userspace can decide
  to change the shape of the exported device

- firewall:
  still partly missing there, there is not yet interception of hidraw
  calls, but it's coming in a followup series, I promise

- tracing:
  well, tracing.


I tried to address as many comments as I could and here is the short log
of changes:

v2:
===

- split the series by subsystem (bpf, HID, libbpf, selftests and
  samples)

- Added an extra patch at the beginning to not require CAP_NET_ADMIN for
  BPF_PROG_TYPE_LIRC_MODE2 (please shout if this is wrong)

- made the bpf context attached to HID program of dynamic size:
  * the first 1 kB will be able to be addressed directly
  * the rest can be retrieved through bpf_hid_{set|get}_data
    (note that I am definitivey not happy with that API, because there
    is part of it in bits and other in bytes. ouch)

- added an extra patch to prevent non GPL HID bpf programs to be loaded
  of type BPF_PROG_TYPE_HID
  * same here, not really happy but I don't know where to put that check
    in verifier.c

- added a new flag BPF_F_INSERT_HEAD for BPF_LINK_CREATE syscall when in
  used with HID program types.
  * this flag is used for tracing, to be able to load a program before
    any others that might already have been inserted and that might
    change the data stream.

Cheers,
Benjamin



[0] https://lore.kernel.org/linux-input/20220224110828.2168231-1-benjamin.tissoires@redhat.com/T/#t


Benjamin Tissoires (28):
  bpf: add new is_sys_admin_prog_type() helper
  bpf: introduce hid program type
  HID: hook up with bpf
  libbpf: add HID program type and API
  selftests/bpf: add tests for the HID-bpf initial implementation
  samples/bpf: add new hid_mouse example
  bpf/hid: add a new attach type to change the report descriptor
  HID: allow to change the report descriptor from an eBPF program
  libbpf: add new attach type BPF_HID_RDESC_FIXUP
  selftests/bpf: add report descriptor fixup tests
  samples/bpf: add a report descriptor fixup
  bpf/hid: add hid_{get|set}_data helpers
  HID: bpf: implement hid_bpf_get|set_data
  selftests/bpf: add tests for hid_{get|set}_data helpers
  bpf/hid: add new BPF type to trigger commands from userspace
  libbpf: add new attach type BPF_HID_USER_EVENT
  selftests/bpf: add test for user call of HID bpf programs
  selftests/bpf: hid: rely on uhid event to know if a test device is
    ready
  bpf/hid: add bpf_hid_raw_request helper function
  HID: add implementation of bpf_hid_raw_request
  selftests/bpf: add tests for bpf_hid_hw_request
  bpf/verifier: prevent non GPL programs to be loaded against HID
  HID: bpf: compute only the required buffer size for the device
  HID: bpf: only call hid_bpf_raw_event() if a ctx is available
  bpf/hid: Add a flag to add the program at the beginning of the list
  libbpf: add handling for BPF_F_INSERT_HEAD in HID programs
  selftests/bpf: Add a test for BPF_F_INSERT_HEAD
  samples/bpf: fix bpf_program__attach_hid() api change

 drivers/hid/Makefile                         |   1 +
 drivers/hid/hid-bpf.c                        | 361 +++++++++
 drivers/hid/hid-core.c                       |  34 +-
 include/linux/bpf-hid.h                      | 129 +++
 include/linux/bpf_types.h                    |   4 +
 include/linux/hid.h                          |  25 +
 include/uapi/linux/bpf.h                     |  59 ++
 include/uapi/linux/bpf_hid.h                 |  50 ++
 kernel/bpf/Makefile                          |   3 +
 kernel/bpf/hid.c                             | 652 +++++++++++++++
 kernel/bpf/syscall.c                         |  26 +-
 kernel/bpf/verifier.c                        |   7 +
 samples/bpf/.gitignore                       |   1 +
 samples/bpf/Makefile                         |   4 +
 samples/bpf/hid_mouse_kern.c                 |  91 +++
 samples/bpf/hid_mouse_user.c                 | 129 +++
 tools/include/uapi/linux/bpf.h               |  59 ++
 tools/lib/bpf/libbpf.c                       |  22 +-
 tools/lib/bpf/libbpf.h                       |   2 +
 tools/lib/bpf/libbpf.map                     |   1 +
 tools/testing/selftests/bpf/prog_tests/hid.c | 788 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/hid.c      | 216 +++++
 22 files changed, 2649 insertions(+), 15 deletions(-)
 create mode 100644 drivers/hid/hid-bpf.c
 create mode 100644 include/linux/bpf-hid.h
 create mode 100644 include/uapi/linux/bpf_hid.h
 create mode 100644 kernel/bpf/hid.c
 create mode 100644 samples/bpf/hid_mouse_kern.c
 create mode 100644 samples/bpf/hid_mouse_user.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/hid.c
 create mode 100644 tools/testing/selftests/bpf/progs/hid.c

-- 
2.35.1

