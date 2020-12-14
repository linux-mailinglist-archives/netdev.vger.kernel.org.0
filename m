Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B6BF2D9207
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 04:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438287AbgLNDP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 22:15:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60587 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726226AbgLNDPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 22:15:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607915630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+9sQ3ROLDoUM3Q2YuCeuJzaGmgvYQ+sS+5UKJ5fqarw=;
        b=CbzPk/9c1cg3VVsXYygRvOwIlZByD3cqoHjp11p5JIZGlqRq6Jv9EsfOBRHMfgoZs7Vxlc
        udJ19Vk3dtRWIVEWpSkWtyWTQcVZefE8acgv6QXIetMLptBFf6ykE22CT5G4WzDuI3IT+V
        hLP4Vt8y/7KWMcLbS8HE+B/MLaR0Q5I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-5YrP6FsXNuuS7gxrQe646A-1; Sun, 13 Dec 2020 22:13:46 -0500
X-MC-Unique: 5YrP6FsXNuuS7gxrQe646A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50DBB10054FF;
        Mon, 14 Dec 2020 03:13:45 +0000 (UTC)
Received: from [10.72.13.213] (ovpn-13-213.pek2.redhat.com [10.72.13.213])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 13F641002382;
        Mon, 14 Dec 2020 03:13:38 +0000 (UTC)
Subject: Re: [PATCH net] vhost_net: fix high cpu load when sendmsg fails
To:     wangyunjian <wangyunjian@huawei.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
References: <1607514504-20956-1-git-send-email-wangyunjian@huawei.com>
 <20201209074832-mutt-send-email-mst@kernel.org>
 <34EFBCA9F01B0748BEB6B629CE643AE60DB61ADF@DGGEMM533-MBX.china.huawei.com>
 <f95f061c-dcac-9d56-94a0-50ef683946cd@redhat.com>
 <34EFBCA9F01B0748BEB6B629CE643AE60DB65468@DGGEMM533-MBX.china.huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <c8fedd8b-8a09-8994-2ad4-133c9e6dc334@redhat.com>
