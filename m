Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5DAB34446
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 12:18:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfFDKSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 06:18:39 -0400
Received: from conuserg-08.nifty.com ([210.131.2.75]:44024 "EHLO
        conuserg-08.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727139AbfFDKSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 06:18:39 -0400
Received: from localhost.localdomain (p14092-ipngnfx01kyoto.kyoto.ocn.ne.jp [153.142.97.92]) (authenticated)
        by conuserg-08.nifty.com with ESMTP id x54AEC76032511;
        Tue, 4 Jun 2019 19:14:12 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-08.nifty.com x54AEC76032511
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1559643254;
        bh=2Cnt75TjD0TucqN65Zm4F4aK2FsJEMupPn4+qQfaomQ=;
        h=From:To:Cc:Subject:Date:From;
        b=T4jvQ0G6x7AI4kdGX5qwlpK7HOvTaBPAv/cRO5t4X32Dcs0uPZAvSErXh4DSjGB31
         HcpKj3d7GK+dEJgeRDnlb3IgG5M1SUitGYK8fWYBHTStYwEem3M/mbalLmPcf7FXff
         2NyynthHyJ0CxXthF++gCaIlODh+BwsYOnM6Vm7DKEJGoJYT3haZXkmHOejQU4htdI
         qbLlQa5xUwjLEMB8M7yoUoLHvQw77TZmiZ2m1IsbGjpX7v+Ox9dBMBaEmddSnnMqUe
         FudqJKtGFxDLUHkFG12GbiN4Ma4TLji3PyPSof/DKDCjFWY8qenZH14JVAqU6EKQqf
         rZdDvtK1Yi38A==
X-Nifty-SrcIP: [153.142.97.92]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     linux-kbuild@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        David Howells <dhowells@redhat.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Jani Nikula <jani.nikula@intel.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-riscv@lists.infradead.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-s390@vger.kernel.org, Greentime Hu <green.hu@gmail.com>,
        Helge Deller <deller@gmx.de>,
        Vineet Gupta <vgupta@synopsys.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-snps-arc@lists.infradead.org,
        Song Liu <songliubraving@fb.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Yonghong Song <yhs@fb.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Paul Mackerras <paulus@samba.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Vasily Gorbik <gor@linux.ibm.com>,
        linux-parisc@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, Vincent Chen <deanbo422@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 00/15] kbuild: refactor headers_install and support compile-test of UAPI headers
Date:   Tue,  4 Jun 2019 19:13:54 +0900
Message-Id: <20190604101409.2078-1-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Multiple people have suggested to compile-test UAPI headers.

Currently, Kbuild provides simple sanity checks by headers_check
but they are not enough to catch bugs.

The most recent patch I know is David Howells' work:
https://patchwork.kernel.org/patch/10590203/

I agree that we need better tests for UAPI headers,
but I want to integrate it in a clean way.

The idea that has been in my mind is to compile each header
to make sure the selfcontainedness.

Recently, Jani Nikula proposed a new syntax 'header-test-y'.
https://patchwork.kernel.org/patch/10947005/

So, I implemented UAPI compile-testing on top of that.

When adding a new feature, cleaning the code first is a
good practice.

[1] Remove headers_install_all

This target installs UAPI headers of all architectures
in a single tree.
It does not make sense to compile test of headers from
multiple arches at the same time. Hence, removed.

[2] Split header installation into 'make headers' and 'make headers_install'

To compile-test UAPI headers, we need a work-directory somewhere
to save objects and .*.cmd files.

usr/include/ will be the work-directory.

Since we cannot pollute the final destination of headers_install,

I split the header installation into two stages.

'make headers' will build up
the ready-to-install headers in usr/include,
which will be also used as a work-directory for the compile-test.

'make headers_install' will copy headers
from usr/include to $(INSTALL_HDR_PATH)/include.

[3] Support compile-test of UAPI headers

This is implemented in usr/include/Makefile


Jani Nikula (1):
  kbuild: add support for ensuring headers are self-contained

Masahiro Yamada (14):
  kbuild: remove headers_{install,check}_all
  kbuild: remove stale dependency between Documentation/ and
    headers_install
  kbuild: make gdb_script depend on prepare0 instead of prepare
  kbuild: fix Kconfig prompt of CONFIG_HEADERS_CHECK
  kbuild: add CONFIG_HEADERS_INSTALL and loosen the dependency of
    samples
  kbuild: remove build_unifdef target in scripts/Makefile
  kbuild: build all prerequisite of headers_install simultaneously
  kbuild: add 'headers' target to build up ready-to-install uapi headers
  kbuild: re-implement Makefile.headersinst without directory descending
  kbuild: move hdr-inst shorthand to top Makefile
  kbuild: simplify scripts/headers_install.sh
  kbuild: deb-pkg: do not run headers_check
  fixup: kbuild: add support for ensuring headers are self-contained
  kbuild: compile test UAPI headers to ensure they are self-contained

 Documentation/kbuild/headers_install.txt |   7 --
 Documentation/kbuild/makefiles.txt       |  13 ++-
 Makefile                                 |  56 +++++-----
 arch/arc/configs/tb10x_defconfig         |   1 +
 arch/nds32/configs/defconfig             |   1 +
 arch/parisc/configs/a500_defconfig       |   1 +
 arch/parisc/configs/b180_defconfig       |   1 +
 arch/parisc/configs/c3000_defconfig      |   1 +
 arch/parisc/configs/default_defconfig    |   1 +
 arch/powerpc/configs/ppc6xx_defconfig    |   1 +
 arch/s390/configs/debug_defconfig        |   1 +
 include/uapi/{linux => }/Kbuild          |   6 +-
 init/Kconfig                             |  20 ++++
 lib/Kconfig.debug                        |  25 +++--
 samples/Kconfig                          |  14 ++-
 samples/Makefile                         |   4 +-
 scripts/Kbuild.include                   |   6 --
 scripts/Makefile                         |   5 -
 scripts/Makefile.build                   |   9 ++
 scripts/Makefile.headersinst             | 132 ++++++++++-------------
 scripts/Makefile.lib                     |   3 +
 scripts/cc-system-headers.sh             |   8 ++
 scripts/headers.sh                       |  29 -----
 scripts/headers_install.sh               |  48 ++++-----
 scripts/package/builddeb                 |   2 +-
 usr/.gitignore                           |   1 -
 usr/Makefile                             |   2 +
 usr/include/.gitignore                   |   3 +
 usr/include/Makefile                     | 132 +++++++++++++++++++++++
 29 files changed, 329 insertions(+), 204 deletions(-)
 rename include/uapi/{linux => }/Kbuild (77%)
 create mode 100755 scripts/cc-system-headers.sh
 delete mode 100755 scripts/headers.sh
 create mode 100644 usr/include/.gitignore
 create mode 100644 usr/include/Makefile

-- 
2.17.1

