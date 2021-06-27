Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D333B5399
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 16:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbhF0OMu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Jun 2021 10:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230386AbhF0OMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Jun 2021 10:12:48 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 380DBC061574
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:23 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id hq39so24420941ejc.5
        for <netdev@vger.kernel.org>; Sun, 27 Jun 2021 07:10:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h0tZudNmP+CZOfFrVDvasRnP/GmZ+c0542egML3jtyU=;
        b=J68q+mDPFI74iLX30Skyjll/F8J8K3aNl2mtxfkdL4S0VSwE9dzYnFHGUOFuJJngbK
         KsHFQMjFi1tlGfaFY3++OvGLAiO62jTcH34lFEnD4Z47EIqrVObVd+SkXDnhg0xVVqZj
         xMJ7zGIfxl9cGZoEENcTACl7REfLmUCvsfeDyPh768T73uD/iV0RWRot+3aSsg3oYng/
         mTcPZpOMj7HA0oYJZYYTqx6k8g7JVoWgckZXAhKgQOSR2tHPhgYWepkgP2kjgqAa0Rip
         3ZOuvciu8HBHLtViBqrL0lfDC4BJTD7ScXo86QwZ+syq33zUDy7VNu/vgDY5ZjghxuMB
         GJRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=h0tZudNmP+CZOfFrVDvasRnP/GmZ+c0542egML3jtyU=;
        b=Hf9h4m3ayae5vWjXCKzklTnMie4rLVQJtrNXn0pJ2up/gV5Ire2z24URGaN+zucp3K
         2BOBlcrRd1smzJBUUIpaBAgmMh5c6KcWUVNpoi4ShjAzM734QlNfCQZXIshRu9vq29Vk
         1Ir0bhFP27gKp/Rf0IVudgKcoXsWEOLYv2jHH33VhJzvt2Agc7e1dp7R4oZgdiqnkBCG
         vAAVKHw/6nnkdmRuIRVJcOrNn4QLhEHJNEopl8vPQZFU5L6cTE6SxdGrlNetzYBCdRhc
         SiixxPTH4C72Qa434nQXdAFxgw8REJd1gq5K8xvikb2XYiCkPBellJrsL0lUSqsEF1y/
         f/Hw==
X-Gm-Message-State: AOAM531IVO3rnam1hv69MGTyW1u8w/KvrP5TE/6+qR/yyLKNfkMtmdQK
        pGR2FeCS6UGgTBip8CvsA+KhaCcjM1s=
X-Google-Smtp-Source: ABdhPJwZANQn8MOU648SrgrRGzR0Nq3yeGn9fh9aTwi8KPGnsMgh7RO9YVwZBOz4aCKZ5oavttAVLA==
X-Received: by 2002:a17:907:1108:: with SMTP id qu8mr12521205ejb.310.1624803020831;
        Sun, 27 Jun 2021 07:10:20 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id s4sm7857389edu.49.2021.06.27.07.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Jun 2021 07:10:20 -0700 (PDT)
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
Subject: [RFC PATCH v3 net-next 00/15] RX filtering in DSA
Date:   Sun, 27 Jun 2021 17:09:58 +0300
Message-Id: <20210627141013.1273942-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Patch series is sent as RFC due to its dependency on the "Cleanup for
the bridge replay helpers" which has not yet been applied:
https://patchwork.kernel.org/project/netdevbpf/cover/20210627115429.1084203-1-olteanv@gmail.com/
Sending just for early review, I'm hoping that there is still enough
time for a proper submission before the development cycle closes.

This is my third stab at creating a list of unicast and multicast
addresses that the DSA CPU ports must trap. I am reusing a lot of
Tobias's work which he submitted here:
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

Vladimir Oltean (12):
  net: bridge: allow br_fdb_replay to be called for the bridge device
  net: bridge: allow br_mdb_replay to be called for the bridge device
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
 net/bridge/br_mdb.c       |   3 +-
 net/bridge/br_private.h   |   7 +-
 net/bridge/br_switchdev.c |  11 +-
 net/dsa/dsa2.c            |  14 ++
 net/dsa/dsa_priv.h        |  14 ++
 net/dsa/port.c            |  86 ++++++++++++
 net/dsa/slave.c           | 102 +++++++-------
 net/dsa/switch.c          | 276 +++++++++++++++++++++++++++++++++++++-
 10 files changed, 490 insertions(+), 69 deletions(-)

-- 
2.25.1

