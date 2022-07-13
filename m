Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7148D573DDC
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 22:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236777AbiGMUii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 16:38:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236481AbiGMUig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 16:38:36 -0400
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6FD2261B
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 13:38:32 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 7578 invoked from network); 13 Jul 2022 22:38:29 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1657744709; bh=+krRejcjJ8GRV1MoEXeN2f0MS3ELVlNB2yISMmLvhmc=;
          h=Subject:To:Cc:From;
          b=s7VyUtDJUT8tWkM4ih9yz5u73lQKgw4XBE485O5eOd8LZC0Hh85i9yw8STLCk/fmw
           lWoNcRzIRcGH24TF302ng3BnBaDLiVAbQsGl7/T9Lds9cakxQUB7xrpfUSWG8rhv1H
           GLISh+53P/WlDNF4pQonKMXaPls9DV1AGkTqErV4=
Received: from ip-137-21.ds.pw.edu.pl (HELO [192.168.3.133]) (olek2@wp.pl@[194.29.137.21])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <edumazet@google.com>; 13 Jul 2022 22:38:29 +0200
Message-ID: <72d3a578-f321-41aa-858c-9f3a6978a277@wp.pl>
Date:   Wed, 13 Jul 2022 22:38:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net-next] net: lantiq_xrx200: use skb cache
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     hauke@hauke-m.de, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20220712181456.3398-1-olek2@wp.pl>
 <CANn89iLbFYaV9MhYMHAzZOKM=ZKaAPOAuuXec_t9G5s4ypnY6A@mail.gmail.com>
From:   Aleksander Bajkowski <olek2@wp.pl>
In-Reply-To: <CANn89iLbFYaV9MhYMHAzZOKM=ZKaAPOAuuXec_t9G5s4ypnY6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-WP-MailID: 34297892d757b274158439635bc78403
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000B [oZPU]                               
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

On 7/13/22 14:50, Eric Dumazet wrote:
> On Tue, Jul 12, 2022 at 8:15 PM Aleksander Jan Bajkowski <olek2@wp.pl> wrote:
>>
>> napi_build_skb() reuses NAPI skbuff_head cache in order to save some
>> cycles on freeing/allocating skbuff_heads on every new Rx or completed
>> Tx.
>> Use napi_consume_skb() to feed the cache with skbuff_heads of completed
>> Tx. The budget parameter is added to indicate NAPI context, as a value
>> of zero can be passed in the case of netpoll.
>>
>> NAT performance results on BT Home Hub 5A (kernel 5.15.45, mtu 1500):
>>
>> Fast path (Software Flow Offload):
>>         Up      Down
>> Before  702.4   719.3
>> After   707.3   739.9
>>
>> Slow path:
>>         Up      Down
>> Before  91.8    184.1
>> After   92.0    185.7
>>
>> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
>> ---
>>  drivers/net/ethernet/lantiq_xrx200.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
>> index 5edb68a8aab1..83e07404803f 100644
>> --- a/drivers/net/ethernet/lantiq_xrx200.c
>> +++ b/drivers/net/ethernet/lantiq_xrx200.c
>> @@ -238,7 +238,7 @@ static int xrx200_hw_receive(struct xrx200_chan *ch)
>>                 return ret;
>>         }
>>
>> -       skb = build_skb(buf, priv->rx_skb_size);
>> +       skb = napi_build_skb(buf, priv->rx_skb_size);
> 
> If you are changing this code path, what about adding proper error recovery ?
> 
> skb can be NULL at this point :/
> 


Good catch. I will try to test the fix on the device tomorrow and send the patch.

>>         skb_reserve(skb, NET_SKB_PAD);
>>         skb_put(skb, len);
>>
>> @@ -321,7 +321,7 @@ static int xrx200_tx_housekeeping(struct napi_struct *napi, int budget)
>>                         pkts++;
>>                         bytes += skb->len;
>>                         ch->skb[ch->tx_free] = NULL;
>> -                       consume_skb(skb);
>> +                       napi_consume_skb(skb, budget);
>>                         memset(&ch->dma.desc_base[ch->tx_free], 0,
>>                                sizeof(struct ltq_dma_desc));
>>                         ch->tx_free++;
>> --
>> 2.30.2
>>

Best regards,
Aleksander
