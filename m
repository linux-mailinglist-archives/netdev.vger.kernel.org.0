Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82D3A3806A1
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 12:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232633AbhENKDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 06:03:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230023AbhENKDR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 06:03:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB4D2613BC;
        Fri, 14 May 2021 10:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620986526;
        bh=GrjPHc36lucdUSuooC9aqhL2Od7+jfK0fPUigqnZcVA=;
        h=From:To:Cc:Subject:Date:From;
        b=iCIXGblwqBis0HCCaKglHVxXgHdjY+ZnJUEpxhS25qd0YTOmPIMwFqlt0gAwqFaCn
         H6TYlYBWCxImWVPxQaXnme+hpROYqMTCLF2Ei6uKrfHadRhs+ayz5bA3lk5FtTeO/J
         kbiLtSut3lU229IM7sF582cRjJivSN3xcEhAoo9aZUac6zWidfJ8NHVAJjY3Rp7yEE
         dYKIekHBKs/JVyWBTb6nx0reJMz2nGFhAf8LBgLNfsP72b9qNOGH6t05d70F9GjPY+
         8sZc7aQR/6sMfmjSb+dYlYAWu/wuLtjPqPhcgnm4RJEAMEiB7smvyJnpuMYADmfYdd
         sGrgg1bm/9cMA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     linux-arch@vger.kernel.org
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Borislav Petkov <bp@alien8.de>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        James Morris <jmorris@namei.org>, Jens Axboe <axboe@kernel.dk>,
        John Johansen <john.johansen@canonical.com>,
        Jonas Bonn <jonas@southpole.se>,
        Kalle Valo <kvalo@codeaurora.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rich Felker <dalias@libc.org>,
        "Richard Russon (FlatCap)" <ldm@flatcap.org>,
        Russell King <linux@armlinux.org.uk>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Stafford Horne <shorne@gmail.com>,
        Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-m68k@lists.linux-m68k.org, linux-crypto@vger.kernel.org,
        openrisc@lists.librecores.org, linuxppc-dev@lists.ozlabs.org,
        linux-sh@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, linux-block@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: [PATCH v2 00/13] Unify asm/unaligned.h around struct helper
Date:   Fri, 14 May 2021 12:00:48 +0200
Message-Id: <20210514100106.3404011-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The get_unaligned()/put_unaligned() helpers are traditionally architecture
specific, with the two main variants being the "access-ok.h" version
that assumes unaligned pointer accesses always work on a particular
architecture, and the "le-struct.h" version that casts the data to a
byte aligned type before dereferencing, for architectures that cannot
always do unaligned accesses in hardware.

Based on the discussion linked below, it appears that the access-ok
version is not realiable on any architecture, but the struct version
probably has no downsides. This series changes the code to use the
same implementation on all architectures, addressing the few exceptions
separately.

I've included this version in the asm-generic tree for 5.14 already,
addressing the few issues that were pointed out in the RFC. If there
are any remaining problems, I hope those can be addressed as follow-up
patches.

        Arnd

Link: https://lore.kernel.org/lkml/75d07691-1e4f-741f-9852-38c0b4f520bc@synopsys.com/
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=100363
Link: https://lore.kernel.org/lkml/20210507220813.365382-14-arnd@kernel.org/
Link: git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git unaligned-rework-v2


