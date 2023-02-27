Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381EB6A42D1
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 14:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbjB0Nfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 08:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjB0Nf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 08:35:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEC392;
        Mon, 27 Feb 2023 05:35:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C651B60C8C;
        Mon, 27 Feb 2023 13:35:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A26C433EF;
        Mon, 27 Feb 2023 13:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677504922;
        bh=d2Lq3RBqNZi5D42D4fx6Gg5riTJj4LbmcuLWDvTa4rU=;
        h=From:To:Cc:Subject:Date:From;
        b=HlILoM4N/Quib/DDjMXNKGh0uKYNnukoM4TWIyiEcCNPDxsI+x7eMxEMC+aWZBhBy
         BIGIxnJF9+flEIjkU0+uhHhjJD5E7cTtmrJiCrpLUUNz7YgPt4miqaKIFyjJHql6P+
         aCtb4/R4QDL1ILQAu3FS9/0xTrNeWn7aHjNG6qFZZgTeOejqNNrcS06xZc4uXQselv
         F/5YoCmEZNEkCGTt4kSQgBKyWaWyVTEMja9q6p13az4cP48+f1jj6ldPAlLCwV25ML
         yfd65nxGtqy2PXCzz5CJ4cbNKp+CEgCMxHyEDFtl+12r25MJLJ/RWuyJNBvjzQRJxW
         WS95XWFRg86sw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Bjorn Helgaas <bhelgaas@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Kevin Cernekee <cernekee@gmail.com>,
        Lukas Wunner <lukas@wunner.de>,
        Manuel Lauss <manuel.lauss@gmail.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Olof Johansson <olof@lixom.net>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-arm-kernel@lists.infradead.org, linux-can@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [RFC 0/6] pcmcia: separate 16-bit support from cardbus
Date:   Mon, 27 Feb 2023 14:34:51 +0100
Message-Id: <20230227133457.431729-1-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Based on some recent discussions [1][2][3], I experimented wtih what
drivers/pcmcia would look like if we completely removed 16-bit support,
which was one of the options that Dominik suggested for winding down
pcmcia maintenance.

The remaining cardbus/yenta support is essentially a PCI hotplug driver
with a slightly unusual sysfs interface, and it would still support all
32-bit cardbus hosts and cards, but no longer work with the even older
16-bit cards that require the pcmcia_driver infrastructure.

I don't expect this to be a problem normal laptop support, as the last
PC models that predate Cardbus support (e.g. 1997 ThinkPad 380ED) are
all limited to i586MMX CPUs and 80MB of RAM. This is barely enough to
boot Tiny Core Linux but not a regular distro.

Support for device drivers is somewhat less clear. Losing support for
16-bit cards in cardbus sockets is obviously a limiting factor for
anyone who still has those cards, but there is also a good chance that
the only reason to keep the cards around is for using them in pre-cardbus
machines that cannot be upgrade to 32-bit devices.

Completely removing the 16-bit PCMCIA support would however break some
20+ year old embedded machines that rely on CompactFlash cards as their
mass-storage device (extension), this notably includes early PocketPC
models and the reference implementations for OMAP1, StrongARM1100,
Alchemy and PA-Semi. All of these are still maintained, though most
of the PocketPC machines got removed in the 6.3 merge window and the
PA-Semi Electra board is the only one that was introduced after
2003.

The approach that I take in this series is to split drivers/pcmcia
into two mutually incompatible parts: the Cardbus support contains
all the code that is relevant for post-1997 laptops and gets moved
to drivers/pci/hotplug, while the drivers/pcmcia/ subsystem is
retained for both the older laptops and the embedded systems but no
longer works with the yenta socket host driver. The BCM63xx
PCMCIA/Cardbus host driver appears to be unused and conflicts with
this series, so it is removed in the process.

My series does not touch any of the pcmcia_driver instances, but
if there is consensus about splitting out the cardbus support,
a lot of them can probably get removed as a follow-up.

