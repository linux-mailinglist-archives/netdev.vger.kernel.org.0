Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A80D174D67
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 13:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgCAM67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 07:58:59 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60225 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726188AbgCAM66 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 07:58:58 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 1 Mar 2020 14:58:51 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 021CwpcK011348;
        Sun, 1 Mar 2020 14:58:51 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next v2 0/3] act_ct: Software offload of conntrack_in
Date:   Sun,  1 Mar 2020 14:58:40 +0200
Message-Id: <1583067523-1960-1-git-send-email-paulb@mellanox.com>
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

Note that this patchset is part of the connection tracking offload feature.
Hardware offload of connections with an established ct state series will follow
this one.

Changelog:
   v1->v2:
     Removed now unused netfilter patches

Paul Blakey (3):
  net/sched: act_ct: Create nf flow table per zone
  net/sched: act_ct: Offload established connections to flow table
  net/sched: act_ct: Software offload of established flows

 include/net/tc_act/tc_ct.h |   2 +
 net/sched/Kconfig          |   2 +-
 net/sched/act_ct.c         | 363 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 364 insertions(+), 3 deletions(-)

-- 
1.8.3.1

