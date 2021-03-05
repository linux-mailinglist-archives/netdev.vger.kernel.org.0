Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B5032E041
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 04:44:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhCEDo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 22:44:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52922 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229458AbhCEDo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 22:44:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614915895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I4I5kef0XmfQCBgsttFhP8wyT8eOUwk5Gs3XFVSY0zw=;
        b=dlW+b9SCXhSDT0HoJT35cxlRrbyVe9+S1B6NjASYga9gad7CRAZj6nyzuPsI7tmUiLqUxQ
        zQChG/GJd6tEC5mcgqbBCn6hTjLjP2xuD1XRLm3POjwMItAscVPgvxdGJ6xyOgz2s7tnfb
        XSTmWtxjTLD3BuYcenyI/QHAuFiNP6U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-435-no1UHjtgMt6ILm_NLFuyrw-1; Thu, 04 Mar 2021 22:44:54 -0500
X-MC-Unique: no1UHjtgMt6ILm_NLFuyrw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DCD6D80006E;
        Fri,  5 Mar 2021 03:44:51 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-13-196.pek2.redhat.com [10.72.13.196])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 425DC6060F;
        Fri,  5 Mar 2021 03:44:39 +0000 (UTC)
Subject: Re: [RFC v4 11/11] vduse: Support binding irq to the specified cpu
To:     Yongji Xie <xieyongji@bytedance.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Parav Pandit <parav@nvidia.com>, Bob Liu <bob.liu@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matthew Wilcox <willy@infradead.org>, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, bcrl@kvack.org,
        Jonathan Corbet <corbet@lwn.net>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org
References: <20210223115048.435-1-xieyongji@bytedance.com>
 <20210223115048.435-12-xieyongji@bytedance.com>
 <d104a518-799d-c13f-311c-f7a673f9241b@redhat.com>
 <CACycT3uaOU5ybwojfiSL0kSpW9GUnh82ZeDH7drdkfK72iP8bg@mail.gmail.com>
 <86af7b84-23f0-dca7-183b-e4d586cbcea6@redhat.com>
 <CACycT3s+eO7Qi8aPayLbfNnLqOK_q1oB6+d+51hudd-zZf7n8w@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <845bfa68-2ece-81a2-317f-3e0cf4f72cf1@redhat.com>
Date:   Fri, 5 Mar 2021 11:44:38 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CACycT3s+eO7Qi8aPayLbfNnLqOK_q1oB6+d+51hudd-zZf7n8w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2021/3/5 11:37 上午, Yongji Xie wrote:
> On Fri, Mar 5, 2021 at 11:11 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2021/3/4 4:19 下午, Yongji Xie wrote:
>>> On Thu, Mar 4, 2021 at 3:30 PM Jason Wang <jasowang@redhat.com> wrote:
>>>> On 2021/2/23 7:50 下午, Xie Yongji wrote:
>>>>> Add a parameter for the ioctl VDUSE_INJECT_VQ_IRQ to support
>>>>> injecting virtqueue's interrupt to the specified cpu.
>>>> How userspace know which CPU is this irq for? It looks to me we need to
>>>> do it at different level.
>>>>
>>>> E.g introduce some API in sys to allow admin to tune for that.
>>>>
>>>> But I think we can do that in antoher patch on top of this series.
>>>>
>>> OK. I will think more about it.
>>
>> It should be soemthing like
>> /sys/class/vduse/$dev_name/vq/0/irq_affinity. Also need to make sure
>> eventfd could not be reused.
>>
> Looks like we doesn't use eventfd now. Do you mean we need to use
> eventfd in this case?


No, I meant if we're using eventfd, do we allow a single eventfd to be 
used for injecting irq for more than one virtqueue? (If not, I guess it 
should be ok).

Thanks


>
> Thanks,
> Yongji
>

