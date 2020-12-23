Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C0052E15EB
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729789AbgLWCz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:55:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40938 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729205AbgLWCz0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 21:55:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1608692038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n00BcWMEg2A9HqhGHz8BATUpmDv8UaVW95nXP+Qgpw8=;
        b=Ge4onf/2st6wzRb7lcfpq72ns6OGmmmwrL/mRJ2exvIgQF9TfDp17HkpKLG9z4WsOv02uw
        pBY9nAR9/qaHFlMDVwlvtl9rD6o4rLaSBYR1aM2i0aAJMIqSgSiJSsQQM4uRDd1b2Vyhqb
        gduVSKNl1EmpkBbBY7DBMoPgeki8bZI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-493-y-15POxsO-W1zTRcOEfuZQ-1; Tue, 22 Dec 2020 21:53:57 -0500
X-MC-Unique: y-15POxsO-W1zTRcOEfuZQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6382F107ACE3;
        Wed, 23 Dec 2020 02:53:55 +0000 (UTC)
Received: from [10.72.13.128] (ovpn-13-128.pek2.redhat.com [10.72.13.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8431510013C1;
        Wed, 23 Dec 2020 02:53:48 +0000 (UTC)
Subject: Re: [PATCH net v2 2/2] vhost_net: fix high cpu load when sendmsg
 fails
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     wangyunjian <wangyunjian@huawei.com>,
        Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org,
        "Lilijun (Jerry)" <jerry.lilijun@huawei.com>,
        chenchanghu <chenchanghu@huawei.com>,
        xudingke <xudingke@huawei.com>,
        "huangbin (J)" <brian.huangbin@huawei.com>
References: <cover.1608065644.git.wangyunjian@huawei.com>
 <6b4c5fff8705dc4b5b6a25a45c50f36349350c73.1608065644.git.wangyunjian@huawei.com>
 <CAF=yD-K6EM3zfZtEh=305P4Z6ehO6TzfQC4cxp5+gHYrxEtXSg@mail.gmail.com>
 <acebdc23-7627-e170-cdfb-b7656c05e5c5@redhat.com>
 <CAF=yD-KCs5x1oX-02aDM=5JyLP=BaA7_Jg7Wxt3=JmK8JBnyiA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <2a309efb-0ea5-c40e-5564-b8900601da97@redhat.com>
Date:   Wed, 23 Dec 2020 10:53:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAF=yD-KCs5x1oX-02aDM=5JyLP=BaA7_Jg7Wxt3=JmK8JBnyiA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/12/22 下午10:24, Willem de Bruijn wrote:
> On Mon, Dec 21, 2020 at 11:41 PM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2020/12/22 上午7:07, Willem de Bruijn wrote:
>>> On Wed, Dec 16, 2020 at 3:20 AM wangyunjian<wangyunjian@huawei.com>  wrote:
>>>> From: Yunjian Wang<wangyunjian@huawei.com>
>>>>
>>>> Currently we break the loop and wake up the vhost_worker when
>>>> sendmsg fails. When the worker wakes up again, we'll meet the
>>>> same error.
>>> The patch is based on the assumption that such error cases always
>>> return EAGAIN. Can it not also be ENOMEM, such as from tun_build_skb?
>>>
>>>> This will cause high CPU load. To fix this issue,
>>>> we can skip this description by ignoring the error. When we
>>>> exceeds sndbuf, the return value of sendmsg is -EAGAIN. In
>>>> the case we don't skip the description and don't drop packet.
>>> the -> that
>>>
>>> here and above: description -> descriptor
>>>
>>> Perhaps slightly revise to more explicitly state that
>>>
>>> 1. in the case of persistent failure (i.e., bad packet), the driver
>>> drops the packet
>>> 2. in the case of transient failure (e.g,. memory pressure) the driver
>>> schedules the worker to try again later
>>
>> If we want to go with this way, we need a better time to wakeup the
>> worker. Otherwise it just produces more stress on the cpu that is what
>> this patch tries to avoid.
> Perhaps I misunderstood the purpose of the patch: is it to drop
> everything, regardless of transient or persistent failure, until the
> ring runs out of descriptors?


My understanding is that the main motivation is to avoid high cpu 
utilization when sendmsg() fail due to guest reason (e.g bad packet).


>
> I can understand both a blocking and drop strategy during memory
> pressure. But partial drop strategy until exceeding ring capacity
> seems like a peculiar hybrid?


Yes. So I wonder if we want to be do better when we are in the memory 
pressure. E.g can we let socket wake up us instead of rescheduling the 
workers here? At least in this case we know some memory might be freed?

Thanks


>

