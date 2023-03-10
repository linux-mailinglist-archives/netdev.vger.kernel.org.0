Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE95E6B3419
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 03:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjCJCPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 21:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjCJCOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 21:14:53 -0500
Received: from out0-197.mail.aliyun.com (out0-197.mail.aliyun.com [140.205.0.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79709FE08F
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 18:14:50 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047188;MF=amy.saq@antgroup.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---.Rj1TxaO_1678414487;
Received: from 30.46.242.148(mailfrom:amy.saq@antgroup.com fp:SMTPD_---.Rj1TxaO_1678414487)
          by smtp.aliyun-inc.com;
          Fri, 10 Mar 2023 10:14:48 +0800
Message-ID: <9ff86804-fe40-6e03-7ed4-6b431220e202@antgroup.com>
Date:   Fri, 10 Mar 2023 10:14:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH v3] net/packet: support mergeable feature of virtio
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     <mst@redhat.com>, <davem@davemloft.net>, <jasowang@redhat.com>,
        "=?UTF-8?B?6LCI6Ym06ZSL?=" <henry.tjf@antgroup.com>
References: <1678168911-337042-1-git-send-email-amy.saq@antgroup.com>
 <64075d1f7ccfc_efd1020865@willemb.c.googlers.com.notmuch>
 <a55816a9-073b-c030-f7f8-19588124e08b@antgroup.com>
 <6409f8bf71c9e_1abbab2088e@willemb.c.googlers.com.notmuch>
From:   "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
In-Reply-To: <6409f8bf71c9e_1abbab2088e@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/3/9 下午11:18, Willem de Bruijn 写道:
> 沈安琪(凛玥) wrote:
>> 在 2023/3/7 下午11:49, Willem de Bruijn 写道:
>>> 沈安琪(凛玥) wrote:
>>>> From: Jianfeng Tan <henry.tjf@antgroup.com>
>>>>
>>>> Packet sockets, like tap, can be used as the backend for kernel vhost.
>>>> In packet sockets, virtio net header size is currently hardcoded to be
>>>> the size of struct virtio_net_hdr, which is 10 bytes; however, it is not
>>>> always the case: some virtio features, such as mrg_rxbuf, need virtio
>>>> net header to be 12-byte long.
>>>>
>>>> Mergeable buffers, as a virtio feature, is worthy of supporting: packets
>>>> that are larger than one-mbuf size will be dropped in vhost worker's
>>>> handle_rx if mrg_rxbuf feature is not used, but large packets
>>>> cannot be avoided and increasing mbuf's size is not economical.
>>>>
>>>> With this mergeable feature enabled by virtio-user, packet sockets with
>>>> hardcoded 10-byte virtio net header will parse mac head incorrectly in
>>>> packet_snd by taking the last two bytes of virtio net header as part of
>>>> mac header.
>>>> This incorrect mac header parsing will cause packet to be dropped due to
>>>> invalid ether head checking in later under-layer device packet receiving.
>>>>
>>>> By adding extra field vnet_hdr_sz with utilizing holes in struct
>>>> packet_sock to record currently used virtio net header size and supporting
>>>> extra sockopt PACKET_VNET_HDR_SZ to set specified vnet_hdr_sz, packet
>>>> sockets can know the exact length of virtio net header that virtio user
>>>> gives.
>>>> In packet_snd, tpacket_snd and packet_recvmsg, instead of using
>>>> hardcoded virtio net header size, it can get the exact vnet_hdr_sz from
>>>> corresponding packet_sock, and parse mac header correctly based on this
>>>> information to avoid the packets being mistakenly dropped.
>>>>
>>>> Besides, has_vnet_hdr field in struct packet_sock is removed since all
>>>> the information it provides is covered by vnet_hdr_sz field: a packet
>>>> socket has a vnet header if and only if its vnet_hdr_sz is not zero.
>>>>
>>>> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
>>>> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
>>>> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
>>>> ---
>>>> diff --git a/net/packet/internal.h b/net/packet/internal.h
>>>> index 48af35b..9b52d93 100644
>>>> --- a/net/packet/internal.h
>>>> +++ b/net/packet/internal.h
>>>> @@ -119,9 +119,9 @@ struct packet_sock {
>>>>    	unsigned int		running;	/* bind_lock must be held */
>>>>    	unsigned int		auxdata:1,	/* writer must hold sock lock */
>>>>    				origdev:1,
>>>> -				has_vnet_hdr:1,
>>>>    				tp_loss:1,
>>>> -				tp_tx_has_off:1;
>>>> +				tp_tx_has_off:1,
>>>> +				vnet_hdr_sz:8;
>>> just a separate u8 variable , rather than 8 bits in a u32.
>>>
>>>>    	int			pressure;
>>>>    	int			ifindex;	/* bound device		*/
>>
>> We plan to add
>>
>> +	   u8	vnet_hdr_sz:8;
>>
>> here.
>> Is this a proper place to add this field to make sure the cacheline will not be broken?
> When in doubt, use pahole (`pahole -C packet_sock net/packet/af_packet.o`).
>
> There currently is a 27-bit hole before pressure. That would be a good spot.


Thanks for the advice! We will try the tool.

Besides, we wonder whether it will be better to use unsigned char or u8 
here to be more consistent with other fields.


>>>>    	__be16			num;
>>>> -- 
>>>> 1.8.3.1
>>>>
