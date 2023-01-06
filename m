Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B4965FEBC
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 11:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjAFKYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 05:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231514AbjAFKYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 05:24:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7972769504
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 02:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673000623;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Asorenzas+kjlhcMKAW/jVBQ4k5PIZb3mjnBvSPg95E=;
        b=ClvJYK+Ha7eCgS10gr78/4XQXHflwCuxcaRfVMLrVujLiRHehMhXhnoWdvubHr2vM6LZEY
        U9HyHLsjGBSzsUd39aLLBnRgWIRQf0mC9LNIB2dzkDb2qNYqGfF+pDQcqezhneCi7wcPhk
        Ww2zECOBPwZ0FC0CskS2BNIUoLMmveo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-6UQoocw_OkuXf3YWNdbAng-1; Fri, 06 Jan 2023 05:23:40 -0500
X-MC-Unique: 6UQoocw_OkuXf3YWNdbAng-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D679B85A588;
        Fri,  6 Jan 2023 10:23:39 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.192.97])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B38FFC15BAD;
        Fri,  6 Jan 2023 10:23:37 +0000 (UTC)
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
        linux-kselftest@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH HID for-next v1 0/9] HID-BPF LLVM fixes, no more hacks
Date:   Fri,  6 Jan 2023 11:23:23 +0100
Message-Id: <20230106102332.1019632-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

So this is the fix for the bug that actually prevented me to integrate
HID-BPF in v6.2.

While testing the code base with LLVM, I realized that clang was smarter
than I expected it to be, and it sometimes inlined a function or not
depending on the branch. This lead to segfaults because my current code
in linux-next is messing up the bpf programs refcounts assuming that I
had enough observability over the kernel.

So I came back to the drawing board and realized that what I was missing
was exactly a bpf_link, to represent the attachment of a bpf program to
a HID device. This is the bulk of the series, in patch 6/9.

The other patches are cleanups, tests, and also the addition of the
vmtests.sh script I run locally, largely inspired by the one in the bpf
selftests dir. This allows very fast development of HID-BPF, assuming we
have tests that cover the bugs :)

Cheers,
Benjamin


Benjamin Tissoires (9):
  selftests: hid: add vmtest.sh
  selftests: hid: allow to compile hid_bpf with LLVM
  selftests: hid: attach/detach 2 bpf programs, not just one
  selftests: hid: ensure the program is correctly pinned
  selftests: hid: prepare tests for HID_BPF API change
  HID: bpf: rework how programs are attached and stored in the kernel
  selftests: hid: enforce new attach API
  HID: bpf: clean up entrypoint
  HID: bpf: reorder BPF registration

 Documentation/hid/hid-bpf.rst                 |  12 +-
 drivers/hid/bpf/entrypoints/entrypoints.bpf.c |   9 -
 .../hid/bpf/entrypoints/entrypoints.lskel.h   | 188 ++++--------
 drivers/hid/bpf/hid_bpf_dispatch.c            |  28 +-
 drivers/hid/bpf/hid_bpf_dispatch.h            |   3 -
 drivers/hid/bpf/hid_bpf_jmp_table.c           | 116 +++----
 include/linux/hid_bpf.h                       |   7 +
 tools/testing/selftests/hid/.gitignore        |   1 +
 tools/testing/selftests/hid/Makefile          |  10 +-
 tools/testing/selftests/hid/config.common     | 241 +++++++++++++++
 tools/testing/selftests/hid/config.x86_64     |   4 +
 tools/testing/selftests/hid/hid_bpf.c         |  32 +-
 tools/testing/selftests/hid/progs/hid.c       |  13 +
 tools/testing/selftests/hid/vmtest.sh         | 284 ++++++++++++++++++
 14 files changed, 724 insertions(+), 224 deletions(-)
 create mode 100644 tools/testing/selftests/hid/config.common
 create mode 100644 tools/testing/selftests/hid/config.x86_64
 create mode 100755 tools/testing/selftests/hid/vmtest.sh

-- 
2.38.1

