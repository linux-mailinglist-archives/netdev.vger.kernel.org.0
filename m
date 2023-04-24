Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45D36ED4A0
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 20:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbjDXSkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 14:40:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbjDXSkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 14:40:45 -0400
Received: from mx05lb.world4you.com (mx05lb.world4you.com [81.19.149.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E3065A8;
        Mon, 24 Apr 2023 11:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rZSvYRJCm1YwId/r2d17sDWM7tvYTeySLkDdNhdkAJE=; b=uQHFyDAGc6z2qS3ECawbp0LyOf
        36e8Ka3Fu5xSPAaTMoOV8OQlIKtuunQ3yS2nBDGSBMAn/e3SnhOnmUmCodULfL4hjj2tkw2HTIFJ+
        1oeTDgt1Xv/yytVvGajtt0Ol0Yityytrx0wVD1qORUEk85VnxQsKkym3iLYNf8P+qMxk=;
Received: from [88.117.57.231] (helo=[10.0.0.160])
        by mx05lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pr178-0002J8-EK; Mon, 24 Apr 2023 20:40:38 +0200
Message-ID: <f9442f99-783d-a227-df85-c602e6bdd752@engleder-embedded.com>
Date:   Mon, 24 Apr 2023 20:40:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v3 6/6] tsnep: Add XDP socket zero-copy TX
 support
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
References: <20230418190459.19326-1-gerhard@engleder-embedded.com>
 <20230418190459.19326-7-gerhard@engleder-embedded.com>
 <ZEGd5QHTInP8WRlZ@boxer>
 <fddf3dd3-2d75-3969-7a62-a4eeeb6ef553@engleder-embedded.com>
 <ZEZv+5DJbEzn28+M@boxer>
Content-Language: en-US
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <ZEZv+5DJbEzn28+M@boxer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24.04.23 14:03, Maciej Fijalkowski wrote:
> On Fri, Apr 21, 2023 at 09:02:56PM +0200, Gerhard Engleder wrote:
>> On 20.04.23 22:17, Maciej Fijalkowski wrote:
>>> On Tue, Apr 18, 2023 at 09:04:59PM +0200, Gerhard Engleder wrote:
>>>> Send and complete XSK pool frames within TX NAPI context. NAPI context
>>>> is triggered by ndo_xsk_wakeup.
>>>>
>>>> Test results with A53 1.2GHz:
>>>>
>>>> xdpsock txonly copy mode:
>>>>                      pps            pkts           1.00
>>>> tx                 284,409        11,398,144
>>>> Two CPUs with 100% and 10% utilization.
>>>>
>>>> xdpsock txonly zero-copy mode:
>>>>                      pps            pkts           1.00
>>>> tx                 511,929        5,890,368
>>>> Two CPUs with 100% and 1% utilization.
>>>
>>> Hmm, I think l2fwd ZC numbers should be included here not in the previous
>>> patch?
>>
>> Will be done.
>>
>>>>
>>>> Packet rate increases and CPU utilization is reduced.
>>>>
>>>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>>>> ---
>>>>    drivers/net/ethernet/engleder/tsnep.h      |   2 +
>>>>    drivers/net/ethernet/engleder/tsnep_main.c | 127 +++++++++++++++++++--
>>>>    2 files changed, 119 insertions(+), 10 deletions(-)
>>>>
>>
>> (...)
>>
>>>>    static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>>>>    {
>>>>    	struct tsnep_tx_entry *entry;
>>>>    	struct netdev_queue *nq;
>>>> +	int xsk_frames = 0;
>>>>    	int budget = 128;
>>>>    	int length;
>>>>    	int count;
>>>> @@ -676,7 +771,7 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>>>>    		if ((entry->type & TSNEP_TX_TYPE_SKB) &&
>>>>    		    skb_shinfo(entry->skb)->nr_frags > 0)
>>>>    			count += skb_shinfo(entry->skb)->nr_frags;
>>>> -		else if (!(entry->type & TSNEP_TX_TYPE_SKB) &&
>>>> +		else if ((entry->type & TSNEP_TX_TYPE_XDP) &&
>>>>    			 xdp_frame_has_frags(entry->xdpf))
>>>>    			count += xdp_get_shared_info_from_frame(entry->xdpf)->nr_frags;
>>>> @@ -705,9 +800,11 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>>>>    		if (entry->type & TSNEP_TX_TYPE_SKB)
>>>>    			napi_consume_skb(entry->skb, napi_budget);
>>>> -		else
>>>> +		else if (entry->type & TSNEP_TX_TYPE_XDP)
>>>>    			xdp_return_frame_rx_napi(entry->xdpf);
>>>> -		/* xdpf is union with skb */
>>>> +		else
>>>> +			xsk_frames++;
>>>> +		/* xdpf and zc are union with skb */
>>>>    		entry->skb = NULL;
>>>>    		tx->read = (tx->read + count) & TSNEP_RING_MASK;
>>>> @@ -718,6 +815,14 @@ static bool tsnep_tx_poll(struct tsnep_tx *tx, int napi_budget)
>>>>    		budget--;
>>>>    	} while (likely(budget));
>>>> +	if (tx->xsk_pool) {
>>>> +		if (xsk_frames)
>>>> +			xsk_tx_completed(tx->xsk_pool, xsk_frames);
>>>> +		if (xsk_uses_need_wakeup(tx->xsk_pool))
>>>> +			xsk_set_tx_need_wakeup(tx->xsk_pool);
>>>> +		tsnep_xdp_xmit_zc(tx);
>>>
>>> would be good to signal to NAPI if we are done with the work or is there a
>>> need to be rescheduled (when you didn't manage to consume all of the descs
>>> from XSK Tx ring).
>>
>> In my opinion this is already done. If some budget is left, then we are
>> done and tsnep_tx_poll() returns true to signal work is complete. If
>> buget gets zero, then tsnep_tx_poll() returns false to signal work is
>> not complete. This return value is considered for the NAPI signaling
>> by tsnep_poll().
> 
> i was only referring to tsnep_xdp_xmit_zc() being void on return. Thing is
> that there is currently no way you would tell to napi there is more work
> to be done. you should do so if desc_available == batch. That would mean
> there might be still descriptors on XSK Tx ring ready to be consumed. NAPI
> budget is out of the picture here.

Now I got it. Pending zero-copy work shall be signaled to napi directly.
In current implementation it would be processed if TX interrupt signals
completed descriptors. By signaling napi directly, the TX interrupt
could be prevented. In my opinion both options are possible, but the
performance may differ. I will check if telling napi that there is more
work to be done would improve performance.
