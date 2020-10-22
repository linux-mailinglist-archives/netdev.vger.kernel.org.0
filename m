Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276C8295C6F
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 12:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2896348AbgJVKK2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 06:10:28 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:32537 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2896302AbgJVKK2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 06:10:28 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09MAAK5b013211;
        Thu, 22 Oct 2020 03:10:21 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net 0/7] cxgb4/ch_ktls: Fixes in nic tls code
Date:   Thu, 22 Oct 2020 15:40:12 +0530
Message-Id: <20201022101019.7363-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series helps in fixing multiple nic ktls issues.
Series is broken into 7 patches.

Patch 1 avoids deciding tls packet based on decrypted bit. If its
a retransmit packet which has tls handshake and finish (for
encryption), decrypted bit won't be set there, and so we can't
rely on decrypted bit.

Patch 2 helps supporting linear skb. SKBs were assumed non-linear.
Corrected the length extraction.

Patch 3 fixes kernel panic happening due to creating new skb for
each record. As part of fix driver will use same skb to send out
one tls record (partial data) of the same SKB.

Patch 4 avoids sending extra data which will be used to make a
record 16 byte aligned. We don't need to retransmit those extra
few bytes.

Patch 5 handles the cases where retransmit packet has tls starting
exchanges which are prior to tls start marker.

Patch 6 handles the small packet case which has partial TAG bytes
only. HW can't handle those, hence using sw crypto for such pkts.

Patch 7 corrects the potential tcb update problem.

Rohit Maheshwari (7):
  cxgb4/ch_ktls: decrypted bit is not enough
  ch_ktls: Correction in finding correct length
  cxgb4/ch_ktls: creating skbs causes panic
  ch_ktls: Correction in middle record handling
  ch_ktls: packet handling prior to start marker
  ch_ktls/cxgb4: handle partial tag alone SKBs
  ch_ktls: tcb update fails sometimes

 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |   3 +
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |   2 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_main.c   |   3 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |   8 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c      | 111 ++-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 784 +++++++++---------
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.h |   1 +
 7 files changed, 542 insertions(+), 370 deletions(-)

-- 
2.18.1

