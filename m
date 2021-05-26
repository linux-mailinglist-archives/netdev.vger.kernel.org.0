Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 162A8391941
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 15:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbhEZN51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 09:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbhEZN5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 09:57:25 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA14C061574
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:55:53 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id f18so2583614ejq.10
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 06:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ef4TL1d6Da2V7g8KnOnMgHuWjRrqLNjsxHB+wpXciwk=;
        b=SL2x7wKYFYCLPfgGbX3XIYq3n9rZSWZcYF0ZJNnIMlPiEXJJYUrKQyNllRoNnnZnUa
         6ucKihAztHXUeF6Xjf4Bq4uS3HUTTwzgEkuZ5AUJM9IsMO/4TdTRd6xWLf3hZq0MM3zT
         8AUM5vYB0TcExKge3fHQ9XFig7n5Td94DksmpwaGKUdJOvgWI43EarMxoL2L5WFi3ciF
         2wO3D+jueAr+P1snGG2oylYkNOff6MzOQXYVg5x0B8bV8h81J3PWK6VGD3Y/ziXYUiDw
         ziYon6efGJZLzg7XpWRU9y7xH3ywvENM6y4NJMV5YjqFau6HhNRTHQsdADffIeOiuWKJ
         2rnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ef4TL1d6Da2V7g8KnOnMgHuWjRrqLNjsxHB+wpXciwk=;
        b=FOQpeYIIIRuBnLny20di0E2uZJf007O2Wuo4+6xAD8/UIb1xA25djpZIN4Ic6wjpzf
         pqs72BScIXzy7WmhyFAElIfjR8QmdSH54FPkJxTn9HFxoRozal/8YKRC/hi8iKiXLE2A
         mAMhXLdXX6hAVdLfCbOzTUjUjuZ+se2exQxWUE5YgqVaFG2c8N/VC4O/HINmLk7Ubt7X
         LUlwEGFPkjisvxmJ09PdLbdN2HHTsCtP8I5bIm7PRmZQPwIDHfOEAEDMRN19j1FyCsVj
         eM0OtVx7uqQYMKhzAcQmIfrNEmTUMqf91H4UeKv5ORwI5CIJLE6aolFOW/K5XUGBIpQU
         6rYg==
X-Gm-Message-State: AOAM530efWWbbE/x+vLKtX/xjqQOEHuJAEkO1X/YvuaxvCGDqPb/ji+h
        9gcoT5RuehtjrAMd6q9PY4Q=
X-Google-Smtp-Source: ABdhPJy5QhSWhWz4Nz1UtWQOWEqejqmXbJ1Al7ux5rYoOCKYmApIi4W9JjUt2gPSI7tO2vutTGnyLw==
X-Received: by 2002:a17:906:7712:: with SMTP id q18mr34795741ejm.10.1622037352275;
        Wed, 26 May 2021 06:55:52 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id k11sm10508476ejc.94.2021.05.26.06.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 06:55:51 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
X-Google-Original-From: Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh@kernel.org>
Subject: [RFC PATCH v2 linux-next 00/14] Add NXP SJA1110 support to the sja1105 DSA driver
Date:   Wed, 26 May 2021 16:55:21 +0300
Message-Id: <20210526135535.2515123-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series is sent as RFC and based on linux-next because it
depends on some changes which are in "net" but not in "net-next".

Changes in v2:
- converted nxp,sja1105 DT bindings to YAML
- registered the PCS MDIO bus and forced auto-probing off for all PHY
  addresses for this bus
- changed the container node name for the 2 MDIO buses from "mdio" to
  "mdios" to avoid matching on the mdio.yaml schema (it's just a
  container node, not an MDIO bus)
- fixed an uninitialized "offset" variable usage in
  sja1110_pcs_mdio_{read,write}
- using the mdiobus_c45_addr macro instead of open-coding that operation

Reason for reposting so early:
Would like some feedback on the DT bindings for the internal MDIO buses.

Feedback from v1 not addressed:
(Q) Can the Synopsys PCS initialization code be moved into
    drivers/net/pcs/xpcs.c?
(A) Yes and no. Initializing the PCS is not sufficient for proper
    SGMII/2500base-x operation, one also needs to initialize the
    non-Synopsys PMA/PMD, which is accessible through the same
    struct mdio_device as the PCS itself.
(Q) No interrupts for the internal PHYs?
(A) In a later patch series (this one is already large), and only in a
    reduced functionality mode, where the switch driver registers an
    irqchip but it busy polls the interrupt status register. The board I
    am working on does not have the switch interrupt pin wired.

Previous cover letter:

The NXP SJA1110 is an automotive Ethernet switch with an embedded Arm
Cortex-M7 microcontroller. The switch has 11 ports (10 external + one
for the DSA-style connection to the microcontroller).
The microcontroller can be disabled and the switch can be controlled
over SPI, a la SJA1105 - this is how this driver handles things.

There are some integrated NXP PHYs (100base-T1 and 100base-TX). Their
initialization is handled by their own PHY drivers, the switch is only
concerned with enabling register accesses to them, by registering two
MDIO buses.

Cc: Russell King <linux@armlinux.org.uk>
Cc: Rob Herring <robh@kernel.org>

Vladimir Oltean (14):
  net: dsa: sja1105: be compatible with "ethernet-ports" OF node name
  net: dsa: sja1105: allow SGMII PCS configuration to be per port
  net: dsa: sja1105: the 0x1F0000 SGMII "base address" is actually
    MDIO_MMD_VEND2
  net: dsa: sja1105: cache the phy-mode port property
  net: dsa: sja1105: add a PHY interface type compatibility matrix
  net: dsa: sja1105: add a translation table for port speeds
  net: dsa: sja1105: always keep RGMII ports in the MAC role
  net: dsa: sja1105: some table entries are always present when read
    dynamically
  dt-bindings: net: dsa: sja1105: convert to YAML schema
  dt-bindings: net: dsa: sja1105: add SJA1110 bindings
  net: dsa: sja1105: add support for the SJA1110 switch family
  net: dsa: sja1105: register the MDIO buses for 100base-T1 and
    100base-TX
  net: dsa: sja1105: expose the SGMII PCS as an mdio_device
  net: dsa: sja1105: add support for the SJA1110 SGMII/2500base-x PCS

 .../bindings/net/dsa/nxp,sja1105.yaml         | 172 ++++++
 .../devicetree/bindings/net/dsa/sja1105.txt   | 156 -----
 drivers/net/dsa/sja1105/Makefile              |   1 +
 drivers/net/dsa/sja1105/sja1105.h             |  88 ++-
 drivers/net/dsa/sja1105/sja1105_clocking.c    | 120 +++-
 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 336 ++++++++++-
 .../net/dsa/sja1105/sja1105_dynamic_config.h  |   1 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 518 +++++++++++++----
 drivers/net/dsa/sja1105/sja1105_mdio.c        | 539 ++++++++++++++++++
 drivers/net/dsa/sja1105/sja1105_sgmii.h       |  63 +-
 drivers/net/dsa/sja1105/sja1105_spi.c         | 368 +++++++++++-
 .../net/dsa/sja1105/sja1105_static_config.c   | 483 ++++++++++++++++
 .../net/dsa/sja1105/sja1105_static_config.h   |  98 +++-
 13 files changed, 2619 insertions(+), 324 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/sja1105.txt
 create mode 100644 drivers/net/dsa/sja1105/sja1105_mdio.c

-- 
2.25.1

