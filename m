Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E42DC2DC1D
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 13:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfE2Lsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 07:48:35 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46876 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726806AbfE2Lsf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 07:48:35 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hVx4K-0004VG-1c; Wed, 29 May 2019 13:48:32 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     eric.dumazet@gmail.com
Subject: [PATCH net-next 0/7] net: add rcu annotations for ifa_list
Date:   Wed, 29 May 2019 13:43:25 +0200
Message-Id: <20190529114332.19163-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet reported follwing problem:

  It looks that unless RTNL is held, accessing ifa_list needs proper RCU
  protection.  indev->ifa_list can be changed under us by another cpu
  (which owns RTNL) [..]

  A proper rcu_dereference() with an happy sparse support would require
  adding __rcu attribute.

This patch series does that: add __rcu to the ifa_list pointers.
That makes sparse complain, so the series also adds the required
rcu_assign_pointer/dereference helpers where needed.

All patches except the last one are preparation work.
Two new macros are introduced for in_ifaddr walks.

Last patch adds the __rcu annotations and the assign_pointer/dereference
helper calls.

This patch is a bit large, but I found no better way -- other
approaches (annotate-first or add helpers-first) all result in
mid-series sparse warnings.

This series is submitted vs. net-next rather than net for several
reasons:

1. Its (mostly) compile-tested only
2. Second patch changes behaviour wrt. secondary addresses
   (see changelog)
3. the afs change removes one un-needed compilation unit
4. The problem exists for a very long time (2004), so it doesn't
   seem to be urgent to fix this -- rcu use to free ifa_list
   predates the git era.

Florian Westphal (7):
      net: inetdevice: provide replacement iterators for in_ifaddr walk
      devinet: use in_dev_for_each_ifa_rcu in more places
      afs: switch to in_dev_for_each_ifa_rcu
      netfilter: use in_dev_for_each_ifa_rcu
      net: use new in_dev_ifa iterators
      drivers: use in_dev_for_each_ifa_rtnl/rcu
      net: ipv4: provide __rcu annotation for ifa_list

 drivers/infiniband/core/roce_gid_mgmt.c              |    5 
 drivers/infiniband/hw/cxgb4/cm.c                     |    9 -
 drivers/infiniband/hw/i40iw/i40iw_cm.c               |    7 
 drivers/infiniband/hw/i40iw/i40iw_main.c             |    6 
 drivers/infiniband/hw/i40iw/i40iw_utils.c            |   12 -
 drivers/infiniband/hw/nes/nes.c                      |    8 
 drivers/infiniband/hw/usnic/usnic_ib_main.c          |   15 +
 drivers/isdn/hysdn/hysdn_net.c                       |    6 
 drivers/isdn/i4l/isdn_net.c                          |   20 +-
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c |    8 
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c     |    5 
 drivers/net/ethernet/via/via-velocity.h              |    2 
 drivers/net/plip/plip.c                              |    4 
 drivers/net/vmxnet3/vmxnet3_drv.c                    |   19 +-
 drivers/net/wan/hdlc_cisco.c                         |   11 -
 drivers/net/wireless/ath/ath6kl/cfg80211.c           |    4 
 drivers/net/wireless/marvell/mwifiex/cfg80211.c      |    2 
 fs/afs/Makefile                                      |    1 
 fs/afs/cmservice.c                                   |   49 +++--
 fs/afs/internal.h                                    |   15 -
 include/linux/inetdevice.h                           |   19 +-
 net/core/netpoll.c                                   |   10 -
 net/core/pktgen.c                                    |    8 
 net/ipv4/devinet.c                                   |  146 ++++++++++-------
 net/ipv4/fib_frontend.c                              |   24 +-
 net/ipv4/igmp.c                                      |    5 
 net/ipv4/netfilter/nf_tproxy_ipv4.c                  |    9 -
 net/ipv6/addrconf.c                                  |    4 
 net/mac80211/main.c                                  |    4 
 net/netfilter/nf_conntrack_broadcast.c               |    9 -
 net/netfilter/nf_nat_redirect.c                      |   12 -
 net/netfilter/nfnetlink_osf.c                        |    5 
 net/sctp/protocol.c                                  |    2 
 net/smc/smc_clc.c                                    |   11 -
 fs/afs/netdevices.c                                    |   48 -----
 35 files changed, 294 insertions(+), 230 deletions(-)

