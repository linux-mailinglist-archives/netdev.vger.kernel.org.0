Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5280295321
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 21:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438943AbgJUTvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 15:51:11 -0400
Received: from mga07.intel.com ([134.134.136.100]:57150 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410316AbgJUTvL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Oct 2020 15:51:11 -0400
IronPort-SDR: ihiLIbR0cEFWWrklo9gLB8CUYtfWXSo3d0m3K5/2UhEpkV5D0F1Ens6Dcjio08HDxdIg7buS0n
 DIsXqQSHr9TA==
X-IronPort-AV: E=McAfee;i="6000,8403,9781"; a="231618706"
X-IronPort-AV: E=Sophos;i="5.77,402,1596524400"; 
   d="scan'208";a="231618706"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2020 12:51:10 -0700
IronPort-SDR: 6E08S0l4CjvlAFRX2B1j/RMlD+FACzGfzX2fOVUT4fM3QFOfF4al/dJGKpUvCLLg5CO7E4jrS/
 4IXu5NCVNgIQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,402,1596524400"; 
   d="scan'208";a="392834634"
Received: from harshitha-linux4.jf.intel.com ([10.166.17.87])
  by orsmga001.jf.intel.com with ESMTP; 21 Oct 2020 12:51:10 -0700
From:   Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     tom@herbertland.com, carolyn.wyborny@intel.com,
        jacob.e.keller@intel.com, amritha.nambiar@intel.com,
        Harshitha Ramamurthy <harshitha.ramamurthy@intel.com>
Subject: [RFC PATCH net-next 0/3] sock: Fix sock queue mapping to include device
Date:   Wed, 21 Oct 2020 12:47:40 -0700
Message-Id: <20201021194743.781583-1-harshitha.ramamurthy@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In XPS, the transmit queue selected for a packet is saved in the associated
sock for the packet and is then used to avoid recalculating the queue
on subsequent sends. The problem is that the corresponding device is not
also recorded so that when the queue mapping is referenced it may
correspond to a different device than the sending one, resulting in an
incorrect queue being used for transmit. Particularly with xps_rxqs, this
can lead to non-deterministic behaviour as illustrated below.

Consider a case where xps_rxqs is configured and there is a difference
in number of Tx and Rx queues. Suppose we have 2 devices A and B. Device A
has 0-7 queues and device B has 0-15 queues. Packets are transmitted from
Device A but packets are received on B. For packets received on queue 0-7
of Device B, xps_rxqs will be applied for reply packets to transmit on
Device A's queues 0-7. However, when packets are received on queues
8-15 of Device B, normal XPS is used to reply packets when transmitting
from Device A. This leads to non-deterministic behaviour. The case where
there are fewer receive queues is even more insidious. Consider Device
A, the trasmitting device has queues 0-15 and Device B, the receiver
has queues 0-7. With xps_rxqs enabled, the packets will be received only
on queues 0-7 of Device B, but sent only on 0-7 queues of Device A
thereby causing a load imbalance.

This patch set fixes the issue by recording both the device (via
ifindex) and the queue in the sock mapping. The pair is set and
retrieved atomically. While retrieving the queue using the get
functions, we check if the ifindex held is the same as the ifindex
stored before returning the queue held. For instance during transmit,
we return a valid queue number only after checking if the ifindex stored
matches the device currently held.

This patch set contains:
	- Definition of dev_and_queue structure to hold the ifindex
	  and queue number
	- Generic functions to get, set, and clear dev_and_queue
	  structure
	- Change sk_tx_queue_{get,set,clear} to
	  sk_tx_dev_and_queue_{get,set,clear}
	- Modify callers of above to use new interface
	- Change sk_rx_queue_{get,set,clear} to 
          sk_rx_dev_and_queue_{get,set,clear}
        - Modify callers of above to use new interface

This patch set was tested as follows:
	- XPS with both xps_cpus and xps_rxqs works as expected
	- the Q index is calculated only once when picking a tx queue
	  per connection. For ex: in netdev_pick_tx

Tom Herbert (3):
  sock: Definition and general functions for dev_and_queue structure
  sock: Use dev_and_queue structure for RX queue mapping in sock
  sock: Use dev_and_queue structure for TX queue mapping in sock

 .../mellanox/mlx5/core/en_accel/ktls_rx.c     |   6 +-
 drivers/net/hyperv/netvsc_drv.c               |   4 +-
 include/net/busy_poll.h                       |   2 +-
 include/net/request_sock.h                    |   2 +-
 include/net/sock.h                            | 107 ++++++++++++------
 net/core/dev.c                                |   6 +-
 net/core/filter.c                             |   7 +-
 net/core/sock.c                               |  10 +-
 net/ipv4/tcp_input.c                          |   2 +-
 9 files changed, 93 insertions(+), 53 deletions(-)

-- 
2.26.2

