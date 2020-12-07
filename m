Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747A72D0997
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 04:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbgLGDzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 22:55:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41708 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726482AbgLGDzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 22:55:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607313265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q2mgpR5hlh3Amjrpkze++o1dwsDrV0P0MuQh4sXa0kQ=;
        b=HyRhj/i1BSGfisIKweSRDGfOpdBY9YONbXeJ/Zaci3G9DhHKce06Pm37mAFJ0RYdMwV4ru
        zcpXStw+vbj5XLVVaHqc2rkBq7tbWFHQciWSiPpRYrqKhiJ0FauCnA9NSLU19pb9fIqAbM
        NjxB4V7E1BGzSje+LuUnNjfzSd/DrlU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-smFEc9h9OFOYI4RTQfovkg-1; Sun, 06 Dec 2020 22:54:21 -0500
X-MC-Unique: smFEc9h9OFOYI4RTQfovkg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1423B107ACE4;
        Mon,  7 Dec 2020 03:54:20 +0000 (UTC)
Received: from [10.72.13.171] (ovpn-13-171.pek2.redhat.com [10.72.13.171])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06B0B10016DB;
        Mon,  7 Dec 2020 03:54:13 +0000 (UTC)
Subject: Re: [PATCH net-next] tun: fix ubuf refcount incorrectly on error path
To:     wangyunjian <wangyunjian@huawei.com>,
        "mst@redhat.com" <mst@redhat.com>
Cc:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        xudingke <xudingke@huawei.com>
References: <1606982459-41752-1-git-send-email-wangyunjian@huawei.com>
 <094f1828-9a73-033e-b1ca-43b73588d22b@redhat.com>
 <34EFBCA9F01B0748BEB6B629CE643AE60DB4E07B@dggemm513-mbx.china.huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e972e42b-4344-31dc-eb4c-d963adb08a5c@redhat.com>
