Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEDB20F589
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 15:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730358AbgF3NYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 09:24:30 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:47897 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgF3NYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 09:24:30 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 05UDOLxT014280;
        Tue, 30 Jun 2020 06:24:22 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, nirranjan@chelsio.com,
        vishal@chelsio.com, dt@chelsio.com
Subject: [PATCH net-next v3 0/3] cxgb4: add mirror action support for TC-MATCHALL
Date:   Tue, 30 Jun 2020 18:41:27 +0530
Message-Id: <cover.1593521119.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches add support to mirror all ingress traffic
for TC-MATCHALL ingress offload.

Patch 1 adds support to dynamically create a mirror Virtual Interface
(VI) that accepts all mirror ingress traffic when mirror action is
set in TC-MATCHALL offload.

Patch 2 adds support to allocate mirror Rxqs and setup RSS for the
mirror VI.

Patch 3 adds support to replicate all the main VI configuration to
mirror VI. This includes replicating MTU, promiscuous mode,
all-multicast mode, and enabled netdev Rx feature offloads.

Thanks,
Rahul

v3:
- Replace mirror VI refcount_t with normal u32 variable in all patches.
- Add back calling cxgb4_port_mirror_start() in cxgb_open(), which
  was there in v1, but got missed in v2 during refactoring, in patch
  3.

v2:
- Add mutex to protect all mirror VI data, instead of just
  mirror Rxqs, in patch 1 and 2.
- Remove the un-needed mirror Rxq mutex in patch 2.
- Simplify the replication code by refactoring t4_set_rxmode()
  to handle mirror VI, instead of duplicating the t4_set_rxmode()
  calls in multiple places in patch 3.

Rahul Lakkireddy (3):
  cxgb4: add mirror action to TC-MATCHALL offload
  cxgb4: add support for mirror Rxqs
  cxgb4: add main VI to mirror VI config replication

 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  24 +-
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |  66 ++-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 445 ++++++++++++++++--
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  16 +-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.h  |   3 +-
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         |  57 ++-
 .../chelsio/cxgb4/cxgb4_tc_matchall.h         |   1 +
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    |  43 +-
 8 files changed, 606 insertions(+), 49 deletions(-)

-- 
2.24.0

