Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6755725CC59
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 23:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728127AbgICVew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 17:34:52 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:54422 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726323AbgICVev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 17:34:51 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0DF69600C9;
        Thu,  3 Sep 2020 21:34:51 +0000 (UTC)
Received: from us4-mdac16-25.ut7.mdlocal (unknown [10.7.65.251])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0CCEE800A4;
        Thu,  3 Sep 2020 21:34:51 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.175])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8B2478005B;
        Thu,  3 Sep 2020 21:34:50 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 43C55700086;
        Thu,  3 Sep 2020 21:34:50 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 3 Sep 2020
 22:34:45 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 2/6] sfc: make ef100 xmit_more handling look more
 like ef10's
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <02b2bb5a-f360-68cb-3c13-b72ced1ecd7b@solarflare.com>
Message-ID: <f7678f01-5f7e-c7e9-3854-2b1ed293c158@solarflare.com>
Date:   Thu, 3 Sep 2020 22:34:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <02b2bb5a-f360-68cb-3c13-b72ced1ecd7b@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25642.007
X-TM-AS-Result: No-6.905900-8.000000-10
X-TMASE-MatchedRID: BfOluHGtj7DLR9UpYKRkjOIfK/Jd5eHmj87/LK+2sqOuwyYr2H34vxbd
        3jyYZmmraTtL3GbwfIdYckfk2t3eiDkI+HOa3v3TZdbZXmGFLie++wkLapadd1VkJxysad/I+9o
        bwkDBW0bxdUjf0kJGdKN80BVgAlECrSKKfw/QqNU/ApMPW/xhXkyQ5fRSh265kY8eITaSJPjHK3
        DBP8Kopxx7r9tNIMk9cclFsrlvOwUWAn35bB7hjMJY7CWyLABtAp+UH372RZWmUfYA3rK2TuL4A
        6U+Qr5RBYlC6T3dnw++1rY3s5rgqLUi+RdXr/ZOx5sgyUhLCNsKogTtqoQiBowsVqi+i43Qo8WM
        kQWv6iUD0yuKrQIMCD3Al4zalJpF33fj+sMArfNSleqDFXU3qcUlWpQhmHnUdQNv943mSJzeg+e
        Vuj8+CyQP1RMh3xcOlF5ICfzposd+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.905900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25642.007
X-MDID: 1599168891-ti-O6BYHh9nV
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This should cause no functional change; merely make there only be one
 design of xmit_more handling to understand.  As with the EF10/Siena
 version, we set tx_queue->xmit_pending when we queue up a TX, and
 clear it when we ring the doorbell (in ef100_notify_tx_desc).
While we're at it, make ef100_notify_tx_desc static since nothing
 outside of ef100_tx.c uses it.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_tx.c | 22 +++++++++++-----------
 drivers/net/ethernet/sfc/ef100_tx.h |  1 -
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index 8d478c5e720e..ce1b462efd17 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -117,11 +117,13 @@ static efx_oword_t *ef100_tx_desc(struct efx_tx_queue *tx_queue, unsigned int in
 		return NULL;
 }
 
-void ef100_notify_tx_desc(struct efx_tx_queue *tx_queue)
+static void ef100_notify_tx_desc(struct efx_tx_queue *tx_queue)
 {
 	unsigned int write_ptr;
 	efx_dword_t reg;
 
+	tx_queue->xmit_pending = false;
+
 	if (unlikely(tx_queue->notify_count == tx_queue->write_count))
 		return;
 
@@ -131,7 +133,6 @@ void ef100_notify_tx_desc(struct efx_tx_queue *tx_queue)
 	efx_writed_page(tx_queue->efx, &reg,
 			ER_GZ_TX_RING_DOORBELL, tx_queue->queue);
 	tx_queue->notify_count = tx_queue->write_count;
-	tx_queue->xmit_pending = false;
 }
 
 static void ef100_tx_push_buffers(struct efx_tx_queue *tx_queue)
@@ -372,15 +373,14 @@ int ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 			netif_tx_start_queue(tx_queue->core_txq);
 	}
 
-	if (__netdev_tx_sent_queue(tx_queue->core_txq, skb->len, xmit_more))
-		tx_queue->xmit_pending = false; /* push doorbell */
-	else if (tx_queue->write_count - tx_queue->notify_count > 255)
-		/* Ensure we never push more than 256 packets at once */
-		tx_queue->xmit_pending = false; /* push */
-	else
-		tx_queue->xmit_pending = true; /* don't push yet */
+	tx_queue->xmit_pending = true;
 
-	if (!tx_queue->xmit_pending)
+	/* If xmit_more then we don't need to push the doorbell, unless there
+	 * are 256 descriptors already queued in which case we have to push to
+	 * ensure we never push more than 256 at once.
+	 */
+	if (__netdev_tx_sent_queue(tx_queue->core_txq, skb->len, xmit_more) ||
+	    tx_queue->write_count - tx_queue->notify_count > 255)
 		ef100_tx_push_buffers(tx_queue);
 
 	if (segments) {
@@ -399,7 +399,7 @@ int ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 
 	/* If we're not expecting another transmit and we had something to push
 	 * on this queue then we need to push here to get the previous packets
-	 * out.  We only enter this branch from before the 'Update BQL' section
+	 * out.  We only enter this branch from before the xmit_more handling
 	 * above, so xmit_pending still refers to the old state.
 	 */
 	if (tx_queue->xmit_pending && !xmit_more)
diff --git a/drivers/net/ethernet/sfc/ef100_tx.h b/drivers/net/ethernet/sfc/ef100_tx.h
index fa23e430bdd7..ddc4b98fa6db 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.h
+++ b/drivers/net/ethernet/sfc/ef100_tx.h
@@ -17,7 +17,6 @@
 int ef100_tx_probe(struct efx_tx_queue *tx_queue);
 void ef100_tx_init(struct efx_tx_queue *tx_queue);
 void ef100_tx_write(struct efx_tx_queue *tx_queue);
-void ef100_notify_tx_desc(struct efx_tx_queue *tx_queue);
 unsigned int ef100_tx_max_skb_descs(struct efx_nic *efx);
 
 void ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event);

