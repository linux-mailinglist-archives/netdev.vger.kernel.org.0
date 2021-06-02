Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DC03982DB
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 09:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhFBHVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 03:21:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40559 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230099AbhFBHVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 03:21:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622618398;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X4nP3Ng969nG95ueTZmh5K5TsN/lZGqF7zfAlo06R84=;
        b=U7j2TpWJ42Qn/KFvKKkKOy7flRZKqCcy9WxDyvKeTqeqZAsoXK5k0IS5aWO7g6E01+ee+t
        zTC0lr8lua8F6e1QbvpzUSz07CbdqdBeTDhTeoNXps65yQNe8n6Ntpoxq2KP1OPa/JqW9Y
        bSISUY7eKr1lyMrz5NXy1o0QYXmZVCg=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-342-fCboMVxBNfShguC1QqU4zA-1; Wed, 02 Jun 2021 03:19:57 -0400
X-MC-Unique: fCboMVxBNfShguC1QqU4zA-1
Received: by mail-pl1-f199.google.com with SMTP id o9-20020a1709026b09b0290102b8314d05so652770plk.8
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 00:19:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=X4nP3Ng969nG95ueTZmh5K5TsN/lZGqF7zfAlo06R84=;
        b=JbDK4d4DjVWMgGp90REJeULObtmjwFJDJG3cgo7p69P5H4eBRwOG/rDcpkjlTZ4mUk
         tWuiW1pozAKBi17zDKAMi9fO0+GYfmexjnf+oo2SNtqYuRoxT7+NEddh4G8DFyP9W3HD
         V8GbOy/q3EJTDG6ftu+aaizQHswKdZoZj7x0OTWH1Bb2DHDtnp1GlL5jn6ewX3hNyFZA
         m6YBxbMr794jm9LS+rZQ7w7aSByMawDMvsPR9e4noHpxKplAq24qjlbIEmcwUpWg+rhS
         W8NLPh7Qs5lwSxRk/hE29e7LRwf1poOBM2/yyLymVlBsp7tfzVTfrIno9cbOtbvKta6T
         JmVw==
X-Gm-Message-State: AOAM5326x/IyJPHqQIJNLGcbLcZ8RSMj4sm8GTyMgKHe757kcX63/G2B
        1ClHeL29L3pWCAkAZ+Rb1pPnftHQnFt8QGml2CjTaw7JmPdS+59gWuWtd/BMrSfINav32MPQPND
        AU3pS7AjRBdBbymNe
X-Received: by 2002:a62:cd46:0:b029:2ea:299c:d7bd with SMTP id o67-20020a62cd460000b02902ea299cd7bdmr490447pfg.72.1622618396346;
        Wed, 02 Jun 2021 00:19:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzZ645Is1tmz07mckMTyAA4Mz50hpb0lkW6SxhGDP6TZI8rBAamuObw3kS2TVn4LZecUfJFGQ==
X-Received: by 2002:a62:cd46:0:b029:2ea:299c:d7bd with SMTP id o67-20020a62cd460000b02902ea299cd7bdmr490428pfg.72.1622618396110;
        Wed, 02 Jun 2021 00:19:56 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id p11sm15880530pgn.65.2021.06.02.00.19.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 00:19:55 -0700 (PDT)
Subject: Re: [PATCH] virtio-net: fix the kzalloc/kfree mismatch problem
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        "Guodeqing (A)" <geffrey.guo@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "mst@redhat.com" <mst@redhat.com>
References: <1621821978.04102-1-xuanzhuo@linux.alibaba.com>
 <36d1b92c-7dc5-f84e-ef86-980b15c39965@redhat.com> <YLccNiOW8UGFowli@unreal>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <abcc9911-67d8-8764-b986-d749187d4977@redhat.com>
Date:   Wed, 2 Jun 2021 15:19:46 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <YLccNiOW8UGFowli@unreal>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/6/2 下午1:50, Leon Romanovsky 写道:
> On Mon, May 24, 2021 at 10:37:14AM +0800, Jason Wang wrote:
>> 在 2021/5/24 上午10:06, Xuan Zhuo 写道:
>>> On Mon, 24 May 2021 01:48:53 +0000, Guodeqing (A) <geffrey.guo@huawei.com> wrote:
>>>>> -----Original Message-----
>>>>> From: Max Gurtovoy [mailto:mgurtovoy@nvidia.com]
>>>>> Sent: Sunday, May 23, 2021 15:25
>>>>> To: Guodeqing (A) <geffrey.guo@huawei.com>; mst@redhat.com
>>>>> Cc: jasowang@redhat.com; davem@davemloft.net; kuba@kernel.org;
>>>>> virtualization@lists.linux-foundation.org; netdev@vger.kernel.org
>>>>> Subject: Re: [PATCH] virtio-net: fix the kzalloc/kfree mismatch problem
>>>>>
>>>>>
>>>>> On 5/22/2021 11:02 AM, guodeqing wrote:
>>>>>> If the virtio_net device does not suppurt the ctrl queue feature, the
>>>>>> vi->ctrl was not allocated, so there is no need to free it.
>>>>> you don't need this check.
>>>>>
>>>>> from kfree doc:
>>>>>
>>>>> "If @objp is NULL, no operation is performed."
>>>>>
>>>>> This is not a bug. I've set vi->ctrl to be NULL in case !vi->has_cvq.
>>>>>
>>>>>
>>>>     yes,  this is not a bug, the patch is just a optimization, because the vi->ctrl maybe
>>>>     be freed which  was not allocated, this may give people a misunderstanding.
>>>>     Thanks.
>>> I think it may be enough to add a comment, and the code does not need to be
>>> modified.
>>>
>>> Thanks.
>>
>> Or even just leave the current code as is. A lot of kernel codes was wrote
>> under the assumption that kfree() should deal with NULL.
> It is not assumption but standard practice that can be seen as side
> effect of "7) Centralized exiting of functions" section of coding-style.rst.
>
> Thanks


I don't see the connection to the centralized exiting.

Something like:

if (foo)
     kfree(foo);

won't break the centralization.

Thanks


>

