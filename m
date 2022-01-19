Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25714493805
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 11:15:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353504AbiASKPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 05:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353474AbiASKPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 05:15:52 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2C97C061574;
        Wed, 19 Jan 2022 02:15:51 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id 7FB081F44427
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1642587349;
        bh=XYDVAxDFFZ3GjKZiYyLIQ7Ax/B1PlxHAo12P/LTWddY=;
        h=From:To:Cc:Subject:Date:From;
        b=QyNw3SnikBjxgmXldT58LDxt+66FxBTgRH/NFcT508gIl9Mo/FfR5aLJfGlutBmBh
         TiNACBRkmu1H+lpBMOChjSwlTXNzv/uov/IfDI5sCYV25iGqHYmXS9lE0rlQhLCnit
         KhRu728rGpQQTLF3vwYnT6k0kEOKnqaJC/O/C/ovuzrJf1x43QWkD4ZCVC9EG5h/83
         NGwXJjN/JtVN2u5Nvk/bBOIG80m3VM1PqMNzh56eDaoqadx2Jz1MrAjgesDzGW/T8Z
         wsGhO5dStqXKya0txfhufgUBcLmMBHnY1S1x0HOjI32Q/LEYyh5wGcxijiG8ugVVtl
         SFNIHZFa3tYcQ==
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
To:     Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        =?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@collabora.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        chiminghao <chi.minghao@zte.com.cn>,
        linux-kselftest@vger.kernel.org (open list:KERNEL SELFTEST FRAMEWORK),
        linux-kernel@vger.kernel.org (open list),
        kvm@vger.kernel.org (open list:KERNEL VIRTUAL MACHINE (KVM)),
        linux-security-module@vger.kernel.org (open list:LANDLOCK SECURITY
        MODULE), netdev@vger.kernel.org (open list:NETWORKING [GENERAL]),
        mptcp@lists.linux.dev (open list:NETWORKING [MPTCP]),
        linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        kernel@collabora.com
Subject: [PATCH V2 00/10] selftests: Fix separate output directory builds
Date:   Wed, 19 Jan 2022 15:15:21 +0500
Message-Id: <20220119101531.2850400-1-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Build of several selftests fail if separate output directory is
specified by the following methods:
1) make -C tools/testing/selftests O=<build_dir>
2) export KBUILD_OUTPUT="build_dir"; make -C tools/testing/selftests

Build fails because of several reasons:
1) The kernel headers aren't found.
2) The path of output objects is wrong and hence unaccessible.

These problems can be solved by:
1) Including the correct path of uapi header files
2) By setting the BUILD variable correctly inside Makefile

Following different build scenarios have been tested after making these
changes to verify that nothing gets broken with these changes:
make -C tools/testing/selftests
make -C tools/testing/selftests/futex
make -C tools/testing/selftests/kvm
make -C tools/testing/selftests/landlock
make -C tools/testing/selftests/net
make -C tools/testing/selftests/net/mptcp
make -C tools/testing/selftests/vm
make -C tools/testing/selftests O=build
make -C tools/testing/selftests o=/opt/build
export KBUILD_OUTPUT="/opt/build"; make -C tools/testing/selftests
export KBUILD_OUTPUT="build"; make -C tools/testing/selftests
cd <any_dir>; make -C <src_path>/tools/testing/selftests
cd <any_dir>; make -C <src_path>/tools/testing/selftests O=build

---
Changes in V2:
        Revert the excessive cleanup which was breaking the individual
test build.

Muhammad Usama Anjum (10):
  selftests: set the BUILD variable to absolute path
  selftests: Add and export a kernel uapi headers path
  selftests: Correct the headers install path
  selftests: futex: Add the uapi headers include variable
  selftests: kvm: Add the uapi headers include variable
  selftests: landlock: Add the uapi headers include variable
  selftests: net: Add the uapi headers include variable
  selftests: mptcp: Add the uapi headers include variable
  selftests: vm: Add the uapi headers include variable
  selftests: vm: remove dependecy from internal kernel macros

 tools/testing/selftests/Makefile              | 32 +++++++++++++------
 .../selftests/futex/functional/Makefile       |  5 ++-
 tools/testing/selftests/kvm/Makefile          |  2 +-
 tools/testing/selftests/landlock/Makefile     |  2 +-
 tools/testing/selftests/net/Makefile          |  2 +-
 tools/testing/selftests/net/mptcp/Makefile    |  2 +-
 tools/testing/selftests/vm/Makefile           |  2 +-
 tools/testing/selftests/vm/userfaultfd.c      |  3 ++
 8 files changed, 32 insertions(+), 18 deletions(-)

-- 
2.30.2

