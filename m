Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38BFAF341F
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 17:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730374AbfKGQHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 11:07:24 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:53125 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729680AbfKGQHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 11:07:24 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xA7G7Iro024011;
        Thu, 7 Nov 2019 08:07:19 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next 0/6] cxgb4: add support for TC-MQPRIO Qdisc Offload
Date:   Thu,  7 Nov 2019 21:29:03 +0530
Message-Id: <cover.1573140612.git.rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches add support for offloading TC-MQPRIO Qdisc
to Chelsio T5/T6 NICs. Offloading QoS traffic shaping and pacing
requires using Ethernet Offload (ETHOFLD) resources available on
Chelsio NICs. The ETHOFLD resources are configured by firmware
and taken from the resource pool shared with other Chelsio Upper
Layer Drivers. Traffic flowing through ETHOFLD region requires a
software netdev Tx queue (EOSW_TXQ) exposed to networking stack,
and an underlying hardware Tx queue (EOHW_TXQ) used for sending
packets through hardware.

ETHOFLD region is addressed using EOTIDs, which are per-connection
resource. Hence, EOTIDs are capable of storing only a very small
number of packets in flight. To allow more connections to share
the the QoS rate limiting configuration, multiple EOTIDs must be
allocated to reduce packet drops. EOTIDs are 1-to-1 mapped with
software EOSW_TXQ. Several software EOSW_TXQs can post packets to
a single hardware EOHW_TXQ.

The series is broken down as follows:

Patch 1 queries firmware for maximum available traffic classes,
as well as, start and maximum available indices (EOTID) into ETHOFLD
region, supported by the underlying device.

Patch 2 reworks queue configuration and simplifies MSI-X allocation
logic in preparation for ETHOFLD queues support.

Patch 3 adds skeleton for validating and configuring TC-MQPRIO Qdisc
offload. Also, adds support for software EOSW_TXQs and exposes them
to network stack. Updates Tx queue selection to use fallback NIC Tx
path for unsupported traffic that can't go through ETHOFLD queues.

Patch 4 adds support for managing hardware queues to rate limit
traffic flowing through them. The queues are allocated/removed based
on enabling/disabling TC-MQPRIO Qdisc offload, respectively.

Patch 5 adds Tx path for traffic flowing through software EOSW_TXQ
and EOHW_TXQ. Also, adds Rx path to handle Tx completions.

Patch 6 updates exisiting SCHED API to configure FLOWC based QoS
offload. In the existing QUEUE based rate limiting, multiple queues
sharing a traffic class get the aggreagated max rate limit value.
On the other hand, in FLOWC based rate limiting, multiple queues
sharing a traffic class get their own individual max rate limit
value. For example, if 2 queues are bound to class 0, which is rate
limited to 1 Gbps, then in QUEUE based rate limiting, both the
queues get the aggregate max output of 1 Gbps only. In FLOWC based
rate limiting, each queue gets its own output of max 1 Gbps each;
i.e. 2 queues * 1 Gbps rate limit = 2 Gbps max output.

Thanks,
Rahul


Rahul Lakkireddy (6):
  cxgb4: query firmware for QoS offload resources
  cxgb4: rework queue config and MSI-X allocation
  cxgb4: parse and configure TC-MQPRIO offload
  cxgb4: add ETHOFLD hardware queue support
  cxgb4: add Tx and Rx path for ETHOFLD traffic
  cxgb4: add FLOWC based QoS offload

 drivers/net/ethernet/chelsio/cxgb4/Makefile   |   2 +-
 .../net/ethernet/chelsio/cxgb4/cudbg_entity.h |   3 +
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    |  21 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    | 109 ++-
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |  53 +-
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   | 591 +++++++++----
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c  | 649 ++++++++++++++
 .../ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h  |  43 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.c    | 131 +--
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |  39 +
 drivers/net/ethernet/chelsio/cxgb4/sched.c    | 229 ++++-
 drivers/net/ethernet/chelsio/cxgb4/sched.h    |  10 +-
 drivers/net/ethernet/chelsio/cxgb4/sge.c      | 813 +++++++++++++++---
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h   |   5 +
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h |  38 +
 15 files changed, 2289 insertions(+), 447 deletions(-)
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.c
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_tc_mqprio.h

-- 
2.23.0

