Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC7EEDF54A
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730014AbfJUSr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:47:26 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45000 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfJUSrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 14:47:25 -0400
Received: by mail-pg1-f194.google.com with SMTP id e10so8327117pgd.11;
        Mon, 21 Oct 2019 11:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=YZXh3CQH5hLwX4w45E8/P8x2cIxsApVTP1i3nP57c5E=;
        b=esS4U4OeTMDmo703W4RXU147NNlSkJx0HRDfPzxm1s8kWuQy7YY8m3SgNkA1lSZ2Gs
         bkjPWfe1pYmSMo4c4HMUcjMQxwtfxBR6o9d3YisWvVCL3EVkZheQknOm0IwMSt3td0cQ
         ISDth2bMSQA+r3fbGghp7JY26KACDCDT0QZ9UYfKn5M5ebC0RKOTRNAbK6DHYmzpMBPI
         99X5p0ukGCPlFEUgjL9LZuyqWoMQWTHv1HerP4y7VuosPa9vP/eFYyTQB5s+2L/DarA2
         RiHybvtF5P+apLEeqkmju7Ewk37K3vk2NqGkTzhiQ64Q4W2GbxARnQDAq7W/YgSclSbD
         TZhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YZXh3CQH5hLwX4w45E8/P8x2cIxsApVTP1i3nP57c5E=;
        b=tgtxeYEAl9Gh8uE2tdKfjGno15Dz0vkiGY3eQqi03ypW7YyGsuwfxKISYEcuXRmeYZ
         abK2TlMMi9l/rcO2RQMlJO429UhnmOXPPm56XEXUs0XSOe+PJcV3vjhxeU/keD21TH2q
         rez1M4llt7bHCFJu7/ddXplCzuIoxeDWRKGfDMauqrXQuaYbU2uyY67JlgNJPMsef60+
         jn/9uK+SBibwtNzS26CwvYmpMe3g6amZHTJI3adayu8eQlbIrCvL8jkypOU0ziqxCCic
         07Gwn2msie4xaWAM4/sTAhY5hEZavLwkQ6HPRWGvBMz6hYRNOQWNyGh3gAvt7Cj9Ggnx
         1jAw==
X-Gm-Message-State: APjAAAU5rlJm5SUhTjIO8RyTScmgsLfZ16E39H2nIzVy7q01IUMqeDbP
        W2Pg00k1B7hLw037jqb4rCE=
X-Google-Smtp-Source: APXvYqz/QbP9MmRHvi5TFxXNyYsd+zF2eTrTOL28Rd+Sr60WUEnkAVNWcXWK9HNw+T1fg5EKGpjFqg==
X-Received: by 2002:aa7:9472:: with SMTP id t18mr24061892pfq.261.1571683644847;
        Mon, 21 Oct 2019 11:47:24 -0700 (PDT)
Received: from localhost.localdomain ([110.35.161.54])
        by smtp.gmail.com with ESMTPSA id t3sm19449792pje.7.2019.10.21.11.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 11:47:23 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, jakub.kicinski@netronome.com,
        johannes@sipsolutions.net, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jiri@resnulli.us, sd@queasysnail.net,
        roopa@cumulusnetworks.com, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com, stephen@networkplumber.org,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        jay.vosburgh@canonical.com, schuffelen@google.com, bjorn@mork.no
Cc:     ap420073@gmail.com
Subject: [PATCH net v5 00/10] net: fix nested device bugs
Date:   Mon, 21 Oct 2019 18:47:10 +0000
Message-Id: <20191021184710.12981-1-ap420073@gmail.com>
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
VLAN, BONDING, TEAM, MACSEC, MACVLAN, IPVLAN, and VXLAN.
But I couldn't test all interface types so there could be more device
types, which have similar problems.
Maybe qmi_wwan.c code could have same problem.
So, I would appreciate if someone test qmi_wwan.c and other modules.

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

2nd patch fixes Qdisc lockdep related problem.
Before this patch, devices use static lockdep map.
So, if devices that are same types are nested, lockdep will warn about
recursive situation.
These patches make these devices use dynamic lockdep key instead of
static lock or subclass.

3rd patch fixes unexpected IFF_BONDING bit unset.
When nested bonding interface scenario, bonding interface could lost it's
IFF_BONDING flag. This should not happen.
This patch adds a condition before unsetting IFF_BONDING.

4th patch fixes nested locking problem in bonding interface
Bonding interface has own lock and this uses static lock.
Bonding interface could be nested and it uses same lockdep key.
So that unexisting lockdep warning occurs.

5th patch fixes nested locking problem in team interface
Team interface has own lock and this uses static lock.
Team interface could be nested and it uses same lockdep key.
So that unexisting lockdep warning occurs.

