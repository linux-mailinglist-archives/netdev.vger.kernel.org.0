Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75183B48FC
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 20:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhFYS4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 14:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbhFYSz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 14:55:59 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 452BBC061574
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 11:53:37 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id hz1so16632247ejc.1
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 11:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U2/jGgVdLPXKyIpWZbpqUxVDn+S5dwmJZ3KfQvelnTY=;
        b=tgjrTD42Q2lqPuYK6zH7AjcFER6j0lmrAdgz5Z3V20o10UgVK70kaq69QbeDj3tNq1
         cp43ukFYmer+l77kY5oPqEIuTs2FtSkmOp2zq0cD/SOggF+sT9fY93z3KciqyIk1lkXP
         NPlxMZs/XM40or0CSQXX7/MxBuJC7md4GWQ/ynhr1ucH+c9wFIKrlNJzZhLor2jSOKeP
         mn0G1C6nwXOZOKUgKvDWnpwxKnLIleQrm6lVU6ogwKWgw6yfIj4oZMZwV3pxNd8A2WJO
         YgEuV86JICAiYYf3v/7PIah/Pl54YW2E0eBqh+tJKgdESI2Natw/w+Kyb0/m9AMR+Z/a
         FooA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U2/jGgVdLPXKyIpWZbpqUxVDn+S5dwmJZ3KfQvelnTY=;
        b=cVZHs+KWYz9WwPBNpsT8hWMGJM5eBJ61atKZuf4AfsE5ldE1zyCBQ5pkqk9qbRX/Oo
         5sFrKhq5sy2tNdKrFZ3DYHddJeXwXcuPnYrqq2w12T0uKtPWhfGJk5x7qH04/feaQCzI
         F5eygNOaTaslNiK0pyT885e0IOBafUcMyJc4UwIxeGyPItOCUkDCo5QmB3nvEpsU4YL0
         qwahQ85prE8rVifjAJxf7v/ZLg2ckae30FT0/NXzt696pJvkMeTkLOj/3ZqwAuJoUzQG
         VCZMjL9uP73kkqNkMi3mK8m2LQ+XTUNqdahJL61Q1DxSn7hAgp3wkKScQk2vb6Sx9FBS
         9FcA==
X-Gm-Message-State: AOAM5305lGv4GELtHL9pHaWAKxJxCFaPg6dTsmCSt4m5m2VdA/oExVkU
        Ol93C76SyT1oVM/A9/GH600=
X-Google-Smtp-Source: ABdhPJxvfIFrDumbYSlIrROe8OgYAJB37ZN6voO3/OvPP1aVniU5kmupd6wkC1wFH/yMqdKyitjY+g==
X-Received: by 2002:a17:906:4899:: with SMTP id v25mr12762705ejq.451.1624647215845;
        Fri, 25 Jun 2021 11:53:35 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id w2sm3094954ejn.118.2021.06.25.11.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 11:53:35 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: [PATCH net-next 0/7] Cleanup for the bridge replay helpers
Date:   Fri, 25 Jun 2021 21:53:14 +0300
Message-Id: <20210625185321.626325-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series brings some improvements to the logic added to the
bridge and DSA to handle LAG interfaces sandwiched between a bridge and
a DSA switch port.

        br0
        /  \
       /    \
     bond0  swp2
     /  \
    /    \
  swp0  swp1

In particular, it ensures that the switchdev object additions and
deletions are well balanced per physical port. This is important for
future work in the area of offloading local bridge FDB entries to
hardware in the context of DSA requesting a replay of those entries at
bridge join time (this will be submitted in a future patch series).
Due to some difficulty ensuring that the deletion of local FDB entries
pointing towards the bridge device itself is notified to switchdev in
time (before the switchdev port disconnects from the bridge), this is
potentially still not the final form in which the replay helpers will
exist. I'm thinking about moving from the pull mode (in which DSA
requests the replay) to a push mode (in which the bridge initiates the
replay). Nonetheless, these preliminary changes are needed either way.

The patch series also addresses some feedback from Nikolai which is long
overdue by now (sorry).

Switchdev driver maintainers were deliberately omitted due to the
trivial nature of the driver changes (just a function prototype).

Vladimir Oltean (7):
  net: bridge: include the is_local bit in br_fdb_replay
  net: ocelot: delete call to br_fdb_replay
  net: switchdev: add a context void pointer to struct
    switchdev_notifier_info
  net: bridge: ignore switchdev events for LAG ports which didn't
    request replay
  net: bridge: constify variables in the replay helpers
  net: bridge: allow the switchdev replay functions to be called for
    deletion
  net: dsa: replay a deletion of switchdev objects for ports leaving a
    bridged LAG

 .../ethernet/freescale/dpaa2/dpaa2-switch.c   |  2 +-
 .../marvell/prestera/prestera_switchdev.c     |  6 ++--
 .../mellanox/mlx5/core/en/rep/bridge.c        |  3 ++
 .../mellanox/mlxsw/spectrum_switchdev.c       |  6 ++--
 .../microchip/sparx5/sparx5_switchdev.c       |  2 +-
 drivers/net/ethernet/mscc/ocelot_net.c        | 29 +++++++++++-----
 drivers/net/ethernet/ti/am65-cpsw-switchdev.c |  6 ++--
 drivers/net/ethernet/ti/cpsw_switchdev.c      |  6 ++--
 include/linux/if_bridge.h                     | 30 ++++++++--------
 include/net/switchdev.h                       | 13 +++----
 net/bridge/br_fdb.c                           | 23 +++++++++----
 net/bridge/br_mdb.c                           | 23 +++++++++----
 net/bridge/br_stp.c                           |  4 +--
 net/bridge/br_vlan.c                          | 15 ++++++--
 net/dsa/port.c                                | 34 ++++++++++++++-----
 net/dsa/slave.c                               | 15 ++++++--
 net/switchdev/switchdev.c                     | 25 ++++++++------
 17 files changed, 157 insertions(+), 85 deletions(-)

-- 
2.25.1