Date:   Mon, 7 Dec 2020 11:54:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <34EFBCA9F01B0748BEB6B629CE643AE60DB4E07B@dggemm513-mbx.china.huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/4 下午6:22, wangyunjian wrote:
>> -----Original Message-----
>> From: Jason Wang [mailto:jasowang@redhat.com]
>> Sent: Friday, December 4, 2020 2:11 PM
>> To: wangyunjian <wangyunjian@huawei.com>; mst@redhat.com
>> Cc: virtualization@lists.linux-foundation.org; netdev@vger.kernel.org; Lilijun
>> (Jerry) <jerry.lilijun@huawei.com>; xudingke <xudingke@huawei.com>
>> Subject: Re: [PATCH net-next] tun: fix ubuf refcount incorrectly on error path
>>
>>
>> On 2020/12/3 下午4:00, wangyunjian wrote:
>>> From: Yunjian Wang <wangyunjian@huawei.com>
>>>
>>> After setting callback for ubuf_info of skb, the callback
>>> (vhost_net_zerocopy_callback) will be called to decrease the refcount
>>> when freeing skb. But when an exception occurs afterwards, the error
>>> handling in vhost handle_tx() will try to decrease the same refcount
>>> again. This is wrong and fix this by clearing ubuf_info when meeting
>>> errors.
>>>
>>> Fixes: 4477138fa0ae ("tun: properly test for IFF_UP")
>>> Fixes: 90e33d459407 ("tun: enable napi_gro_frags() for TUN/TAP
>>> driver")
>>>
>>> Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
>>> ---
>>>    drivers/net/tun.c | 11 +++++++++++
>>>    1 file changed, 11 insertions(+)
>>>
>>> diff --git a/drivers/net/tun.c b/drivers/net/tun.c index
>>> 2dc1988a8973..3614bb1b6d35 100644
>>> --- a/drivers/net/tun.c
>>> +++ b/drivers/net/tun.c
>>> @@ -1861,6 +1861,12 @@ static ssize_t tun_get_user(struct tun_struct
>> *tun, struct tun_file *tfile,
>>>    	if (unlikely(!(tun->dev->flags & IFF_UP))) {
>>>    		err = -EIO;
>>>    		rcu_read_unlock();
>>> +		if (zerocopy) {
>>> +			skb_shinfo(skb)->destructor_arg = NULL;
>>> +			skb_shinfo(skb)->tx_flags &= ~SKBTX_DEV_ZEROCOPY;
>>> +			skb_shinfo(skb)->tx_flags &= ~SKBTX_SHARED_FRAG;
>>> +		}
>>> +
>>>    		goto drop;
>>>    	}
>>>
>>> @@ -1874,6 +1880,11 @@ static ssize_t tun_get_user(struct tun_struct
>>> *tun, struct tun_file *tfile,
>>>
>>>    		if (unlikely(headlen > skb_headlen(skb))) {
>>>    			atomic_long_inc(&tun->dev->rx_dropped);
>>> +			if (zerocopy) {
>>> +				skb_shinfo(skb)->destructor_arg = NULL;
>>> +				skb_shinfo(skb)->tx_flags &= ~SKBTX_DEV_ZEROCOPY;
>>> +				skb_shinfo(skb)->tx_flags &= ~SKBTX_SHARED_FRAG;
>>> +			}
>>>    			napi_free_frags(&tfile->napi);
>>>    			rcu_read_unlock();
>>>    			mutex_unlock(&tfile->napi_mutex);
>>
>> It looks to me then we miss the failure feedback.
>>
>> The issues comes from the inconsistent error handling in tun.
>>
>> I wonder whether we can simply do uarg->callback(uarg, false) if necessary on
>> every failture path on tun_get_user().
> How about this?
>
> ---
>   drivers/net/tun.c | 29 ++++++++++++++++++-----------
>   1 file changed, 18 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index 2dc1988a8973..36a8d8eacd7b 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1637,6 +1637,19 @@ static struct sk_buff *tun_build_skb(struct tun_struct *tun,
>   	return NULL;
>   }
>   
> +/* copy ubuf_info for callback when skb has no error */
> +inline static tun_copy_ubuf_info(struct sk_buff *skb, bool zerocopy, void *msg_control)
> +{
> +	if (zerocopy) {
> +		skb_shinfo(skb)->destructor_arg = msg_control;
> +		skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
> +		skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
> +	} else if (msg_control) {
> +		struct ubuf_info *uarg = msg_control;
> +		uarg->callback(uarg, false);
> +	}
> +}
> +
>   /* Get packet from user space buffer */
>   static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>   			    void *msg_control, struct iov_iter *from,
> @@ -1812,16 +1825,6 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>   		break;
>   	}
>   
> -	/* copy skb_ubuf_info for callback when skb has no error */
> -	if (zerocopy) {
> -		skb_shinfo(skb)->destructor_arg = msg_control;
> -		skb_shinfo(skb)->tx_flags |= SKBTX_DEV_ZEROCOPY;
> -		skb_shinfo(skb)->tx_flags |= SKBTX_SHARED_FRAG;
> -	} else if (msg_control) {
> -		struct ubuf_info *uarg = msg_control;
> -		uarg->callback(uarg, false);
> -	}
> -
>   	skb_reset_network_header(skb);
>   	skb_probe_transport_header(skb);
>   	skb_record_rx_queue(skb, tfile->queue_index);
> @@ -1830,6 +1833,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>   		struct bpf_prog *xdp_prog;
>   		int ret;
>   
> +		tun_copy_ubuf_info(skb, zerocopy, msg_control);


If you think disabling zerocopy for XDP (which I think it makes sense). 
It's better to do this in another patch.


>   		local_bh_disable();
>   		rcu_read_lock();
>   		xdp_prog = rcu_dereference(tun->xdp_prog);
> @@ -1880,7 +1884,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>   			WARN_ON(1);
>   			return -ENOMEM;
>   		}
> -
> +		tun_copy_ubuf_info(skb, zerocopy, msg_control);


And for NAPI frags.


>   		local_bh_disable();
>   		napi_gro_frags(&tfile->napi);
>   		local_bh_enable();
> @@ -1889,6 +1893,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>   		struct sk_buff_head *queue = &tfile->sk.sk_write_queue;
>   		int queue_len;
>   
> +		tun_copy_ubuf_info(skb, zerocopy, msg_control);
>   		spin_lock_bh(&queue->lock);
>   		__skb_queue_tail(queue, skb);
>   		queue_len = skb_queue_len(queue);
> @@ -1899,8 +1904,10 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
>   
>   		local_bh_enable();
>   	} else if (!IS_ENABLED(CONFIG_4KSTACKS)) {
> +		tun_copy_ubuf_info(skb, zerocopy, msg_control);
>   		tun_rx_batched(tun, tfile, skb, more);
>   	} else {
> +		tun_copy_ubuf_info(skb, zerocopy, msg_control);
>   		netif_rx_ni(skb);
>   	}
>   	rcu_read_unlock();


So it looks to me you want to disable zerocopy in all of the possible 
datapath?

Thanks

