Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337136E7384
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 08:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbjDSGwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 02:52:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbjDSGwa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 02:52:30 -0400
Received: from out0-213.mail.aliyun.com (out0-213.mail.aliyun.com [140.205.0.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519E62698;
        Tue, 18 Apr 2023 23:52:27 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047212;MF=amy.saq@antgroup.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---.SKIPqvP_1681887140;
Received: from 30.230.59.187(mailfrom:amy.saq@antgroup.com fp:SMTPD_---.SKIPqvP_1681887140)
          by smtp.aliyun-inc.com;
          Wed, 19 Apr 2023 14:52:21 +0800
Message-ID: <f6a3a72d-495b-d1f1-9013-9be2faf67798@antgroup.com>
Date:   Wed, 19 Apr 2023 14:52:20 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v8] net/packet: support mergeable feature of virtio
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     "=?UTF-8?B?6LCI6Ym06ZSL?=" <henry.tjf@antgroup.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <netdev@vger.kernel.org>
References: <20230413114402.50225-1-amy.saq@antgroup.com>
 <64387b25619ba_1479cd29457@willemb.c.googlers.com.notmuch>
From:   "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
In-Reply-To: <64387b25619ba_1479cd29457@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/4/14 上午5:59, Willem de Bruijn 写道:
> 沈安琪(凛玥) wrote:
>> From: Jianfeng Tan <henry.tjf@antgroup.com>
>>
>> Packet sockets, like tap, can be used as the backend for kernel vhost.
>> In packet sockets, virtio net header size is currently hardcoded to be
>> the size of struct virtio_net_hdr, which is 10 bytes; however, it is not
>> always the case: some virtio features, such as mrg_rxbuf, need virtio
>> net header to be 12-byte long.
>>
>> Mergeable buffers, as a virtio feature, is worthy of supporting: packets
>> that are larger than one-mbuf size will be dropped in vhost worker's
>> handle_rx if mrg_rxbuf feature is not used, but large packets
>> cannot be avoided and increasing mbuf's size is not economical.
>>
>> With this virtio feature enabled by virtio-user, packet sockets with
>> hardcoded 10-byte virtio net header will parse mac head incorrectly in
>> packet_snd by taking the last two bytes of virtio net header as part of
>> mac header.
>> This incorrect mac header parsing will cause packet to be dropped due to
>> invalid ether head checking in later under-layer device packet receiving.
>>
>> By adding extra field vnet_hdr_sz with utilizing holes in struct
>> packet_sock to record currently used virtio net header size and supporting
>> extra sockopt PACKET_VNET_HDR_SZ to set specified vnet_hdr_sz, packet
>> sockets can know the exact length of virtio net header that virtio user
>> gives.
>> In packet_snd, tpacket_snd and packet_recvmsg, instead of using
>> hardcoded virtio net header size, it can get the exact vnet_hdr_sz from
>> corresponding packet_sock, and parse mac header correctly based on this
>> information to avoid the packets being mistakenly dropped.
>>
>> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
>> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
>> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
>> ---
>>
>> Changelog
>>
>> V7 -> V8:
>> * remove redundant variables;
>> * resolve KCSAN warning.
>>
>> V6 -> V7:
>> * addresses coding style comments.
>>
>> V5 -> V6:
>> * rebase patch based on 6.3-rc2.
>>
>> V4 -> V5:
>> * add READ_ONCE() macro when initializing local vnet_hdr_sz variable;
>> * fix some nits.
>>
>> V3 -> V4:
>> * read po->vnet_hdr_sz once during vnet_hdr_sz and use vnet_hdr_sz locally
>> to avoid race condition;
>> * modify how to check non-zero po->vnet_hdr_sz;
>> * separate vnet_hdr_sz as a u8 field in struct packet_sock instead of 8-bit
>> in an int field.
>>
>> V2 -> V3:
>> * remove has_vnet_hdr field and use vnet_hdr_sz to indicate whether
>> there is a vnet header;
>> * refactor PACKET_VNET_HDR and PACKET_VNET_HDR_SZ sockopt to remove
>> redundant code.
>>
>> V1 -> V2:
>> * refactor the implementation of PACKET_VNET_HDR and PACKET_VNET_HDR_SZ
>> socketopts to get rid of redundate code;
>> * amend packet_rcv_vnet in af_packet.c to avoid extra function invocation.
>>
>>   include/uapi/linux/if_packet.h |  1 +
>>   net/packet/af_packet.c         | 93 ++++++++++++++++++++--------------
>>   net/packet/diag.c              |  2 +-
>>   net/packet/internal.h          |  2 +-
>>   4 files changed, 58 insertions(+), 40 deletions(-)
>>
>> @@ -2250,7 +2250,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>>   	__u32 ts_status;
>>   	bool is_drop_n_account = false;
>>   	unsigned int slot_id = 0;
>> -	bool do_vnet = false;
>> +	int vnet_hdr_sz = 0;
>>   
>>   	/* struct tpacket{2,3}_hdr is aligned to a multiple of TPACKET_ALIGNMENT.
>>   	 * We may add members to them until current aligned size without forcing
>> @@ -2308,10 +2308,9 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>>   		netoff = TPACKET_ALIGN(po->tp_hdrlen +
>>   				       (maclen < 16 ? 16 : maclen)) +
>>   				       po->tp_reserve;
>> -		if (packet_sock_flag(po, PACKET_SOCK_HAS_VNET_HDR)) {
>> -			netoff += sizeof(struct virtio_net_hdr);
>> -			do_vnet = true;
>> -		}
>> +		vnet_hdr_sz = READ_ONCE(po->vnet_hdr_sz);
>> +		if (vnet_hdr_sz)
>> +			netoff += vnet_hdr_sz;
>>   		macoff = netoff - maclen;
>>   	}
>>   	if (netoff > USHRT_MAX) {
>> @@ -2337,7 +2336,6 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>>   			snaplen = po->rx_ring.frame_size - macoff;
>>   			if ((int)snaplen < 0) {
>>   				snaplen = 0;
>> -				do_vnet = false;
>>   			}
>>   		}
>>   	} else if (unlikely(macoff + snaplen >
>> @@ -2351,7 +2349,6 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>>   		if (unlikely((int)snaplen < 0)) {
>>   			snaplen = 0;
>>   			macoff = GET_PBDQC_FROM_RB(&po->rx_ring)->max_frame_len;
>> -			do_vnet = false;
> here and in the block above the existing behavior must be maintained:
> vnet_hdr_sz must be reset to zero in these cases.


Thanks for pointing out. You're right and we will address it in the next 
version which will be sent out soon.


>>   		}
>>   	}
>>   	spin_lock(&sk->sk_receive_queue.lock);
>> @@ -2367,7 +2364,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>>   		__set_bit(slot_id, po->rx_ring.rx_owner_map);
>>   	}
>>   
>> -	if (do_vnet &&
>> +	if (vnet_hdr_sz &&
>>   	    virtio_net_hdr_from_skb(skb, h.raw + macoff -
>>   				    sizeof(struct virtio_net_hdr),
>>   				    vio_le(), true, 0)) {
