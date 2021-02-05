Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFC3311883
	for <lists+netdev@lfdr.de>; Sat,  6 Feb 2021 03:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbhBFCjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 21:39:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbhBFCg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 21:36:28 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD9FBC06121D
        for <netdev@vger.kernel.org>; Fri,  5 Feb 2021 14:03:11 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id s26so4910520edt.10
        for <netdev@vger.kernel.org>; Fri, 05 Feb 2021 14:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tm1BEQal6Ea4cTm9YjYQQhIjT6fhvCeuE8sDjoTsONg=;
        b=Ts+WLFX0apBOUCBoLp6mtgtd9p0b4uk382MVUYnMMH7yiYfaGBoW11MYlZ8tjEMtQo
         tGTjJ3SkEi97ZcAxMEfkgdGjrjyNPuedGvW6hf/PUlRqUcHY6465HiDwzYD1/DA9kF04
         e342s1YbJLnatwVo9OI0ICvYMPhhRyPt9ZUHZa9gCDE0i7lxGB4OFTxr2YWD06B4kqFC
         zWgQF0GomoFI7oIDl9AEQJtKXCrM70tVvDLHQgvm98pNXrIQpWnDBsULxGR2CvTWERdJ
         Nva3NC1fBrjiXvhNGV8fd6QqJknuko8P1GIghKGu0466pH9qfxwy2DGVJ3FVa8gNId6v
         6+eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tm1BEQal6Ea4cTm9YjYQQhIjT6fhvCeuE8sDjoTsONg=;
        b=SEc5Rk6G/fq4mHuXhWBK6LmH6yoYzVN0fNVKjr3yyUGqIxIIE4YRnilJ2haJQexVgM
         pK/3Dxao3TzsCQKQW5Bmrdt2JGQqWDjbokGgYXZ02E5dIp81zQ2uZ2Qrd1IUO+4tpr64
         tIK0faZsrUKRWl87QrsrdwicM1jKts+C78JF+sHl3CQDrGyH1Ustg9fWHhiXhoc4MLzA
         H4/ikfg9p1sCbuUZ5fZS9SjKY9rszvENkYFISDdfPT2Pz4gga0mzX8u+4EkLKkfXVNay
         TmAZOwsnyUa3kSusNCUrbn+/OcJctzknevjp4R/6KiFgqouPzyhI8wX4DSzoj1pDeY1o
         0u5A==
X-Gm-Message-State: AOAM532V5BHHUlwwuIHgVeGRTbUKW9s+zi42Tceuf+52D0SUG5Q/jlPn
        BGZHg8xjULREQKLdiSK1tx4=
X-Google-Smtp-Source: ABdhPJxUIn25ZtcH2yUY9MLlxOTYGLgw0ykozJcZk6LkiwMulkjlM/u7PgwqfsQE0IGHqI204ZDCHg==
X-Received: by 2002:aa7:de10:: with SMTP id h16mr5733824edv.295.1612562590624;
        Fri, 05 Feb 2021 14:03:10 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t16sm4969909edi.60.2021.02.05.14.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Feb 2021 14:03:10 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH RESEND v3 net-next 00/12] LAG offload for Ocelot DSA switches
Date:   Sat,  6 Feb 2021 00:02:09 +0200
Message-Id: <20210205220221.255646-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This patch series reworks the ocelot switchdev driver such that it could
share the same implementation for LAG offload as the felix DSA driver.

Testing has been done in the following topology:

         +----------------------------------+
         | Board 1         br0              |
         |             +---------+          |
         |            /           \         |
         |            |           |         |
         |            |         bond0       |
         |            |        +-----+      |
         |            |       /       \     |
         |  eno0     swp0    swp1    swp2   |
         +---|--------|-------|-------|-----+
             |        |       |       |
             +--------+       |       |
               Cable          |       |
                         Cable|       |Cable
               Cable          |       |
             +--------+       |       |
             |        |       |       |
         +---|--------|-------|-------|-----+
         |  eno0     swp0    swp1    swp2   |
         |            |       \       /     |
         |            |        +-----+      |
         |            |         bond0       |
         |            |           |         |
         |            \           /         |
         |             +---------+          |
         | Board 2         br0              |
         +----------------------------------+

The same script can be run on both Board 1 and Board 2 to set this up:

ip link del bond0
ip link add bond0 type bond mode balance-xor miimon 1
OR
ip link add bond0 type bond mode 802.3ad
ip link set swp1 down && ip link set swp1 master bond0 && ip link set swp1 up
ip link set swp2 down && ip link set swp2 master bond0 && ip link set swp2 up
ip link del br0
ip link add br0 type bridge
ip link set bond0 master br0
ip link set swp0 master br0

Then traffic can be tested between eno0 of Board 1 and eno0 of Board 2.

Vladimir Oltean (12):
  net: mscc: ocelot: rename ocelot_netdevice_port_event to
    ocelot_netdevice_changeupper
  net: mscc: ocelot: use a switch-case statement in
    ocelot_netdevice_event
  net: mscc: ocelot: don't refuse bonding interfaces we can't offload
  net: mscc: ocelot: use ipv6 in the aggregation code
  net: mscc: ocelot: set up the bonding mask in a way that avoids a
    net_device
  net: mscc: ocelot: avoid unneeded "lp" variable in LAG join
  net: mscc: ocelot: set up logical port IDs centrally
  net: mscc: ocelot: drop the use of the "lags" array
  net: mscc: ocelot: rename aggr_count to num_ports_in_lag
  net: mscc: ocelot: rebalance LAGs on link up/down events
  net: dsa: make assisted_learning_on_cpu_port bypass offloaded LAG
    interfaces
  net: dsa: felix: propagate the LAG offload ops towards the ocelot lib

 drivers/net/dsa/ocelot/felix.c         |  32 ++++
 drivers/net/ethernet/mscc/ocelot.c     | 206 ++++++++++++++-----------
 drivers/net/ethernet/mscc/ocelot.h     |   4 -
 drivers/net/ethernet/mscc/ocelot_net.c | 131 ++++++++++------
 include/soc/mscc/ocelot.h              |  11 +-
 net/dsa/dsa_priv.h                     |  13 ++
 net/dsa/slave.c                        |   8 +
 7 files changed, 262 insertions(+), 143 deletions(-)

-- 
2.25.1

