Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B49323B67
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 12:46:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbhBXLoq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 06:44:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbhBXLom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 06:44:42 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81846C06174A
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:02 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id c6so2121928ede.0
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 03:44:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WPv+NcQcrkrtTYPGU4KBIhoBgi9q82qR2kFd2AnbgdM=;
        b=NDMhyJ0Un1Nc9NfE94OSo3aL3g+zM+l2NuXUds67e6cZg/nqZhop1qzQrlxm3l4OWV
         evOxObbufzSmCTusINy25W5L1i4/Sa2lxhTXZKAILyaNeOvG5VisGuq4LggVNK618x1X
         0+I1Lr0CXqTyCJgPFV5hVTqfI1iYJ2lm7UNhE3wx/caNC165r53krsBZnQLYQu/m6qth
         Uo9vmSaBX/pejcasn9A8xTmTYz0kWIcC4FyxxO5E9p0qhY45YLlGQka0dHaeG5G4VBQC
         FOw3X5/fvgKvpIn13m92Z3TS3bbEN3Rm4ffCzdKl8IpsTEugoEfZddi2mY8MCgmcSIQt
         CC0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WPv+NcQcrkrtTYPGU4KBIhoBgi9q82qR2kFd2AnbgdM=;
        b=ujXjMDKD8g+ZEJ9qDAtGpUguHFlil0OUKjU8fJo2X/ITeuwRH2H//jcBzj6vi+T2Z6
         fcEQuaLhRkjBueb/Vcnfh6gQ6rTyD288ATaAfu4L3uh6weTc5I3k8RWPAIVoTUbp3+O8
         nXLtpdZM1qbkr+8yeESsehYtIjZ77hSxyWCZwYmXlHKz6VcXYmeCss9ZO5CpgeJz8H5A
         nfHwNSl2u+B+J/JnifPaEy2yfG94rjpFuyw79Bvu2/LpRqYE8lIztBNWCE77Gz/SR6K1
         XH+3u1vZQWPuAXD7uJUdZImW7hG8K9WkreMHLXm6EpVkE2P273tDDe9i/nlHcHeWgBYS
         qvJA==
X-Gm-Message-State: AOAM532ORbJ7JKt9ubQmtYtdiLhwaGNd7xhrjdAus94cy950qqSc8bzx
        2nGgW55jEFcKigaq8kyOJ60SCcEfIZM=
X-Google-Smtp-Source: ABdhPJwtRKCSAJdlWtxFT5iWfDl/OY3lmC77JMJ/v4im8QHGF1ldhOFf4uMN7M9E/lgdxTb9MqreFg==
X-Received: by 2002:aa7:c7ce:: with SMTP id o14mr3781973eds.163.1614167041016;
        Wed, 24 Feb 2021 03:44:01 -0800 (PST)
Received: from localhost.localdomain ([188.25.217.13])
        by smtp.gmail.com with ESMTPSA id r5sm1203921ejx.96.2021.02.24.03.43.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 03:44:00 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [RFC PATCH v2 net-next 00/17] RX filtering in DSA
Date:   Wed, 24 Feb 2021 13:43:33 +0200
Message-Id: <20210224114350.2791260-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is my second stab at creating a list of unicast and multicast
addresses that the DSA CPU port must trap. I am reusing a lot of
Tobias's work which he submitted here:
https://patchwork.kernel.org/project/netdevbpf/cover/20210116012515.3152-1-tobias@waldekranz.com/

I did not yet have the guts to disable flooding towards the CPU port,
but if feedback for the approach taken here is positive, that will be
next.

Tobias Waldekranz (6):
  net: bridge: switchdev: refactor br_switchdev_fdb_notify
  net: bridge: switchdev: include local flag in FDB notifications
  net: bridge: switchdev: send FDB notifications for host addresses
  net: dsa: include bridge addresses which are local in the host fdb
    list
  net: dsa: sync static FDB entries on foreign interfaces to hardware
  net: dsa: mv88e6xxx: Request assisted learning on CPU port

Vladimir Oltean (11):
  net: dsa: reference count the host mdb addresses
  net: dsa: reference count the host fdb addresses
  net: dsa: install the host MDB and FDB entries in the master's RX
    filter
  net: dsa: install the port MAC addresses as host fdb entries
  net: bridge: implement unicast filtering for the bridge device
  net: dsa: add addresses obtained from RX filtering to host addresses
  net: dsa: include fdb entries pointing to bridge in the host fdb list
  net: dsa: replay port and host-joined mdb entries when joining the
    bridge
  net: dsa: replay port and local fdb entries when joining the bridge
  net: bridge: switchdev: let drivers inform which bridge ports are
    offloaded
  net: bridge: offloaded ports are always promiscuous

 drivers/net/dsa/mv88e6xxx/chip.c              |   1 +
 .../marvell/prestera/prestera_switchdev.c     |   4 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |   7 +-
 drivers/net/ethernet/mscc/ocelot_net.c        |  43 +-
 drivers/net/ethernet/rocker/rocker_main.c     |   4 +-
 drivers/net/ethernet/rocker/rocker_ofdpa.c    |   2 +
 drivers/net/ethernet/ti/am65-cpsw-nuss.c      |   2 +
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c |   4 +-
 drivers/net/ethernet/ti/cpsw_new.c            |   1 +
 drivers/net/ethernet/ti/cpsw_switchdev.c      |   4 +-
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c       |   6 +-
 include/linux/if_bridge.h                     |  18 +
 include/net/dsa.h                             |  35 ++
 include/net/switchdev.h                       |  19 +
 net/bridge/br.c                               |   8 +-
 net/bridge/br_device.c                        |  23 +-
 net/bridge/br_fdb.c                           |  57 +-
 net/bridge/br_if.c                            |  19 +-
 net/bridge/br_mdb.c                           | 117 ++++
 net/bridge/br_private.h                       |  14 +-
 net/bridge/br_switchdev.c                     |  74 +--
 net/dsa/dsa2.c                                |  30 +-
 net/dsa/dsa_priv.h                            |  23 +-
 net/dsa/port.c                                |  51 ++
 net/dsa/slave.c                               | 589 ++++++++++++++----
 net/dsa/switch.c                              | 123 +++-
 net/switchdev/switchdev.c                     |  18 +
 27 files changed, 1047 insertions(+), 249 deletions(-)

-- 
2.25.1

