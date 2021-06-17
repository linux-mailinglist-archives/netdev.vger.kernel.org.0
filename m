Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19DF13AA8FE
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 04:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhFQCjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 22:39:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45666 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229989AbhFQCjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 22:39:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623897419;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z5SUgRme5vfSn2M+kLpJuyGRMNfwStTHpMTYk3YD170=;
        b=RwE/c0gI1mkLVXS/GciwpxzCEpKi+KCtN/n9ObhGxTpF62jT2ck21C/u1w75kNKNvjdOCr
        WPpr84qIfCcZS/M6RThRnBiKU8ZbvEmkQgcb0S3HgUsmd51MqYvm9mJNkCla87QI+4SUCc
        Pp7dMKTHIduO1S5Ko8CbvdKfymleKCU=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-lvala2DsOkW1rcl2OxzNdw-1; Wed, 16 Jun 2021 22:36:58 -0400
X-MC-Unique: lvala2DsOkW1rcl2OxzNdw-1
Received: by mail-pl1-f197.google.com with SMTP id e10-20020a170902b78ab029011c600aa751so1110909pls.6
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 19:36:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=z5SUgRme5vfSn2M+kLpJuyGRMNfwStTHpMTYk3YD170=;
        b=EItH8232bscdQl4DbItwwGs8soMWbS+R+FfMs83iOH2Is/1CQFgg5RYlLXaHf68svm
         oXCPBAi0ig9autBVs+Fc1sYpUgD0paA6MWnXRKIP9W+RoujVf3Ikn1dnirdxOArDwFNq
         fSTpoQ0AMDMgeTRJx7CQ+lKPLLHk6R5CCVDmhASM5ZXFEtT+68t7wYuTDr/p8p7uyOXf
         YIxgNv8ymJYol+0d63OFLB6tGYdZieODGFf+M4EIDMq6NAAztfTe2DwYuAPu9A22B/au
         PyGMTbLYOIURFSPN83+Frg72veelhpIj2EMQ5bqa9ptwa3PReJ0mdoms+6rYc2R8tExp
         teNw==
X-Gm-Message-State: AOAM531/FaItWJ2EygmSD44J+H8QL+GrzH5HdokgmdiWkXAEwbSdQRcV
        EcAaunZUhm0eP3/ntmjNZ3kwC3K+tqE0ozwbMX7Y0DIL02WuYgRAagsfytFIC+4f2vIQrnc/HY7
        ybkWxVhGTPyOmYnjwlg51yHUV6VmiaMTmpp0JWVo8mFg5MlKmwLKFv8YZIqGhT3y1Z5iM
X-Received: by 2002:aa7:8886:0:b029:2fe:8eee:4a69 with SMTP id z6-20020aa788860000b02902fe8eee4a69mr1172990pfe.73.1623897417309;
        Wed, 16 Jun 2021 19:36:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzJlUPCOW72eixcxEQwNs9jI/9nypgEKYTM8JVt54OOata6jZKvX0oDhYusW5wvm4F8OwAFgw==
X-Received: by 2002:aa7:8886:0:b029:2fe:8eee:4a69 with SMTP id z6-20020aa788860000b02902fe8eee4a69mr1172955pfe.73.1623897416935;
        Wed, 16 Jun 2021 19:36:56 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id b1sm3342472pjh.4.2021.06.16.19.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jun 2021 19:36:56 -0700 (PDT)
Subject: Re: [PATCH net-next v5 12/15] virtio-net: support AF_XDP zc tx
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org,
        "dust.li" <dust.li@linux.alibaba.com>, netdev@vger.kernel.org
References: <1623848265.175296-1-xuanzhuo@linux.alibaba.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <be83fe73-cdde-6905-6e56-5b220cf302fd@redhat.com>
Date:   Thu, 17 Jun 2021 10:36:49 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1623848265.175296-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/16 下午8:57, Xuan Zhuo 写道:
> On Wed, 16 Jun 2021 20:51:41 +0800, Jason Wang <jasowang@redhat.com> wrote:
>> 在 2021/6/16 下午6:19, Xuan Zhuo 写道:
>>>>> + * In this way, even if xsk has been unbundled with rq/sq, or a new xsk and
>>>>> + * rq/sq  are bound, and a new virtnet_xsk_ctx_head is created. It will not
>>>>> + * affect the old virtnet_xsk_ctx to be recycled. And free all head and ctx when
>>>>> + * ref is 0.
>>>> This looks complicated and it will increase the footprint. Consider the
>>>> performance penalty and the complexity, I would suggest to use reset
>>>> instead.
>>>>
>>>> Then we don't need to introduce such context.
>>> I don't like this either. It is best if we can reset the queue, but then,
>>> according to my understanding, the backend should also be supported
>>> synchronously, so if you don't update the backend synchronously, you can't use
>>> xsk.
>>
>> Yes, actually, vhost-net support per vq suspending. The problem is that
>> we're lacking a proper API at virtio level.
>>
>> Virtio-pci has queue_enable but it forbids writing zero to that.
>>
>>
>>> I don’t think resetting the entire dev is a good solution. If you want to bind
>>> xsk to 10 queues, you may have to reset the entire device 10 times. I don’t
>>> think this is a good way. But the current spec does not support reset single
>>> queue, so I chose the current solution.
>>>
>>> Jason, what do you think we are going to do? Realize the reset function of a
>>> single queue?
>>
>> Yes, it's the best way. Do you want to work on that?
> Of course, I am very willing to continue this work. Although users must upgrade
> the backend to use virtio-net + xsk in the future, this makes the situation a
> bit troublesome.
>
> I will complete the kernel modification as soon as possible, but I am not
> familiar with the process of submitting the spec patch. Can you give me some
> guidance and where should I send the spec patch.


Subscribe the virtio dev mailing list [1] and send the spec path there.

Thanks

[1] 
https://www.oasis-open.org/committees/tc_home.php?wg_abbrev=virtio#feedback


>
> Thanks.
>
>> We can start from the spec patch, and introduce it as basic facility and
>> implement it in the PCI transport first.
>>
>> Thanks
>>
>>
>>> Looking forward to your reply!!!
>>>
>>> Thanks
>>>

