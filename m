Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA9CC2AB56F
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 11:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgKIKwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 05:52:33 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:3500 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727311AbgKIKwd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 05:52:33 -0500
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0A9AqQMZ011444;
        Mon, 9 Nov 2020 02:52:26 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net v6 00/12] cxgb4/ch_ktls: Fixes in nic tls code
Date:   Mon,  9 Nov 2020 16:21:30 +0530
Message-Id: <20201109105142.15398-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series helps in fixing multiple nic ktls issues. Series is broken
into 12 patches.

Patch 1 avoids deciding tls packet based on decrypted bit. If its a
retransmit packet which has tls handshake and finish (for encryption),
decrypted bit won't be set there, and so we can't rely on decrypted
bit.

Patch 2 helps supporting linear skb. SKBs were assumed non-linear.
Corrected the length extraction.

Patch 3 fixes the checksum offload update in WR.

Patch 4 fixes kernel panic happening due to creating new skb for each
record. As part of fix driver will use same skb to send out one tls
record (partial data) of the same SKB.

Patch 5 fixes the problem of skb data length smaller than remaining data
of the record.

Patch 6 fixes the handling of SKBs which has tls header alone pkt, but
not starting from beginning.

Patch 7 avoids sending extra data which is used to make a record 16 byte
aligned. We don't need to retransmit those extra few bytes.

Patch 8 handles the cases where retransmit packet has tls starting
exchanges which are prior to tls start marker.

Patch 9 fixes the problem os skb free before HW knows about tcp FIN.

Patch 10 handles the small packet case which has partial TAG bytes only.
HW can't handle those, hence using sw crypto for such pkts.

Patch 11 corrects the potential tcb update problem.

Patch 12 stops the queue if queue reaches threshold value.

v1->v2:
- Corrected fixes tag issue.
- Marked chcr_ktls_sw_fallback() static.

v2->v3:
- Replaced GFP_KERNEL with GFP_ATOMIC.
- Removed mixed fixes.

v3->v4:
- Corrected fixes tag issue.

v4->v5:
- Separated mixed fixes from patch 4.

v5-v6:
- Fixes tag should be at the end.

Rohit Maheshwari (12):
  cxgb4/ch_ktls: decrypted bit is not enough
  ch_ktls: Correction in finding correct length
  ch_ktls: Update cheksum information
  cxgb4/ch_ktls: creating skbs causes panic
  ch_ktls: Correction in trimmed_len calculation
  ch_ktls: missing handling of header alone
  ch_ktls: Correction in middle record handling
  ch_ktls: packet handling prior to start marker
  ch_ktls: don't free skb before sending FIN
  ch_ktls/cxgb4: handle partial tag alone SKBs
  ch_ktls: tcb update fails sometimes
  ch_ktls: stop the txq if reaches threshold

 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   3 +
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |   2 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |   1 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |   6 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c      | 111 +++-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 582 +++++++++++-------
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.h |   1 +
 7 files changed, 478 insertions(+), 228 deletions(-)

-- 
2.18.1

