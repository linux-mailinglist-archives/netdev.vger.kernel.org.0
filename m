Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97E876A525B
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 05:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjB1Eik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 23:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjB1Eij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 23:38:39 -0500
Received: from out0-206.mail.aliyun.com (out0-206.mail.aliyun.com [140.205.0.206])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675A76EAA
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 20:38:36 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018047193;MF=amy.saq@antgroup.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---.RYtNlKY_1677559113;
Received: from 30.46.243.2(mailfrom:amy.saq@antgroup.com fp:SMTPD_---.RYtNlKY_1677559113)
          by smtp.aliyun-inc.com;
          Tue, 28 Feb 2023 12:38:33 +0800
Message-ID: <3eb8394c-3243-daef-652b-365b3db5d630@antgroup.com>
Date:   Tue, 28 Feb 2023 12:38:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH v2] net/packet: support mergeable feautre of virtio
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     <mst@redhat.com>, <davem@davemloft.net>, <jasowang@redhat.com>,
        "=?UTF-8?B?6LCI6Ym06ZSL?=" <henry.tjf@antgroup.com>
References: <1677497625-351024-1-git-send-email-amy.saq@antgroup.com>
 <63fcdaf7e3e9d_1684422084b@willemb.c.googlers.com.notmuch>
 <4fee48b3-fac0-9de6-1edd-b3f3b246dab0@antgroup.com>
 <63fd83b98d020_18126f2089b@willemb.c.googlers.com.notmuch>
From:   "=?UTF-8?B?5rKI5a6J55CqKOWHm+eOpSk=?=" <amy.saq@antgroup.com>
In-Reply-To: <63fd83b98d020_18126f2089b@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/2/28 下午12:31, Willem de Bruijn 写道:
> 沈安琪(凛玥) wrote:
>> 在 2023/2/28 上午12:31, Willem de Bruijn 写道:
>>> 沈安琪(凛玥) wrote:
>>>> From: Jianfeng Tan <henry.tjf@antgroup.com>
>>>>
>>>> Packet sockets, like tap, can be used as the backend for kernel vhost.
>>>> In packet sockets, virtio net header size is currently hardcoded to be
>>>> the size of struct virtio_net_hdr, which is 10 bytes; however, it is not
>>>> always the case: some virtio features, such as mrg_rxbuf, need virtio
>>>> net header to be 12-byte long.
>>>>
>>>> Mergeable buffers, as a virtio feature, is worthy to support: packets
>>>> that larger than one-mbuf size will be dropped in vhost worker's
>>>> handle_rx if mrg_rxbuf feature is not used, but large packets
>>>> cannot be avoided and increasing mbuf's size is not economical.
>>>>
>>>> With this virtio feature enabled, packet sockets with hardcoded 10-byte
>>>> virtio net header will parse mac head incorrectly in packet_snd by taking
>>>> the last two bytes of virtio net header as part of mac header as well.
>>>> This incorrect mac header parsing will cause packet be dropped due to
>>>> invalid ether head checking in later under-layer device packet receiving.
>>>>
>>>> By adding extra field vnet_hdr_sz with utilizing holes in struct
>>>> packet_sock to record current using virtio net header size and supporting
>>>> extra sockopt PACKET_VNET_HDR_SZ to set specified vnet_hdr_sz, packet
>>>> sockets can know the exact length of virtio net header that virtio user
>>>> gives.
>>>> In packet_snd, tpacket_snd and packet_recvmsg, instead of using hardcode
>>>> virtio net header size, it can get the exact vnet_hdr_sz from corresponding
>>>> packet_sock, and parse mac header correctly based on this information to
>>>> avoid the packets being mistakenly dropped.
>>>>
>>>> Signed-off-by: Jianfeng Tan <henry.tjf@antgroup.com>
>>>> Co-developed-by: Anqi Shen <amy.saq@antgroup.com>
>>>> Signed-off-by: Anqi Shen <amy.saq@antgroup.com>
>>> net-next is closed
>>
>> May we still send the revision of this patch and/or keep discussing
>> during the merge window? We understand that new features will not be
>> took until the merge window finishes.
> That is certainly fine. If patches are not expected to be merged,
> perhaps label them RFC to avoid confusion.


Got it! Thanks for quick reply.


