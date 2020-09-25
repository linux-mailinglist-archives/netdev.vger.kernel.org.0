Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E5E27901C
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 20:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbgIYSM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 14:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgIYSM5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 14:12:57 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539DBC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 11:12:57 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id o20so3932151pfp.11
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 11:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=02zW6dFdr53vpo25P5t9KdDN5a85GQ+1sSH1NmQ8I8o=;
        b=OnxVx7ZBYYDD+p95UIG4KhqZHyKa2xA9KZRbJ2B7V7pvB5k4bb6u8tAY8OQfQxXRKL
         Mt+NfhAC+zgu/0woh5pJybbMH+2Fogf0aODS9i9Yvb8xSRbozDX2FPRgrTEn1nIAMVG1
         s8EVbPBH9U2gjS3Hm2Sv+jKZ4Rw5L7Oy8UlQredNmBMulPQY4JoLUyNOi1Trcl06zZwg
         WzqLq6/z7OEB2f/2NtORUus+EdCEm6R3kMBSEEnnjvP/fEkVv7wirFpC+6+sHLo7+5uo
         4/58nVU1T+QZ6X7mK8z+q9i7O06jF3I9f2MnEr+HT0PQ9bvQuCpv+Id4oysDsTeucSwg
         IxDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=02zW6dFdr53vpo25P5t9KdDN5a85GQ+1sSH1NmQ8I8o=;
        b=Xd8OCvCKsC6whbdV9R2lfzQbfNw0z2ddsCrx7xczmX4aVNllNgWKo8GorYTumyc8KI
         8rZdikwAXpZVZsAf+umQzbIQ8ga4fso8R1OMLuKCI9Y65H8sQ9wlCXVNNNDNEw4lAqBa
         GAfqpXYCHCHOZ9kAaOSgi+s5A6p9RBDsjKCXR5oJn36qS8UOQMRZ+pQrTQ1rmBRQzSWr
         vmhzGvnphQIT5I0D95q9fMK+EykL+bNFxEpKg71n5+PSlVLG0uQ9FMppkqw4UgNRJvs5
         /oOV+5MiZ66q0FiRzCQ/Q6g00dK30bm+wCfsfrP/O78jADwnkwhKjLuniNdFrSSmclof
         Vw7g==
X-Gm-Message-State: AOAM531MpZpD9OdjKAGoJxA5Y9/+H+QMRVIthOu313Hnoq3tliTopCmd
        9Z10Qlx8rxixJdBhAG4ZEVc=
X-Google-Smtp-Source: ABdhPJwwijP1IH2Ns0Z5EoN0nLDuve/ZUSUyhiCpxmvsfFoaKkduWRl5ejxkRraDtYYt/N32l3WfOw==
X-Received: by 2002:a62:14d2:0:b029:142:2501:39f2 with SMTP id 201-20020a6214d20000b0290142250139f2mr547169pfu.65.1601057576818;
        Fri, 25 Sep 2020 11:12:56 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id y5sm3261850pge.62.2020.09.25.11.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2020 11:12:55 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, xiyou.wangcong@gmail.com
Subject: [PATCH net 0/3] net: core: fix a lockdep splat in the dev_addr_list.
Date:   Fri, 25 Sep 2020 18:12:46 +0000
Message-Id: <20200925181246.25090-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to avoid lockdep splat.

When a stacked interface graph is changed, netif_addr_lock() is called
recursively and it internally calls spin_lock_nested().
The parameter of spin_lock_nested() is 'dev->lower_level',
this is called subclass.
The problem of 'dev->lower_level' is that while 'dev->lower_level' is
being used as a subclass of spin_lock_nested(), its value can be changed.
So, spin_lock_nested() would be called recursively with the same
subclass value, the lockdep understands a deadlock.
In order to avoid this, a new variable is needed and it is going to be
used as a parameter of spin_lock_nested().
The first and second patch is a preparation patch for the third patch.
In the third patch, the problem will be fixed.

The first patch is to add __netdev_upper_dev_unlink().
An existed netdev_upper_dev_unlink() is renamed to
__netdev_upper_dev_unlink(). and netdev_upper_dev_unlink()
is added as an wrapper of this function.

The second patch is to add the netdev_nested_priv structure.
netdev_walk_all_{ upper | lower }_dev() pass both private functions
and "data" pointer to handle their own things.
At this point, the data pointer type is void *.
In order to make it easier to expand common variables and functions,
this new netdev_nested_priv structure is added.

The third patch is to add a new variable 'nested_level'
into the net_device structure.
This variable will be used as a parameter of spin_lock_nested() of
dev->addr_list_lock.
Due to this variable, it can avoid lockdep splat.

Taehee Yoo (3):
  net: core: add __netdev_upper_dev_unlink()
  net: core: introduce struct netdev_nested_priv for nested interface
    infrastructure
  net: core: add nested_level variable in net_device

 drivers/infiniband/core/cache.c               |  10 +-
 drivers/infiniband/core/cma.c                 |   9 +-
 drivers/infiniband/core/roce_gid_mgmt.c       |   9 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |   9 +-
 drivers/net/bonding/bond_alb.c                |   9 +-
 drivers/net/bonding/bond_main.c               |  10 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  37 ++--
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  24 +--
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  11 +-
 .../mellanox/mlxsw/spectrum_switchdev.c       |  10 +-
 drivers/net/ethernet/rocker/rocker_main.c     |   9 +-
 drivers/net/wireless/quantenna/qtnfmac/core.c |  10 +-
 include/linux/netdevice.h                     |  68 ++++++--
 net/bridge/br_arp_nd_proxy.c                  |  26 ++-
 net/bridge/br_vlan.c                          |  20 ++-
 net/core/dev.c                                | 164 +++++++++++++-----
 net/core/dev_addr_lists.c                     |  12 +-
 17 files changed, 318 insertions(+), 129 deletions(-)

-- 
2.17.1

