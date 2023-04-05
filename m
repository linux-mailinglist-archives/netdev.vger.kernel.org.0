Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 071126D8644
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 20:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbjDEStR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 14:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233462AbjDEStQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 14:49:16 -0400
Received: from mx07lb.world4you.com (mx07lb.world4you.com [81.19.149.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC2261A2;
        Wed,  5 Apr 2023 11:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eEoDwgSSzBtiJcPNiRvd4uK5LT9mg+DaFtKkxSyJsOg=; b=NVu5loj1/be9vgdmd7Mv8nr3qR
        nrcAwHVg5Qr2zjjwWa5+zhxDI4GhmheX8/oSbJugI8Py9zKGMPuV8QsHvt3GcEI3na0ezJsh+6h5K
        A8T0kBgxKcBvmplFe3wlXPlUpDzIeXR0N5iYuAblSy61Ref1y7CZw2AVl4j7l8wC3DKk=;
Received: from [88.117.56.218] (helo=[10.0.0.160])
        by mx07lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pk8Bw-0005Yx-JA; Wed, 05 Apr 2023 20:49:08 +0200
Message-ID: <0af43fcd-84aa-85e0-1940-d21ca7a6c366@engleder-embedded.com>
Date:   Wed, 5 Apr 2023 20:49:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next 4/5] tsnep: Add XDP socket zero-copy RX support
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
References: <20230402193838.54474-1-gerhard@engleder-embedded.com>
 <20230402193838.54474-5-gerhard@engleder-embedded.com>
 <ZCsKkygVjB3J+XrO@boxer>
Content-Language: en-US
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <ZCsKkygVjB3J+XrO@boxer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-1.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.04.23 19:19, Maciej Fijalkowski wrote:

Hello Maciej,

>> Add support for XSK zero-copy to RX path. The setup of the XSK pool can
>> be done at runtime. If the netdev is running, then the queue must be
>> disabled and enabled during reconfiguration. This can be done easily
>> with functions introduced in previous commits.
>>
>> A more important property is that, if the netdev is running, then the
>> setup of the XSK pool shall not stop the netdev in case of errors. A
>> broken netdev after a failed XSK pool setup is bad behavior. Therefore,
>> the allocation and setup of resources during XSK pool setup is done only
>> before any queue is disabled. Additionally, freeing and later allocation
>> of resources is eliminated in some cases. Page pool entries are kept for
>> later use. Two memory models are registered in parallel. As a result,
>> the XSK pool setup cannot fail during queue reconfiguration.
>>
>> In contrast to other drivers, XSK pool setup and XDP BPF program setup
>> are separate actions. XSK pool setup can be done without any XDP BPF
>> program. The XDP BPF program can be added, removed or changed without
>> any reconfiguration of the XSK pool.
> 
> I won't argue about your design, but I'd be glad if you would present any
> perf numbers (ZC vs copy mode) just to give us some overview how your
> implementation works out. Also, please consider using batching APIs and
> see if this gives you any boost (my assumption is that it would).

I will add some numbers about ZC vs copy mode.

I assume the batching API consists of xsk_tx_peek_release_desc_batch()
and xsk_buff_alloc_batch(). I will give it try and measure the
difference.

>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>> ---
>>   drivers/net/ethernet/engleder/tsnep.h      |   7 +
>>   drivers/net/ethernet/engleder/tsnep_main.c | 432 ++++++++++++++++++++-
>>   drivers/net/ethernet/engleder/tsnep_xdp.c  |  67 ++++
>>   3 files changed, 488 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
>> index 058c2bcf31a7..836fd6b1d62e 100644
>> --- a/drivers/net/ethernet/engleder/tsnep.h
>> +++ b/drivers/net/ethernet/engleder/tsnep.h
>> @@ -101,6 +101,7 @@ struct tsnep_rx_entry {
>>   	u32 properties;
>>   
>>   	struct page *page;
>> +	struct xdp_buff *xdp;
> 
> couldn't page and xdp be a union now?

No, because the pages are not freed during XSK pool setup. At least
some pages survive at this pointer during XSK pool setup. Therefore,
when switching back to page pool, those pages can be used again without
the risk of failed allocations.

>>   	size_t len;
>>   	dma_addr_t dma;
>>   };
>> @@ -120,6 +121,7 @@ struct tsnep_rx {
>>   	u32 owner_counter;
>>   	int increment_owner_counter;
>>   	struct page_pool *page_pool;
>> +	struct xsk_buff_pool *xsk_pool;
>>   
>>   	u32 packets;
>>   	u32 bytes;
>> @@ -128,6 +130,7 @@ struct tsnep_rx {
>>   	u32 alloc_failed;
>>   
>>   	struct xdp_rxq_info xdp_rxq;
>> +	struct xdp_rxq_info xdp_rxq_zc;
>>   };
>>   
>>   struct tsnep_queue {
>> @@ -213,6 +216,8 @@ int tsnep_rxnfc_del_rule(struct tsnep_adapter *adapter,
>>   
>>   int tsnep_xdp_setup_prog(struct tsnep_adapter *adapter, struct bpf_prog *prog,
>>   			 struct netlink_ext_ack *extack);
>> +int tsnep_xdp_setup_pool(struct tsnep_adapter *adapter,
>> +			 struct xsk_buff_pool *pool, u16 queue_id);
>>   
>>   #if IS_ENABLED(CONFIG_TSNEP_SELFTESTS)
>>   int tsnep_ethtool_get_test_count(void);
>> @@ -241,5 +246,7 @@ static inline void tsnep_ethtool_self_test(struct net_device *dev,
>>   void tsnep_get_system_time(struct tsnep_adapter *adapter, u64 *time);
>>   int tsnep_set_irq_coalesce(struct tsnep_queue *queue, u32 usecs);
>>   u32 tsnep_get_irq_coalesce(struct tsnep_queue *queue);
>> +int tsnep_enable_xsk(struct tsnep_queue *queue, struct xsk_buff_pool *pool);
>> +void tsnep_disable_xsk(struct tsnep_queue *queue);
>>   
>>   #endif /* _TSNEP_H */
>> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
>> index 6d63b379f05a..e05835d675aa 100644
>> --- a/drivers/net/ethernet/engleder/tsnep_main.c
>> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
>> @@ -28,11 +28,16 @@
>>   #include <linux/iopoll.h>
>>   #include <linux/bpf.h>
>>   #include <linux/bpf_trace.h>
>> +#include <net/xdp_sock_drv.h>
>>   
>>   #define TSNEP_RX_OFFSET (max(NET_SKB_PAD, XDP_PACKET_HEADROOM) + NET_IP_ALIGN)
>>   #define TSNEP_HEADROOM ALIGN(TSNEP_RX_OFFSET, 4)
>>   #define TSNEP_MAX_RX_BUF_SIZE (PAGE_SIZE - TSNEP_HEADROOM - \
>>   			       SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
>> +/* XSK buffer shall store at least Q-in-Q frame */
>> +#define TSNEP_XSK_RX_BUF_SIZE (ALIGN(TSNEP_RX_INLINE_METADATA_SIZE + \
>> +				     ETH_FRAME_LEN + ETH_FCS_LEN + \
>> +		s survive at 		     VLAN_HLEN * 2, 4))
>>   
>>   #ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
>>   #define DMA_ADDR_HIGH(dma_addr) ((u32)(((dma_addr) >> 32) & 0xFFFFFFFF))
>> @@ -781,6 +786,9 @@ static void tsnep_rx_ring_cleanup(struct tsnep_rx *rx)
>>   			page_pool_put_full_page(rx->page_pool, entry->page,
>>   						false);
>>   		entry->page = NULL;
>> +		if (entry->xdp)
>> +			xsk_buff_free(entry->xdp);
>> +		entry->xdp = NULL;
>>   	}
>>   
>>   	if (rx->page_pool)
>> @@ -927,7 +935,7 @@ static void tsnep_rx_activate(struct tsnep_rx *rx, int index)
>>   {
>>   	struct tsnep_rx_entry *entry = &rx->entry[index];
>>   
>> -	/* TSNEP_MAX_RX_BUF_SIZE is a multiple of 4 */
>> +	/* TSNEP_MAX_RX_BUF_SIZE and TSNEP_XSK_RX_BUF_SIZE are multiple of 4 */
>>   	entry->properties = entry->len & TSNEP_DESC_LENGTH_MASK;
>>   	entry->properties |= TSNEP_DESC_INTERRUPT_FLAG;
>>   	if (index == rx->increment_owner_counter) {
>> @@ -979,6 +987,24 @@ static int tsnep_rx_alloc(struct tsnep_rx *rx, int count, bool reuse)
>>   	return i;
>>   }
>>   
>> +static int tsnep_rx_prealloc(struct tsnep_rx *rx)
>> +{
>> +	struct tsnep_rx_entry *entry;
>> +	int i;
>> +
>> +	/* prealloc all ring entries except the last one, because ring cannot be
>> +	 * filled completely
>> +	 */
>> +	for (i = 0; i < TSNEP_RING_SIZE - 1; i++) {
>> +		entry = &rx->entry[i];
>> +		entry->page = page_pool_dev_alloc_pages(rx->page_pool);
>> +		if (!entry->page)
>> +			return -ENOMEM;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>>   static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
>>   {
>>   	int desc_refilled;
>> @@ -990,22 +1016,118 @@ static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
>>   	return desc_refilled;
>>   }
>>   
>> +static void tsnep_rx_set_xdp(struct tsnep_rx *rx, struct tsnep_rx_entry *entry,
>> +			     struct xdp_buff *xdp)
>> +{
>> +	entry->xdp = xdp;
>> +	entry->len = TSNEP_XSK_RX_BUF_SIZE;
>> +	entry->dma = xsk_buff_xdp_get_dma(entry->xdp);
>> +	entry->desc->rx = __cpu_to_le64(entry->dma);
>> +}
>> +
>> +static int tsnep_rx_alloc_buffer_zc(struct tsnep_rx *rx, int index)
>> +{
>> +	struct tsnep_rx_entry *entry = &rx->entry[index];
>> +	struct xdp_buff *xdp;
>> +
>> +	xdp = xsk_buff_alloc(rx->xsk_pool);
>> +	if (unlikely(!xdp))
>> +		return -ENOMEM;
>> +	tsnep_rx_set_xdp(rx, entry, xdp);
>> +
>> +	return 0;
>> +}
>> +
>> +static void tsnep_rx_reuse_buffer_zc(struct tsnep_rx *rx, int index)
>> +{
>> +	struct tsnep_rx_entry *entry = &rx->entry[index];
>> +	struct tsnep_rx_entry *read = &rx->entry[rx->read];
>> +
>> +	tsnep_rx_set_xdp(rx, entry, read->xdp);
>> +	read->xdp = NULL;
>> +}
>> +
>> +static int tsnep_rx_alloc_zc(struct tsnep_rx *rx, int count, bool reuse)
>> +{
>> +	bool alloc_failed = false;
>> +	int i, index, retval;
>> +
>> +	for (i = 0; i < count && !alloc_failed; i++) {
>> +		index = (rx->write + i) % TSNEP_RING_SIZE;
> 
> If your ring size is static (256) then you could use the trick of:
> 
> 		index = (rx->write + i) & (TSNEP_RING_SIZE - 1);
> 
> since TSNEP_RING_SIZE is of power of 2. This way you avoid modulo op in
> hotpath.

I did assume that the compiler does that work for me. Same modulo
operation is used in the existing TX/RX path. I will rework all
locations.

>> +
>> +		retval = tsnep_rx_alloc_buffer_zc(rx, index);
>> +		if (unlikely(retval)) {
> 
> retval is not needed. just do:
> 		if (unlikely(tsnep_rx_alloc_buffer_zc(rx, index))) {

I will eliminate retval.

>> +			rx->alloc_failed++;
>> +			alloc_failed = true;
>> +
>> +			/* reuse only if no other allocation was successful */
>> +			if (i == 0 && reuse)
>> +				tsnep_rx_reuse_buffer_zc(rx, index);
>> +			else
>> +				break;
> 
> isn't the else branch not needed as you've set the alloc_failed to true
> which will break out the loop?

No, because tsnep_rx_activate() shall not be called in this case.

>> +		}
>> +		tsnep_rx_activate(rx, index);
>> +	}
>> +
>> +	if (i)
>> +		rx->write = (rx->write + i) % TSNEP_RING_SIZE;
>> +
>> +	return i;
>> +}
>> +
>> +static void tsnep_rx_free_zc(struct tsnep_rx *rx, struct xsk_buff_pool *pool)
>> +{
>> +	struct tsnep_rx_entry *entry;
> 
> can be scoped within loop

Will be done.

>> +	int i;
>> +
>> +	for (i = 0; i < TSNEP_RING_SIZE; i++) {
>> +		entry = &rx->entry[i];
>> +		if (entry->xdp)
>> +			xsk_buff_free(entry->xdp);
>> +		entry->xdp = NULL;
>> +	}
>> +}
>> +
>> +static void tsnep_rx_prealloc_zc(struct tsnep_rx *rx,
>> +				 struct xsk_buff_pool *pool)
>> +{
>> +	struct tsnep_rx_entry *entry;
> 
> ditto

Will be done.

>> +	int i;
>> +
>> +	/* prealloc all ring entries except the last one, because ring cannot be
>> +	 * filled completely, as many buffers as possible is enough as wakeup is
>> +	 * done if new buffers are available
>> +	 */
>> +	for (i = 0; i < TSNEP_RING_SIZE - 1; i++) {
>> +		entry = &rx->entry[i];
>> +		entry->xdp = xsk_buff_alloc(pool);
> 
> anything stops you from using xsk_buff_alloc_batch() ?

I will use xsk_buff_alloc_batch().

>> +		if (!entry->xdp)
>> +			break;
>> +	}
>> +}
>> +
>> +static int tsnep_rx_refill_zc(struct tsnep_rx *rx, int count, bool reuse)
>> +{
>> +	int desc_refilled;
>> +
>> +	desc_refilled = tsnep_rx_alloc_zc(rx, count, reuse);
>> +	if (desc_refilled)
>> +		tsnep_rx_enable(rx);
>> +
>> +	return desc_refilled;
>> +}
>> +
>>   static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
>>   			       struct xdp_buff *xdp, int *status,
>> -			       struct netdev_queue *tx_nq, struct tsnep_tx *tx)
>> +			       struct netdev_queue *tx_nq, struct tsnep_tx *tx,
>> +			       bool zc)
>>   {
>>   	unsigned int length;
>> -	unsigned int sync;
>>   	u32 act;
>>   
>>   	length = xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
>>   
>>   	act = bpf_prog_run_xdp(prog, xdp);
>> -
>> -	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
>> -	sync = xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
>> -	sync = max(sync, length);
>> -
>>   	switch (act) {
>>   	case XDP_PASS:
>>   		return false;
>> @@ -1027,8 +1149,21 @@ static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
>>   		trace_xdp_exception(rx->adapter->netdev, prog, act);
>>   		fallthrough;
>>   	case XDP_DROP:
>> -		page_pool_put_page(rx->page_pool, virt_to_head_page(xdp->data),
>> -				   sync, true);
>> +		if (zc) {
>> +			xsk_buff_free(xdp);
>> +		} else {
>> +			unsigned int sync;
>> +
>> +			/* Due xdp_adjust_tail: DMA sync for_device cover max
>> +			 * len CPU touch
>> +			 */
>> +			sync = xdp->data_end - xdp->data_hard_start -
>> +			       XDP_PACKET_HEADROOM;
>> +			sync = max(sync, length);
>> +			page_pool_put_page(rx->page_pool,
>> +					   virt_to_head_page(xdp->data), sync,
>> +					   true);
>> +		}
>>   		return true;
>>   	}
>>   }
>> @@ -1181,7 +1316,8 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
>>   					 length, false);
>>   
>>   			consume = tsnep_xdp_run_prog(rx, prog, &xdp,
>> -						     &xdp_status, tx_nq, tx);
>> +						     &xdp_status, tx_nq, tx,
>> +						     false);
>>   			if (consume) {
>>   				rx->packets++;
>>   				rx->bytes += length;
>> @@ -1205,6 +1341,125 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
>>   	return done;
>>   }
>>   
>> +static int tsnep_rx_poll_zc(struct tsnep_rx *rx, struct napi_struct *napi,
>> +			    int budget)
>> +{
>> +	struct tsnep_rx_entry *entry;
>> +	struct netdev_queue *tx_nq;
>> +	struct bpf_prog *prog;
>> +	struct tsnep_tx *tx;
>> +	int desc_available;
>> +	int xdp_status = 0;
>> +	struct page *page;
>> +	int done = 0;
>> +	int length;
>> +
>> +	desc_available = tsnep_rx_desc_available(rx);
>> +	prog = READ_ONCE(rx->adapter->xdp_prog);
>> +	if (prog) {
>> +		tx_nq = netdev_get_tx_queue(rx->adapter->netdev,
>> +					    rx->tx_queue_index);
>> +		tx = &rx->adapter->tx[rx->tx_queue_index];
>> +	}
>> +
>> +	while (likely(done < budget) && (rx->read != rx->write)) {
>> +		entry = &rx->entry[rx->read];
>> +		if ((__le32_to_cpu(entry->desc_wb->properties) &
>> +		     TSNEP_DESC_OWNER_COUNTER_MASK) !=
>> +		    (entry->properties & TSNEP_DESC_OWNER_COUNTER_MASK))
>> +			break;
>> +		done++;
>> +
>> +		if (desc_available >= TSNEP_RING_RX_REFILL) {
>> +			bool reuse = desc_available >= TSNEP_RING_RX_REUSE;
>> +
>> +			desc_available -= tsnep_rx_refill_zc(rx, desc_available,
>> +							     reuse);
>> +			if (!entry->xdp) {
>> +				/* buffer has been reused for refill to prevent
>> +				 * empty RX ring, thus buffer cannot be used for
>> +				 * RX processing
>> +				 */
>> +				rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
>> +				desc_available++;
>> +
>> +				rx->dropped++;
>> +
>> +				continue;
>> +			}
>> +		}
>> +
>> +		/* descriptor properties shall be read first, because valid data
>> +		 * is signaled there
>> +		 */
>> +		dma_rmb();
>> +
>> +		prefetch(entry->xdp->data);
>> +		length = __le32_to_cpu(entry->desc_wb->properties) &
>> +			 TSNEP_DESC_LENGTH_MASK;
>> +		entry->xdp->data_end = entry->xdp->data + length;
>> +		xsk_buff_dma_sync_for_cpu(entry->xdp, rx->xsk_pool);
>> +
>> +		/* RX metadata with timestamps is in front of actual data,
>> +		 * subtract metadata size to get length of actual data and
>> +		 * consider metadata size as offset of actual data during RX
>> +		 * processing
>> +		 */
>> +		length -= TSNEP_RX_INLINE_METADATA_SIZE;
>> +
>> +		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
>> +		desc_available++;
>> +
>> +		if (prog) {
>> +			bool consume;
>> +
>> +			entry->xdp->data += TSNEP_RX_INLINE_METADATA_SIZE;
>> +			entry->xdp->data_meta += TSNEP_RX_INLINE_METADATA_SIZE;
>> +
>> +			consume = tsnep_xdp_run_prog(rx, prog, entry->xdp,
>> +						     &xdp_status, tx_nq, tx,
>> +						     true);
> 
> reason for separate xdp run prog routine for ZC was usually "likely-fying"
> XDP_REDIRECT action as this is the main action for AF_XDP which was giving
> us perf improvement. Please try this out on your side to see if this
> yields any positive value.

I will try it.

>> +			if (consume) {
>> +				rx->packets++;
>> +				rx->bytes += length;
>> +
>> +				entry->xdp = NULL;
>> +
>> +				continue;
>> +			}
>> +		}
>> +
>> +		page = page_pool_dev_alloc_pages(rx->page_pool);
>> +		if (page) {
>> +			memcpy(page_address(page) + TSNEP_RX_OFFSET,
>> +			       entry->xdp->data - TSNEP_RX_INLINE_METADATA_SIZE,
>> +			       length + TSNEP_RX_INLINE_METADATA_SIZE);
>> +			tsnep_rx_page(rx, napi, page, length);
>> +		} else {
>> +			rx->dropped++;
>> +		}
>> +		xsk_buff_free(entry->xdp);
>> +		entry->xdp = NULL;
>> +	}
>> +
>> +	if (xdp_status)
>> +		tsnep_finalize_xdp(rx->adapter, xdp_status, tx_nq, tx);
>> +
>> +	if (desc_available)
>> +		desc_available -= tsnep_rx_refill_zc(rx, desc_available, false);
>> +
>> +	if (xsk_uses_need_wakeup(rx->xsk_pool)) {
>> +		if (desc_available)
>> +			xsk_set_rx_need_wakeup(rx->xsk_pool);
>> +		else
>> +			xsk_clear_rx_need_wakeup(rx->xsk_pool);
>> +
>> +		return done;
>> +	}
>> +
>> +	return desc_available ? budget : done;
>> +}
>>   
> 
> (...)
> 
>>   static int tsnep_mac_init(struct tsnep_adapter *adapter)
>> @@ -1974,7 +2369,8 @@ static int tsnep_probe(struct platform_device *pdev)
>>   
>>   	netdev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
>>   			       NETDEV_XDP_ACT_NDO_XMIT |
>> -			       NETDEV_XDP_ACT_NDO_XMIT_SG;
>> +			       NETDEV_XDP_ACT_NDO_XMIT_SG |
>> +			       NETDEV_XDP_ACT_XSK_ZEROCOPY;
>>   
>>   	/* carrier off reporting is important to ethtool even BEFORE open */
>>   	netif_carrier_off(netdev);
>> diff --git a/drivers/net/ethernet/engleder/tsnep_xdp.c b/drivers/net/ethernet/engleder/tsnep_xdp.c
>> index 4d14cb1fd772..6ec137870b59 100644
>> --- a/drivers/net/ethernet/engleder/tsnep_xdp.c
>> +++ b/drivers/net/ethernet/engleder/tsnep_xdp.c
>> @@ -6,6 +6,8 @@
>>   
>>   #include "tsnep.h"
>>   
>> +#define TSNEP_XSK_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC)
> 
> This is not introducing any value, you can operate directly on
> DMA_ATTR_SKIP_CPU_SYNC

Will be done.
