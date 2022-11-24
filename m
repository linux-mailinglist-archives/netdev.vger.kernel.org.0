Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D169637CA0
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:17:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiKXPRI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:17:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiKXPRG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:17:06 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2BB1609FD
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:16:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669302971;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LUgA74J/++itggE2ifC+Q/hNt3kstw8hLv1rp9ic5GM=;
        b=BzN4PPbuKDKjxQZzl4YYD1jjP6k6hKE47DObe0prerpQf99Ozk4QkZkUy3ERy0wMq/ObX+
        RDWvy0tTj+QTiHdmCmkZYjyOxBya2EFA7JjmQpKKB/USR79ulqtT8jBexuOOuWTv4nWJUF
        pgC1hkrUTSW4Nnaj+Lai3bV0k+dNmQM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-ui-rpmSPOeqhXlg0WUIVrw-1; Thu, 24 Nov 2022 10:16:10 -0500
X-MC-Unique: ui-rpmSPOeqhXlg0WUIVrw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 93C5E2A2AD7C;
        Thu, 24 Nov 2022 15:16:09 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.193.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A517340C2064;
        Thu, 24 Nov 2022 15:16:07 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [RFC hid v1 00/10] HID-BPF: add support for in-tree BPF programs
Date:   Thu, 24 Nov 2022 16:15:53 +0100
Message-Id: <20221124151603.807536-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

sending this as an RFC because it's not complete, but I'd like to start
the discussion:

While presenting HID-BPF, I always mentioned that device fixes should be
integrated in the kernel. And I am trying to do that in this series.

Load a generic bpf from the kernel:
===================================

The first step is to be able to load that bpf program without knowing
its interface. So I studied the output of the light skeletons and
squized them into a simple C array. Then I wrote a BPF loader based on
that same skeleton, and now I can iterate over an array of BPF programs
and load the ones that match the device.

The step 0 in that translation was to generate a json instead of a
proper C header for the light skeleton. The idea is that I can then
transform that json into whatever I want, without having to mess up with
bpftool. IIRC this was briefly discussed at plumbers, so I hope this is
not too weird.

Pin the program to the bpffs:
=============================

AFAICT, the infrastructure is not completely ready to pin programs from
the kernel itself (outside of bpf_preload).

I encountered a few hiccups and I'd like to know if I am on the correct
path:
- to be able to pin to the bpffs, it first needs to be mounted by
  userspace. Should I add some sort of list of already available
  programs that would be picked up by the kernel when bpffs is mounted?

- I am not sure the way I added the pinned program is correct: I am
  reusing the skeleton of bpf_iter_link_pin_kernel(), but using
  kernel_path_create() in the same way bpf_obj_pin_user() does seems
  better, though I always get -ENOENT even with bpffs mounted.

- I also need to be able to add a hierarchy of directories in bpffs from
  the kernel, and this requires some more code digging... :)

Produce the actual "compiled" bpf program:
==========================================

The current code here relies on the user to run `make` in the
drivers/hid/bpf/progs directory to regenerate the files.
Leaving aside the fact that I need to check on how to make this step
integrated by the generic root-level make, I wonder if using python to
generate that file is OK.

I am not very happy to add a requirement to build the whole kernel, but
OTOH, writing the same tool in C is desperately annoying. I would rather
have a tool written in rust TBH, if rust is now part of the required
toolchain.

Ship the "compiled" bpf programs:
=================================

In this version, the bpf program is embedded in vmlinux, for no other
reasons that splitting that out in a module would require some more
effort before submitting that RFC (and subject to concurrency races when
a device has several interfaces at once).

However, I wonder what should be the final "product":

- In a first pass, I can keep the current form and have a dedicated
  kernel module that contains all of the bpf fixes. The kernel would
  load it, check for any match, pin the programs, and unload this kernel
  module.

  This works but isn't very modular as we just enable/ship all of the
  fixes or nothing.

