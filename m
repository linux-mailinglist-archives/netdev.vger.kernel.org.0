Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB6717CEBE
	for <lists+netdev@lfdr.de>; Sat,  7 Mar 2020 15:36:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgCGOgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 09:36:25 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:41592 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgCGOgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 09:36:25 -0500
Received: from redhouse-blr-asicdesigners-com.blr.asicdesigners.com (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 027Ea9mu031095;
        Sat, 7 Mar 2020 06:36:10 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     borisp@mellanox.com, netdev@vger.kernel.org, davem@davemloft.net
Cc:     herbert@gondor.apana.org.au, kuba@kernel.org, secdev@chelsio.com,
        varun@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [PATCH net-next v4 0/6] cxgb4/chcr: ktls tx ofld support on T6 adapter
Date:   Sat,  7 Mar 2020 20:06:02 +0530
Message-Id: <20200307143608.13109-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series of patches add support for kernel tls offload in Tx direction,
over Chelsio T6 NICs. SKBs marked as decrypted will be treated as tls plain
text packets and then offloaded to encrypt using network device (chelsio T6
adapter).

This series is broken down as follows:

Patch 1 defines a new macro and registers tls_dev_add and tls_dev_del
callbacks. When tls_dev_add gets called we send a connection request to
our hardware and to make HW understand about tls offload. Its a partial
connection setup and only ipv4 part is done.

Patch 2 handles the HW response of the connection request and then we
request to update TCB and handle it's HW response as well. Also we save
crypto key locally. Only supporting TLS_CIPHER_AES_GCM_128_KEY_SIZE.

Patch 3 handles tls marked skbs (decrypted bit set) and sends it to ULD for
crypto handling. This code has a minimal portion of tx handler, to handle
only one complete record per skb.

Patch 4 hanldes partial end part of records. Also added logic to handle
multiple records in one single skb. It also adds support to send out tcp
option(/s) if exists in skb. If a record is partial but has end part of a
record, we'll fetch complete record and then only send it to HW to generate
HASH on complete record.

Patch 5 handles partial first or middle part of record, it uses AES_CTR to
encrypt the partial record. If we are trying to send middle record, it's
start should be 16 byte aligned, so we'll fetch few earlier bytes from the
record and then send it to HW for encryption.

Patch 6 enables ipv6 support and also includes ktls startistics.

v1->v2:
- mark tcb state to close in tls_dev_del.
- u_ctx is now picked from adapter structure.
- clear atid in case of failure.
- corrected ULP_CRYPTO_KTLS_INLINE value.
- optimized tcb update using control queue.
- state machine handling when earlier states received.
- chcr_write_cpl_set_tcb_ulp  function is shifted to patch3.
- un-necessary updating left variable.

v2->v3:
- add empty line after variable declaration.
- local variable declaration in reverse christmas tree ordering.

v3->v4:
- replaced kfree_skb with dev_kfree_skb_any.
- corrected error message reported by kbuild test robot <lkp@intel.com>
- mss calculation logic.
- correct place for Alloc skb check.
- Replaced atomic_t with atomic64_t
- added few more statistics counters.

Rohit Maheshwari (6):
  cxgb4/chcr : Register to tls add and del callback
  cxgb4/chcr: Save tx keys and handle HW response
  cxgb4/chcr: complete record tx handling
  chcr: handle partial end part of a record
  chcr: Handle first or middle part of record
  cxgb4/chcr: Add ipv6 support and statistics

 drivers/crypto/chelsio/Kconfig                |   11 +
 drivers/crypto/chelsio/Makefile               |    3 +
 drivers/crypto/chelsio/chcr_common.h          |  135 ++
 drivers/crypto/chelsio/chcr_core.c            |   51 +-
 drivers/crypto/chelsio/chcr_core.h            |    7 +
 drivers/crypto/chelsio/chcr_ktls.c            | 2021 +++++++++++++++++
 drivers/crypto/chelsio/chcr_ktls.h            |   98 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |    1 +
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |   35 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.c    |   32 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |   20 +
 drivers/net/ethernet/chelsio/cxgb4/l2t.c      |   11 +
 drivers/net/ethernet/chelsio/cxgb4/l2t.h      |    1 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c      |    5 +
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h   |   28 +
 drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h   |   62 +-
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h |    2 +
 17 files changed, 2506 insertions(+), 17 deletions(-)
 create mode 100644 drivers/crypto/chelsio/chcr_common.h
 create mode 100644 drivers/crypto/chelsio/chcr_ktls.c
 create mode 100644 drivers/crypto/chelsio/chcr_ktls.h

-- 
2.18.1

