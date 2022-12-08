Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B3A6476E0
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 20:58:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbiLHT6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 14:58:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbiLHT55 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 14:57:57 -0500
Received: from mx05lb.world4you.com (mx05lb.world4you.com [81.19.149.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D60E05F6D0;
        Thu,  8 Dec 2022 11:57:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SoGtLqalAO9QKDo/Z7/hc5vCiJD9VCisOm/W37RydJw=; b=ugF4reuGi+ChSWdv6zkCPrstfW
        +nOObzPtUj96q8N/mip+rv9iTsIlven3zYWvzYSy/gVZmkpdvHmGblAWk/8kMKOy45mWHT/l5x5Ar
        D5i+eW7SXWdlnDiH85kqtXXCK+qjFR9IcL40rR8hYDn7AX7Yw/WYC4cXHRP0dj4d5iww=;
Received: from [88.117.53.17] (helo=[10.0.0.160])
        by mx05lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1p3N19-0005O3-Vw; Thu, 08 Dec 2022 20:57:16 +0100
Message-ID: <8e3c1888-65b1-ee11-a515-3d7a71e9161e@engleder-embedded.com>
Date:   Thu, 8 Dec 2022 20:57:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v2 2/6] tsnep: Add XDP TX support
Content-Language: en-US
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com
References: <20221208054045.3600-1-gerhard@engleder-embedded.com>
 <20221208054045.3600-3-gerhard@engleder-embedded.com>
 <Y5HwRZmCv2WYpBtg@boxer>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <Y5HwRZmCv2WYpBtg@boxer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.12.22 15:10, Maciej Fijalkowski wrote:
>> @@ -65,7 +71,11 @@ struct tsnep_tx_entry {
>>   
>>   	u32 properties;
>>   
>> -	struct sk_buff *skb;
>> +	enum tsnep_tx_type type;
>> +	union {
>> +		struct sk_buff *skb;
>> +		struct xdp_frame *xdpf;
>> +	};
>>   	size_t len;
>>   	DEFINE_DMA_UNMAP_ADDR(dma);
>>   };
>> diff --git a/drivers/net/ethernet/engleder/tsnep_main.c b/drivers/net/ethernet/engleder/tsnep_main.c
>> index a28fde9fb060..b97cfd5fa1fa 100644
>> --- a/drivers/net/ethernet/engleder/tsnep_main.c
>> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
>> @@ -310,10 +310,11 @@ static void tsnep_tx_activate(struct tsnep_tx *tx, int index, int length,
>>   	struct tsnep_tx_entry *entry = &tx->entry[index];
>>   
>>   	entry->properties = 0;
>> -	if (entry->skb) {
>> +	if (entry->skb || entry->xdpf) {
> 
> i think this change is redundant, you could keep a single check as skb and
> xdpf ptrs share the same memory, but i guess this makes it more obvious

Yes it is actually redundant. I thought it is not a good idea to rely on
the union in the code.

>> +/* This function requires __netif_tx_lock is held by the caller. */
>> +static int tsnep_xdp_xmit_frame_ring(struct xdp_frame *xdpf,
>> +				     struct tsnep_tx *tx, bool dma_map)
>> +{
>> +	struct skb_shared_info *shinfo = xdp_get_shared_info_from_frame(xdpf);
>> +	unsigned long flags;
>> +	int count = 1;
>> +	struct tsnep_tx_entry *entry;
>> +	int length;
>> +	int i;
>> +	int retval;
>> +
>> +	if (unlikely(xdp_frame_has_frags(xdpf)))
>> +		count += shinfo->nr_frags;
>> +
>> +	spin_lock_irqsave(&tx->lock, flags);
>> +
>> +	if (tsnep_tx_desc_available(tx) < (MAX_SKB_FRAGS + 1 + count)) {
> 
> Wouldn't count + 1 be sufficient to check against the descs available?
> if there are frags then you have already accounted them under count
> variable so i feel like MAX_SKB_FRAGS is redundant.

In the standard TX path tsnep_xmit_frame_ring() would stop the queue if
less than MAX_SKB_FRAGS + 1 descriptors are available. I wanted to keep
that stop queue logic in tsnep_xmit_frame_ring() by ensuring that XDP
never exceeds this limit (similar to STMMAC_TX_THRESH of stmmac).

So this line checks if enough descriptors are available and that the
queue would not have been stopped by tsnep_xmit_frame_ring().

I could improve the comment below.

>> +		/* prevent full TX ring due to XDP */
>> +		spin_unlock_irqrestore(&tx->lock, flags);
>> +
>> +		return -EBUSY;
>> +	}

Gerhard
