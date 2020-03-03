Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C52FA17766A
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 13:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgCCMw6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 07:52:58 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:53289 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728056AbgCCMw6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 07:52:58 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 3 Mar 2020 14:52:56 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 023Cqu3r009481;
        Tue, 3 Mar 2020 14:52:56 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
Subject: [PATCH net-next v3 0/3] act_ct: Software offload of conntrack_in
Date:   Tue,  3 Mar 2020 14:52:50 +0200
Message-Id: <1583239973-3728-1-git-send-email-paulb@mellanox.com>
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
 net/sched/act_ct.c         | 353 ++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 355 insertions(+), 2 deletions(-)

-- 
1.8.3.1

