Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00682B3BC2
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 15:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733176AbfIPNsO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 09:48:14 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38517 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727806AbfIPNsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 09:48:14 -0400
Received: by mail-pg1-f195.google.com with SMTP id x10so40868pgi.5
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 06:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+p0nFe8JLk/LesMlQ1J4lZLATbWYAw3Q1ZkznPHsYic=;
        b=uxDkH99sgsjpW5h3qSuEmE6zX1AuvDqGRPwPx1b2fKisNDo29hUZ5z0cFifaasjrGa
         0A8sxqXTLg2AINOSDaZzY7AVUn4IKKWshlCzYE/ElBONbF2fG4h6kxHQbMR7yRVckTOM
         vkoj25LWSNYCv+yXnWxaG7ycnnKR5wJU82DvI492I5hmkHH5TJI9nLbV+rILj8mlAZWe
         WshTgmcGRXvGQDbKo8kNUuaHVbmh+aiGXbQnQfGoz49A5wYNZyue3Sd1suAIH14N71QD
         cfPFQVDEdLlDAWOs8RpcbBVRMCU8pCGZrAWRJTz7YQtrgPbJ4RyYWherbwdxrxC7FEYI
         h5Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+p0nFe8JLk/LesMlQ1J4lZLATbWYAw3Q1ZkznPHsYic=;
        b=AyFCH4AiZwG9+8qjYPWuMSOU4iDx6azvU0NeIGIixtbkNYThOzNRfxKvXBmuv2Z2nk
         m1dtjwsTxdyISVAqGU1HdqQfTr3Cnimn6+FQlIiLVHtrr1WRVjGeAEIhar6Jk5ZY2E9T
         d8VvtjU7suvj719JUsiJYZo8U4dKqfetJsTGWnMmrNZ1rvZe5m840gVgQ5K2hfPhx8Ac
         0Fj5ds0t6Kp1LGP/tAx/Pi5CAigzb62aWxji40xDSzjvjhYhlYMmmq4ZnT3rTotm36bg
         nQT1XTmaYDqr9EVnXckU3JCRMrg3itCTlITaW2aL4wAM/pmzVoWd8C0FCHwpXtBjtjJ8
         LYCg==
X-Gm-Message-State: APjAAAW50THH89mqdMSTnbWQV/J1wNfmOD7t6A6p8ElwoBIPlHwAtu6b
        Qlgbjp4Q+1mnVu/Pi+17yf0=
X-Google-Smtp-Source: APXvYqw/TBiVO8QFurTfRn9COmArYxnxjpGR5XC7iQWwO3Ls0sI2TV6+Ecsg1/f0b1h7KErex/Yykg==
X-Received: by 2002:a63:cf4a:: with SMTP id b10mr610969pgj.276.1568641693348;
        Mon, 16 Sep 2019 06:48:13 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.1.1.1.1 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id z20sm2822266pjn.12.2019.09.16.06.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 06:48:12 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com
Cc:     ap420073@gmail.com
Subject: [PATCH net v3 00/11] net: fix nested device bugs
Date:   Mon, 16 Sep 2019 22:47:51 +0900
Message-Id: <20190916134802.8252-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset fixes several bugs that are related to nesting
device infrastructure.
Current nesting infrastructure code doesn't limit the depth level of
devices. nested devices could be handled recursively. at that moment,
it needs huge memory and stack overflow could occur.
Below devices type have same bug.
VLAN, BONDING, TEAM, MACSEC, MACVLAN and VXLAN.

Test commands:
    ip link add dummy0 type dummy
    ip link add vlan1 link dummy0 type vlan id 1

    for i in {2..100}
    do
	    let A=$i-1
	    ip link add vlan$i link vlan$A type vlan id $i
    done
    ip link del dummy0

1st patch actually fixes the root cause.
It adds new common variables {upper/lower}_level that represent
depth level. upper_level variable is depth of upper devices.
lower_level variable is depth of lower devices.

      [U][L]       [U][L]
vlan1  1  5  vlan4  1  4
vlan2  2  4  vlan5  2  3
vlan3  3  3    |
  |            |
  +------------+
  |
vlan6  4  2
dummy0 5  1

After this patch, the nesting infrastructure code uses this variable to
check the depth level.

2, 4, 5, 6, 7 patches fix lockdep related problem.
Before this patch, devices use static lockdep map.
So, if devices that are same type is nested, lockdep will warn about
recursive situation.
These patches make these devices use dynamic lockdep key instead of
static lock or subclass.

3rd patch fixes unexpected IFF_BONDING bit unset.

8th patch fixes a refcnt leak in the macsec module.

9th patch adds ignore flag to an adjacent structure.
In order to exchange an adjacent node safely, ignore flag is needed.

10th patch makes vxlan add an adjacent link to limit depth level.

11th patch removes unnecessary variables and callback.

v2 -> v3 :
 - Modify nesting infrastructure code to use iterator instead of recursive.
v1 -> v2 :
 - Make the 3rd patch do not add a new priv_flag.

Taehee Yoo (11):
  net: core: limit nested device depth
  vlan: use dynamic lockdep key instead of subclass
  bonding: fix unexpected IFF_BONDING bit unset
  bonding: use dynamic lockdep key instead of subclass
  team: use dynamic lockdep key instead of static key
  macsec: use dynamic lockdep key instead of subclass
  macvlan: use dynamic lockdep key instead of subclass
  macsec: fix refcnt leak in module exit routine
  net: core: add ignore flag to netdev_adjacent structure
  vxlan: add adjacent link to limit depth level
  net: remove unnecessary variables and callback

 drivers/net/bonding/bond_alb.c                |   2 +-
 drivers/net/bonding/bond_main.c               |  81 +++-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   2 +-
 drivers/net/macsec.c                          |  50 +-
 drivers/net/macvlan.c                         |  36 +-
 drivers/net/team/team.c                       |  61 ++-
 drivers/net/vxlan.c                           |  71 ++-
 include/linux/if_macvlan.h                    |   3 +-
 include/linux/if_team.h                       |   5 +
 include/linux/if_vlan.h                       |  13 +-
 include/linux/netdevice.h                     |  20 +-
 include/net/bonding.h                         |   4 +-
 include/net/vxlan.h                           |   1 +
 net/8021q/vlan.c                              |   1 -
 net/8021q/vlan_dev.c                          |  32 +-
 net/core/dev.c                                | 456 +++++++++++++++---
 net/core/dev_addr_lists.c                     |  12 +-
 net/smc/smc_core.c                            |   2 +-
 net/smc/smc_pnet.c                            |   2 +-
 19 files changed, 667 insertions(+), 187 deletions(-)

-- 
2.17.1

