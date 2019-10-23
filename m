Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF2CE0EFC
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 02:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732151AbfJWAOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 20:14:14 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43408 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbfJWAOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 20:14:14 -0400
Received: by mail-pl1-f193.google.com with SMTP id v5so4424073ply.10
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 17:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=5amMexrOca6tufyPHdNC3BAMWuOoS7LrBFRbWvHYXmA=;
        b=TP0Q0IutlDfCe2nom8JTJs73cbSAMKBv5NhyoxpFqaLVKFlnf+sDGSy/IwAvL+tZyR
         oaMSbcOan2nEgHnOAb6pdaS+jqtd8sf2+kfOCpdfw7Xxw9UdJrjkkIMDoKj9e5xIEGyV
         ghj17a8JZOt/4xXGLAT//gQAxpwD7U4kjbPq0Hygddcowxwwng88zTMUIFPHEY4kGGg0
         k7GDkeYcvc0mdRKm33iX1f1l1z0OVlPwzr6zsSJ4jck02FGNGIpxZ2nw7uVeidWW+dBT
         h+/lG/MkWl+I7fkFyvt64dJf/1kKsaN5pq+eu1+narZN+OawaheL83elf3yOsNiZIkHp
         0wSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=5amMexrOca6tufyPHdNC3BAMWuOoS7LrBFRbWvHYXmA=;
        b=r5GsWkxd+iB2EG35VErmSdx3U3fAn8aIZRsSrL3HwWoNTqiQcP80Nw3P1MR50jkhDC
         tiXO2UfRYWTDdoFYdwgYp9cGYtTCTObBCpGcBTRUzokuu3gxGirlY/N1PnyNc1pNVNNu
         Atp0Y331T2Gh6dZeyy9umrvNAQtgdHHH2rVQV1xEAFTf8DkmKEA9Lab8Ml+NCeiIB7ZI
         3ASlUW+PWIyohy5U+W0u2TDcVfrga8B8Y4/aBFCEFzgShCdoc7/uENCxaPh7Uchc1Z0L
         Y3XK3+piZev/mUyq2U1AdC5mdG/KezQnqHtjmZUNvYEI22uH4+r29DNFROyXBnRGa2Tl
         rd9w==
X-Gm-Message-State: APjAAAXBwBUhFBUx3iRgEayoHiT9BC8rrvBZL1h4RQLyfC14Duinhgkv
        SQAuMbGYPEG502gAu7nU6xd5S1XkHZN/Ig==
X-Google-Smtp-Source: APXvYqyc/roqqiAu2Yrap+Hsxl5IsdC/qTRqN/m//PZObDuS1B76EF/Q/aqiWOJzAdjJnQKz59kcAQ==
X-Received: by 2002:a17:902:9f96:: with SMTP id g22mr6456891plq.286.1571789653279;
        Tue, 22 Oct 2019 17:14:13 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id h186sm25555594pfb.63.2019.10.22.17.14.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 17:14:12 -0700 (PDT)
Subject: Re: [PATCH net-next 5/6] ionic: implement support for rx sgl
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20191022203113.30015-1-snelson@pensando.io>
 <20191022203113.30015-6-snelson@pensando.io>
 <20191022163732.102f357c@cakuba.netronome.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <47b41a14-6814-b555-6581-f32d4a9b18b4@pensando.io>