[1] https://lore.kernel.org/all/Y07d7rMvd5++85BJ@owl.dominikbrodowski.net/
[2] https://lore.kernel.org/all/c5b39544-a4fb-4796-a046-0b9be9853787@app.fastmail.com/
[3] https://lore.kernel.org/all/20230222092302.6348-1-jirislaby@kernel.org/

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kevin Cernekee <cernekee@gmail.com>
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Manuel Lauss <manuel.lauss@gmail.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: Olof Johansson <olof@lixom.net>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Cc: bcm-kernel-feedback-list@broadcom.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-can@vger.kernel.org
Cc: linux-mips@vger.kernel.org
Cc: linux-pci@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org

Arnd Bergmann (6):
  pccard: remove bcm63xx socket driver
  pccard: split cardbus support from pcmcia
  yenta_socket: copy pccard core code into driver
  yenta_socket: remove dead code
  pccard: drop remnants of cardbus support
  pci: hotplug: move cardbus code from drivers/pcmcia

 arch/mips/bcm63xx/Makefile                    |    2 +-
 arch/mips/bcm63xx/boards/board_bcm963xx.c     |   14 -
 arch/mips/bcm63xx/dev-pcmcia.c                |  144 -
 arch/mips/configs/bcm63xx_defconfig           |    1 -
 .../asm/mach-bcm63xx/bcm63xx_dev_pcmcia.h     |   14 -
 arch/mips/pci/ops-bcm63xx.c                   |  294 --
 arch/mips/pci/pci-bcm63xx.c                   |   44 -
 drivers/Makefile                              |    2 +-
 drivers/pci/hotplug/Kconfig                   |   56 +
 drivers/pci/hotplug/Makefile                  |    1 +
 drivers/pci/hotplug/yenta_socket.c            | 4056 +++++++++++++++++
 drivers/pcmcia/Kconfig                        |   63 +-
 drivers/pcmcia/Makefile                       |   13 +-
 drivers/pcmcia/bcm63xx_pcmcia.c               |  538 ---
 drivers/pcmcia/bcm63xx_pcmcia.h               |   61 -
 drivers/pcmcia/cardbus.c                      |  124 -
 drivers/pcmcia/cistpl.c                       |   10 +-
 drivers/pcmcia/cs.c                           |  103 +-
 drivers/pcmcia/cs_internal.h                  |   10 +-
 drivers/pcmcia/ds.c                           |   14 +-
 drivers/pcmcia/i82092.c                       |    2 +-
 drivers/pcmcia/i82365.c                       |    2 +-
 drivers/pcmcia/o2micro.h                      |  183 -
 drivers/pcmcia/pd6729.c                       |    3 +-
 drivers/pcmcia/ricoh.h                        |  169 -
 drivers/pcmcia/socket_sysfs.c                 |    2 -
 drivers/pcmcia/ti113x.h                       |  978 ----
 drivers/pcmcia/topic.h                        |  168 -
 drivers/pcmcia/yenta_socket.c                 | 1455 ------
 drivers/pcmcia/yenta_socket.h                 |  136 -
 {drivers => include}/pcmcia/i82365.h          |    0
 include/pcmcia/ss.h                           |   21 -
 32 files changed, 4147 insertions(+), 4536 deletions(-)
 delete mode 100644 arch/mips/bcm63xx/dev-pcmcia.c
 delete mode 100644 arch/mips/include/asm/mach-bcm63xx/bcm63xx_dev_pcmcia.h
 create mode 100644 drivers/pci/hotplug/yenta_socket.c
 delete mode 100644 drivers/pcmcia/bcm63xx_pcmcia.c
 delete mode 100644 drivers/pcmcia/bcm63xx_pcmcia.h
 delete mode 100644 drivers/pcmcia/cardbus.c
 delete mode 100644 drivers/pcmcia/o2micro.h
 delete mode 100644 drivers/pcmcia/ti113x.h
 delete mode 100644 drivers/pcmcia/topic.h
 delete mode 100644 drivers/pcmcia/yenta_socket.c
 delete mode 100644 drivers/pcmcia/yenta_socket.h
 rename {drivers => include}/pcmcia/i82365.h (100%)

-- 
2.39.2

