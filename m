Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BAFD17A6AF
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 14:49:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgCENtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 08:49:14 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:43334 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725990AbgCENtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 08:49:13 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4366680063;
        Thu,  5 Mar 2020 13:49:11 +0000 (UTC)
Received: from [10.17.20.62] (10.17.20.62) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 5 Mar 2020
 13:49:06 +0000
Subject: Re: [PATCH] sfc: complete the next packet when we receive a timestamp
To:     Tom Zhao <tzhao@solarflare.com>,
        <linux-net-drivers@solarflare.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>
References: <b8de726f-d7f7-09f3-115a-96aac3cd4d40@solarflare.com>
From:   Martin Habets <mhabets@solarflare.com>
Message-ID: <d9b43956-5b7f-80f7-5638-4744fe96e0f2@solarflare.com>
Date:   Thu, 5 Mar 2020 13:49:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <b8de726f-d7f7-09f3-115a-96aac3cd4d40@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.62]
X-ClientProxiedBy: ukex01.SolarFlarecom.com (10.17.10.4) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25270.003
X-TM-AS-Result: No-11.291100-8.000000-10
X-TMASE-MatchedRID: H0/uSqZo4D7mLzc6AOD8DfHkpkyUphL9NW8jQhzoALV0u//5asbq03sy
        gY4tPtxe/aiu4+Q1XCKFCdl/2uAVW14FRYeN/DP9CesU3iPiNCxMhH/KpYxyu5u6++Cllkj56Fc
        NQho06xYRYyKiJ7BL10PzNR994ocY9rqf24A6kyu7B1QwzOcQD9ST/TZ3TTpFHWtVZN0asThyKM
        xmuvaJna3aC25avUuadVjGLDENAPGZka9ZOnvpYGXaK3KHx/xpfrTt+hmA5bIPIbBu4llm3ro8P
        QV15rjgfZ1wWAXO/vX4iJBxWPO33LjAlyhiLbFWfY+iJfFQBxeZ2scyRQcer0oPLn6eZ90+ac2t
        /JoXOgBgJHW0v6veR5eojZTFcb3xr4AC9FWO6drJ/bVh4iw9hnyzRzLq38pIb59dURD98Z5nu4p
        z9/YQTvMXQV0Skt5eyPaKiqafZByRehYFOG64KOn1HxC6hVB/BGvINcfHqhfAJMh4mAwEG/uJNC
        6U8cqf+aSt+E6D0kXWuzp0zYDj5Ef6DNnIFLGaogGd8wIUGIKnZS/aYgjrzjE5FmPR2MmR8b1mX
        TqetmxbTlRHpCSZcqSwCZzYjZsak4DUhUqJIL6eAiCmPx4NwLTrdaH1ZWqCeVl+oyOKCVfUZxEA
        lFPo846HM5rqDwqtlFN8RRhbx8+pe0GQ6zKL82Om8RN4dT3snmIbcq9OIe9CDJArwqU6Lg==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--11.291100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25270.003
X-MDID: 1583416152-Ehgmp56iE__8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/03/2020 11:38, Tom Zhao wrote:
> We now ignore the "completion" event when using tx queue timestamping,
> and only pay attention to the two (high and low) timestamp events. The
> NIC will send a pair of timestamp events for every packet transmitted.
> The current firmware may merge the completion events, and it is possible
> that future versions may reorder the completion and timestamp events.
> As such the completion event is not useful.
> 
> Without this patch in place a merged completion event on a queue with
> timestamping will cause a "spurious TX completion" error. This affects
> SFN8000-series adapters.
> 
> Signed-off-by: Tom Zhao <tzhao@solarflare.com>

Acked-by: Martin Habets <mhabets@solarflare.com>