Date:   Mon, 14 Dec 2020 11:13:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <34EFBCA9F01B0748BEB6B629CE643AE60DB65468@DGGEMM533-MBX.china.huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/11 下午3:37, wangyunjian wrote:
>> -----Original Message-----
>> From: Jason Wang [mailto:jasowang@redhat.com]
>> Sent: Friday, December 11, 2020 10:53 AM
>> To: wangyunjian <wangyunjian@huawei.com>; Michael S. Tsirkin
>> <mst@redhat.com>
>> Cc: virtualization@lists.linux-foundation.org; netdev@vger.kernel.org; Lilijun
>> (Jerry) <jerry.lilijun@huawei.com>; chenchanghu <chenchanghu@huawei.com>;
>> xudingke <xudingke@huawei.com>
>> Subject: Re: [PATCH net] vhost_net: fix high cpu load when sendmsg fails
>>
>>
>> On 2020/12/9 下午9:27, wangyunjian wrote:
>>>> -----Original Message-----
>>>> From: Michael S. Tsirkin [mailto:mst@redhat.com]
>>>> Sent: Wednesday, December 9, 2020 8:50 PM
>>>> To: wangyunjian <wangyunjian@huawei.com>
>>>> Cc: jasowang@redhat.com; virtualization@lists.linux-foundation.org;
>>>> netdev@vger.kernel.org; Lilijun (Jerry) <jerry.lilijun@huawei.com>;
>>>> chenchanghu <chenchanghu@huawei.com>; xudingke
>> <xudingke@huawei.com>
>>>> Subject: Re: [PATCH net] vhost_net: fix high cpu load when sendmsg
>>>> fails
>>>>
>>>> On Wed, Dec 09, 2020 at 07:48:24PM +0800, wangyunjian wrote:
>>>>> From: Yunjian Wang <wangyunjian@huawei.com>
>>>>>
>>>>> Currently we break the loop and wake up the vhost_worker when
>>>>> sendmsg fails. When the worker wakes up again, we'll meet the same
>>>>> error. This will cause high CPU load. To fix this issue, we can skip
>>>>> this description by ignoring the error.
>>>>>
>>>>> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
>>>>> ---
>>>>>    drivers/vhost/net.c | 24 +++++-------------------
>>>>>    1 file changed, 5 insertions(+), 19 deletions(-)
>>>>>
>>>>> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c index
>>>>> 531a00d703cd..ac950b1120f5 100644
>>>>> --- a/drivers/vhost/net.c
>>>>> +++ b/drivers/vhost/net.c
>>>>> @@ -829,14 +829,8 @@ static void handle_tx_copy(struct vhost_net
>>>>> *net, struct socket *sock)
>>>>>
>>>>>    		/* TODO: Check specific error and bomb out unless ENOBUFS?
>> */
>>>>>    		err = sock->ops->sendmsg(sock, &msg, len);
>>>>> -		if (unlikely(err < 0)) {
>>>>> -			vhost_discard_vq_desc(vq, 1);
>>>>> -			vhost_net_enable_vq(net, vq);
>>>>> -			break;
>>>>> -		}
>>>>> -		if (err != len)
>>>>> -			pr_debug("Truncated TX packet: len %d != %zd\n",
>>>>> -				 err, len);
>>>>> +		if (unlikely(err < 0 || err != len))
>>>>> +			vq_err(vq, "Fail to sending packets err : %d, len : %zd\n",
>> err,
>>>>> +len);
>>>>>    done:
>>>>>    		vq->heads[nvq->done_idx].id = cpu_to_vhost32(vq, head);
>>>>>    		vq->heads[nvq->done_idx].len = 0;
>>>> One of the reasons for sendmsg to fail is ENOBUFS.
>>>> In that case for sure we don't want to drop packet.
>>> Now the function tap_sendmsg()/tun_sendmsg() don't return ENOBUFS.
>>
>> I think not, it can happen if we exceeds sndbuf. E.g see tun_alloc_skb().
> This patch 'net: add alloc_skb_with_frags() helper' modifys the return value
> of sock_alloc_send_pskb() from -ENOBUFS to -EAGAIN when we exceeds sndbuf.
> So the return value of tun_alloc_skb has been changed.


Ok.


>
> We don't drop packet if the reasons for sendmsg to fail is EAGAIN.
> How about this?


It should work.

Btw, the patch doesn't add the head to the used ring. This may confuse 
the driver.

Thanks


>
> Thanks
>
>> Thanks
>>
>>
>>>> There could be other transient errors.
>>>> Which error did you encounter, specifically?
>>> Currently a guest vm send a skb which length is more than 64k.
>>> If virtio hdr is wrong, the problem will also be triggered.
>>>
>>> Thanks
>>>
>>>>> @@ -925,19 +919,11 @@ static void handle_tx_zerocopy(struct
>>>>> vhost_net *net, struct socket *sock)
>>>>>
>>>>>    		/* TODO: Check specific error and bomb out unless ENOBUFS?
>> */
>>>>>    		err = sock->ops->sendmsg(sock, &msg, len);
>>>>> -		if (unlikely(err < 0)) {
>>>>> -			if (zcopy_used) {
>>>>> +		if (unlikely(err < 0 || err != len)) {
>>>>> +			if (zcopy_used && err < 0)
>>>>>    				vhost_net_ubuf_put(ubufs);
>>>>> -				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
>>>>> -					% UIO_MAXIOV;
>>>>> -			}
>>>>> -			vhost_discard_vq_desc(vq, 1);
>>>>> -			vhost_net_enable_vq(net, vq);
>>>>> -			break;
>>>>> +			vq_err(vq, "Fail to sending packets err : %d, len : %zd\n",
>> err,
>>>>> +len);
>>>>>    		}
>>>>> -		if (err != len)
>>>>> -			pr_debug("Truncated TX packet: "
>>>>> -				 " len %d != %zd\n", err, len);
>>>>>    		if (!zcopy_used)
>>>>>    			vhost_add_used_and_signal(&net->dev, vq, head, 0);
>>>>>    		else
>>>>> --
>>>>> 2.23.0

