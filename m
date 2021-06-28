Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B697E3B6AAC
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 00:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237038AbhF1WDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 18:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236820AbhF1WDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Jun 2021 18:03:05 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E9A0C061574
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:35 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id df12so28269670edb.2
        for <netdev@vger.kernel.org>; Mon, 28 Jun 2021 15:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U0nTvzpOYlzS2K2vDwU1PVgZJvf6WRgahWZkw2g5X9A=;
        b=Gs7K+GQWGkZvIqCUryoti3K8ump8sZODhDBIH+ICaJRNcNvcTL72wBV7dVwugJqEVb
         SZpib6bRShisBe8ul7m4+pZntBmF4qt+/5ThFMelWuQO6GIp+8SX+bW9xuK/AKSsPtXE
         YFEw4PpHldNg7sPKP2fmnHrR7HNz+VhYDk5Af+YGQV0xUpR4Sfom/QnURXmCF2lM1NRt
         Rk/Jnd97txJapoyxYUbZcLf0QZFwZpHR7H7izEtLMT2RcAMeniBxE7vNhq2zU/8CN8NV
         sYaraAOAy2ZLZ1pda3e1JFh++SW4h1P2Q3h2QpuK74lV7lKOsoDQG2f8i8b8hb162Pwt
         ZxEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U0nTvzpOYlzS2K2vDwU1PVgZJvf6WRgahWZkw2g5X9A=;
        b=FLtN6KX/ISBUr0SX0PFEHmvBggWbOnlolQnSqPBRLNu8rZwnEhFArWWnbXT4qLv3M+
         o0fheO9HGp8yaKIgoMf2QcJ0ivSgJhgsLzBeE8wztmGY8jcEN8YJp6/ML+UI6Mzd+JeP
         4Iz+VF4FF9svq4nEejqJKpoDH3oGo6vz0uPOOssBggZ8Xvf5emDrPujlVYrthtRzUpHh
         WfMgBqDsXYpj7qSjXgoJv6XF8jynny/BAEllSJaRwX4TU5cmnkK/o2TCRvSkdyg0Y1pA
         cWdjDPOxoRJFqluxLc5Xpl0XP+0O25MTpXmwKYN8O05neUpC6vBdunuOpP26LlyaG1xH
         pG+g==
X-Gm-Message-State: AOAM532r+ofuMsXRBkm1I/uYFS2oXsBONx7n8pQ3q0MG0znqvWjE4c04
        CBNUhIAWXF3ORgYyKMzRgMME9gP+XD8=
X-Google-Smtp-Source: ABdhPJyYGJDNGASgSQuOziGwNzOjOhED+XokMA4A7ewKqqcs1IGbWTZ+f+5qn+XEqOX5ZY5vSUOD0g==
X-Received: by 2002:aa7:c997:: with SMTP id c23mr35770797edt.42.1624917633955;
        Mon, 28 Jun 2021 15:00:33 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id dn7sm10146615edb.29.2021.06.28.15.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 15:00:33 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v4 net-next 00/14] RX filtering in DSA
Date:   Tue, 29 Jun 2021 00:59:57 +0300
Message-Id: <20210628220011.1910096-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is my fourth stab (identical to the third one except sent as
non-RFC) at creating a list of unicast and multicast addresses that the
DSA CPU ports must trap. I am reusing a lot of Tobias's work which he
submitted here:
https://patchwork.kernel.org/project/netdevbpf/cover/20210116012515.3152-1-tobias@waldekranz.com/

My additions to Tobias' work come in the form of taking some care that
additions and removals of host addresses are properly balanced, so that
we can do reference counting on them for cross-chip setups and multiple
bridges spanning the same switch (I am working on an NXP board where
both are real requirements).

During the last attempted submission of multiple CPU ports for DSA:
https://patchwork.kernel.org/project/netdevbpf/cover/20210410133454.4768-1-ansuelsmth@gmail.com/

it became clear that the concept of multiple CPU ports would not be
compatible with the idea of address learning on those CPU ports (when
those CPU ports are statically assigned to user ports, not in a LAG)
unless the switch supports complete FDB isolation, which most switches
do not. So DSA needs to manage in software all addresses that are
installed on the CPU port(s), which is what this patch set does.

Compared to all earlier attempts, this series does not fiddle with how
DSA operates the ports in standalone mode at all, just when bridged.
We need to sort that out properly, then any optimization that comes in
standalone mode (i.e. IFF_UNICAST_FLT) can come later.

Tobias Waldekranz (3):
  net: bridge: switchdev: send FDB notifications for host addresses
  net: dsa: sync static FDB entries on foreign interfaces to hardware
  net: dsa: include bridge addresses which are local in the host fdb
    list

Vladimir Oltean (11):
  net: bridge: allow br_fdb_replay to be called for the bridge device
  net: dsa: delete dsa_legacy_fdb_add and dsa_legacy_fdb_del
  net: dsa: introduce dsa_is_upstream_port and dsa_switch_is_upstream_of
  net: dsa: introduce a separate cross-chip notifier type for host MDBs
  net: dsa: reference count the MDB entries at the cross-chip notifier
    level
  net: dsa: introduce a separate cross-chip notifier type for host FDBs
  net: dsa: reference count the FDB addresses at the cross-chip notifier
    level
  net: dsa: install the host MDB and FDB entries in the master's RX
    filter
  net: dsa: include fdb entries pointing to bridge in the host fdb list
  net: dsa: ensure during dsa_fdb_offload_notify that dev_hold and
    dev_put are on the same dev
  net: dsa: replay the local bridge FDB entries pointing to the bridge
    dev too

 include/net/dsa.h         |  39 ++++++
 net/bridge/br_fdb.c       |   7 +-
 net/bridge/br_private.h   |   7 +-
 net/bridge/br_switchdev.c |  11 +-
 net/dsa/dsa2.c            |  14 ++
 net/dsa/dsa_priv.h        |  14 ++
 net/dsa/port.c            |  86 ++++++++++++
 net/dsa/slave.c           | 102 +++++++-------
 net/dsa/switch.c          | 276 +++++++++++++++++++++++++++++++++++++-
 9 files changed, 488 insertions(+), 68 deletions(-)

-- 
2.25.1

