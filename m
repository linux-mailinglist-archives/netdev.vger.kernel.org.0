Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2C3CA91E5
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732651AbfIDSir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 14:38:47 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:35289 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732177AbfIDSir (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 14:38:47 -0400
Received: by mail-pf1-f196.google.com with SMTP id 205so11338404pfw.2
        for <netdev@vger.kernel.org>; Wed, 04 Sep 2019 11:38:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=BBo//nHitzuEIQ9rG+En6+dysAP/22gDce3Y5gBl2jE=;
        b=p+hC7nMTRDPpz326xRJhP+WECzeU4g2g2LuzqGJTjod5/lZkRHbM3PslzjwhZM88Yy
         NyOfb/XGVJU8a04/LkrvpbSgdwul11OQiFHVhD0AalbzYmRMxQSFhyvGrEhe32smyLsD
         R8zKtk+j0C08hdEbsPICJKHyTFSvur79e4R/ftbAnsDQesLb/MhqwROzl6KxmBZT11dt
         JZgxp3wgiTl03Ej7h4aoHP/xYtszMGa/3QP6uOVKglUx2X7mhmV9wR6ELUCN7LvVh5/l
         6HX4AhlbkEB/I+P48uxTkUfw9bcdBOMC+VDd9dUWWxsE6+IdkMd8k0pRpj4i0iX8UCX7
         qx1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BBo//nHitzuEIQ9rG+En6+dysAP/22gDce3Y5gBl2jE=;
        b=dG31mMKLoC6W3HO0vUlJlySIlwG7UGxPva7m98MDvdSXI4WUDBwrMQnFvDGmAtHeVR
         hjCdfUbvxWrHBQgEur2dKVuNl3gj0AK173X945ji9lbZP+DQ8UR5n6lRDOSZsyhFFJ52
         ZJ74Ucso1DjTZbNhTUcqfPRmwZUivpOuKI1Ye631QgnC6XSf76fhTwjdeRy90RrMWLAy
         kRmgs4So3pJCPGjqW2fh3xDHxtTkPNKlqmsOMoRSfa3HjiO3JbMumsI9ujoEZpLPEeXU
         ur8a4KFYxQlCME6cPBmXHuYMpxsTKeuG3qCi8y8UtVYjyW1WV8QdzIau4N9VKrMTiz0n
         9NVQ==
X-Gm-Message-State: APjAAAWJQeUFHDMEotkR/bFn1TMRfH1lniEWHkJ6+GShjgoYAuBazCR+
        gH5S2QptlX+asVybTlcmXmw=
X-Google-Smtp-Source: APXvYqwuhOMVIASmBfIl40c7+2uB/8sVrFtMgqJhJc8TOaNsncEcmA+XqY+PWuOdGnnNONfBVZn8oA==
X-Received: by 2002:a63:4612:: with SMTP id t18mr36655112pga.85.1567622326323;
        Wed, 04 Sep 2019 11:38:46 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.1.1.1.1 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id o130sm36561356pfg.171.2019.09.04.11.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 11:38:44 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, jiri@resnulli.us,
        sd@queasysnail.net, roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, sashal@kernel.org,
        hare@suse.de, varun@chelsio.com, ubraun@linux.ibm.com,
        kgraul@linux.ibm.com
Cc:     ap420073@gmail.com
Subject: [PATCH net 00/11] net: fix nested device bugs
Date:   Thu,  5 Sep 2019 03:38:28 +0900
Message-Id: <20190904183828.14260-1-ap420073@gmail.com>
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
	    ip link add name vlan$i link vlan$A type vlan id $i
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

3rd patch splits IFF_BONDING flag into IFF_BONDING and IFF_BONDING_SLAVE.
Before this patch, there is only IFF_BONDING flags, which means
a bonding master or a bonding slave device.
But this single flag could be problem when bonding devices are set to
nested.

8th patch fixes a refcnt leak in the macsec module.

9th patch adds ignore flag to an adjacent structure.
In order to exchange an adjacent node safely, ignore flag is needed.

10th patch makes vxlan add an adjacent link to limit depth level.

11th patch removes unnecessary variables and callback.

Taehee Yoo (11):
  net: core: limit nested device depth
  vlan: use dynamic lockdep key instead of subclass
  bonding: split IFF_BONDING into IFF_BONDING and IFF_BONDING_SLAVE
  bonding: use dynamic lockdep key instead of subclass
  team: use dynamic lockdep key instead of static key
  macsec: use dynamic lockdep key instead of subclass
  macvlan: use dynamic lockdep key instead of subclass
  macsec: fix refcnt leak in module exit routine
  net: core: add ignore flag to netdev_adjacent structure
  vxlan: add adjacent link to limit depth level
  net: remove unnecessary variables and callback

 drivers/net/bonding/bond_alb.c                |   2 +-
 drivers/net/bonding/bond_main.c               |  87 ++++--
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   2 +-
 .../ethernet/qlogic/netxen/netxen_nic_main.c  |   2 +-
 drivers/net/hyperv/netvsc_drv.c               |   3 +-
 drivers/net/macsec.c                          |  50 ++--
 drivers/net/macvlan.c                         |  36 ++-
 drivers/net/team/team.c                       |  61 ++++-
 drivers/net/vxlan.c                           |  71 ++++-
 drivers/scsi/fcoe/fcoe.c                      |   2 +-
 drivers/target/iscsi/cxgbit/cxgbit_cm.c       |   2 +-
 include/linux/if_macvlan.h                    |   3 +-
 include/linux/if_team.h                       |   5 +
 include/linux/if_vlan.h                       |  13 +-
 include/linux/netdevice.h                     |  29 +-
 include/net/bonding.h                         |   4 +-
 include/net/vxlan.h                           |   1 +
 net/8021q/vlan.c                              |   1 -
 net/8021q/vlan_dev.c                          |  32 +--
 net/core/dev.c                                | 252 ++++++++++++++++--
 net/core/dev_addr_lists.c                     |  12 +-
 net/smc/smc_core.c                            |   2 +-
 net/smc/smc_pnet.c                            |   2 +-
 23 files changed, 519 insertions(+), 155 deletions(-)

-- 
2.17.1

