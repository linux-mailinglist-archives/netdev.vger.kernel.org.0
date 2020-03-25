Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94B67192C28
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 16:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727702AbgCYPWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 11:22:18 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:39991 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbgCYPWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 11:22:17 -0400
Received: by mail-wr1-f43.google.com with SMTP id u10so3618731wro.7
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 08:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=L6baR+pE/3POxriFgUdCt6+yNb7cuMR0ZXk3/g0okeE=;
        b=eSiJ8IXd0ce7mBu9dAOKf9J+qh8JNpQfwlwZ3Tuo23hcAYWJK8DdlENUdDa7DTTxla
         ER38YWN9hqhJUlT+zW+IeMWheDH8SHPomIcqSpPtOlKbW27gIdSm6xa6ddBk7ZtM6rG7
         gT7XwyHHj8XrrnBNyTlPqzOWjMAVcejXu4vMf+iey0LKspS+lTNvWYyYpXE0Q9CMTo7m
         xh0dfqVUkWBHr+LPcZbtOiAsxl1AMOygEm8Z56NUs2VzrJh8gSaKrOZQOj7w36iLtxKe
         vJHzggCCGnKp4DKix2gSzH+O9sHkklxSZRNFmWAEY7xWX/pFqdQIJRDmOaWKmfTUmrK6
         Zgtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=L6baR+pE/3POxriFgUdCt6+yNb7cuMR0ZXk3/g0okeE=;
        b=Km8q3na7QBICe1WXe5sMr8L1jPYf1zdUaa2/VfLebDidNklfYYJN0f3G8kf9KBYeO2
         LwdkQewvB3jvKI4MtGV22wn33/IIHX8yjW0nvepGTMqkdf97X53pJf9iTu5gpEtJLYjW
         ux9NsxGZKklfVkOoZu+3yyyEbE5KLegGjgS7I+FKdw2n+dBJvJOf/h2pxuf71rqmh2rW
         WJ3mzR4WhKIpuL0yV1Yz8XgH71PxQyEVG9jZsCPjaB27Ry/bnQmgLDmgsMc1uD+OoMBx
         Y0md24UawwTQm6ltNP+7EcernuhJ13eOcDavxUkCBBSEyGzOpPNvtUlu9UD3eCZs0rfO
         m9gQ==
X-Gm-Message-State: ANhLgQ1DpLPqDn6GSq/ojGAobRBvtJAiOktTljVVDbZm0IqQkEeoOqY4
        cyOFQPC2IMK4NgtSrpwhYQ0=
X-Google-Smtp-Source: ADFU+vs9V+H7JMc/8OChVyxuDe8UqgIBOoz6CmEmlCbXdkyWtfsBD9QOgbl/VWPOcSWTJn5gK4Q5GA==
X-Received: by 2002:a5d:53ce:: with SMTP id a14mr3922099wrw.129.1585149734985;
        Wed, 25 Mar 2020 08:22:14 -0700 (PDT)
Received: from localhost.localdomain ([79.115.60.40])
        by smtp.gmail.com with ESMTPSA id n9sm6309165wru.50.2020.03.25.08.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 08:22:14 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     murali.policharla@broadcom.com, stephen@networkplumber.org,
        jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        nikolay@cumulusnetworks.com, netdev@vger.kernel.org
Subject: [PATCH v2 net-next 00/10] Configure the MTU on DSA switches
Date:   Wed, 25 Mar 2020 17:21:59 +0200
Message-Id: <20200325152209.3428-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This series adds support for configuring the MTU on front-panel switch
ports, while seamlessly adapting the CPU port and the DSA master to the
largest value plus the tagger overhead.

It also implements bridge MTU auto-normalization, as discussed with
Florian in the comments of v1.

Support was added for quite a number of switches, in the hope that this
series would gain some traction:
 - sja1105
 - felix
 - vsc73xx
 - b53 and rest of the platform

V1 of this series was submitted here:
https://patchwork.ozlabs.org/cover/1199868/

Murali Krishna Policharla (5):
  net: phy: bcm7xx: Add jumbo frame configuration to PHY
  bgmac: Add support for Jumbo frames
  bgmac: Add MTU configuration support to the driver
  bgmac: Add DMA support to handle frames beyond 8192 bytes
  net: dsa: b53: Add MTU configuration support

Vladimir Oltean (5):
  net: dsa: configure the MTU for switch ports
  net: dsa: sja1105: Implement the port MTU callbacks
  net: dsa: vsc73xx: Make the MTU configurable
  net: dsa: felix: support changing the MTU
  net: bridge: implement auto-normalization of MTU for hardware datapath

 drivers/net/dsa/b53/b53_common.c       |  35 +++++++++
 drivers/net/dsa/ocelot/felix.c         |  18 +++++
 drivers/net/dsa/sja1105/sja1105.h      |   1 +
 drivers/net/dsa/sja1105/sja1105_main.c |  48 +++++++++++-
 drivers/net/dsa/vitesse-vsc73xx-core.c |  30 ++++---
 drivers/net/ethernet/broadcom/bgmac.c  |  12 +++
 drivers/net/ethernet/broadcom/bgmac.h  |   5 +-
 drivers/net/ethernet/mscc/ocelot.c     |  45 ++++++++---
 drivers/net/phy/bcm-phy-lib.c          |  28 +++++++
 drivers/net/phy/bcm-phy-lib.h          |   1 +
 drivers/net/phy/bcm7xxx.c              |   4 +
 include/linux/brcmphy.h                |   1 +
 include/net/dsa.h                      |  10 +++
 include/soc/mscc/ocelot.h              |   7 ++
 net/bridge/br.c                        |   1 +
 net/bridge/br_if.c                     |  93 ++++++++++++++++++++++
 net/bridge/br_private.h                |   1 +
 net/dsa/dsa_priv.h                     |  10 +++
 net/dsa/master.c                       |  14 ++--
 net/dsa/port.c                         |  11 +++
 net/dsa/slave.c                        | 104 ++++++++++++++++++++++++-
 net/dsa/switch.c                       |  34 ++++++++
 22 files changed, 478 insertions(+), 35 deletions(-)

-- 
2.17.1