- another idea I had, was to rely on the firmware kernel interface. Now
  that I have a simple "bpf module" format (or even the json file), I
  could "compile" it into a binary and then have the kernel request the
  firmware on a device plug. This way we don't load/unload a module at
  each plug, and we rely on the existing firmware capabilities.

  I really like this idea, but then I wonder how I can ship those
  firmwares. I'd like them to be tied to the currently running kernel,
  so should I namespace them in the firmware directory on install? Is
  there any other way to be able to have 2 or more firmwares depending
  on the kernel version?

I think that's it. Again, this series is just a PoC on top of
hid.git/for-6.2/hid-bpf, and I can change everything if I am not headed
to the correct direction.

Cheers,
Benjamin

Benjamin Tissoires (10):
  bpftool: generate json output of skeletons
  WIP: bpf: allow to pin programs from the kernel when bpffs is mounted
  HID: add a tool to convert a bpf source into a generic bpf loader
  HID: add the bpf loader that can attach a generic hid-bpf program
  HID: add report descriptor override for the X-Keys XK24
  selftests: hid: add vmtest.sh
  selftests: hid: Add a variant parameter so we can emulate specific
    devices
  selftests: hid: add XK-24 tests
  selftests: hid: ensure the program is correctly pinned
  wip: vmtest aarch64

 MAINTAINERS                                   |   1 +
 drivers/hid/bpf/Makefile                      |   3 +-
 drivers/hid/bpf/hid_bpf_dispatch.c            |   3 +-
 drivers/hid/bpf/hid_bpf_loader.c              | 243 +++++++++++++++
 drivers/hid/bpf/progs/Makefile                | 105 +++++++
 .../bpf/progs/b0003g0001v05F3p0405-xk24.bpf.c | 106 +++++++
 .../progs/b0003g0001v05F3p0405-xk24.hidbpf.h  | 292 ++++++++++++++++++
 drivers/hid/bpf/progs/hid_bpf.h               |  15 +
 drivers/hid/bpf/progs/hid_bpf_helpers.h       |  22 ++
 drivers/hid/bpf/progs/hid_bpf_progs.h         |  50 +++
 drivers/hid/hid-core.c                        |   2 +
 include/linux/bpf.h                           |   1 +
 include/linux/hid_bpf.h                       |   2 +
 kernel/bpf/inode.c                            |  41 ++-
 tools/bpf/bpftool/gen.c                       |  95 ++++++
 tools/hid/build_progs_list.py                 | 231 ++++++++++++++
 tools/testing/selftests/hid/.gitignore        |   1 +
 tools/testing/selftests/hid/config.aarch64    |  39 +++
 tools/testing/selftests/hid/config.common     | 241 +++++++++++++++
 tools/testing/selftests/hid/config.x86_64     |   4 +
 tools/testing/selftests/hid/hid_bpf.c         | 150 +++++++--
 tools/testing/selftests/hid/vmtest.sh         | 286 +++++++++++++++++
 22 files changed, 1907 insertions(+), 26 deletions(-)
 create mode 100644 drivers/hid/bpf/hid_bpf_loader.c
 create mode 100644 drivers/hid/bpf/progs/Makefile
 create mode 100644 drivers/hid/bpf/progs/b0003g0001v05F3p0405-xk24.bpf.c
 create mode 100644 drivers/hid/bpf/progs/b0003g0001v05F3p0405-xk24.hidbpf.h
 create mode 100644 drivers/hid/bpf/progs/hid_bpf.h
 create mode 100644 drivers/hid/bpf/progs/hid_bpf_helpers.h
 create mode 100644 drivers/hid/bpf/progs/hid_bpf_progs.h
 create mode 100755 tools/hid/build_progs_list.py
 create mode 100644 tools/testing/selftests/hid/config.aarch64
 create mode 100644 tools/testing/selftests/hid/config.common
 create mode 100644 tools/testing/selftests/hid/config.x86_64
 create mode 100755 tools/testing/selftests/hid/vmtest.sh

-- 
2.38.1