Arnd Bergmann (13):
  asm-generic: use asm-generic/unaligned.h for most architectures
  openrisc: always use unaligned-struct header
  sh: remove unaligned access for sh4a
  m68k: select CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
  powerpc: use linux/unaligned/le_struct.h on LE power7
  asm-generic: unaligned: remove byteshift helpers
  asm-generic: unaligned always use struct helpers
  partitions: msdos: fix one-byte get_unaligned()
  apparmor: use get_unaligned() only for multi-byte words
  mwifiex: re-fix for unaligned accesses
  netpoll: avoid put_unaligned() on single character
  asm-generic: uaccess: 1-byte access is always aligned
  asm-generic: simplify asm/unaligned.h

 arch/alpha/include/asm/unaligned.h          |  12 --
 arch/arm/include/asm/unaligned.h            |  27 ---
 arch/ia64/include/asm/unaligned.h           |  12 --
 arch/m68k/Kconfig                           |   1 +
 arch/m68k/include/asm/unaligned.h           |  26 ---
 arch/microblaze/include/asm/unaligned.h     |  27 ---
 arch/mips/crypto/crc32-mips.c               |   2 +-
 arch/openrisc/include/asm/unaligned.h       |  47 -----
 arch/parisc/include/asm/unaligned.h         |   6 +-
 arch/powerpc/include/asm/unaligned.h        |  22 ---
 arch/sh/include/asm/unaligned-sh4a.h        | 199 --------------------
 arch/sh/include/asm/unaligned.h             |  13 --
 arch/sparc/include/asm/unaligned.h          |  11 --
 arch/x86/include/asm/unaligned.h            |  15 --
 arch/xtensa/include/asm/unaligned.h         |  29 ---
 block/partitions/ldm.h                      |   2 +-
 block/partitions/msdos.c                    |   2 +-
 drivers/net/wireless/marvell/mwifiex/pcie.c |  10 +-
 include/asm-generic/uaccess.h               |   4 +-
 include/asm-generic/unaligned.h             | 141 +++++++++++---
 include/linux/unaligned/access_ok.h         |  68 -------
 include/linux/unaligned/be_byteshift.h      |  71 -------
 include/linux/unaligned/be_memmove.h        |  37 ----
 include/linux/unaligned/be_struct.h         |  37 ----
 include/linux/unaligned/generic.h           | 115 -----------
 include/linux/unaligned/le_byteshift.h      |  71 -------
 include/linux/unaligned/le_memmove.h        |  37 ----
 include/linux/unaligned/le_struct.h         |  37 ----
 include/linux/unaligned/memmove.h           |  46 -----
 net/core/netpoll.c                          |   4 +-
 security/apparmor/policy_unpack.c           |   2 +-
 31 files changed, 131 insertions(+), 1002 deletions(-)
 delete mode 100644 arch/alpha/include/asm/unaligned.h
 delete mode 100644 arch/arm/include/asm/unaligned.h
 delete mode 100644 arch/ia64/include/asm/unaligned.h
 delete mode 100644 arch/m68k/include/asm/unaligned.h
 delete mode 100644 arch/microblaze/include/asm/unaligned.h
 delete mode 100644 arch/openrisc/include/asm/unaligned.h
 delete mode 100644 arch/powerpc/include/asm/unaligned.h
 delete mode 100644 arch/sh/include/asm/unaligned-sh4a.h
 delete mode 100644 arch/sh/include/asm/unaligned.h
 delete mode 100644 arch/sparc/include/asm/unaligned.h
 delete mode 100644 arch/x86/include/asm/unaligned.h
 delete mode 100644 arch/xtensa/include/asm/unaligned.h
 delete mode 100644 include/linux/unaligned/access_ok.h
 delete mode 100644 include/linux/unaligned/be_byteshift.h
 delete mode 100644 include/linux/unaligned/be_memmove.h
 delete mode 100644 include/linux/unaligned/be_struct.h
 delete mode 100644 include/linux/unaligned/generic.h
 delete mode 100644 include/linux/unaligned/le_byteshift.h
 delete mode 100644 include/linux/unaligned/le_memmove.h
 delete mode 100644 include/linux/unaligned/le_struct.h
 delete mode 100644 include/linux/unaligned/memmove.h

-- 
2.29.2

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Ganapathi Bhat <ganapathi017@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: James Morris <jmorris@namei.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: John Johansen <john.johansen@canonical.com>
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rich Felker <dalias@libc.org>
Cc: "Richard Russon (FlatCap)" <ldm@flatcap.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Sharvari Harisangam <sharvari.harisangam@nxp.com>
Cc: Stafford Horne <shorne@gmail.com>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: Xinming Hu <huxinming820@gmail.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-m68k@lists.linux-m68k.org
Cc: linux-crypto@vger.kernel.org
Cc: openrisc@lists.librecores.org
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-sh@vger.kernel.org
Cc: sparclinux@vger.kernel.org
Cc: linux-ntfs-dev@lists.sourceforge.net
Cc: linux-block@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-arch@vger.kernel.org
Cc: linux-security-module@vger.kernel.org


