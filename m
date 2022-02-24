Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47CE84C2A68
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 12:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbiBXLJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 06:09:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbiBXLJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 06:09:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D5931D198B
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 03:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645700935;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ew2uiDPIHxvTCVcjyHAafYa2L1bDx5BAahQa52A1Fps=;
        b=he5hB96+8JVbqHMJ/UxrbQBYCra/ojrP4FaQpIM54+X7RxcXPb6h7l9JHIahU/UcOf+yB7
        xbYTt5QtghqWHZK4T1uH6eMxnFmbO0h+9FTj74upG4q2O3TqFfFvpzZwFqme3+Jjgdty2R
        21YFvDaN2I/gWuuCXFlbe8mLv10a2/Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-J33YmlWkOXiYwXfOB-Uq4w-1; Thu, 24 Feb 2022 06:08:49 -0500
X-MC-Unique: J33YmlWkOXiYwXfOB-Uq4w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D08151D5;
        Thu, 24 Feb 2022 11:08:47 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.194.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A7AF79A22;
        Thu, 24 Feb 2022 11:08:33 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Jiri Kosina <jikos@kernel.org>,
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
Subject: [PATCH bpf-next v1 0/6] Introduce eBPF support for HID devices
Date:   Thu, 24 Feb 2022 12:08:22 +0100
Message-Id: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi there,

This series introduces support of eBPF for HID devices.

I have several use cases where eBPF could be interesting for those
input devices:

- simple fixup of report descriptor:

In the HID tree, we have half of the drivers that are "simple" and
that just fix one key or one byte in the report descriptor.
Currently, for users of such devices, the process of fixing them
is long and painful.
With eBPF, we could externalize those fixups in one external repo,
ship various CoRe bpf programs and have those programs loaded at boot
time without having to install a new kernel (and wait 6 months for the
fix to land in the distro kernel)

- Universal Stylus Interface (or any other new fancy feature that
  requires a new kernel API)

See [0].
Basically, USI pens are requiring a new kernel API because there are
some channels of communication our HID and input stack are not capable
of. Instead of using hidraw or creating new sysfs or ioctls, we can rely
on eBPF to have the kernel API controlled by the consumer and to not
impact the performances by waking up userspace every time there is an
event.

- Surface Dial

This device is a "puck" from Microsoft, basically a rotary dial with a
push button. The kernel already exports it as such but doesn't handle
the haptic feedback we can get out of it.
Furthermore, that device is not recognized by userspace and so it's a
nice paperwight in the end.

With eBPF, we can morph that device into a mouse, and convert the dial
events into wheel events. Also, we can set/unset the haptic feedback
from userspace. The convenient part of BPF makes it that the kernel
doesn't make any choice that would need to be reverted because that
specific userspace doesn't handle it properly or because that other
one expects it to be different.

- firewall

What if we want to prevent other users to access a specific feature of a
device? (think a possibly bonker firmware update entry popint)
With eBPF, we can intercept any HID command emitted to the device and
validate it or not.
This also allows to sync the state between the userspace and the
kernel/bpf program because we can intercept any incoming command.

- tracing

The last usage I have in mind is tracing events and all the fun we can
do we BPF to summarize and analyze events.
Right now, tracing relies on hidraw. It works well except for a couple
of issues:
 1. if the driver doesn't export a hidraw node, we can't trace anything
    (eBPF will be a "god-mode" there, so it might raise some eyebrows)
 2. hidraw doesn't catch the other process requests to the device, which
    means that we have cases where we need to add printks to the kernel
    to understand what is happening.


With that long introduction, here is the v1 of the support of eBPF in
HID.

I have targeted bpf-next here because the parts that will have the most
conflicts are in bpf. There might be a trivial minor conflict in
include/linux/hid.h with an other series I have pending[1].

I am relatively new to bpf, so having some feedback would be most very
welcome.

A couple of notes though:

- The series is missing a SEC("hid/driver_event") which would allow to
  intercept incoming requests to the device from anybody. I left it
  outside because it's not critical to have it from day one (we are more
  interested right now by the USI case above)

- I am still wondering how to integrate the tracing part:
  right now, if a bpf program is loaded before we start the tracer, we
  will see *modified* events in the tracer. However, it might be
  interesting to decide to see either unmodified (raw events from the
  device) or modified events.
  I think a flag might be able to solve that. The flag will control
  whether we add the new program at the beginning of the list or at the
  tail, but I am not sure if this is common practice in eBPF or if
  there is a better way.

Cheers,
Benjamin


[0] https://lore.kernel.org/linux-input/20211215134220.1735144-1-tero.kristo@linux.intel.com/
[1] https://lore.kernel.org/linux-input/20220203143226.4023622-1-benjamin.tissoires@redhat.com/


Benjamin Tissoires (6):
  HID: initial BPF implementation
  HID: bpf: allow to change the report descriptor from an eBPF program
  HID: bpf: add hid_{get|set}_data helpers
  HID: bpf: add new BPF type to trigger commands from userspace
  HID: bpf: tests: rely on uhid event to know if a test device is ready
  HID: bpf: add bpf_hid_raw_request helper function

 drivers/hid/Makefile                         |   1 +
 drivers/hid/hid-bpf.c                        | 327 +++++++++
 drivers/hid/hid-core.c                       |  31 +-
 include/linux/bpf-hid.h                      |  98 +++
 include/linux/bpf_types.h                    |   4 +
 include/linux/hid.h                          |  25 +
 include/uapi/linux/bpf.h                     |  33 +
 include/uapi/linux/bpf_hid.h                 |  56 ++
 kernel/bpf/Makefile                          |   3 +
 kernel/bpf/hid.c                             | 653 ++++++++++++++++++
 kernel/bpf/syscall.c                         |  12 +
 samples/bpf/.gitignore                       |   1 +
 samples/bpf/Makefile                         |   4 +
 samples/bpf/hid_mouse_kern.c                 |  91 +++
 samples/bpf/hid_mouse_user.c                 | 129 ++++
 tools/include/uapi/linux/bpf.h               |  33 +
 tools/lib/bpf/libbpf.c                       |   9 +
 tools/lib/bpf/libbpf.h                       |   2 +
 tools/lib/bpf/libbpf.map                     |   1 +
 tools/testing/selftests/bpf/prog_tests/hid.c | 685 +++++++++++++++++++
 tools/testing/selftests/bpf/progs/hid.c      | 149 ++++
 21 files changed, 2339 insertions(+), 8 deletions(-)
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

