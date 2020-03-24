Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E05619112F
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgCXNcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:32:35 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:59768 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728619AbgCXNRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 09:17:37 -0400
Received: from Internal Mail-Server by MTLPINE1 (envelope-from paulb@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 24 Mar 2020 15:17:28 +0200
Received: from reg-r-vrt-019-120.mtr.labs.mlnx (reg-r-vrt-019-120.mtr.labs.mlnx [10.213.19.120])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 02ODHSYp030372;
        Tue, 24 Mar 2020 15:17:28 +0200
From:   Paul Blakey <paulb@mellanox.com>
To:     Paul Blakey <paulb@mellanox.com>, Oz Shlomo <ozsh@mellanox.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH net-next 0/3] netfilter: flowtable: Support offload of tuples in parallel
Date:   Tue, 24 Mar 2020 15:17:18 +0200
Message-Id: <1585055841-14256-1-git-send-email-paulb@mellanox.com>
X-Mailer: git-send-email 1.8.4.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following patchset opens support for offloading tuples in parallel.

Patches for netfilter replace the flow table block lock with rw sem,
and use a work entry per offload command, so they can be run in
parallel under rw sem read lock.

MLX5 patch removes the unguarded ct entries list, and instead uses
rhashtable's iterator to support the above.


Paul Blakey (3):
  netfilter: flowtable: Use rw sem as flow block lock
  netfilter: flowtable: Use work entry per offload command
  net/mlx5: CT: Use rhashtable's ct entries instead of a seperate list

 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 19 +++-----
 include/net/netfilter/nf_flow_table.h              |  2 +-
 net/netfilter/nf_flow_table_core.c                 | 11 +++--
 net/netfilter/nf_flow_table_offload.c              | 50 ++++++++--------------
 4 files changed, 30 insertions(+), 52 deletions(-)

-- 
1.8.3.1