>
>>
>>>> @@ -2311,7 +2312,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
>>>>    				       (maclen < 16 ? 16 : maclen)) +
>>>>    				       po->tp_reserve;
>>>>    		if (po->has_vnet_hdr) {
>>>> -			netoff += sizeof(struct virtio_net_hdr);
>>>> +			netoff += po->vnet_hdr_sz;
>>>>    			do_vnet = true;
>>>>    		}
>>>>    		macoff = netoff - maclen;
>>>> @@ -2552,16 +2553,23 @@ static int __packet_snd_vnet_parse(struct virtio_net_hdr *vnet_hdr, size_t len)
>>>>    }
>>>>    
>>>>    static int packet_snd_vnet_parse(struct msghdr *msg, size_t *len,
>>>> -				 struct virtio_net_hdr *vnet_hdr)
>>>> +				 struct virtio_net_hdr *vnet_hdr, int vnet_hdr_sz)
>>>>    {
>>>> -	if (*len < sizeof(*vnet_hdr))
>>>> +	int ret;
>>>> +
>>>> +	if (*len < vnet_hdr_sz)
>>>>    		return -EINVAL;
>>>> -	*len -= sizeof(*vnet_hdr);
>>>> +	*len -= vnet_hdr_sz;
>>>>    
>>>>    	if (!copy_from_iter_full(vnet_hdr, sizeof(*vnet_hdr), &msg->msg_iter))
>>>>    		return -EFAULT;
>>>>    
>>>> -	return __packet_snd_vnet_parse(vnet_hdr, *len);
>>>> +	ret = __packet_snd_vnet_parse(vnet_hdr, *len);
>>>> +
>>>> +	/* move iter to point to the start of mac header */
>>>> +	if (ret == 0)
>>>> +		iov_iter_advance(&msg->msg_iter, vnet_hdr_sz - sizeof(struct virtio_net_hdr));
>>>> +	return ret;
>>> Let's make the error path the exception
>>>
>>>           if (ret)
>>>                   return ret;
>>>
>>> And maybe avoid calling iov_iter_advance if vnet_hdr_sz == sizeof(*vnet_hdr)
>>>
>>>>    	case PACKET_VNET_HDR:
>>>> +	case PACKET_VNET_HDR_SZ:
>>>>    	{
>>>>    		int val;
>>>> +		int hdr_len = 0;
>>>>    
>>>>    		if (sock->type != SOCK_RAW)
>>>>    			return -EINVAL;
>>>> @@ -3931,11 +3945,23 @@ static void packet_flush_mclist(struct sock *sk)
>>>>    		if (copy_from_sockptr(&val, optval, sizeof(val)))
>>>>    			return -EFAULT;
>>>>    
>>>> +		if (optname == PACKET_VNET_HDR_SZ) {
>>>> +			if (val != sizeof(struct virtio_net_hdr) &&
>>>> +			    val != sizeof(struct virtio_net_hdr_mrg_rxbuf))
>>>> +				return -EINVAL;
>>>> +			hdr_len = val;
>>>> +		}
>>>> +
>>>       } else {
>>>               hdr_len = sizeof(struct virtio_net_hdr);
>>>       }
>>>
>>>>    		lock_sock(sk);
>>>>    		if (po->rx_ring.pg_vec || po->tx_ring.pg_vec) {
>>>>    			ret = -EBUSY;
>>>>    		} else {
>>>> -			po->has_vnet_hdr = !!val;
>>>> +			if (optname == PACKET_VNET_HDR) {
>>>> +				po->has_vnet_hdr = !!val;
>>>> +				if (po->has_vnet_hdr)
>>>> +					hdr_len = sizeof(struct virtio_net_hdr);
>>>> +			}
>>>> +			po->vnet_hdr_sz = hdr_len;
>>> then this is not needed
>>>>    			ret = 0;
>>>>    		}
>>>>    		release_sock(sk);
>>>> @@ -4070,6 +4096,9 @@ static int packet_getsockopt(struct socket *sock, int level, int optname,
>>>>    	case PACKET_VNET_HDR:
>>>>    		val = po->has_vnet_hdr;
>>>>    		break;
>>>> +	case PACKET_VNET_HDR_SZ:
>>>> +		val = po->vnet_hdr_sz;
>>>> +		break;
>>>>    	case PACKET_VERSION:
>>>>    		val = po->tp_version;
>>>>    		break;
>>>> diff --git a/net/packet/internal.h b/net/packet/internal.h
>>>> index 48af35b..e27b47d 100644
>>>> --- a/net/packet/internal.h
>>>> +++ b/net/packet/internal.h
>>>> @@ -121,7 +121,8 @@ struct packet_sock {
>>>>    				origdev:1,
>>>>    				has_vnet_hdr:1,
>>>>    				tp_loss:1,
>>>> -				tp_tx_has_off:1;
>>>> +				tp_tx_has_off:1,
>>>> +				vnet_hdr_sz:8;	/* vnet header size should use */
>>> has_vnet_hdr is no longer needed when adding vnet_hdr_sz. removing that simplifies the code
>>
>> So we are going to indicate whether the packet socket has a vnet header
>> based on vnet_hdr_sz it is set to, right?
> That's the idea. That has all state. The boolean doesn't add any useful info.


Good point. We will refactor the places that uses has_vnet_hdr.


