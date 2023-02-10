Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D169691772
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 05:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230409AbjBJEBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 23:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230324AbjBJEBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 23:01:10 -0500
Received: from out0-221.mail.aliyun.com (out0-221.mail.aliyun.com [140.205.0.221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CB0721CA
        for <netdev@vger.kernel.org>; Thu,  9 Feb 2023 20:01:06 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R561e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047193;MF=amy.saq@antgroup.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---.RHcbDfz_1676001663;
Received: from 30.46.243.134(mailfrom:amy.saq@antgroup.com fp:SMTPD_---.RHcbDfz_1676001663)
          by smtp.aliyun-inc.com;
          Fri, 10 Feb 2023 12:01:04 +0800
Message-ID: <858f8db1-c107-1ac5-bcbc-84e0d36c981d@antgroup.com>
Date:   Fri, 10 Feb 2023 12:01:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH 2/2] net/packet: send and receive pkt with given
 vnet_hdr_sz
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     <netdev@vger.kernel.org>, <willemdebruijn.kernel@gmail.com>,
        <davem@davemloft.net>, <jasowang@redhat.com>,
        "=?UTF-8?B?6LCI6Ym06ZSL?=" <henry.tjf@antgroup.com>
References: <1675946595-103034-1-git-send-email-amy.saq@antgroup.com>
 <1675946595-103034-3-git-send-email-amy.saq@antgroup.com>
 <20230209080612-mutt-send-email-mst@kernel.org>
From:   "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
In-Reply-To: <20230209080612-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/2/9 下午9:07, Michael S. Tsirkin 写道:
> On Thu, Feb 09, 2023 at 08:43:15PM +0800, 沈安琪(凛玥) wrote:
>> From: "Jianfeng Tan" <henry.tjf@antgroup.com>
>>
>> When raw socket is used as the backend for kernel vhost, currently it
>> will regard the virtio net header as 10-byte, which is not always the
>> case since some virtio features need virtio net header other than
>> 10-byte, such as mrg_rxbuf and VERSION_1 that both need 12-byte virtio
>> net header.
>>
>> Instead of hardcoding virtio net header length to 10 bytes, tpacket_snd,
>> tpacket_rcv, packet_snd and packet_recvmsg now get the virtio net header
>> size that is recorded in packet_sock to indicate the exact virtio net
>> header size that virtio user actually prepares in the packets. By doing
>> so, it can fix the issue of incorrect mac header parsing when these
>> virtio features that need virtio net header other than 10-byte are
>> enable.
>>
>> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
>> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
>> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
> Does it handle VERSION_1 though? That one is also LE.
> Would it be better to pass a features bitmap instead?


Thanks for quick reply!

I am a little confused abot what "LE" presents here?

For passing a features bitmap to af_packet here, our consideration is 
whether it will be too complicated for af_packet to understand the 
virtio features bitmap in order to get the vnet header size. For now, 
all the virtio features stuff is handled by vhost worker and af_packet 
actually does not need to know much about virtio features. Would it be 
better if we keep the virtio feature stuff in user-level and let 
user-level tell af_packet how much space it should reserve?

>
>
>> ---
>>   net/packet/af_packet.c | 48 +++++++++++++++++++++++++++++++++---------------
>>   1 file changed, 33 insertions(+), 15 deletions(-)
>>
>> diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
>> index ab37baf..4f49939 100644
>> --- a/net/packet/af_packet.c
>> +++ b/net/packet/af_packet.c
>> @@ -2092,18 +2092,25 @@ static unsigned int run_filter(struct sk_buff *skb,
>>   }
>>   
>>   static int packet_rcv_vnet(struct msghdr *msg, const struct sk_buff *skb,
>> -			   size_t *len)
>> +			   size_t *len, int vnet_hdr_sz)
>>   {
>>   	struct virtio_net_hdr vnet_hdr;
>> +	int ret;
>>   
>> -	if (*len < sizeof(vnet_hdr))
>> +	if (*len < vnet_hdr_sz)
>>   		return -EINVAL;
>> -	*len -= sizeof(vnet_hdr);
>> +	*len -= vnet_hdr_sz;
>>   
>>   	if (virtio_net_hdr_from_skb(skb, &vnet_hdr, vio_le(), true, 0))
>>   		return -EINVAL;
>>   
>> -	return memcpy_to_msg(msg, (void *)&vnet_hdr, sizeof(vnet_hdr));
>> +	ret = memcpy_to_msg(msg, (void *)&vnet_hdr, sizeof(vnet_hdr));
>> +
>> +	/* reserve space for extra info in vnet_hdr if needed */
>> +	if (ret == 0)
>> +		iov_iter_advance(&msg->msg_iter, vnet_hdr_sz - sizeof(vnet_hdr));
>> +
>> +	return ret;
>>   }
>>   
>>   /*
>> @@ -2311,7 +2318,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>>   				       (maclen < 16 ? 16 : maclen)) +
>>   				       po->tp_reserve;
>>   		if (po->has_vnet_hdr) {
>> -			netoff += sizeof(struct virtio_net_hdr);
>> +			netoff += po->vnet_hdr_sz;
>>   			do_vnet = true;
>>   		}
>>   		macoff = netoff - maclen;
>> @@ -2552,16 +2559,23 @@ static int __packet_snd_vnet_parse(struct virtio_net_hdr *vnet_hdr, size_t len)
>>   }
>>   
>>   static int packet_snd_vnet_parse(struct msghdr *msg, size_t *len,
>> -				 struct virtio_net_hdr *vnet_hdr)
>> +				 struct virtio_net_hdr *vnet_hdr, int vnet_hdr_sz)
>>   {
>> -	if (*len < sizeof(*vnet_hdr))
>> +	int ret;
>> +
>> +	if (*len < vnet_hdr_sz)
>>   		return -EINVAL;
>> -	*len -= sizeof(*vnet_hdr);
>> +	*len -= vnet_hdr_sz;
>>   
>>   	if (!copy_from_iter_full(vnet_hdr, sizeof(*vnet_hdr), &msg->msg_iter))
>>   		return -EFAULT;
>>   
>> -	return __packet_snd_vnet_parse(vnet_hdr, *len);
>> +	ret = __packet_snd_vnet_parse(vnet_hdr, *len);
>> +
>> +	/* move iter to point to the start of mac header */
>> +	if (ret == 0)
>> +		iov_iter_advance(&msg->msg_iter, vnet_hdr_sz - sizeof(struct virtio_net_hdr));
>> +	return ret;
>>   }
>>   
>>   static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
>> @@ -2730,6 +2744,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>>   	int status = TP_STATUS_AVAILABLE;
>>   	int hlen, tlen, copylen = 0;
>>   	long timeo = 0;
>> +	int vnet_hdr_sz;
>>   
>>   	mutex_lock(&po->pg_vec_lock);
>>   
>> @@ -2811,8 +2826,9 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>>   		tlen = dev->needed_tailroom;
>>   		if (po->has_vnet_hdr) {
>>   			vnet_hdr = data;
>> -			data += sizeof(*vnet_hdr);
>> -			tp_len -= sizeof(*vnet_hdr);
>> +			vnet_hdr_sz = po->vnet_hdr_sz;
>> +			data += vnet_hdr_sz;
>> +			tp_len -= vnet_hdr_sz;
>>   			if (tp_len < 0 ||
>>   			    __packet_snd_vnet_parse(vnet_hdr, tp_len)) {
>>   				tp_len = -EINVAL;
>> @@ -2947,6 +2963,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>>   	int offset = 0;
>>   	struct packet_sock *po = pkt_sk(sk);
>>   	bool has_vnet_hdr = false;
>> +	int vnet_hdr_sz;
>>   	int hlen, tlen, linear;
>>   	int extra_len = 0;
>>   
>> @@ -2991,7 +3008,8 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>>   	if (sock->type == SOCK_RAW)
>>   		reserve = dev->hard_header_len;
>>   	if (po->has_vnet_hdr) {
>> -		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr);
>> +		vnet_hdr_sz = po->vnet_hdr_sz;
>> +		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr, vnet_hdr_sz);
>>   		if (err)
>>   			goto out_unlock;
>>   		has_vnet_hdr = true;
>> @@ -3068,7 +3086,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>>   		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
>>   		if (err)
>>   			goto out_free;
>> -		len += sizeof(vnet_hdr);
>> +		len += vnet_hdr_sz;
>>   		virtio_net_hdr_set_proto(skb, &vnet_hdr);
>>   	}
>>   
>> @@ -3452,10 +3470,10 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>>   	packet_rcv_try_clear_pressure(pkt_sk(sk));
>>   
>>   	if (pkt_sk(sk)->has_vnet_hdr) {
>> -		err = packet_rcv_vnet(msg, skb, &len);
>> +		vnet_hdr_len = pkt_sk(sk)->vnet_hdr_sz;
>> +		err = packet_rcv_vnet(msg, skb, &len, vnet_hdr_len);
>>   		if (err)
>>   			goto out_free;
>> -		vnet_hdr_len = sizeof(struct virtio_net_hdr);
>>   	}
>>   
>>   	/* You lose any data beyond the buffer you gave. If it worries
>> -- 
>> 1.8.3.1
