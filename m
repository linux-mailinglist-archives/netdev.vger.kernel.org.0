Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36C66669283
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 10:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241118AbjAMJMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 04:12:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbjAMJMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 04:12:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7044938C
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 01:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673600985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=X4OMapMn4DPgQ6a+VqmEJlLUwkXj3/OngbIshLVda8U=;
        b=TtUVPtWnnN87PUcIZ0SOYL4gWxqHv2dHdAuokZm34KTtXQ7uKhmj/ZkFb5dGJNVa5yFY4s
        rCbSxw3Bjri1pDy/tLU+BKecQfIUXNpdZxskAzUgutVh8RfP1d1N5eaiNXlACoDoHU4s+n
        wFA49rG7zyAAV83r/agZVtny4jyJ/W4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-577-hrpH9WwZOmmcyoABtpkYUQ-1; Fri, 13 Jan 2023 04:09:40 -0500
X-MC-Unique: hrpH9WwZOmmcyoABtpkYUQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA3C6858F0E;
        Fri, 13 Jan 2023 09:09:39 +0000 (UTC)
Received: from plouf.redhat.com (ovpn-193-50.brq.redhat.com [10.40.193.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 529D11121314;
        Fri, 13 Jan 2023 09:09:37 +0000 (UTC)
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
Subject: [PATCH HID for-next v2 0/9] HID-BPF LLVM fixes, no more hacks
Date:   Fri, 13 Jan 2023 10:09:26 +0100
Message-Id: <20230113090935.1763477-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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


changes in v2:
- took Alexei's remarks into account and renamed the indexes into
  prog_table_index and hid_table_index
- fixed unused function as reported by the Intel kbuild bot


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
 drivers/hid/bpf/hid_bpf_jmp_table.c           | 129 ++++----
 include/linux/hid_bpf.h                       |   7 +
 tools/testing/selftests/hid/.gitignore        |   1 +
 tools/testing/selftests/hid/Makefile          |  10 +-
 tools/testing/selftests/hid/config.common     | 241 +++++++++++++++
 tools/testing/selftests/hid/config.x86_64     |   4 +
 tools/testing/selftests/hid/hid_bpf.c         |  32 +-
 tools/testing/selftests/hid/progs/hid.c       |  13 +
 tools/testing/selftests/hid/vmtest.sh         | 284 ++++++++++++++++++
 14 files changed, 728 insertions(+), 233 deletions(-)
 create mode 100644 tools/testing/selftests/hid/config.common
 create mode 100644 tools/testing/selftests/hid/config.x86_64
 create mode 100755 tools/testing/selftests/hid/vmtest.sh

-- 
2.38.1

