Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F317031A15D
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 16:17:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbhBLPRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:17:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbhBLPQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 10:16:50 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D00BC061574;
        Fri, 12 Feb 2021 07:16:10 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id y9so16166792ejp.10;
        Fri, 12 Feb 2021 07:16:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9js+f0qftXEjk3IJleRBb/QBgSDgHgl8iRdUuTKast8=;
        b=of3rK2160oByIIF+kBqqx46rjK0WSMxkO7kPEe6tJr4iA+dDvK7Dzat72AyCT5iI8v
         Da+pwi6/NfrUoK2avV2XFp4k0z0B6ji1v7rSzNfCPaV4NgExTJRU3yPmaJExppN4amXG
         eHFlLGmi9nfNtqBrAsPkrdL4TBoHHrGw21fa3WsMi14HyyHWrAEAXyuByn40KFvmZNX9
         ZpTkhmXIDolxrmpb/CvmI0wXf3OlnH7CzSsoW2secyyyHugLLTnhm+0Y6c4zGRAQJvNB
         CER3Gr9IuoTxnuUll2AurDx22ml2btXEag6zrEJ9AXat8AZLhwEgDuIEMsdNrulqOPCl
         M6GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9js+f0qftXEjk3IJleRBb/QBgSDgHgl8iRdUuTKast8=;
        b=tYZi3p68qLO9KmyrNghKU+QSjMQx9Db2mNGW/HKmVMbr+A9gdoRrSJ2rS6uy8OHJqy
         NcL3FRzUMUpDTsd72QjFQ8JIljg16lU8/+Ki5/HltCSH5+6HfgYnhmTOqkMFfhCKKGUq
         WQU2Cknav85a6GlyvcPfcb/sxY1391wxvx8zK+4QxXxRNnpQmwhNV4MBc9Z2FBGotUOR
         fuoogFIfC7buswI2S9vQ5200FnbqR4l3IyFnudfacT9RAN6vRoMfKdChTl52iEpQ4N8n
         e4oOYsQ48gL28QtuB+4IgQCvRCSeyNTix+pNlFLLsiuU7hqr5GwkK/sB57YZVz0piZ0X
         Gt6Q==
X-Gm-Message-State: AOAM531MY3MEpCtjnzpKCC+Sm+DfxazYsrnPMN/ry4aA4SnekrHl79Ip
        /JNxOE0xftNa6PhtmpRWTpk=
X-Google-Smtp-Source: ABdhPJzAZJbg31w/pvGoxHoKvxji6eJsGt8VTGpKu8R1ebmr7OBUW/jKTDmRDYVrYpts1s0tIeDwEw==
X-Received: by 2002:a17:906:2e4f:: with SMTP id r15mr3452573eji.407.1613142969032;
        Fri, 12 Feb 2021 07:16:09 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id z19sm6515456edr.69.2021.02.12.07.16.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 07:16:08 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>, linux-omap@vger.kernel.org
Subject: [PATCH v5 net-next 00/10] Cleanup in brport flags switchdev offload for DSA
Date:   Fri, 12 Feb 2021 17:15:50 +0200
Message-Id: <20210212151600.3357121-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

The initial goal of this series was to have better support for
standalone ports mode on the DSA drivers like ocelot/felix and sja1105.
This turned out to require some API adjustments in both directions:
to the information presented to and by the switchdev notifier, and to
the API presented to the switch drivers by the DSA layer.

Vladimir Oltean (10):
  net: switchdev: propagate extack to port attributes
  net: bridge: offload all port flags at once in br_setport
  net: bridge: don't print in br_switchdev_set_port_flag
  net: dsa: configure better brport flags when ports leave the bridge
  net: switchdev: pass flags and mask to both {PRE_,}BRIDGE_FLAGS
    attributes
  net: dsa: act as passthrough for bridge port flags
  net: dsa: felix: restore multicast flood to CPU when NPI tagger
    reinitializes
  net: mscc: ocelot: use separate flooding PGID for broadcast
  net: mscc: ocelot: offload bridge port flags to device
  net: dsa: sja1105: offload bridge port flags to device

 drivers/net/dsa/b53/b53_common.c              |  91 ++++---
 drivers/net/dsa/b53/b53_priv.h                |   2 -
 drivers/net/dsa/mv88e6xxx/chip.c              | 163 ++++++++++---
 drivers/net/dsa/mv88e6xxx/chip.h              |   6 +-
 drivers/net/dsa/mv88e6xxx/port.c              |  52 ++--
 drivers/net/dsa/mv88e6xxx/port.h              |  19 +-
 drivers/net/dsa/ocelot/felix.c                |  25 ++
 drivers/net/dsa/sja1105/sja1105.h             |   2 +
 drivers/net/dsa/sja1105/sja1105_main.c        | 222 +++++++++++++++++-
 drivers/net/dsa/sja1105/sja1105_spi.c         |   6 +
 .../marvell/prestera/prestera_switchdev.c     |  26 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  53 +++--
 drivers/net/ethernet/mscc/ocelot.c            | 100 +++++++-
 drivers/net/ethernet/mscc/ocelot_net.c        |  52 +++-
 drivers/net/ethernet/rocker/rocker_main.c     |  10 +-
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c |  27 ++-
 drivers/net/ethernet/ti/cpsw_switchdev.c      |  27 ++-
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       |  34 ++-
 include/net/dsa.h                             |  10 +-
 include/net/switchdev.h                       |  13 +-
 include/soc/mscc/ocelot.h                     |  20 +-
 net/bridge/br_netlink.c                       | 116 +++------
 net/bridge/br_private.h                       |   6 +-
 net/bridge/br_switchdev.c                     |  23 +-
 net/bridge/br_sysfs_if.c                      |   7 +-
 net/dsa/dsa_priv.h                            |  11 +-
 net/dsa/port.c                                |  76 ++++--
 net/dsa/slave.c                               |  10 +-
 net/switchdev/switchdev.c                     |  11 +-
 29 files changed, 889 insertions(+), 331 deletions(-)

-- 
2.25.1