6th patch fixes a refcnt leak in the macsec module.
When the macsec module is unloaded, refcnt leaks occur.
But actually, that holding refcnt is unnecessary.
So this patch just removes these code.

7th patch adds ignore flag to an adjacent structure.
In order to exchange an adjacent node safely, ignore flag is needed.

8th patch makes vxlan add an adjacent link to limit depth level.
Vxlan interface could set it's lower interface and these lower interfaces
are handled recursively.
So, if the depth of lower interfaces is too deep, stack overflow could
happen.

9th patch removes unnecessary variables and callback.
After 1st patch, subclass callback and variables are unnecessary.
This patch just removes these variables and callback.

10th patch fix refcnt leaks in the virt_wifi module
Like every nested interface, the upper interface should be deleted
before the lower interface is deleted.
In order to fix this, the notifier routine is added in this patch.

v4 -> v5 :
 - Update log messages
 - Move variables position, 1st patch
 - Fix iterator routine, 1st patch
 - Add generic lockdep key code, which replaces 2, 4, 5, 6, 7 patches.
 - Log message update, 10th patch
 - Fix wrong error value in error path of __init routine, 10th patch
 - hold module refcnt when interface is created, 10th patch
v3 -> v4 :
 - Add new 12th patch to fix refcnt leaks in the virt_wifi module
 - Fix wrong usage netdev_upper_dev_link() in the vxlan.c
 - Preserve reverse christmas tree variable ordering in the vxlan.c
 - Add missing static keyword in the dev.c
 - Expose netdev_adjacent_change_{prepare/commit/abort} instead of
   netdev_adjacent_dev_{enable/disable}
v2 -> v3 :
 - Modify nesting infrastructure code to use iterator instead of recursive.
v1 -> v2 :
 - Make the 3rd patch do not add a new priv_flag.

Taehee Yoo (10):
  net: core: limit nested device depth
  net: core: add generic lockdep keys
  bonding: fix unexpected IFF_BONDING bit unset
  bonding: use dynamic lockdep key instead of subclass
  team: fix nested locking lockdep warning
  macsec: fix refcnt leak in module exit routine
  net: core: add ignore flag to netdev_adjacent structure
  vxlan: add adjacent link to limit depth level
  net: remove unnecessary variables and callback
  virt_wifi: fix refcnt leak in module exit routine

 drivers/net/bonding/bond_alb.c                |   2 +-
 drivers/net/bonding/bond_main.c               |  30 +-
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |   2 +-
 .../net/ethernet/netronome/nfp/nfp_net_repr.c |  18 -
 drivers/net/hamradio/bpqether.c               |  22 -
 drivers/net/hyperv/netvsc_drv.c               |   2 -
 drivers/net/ipvlan/ipvlan_main.c              |   2 -
 drivers/net/macsec.c                          |  18 -
 drivers/net/macvlan.c                         |  19 -
 drivers/net/ppp/ppp_generic.c                 |   2 -
 drivers/net/team/team.c                       |  16 +-
 drivers/net/vrf.c                             |   1 -
 drivers/net/vxlan.c                           |  53 +-
 .../net/wireless/intersil/hostap/hostap_hw.c  |  25 -
 drivers/net/wireless/virt_wifi.c              |  54 +-
 include/linux/if_macvlan.h                    |   1 -
 include/linux/if_team.h                       |   1 +
 include/linux/if_vlan.h                       |  11 -
 include/linux/netdevice.h                     |  61 +-
 include/net/bonding.h                         |   2 +-
 include/net/vxlan.h                           |   1 +
 net/8021q/vlan.c                              |   1 -
 net/8021q/vlan_dev.c                          |  33 -
 net/batman-adv/soft-interface.c               |  32 -
 net/bluetooth/6lowpan.c                       |   8 -
 net/bridge/br_device.c                        |   8 -
 net/core/dev.c                                | 618 +++++++++++++-----
 net/core/dev_addr_lists.c                     |  12 +-
 net/core/rtnetlink.c                          |   1 +
 net/dsa/master.c                              |   5 -
 net/dsa/slave.c                               |  12 -
 net/ieee802154/6lowpan/core.c                 |   8 -
 net/l2tp/l2tp_eth.c                           |   1 -
 net/netrom/af_netrom.c                        |  23 -
 net/rose/af_rose.c                            |  23 -
 net/sched/sch_generic.c                       |  17 +-
 net/smc/smc_core.c                            |   2 +-
 net/smc/smc_pnet.c                            |   2 +-
 38 files changed, 628 insertions(+), 521 deletions(-)

-- 
2.17.1

