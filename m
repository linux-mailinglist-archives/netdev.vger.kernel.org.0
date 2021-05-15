Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8A12381B54
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 00:14:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235185AbhEOWPn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 18:15:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229989AbhEOWPl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 18:15:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1E5260C3F;
        Sat, 15 May 2021 22:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621116868;
        bh=+oo6MXkH4s3EnhdaaD6r8S7Ts2xF18eX//Y1vcCqOfM=;
        h=From:To:Cc:Subject:Date:From;
        b=PFwwy1bO7qp2WdUqg2r5OCWQtI/oT3+TuEWsAngkiu0BwPZhqqCxWkzhVnBlXwN4/
         qRU5OnPQ28C5tyXcQu44SjUQscZT2q1gsZ+iqEf+2/dnhgER/6v/+f1jykSWaAzTEW
         c4brNb0fObVKhhfk9IaRG8WpOG+0Xyih3KjRXGrcT0O074bwFg5DQgEvMd6jxf+F6q
         xY2LSPij6H6jMlLUhjZt691ZdJ7ufAv0xQqZ/T3JPFgQ3o2kE6BWzEvQ+DAAhG0RWA
         ThF+7onqNO4zQ1b9R8X/bPuie0tQy5rjYO19Np37QzAkTOZhpQ3T8m5dFr9OZo5Eoq
         C8FqANNUl4Rfg==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sam Creasey <sammy@sammy.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: [RFC 00/13] [net-next] drivers/net/Space.c cleanup
Date:   Sun, 16 May 2021 00:13:07 +0200
Message-Id: <20210515221320.1255291-1-arnd@kernel.org>
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
resemble modern drivers. There are only a few users of the init_module()
interface remaining, and removing that would likely allow some cleanups
in the module loader code.

There are a couple of possible follow-ups:

* Most of ISA drivers could be trivially converted to use the module_init()
  entry point, which would slightly change the command line syntax and
  still support a single device of that type, but not more than one. We
  could decide that this is fine, as few users remain that have any of
  these devices, let alone more than one.

* Alternatively, the fact that the ISA drivers have never been cleaned
  up can be seen as an indication that there isn't really much remaining
  interest in them. We could move them to drivers/staging along with the
  consolidated contents of drivers/net/Space.c and see if anyone still
  uses them and eventually remove the ones that nobody has.
  I can see that Paul Gortmaker removed a number of less common ISA
  ethernet drivers in 2013, but at the time left these because they
  were possibly still relevant.

* If we end up moving the cops localtalk driver to staging, support
  for localtalk devices (though probably not appletalk over ethernet)
  can arguably meet the same fate.

If someone wants to work on those follow-ups or thinks they are a
good idea, let me know, otherwise I'd leave it at this cleanup.

       Arnd

Arnd Bergmann (13):
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
  [net-next] 8390: xsurf100: avoid including lib8390.c

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
 drivers/net/ethernet/8390/Makefile            |    2 +-
 drivers/net/ethernet/8390/apne.c              |   11 +-
 drivers/net/ethernet/8390/ne.c                |    5 +-
 drivers/net/ethernet/8390/smc-ultra.c         |    9 +-
 drivers/net/ethernet/8390/wd.c                |    7 +-
 drivers/net/ethernet/8390/xsurf100.c          |    7 +-
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
 drivers/net/wan/sbni.c                        | 1638 -----------------
 drivers/net/wan/sbni.h                        |  147 --
 include/linux/netdevice.h                     |   13 -
 include/net/Space.h                           |   10 -
 net/core/dev.c                                |  125 --
 net/ethernet/eth.c                            |    2 -
 40 files changed, 259 insertions(+), 2157 deletions(-)
 delete mode 100644 drivers/net/wan/sbni.c
 delete mode 100644 drivers/net/wan/sbni.h

-- 
2.29.2

Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Doug Berger <opendmb@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Sam Creasey <sammy@sammy.net>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Andrii Nakryiko <andriin@fb.com>
Cc: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: bcm-kernel-feedback-list@broadcom.com
