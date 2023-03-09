Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 995E36B208F
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 10:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjCIJsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 04:48:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjCIJrs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 04:47:48 -0500
Received: from out0-218.mail.aliyun.com (out0-218.mail.aliyun.com [140.205.0.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A37BEE3883
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 01:47:44 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047201;MF=amy.saq@antgroup.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---.RiPLfnw_1678355261;
Received: from 30.46.241.91(mailfrom:amy.saq@antgroup.com fp:SMTPD_---.RiPLfnw_1678355261)
          by smtp.aliyun-inc.com;
          Thu, 09 Mar 2023 17:47:42 +0800
Message-ID: <8cc18f9d-62e1-8902-36ca-9741aa0d148f@antgroup.com>
Date:   Thu, 09 Mar 2023 17:47:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH v3] net/packet: support mergeable feature of virtio
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>
Cc:     <davem@davemloft.net>, <jasowang@redhat.com>,
        "=?UTF-8?B?6LCI6Ym06ZSL?=" <henry.tjf@antgroup.com>
References: <1678168911-337042-1-git-send-email-amy.saq@antgroup.com>
 <64075d1f7ccfc_efd1020865@willemb.c.googlers.com.notmuch>
From:   "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
In-Reply-To: <64075d1f7ccfc_efd1020865@willemb.c.googlers.com.notmuch>
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


在 2023/3/7 下午11:49, Willem de Bruijn 写道:
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
>> With this mergeable feature enabled by virtio-user, packet sockets with
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
>> Besides, has_vnet_hdr field in struct packet_sock is removed since all
>> the information it provides is covered by vnet_hdr_sz field: a packet
>> socket has a vnet header if and only if its vnet_hdr_sz is not zero.
>>
>> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
>> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
>> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
>> ---
>>
>>   /*
>> @@ -2310,8 +2310,8 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>>   		netoff = TPACKET_ALIGN(po->tp_hdrlen +
>>   				       (maclen < 16 ? 16 : maclen)) +
>>   				       po->tp_reserve;
>> -		if (po->has_vnet_hdr) {
>> -			netoff += sizeof(struct virtio_net_hdr);
>> +		if (po->vnet_hdr_sz != 0) {
>> +			netoff += po->vnet_hdr_sz;
> no need to test != 0 here and elsewhere, just if (po->vnet_hdr_sz)
>
>>   			do_vnet = true;
>>   		}
>>   		macoff = netoff - maclen;
>> @@ -2552,16 +2552,27 @@ static int __packet_snd_vnet_parse(struct virtio_net_hdr *vnet_hdr, size_t len)
>>   }
>>   
>>   static int tpacket_fill_skb(struct packet_sock *po, struct sk_buff *skb,
>> @@ -2730,6 +2741,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>>   	int status = TP_STATUS_AVAILABLE;
>>   	int hlen, tlen, copylen = 0;
>>   	long timeo = 0;
>> +	int vnet_hdr_sz;
> since po->vnet_hdr_sz is touched in the hot path anyway, initialize
> it here and use the local var everywhere. Else this might race with
> updates too header length.
>>   
>>   	mutex_lock(&po->pg_vec_lock);
>>   
>> @@ -2780,7 +2792,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>>   	size_max = po->tx_ring.frame_size
>>   		- (po->tp_hdrlen - sizeof(struct sockaddr_ll));
>>   
>> -	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !po->has_vnet_hdr)
>> +	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && po->vnet_hdr_sz == 0)
>>   		size_max = dev->mtu + reserve + VLAN_HLEN;
>>   
>>   	reinit_completion(&po->skb_completion);
>> @@ -2809,10 +2821,11 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>>   		status = TP_STATUS_SEND_REQUEST;
>>   		hlen = LL_RESERVED_SPACE(dev);
>>   		tlen = dev->needed_tailroom;
>> -		if (po->has_vnet_hdr) {
>> +		if (po->vnet_hdr_sz != 0) {
>>   			vnet_hdr = data;
>> -			data += sizeof(*vnet_hdr);
>> -			tp_len -= sizeof(*vnet_hdr);
>> +			vnet_hdr_sz = po->vnet_hdr_sz;
> .. in particularly here, where vnet_hdr_sz is first checked and then copied
> to a local var in a separate step.
>
>> +			data += vnet_hdr_sz;
>> +			tp_len -= vnet_hdr_sz;
>>   			if (tp_len < 0 ||
>>   			    __packet_snd_vnet_parse(vnet_hdr, tp_len)) {
>>   				tp_len = -EINVAL;
>> @@ -2837,7 +2850,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>>   					  addr, hlen, copylen, &sockc);
>>   		if (likely(tp_len >= 0) &&
>>   		    tp_len > dev->mtu + reserve &&
>> -		    !po->has_vnet_hdr &&
>> +		    (po->vnet_hdr_sz == 0) &&
>>   		    !packet_extra_vlan_len_allowed(dev, skb))
>>   			tp_len = -EMSGSIZE;
>>   
>> @@ -2856,7 +2869,7 @@ static int tpacket_snd(struct packet_sock *po, struct msghdr *msg)
>>   			}
>>   		}
>>   
>> -		if (po->has_vnet_hdr) {
>> +		if (po->vnet_hdr_sz != 0) {
>>   			if (virtio_net_hdr_to_skb(skb, vnet_hdr, vio_le())) {
>>   				tp_len = -EINVAL;
>>   				goto tpacket_error;
>> @@ -2947,6 +2960,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>>   	int offset = 0;
>>   	struct packet_sock *po = pkt_sk(sk);
>>   	bool has_vnet_hdr = false;
> remove has_vnet_hdr, which is now superfluous.
>
>> +	int vnet_hdr_sz;
>>   	int hlen, tlen, linear;
>>   	int extra_len = 0;
>>   
>> @@ -2990,8 +3004,9 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>>   
>>   	if (sock->type == SOCK_RAW)
>>   		reserve = dev->hard_header_len;
>> -	if (po->has_vnet_hdr) {
>> -		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr);
>> +	if (po->vnet_hdr_sz != 0) {
>> +		vnet_hdr_sz = po->vnet_hdr_sz;
> same here
>
>> +		err = packet_snd_vnet_parse(msg, &len, &vnet_hdr, vnet_hdr_sz);
>>   		if (err)
>>   			goto out_unlock;
>>   		has_vnet_hdr = true;
>> @@ -3068,7 +3083,7 @@ static int packet_snd(struct socket *sock, struct msghdr *msg, size_t len)
>>   		err = virtio_net_hdr_to_skb(skb, &vnet_hdr, vio_le());
>>   		if (err)
>>   			goto out_free;
>> -		len += sizeof(vnet_hdr);
>> +		len += vnet_hdr_sz;
>>   		virtio_net_hdr_set_proto(skb, &vnet_hdr);
>>   	}
>>   
>> @@ -3451,11 +3466,11 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>>   
>>   	packet_rcv_try_clear_pressure(pkt_sk(sk));
>>   
>> -	if (pkt_sk(sk)->has_vnet_hdr) {
>> -		err = packet_rcv_vnet(msg, skb, &len);
>> +	if (pkt_sk(sk)->vnet_hdr_sz != 0) {
>> +		vnet_hdr_len = pkt_sk(sk)->vnet_hdr_sz;
> and here
>
>> +		err = packet_rcv_vnet(msg, skb, &len, vnet_hdr_len);
>>   		if (err)
>>   			goto out_free;
>> -		vnet_hdr_len = sizeof(struct virtio_net_hdr);
>>   	}
>>   
>>   	/* You lose any data beyond the buffer you gave. If it worries
>> @@ -3921,8 +3936,10 @@ static void packet_flush_mclist(struct sock *sk)
>>   		return 0;
>>   	}
>>   	case PACKET_VNET_HDR:
>> +	case PACKET_VNET_HDR_SZ:
>>   	{
>>   		int val;
>> +		int hdr_len = 0;
>>   
>>   		if (sock->type != SOCK_RAW)
>>   			return -EINVAL;
>> @@ -3931,11 +3948,21 @@ static void packet_flush_mclist(struct sock *sk)
>>   		if (copy_from_sockptr(&val, optval, sizeof(val)))
>>   			return -EFAULT;
>>   
>> +		if (optname == PACKET_VNET_HDR_SZ) {
>> +			if (val != sizeof(struct virtio_net_hdr) &&
>> +			    val != sizeof(struct virtio_net_hdr_mrg_rxbuf))
>> +				return -EINVAL;
>> +			hdr_len = val;
> val == 0 is also a a correct value
>
>> +		} else {
>> +			if (!!val)
>> +				hdr_len = sizeof(struct virtio_net_hdr);
> no need for !! when testing non-zero.
>
> and instead of initializing to zero on initial variable definition:
>
>      hdr_len = val ? sizeof(struct virtio_net_hdr) : 0;
>
>> +		}
>> +
>>   		lock_sock(sk);
>>   		if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
>>   			ret = -EBUSY;
>>   		} else {
>> -			po->has_vnet_hdr = !!val;
>> +			po->vnet_hdr_sz = hdr_len;
>>   			ret = 0;
>>   		}
>>   		release_sock(sk);
>> @@ -4068,7 +4095,10 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
>>   		val = po->origdev;
>>   		break;
>>   	case PACKET_VNET_HDR:
>> -		val = po->has_vnet_hdr;
>> +		val = !!po->vnet_hdr_sz;
>> +		break;
>> +	case PACKET_VNET_HDR_SZ:
>> +		val = po->vnet_hdr_sz;
>>   		break;
>>   	case PACKET_VERSION:
>>   		val = po->tp_version;
>> diff --git a/net/packet/diag.c b/net/packet/diag.c
>> index 07812ae..4e544da 100644
>> --- a/net/packet/diag.c
>> +++ b/net/packet/diag.c
>> @@ -27,7 +27,7 @@ static int pdiag_put_info(const struct packet_sock *po, struct sk_buff *nlskb)
>>   		pinfo.pdi_flags |= PDI_AUXDATA;
>>   	if (po->origdev)
>>   		pinfo.pdi_flags |= PDI_ORIGDEV;
>> -	if (po->has_vnet_hdr)
>> +	if (po->vnet_hdr_sz != 0)
>>   		pinfo.pdi_flags |= PDI_VNETHDR;
>>   	if (po->tp_loss)
>>   		pinfo.pdi_flags |= PDI_LOSS;
>> diff --git a/net/packet/internal.h b/net/packet/internal.h
>> index 48af35b..9b52d93 100644
>> --- a/net/packet/internal.h
>> +++ b/net/packet/internal.h
>> @@ -119,9 +119,9 @@ struct packet_sock {
>>   	unsigned int		running;	/* bind_lock must be held */
>>   	unsigned int		auxdata:1,	/* writer must hold sock lock */
>>   				origdev:1,
>> -				has_vnet_hdr:1,
>>   				tp_loss:1,
>> -				tp_tx_has_off:1;
>> +				tp_tx_has_off:1,
>> +				vnet_hdr_sz:8;
> just a separate u8 variable , rather than 8 bits in a u32.
>
>>   	int			pressure;
>>   	int			ifindex;	/* bound device		*/
>>   	__be16			num;
>> -- 
>> 1.8.3.1
>>

Thanks for the comments! We will soon address these comments in the next 
version of this patch.

Before we send out the next version, we just wonder whether there is any 
other advice on this version of patch from Willem or Michael and we may 
address them as well in the next version. We really appreciate all the 
comments you provided and may provide in the future.



