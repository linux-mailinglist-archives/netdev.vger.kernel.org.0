Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7383DEC55
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235753AbhHCLlQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:32822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235596AbhHCLlP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:41:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0EC7B60560;
        Tue,  3 Aug 2021 11:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627990864;
        bh=tgIXMlrpgPMftjmh86rBN4lsD6F7+4KJtVtcFSF6V4E=;
        h=From:To:Cc:Subject:Date:From;
        b=oBnNB3SzVNE2Pp9w9eeN5zhzRm1zPW5HR/13j1cITjW4sHdJkVDPtu3dFIehB8XS4
         S+j8b434iWqMB+dPSJYVsqhdlm7wlQRyoDmAslwxwbXqLRWocJRa3ykdZ49d2o/0GP
         sJjq1kxh81hsxVUR1Y576YrU815sgjfmQ//D5LaLRV9e4T/TJhVJAnhahWfFwmiOpo
         UaZ/rmjTEIKRN6JFzqFPpKxTqabyx/IWVdVn/b+zhORZGiObCtN2Ig48r8PlYP79wq
         o2N5UzA9DBA2j6mqMPqfIueylbZjfk/2/n0cOX/RHWlmrDC8EZK4SK7o9rxr+RDu7J
         zFfnNCtJOlGiA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Doug Berger <opendmb@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sam Creasey <sammy@sammy.net>, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH v2 00/14] [net-next] drivers/net/Space.c cleanup
Date:   Tue,  3 Aug 2021 13:40:37 +0200
Message-Id: <20210803114051.2112986-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

I discovered that there are still a couple of drivers that rely on
beiong statically initialized from drivers/net/Space.c the way
we did in the last century. As it turns out, there are a couple
of simplifications that can be made here, as well as some minor
bugfixes.

There are four classes of drivers that use this:

- most 10mbit ISA bus ethernet drivers (and one 100mbit one)
- both ISA localtalk drivers
- several m68k ethernet drivers
- one obsolete WAN driver

I found that the drivers using in arch/m68k/ don't actually benefit
from being probed this way as they do not rely on the netdev= command
line arguments, they have simply never been changed to work like a
modern driver.

I had previously sent a patch to remove the sbni/granch driver, and
there were no objections to this patch but forgot to resend it after
some discussion about another patch in the same series.

For the ISA drivers, there is usually no way to probe multiple devices
at boot time other than the netdev= arguments, so all that logic is left
in place for the moment, but centralized in a single file that only gets
included in the kernel build if one or more of the drivers are built-in.

I'm also changing the old-style init_module() functions in these drivers
to static functions with a module_init() annotation, to more closely
resemble modern drivers. These are the last drivers in the kernel to
still use init_module/cleanup_module, removing those may enable future
cleanups to the module loading process.

       Arnd

Changes in v2:

- replace xsurf100 change with Michael's version
- make it PATCH instead of RFC
- rebase to net-next as of August 3

Arnd Bergmann (12):
  [net-next] bcmgenet: remove call to netdev_boot_setup_check
  [net-next] natsemi: sonic: stop calling netdev_boot_setup_check
  [net-next] appletalk: ltpc: remove static probing
  [net-next] 3c509: stop calling netdev_boot_setup_check
  [net-next] cs89x0: rework driver configuration
  [net-next] m68k: remove legacy probing
  [net-next] move netdev_boot_setup into Space.c
  [net-next] make legacy ISA probe optional
  [net-next] wan: remove stale Kconfig entries
  [net-next] wan: remove sbni/granch driver
  [net-next] wan: hostess_sv11: use module_init/module_exit helpers
  [net-next] ethernet: isa: convert to module_init/module_exit

Michael Schmitz (2):
  [net-next] ax88796: export ax_NS8390_init() hook
  [net-next] xsurf100: drop include of lib8390.c

 .../admin-guide/kernel-parameters.txt         |    2 -
 drivers/net/Kconfig                           |    7 +
 drivers/net/Makefile                          |    3 +-
 drivers/net/Space.c                           |  178 +-
 drivers/net/appletalk/Kconfig                 |    4 +-
 drivers/net/appletalk/ltpc.c                  |    7 +-
 drivers/net/ethernet/3com/3c509.c             |    3 -
 drivers/net/ethernet/3com/3c515.c             |    3 +-
 drivers/net/ethernet/3com/Kconfig             |    1 +
 drivers/net/ethernet/8390/Kconfig             |    3 +
 drivers/net/ethernet/8390/apne.c              |   11 +-
 drivers/net/ethernet/8390/ax88796.c           |    7 +
 drivers/net/ethernet/8390/ne.c                |    5 +-
 drivers/net/ethernet/8390/smc-ultra.c         |    9 +-
 drivers/net/ethernet/8390/wd.c                |    7 +-
 drivers/net/ethernet/8390/xsurf100.c          |    9 +-
 drivers/net/ethernet/amd/Kconfig              |    2 +
 drivers/net/ethernet/amd/atarilance.c         |   11 +-
 drivers/net/ethernet/amd/lance.c              |    6 +-
 drivers/net/ethernet/amd/mvme147.c            |   16 +-
 drivers/net/ethernet/amd/ni65.c               |    6 +-
 drivers/net/ethernet/amd/sun3lance.c          |   19 +-
 .../net/ethernet/broadcom/genet/bcmgenet.c    |    2 -
 drivers/net/ethernet/cirrus/Kconfig           |   27 +-
 drivers/net/ethernet/cirrus/cs89x0.c          |   31 +-
 drivers/net/ethernet/i825xx/82596.c           |   24 +-
 drivers/net/ethernet/i825xx/sun3_82586.c      |   17 +-
 drivers/net/ethernet/natsemi/jazzsonic.c      |    2 -
 drivers/net/ethernet/natsemi/xtsonic.c        |    1 -
 drivers/net/ethernet/smsc/Kconfig             |    1 +
 drivers/net/ethernet/smsc/smc9194.c           |    6 +-
 drivers/net/wan/Kconfig                       |   51 -
 drivers/net/wan/Makefile                      |    1 -
 drivers/net/wan/hostess_sv11.c                |    6 +-
 drivers/net/wan/sbni.c                        | 1639 -----------------
 drivers/net/wan/sbni.h                        |  147 --
 include/linux/netdevice.h                     |   13 -
 include/net/Space.h                           |   10 -
 include/net/ax88796.h                         |    3 +
 init/main.c                                   |    6 +-
 net/core/dev.c                                |  125 --
 net/ethernet/eth.c                            |    2 -
 42 files changed, 271 insertions(+), 2162 deletions(-)
 delete mode 100644 drivers/net/wan/sbni.c
 delete mode 100644 drivers/net/wan/sbni.h

-- 
2.29.2

Cc: "David S. Miller" <davem@davemloft.net>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jessica Yu <jeyu@kernel.org>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Sam Creasey <sammy@sammy.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: bcm-kernel-feedback-list@broadcom.com
