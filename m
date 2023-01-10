Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74D20664DFF
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 22:28:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbjAJV24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 16:28:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234505AbjAJV2y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 16:28:54 -0500
Received: from mx24lb.world4you.com (mx24lb.world4you.com [81.19.149.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50E95567D
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 13:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=YPHGZCZQcsJnMJncY3C+ACgPaIgKUN4eJVIbjXA3Tmo=; b=EljGo7vROczQ/8z9n51LuY8UAW
        RSJsPfZBzoxNS9A/Zmu7eoyGQBxhDnob3GW9hEzUklSgOXS4FM5d/IiBSmKB5nja7CTm6926SEx8u
        Gn+U0lpz3YyzpBvMlmQygmMy3qpA/wqxs10pA/VFOyk9oMUnK/yXtK6p7qWcSaSl+sd0=;
Received: from [88.117.53.243] (helo=[10.0.0.160])
        by mx24lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pFMAt-0000Qg-V1; Tue, 10 Jan 2023 22:28:52 +0100
Message-ID: <a78d3011-738c-2289-7a70-cd046cde12d5@engleder-embedded.com>
Date:   Tue, 10 Jan 2023 22:28:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v4 09/10] tsnep: Add XDP RX support
Content-Language: en-US
To:     Alexander H Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
 <20230109191523.12070-10-gerhard@engleder-embedded.com>
 <c5e39384f185fcb8788e7723498702b0235e367e.camel@gmail.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <c5e39384f185fcb8788e7723498702b0235e367e.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.01.23 18:40, Alexander H Duyck wrote:
> On Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
>> If BPF program is set up, then run BPF program for every received frame
>> and execute the selected action.
>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>> ---
>>   drivers/net/ethernet/engleder/tsnep_main.c | 122 ++++++++++++++++++++-
>>   1 file changed, 120 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
>> index 451ad1849b9d..002c879639db 100644
>> --- a/drivers/net/ethernet/engleder/tsnep_main.c
>> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
>> @@ -27,6 +27,7 @@
>>   #include <linux/phy.h>
>>   #include <linux/iopoll.h>
>>   #include <linux/bpf.h>
>> +#include <linux/bpf_trace.h>
>>   
>>   #define TSNEP_SKB_PAD (NET_SKB_PAD + NET_IP_ALIGN)
>>   #define TSNEP_HEADROOM ALIGN(max(TSNEP_SKB_PAD, XDP_PACKET_HEADROOM), 4)
>> @@ -44,6 +45,9 @@
>>   #define TSNEP_COALESCE_USECS_MAX     ((ECM_INT_DELAY_MASK >> ECM_INT_DELAY_SHIFT) * \
>>   				      ECM_INT_DELAY_BASE_US + ECM_INT_DELAY_BASE_US - 1)
>>   
>> +#define TSNEP_XDP_TX		BIT(0)
>> +#define TSNEP_XDP_REDIRECT	BIT(1)
>> +
>>   enum {
>>   	__TSNEP_DOWN,
>>   };
>> @@ -625,6 +629,28 @@ static void tsnep_xdp_xmit_flush(struct tsnep_tx *tx)
>>   	iowrite32(TSNEP_CONTROL_TX_ENABLE, tx->addr + TSNEP_CONTROL);
>>   }
>>   
>> +static bool tsnep_xdp_xmit_back(struct tsnep_adapter *adapter,
>> +				struct xdp_buff *xdp,
>> +				struct netdev_queue *tx_nq, struct tsnep_tx *tx)
>> +{
>> +	struct xdp_frame *xdpf = xdp_convert_buff_to_frame(xdp);
>> +	bool xmit;
>> +
>> +	if (unlikely(!xdpf))
>> +		return false;
>> +
>> +	__netif_tx_lock(tx_nq, smp_processor_id());
>> +
>> +	/* Avoid transmit queue timeout since we share it with the slow path */
>> +	txq_trans_cond_update(tx_nq);
>> +
>> +	xmit = tsnep_xdp_xmit_frame_ring(xdpf, tx, TSNEP_TX_TYPE_XDP_TX);
>> +
> 
> Again the trans_cond_update should be after the xmit and only if it is
> not indicating it completed the transmit.

tsnep_xdp_xmit_frame_ring() only adds xpdf to the descriptor ring, so it
cannot complete the transmit. Therefore and in line with your previous
comment trans_cond_update() should be called here if xpdf is
successfully placed in the descriptor ring. Is that right?

>> +	__netif_tx_unlock(tx_nq);
>> +
>> +	return xmit;
>> +}
>> +
>>   static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>>   {
>>   	struct tsnep_tx_entry *entry;
>> @@ -983,6 +1009,62 @@ static int tsnep_rx_refill(struct tsnep_rx *rx, int count, bool reuse)
>>   	return i;
>>   }
>>   
>> +static bool tsnep_xdp_run_prog(struct tsnep_rx *rx, struct bpf_prog *prog,
>> +			       struct xdp_buff *xdp, int *status,
>> +			       struct netdev_queue *tx_nq, struct tsnep_tx *tx)
>> +{
>> +	unsigned int length;
>> +	unsigned int sync;
>> +	u32 act;
>> +
>> +	length = xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
>> +
>> +	act = bpf_prog_run_xdp(prog, xdp);
>> +
>> +	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
>> +	sync = xdp->data_end - xdp->data_hard_start - XDP_PACKET_HEADROOM;
>> +	sync = max(sync, length);
>> +
>> +	switch (act) {
>> +	case XDP_PASS:
>> +		return false;
>> +	case XDP_TX:
>> +		if (!tsnep_xdp_xmit_back(rx->adapter, xdp, tx_nq, tx))
>> +			goto out_failure;
>> +		*status |= TSNEP_XDP_TX;
>> +		return true;
>> +	case XDP_REDIRECT:
>> +		if (xdp_do_redirect(rx->adapter->netdev, xdp, prog) < 0)
>> +			goto out_failure;
>> +		*status |= TSNEP_XDP_REDIRECT;
>> +		return true;
>> +	default:
>> +		bpf_warn_invalid_xdp_action(rx->adapter->netdev, prog, act);
>> +		fallthrough;
>> +	case XDP_ABORTED:
>> +out_failure:
>> +		trace_xdp_exception(rx->adapter->netdev, prog, act);
>> +		fallthrough;
>> +	case XDP_DROP:
>> +		page_pool_put_page(rx->page_pool, virt_to_head_page(xdp->data),
>> +				   sync, true);
>> +		return true;
>> +	}
>> +}
>> +
>> +static void tsnep_finalize_xdp(struct tsnep_adapter *adapter, int status,
>> +			       struct netdev_queue *tx_nq, struct tsnep_tx *tx)
>> +{
>> +	if (status & TSNEP_XDP_TX) {
>> +		__netif_tx_lock(tx_nq, smp_processor_id());
>> +		tsnep_xdp_xmit_flush(tx);
>> +		__netif_tx_unlock(tx_nq);
>> +	}
>> +
>> +	if (status & TSNEP_XDP_REDIRECT)
>> +		xdp_do_flush();
>> +}
>> +
>>   static struct sk_buff *tsnep_build_skb(struct tsnep_rx *rx, struct page *page,
>>   				       int length)
>>   {
>> @@ -1018,15 +1100,29 @@ static int tsnep_rx_poll(struct tsnep_rx *rx, struct napi_struct *napi,
>>   			 int budget)
>>   {
>>   	struct device *dmadev = rx->adapter->dmadev;
>> -	int desc_available;
>> -	int done = 0;
>>   	enum dma_data_direction dma_dir;
>>   	struct tsnep_rx_entry *entry;
>> +	struct netdev_queue *tx_nq;
>> +	struct bpf_prog *prog;
>> +	struct xdp_buff xdp;
>>   	struct sk_buff *skb;
>> +	struct tsnep_tx *tx;
>> +	int desc_available;
>> +	int xdp_status = 0;
>> +	int done = 0;
>>   	int length;
>>   
>>   	desc_available = tsnep_rx_desc_available(rx);
>>   	dma_dir = page_pool_get_dma_dir(rx->page_pool);
>> +	prog = READ_ONCE(rx->adapter->xdp_prog);
>> +	if (prog) {
>> +		int queue = smp_processor_id() % rx->adapter->num_tx_queues;
>> +
> 
> As I mentioned before. Take a look at how this was addressed in
> skb_tx_hash. The modulus division is really expensive.
> 
> Also does this make sense. I am assuming you have a 1:1 Tx to Rx
> mapping for your queues don't you? If so it might make more sense to
> use the Tx queue that you clean in this queue pair.

Sounds reasonable. I will work on that.

Gerhard
