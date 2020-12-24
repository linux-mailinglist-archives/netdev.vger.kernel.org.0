Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83432E2483
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 07:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgLXF5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 00:57:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40546 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725933AbgLXF5w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 00:57:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608789385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tWPr/JJTfRTm5p5WCHDxnGzwlW39vVczjU0f0pHL4FM=;
        b=iYLFBBbQeH02lfe2I3dGvlpVL8FzWlnl7BwhHj5xKzspFDneMMrlKGNAsks/IA50luLncE
        X4t37HgPd3esbf+k/Zhk+ygeZANy+FnD+nTdZZ/3IpkYR52PBSBieA5MkliW8NSyAXF6r1
        UgDCbCrpX/dgseZCXgpUIBk3RuYh1LE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-583-TQAg_WrzOcWzQS4VZyJ-SQ-1; Thu, 24 Dec 2020 00:56:21 -0500
X-MC-Unique: TQAg_WrzOcWzQS4VZyJ-SQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 88F07107ACE8;
        Thu, 24 Dec 2020 05:56:19 +0000 (UTC)
Received: from [10.72.13.109] (ovpn-13-109.pek2.redhat.com [10.72.13.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1D5561F056;
        Thu, 24 Dec 2020 05:56:07 +0000 (UTC)
Subject: Re: [PATCH net v4 2/2] vhost_net: fix tx queue stuck when sendmsg
 fails
To:     wangyunjian <wangyunjian@huawei.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "willemdebruijn.kernel@gmail.com" <willemdebruijn.kernel@gmail.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
References: <1608776746-4040-1-git-send-email-wangyunjian@huawei.com>
 <c854850b-43ab-c98d-a4d8-36ad7cd6364c@redhat.com>
 <34EFBCA9F01B0748BEB6B629CE643AE60DB8ED23@DGGEMM533-MBX.china.huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <823a1558-70fb-386d-fd28-d0c9bdbe9dac@redhat.com>
Date:   Thu, 24 Dec 2020 13:56:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <34EFBCA9F01B0748BEB6B629CE643AE60DB8ED23@DGGEMM533-MBX.china.huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/24 下午12:37, wangyunjian wrote:
>> -----Original Message-----
>> From: Jason Wang [mailto:jasowang@redhat.com]
>> Sent: Thursday, December 24, 2020 11:10 AM
>> To: wangyunjian <wangyunjian@huawei.com>; netdev@vger.kernel.org;
>> mst@redhat.com; willemdebruijn.kernel@gmail.com
>> Cc: virtualization@lists.linux-foundation.org; Lilijun (Jerry)
>> <jerry.lilijun@huawei.com>; chenchanghu <chenchanghu@huawei.com>;
>> xudingke <xudingke@huawei.com>; huangbin (J)
>> <brian.huangbin@huawei.com>
>> Subject: Re: [PATCH net v4 2/2] vhost_net: fix tx queue stuck when sendmsg
>> fails
>>
>>
>> On 2020/12/24 上午10:25, wangyunjian wrote:
>>> From: Yunjian Wang <wangyunjian@huawei.com>
>>>
>>> Currently the driver doesn't drop a packet which can't be sent by tun
>>> (e.g bad packet). In this case, the driver will always process the
>>> same packet lead to the tx queue stuck.
>>>
>>> To fix this issue:
>>> 1. in the case of persistent failure (e.g bad packet), the driver can
>>> skip this descriptor by ignoring the error.
>>> 2. in the case of transient failure (e.g -EAGAIN and -ENOMEM), the
>>> driver schedules the worker to try again.
>>
>> I might be wrong but looking at alloc_skb_with_frags(), it returns -ENOBUFS
>> actually:
>>
>>       *errcode = -ENOBUFS;
>>       skb = alloc_skb(header_len, gfp_mask);
>>       if (!skb)
>>           return NULL;
> Yes, but the sock_alloc_send_pskb() returns - EAGAIN when no sndbuf space.
> So there is need to check return value which is -EAGAIN or -ENOMEM or - EAGAIN?
>
> struct sk_buff *sock_alloc_send_pskb()
> {
> ...
> 	for (;;) {
> ...
> 		sk_set_bit(SOCKWQ_ASYNC_NOSPACE, sk);
> 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
> 		err = -EAGAIN;
> 		if (!timeo)
> 			goto failure;
> ...
> 	}
> 	skb = alloc_skb_with_frags(header_len, data_len, max_page_order,
> 				   errcode, sk->sk_allocation);
> 	if (skb)
> 		skb_set_owner_w(skb, sk);
> 	return skb;
> ...
> 	*errcode = err;
> 	return NULL;
> }


-EAGAIN and -ENOBFS are fine. But I don't see how -ENOMEM can be returned.

Thanks


>> Thanks
>>
>>
>>> Fixes: 3a4d5c94e959 ("vhost_net: a kernel-level virtio server")
>>> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
>>> ---
>>>    drivers/vhost/net.c | 16 ++++++++--------
>>>    1 file changed, 8 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c index
>>> c8784dfafdd7..e76245daa7f6 100644
>>> --- a/drivers/vhost/net.c
>>> +++ b/drivers/vhost/net.c
>>> @@ -827,14 +827,13 @@ static void handle_tx_copy(struct vhost_net *net,
>> struct socket *sock)
>>>    				msg.msg_flags &= ~MSG_MORE;
>>>    		}
>>>
>>> -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
>>>    		err = sock->ops->sendmsg(sock, &msg, len);
>>> -		if (unlikely(err < 0)) {
>>> +		if (unlikely(err == -EAGAIN || err == -ENOMEM)) {
>>>    			vhost_discard_vq_desc(vq, 1);
>>>    			vhost_net_enable_vq(net, vq);
>>>    			break;
>>>    		}
>>> -		if (err != len)
>>> +		if (err >= 0 && err != len)
>>>    			pr_debug("Truncated TX packet: len %d != %zd\n",
>>>    				 err, len);
>>>    done:
>>> @@ -922,7 +921,6 @@ static void handle_tx_zerocopy(struct vhost_net
>> *net, struct socket *sock)
>>>    			msg.msg_flags &= ~MSG_MORE;
>>>    		}
>>>
>>> -		/* TODO: Check specific error and bomb out unless ENOBUFS? */
>>>    		err = sock->ops->sendmsg(sock, &msg, len);
>>>    		if (unlikely(err < 0)) {
>>>    			if (zcopy_used) {
>>> @@ -931,11 +929,13 @@ static void handle_tx_zerocopy(struct vhost_net
>> *net, struct socket *sock)
>>>    				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
>>>    					% UIO_MAXIOV;
>>>    			}
>>> -			vhost_discard_vq_desc(vq, 1);
>>> -			vhost_net_enable_vq(net, vq);
>>> -			break;
>>> +			if (err == -EAGAIN || err == -ENOMEM) {
>>> +				vhost_discard_vq_desc(vq, 1);
>>> +				vhost_net_enable_vq(net, vq);
>>> +				break;
>>> +			}
>>>    		}
>>> -		if (err != len)
>>> +		if (err >= 0 && err != len)
>>>    			pr_debug("Truncated TX packet: "
>>>    				 " len %d != %zd\n", err, len);
>>>    		if (!zcopy_used)

