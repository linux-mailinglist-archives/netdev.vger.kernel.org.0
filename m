Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A67E119E576
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 16:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgDDOSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 10:18:08 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:42203 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgDDOSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 10:18:08 -0400
Received: by mail-pg1-f195.google.com with SMTP id g6so3145713pgs.9;
        Sat, 04 Apr 2020 07:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sfQMlMAda3pQng9rGUX57/EKwXiG2hx6/OzhCYgsOX0=;
        b=GQsDgzYK5cUQoXkTM3JxUPe9M7SBL+OHc/aNViwFJP0WCZBpBXtPmiXr1mkua6gKxl
         x+JepIOF5fO5UwzvZ6xxZ0TPTm7QZzbC9bN8ro5NusaDoaS3Dd0CNajvqqnmP/ZSILgO
         p2Fdc/m2y2NnDU0OT0oevWRyNf77GkTBWmLLs9ujmKjWOaKi3moPsGG88cwx3VqE1K0R
         6n0ez6lnmAy6kkXU3tELZDtD3U3txe9OdZN6bFSc6ddyt1NL0snVD2C5vJ03KjTSSDeT
         DyOGjpjSvAAyeoAU+J20awQiCikOClrPHxdcyu41ZWS16NR4OF8jPpMf+rbYU+dm5gAi
         nLmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sfQMlMAda3pQng9rGUX57/EKwXiG2hx6/OzhCYgsOX0=;
        b=SbHReouYXNbwBN8bvx75bjQFj/yfkGw89KLWeUqJljq21AvTGsqGefa/fKWmfF8z5w
         Au+5GDgLp1sCym/vDEJmLRSf7j2dYBcdyrFadbqGcVi6L4MeDl0Tjqt3pMZLTBPjaKWl
         YJ7gF5uErx2qHWYylu29sdro5koq+wypWnX+NTeAYqWn7dIy4WT/dxDyj3VqT0ED8qSN
         XkrGnTRxhEQc8d9SUeGkhZvJopr3bcAM8NMduCbmjkCrNxiUb0SsrvINwzpUWYIbb9O9
         2E0dYdYfFUj2HJCso0i4U1qSWiZKBDMvv46OG2s4tjBQ1oGS2cKznooBTX1C/J9PcAu5
         APyg==
X-Gm-Message-State: AGi0PubGtmEB2pDEnnNQpQLSf93tLDldRbYc1drGUk2h1W1I6Kd8fMXx
        qsrJdohKkEK44MjZJxYg0Il1Bk0C
X-Google-Smtp-Source: APiQypLzkg7K87qM0S0jryChYdRBytH7ZpmUAynTrembTpwUPbFS2pOw72I8MALlQnI7hcja9GilOA==
X-Received: by 2002:a62:52d7:: with SMTP id g206mr13809712pfb.286.1586009886623;
        Sat, 04 Apr 2020 07:18:06 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id l18sm7186139pgc.26.2020.04.04.07.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Apr 2020 07:18:05 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, gregkh@linuxfoundation.org,
        rafael@kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     ap420073@gmail.com, mitch.a.williams@intel.com
Subject: [PATCH net v2 0/3] net: core: avoid unexpected situation in namespace change routine
Date:   Sat,  4 Apr 2020 14:17:57 +0000
Message-Id: <20200404141757.26176-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset is to avoid an unexpected situation when an interface's
namespace is being changed.

When interface's namespace is being changed, dev_change_net_namespace()
is called. This removes and re-allocates many resources that include
sysfs files. The "/net/class/net/<interface name>" is one of them.
If the sysfs creation routine(device_rename()) found duplicate sysfs
file name, it warns about it and fails. But unfortunately, at that point,
dev_change_net_namespace() doesn't return fail because rollback cost
is too high.
So, the interface can't have a sysfs file.

The approach of this patchset is to find the duplicate sysfs file as
fast as possible. If it found that, dev_change_net_namespace() returns
fail immediately with zero rollback cost.

1. The first patch is to add class_has_file_ns() helper function.
   That function will be used for checking the existence of duplicate
   sysfs file.
2. The second patch is to add netdev_class_has_file_ns().
   That function is to check whether duplicate sysfs file in
   the "/sys/class/net*" using class_has_file_ns().
3. The last patch is to avoid an unexpected situation.
   a) If duplicate sysfs is existing, it fails as fast as possible in
      the dev_change_net_namespace()
   b) Acquire rtnl_lock() in both bond_create_sysfs() and
      bond_destroy_sysfs() to avoid race condition.
   c) Do not remove "/sys/class/net/bonding_masters" sysfs file by
      bond_destroy_sysfs() if the file wasn't created
      by bond_create_sysfs().

Test commands#1:
    ip netns add nst
    ip link add bonding_masters type dummy
    modprobe bonding
    ip link set bonding_masters netns nst

Test commands#2:
    ip link add bonding_masters type dummy
    ls /sys/class/net
    modprobe bonding
    modprobe -rv bonding
    ls /sys/class/net

After removing the bonding module, we can see the "bonding_masters"
interface's sysfs will be removed.
This is an unexpected situation.

Change log:
 - v1 -> v2:
   - Implement class_has_file_ns() instead of class_file_and_get_file_ns()
     in the first patch.
   - Change headline in the first patch.
   - Add kernel documentation comment in the first patch.
   - Use class_has_file_ns() in the second patch.
   - Change commit log in the third patch.

Taehee Yoo (3):
  class: add class_has_file_ns() helper function
  net: core: add netdev_class_has_file_ns() helper function
  net: core: avoid warning in dev_change_net_namespace()

 drivers/base/class.c             | 22 ++++++++++++++++++++++
 drivers/net/bonding/bond_sysfs.c | 13 ++++++++++++-
 include/linux/device/class.h     |  3 ++-
 include/linux/netdevice.h        |  2 +-
 include/net/bonding.h            |  1 +
 net/core/dev.c                   |  4 ++++
 net/core/net-sysfs.c             |  6 ++++++
 7 files changed, 48 insertions(+), 3 deletions(-)

-- 
2.17.1

