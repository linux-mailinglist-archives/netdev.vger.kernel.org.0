Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5412C3660A7
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 22:12:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233811AbhDTUMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 16:12:40 -0400
Received: from mx2.unformed.ru ([91.219.49.66]:45989 "EHLO mx2.unformed.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233544AbhDTUMj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 16:12:39 -0400
X-Greylist: delayed 1727 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2021 16:12:38 EDT
Received: from dotty.home.arpa ([10.3.14.10]:55754)
        by filet.unformed.ru with esmtp (Exim 4.92)
        (envelope-from <mon@unformed.ru>)
        id 1lYwH4-00030I-0s; Tue, 20 Apr 2021 21:43:06 +0200
Received: from [10.3.14.66] (port=52178 helo=phobos.home.arpa.)
        by dotty.home.arpa with esmtp (Exim 4.92)
        (envelope-from <mon@unformed.ru>)
        id 1lYwH3-0001x3-Ua; Tue, 20 Apr 2021 21:43:05 +0200
From:   Yury Vostrikov <mon@unformed.ru>
Cc:     mon@unformed.ru,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Edward Cree <ecree@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: sfc: Fix kernel panic introduced by commit 044588b96372 ("sfc: define inner/outer csum offload TXQ types")
Date:   Tue, 20 Apr 2021 21:42:03 +0200
Message-Id: <20210420194203.24759-1-mon@unformed.ru>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NIC has EFX_MAX_CHANNELS channels:
struct efx_nic {
	[...]
	struct efx_channel *channel[EFX_MAX_CHANNELS];
	[...]
}

Each channel has EFX_MAX_TXQ_PER_CHANNEL TX queues; There a reverse
mapping from type to TX queue, holding at most EFX_TXQ_TYPES
entries. This mapping is a bitset mapping because EFX_TXQ_TYPE_* is
defined as non-overlapping bit enum:

struct efx_channel {
	[...]
	struct efx_tx_queue tx_queue[EFX_MAX_TXQ_PER_CHANNEL];
	struct efx_tx_queue *tx_queue_by_type[EFX_TXQ_TYPES];
	[...]
}

Because channels and queues are enumerated in-order in
efx_set_channels(), it is possible to get tx_queue be calling

efx_get_tx_queue(efx, qid / EFX_MAX_TXQ_PER_CHANNEL,
                      qid % EFX_MAX_TXQ_PER_CHANNEL);

This uses qid / EFX_MAX_TXQ_PER_CHANNEL as index inside
efx_nic->channels[] and qid % EFX_MAX_TXQ_PER_CHANNEL as index inside
channel->tx_queue_be_type[].

Indexing into bitset mapping with modulo operation seems to oversight
from the previous refactoring. Comments of other call sites also
indicate that the second argument is indeed queue->label (which is an
index into channel->tx_queue[]), not queue->type. It also looks like
that some callers do need indexing by type, though.

However, because the sizes of tx_queue[] and tx_queue_by_type[] are
equal, and every single slot in both arrays is not equal to NULL, no
crash occurs.

commit 044588b96372 ("sfc: define inner/outer csum offload TXQ types")
add additional TXQ_TYPE and bumps size of tx_queue_by_type to 8
elements. Some of its members are NULL now. During interface shutdown,
tx_queues are flushed; this, in turn, results in a callback to
efx_farch_handle_tx_flush_done, which then tries to use
qid % EFX_MAX_TXQ_PER_CHANNEL as queue->type, gets NULL back, and
crashes.

Address this by adding efx_get_tx_queue_by_type() and updating
relevant callers.

Signed-off-by: Yury Vostrikov <mon@unformed.ru>
---
 drivers/net/ethernet/sfc/net_driver.h | 21 ++++++++++++++++++---
 drivers/net/ethernet/sfc/ptp.c        |  2 +-
 drivers/net/ethernet/sfc/tx.c         |  2 +-
 3 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 9f7dfdf708cf..4ab0fe21a3a6 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1533,18 +1533,33 @@ static inline unsigned int efx_channel_num_tx_queues(struct efx_channel *channel
 }
 
 static inline struct efx_tx_queue *
-efx_channel_get_tx_queue(struct efx_channel *channel, unsigned int type)
+efx_channel_get_tx_queue_by_type(struct efx_channel *channel, unsigned int type)
 {
 	EFX_WARN_ON_ONCE_PARANOID(type >= EFX_TXQ_TYPES);
 	return channel->tx_queue_by_type[type];
 }
 
 static inline struct efx_tx_queue *
-efx_get_tx_queue(struct efx_nic *efx, unsigned int index, unsigned int type)
+efx_get_tx_queue_by_type(struct efx_nic *efx, unsigned int index, unsigned int type)
 {
 	struct efx_channel *channel = efx_get_tx_channel(efx, index);
 
-	return efx_channel_get_tx_queue(channel, type);
+	return efx_channel_get_tx_queue_by_type(channel, type);
+}
+
+static inline struct efx_tx_queue *
+efx_channel_get_tx_queue(struct efx_channel *channel, unsigned int label)
+{
+	EFX_WARN_ON_ONCE_PARANOID(label >= EFX_MAX_TXQ_PER_CHANNEL);
+	return &channel->tx_queue[label];
+}
+
+static inline struct efx_tx_queue *
+efx_get_tx_queue(struct efx_nic *efx, unsigned int index, unsigned int label)
+{
+	struct efx_channel *channel = efx_get_tx_channel(efx, index);
+
+	return efx_channel_get_tx_queue(channel, label);
 }
 
 /* Iterate over all TX queues belonging to a channel */
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index a39c5143b386..7de19d22dadc 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1091,7 +1091,7 @@ static void efx_ptp_xmit_skb_queue(struct efx_nic *efx, struct sk_buff *skb)
 	u8 type = efx_tx_csum_type_skb(skb);
 	struct efx_tx_queue *tx_queue;
 
-	tx_queue = efx_channel_get_tx_queue(ptp_data->channel, type);
+	tx_queue = efx_channel_get_tx_queue_by_type(ptp_data->channel, type);
 	if (tx_queue && tx_queue->timestamping) {
 		efx_enqueue_skb(tx_queue, skb);
 	} else {
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 1665529a7271..18742db2990d 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -533,7 +533,7 @@ netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
 		return efx_ptp_tx(efx, skb);
 	}
 
-	tx_queue = efx_get_tx_queue(efx, index, type);
+	tx_queue = efx_get_tx_queue_by_type(efx, index, type);
 	if (WARN_ON_ONCE(!tx_queue)) {
 		/* We don't have a TXQ of the right type.
 		 * This should never happen, as we don't advertise offload
-- 
2.20.1

