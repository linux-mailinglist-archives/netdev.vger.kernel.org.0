Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B750C1618CB
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 18:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbgBQR2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 12:28:46 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:39868 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726462AbgBQR2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 12:28:46 -0500
Received: from redhouse.blr.asicdesginers.com ([10.193.187.72])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 01HHSfJu022959;
        Mon, 17 Feb 2020 09:28:42 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     manojmalviya@chelsio.com, varun@chelsio.com,
        Rohit Maheshwari <rohitm@chelsio.com>
Subject: [RFC net-next 0/6] cxgb4/chcr: ktls tx offload support on T6 adapter
Date:   Mon, 17 Feb 2020 22:58:33 +0530
Message-Id: <20200217172839.32066-1-rohitm@chelsio.com>
X-Mailer: git-send-email 2.25.0.191.gde93cc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

Patch 5 handles partial first part or middle part of record, it uses AES_CTR
to encrypt the partial record. If we are trying to send middle record, it's
start should be 16 byte aligned, so we'll fetch few earlier bytes from the
record and then send it to HW for encryption.

Patch 6 enables ipv6 support and also includes ktls startistics.

Rohit Maheshwari (6):
  cxgb4/chcr: Register to tls add and del callbacks
  cxgb4/chcr: Save crypto keys and handle HW response
  cxgb4/chcr: Complete record tx handling
  chcr: Handle partial end part of a record
  chcr: Handle first or middle part of record
  cxgb4/chcr: Add ipv6 support and statistics

 drivers/crypto/chelsio/Kconfig                |   11 +
 drivers/crypto/chelsio/Makefile               |    3 +
 drivers/crypto/chelsio/chcr_common.h          |  135 ++
 drivers/crypto/chelsio/chcr_core.c            |   56 +-
 drivers/crypto/chelsio/chcr_core.h            |    7 +
 drivers/crypto/chelsio/chcr_ktls.c            | 1995 +++++++++++++++++
 drivers/crypto/chelsio/chcr_ktls.h            |   96 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h    |    3 +-
 .../ethernet/chelsio/cxgb4/cxgb4_debugfs.c    |   25 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.c    |   34 +
 .../net/ethernet/chelsio/cxgb4/cxgb4_uld.h    |   13 +
 drivers/net/ethernet/chelsio/cxgb4/l2t.c      |   11 +
 drivers/net/ethernet/chelsio/cxgb4/l2t.h      |    1 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c      |    6 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h   |   28 +
 drivers/net/ethernet/chelsio/cxgb4/t4_tcb.h   |   64 +-
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h |    2 +
 17 files changed, 2468 insertions(+), 22 deletions(-)
 create mode 100644 drivers/crypto/chelsio/chcr_common.h
 create mode 100644 drivers/crypto/chelsio/chcr_ktls.c
 create mode 100644 drivers/crypto/chelsio/chcr_ktls.h

-- 
2.25.0.191.gde93cc1