> ---
> v2: apply to correct head
> v3: actually send the right patch this time
> ---
>  drivers/net/ethernet/sfc/ef10.c       | 32 +++++++++++-----------
>  drivers/net/ethernet/sfc/efx.h        |  1 +
>  drivers/net/ethernet/sfc/net_driver.h |  3 ---
>  drivers/net/ethernet/sfc/tx.c         | 38 +++++++++++++++++++++++++++
>  drivers/net/ethernet/sfc/tx_common.c  | 29 +++++++++++---------
>  drivers/net/ethernet/sfc/tx_common.h  |  6 +++++
>  6 files changed, 78 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
> index 52113b7529d6..3f16bd807c6e 100644
> --- a/drivers/net/ethernet/sfc/ef10.c
> +++ b/drivers/net/ethernet/sfc/ef10.c
> @@ -2853,11 +2853,24 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
>  	}
>  
>  	/* Transmit timestamps are only available for 8XXX series. They result
> -	 * in three events per packet. These occur in order, and are:
> -	 *  - the normal completion event
> +	 * in up to three events per packet. These occur in order, and are:
> +	 *  - the normal completion event (may be omitted)
>  	 *  - the low part of the timestamp
>  	 *  - the high part of the timestamp
>  	 *
> +	 * It's possible for multiple completion events to appear before the
> +	 * corresponding timestamps. So we can for example get:
> +	 *  COMP N
> +	 *  COMP N+1
> +	 *  TS_LO N
> +	 *  TS_HI N
> +	 *  TS_LO N+1
> +	 *  TS_HI N+1
> +	 *
> +	 * In addition it's also possible for the adjacent completions to be
> +	 * merged, so we may not see COMP N above. As such, the completion
> +	 * events are not very useful here.
> +	 *
>  	 * Each part of the timestamp is itself split across two 16 bit
>  	 * fields in the event.
>  	 */
> @@ -2865,17 +2878,7 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
>  
>  	switch (tx_ev_type) {
>  	case TX_TIMESTAMP_EVENT_TX_EV_COMPLETION:
> -		/* In case of Queue flush or FLR, we might have received
> -		 * the previous TX completion event but not the Timestamp
> -		 * events.
> -		 */
> -		if (tx_queue->completed_desc_ptr != tx_queue->ptr_mask)
> -			efx_xmit_done(tx_queue, tx_queue->completed_desc_ptr);
> -
> -		tx_ev_desc_ptr = EFX_QWORD_FIELD(*event,
> -						 ESF_DZ_TX_DESCR_INDX);
> -		tx_queue->completed_desc_ptr =
> -					tx_ev_desc_ptr & tx_queue->ptr_mask;
> +		/* Ignore this event - see above. */
>  		break;
>  
>  	case TX_TIMESTAMP_EVENT_TX_EV_TSTAMP_LO:
> @@ -2887,8 +2890,7 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
>  		ts_part = efx_ef10_extract_event_ts(event);
>  		tx_queue->completed_timestamp_major = ts_part;
>  
> -		efx_xmit_done(tx_queue, tx_queue->completed_desc_ptr);
> -		tx_queue->completed_desc_ptr = tx_queue->ptr_mask;
> +		efx_xmit_done_single(tx_queue);
>  		break;
>  
>  	default:
> diff --git a/drivers/net/ethernet/sfc/efx.h b/drivers/net/ethernet/sfc/efx.h
> index da54afaa3c44..66dcab140449 100644
> --- a/drivers/net/ethernet/sfc/efx.h
> +++ b/drivers/net/ethernet/sfc/efx.h
> @@ -20,6 +20,7 @@ netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
>  				struct net_device *net_dev);
>  netdev_tx_t efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
>  void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index);
> +void efx_xmit_done_single(struct efx_tx_queue *tx_queue);
>  int efx_setup_tc(struct net_device *net_dev, enum tc_setup_type type,
>  		 void *type_data);
>  extern unsigned int efx_piobuf_size;
> diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
> index 392bd5b7017e..b836315bac87 100644
> --- a/drivers/net/ethernet/sfc/net_driver.h
> +++ b/drivers/net/ethernet/sfc/net_driver.h
> @@ -208,8 +208,6 @@ struct efx_tx_buffer {
>   *	avoid cache-line ping-pong between the xmit path and the
>   *	completion path.
>   * @merge_events: Number of TX merged completion events
> - * @completed_desc_ptr: Most recent completed pointer - only used with
> - *      timestamping.
>   * @completed_timestamp_major: Top part of the most recent tx timestamp.
>   * @completed_timestamp_minor: Low part of the most recent tx timestamp.
>   * @insert_count: Current insert pointer
> @@ -269,7 +267,6 @@ struct efx_tx_queue {
>  	unsigned int merge_events;
>  	unsigned int bytes_compl;
>  	unsigned int pkts_compl;
> -	unsigned int completed_desc_ptr;
>  	u32 completed_timestamp_major;
>  	u32 completed_timestamp_minor;
>  
> diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
> index 696a77c20cb7..19b58563cb78 100644
> --- a/drivers/net/ethernet/sfc/tx.c
> +++ b/drivers/net/ethernet/sfc/tx.c
> @@ -534,6 +534,44 @@ netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
>  	return efx_enqueue_skb(tx_queue, skb);
>  }
>  
> +void efx_xmit_done_single(struct efx_tx_queue *tx_queue)
> +{
> +	unsigned int pkts_compl = 0, bytes_compl = 0;
> +	unsigned int read_ptr;
> +	bool finished = false;
> +
> +	read_ptr = tx_queue->read_count & tx_queue->ptr_mask;
> +
> +	while (!finished) {
> +		struct efx_tx_buffer *buffer = &tx_queue->buffer[read_ptr];
> +
> +		if (!efx_tx_buffer_in_use(buffer)) {
> +			struct efx_nic *efx = tx_queue->efx;
> +
> +			netif_err(efx, hw, efx->net_dev,
> +				  "TX queue %d spurious single TX completion\n",
> +				  tx_queue->queue);
> +			efx_schedule_reset(efx, RESET_TYPE_TX_SKIP);
> +			return;
> +		}
> +
> +		/* Need to check the flag before dequeueing. */
> +		if (buffer->flags & EFX_TX_BUF_SKB)
> +			finished = true;
> +		efx_dequeue_buffer(tx_queue, buffer, &pkts_compl, &bytes_compl);
> +
> +		++tx_queue->read_count;
> +		read_ptr = tx_queue->read_count & tx_queue->ptr_mask;
> +	}
> +
> +	tx_queue->pkts_compl += pkts_compl;
> +	tx_queue->bytes_compl += bytes_compl;
> +
> +	EFX_WARN_ON_PARANOID(pkts_compl != 1);
> +
> +	efx_xmit_done_check_empty(tx_queue);
> +}
> +
>  void efx_init_tx_queue_core_txq(struct efx_tx_queue *tx_queue)
>  {
>  	struct efx_nic *efx = tx_queue->efx;
> diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
> index b1571e9789d0..70876df1da69 100644
> --- a/drivers/net/ethernet/sfc/tx_common.c
> +++ b/drivers/net/ethernet/sfc/tx_common.c
> @@ -80,7 +80,6 @@ void efx_init_tx_queue(struct efx_tx_queue *tx_queue)
>  	tx_queue->xmit_more_available = false;
>  	tx_queue->timestamping = (efx_ptp_use_mac_tx_timestamps(efx) &&
>  				  tx_queue->channel == efx_ptp_channel(efx));
> -	tx_queue->completed_desc_ptr = tx_queue->ptr_mask;
>  	tx_queue->completed_timestamp_major = 0;
>  	tx_queue->completed_timestamp_minor = 0;
>  
> @@ -210,10 +209,9 @@ static void efx_dequeue_buffers(struct efx_tx_queue *tx_queue,
>  	while (read_ptr != stop_index) {
>  		struct efx_tx_buffer *buffer = &tx_queue->buffer[read_ptr];
>  
> -		if (!(buffer->flags & EFX_TX_BUF_OPTION) &&
> -		    unlikely(buffer->len == 0)) {
> +		if (!efx_tx_buffer_in_use(buffer)) {
>  			netif_err(efx, tx_err, efx->net_dev,
> -				  "TX queue %d spurious TX completion id %x\n",
> +				  "TX queue %d spurious TX completion id %d\n",
>  				  tx_queue->queue, read_ptr);
>  			efx_schedule_reset(efx, RESET_TYPE_TX_SKIP);
>  			return;
> @@ -226,6 +224,19 @@ static void efx_dequeue_buffers(struct efx_tx_queue *tx_queue,
>  	}
>  }
>  
> +void efx_xmit_done_check_empty(struct efx_tx_queue *tx_queue)
> +{
> +	if ((int)(tx_queue->read_count - tx_queue->old_write_count) >= 0) {
> +		tx_queue->old_write_count = READ_ONCE(tx_queue->write_count);
> +		if (tx_queue->read_count == tx_queue->old_write_count) {
> +			/* Ensure that read_count is flushed. */
> +			smp_mb();
> +			tx_queue->empty_read_count =
> +				tx_queue->read_count | EFX_EMPTY_COUNT_VALID;
> +		}
> +	}
> +}
> +
>  void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
>  {
>  	unsigned int fill_level, pkts_compl = 0, bytes_compl = 0;
> @@ -256,15 +267,7 @@ void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
>  			netif_tx_wake_queue(tx_queue->core_txq);
>  	}
>  
> -	/* Check whether the hardware queue is now empty */
> -	if ((int)(tx_queue->read_count - tx_queue->old_write_count) >= 0) {
> -		tx_queue->old_write_count = READ_ONCE(tx_queue->write_count);
> -		if (tx_queue->read_count == tx_queue->old_write_count) {
> -			smp_mb();
> -			tx_queue->empty_read_count =
> -				tx_queue->read_count | EFX_EMPTY_COUNT_VALID;
> -		}
> -	}
> +	efx_xmit_done_check_empty(tx_queue);
>  }
>  
>  /* Remove buffers put into a tx_queue for the current packet.
> diff --git a/drivers/net/ethernet/sfc/tx_common.h b/drivers/net/ethernet/sfc/tx_common.h
> index f92f1fe3a87f..99cf7ce2f36c 100644
> --- a/drivers/net/ethernet/sfc/tx_common.h
> +++ b/drivers/net/ethernet/sfc/tx_common.h
> @@ -21,6 +21,12 @@ void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
>  			unsigned int *pkts_compl,
>  			unsigned int *bytes_compl);
>  
> +static inline bool efx_tx_buffer_in_use(struct efx_tx_buffer *buffer)
> +{
> +	return buffer->len || (buffer->flags & EFX_TX_BUF_OPTION);
> +}
> +
> +void efx_xmit_done_check_empty(struct efx_tx_queue *tx_queue);
>  void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index);
>  
>  void efx_enqueue_unwind(struct efx_tx_queue *tx_queue,
> 
