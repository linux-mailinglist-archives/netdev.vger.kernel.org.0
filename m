Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263853B73C9
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 16:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbhF2OJs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 10:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbhF2OJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 10:09:46 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF4AC061760
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:17 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id n20so31496606edv.8
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 07:07:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FzNs6k+WH9nnhjpgpXPTc7VwF/FF2gD8HuGqYMS5qGE=;
        b=UENoSF0vdbrkt2VBRVb9yTMcP+TFhrp6iHCqbcu4h7QEoAU/8SJrNC8AHhewuD79/9
         Tscf9R8dRpdPGRLOnx91O6Et9pyPHJik4Z3Bzzv6XpBy0928GrRQ0i7QX75uY3Pvt12j
         B0+hi+NgpLORRqNUuv4RAXd1PHmvJEUw7KxCxcnyUiCjU9TZ8BnVo+nW558M/FpAeWF4
         swbWVr0rVBWx0FXOtvASNb0CGc8ZhYiw6OK8VZ7j8TjlvF6cwFoNowJhRImw+IfBFpMA
         B+yAxZfcFZSEK/Yqxd3oJzfFETJWraWUdgm+dzr+5NC4ml2wvuFZ7mUbbfeGV52bgBRR
         NBTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FzNs6k+WH9nnhjpgpXPTc7VwF/FF2gD8HuGqYMS5qGE=;
        b=F0geuQPo8RKvfxt+C13aqAolefktZ6zQlJ4vPzmAIXhwHhAMYAx011HTc4uHcJTf4r
         a8kY65SNQMgwDs4unLlWijnzCswBCRUWwVzk1XP/TYV8u1iBZ4vPGJ1DMA7FzHvmT88s
         Spb2cRygmsYEj2cCk27RQxEqen8Qq2XK/X79rZUHYgMmLm/0zkK1JJPGsgrItMPt6ecc
         gLv3skK9qGdmNSPPoLvcZ9D2XWIMXzkQqPQuTXphFZfrp1NNYe93sJGWfe7AlWYbV3JH
         jPk1pdkpIBn/qGaAT5aX+nlnc3DB075tTzT8ad3eFsWWHhzBwb7rKJlwjaR2KinmA2Dy
         hl/Q==
X-Gm-Message-State: AOAM531i5K1SmadFmmdIacZmY4cKccUqcb7QSS5dsGjdaI9W80PAEEDr
        tCkoc80iT9K+UgsaRgvujxZjF0pSeHE=
X-Google-Smtp-Source: ABdhPJxwCupxqwye11I9zt+G3U/Paxv5VqKI06sxoIZFwq54yeaY2q1lVnLtV+vQdlpdzDV0dGyDdA==
X-Received: by 2002:a05:6402:375:: with SMTP id s21mr39507883edw.203.1624975636162;
        Tue, 29 Jun 2021 07:07:16 -0700 (PDT)
Received: from localhost.localdomain ([188.26.224.68])
        by smtp.gmail.com with ESMTPSA id b27sm8220121ejl.10.2021.06.29.07.07.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 07:07:15 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 00/15] RX filtering in DSA
Date:   Tue, 29 Jun 2021 17:06:43 +0300
Message-Id: <20210629140658.2510288-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

This is my 5th stab at creating a list of unicast and multicast
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

Changes in v5:
- added READ_ONCE and WRITE_ONCE for fdb->dst
- removed a paranoid WARN_ON in DSA
- added some documentation regarding how 'bridge fdb' is supposed to be
  used with DSA

Tobias Waldekranz (2):
  net: bridge: switchdev: send FDB notifications for host addresses
  net: dsa: include bridge addresses which are local in the host fdb
    list

Vladimir Oltean (13):
  net: bridge: use READ_ONCE() and WRITE_ONCE() compiler barriers for
    fdb->dst
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
  net: dsa: sync static FDB entries on foreign interfaces to hardware
  net: dsa: include fdb entries pointing to bridge in the host fdb list
  net: dsa: ensure during dsa_fdb_offload_notify that dev_hold and
    dev_put are on the same dev
  net: dsa: replay the local bridge FDB entries pointing to the bridge
    dev too

 .../networking/dsa/configuration.rst          |  68 +++++
 include/net/dsa.h                             |  39 +++
 net/bridge/br_fdb.c                           |  37 ++-
 net/bridge/br_private.h                       |   7 +-
 net/bridge/br_switchdev.c                     |  12 +-
 net/dsa/dsa2.c                                |  14 +
 net/dsa/dsa_priv.h                            |  14 +
 net/dsa/port.c                                |  86 ++++++
 net/dsa/slave.c                               | 102 +++----
 net/dsa/switch.c                              | 273 +++++++++++++++++-
 10 files changed, 573 insertions(+), 79 deletions(-)

-- 
2.25.1

