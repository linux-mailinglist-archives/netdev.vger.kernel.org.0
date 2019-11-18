Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00E3D1009EA
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 18:08:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfKRRIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 12:08:49 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:28583 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbfKRRIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 12:08:49 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xAIH8eE0018666;
        Mon, 18 Nov 2019 09:08:41 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next v4 0/3] cxgb4: add TC-MATCHALL classifier offload
Date:   Mon, 18 Nov 2019 22:30:16 +0530
Message-Id: <cover.1574089391.git.rahul.lakkireddy@chelsio.com>
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

Patch 2 adds logic to reject the current rule offload if its priority
conflicts with existing rules in the TCAM.

Patch 3 adds support for TC-MATCHALL classifier offload on the ingress
side. The same set of actions supported by existing TC-FLOWER
classifier offload can be applied on all the incoming traffic.

Thanks,
Rahul

---
v4:
- Removed check in patch 1 to reject police offload if prio is not 1.
- Moved TC_SETUP_BLOCK code to separate function in patch 1.
- Added logic to ensure the prio passed by TC doesn't conflict with
  other rules in TCAM in patch 2.
- Higher index has lower priority than lower index in TCAM. So, rework
  cxgb4_get_free_ftid() to search free index from end of TCAM in
  descending order in patch 2.
- Added check to ensure the matchall rule's prio doesn't conflict with
  other rules in TCAM in patch 3.
- Added logic to fill default mask for VIID, if none has been
  provided, to prevent conflict with duplicate VIID rules in patch 3.
- Used existing variables in private structure to fill VIID info,
  instead of extracting the info manually in patch 3.

v3:
- Added check in patch 1 to reject police offload if prio is not 1.
- Assign block_shared variable only for TC_SETUP_BLOCK in patch 1.

v2:
- Added check to reject flow block sharing for policers in patch 1.
- Removed logic to fetch free index from end of TCAM in patch 2.
  Must maintain the same ordering as in kernel.


Rahul Lakkireddy (3):
  cxgb4: add TC-MATCHALL classifier egress offload
  cxgb4: check rule prio conflicts before offload
  cxgb4: add TC-MATCHALL classifier ingress offload

 drivers/net/ethernet/chelsio/cxgb4/Makefile   |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |  11 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.c | 119 ++++--
 .../net/ethernet/chelsio/cxgb4/cxgb4_filter.h |   1 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |  91 ++++-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.c  |  52 ++-
 .../ethernet/chelsio/cxgb4/cxgb4_tc_flower.h  |   6 +
 .../chelsio/cxgb4/cxgb4_tc_matchall.c         | 354 ++++++++++++++++++
 .../chelsio/cxgb4/cxgb4_tc_matchall.h         |  49 +++
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c  |   5 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_tc_u32.c |  36 +-
 drivers/net/ethernet/chelsio/cxgb4/sched.c    |  56 ++-
 drivers/net/ethernet/chelsio/cxgb4/sched.h    |   1 +
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c    |  11 +-
 14 files changed, 707 insertions(+), 88 deletions(-)
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.c
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_matchall.h

-- 
2.24.0

