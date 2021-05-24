Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFDB38DF46
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 04:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbhEXCiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 22:38:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47068 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231867AbhEXCiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 22:38:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621823842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RtRzjJU3zz/wMpYYu1wZ0eR2bUfiIpbddTRFTd2F8tI=;
        b=KNsTaCyh6D9GyFY/MK/rV6RH/k1q6nh8Q0+kLUE15xCXh+tz1GwvPkpDlT1fwV9BK0up7+
        Y17osa1F4T4iUuzaQaCFTNuwFq9nGgTIE5Bx5XW9IMG0BcicWH4xYRdPKBMv0HKx6i2F3O
        tcwe8IGKdmmDJujMyoINcYm93f7EbCo=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-354-5fn4rDYWNOW0C5GNHJRyrw-1; Sun, 23 May 2021 22:37:21 -0400
X-MC-Unique: 5fn4rDYWNOW0C5GNHJRyrw-1
Received: by mail-pl1-f199.google.com with SMTP id m12-20020a170902f20cb02900ef9c8577c4so12133088plc.19
        for <netdev@vger.kernel.org>; Sun, 23 May 2021 19:37:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=RtRzjJU3zz/wMpYYu1wZ0eR2bUfiIpbddTRFTd2F8tI=;
        b=C8yq6zDvwWeM6FGXjUhkLxAXS1T5QlWQiKOGwfpFfPh09o5y58Tgxf4cULkQSFLxJW
         mdSLaJbC3gUnsLIi1Ot35KX4Cnq1x/KUGRnvanM9GQ7eG8fvBY+g6G86swM4rgDHxXPz
         2rBY52+nU+OlUwm5biVZbLlVJTzP51fPGs1mTJhp6CkexqLeMa+aigpT6ozI356Yuwdq
         HOJw8KzoZ5raL5/C/uTCtZdAlVUIuI+uE0j1NRVyUJRxWNsaxiVBGFf3gaAlT4HCBjXq
         Js+FuJOwyADiucorrf2KBF6yQW9B6HqP9rVsqs5Pi8pNKGEtdlPHnkZuTiyTY28QiSWU
         Uyng==
X-Gm-Message-State: AOAM531YA3QJXwpjgBuXAdiRt1s13TMPRgWaGQJqWtOULiMkBfeKCB2B
        YZ8GP3K+Zh6i9/2SeC3NsRgdFzyjclxyBiuyeY70k+/zfax1lfBB26G3iFwpbeIVfAFXQK3ZYzR
        Pm/v2fa5v24PFjvE3
X-Received: by 2002:a05:6a00:bcd:b029:2e5:694c:1c96 with SMTP id x13-20020a056a000bcdb02902e5694c1c96mr13004706pfu.53.1621823840112;
        Sun, 23 May 2021 19:37:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx37stF392FcwzsfWouLaJiCy30jVN9MxMjs2gF5N3m/RiHjhLpwt2/v+Fs58s94Yk5v76tVg==
X-Received: by 2002:a05:6a00:bcd:b029:2e5:694c:1c96 with SMTP id x13-20020a056a000bcdb02902e5694c1c96mr13004685pfu.53.1621823839871;
        Sun, 23 May 2021 19:37:19 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l1sm8671328pjt.40.2021.05.23.19.37.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 May 2021 19:37:19 -0700 (PDT)
