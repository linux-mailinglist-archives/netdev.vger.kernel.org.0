Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8704883C6
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 14:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbiAHN1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 08:27:19 -0500
Received: from mx3.wp.pl ([212.77.101.10]:36411 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbiAHN1S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Jan 2022 08:27:18 -0500
Received: (wp-smtpd smtp.wp.pl 32852 invoked from network); 8 Jan 2022 14:27:14 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1641648434; bh=bekp1Qt50V5BwOs8/LkFBvx1MFKWNaNfsRC8YTk1aKw=;
          h=Subject:To:From;
          b=rBrmGHMWSQfVKsRjCKwyRdjEsD67tqQgaHptiCaTLRUaFBG7FbaDLrXzEsE12eKAP
           Wc3fAIz3+9dF/g6jXkeuUvGrUoMDy1HK5zK+y6WBnP2EkwxpJt22CfbkZloY5zaaOu
           YUHTWpU6cZUv2tGNmASDKgD4yvVyljzDqDghFT4g=
Received: from riviera.nat.ds.pw.edu.pl (HELO [192.168.3.133]) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <eric.dumazet@gmail.com>; 8 Jan 2022 14:27:14 +0100
Message-ID: <98bed219-5fb4-8376-e300-c77daf4549eb@wp.pl>
Date:   Sat, 8 Jan 2022 14:27:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH net-next] net: lantiq_xrx200: add ingress SG DMA support
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>, hauke@hauke-m.de,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220103194316.1116630-1-olek2@wp.pl>
 <0215980e-a258-5322-13e9-42fe868817b3@gmail.com>
From:   Aleksander Bajkowski <olek2@wp.pl>
In-Reply-To: <0215980e-a258-5322-13e9-42fe868817b3@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: de796539d1e4a2922f773213bc572bae
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000B [4fMk]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On 1/4/22 18:41, Eric Dumazet wrote:
> 
> On 1/3/22 11:43, Aleksander Jan Bajkowski wrote:
>> This patch adds support for scatter gather DMA. DMA in PMAC splits
>> the packet into several buffers when the MTU on the CPU port is
>> less than the MTU of the switch. The first buffer starts at an
>> offset of NET_IP_ALIGN. In subsequent buffers, dma ignores the
>> offset. Thanks to this patch, the user can still connect to the
>> device in such a situation. For normal configurations, the patch
>> has no effect on performance.
>>
>> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
>> ---
>>   drivers/net/ethernet/lantiq_xrx200.c | 47 +++++++++++++++++++++++-----
>>   1 file changed, 40 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
>> index 80bfaf2fec92..503fb99c5b90 100644
>> --- a/drivers/net/ethernet/lantiq_xrx200.c
>> +++ b/drivers/net/ethernet/lantiq_xrx200.c
>> @@ -27,6 +27,9 @@
>>   #define XRX200_DMA_TX        1
>>   #define XRX200_DMA_BURST_LEN    8
>>   +#define XRX200_DMA_PACKET_COMPLETE    0
>> +#define XRX200_DMA_PACKET_IN_PROGRESS    1
>> +
>>   /* cpu port mac */
>>   #define PMAC_RX_IPG        0x0024
>>   #define PMAC_RX_IPG_MASK    0xf
>> @@ -62,6 +65,9 @@ struct xrx200_chan {
>>       struct ltq_dma_channel dma;
>>       struct sk_buff *skb[LTQ_DESC_NUM];
>>   +    struct sk_buff *skb_head;
>> +    struct sk_buff *skb_tail;
>> +
>>       struct xrx200_priv *priv;
>>   };
>>   @@ -205,7 +211,8 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
>>       struct xrx200_priv *priv = ch->priv;
>>       struct ltq_dma_desc *desc = &ch->dma.desc_base[ch->dma.desc];
>>       struct sk_buff *skb = ch->skb[ch->dma.desc];
>> -    int len = (desc->ctl & LTQ_DMA_SIZE_MASK);
>> +    u32 ctl = desc->ctl;
>> +    int len = (ctl & LTQ_DMA_SIZE_MASK);
>>       struct net_device *net_dev = priv->net_dev;
>>       int ret;
>>   @@ -221,12 +228,36 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
>>       }
>>         skb_put(skb, len);
>> -    skb->protocol = eth_type_trans(skb, net_dev);
>> -    netif_receive_skb(skb);
>> -    net_dev->stats.rx_packets++;
>> -    net_dev->stats.rx_bytes += len;
>>   -    return 0;
>> +    /* add buffers to skb via skb->frag_list */
>> +    if (ctl & LTQ_DMA_SOP) {
>> +        ch->skb_head = skb;
>> +        ch->skb_tail = skb;
>> +    } else if (ch->skb_head) {
>> +        if (ch->skb_head == ch->skb_tail)
>> +            skb_shinfo(ch->skb_tail)->frag_list = skb;
>> +        else
>> +            ch->skb_tail->next = skb;
>> +        ch->skb_tail = skb;
>> +        skb_reserve(ch->skb_tail, -NET_IP_ALIGN);
>> +        ch->skb_head->len += skb->len;
>> +        ch->skb_head->data_len += skb->len;
>> +        ch->skb_head->truesize += skb->truesize;
>> +    }
>> +
>> +    if (ctl & LTQ_DMA_EOP) {
>> +        ch->skb_head->protocol = eth_type_trans(ch->skb_head, net_dev);
>> +        netif_receive_skb(ch->skb_head);
>> +        net_dev->stats.rx_packets++;
>> +        net_dev->stats.rx_bytes += ch->skb_head->len;
> 
> 
> Use after free alert.
> 
> Please add/test the following fix.
> 
> (It is illegal to deref skb after netif_receive_skb())
> 
> 
> diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
> index 503fb99c5b90..bf7e3c7910d1 100644
> --- a/drivers/net/ethernet/lantiq_xrx200.c
> +++ b/drivers/net/ethernet/lantiq_xrx200.c
> @@ -247,9 +247,9 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
> 
>         if (ctl & LTQ_DMA_EOP) {
>                 ch->skb_head->protocol = eth_type_trans(ch->skb_head, net_dev);
> -               netif_receive_skb(ch->skb_head);
>                 net_dev->stats.rx_packets++;
>                 net_dev->stats.rx_bytes += ch->skb_head->len;
> +               netif_receive_skb(ch->skb_head);
>                 ch->skb_head = NULL;
>                 ch->skb_tail = NULL;
>                 ret = XRX200_DMA_PACKET_COMPLETE;
> 
> 
>


Thanks for spot this bug. I tested this patch and it works
ok. I will sent this patch it soon. 


>> +        ch->skb_head = NULL;
>> +        ch->skb_tail = NULL;
>> +        ret = XRX200_DMA_PACKET_COMPLETE;
>> +    } else {
>> +        ret = XRX200_DMA_PACKET_IN_PROGRESS;
>> +    }
>> +
>> +    return ret;
>>   }
>>     static int xrx200_poll_rx(struct napi_struct *napi, int budget)
>> @@ -241,7 +272,9 @@ static int xrx200_poll_rx(struct napi_struct *napi, int budget)
>>             if ((desc->ctl & (LTQ_DMA_OWN | LTQ_DMA_C)) == LTQ_DMA_C) {
>>               ret = xrx200_hw_receive(ch);
>> -            if (ret)
>> +            if (ret == XRX200_DMA_PACKET_IN_PROGRESS)
>> +                continue;
>> +            if (ret != XRX200_DMA_PACKET_COMPLETE)
>>                   return ret;
>>               rx++;
>>           } else {
