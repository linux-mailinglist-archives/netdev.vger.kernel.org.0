Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A361F8FD5
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 13:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfKLMon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 07:44:43 -0500
Received: from mail-wr1-f46.google.com ([209.85.221.46]:45095 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbfKLMon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 07:44:43 -0500
Received: by mail-wr1-f46.google.com with SMTP id z10so13056447wrs.12
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 04:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KvMd0an32r343/09fpHZgiqW6OG3fqQ3Rg9nlXtcVMg=;
        b=EhF/v524PZ9i34OsiMuLQ0F4qRQnLkJRB78+b4qQ9l5iUK5+Yp14CUHfZ5SWpcQ/6m
         EyxlRJEwRmKTYeTrzttdJvZac2vJZU4Uy3klYzve/5Pe9sVuxyCYTKqfUhgU3yRqqk0N
         2sAw8LazXWTtuVlr2MVmjBdXEQLOM3p0AXDhBkmJLmGXaDAeRx40j8qGS4aAS8vpDDMc
         77HXq7gORntJRPsaysvLu82u0hYhid1OkYiPQ/EmHvLgEE9mKe1+FVlhXN7ZgUMuq4cG
         LqIwoNH5VUtM/GZmZP7tJ0AuRYYTYVKKzFKeZGVN1yFKTskTkqF4rcSWuRYGmteOItIk
         /I2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KvMd0an32r343/09fpHZgiqW6OG3fqQ3Rg9nlXtcVMg=;
        b=t0YHhZj7RoBtEKWkzB2Ab/cvX7d7OPZESH16g2e/N0Wyeqt7CFWZGQkTuV51N9bpFq
         KDOnEfbW3wDvMYIK47ZpLY0zVKA/aBCapngQSo0ouXDr70A0mTK3HCIyoQ7PMyMOHhxY
         MbUr/pyE+hD/g8h19KC+4eIB6l7i6NnUKx8+LjazHK8mXYPzB4uwaQQpVBlVbbnlsM4g
         idjN6rjukTIXkDCDl/XPT/NCK2Qf3Mo0xTGWww3fSw3e3BXbVpXlGX3ySVkjDMWTD4jV
         8fGZ1mugW/ZtknrZQa5mzaa4GiwhXv3ugW267FP4fm7J/DdngojUVkORh3D/sXeT+io2
         zeMw==
X-Gm-Message-State: APjAAAVLOkFyF1qsO9mrjPmhEaFB9UZkTu+kH2DmLKdIoJCzB3OCwOj/
        /6byK4Y0/dIP5MrW6ZnleSw=
X-Google-Smtp-Source: APXvYqzrmjR+gVYmwopVqM1wBbmjBvhGVCvRuGlGoERvJ1BneN0GGn+OyPQw4kxdv/ZVnXsdWezLFw==
X-Received: by 2002:a5d:694d:: with SMTP id r13mr24127911wrw.395.1573562679590;
        Tue, 12 Nov 2019 04:44:39 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id g184sm4197688wma.8.2019.11.12.04.44.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 04:44:39 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 00/12] DSA driver for Vitesse Felix switch
Date:   Tue, 12 Nov 2019 14:44:08 +0200
Message-Id: <20191112124420.6225-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series builds upon the previous "Accomodate DSA front-end into
Ocelot" topic and does the following:

- Reworks the Ocelot (VSC7514) driver to support one more switching core
  (VSC9959), used in NPI mode. Some code which was thought to be
  SoC-specific (ocelot_board.c) wasn't, and vice versa, so it is being
  accordingly moved.
- Exports ocelot driver structures and functions to include/soc/mscc.
- Adds a DSA ocelot front-end for VSC9959, which is a PCI device and
  uses the exported ocelot functionality for hardware configuration.
- Adds a tagger driver for the Vitesse injection/extraction DSA headers.
  This is known to be compatible with at least Ocelot and Felix.

Claudiu Manoil (2):
  net: mscc: ocelot: move resource ioremap and regmap init to common
    code
  net: mscc: ocelot: filter out ocelot SoC specific PCS config from
    common path

Vladimir Oltean (10):
  net: mscc: ocelot: move invariant configs out of adjust_link
  net: mscc: ocelot: create a helper for changing the port MTU
  net: mscc: ocelot: export a constant for the tag length in bytes
  net: mscc: ocelot: adjust MTU on the CPU port in NPI mode
  net: mscc: ocelot: separate the implementation of switch reset
  net: mscc: ocelot: publish structure definitions to
    include/soc/mscc/ocelot.h
  net: mscc: ocelot: publish ocelot_sys.h to include/soc/mscc
  net: dsa: vitesse: move vsc73xx driver to a separate folder
  net: dsa: vitesse: add basic Felix switch driver
  net: dsa: vitesse: add tagger for Ocelot/Felix switches

 MAINTAINERS                                   |   8 +
 drivers/net/dsa/Kconfig                       |  31 +-
 drivers/net/dsa/Makefile                      |   4 +-
 drivers/net/dsa/vitesse/Kconfig               |  44 ++
 drivers/net/dsa/vitesse/Makefile              |  10 +
 drivers/net/dsa/vitesse/felix-regs.c          | 647 ++++++++++++++++
 drivers/net/dsa/vitesse/felix.c               | 358 +++++++++
 drivers/net/dsa/vitesse/felix.h               |  36 +
 .../vsc73xx-core.c}                           |   2 +-
 .../vsc73xx-platform.c}                       |   2 +-
 .../vsc73xx-spi.c}                            |   2 +-
 .../{vitesse-vsc73xx.h => vitesse/vsc73xx.h}  |   0
 drivers/net/ethernet/mscc/ocelot.c            | 205 ++---
 drivers/net/ethernet/mscc/ocelot.h            | 479 +-----------
 drivers/net/ethernet/mscc/ocelot_board.c      |  85 ++-
 drivers/net/ethernet/mscc/ocelot_io.c         |  14 +-
 drivers/net/ethernet/mscc/ocelot_regs.c       |   4 +-
 include/net/dsa.h                             |   2 +
 include/soc/mscc/ocelot.h                     | 698 ++++++++++++++++++
 .../soc}/mscc/ocelot_sys.h                    |   0
 net/dsa/Kconfig                               |   7 +
 net/dsa/Makefile                              |   1 +
 net/dsa/tag_ocelot.c                          | 229 ++++++
 23 files changed, 2231 insertions(+), 637 deletions(-)
 create mode 100644 drivers/net/dsa/vitesse/Kconfig
 create mode 100644 drivers/net/dsa/vitesse/Makefile
 create mode 100644 drivers/net/dsa/vitesse/felix-regs.c
 create mode 100644 drivers/net/dsa/vitesse/felix.c
 create mode 100644 drivers/net/dsa/vitesse/felix.h
 rename drivers/net/dsa/{vitesse-vsc73xx-core.c => vitesse/vsc73xx-core.c} (99%)
 rename drivers/net/dsa/{vitesse-vsc73xx-platform.c => vitesse/vsc73xx-platform.c} (99%)
 rename drivers/net/dsa/{vitesse-vsc73xx-spi.c => vitesse/vsc73xx-spi.c} (99%)
 rename drivers/net/dsa/{vitesse-vsc73xx.h => vitesse/vsc73xx.h} (100%)
 create mode 100644 include/soc/mscc/ocelot.h
 rename {drivers/net/ethernet => include/soc}/mscc/ocelot_sys.h (100%)
 create mode 100644 net/dsa/tag_ocelot.c

-- 
2.17.1

