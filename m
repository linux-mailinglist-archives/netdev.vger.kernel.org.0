Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2454D2A0D05
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 19:02:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgJ3SCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 14:02:34 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:40972 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgJ3SCe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 14:02:34 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09UI2Sus020754;
        Fri, 30 Oct 2020 11:02:29 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net v4 00/10] cxgb4/ch_ktls: Fixes in nic tls code
Date:   Fri, 30 Oct 2020 23:32:15 +0530
Message-Id: <20201030180225.11089-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series helps in fixing multiple nic ktls issues. Series is
broken into 10 patches.

Patch 1 avoids deciding tls packet based on decrypted bit. If its
a retransmit packet which has tls handshake and finish (for
encryption), decrypted bit won't be set there, and so we can't
rely on decrypted bit.

Patch 2 helps supporting linear skb. SKBs were assumed non-linear.
Corrected the length extraction.

Patch 3 fixes the checksum offload update in WR.

Patch 4 corrects the usage of GFP_KERNEL and replaces it with
GFP_ATOMIC.

Patch 5 fixes kernel panic happening due to creating new skb for
each record. As part of fix driver will use same skb to send out
one tls record (partial data) of the same SKB.

Patch 6 avoids sending extra data which is used to make a record 16
byte aligned. We don't need to retransmit those extra few bytes.

Patch 7 handles the cases where retransmit packet has tls starting
exchanges which are prior to tls start marker.

Patch 8 handles the small packet case which has partial TAG bytes
only. HW can't handle those, hence using sw crypto for such pkts.

Patch 9 corrects the potential tcb update problem.

Patch 10 stops the queue if queue reaches threshold value.

v1->v2:
- Corrected fixes tag issue.
- Marked chcr_ktls_sw_fallback() static.

v2->v3:
- Replaced GFP_KERNEL with GFP_ATOMIC.
- Removed mixed fixes.

v3->v4:
- Corrected fixes tag issue.

Rohit Maheshwari (10):
  cxgb4/ch_ktls: decrypted bit is not enough
  ch_ktls: Correction in finding correct length
  ch_ktls: Update cheksum information
  ch_ktls: incorrect use of GFP_KERNEL
  cxgb4/ch_ktls: creating skbs causes panic
  ch_ktls: Correction in middle record handling
  ch_ktls: packet handling prior to start marker
  ch_ktls/cxgb4: handle partial tag alone SKBs
  ch_ktls: tcb update fails sometimes
  ch_ktls: stop the txq if reaches threshold

 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   3 +
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |   2 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |   1 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |   6 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c      | 111 ++-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 772 ++++++++++--------
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.h |   1 +
 7 files changed, 532 insertions(+), 364 deletions(-)

-- 
2.18.1

