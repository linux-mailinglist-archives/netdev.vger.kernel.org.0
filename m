Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1F0A4DDE1E
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 17:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238650AbiCRQRP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 12:17:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238640AbiCRQRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 12:17:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8810310874A
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 09:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647620151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=g1mbgj0kUt9HOlxHcHj225lXtzgiEcushRQUeJqOcqU=;
        b=g07WplWLJeIhknFRW82uRJ4k2wwXo9HeztD4DNO2sUdOCLFa0mAEH0qaK1vfn4HTMJPIDM
        pmCuDCAPDjYE2RfBMr2jgGLAMyXHr+OX+ubL9LQ6d24JbiknCiWoJHCU82dGzNlQQ53yBr
        QJX/6NzhtcHEmdluA8Egsz1rwlU+3Mg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-320-650TfjtuPgKGivDJH0xQBg-1; Fri, 18 Mar 2022 12:15:46 -0400
X-MC-Unique: 650TfjtuPgKGivDJH0xQBg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C2712800FFB;
        Fri, 18 Mar 2022 16:15:44 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A1407AD1;
        Fri, 18 Mar 2022 16:15:41 +0000 (UTC)
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
Subject: [PATCH bpf-next v3 00/17] Introduce eBPF support for HID devices
Date:   Fri, 18 Mar 2022 17:15:11 +0100
Message-Id: <20220318161528.1531164-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is a followup of my v1 at [0] and v2 at [1].

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


I think I addressed the comments from the previous version, but there are
a few things I'd like to note here:

- I did not take the various rev-by and tested-by (thanks a lot for those)
  because the uapi changed significantly in v3, so I am not very confident
  in taking those rev-by blindly

- I mentioned in my discussion with Song that I'll put a summary of the uapi
  in the cover letter, but I ended up adding a (long) file in the Documentation
  directory. So please maybe start by reading 17/17 to have an overview of
  what I want to achieve

- I added in the libbpf and bpf the new type BPF_HID_DRIVER_EVENT, even though
  I don't have a user of it right now in the kernel. I wanted to have them in
  the docs, but we might not want to have them ready here.
  In terms of code, it just means that we can attach such programs types
  but that they will never get triggered.

Anyway, I have been mulling on this for the past 2 weeks, and I think that
maybe sharing this now is better than me just starring at the code over and
over.


Short summary of changes:

v3:
===

- squashed back together most of the libbpf and bpf changes into bigger
  commits that give a better overview of the whole interactions

- reworked the user API to not expose .data as a directly accessible field
  from the context, but instead forces everyone to use hid_bpf_get_data (or
  get/set_bits)

- added BPF_HID_DRIVER_EVENT (see note above)

- addressed the various nitpicks from v2

- added a big Documentation file (and so adding now the doc maintainers to the
  long list of recipients)

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
[1] https://lore.kernel.org/linux-input/20220304172852.274126-1-benjamin.tissoires@redhat.com/T/#t


Benjamin Tissoires (17):
  bpf: add new is_sys_admin_prog_type() helper
  bpf: introduce hid program type
  bpf/verifier: prevent non GPL programs to be loaded against HID
  libbpf: add HID program type and API
  HID: hook up with bpf
  HID: allow to change the report descriptor from an eBPF program
  selftests/bpf: add tests for the HID-bpf initial implementation
  selftests/bpf: add report descriptor fixup tests
  selftests/bpf: Add a test for BPF_F_INSERT_HEAD
  selftests/bpf: add test for user call of HID bpf programs
  samples/bpf: add new hid_mouse example
  bpf/hid: add more HID helpers
  HID: bpf: implement hid_bpf_get|set_bits
  HID: add implementation of bpf_hid_raw_request
  selftests/bpf: add tests for hid_{get|set}_bits helpers
  selftests/bpf: add tests for bpf_hid_hw_request
  Documentation: add HID-BPF docs

 Documentation/hid/hid-bpf.rst                | 444 +++++++++++
 Documentation/hid/index.rst                  |   1 +
 drivers/hid/Makefile                         |   1 +
 drivers/hid/hid-bpf.c                        | 328 ++++++++
 drivers/hid/hid-core.c                       |  34 +-
 include/linux/bpf-hid.h                      | 127 +++
 include/linux/bpf_types.h                    |   4 +
 include/linux/hid.h                          |  36 +-
 include/uapi/linux/bpf.h                     |  67 ++
 include/uapi/linux/bpf_hid.h                 |  71 ++
 include/uapi/linux/hid.h                     |  10 +
 kernel/bpf/Makefile                          |   3 +
 kernel/bpf/btf.c                             |   1 +
 kernel/bpf/hid.c                             | 728 +++++++++++++++++
 kernel/bpf/syscall.c                         |  27 +-
 kernel/bpf/verifier.c                        |   7 +
 samples/bpf/.gitignore                       |   1 +
 samples/bpf/Makefile                         |   4 +
 samples/bpf/hid_mouse_kern.c                 | 117 +++
 samples/bpf/hid_mouse_user.c                 | 129 +++
 tools/include/uapi/linux/bpf.h               |  67 ++
 tools/lib/bpf/libbpf.c                       |  23 +-
 tools/lib/bpf/libbpf.h                       |   2 +
 tools/lib/bpf/libbpf.map                     |   1 +
 tools/testing/selftests/bpf/config           |   3 +
 tools/testing/selftests/bpf/prog_tests/hid.c | 788 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/hid.c      | 205 +++++
 27 files changed, 3204 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/hid/hid-bpf.rst
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