Subject: Re: [PATCH] virtio-net: fix the kzalloc/kfree mismatch problem
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Guodeqing (A)" <geffrey.guo@huawei.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "mst@redhat.com" <mst@redhat.com>
References: <1621821978.04102-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <36d1b92c-7dc5-f84e-ef86-980b15c39965@redhat.com>
Date:   Mon, 24 May 2021 10:37:14 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <1621821978.04102-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/5/24 ÉÏÎç10:06, Xuan Zhuo Ð´µÀ:
> On Mon, 24 May 2021 01:48:53 +0000, Guodeqing (A) <geffrey.guo@huawei.com> wrote:
>>
>>> -----Original Message-----
>>> From: Max Gurtovoy [mailto:mgurtovoy@nvidia.com]
>>> Sent: Sunday, May 23, 2021 15:25
>>> To: Guodeqing (A) <geffrey.guo@huawei.com>; mst@redhat.com
>>> Cc: jasowang@redhat.com; davem@davemloft.net; kuba@kernel.org;
>>> virtualization@lists.linux-foundation.org; netdev@vger.kernel.org
>>> Subject: Re: [PATCH] virtio-net: fix the kzalloc/kfree mismatch problem
>>>
>>>
>>> On 5/22/2021 11:02 AM, guodeqing wrote:
>>>> If the virtio_net device does not suppurt the ctrl queue feature, the
>>>> vi->ctrl was not allocated, so there is no need to free it.
>>> you don't need this check.
>>>
>>> from kfree doc:
>>>
>>> "If @objp is NULL, no operation is performed."
>>>
>>> This is not a bug. I've set vi->ctrl to be NULL in case !vi->has_cvq.
>>>
>>>
>>    yes,  this is not a bug, the patch is just a optimization, because the vi->ctrl maybe
>>    be freed which  was not allocated, this may give people a misunderstanding.
>>    Thanks.
>
> I think it may be enough to add a comment, and the code does not need to be
> modified.
>
> Thanks.


Or even just leave the current code as is. A lot of kernel codes was 
wrote under the assumption that kfree() should deal with NULL.

Thanks


>
>>>> Here I adjust the initialization sequence and the check of vi->has_cvq
>>>> to slove this problem.
>>>>
>>>> Fixes: 	122b84a1267a ("virtio-net: don't allocate control_buf if not
>>> supported")
>>>> Signed-off-by: guodeqing <geffrey.guo@huawei.com>
>>>> ---
>>>>    drivers/net/virtio_net.c | 20 ++++++++++----------
>>>>    1 file changed, 10 insertions(+), 10 deletions(-)
>>>>
>>>> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c index
>>>> 9b6a4a875c55..894f894d3a29 100644
>>>> --- a/drivers/net/virtio_net.c
>>>> +++ b/drivers/net/virtio_net.c
>>>> @@ -2691,7 +2691,8 @@ static void virtnet_free_queues(struct
>>>> virtnet_info *vi)
>>>>
>>>>    	kfree(vi->rq);
>>>>    	kfree(vi->sq);
>>>> -	kfree(vi->ctrl);
>>>> +	if (vi->has_cvq)
>>>> +		kfree(vi->ctrl);
>>>>    }
>>>>
>>>>    static void _free_receive_bufs(struct virtnet_info *vi) @@ -2870,13
>>>> +2871,6 @@ static int virtnet_alloc_queues(struct virtnet_info *vi)
>>>>    {
>>>>    	int i;
>>>>
>>>> -	if (vi->has_cvq) {
>>>> -		vi->ctrl = kzalloc(sizeof(*vi->ctrl), GFP_KERNEL);
>>>> -		if (!vi->ctrl)
>>>> -			goto err_ctrl;
>>>> -	} else {
>>>> -		vi->ctrl = NULL;
>>>> -	}
>>>>    	vi->sq = kcalloc(vi->max_queue_pairs, sizeof(*vi->sq), GFP_KERNEL);
>>>>    	if (!vi->sq)
>>>>    		goto err_sq;
>>>> @@ -2884,6 +2878,12 @@ static int virtnet_alloc_queues(struct
>>> virtnet_info *vi)
>>>>    	if (!vi->rq)
>>>>    		goto err_rq;
>>>>
>>>> +	if (vi->has_cvq) {
>>>> +		vi->ctrl = kzalloc(sizeof(*vi->ctrl), GFP_KERNEL);
>>>> +		if (!vi->ctrl)
>>>> +			goto err_ctrl;
>>>> +	}
>>>> +
>>>>    	INIT_DELAYED_WORK(&vi->refill, refill_work);
>>>>    	for (i = 0; i < vi->max_queue_pairs; i++) {
>>>>    		vi->rq[i].pages = NULL;
>>>> @@ -2902,11 +2902,11 @@ static int virtnet_alloc_queues(struct
>>>> virtnet_info *vi)
>>>>
>>>>    	return 0;
>>>>
>>>> +err_ctrl:
>>>> +	kfree(vi->rq);
>>>>    err_rq:
>>>>    	kfree(vi->sq);
>>>>    err_sq:
>>>> -	kfree(vi->ctrl);
>>>> -err_ctrl:
>>>>    	return -ENOMEM;
>>>>    }
>>>>

