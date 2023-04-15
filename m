Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32A066E31C9
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 16:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjDOOU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 10:20:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjDOOU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 10:20:27 -0400
Received: from mx03lb.world4you.com (mx03lb.world4you.com [81.19.149.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02375BB3;
        Sat, 15 Apr 2023 07:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7o987JN2RXQLJSOJmDRhI+mEldNIqnOlpQbJWGmldZ4=; b=K5/ceCCEdmcH83QDs3+jDY7Z9U
        48eqjTkTIq/VCrVdS0fy4PiNjHb3YCMjFSTMDsM2Ui8gFjfnBi1yJ59YpnW+gV9XoyEkJgvxuhr8O
        756UUmGhpxNpGIbaWiujhjWxpSnMpwBpkKPUELWBtLJmUt0OuJ57Ic9fhgo0BlNO/208=;
Received: from [88.117.57.231] (helo=[10.0.0.160])
        by mx03lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pngkd-0004v7-GZ; Sat, 15 Apr 2023 16:19:39 +0200
Message-ID: <5b668562-bb9d-2156-3ff8-0e2c800aa370@engleder-embedded.com>
Date:   Sat, 15 Apr 2023 16:19:39 +0200
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
 <ZCsKkygVjB3J+XrO@boxer> <ZCsMNKCK0xQECDJh@boxer>
 <72bb23b0-50cc-7333-56e7-a887223ac6e1@engleder-embedded.com>
 <ZDAddB+bF7W2OhY1@boxer>
Content-Language: en-US
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <ZDAddB+bF7W2OhY1@boxer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.04.23 15:41, Maciej Fijalkowski wrote:
> On Wed, Apr 05, 2023 at 09:13:58PM +0200, Gerhard Engleder wrote:
>> On 03.04.23 19:26, Maciej Fijalkowski wrote:
>>> On Mon, Apr 03, 2023 at 07:19:15PM +0200, Maciej Fijalkowski wrote:
>>>> On Sun, Apr 02, 2023 at 09:38:37PM +0200, Gerhard Engleder wrote:
>>>>
>>>> Hey Gerhard,
>>>>
>>>>> Add support for XSK zero-copy to RX path. The setup of the XSK pool can
>>>>> be done at runtime. If the netdev is running, then the queue must be
>>>>> disabled and enabled during reconfiguration. This can be done easily
>>>>> with functions introduced in previous commits.
>>>>>
>>>>> A more important property is that, if the netdev is running, then the
>>>>> setup of the XSK pool shall not stop the netdev in case of errors. A
>>>>> broken netdev after a failed XSK pool setup is bad behavior. Therefore,
>>>>> the allocation and setup of resources during XSK pool setup is done only
>>>>> before any queue is disabled. Additionally, freeing and later allocation
>>>>> of resources is eliminated in some cases. Page pool entries are kept for
>>>>> later use. Two memory models are registered in parallel. As a result,
>>>>> the XSK pool setup cannot fail during queue reconfiguration.
>>>>>
>>>>> In contrast to other drivers, XSK pool setup and XDP BPF program setup
>>>>> are separate actions. XSK pool setup can be done without any XDP BPF
>>>>> program. The XDP BPF program can be added, removed or changed without
>>>>> any reconfiguration of the XSK pool.
>>>>
>>>> I won't argue about your design, but I'd be glad if you would present any
>>>> perf numbers (ZC vs copy mode) just to give us some overview how your
>>>> implementation works out. Also, please consider using batching APIs and
>>>> see if this gives you any boost (my assumption is that it would).
>>>>
>>>>>
>>>>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>>>>> ---
>>>>>    drivers/net/ethernet/engleder/tsnep.h      |   7 +
>>>>>    drivers/net/ethernet/engleder/tsnep_main.c | 432 ++++++++++++++++++++-
>>>>>    drivers/net/ethernet/engleder/tsnep_xdp.c  |  67 ++++
>>>>>    3 files changed, 488 insertions(+), 18 deletions(-)
>>>
>>> (...)
>>>
>>>>> +
>>>>>    static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
>>>>>    			       struct xdp_buff *xdp, int *status,
>>>>> -			       struct netdev_queue *tx_nq, struct tsnep_tx *tx)
>>>>> +			       struct netdev_queue *tx_nq, struct tsnep_tx *tx,
>>>>> +			       bool zc)
>>>>>    {
>>>>>    	unsigned int length;
>>>>> -	unsigned int sync;
>>>>>    	u32 act;
>>>>>    	length = xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
>>>>>    	act = bpf_prog_run_xdp(prog, xdp);
>>>>> -
>>>>> -	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
>>>>> -	sync = xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
>>>>> -	sync = max(sync, length);
>>>>> -
>>>>>    	switch (act) {
>>>>>    	case XDP_PASS:
>>>>>    		return false;
>>>>> @@ -1027,8 +1149,21 @@ static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
>>>>>    		trace_xdp_exception(rx->adapter->netdev, prog, act);
>>>>>    		fallthrough;
>>>>>    	case XDP_DROP:
>>>>> -		page_pool_put_page(rx->page_pool, virt_to_head_page(xdp->data),
>>>>> -				   sync, true);
>>>>> +		if (zc) {
>>>>> +			xsk_buff_free(xdp);
>>>>> +		} else {
>>>>> +			unsigned int sync;
>>>>> +
>>>>> +			/* Due xdp_adjust_tail: DMA sync for_device cover max
>>>>> +			 * len CPU touch
>>>>> +			 */
>>>>> +			sync = xdp->data_end - xdp->data_hard_start -
>>>>> +			       XDP_PACKET_HEADROOM;
>>>>> +			sync = max(sync, length);
>>>>> +			page_pool_put_page(rx->page_pool,
>>>>> +					   virt_to_head_page(xdp->data), sync,
>>>>> +					   true);
>>>>> +		}
>>>>>    		return true;
>>>>>    	}
>>>>>    }
>>>>> @@ -1181,7 +1316,8 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
>>>>>    					 length, false);
>>>>>    			consume = tsnep_xdp_run_prog(rx, prog, &xdp,
>>>>> -						     &xdp_status, tx_nq, tx);
>>>>> +						     &xdp_status, tx_nq, tx,
>>>>> +						     false);
>>>>>    			if (consume) {
>>>>>    				rx->packets++;
>>>>>    				rx->bytes += length;
>>>>> @@ -1205,6 +1341,125 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
>>>>>    	return done;
>>>>>    }
>>>>> +static int tsnep_rx_poll_zc(struct tsnep_rx *rx, struct napi_struct *napi,
>>>>> +			    int budget)
>>>>> +{
>>>>> +	struct tsnep_rx_entry *entry;
>>>>> +	struct netdev_queue *tx_nq;
>>>>> +	struct bpf_prog *prog;
>>>>> +	struct tsnep_tx *tx;
>>>>> +	int desc_available;
>>>>> +	int xdp_status = 0;
>>>>> +	struct page *page;
>>>>> +	int done = 0;
>>>>> +	int length;
>>>>> +
>>>>> +	desc_available = tsnep_rx_desc_available(rx);
>>>>> +	prog = READ_ONCE(rx->adapter->xdp_prog);
>>>>> +	if (prog) {
>>>>> +		tx_nq = netdev_get_tx_queue(rx->adapter->netdev,
>>>>> +					    rx->tx_queue_index);
>>>>> +		tx = &rx->adapter->tx[rx->tx_queue_index];
>>>>> +	}
>>>>> +
>>>>> +	while (likely(done < budget) && (rx->read != rx->write)) {
>>>>> +		entry = &rx->entry[rx->read];
>>>>> +		if ((__le32_to_cpu(entry->desc_wb->properties) &
>>>>> +		     TSNEP_DESC_OWNER_COUNTER_MASK) !=
>>>>> +		    (entry->properties & TSNEP_DESC_OWNER_COUNTER_MASK))
>>>>> +			break;
>>>>> +		done++;
>>>>> +
>>>>> +		if (desc_available >= TSNEP_RING_RX_REFILL) {
>>>>> +			bool reuse = desc_available >= TSNEP_RING_RX_REUSE;
>>>>> +
>>>>> +			desc_available -= tsnep_rx_refill_zc(rx, desc_available,
>>>>> +							     reuse);
>>>>> +			if (!entry->xdp) {
>>>>> +				/* buffer has been reused for refill to prevent
>>>>> +				 * empty RX ring, thus buffer cannot be used for
>>>>> +				 * RX processing
>>>>> +				 */
>>>>> +				rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
>>>>> +				desc_available++;
>>>>> +
>>>>> +				rx->dropped++;
>>>>> +
>>>>> +				continue;
>>>>> +			}
>>>>> +		}
>>>>> +
>>>>> +		/* descriptor properties shall be read first, because valid data
>>>>> +		 * is signaled there
>>>>> +		 */
>>>>> +		dma_rmb();
>>>>> +
>>>>> +		prefetch(entry->xdp->data);
>>>>> +		length = __le32_to_cpu(entry->desc_wb->properties) &
>>>>> +			 TSNEP_DESC_LENGTH_MASK;
>>>>> +		entry->xdp->data_end = entry->xdp->data + length;
>>>>> +		xsk_buff_dma_sync_for_cpu(entry->xdp, rx->xsk_pool);
>>>>> +
>>>>> +		/* RX metadata with timestamps is in front of actual data,
>>>>> +		 * subtract metadata size to get length of actual data and
>>>>> +		 * consider metadata size as offset of actual data during RX
>>>>> +		 * processing
>>>>> +		 */
>>>>> +		length -= TSNEP_RX_INLINE_METADATA_SIZE;
>>>>> +
>>>>> +		rx->read = (rx->read + 1) % TSNEP_RING_SIZE;
>>>>> +		desc_available++;
>>>>> +
>>>>> +		if (prog) {
>>>>> +			bool consume;
>>>>> +
>>>>> +			entry->xdp->data += TSNEP_RX_INLINE_METADATA_SIZE;
>>>>> +			entry->xdp->data_meta += TSNEP_RX_INLINE_METADATA_SIZE;
>>>>> +
>>>>> +			consume = tsnep_xdp_run_prog(rx, prog, entry->xdp,
>>>>> +						     &xdp_status, tx_nq, tx,
>>>>> +						     true);
>>>>
>>>> reason for separate xdp run prog routine for ZC was usually "likely-fying"
>>>> XDP_REDIRECT action as this is the main action for AF_XDP which was giving
>>>> us perf improvement. Please try this out on your side to see if this
>>>> yields any positive value.
>>>
>>> One more thing - you have to handle XDP_TX action in a ZC specific way.
>>> Your current code will break if you enable xsk_pool and return XDP_TX from
>>> XDP prog.
>>
>> I took again a look to igc, but I didn't found any specifics for XDP_TX
>> ZC. Only some buffer flipping, which I assume is needed for shared
>> pages.
>> For ice I see a call to xdp_convert_buff_to_frame() in ZC path, which
>> has some XSK logic within. Is this the ZC specific way? igc calls
>> xdp_convert_buff_to_frame() in both cases, so I'm not sure. But I will
>> try the XDP_TX action. I did test only with xdpsock.
> 
> I think I will back off a bit with a statement that your XDP_TX is clearly
> broken, here's why.
> 
> igc when converting xdp_buff to xdp_frame and xdp_buff's memory being
> backed by xsk_buff_pool will grab the new page from kernel, copy the
> contents of xdp_buff to it, recycle xdp_buff back to xsk_buff_pool and
> return new page back to driver (i have just described what
> xdp_convert_zc_to_xdp_frame() is doing). Thing is that it is expensive and
> hurts perf and we stepped away from this on ice, this is a matter of
> storing the xdp_buff onto adequate Tx buffer struct that you can access
> while cleaning Tx descriptors so that you'll be able to xsk_buff_free()
> it.
> 
> So saying 'your current code will break' might have been too much from my
> side. Just make sure that your XDP_TX action on ZC works. In order to do
> that, i was loading xdpsock with XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD flag
> on a queue receiving frames and then running xdp_rxq_info with XDP_TX
> action.

I took a look to the new ice code. It makes sense to prevent that
copying. I took a note for future work. For now XDP_REDIRECT is
the optimisation path.

Tested as suggested. XDP_TX works.
