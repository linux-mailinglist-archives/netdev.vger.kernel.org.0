Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54EF216975C
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 12:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgBWLpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 06:45:38 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:47890 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726023AbgBWLpi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 06:45:38 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 23 Feb 2020 13:45:36 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 01NBjZET006598;
        Sun, 23 Feb 2020 13:45:35 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next 0/6] act_ct: Software offload of conntrack_in
Date:   Sun, 23 Feb 2020 13:45:01 +0200
Message-Id: <1582458307-17067-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds software offload of connections with an established
ct state using the NF flow table offload infrastructure, so
once such flows are offloaded, they will not pass through conntrack
again, and instead act_ct will restore the conntrack info metadata
on the skb to the state it had on the offload event - established.

Act_ct maintains an FT instance per ct zone. Flow table entries
are created, per ct connection, when connections enter an established
state and deleted otherwise. Once an entry is created, the FT assumes
ownership of the entry, and manages it's aging.

On the datapath, first lookup the skb in the zone's FT before going
into conntrack, and if a matching flow is found, restore the conntrack
info metadata on the skb, and skip calling conntrack.

Netfilter flowtable patches provide the cleanup callback so act_ct can
cleanup the flow table once all entries are removed, as these are
managed by the flowtable.

Note that this patchset is part of the connection tracking offload feature.
Hardware offload of connections with an established ct state series will follow
this one.

Pablo Neira Ayuso (3):
  netfilter: flowtable: pass flowtable to nf_flow_table_iterate()
  netfilter: flowtable: nf_flow_table_iterate() returns the number of
    entries
  netfilter: flowtable: add cleanup callback from garbage collector

Paul Blakey (3):
  net/sched: act_ct: Create nf flow table per zone
  net/sched: act_ct: Offload established connections to flow table
  net/sched: act_ct: Software offload of established flows

 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c |   1 +
 include/net/netfilter/nf_flow_table.h           |   1 +
 include/net/tc_act/tc_ct.h                      |   2 +
 net/netfilter/nf_flow_table_core.c              |  28 +-
 net/sched/Kconfig                               |   2 +-
 net/sched/act_ct.c                              | 381 +++++++++++++++++++++++-
 6 files changed, 402 insertions(+), 13 deletions(-)

-- 
1.8.3.1

