Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8559F5F41
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 14:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfKINDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 08:03:22 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37658 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726267AbfKINDV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 08:03:21 -0500
Received: by mail-wm1-f65.google.com with SMTP id b17so627000wmj.2
        for <netdev@vger.kernel.org>; Sat, 09 Nov 2019 05:03:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=odAHsl8ZmPtL8IOqoWZ3WO1E8NmrLatz71pmhzqGX50=;
        b=Y0GyFN8X8C41LlrNvOg9oQ7TbFxE8UwghefsVCOMUBW+3qKiArLvT2n2yx82Z92bWT
         jwm7z209VGoujOQfrH2odFW7hm9f9ErpizmXYAc7fqk9FDmlj+15Zhe7VZuH48sVCDAK
         jvH52hil1fcfq/2lINENOr16kipNqrXBy9LQInxsjXENOpA3naru9sv9n9iCyVxTLH4I
         DkrdXBB2Pmo54/kVRPLeKXHDrFRpb1sN3SG2+7GHZ+Y/QfS9UmPvs7jeRVTCHADEFwoB
         H73RzmuQlUoU0pdqPuUxd/a+5FmmQJcHp9ADPojTmQHy9wuUw9QAUBcF7jysJTcdB+gR
         8mog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=odAHsl8ZmPtL8IOqoWZ3WO1E8NmrLatz71pmhzqGX50=;
        b=uLHYTar04udjELUTGRGRxwlW8O3173b0BmB2c4VPe0IiaKTgCqCzRb7bXVH30fWFMH
         VkyB1wCekqg20FLWJMWGZxNMHXtJCs73DHFYXDqhx7j1LsdbKwMWgSGN/BvxCPgl2ZJ4
         Fd/bJqYExjaKzN7TRmKTesLLaA/7vAKno0SCop7Yzci9H6EednkZgL7RWovO1g9IPrmx
         GB3juM6/5KI+UksYU1UVVV3LWU6aim6iEwO3gLlJgkfAM8yVMFoEK4K1+azN5O7uXnx2
         +EBdYWvtb6Lkwpji7UZMpN1F6Dn66enWhQpFa8M2rhVu0AZ8dlk/nXQOVJjb2ESBFouS
         A3cg==
X-Gm-Message-State: APjAAAXyFeLsCxwAmIQtLk57x0kD9dKWnCpMlY/spn5g1Xro+HSBj4yt
        eJL4QjBZvUd+auLE+uhJJ0QAPWyB
X-Google-Smtp-Source: APXvYqxt+uyavt6E8M79M2FvkKTNA9CY8eO0H0jV0O/JPRYYMfWSMNyJY1O8KEZ5AMI6HW02QlVVYA==
X-Received: by 2002:a1c:7905:: with SMTP id l5mr13422869wme.76.1573304599246;
        Sat, 09 Nov 2019 05:03:19 -0800 (PST)
Received: from localhost.localdomain ([86.121.29.241])
        by smtp.gmail.com with ESMTPSA id n13sm8370908wmi.25.2019.11.09.05.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Nov 2019 05:03:18 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        joergen.andreasen@microchip.com, allan.nielsen@microchip.com,
        horatiu.vultur@microchip.com, claudiu.manoil@nxp.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 00/15] Accomodate DSA front-end into Ocelot
Date:   Sat,  9 Nov 2019 15:02:46 +0200
Message-Id: <20191109130301.13716-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the nice "change-my-mind" discussion about Ocelot, Felix and
LS1028A (which can be read here: https://lkml.org/lkml/2019/6/21/630),
we have decided to take the route of reworking the Ocelot implementation
in a way that is DSA-compatible.

This is a large series, but hopefully is easy enough to digest, since it
contains mostly code refactoring. What needs to be changed:
- The struct net_device, phy_device needs to be isolated from Ocelot
  private structures (struct ocelot, struct ocelot_port). These will
  live as 1-to-1 equivalents to struct dsa_switch and struct dsa_port.
- The function prototypes need to be compatible with DSA (of course,
  struct dsa_switch will become struct ocelot).
- The CPU port needs to be assigned via a higher-level API, not
  hardcoded in the driver.

What is going to be interesting is that the new DSA front-end of Ocelot
will need to have features in lockstep with the DSA core itself. At the
moment, some more advanced tc offloading features of Ocelot (tc-flower,
etc) are not available in the DSA front-end due to lack of API in the
DSA core. It also means that Ocelot practically re-implements large
parts of DSA (although it is not a DSA switch per se) - see the FDB API
for example.

The code has been only compile-tested on Ocelot, since I don't have
access to any VSC7514 hardware. It was proven to work on NXP LS1028A,
which instantiates a DSA derivative of Ocelot. So I would like to ask
Alex Belloni if you could confirm this series causes no regression on
the Ocelot MIPS SoC.

The goal is to get this rework upstream as quickly as possible,
precisely because it is a large volume of code that risks gaining merge
conflicts if we keep it for too long.

This is but the first chunk of the LS1028A Felix DSA driver upstreaming.
For those who are interested, the concept can be seen on my private
Github repo, the user of this reworked Ocelot driver living under
drivers/net/dsa/vitesse/:
https://github.com/vladimiroltean/ls1028ardb-linux

Claudiu Manoil (1):
  net: mscc: ocelot: initialize list of multicast addresses in common
    code

Vladimir Oltean (14):
  net: mscc: ocelot: break apart ocelot_vlan_port_apply
  net: mscc: ocelot: break apart vlan operations into
    ocelot_vlan_{add,del}
  net: mscc: ocelot: break out fdb operations into abstract
    implementations
  net: mscc: ocelot: change prototypes of hwtstamping ioctls
  net: mscc: ocelot: change prototypes of switchdev port attribute
    handlers
  net: mscc: ocelot: refactor struct ocelot_port out of function
    prototypes
  net: mscc: ocelot: separate net_device related items out of
    ocelot_port
  net: mscc: ocelot: refactor ethtool callbacks
  net: mscc: ocelot: limit vlan ingress filtering to actual number of
    ports
  net: mscc: ocelot: move port initialization into separate function
  net: mscc: ocelot: separate the common implementation of ndo_open and
    ndo_stop
  net: mscc: ocelot: refactor adjust_link into a netdev-independent
    function
  net: mscc: ocelot: split assignment of the cpu port into a separate
    function
  net: mscc: ocelot: don't hardcode the number of the CPU port

 drivers/net/ethernet/mscc/ocelot.c        | 948 +++++++++++++---------
 drivers/net/ethernet/mscc/ocelot.h        |  33 +-
 drivers/net/ethernet/mscc/ocelot_ace.h    |   4 +-
 drivers/net/ethernet/mscc/ocelot_board.c  |  24 +-
 drivers/net/ethernet/mscc/ocelot_flower.c |  32 +-
 drivers/net/ethernet/mscc/ocelot_police.c |  36 +-
 drivers/net/ethernet/mscc/ocelot_police.h |   4 +-
 drivers/net/ethernet/mscc/ocelot_tc.c     |  56 +-
 8 files changed, 680 insertions(+), 457 deletions(-)

-- 
2.17.1