Date:   Tue, 22 Oct 2019 17:14:11 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191022163732.102f357c@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/22/19 4:37 PM, Jakub Kicinski wrote:
> On Tue, 22 Oct 2019 13:31:12 -0700, Shannon Nelson wrote:
>> diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
>> index ab6663d94f42..8c96f5fe43a2 100644
>> --- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
>> +++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
>> @@ -34,52 +34,107 @@ static inline struct netdev_queue *q_to_ndq(struct ionic_queue *q)
>>   	return netdev_get_tx_queue(q->lif->netdev, q->index);
>>   }
>>   
>> -static void ionic_rx_recycle(struct ionic_queue *q, struct ionic_desc_info *desc_info,
>> -			     struct sk_buff *skb)
>> +static struct sk_buff *ionic_rx_skb_alloc(struct ionic_queue *q,
>> +					  unsigned int len, bool frags)
>>   {
>> -	struct ionic_rxq_desc *old = desc_info->desc;
>> -	struct ionic_rxq_desc *new = q->head->desc;
>> +	struct ionic_lif *lif = q->lif;
>> +	struct ionic_rx_stats *stats;
>> +	struct net_device *netdev;
>> +	struct sk_buff *skb;
>> +
>> +	netdev = lif->netdev;
>> +	stats = q_to_rx_stats(q);
>>   
>> -	new->addr = old->addr;
>> -	new->len = old->len;
>> +	if (frags)
>> +		skb = napi_get_frags(&q_to_qcq(q)->napi);
>> +	else
>> +		skb = netdev_alloc_skb_ip_align(netdev, len);
>>   
>> -	ionic_rxq_post(q, true, ionic_rx_clean, skb);
>> +	if (unlikely(!skb)) {
>> +		net_warn_ratelimited("%s: SKB alloc failed on %s!\n",
>> +				     netdev->name, q->name);
>> +		stats->alloc_err++;
>> +		return NULL;
>> +	}
>> +
>> +	return skb;
>>   }
>>   
>> -static bool ionic_rx_copybreak(struct ionic_queue *q, struct ionic_desc_info *desc_info,
>> -			       struct ionic_cq_info *cq_info, struct sk_buff **skb)
>> +static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
>> +				      struct ionic_desc_info *desc_info,
>> +				      struct ionic_cq_info *cq_info)
>>   {
>>   	struct ionic_rxq_comp *comp = cq_info->cq_desc;
>> -	struct ionic_rxq_desc *desc = desc_info->desc;
>> -	struct net_device *netdev = q->lif->netdev;
>>   	struct device *dev = q->lif->ionic->dev;
>> -	struct sk_buff *new_skb;
>> -	u16 clen, dlen;
>> -
>> -	clen = le16_to_cpu(comp->len);
>> -	dlen = le16_to_cpu(desc->len);
>> -	if (clen > q->lif->rx_copybreak) {
>> -		dma_unmap_single(dev, (dma_addr_t)le64_to_cpu(desc->addr),
>> -				 dlen, DMA_FROM_DEVICE);
>> -		return false;
>> -	}
>> +	struct ionic_page_info *page_info;
>> +	struct sk_buff *skb;
>> +	unsigned int i;
>> +	u16 frag_len;
>> +	u16 len;
>>   
>> -	new_skb = netdev_alloc_skb_ip_align(netdev, clen);
>> -	if (!new_skb) {
>> -		dma_unmap_single(dev, (dma_addr_t)le64_to_cpu(desc->addr),
>> -				 dlen, DMA_FROM_DEVICE);
>> -		return false;
>> -	}
>> +	page_info = &desc_info->pages[0];
>> +	len = le16_to_cpu(comp->len);
>>   
>> -	dma_sync_single_for_cpu(dev, (dma_addr_t)le64_to_cpu(desc->addr),
>> -				clen, DMA_FROM_DEVICE);
>> +	prefetch(page_address(page_info->page) + NET_IP_ALIGN);
>>   
>> -	memcpy(new_skb->data, (*skb)->data, clen);
>> +	skb = ionic_rx_skb_alloc(q, len, true);
>> +	if (unlikely(!skb))
>> +		return NULL;
>>   
>> -	ionic_rx_recycle(q, desc_info, *skb);
>> -	*skb = new_skb;
>> +	i = comp->num_sg_elems + 1;
>> +	do {
>> +		if (unlikely(!page_info->page)) {
>> +			dev_kfree_skb(skb);
>> +			return NULL;
>> +		}
> Would you not potentially free the napi->skb here? is that okay?

Yes, probably a good idea.  I'll update that.

sln

