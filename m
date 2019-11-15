Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39C10FDD94
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 13:26:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbfKOMZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 07:25:55 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:41231 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727884AbfKOMZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 07:25:49 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xAFCPiwN022226;
        Fri, 15 Nov 2019 04:25:45 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next v3 0/2] cxgb4: add TC-MATCHALL classifier offload
Date:   Fri, 15 Nov 2019 17:44:19 +0530
Message-Id: <cover.1573818408.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches add support to offload TC-MATCHALL classifier
to hardware to classify all outgoing and incoming traffic on the
underlying port. Only 1 egress and 1 ingress rule each can be
offloaded on the underlying port.

Patch 1 adds support for TC-MATCHALL classifier offload on the egress
side. TC-POLICE is the only action that can be offloaded on the egress
side and is used to rate limit all outgoing traffic to specified max
rate.

Patch 2 adds support for TC-MATCHALL classifier offload on the ingress
side. The same set of actions supported by existing TC-FLOWER
classifier offload can be applied on all the incoming traffic.

Thanks,
Rahul

---
v3:
- Added check in patch 1 to reject police offload if prio is not 1.
- Assign block_shared variable only for TC_SETUP_BLOCK in patch 1.

v2:
- Added check to reject flow block sharing for policers in patch 1.
- Removed logic to fetch free index from end of TCAM in patch 2.
  Must maintain the same ordering as in kernel.


Rahul Lakkireddy (2):
  cxgb4: add TC-MATCHALL classifier egress offload
  cxgb4: add TC-MATCHALL classifier ingress offload

 drivers/net/ethernet/chelsio/cxgb4/Makefile   |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   6 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  79 +++-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  21 +-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.h  |   6 +
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         | 345 ++++++++++++++++++
 .../chelsio/cxgb4/cxgb4_tc_matchall.h         |  50 +++
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c  |   5 +-
 drivers/net/ethernet/chelsio/cxgb4/sched.c    |  56 ++-
 drivers/net/ethernet/chelsio/cxgb4/sched.h    |   1 +
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    |  11 +-
 11 files changed, 543 insertions(+), 40 deletions(-)
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.h

-- 
2.24.0

