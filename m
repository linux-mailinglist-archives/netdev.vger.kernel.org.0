Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C40ABFC971
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 16:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfKNPEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 10:04:13 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52974 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfKNPEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 10:04:12 -0500
Received: by mail-wm1-f65.google.com with SMTP id l1so6016651wme.2
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 07:04:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+CwUq6oRlSwW/2hY9AHWbhWiGW3GI87y2NDKcQiGFts=;
        b=Cor9bVXYv4dbhjRwqTfOIHTsmdR3wC35qrlUspMnnuKN7sYq2T+KSxRdAPdPY/+DPk
         BVTpgs5o8JE38KccO3wVxclVihPchDsvmV1FUTRwsYcsDnCsoBIEwsHF1RZ+fSn7Du32
         h44PBuEga7VVhF68P3sxgSlfo418/KwBH5nVWwHy92LSScqNK05tAubEvvCn12hkChIB
         kWHz4qQziSsjSYHLULEys/nC/kSIvkIZAxKugf4J049sz43JLsEOZvqa9Xc1o99yCWIU
         WA51K750h9mw/iJ6iGxnE1sH/q2eiwlH+yKdDNSKe/Fe/GTbSJ9q0AVUyh6/2ZrKHfbA
         gaeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+CwUq6oRlSwW/2hY9AHWbhWiGW3GI87y2NDKcQiGFts=;
        b=TWYjyxJOjYf2MLD5ps8PWrXgVDdladYTIphgQjvgTCfF0vYylG687qkJk7NjoyifAC
         MR9wpZz4jepgQLCw1S46qMlXEpqxjoV+ctUuz2zR4Ak5Dg7WBxLRQrtt/KCZoLT+fWfQ
         D0jZcuNof5vxiPkhnMU5b9dDo6lEPp4uGivuOWl7gjFt+z+O6AP5Fa4u5UHFa1nzCEs9
         YTcVhJKnunc9rpTYOPRy2TcoKAe2xIlu/uO93w/rE2XvzK6c56616T4l1AyZcFoOlREP
         DJMjBQye/8IMKhN1JZUnRdH+AXl/MALxJU7Vv3NKocxN42SVjjXZMA07Mnc7e2uvFqkV
         3K1g==
X-Gm-Message-State: APjAAAVYe6OMKbiUuoRug0svqDqKmeDZj1e/PwDMp5uVx2QdwMfuethQ
        KZ26GsR1pa+mqK7LGULGYK8=
X-Google-Smtp-Source: APXvYqzkT2AVajPa4HjXWCZF8bkqTjEnQDPTLMFP3x1TEZa3j3KNNF2WmSrVX5tGUDyp/vzWAFi1Fw==
X-Received: by 2002:a05:600c:2105:: with SMTP id u5mr8031255wml.47.1573743850098;
        Thu, 14 Nov 2019 07:04:10 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id v128sm7600094wmb.14.2019.11.14.07.04.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2019 07:04:09 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     davem@davemloft.net, alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        alexandru.marginean@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v2 net-next 00/11] DSA driver for Vitesse Felix switch
Date:   Thu, 14 Nov 2019 17:03:19 +0200
Message-Id: <20191114150330.25856-1-olteanv@gmail.com>
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

Vladimir Oltean (9):
  net: mscc: ocelot: move invariant configs out of adjust_link
  net: mscc: ocelot: create a helper for changing the port MTU
  net: mscc: ocelot: export a constant for the tag length in bytes
  net: mscc: ocelot: adjust MTU on the CPU port in NPI mode
  net: mscc: ocelot: separate the implementation of switch reset
  net: mscc: ocelot: publish structure definitions to
    include/soc/mscc/ocelot.h
  net: mscc: ocelot: publish ocelot_sys.h to include/soc/mscc
  net: dsa: ocelot: add tagger for Ocelot/Felix switches
  net: dsa: ocelot: add driver for Felix switch family

 MAINTAINERS                                   |   9 +
 drivers/net/dsa/Kconfig                       |   2 +
 drivers/net/dsa/Makefile                      |   1 +
 drivers/net/dsa/ocelot/Kconfig                |  11 +
 drivers/net/dsa/ocelot/Makefile               |   6 +
 drivers/net/dsa/ocelot/felix.c                | 441 ++++++++++++++
 drivers/net/dsa/ocelot/felix.h                |  37 ++
 drivers/net/dsa/ocelot/felix_vsc9959.c        | 567 ++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot.c            | 209 ++++---
 drivers/net/ethernet/mscc/ocelot.h            | 479 +--------------
 drivers/net/ethernet/mscc/ocelot_board.c      |  85 ++-
 drivers/net/ethernet/mscc/ocelot_io.c         |  14 +-
 drivers/net/ethernet/mscc/ocelot_regs.c       |   3 +-
 include/net/dsa.h                             |   2 +
 include/soc/mscc/ocelot.h                     | 539 +++++++++++++++++
 .../soc}/mscc/ocelot_sys.h                    |   0
 net/dsa/Kconfig                               |   7 +
 net/dsa/Makefile                              |   1 +
 net/dsa/tag_ocelot.c                          | 229 +++++++
 19 files changed, 2043 insertions(+), 599 deletions(-)
 create mode 100644 drivers/net/dsa/ocelot/Kconfig
 create mode 100644 drivers/net/dsa/ocelot/Makefile
 create mode 100644 drivers/net/dsa/ocelot/felix.c
 create mode 100644 drivers/net/dsa/ocelot/felix.h
 create mode 100644 drivers/net/dsa/ocelot/felix_vsc9959.c
 create mode 100644 include/soc/mscc/ocelot.h
 rename {drivers/net/ethernet => include/soc}/mscc/ocelot_sys.h (100%)
 create mode 100644 net/dsa/tag_ocelot.c

-- 
2.17.1

