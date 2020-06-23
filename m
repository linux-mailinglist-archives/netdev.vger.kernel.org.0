Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77505204ACB
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 09:16:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731264AbgFWHPx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 03:15:53 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22531 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731006AbgFWHPx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 03:15:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592896552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HjkVUr/S/a3Xewkk0G7CYjpjGpF5YBjTPi+qkO5aYLE=;
        b=dOzWxCSt1De9tmE1t9ZihGLvmfS3jXOufbS488aFatHOThBkk36RfsYPB780EOG3A95Mdq
        KVmQAY8lWiIvbUj1insLFe9MiwM61cSatLtMMx4m4IEQ49Sm5chMnHviMH1mNn+AvNT6AY
        5gOVErTYdTXpxHW9Hu4AP7OAGHdkZAA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-0YPiTuEgM8O-Zx2HigyzCw-1; Tue, 23 Jun 2020 03:15:48 -0400
X-MC-Unique: 0YPiTuEgM8O-Zx2HigyzCw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 621081005512;
        Tue, 23 Jun 2020 07:15:47 +0000 (UTC)
Received: from [10.72.12.144] (ovpn-12-144.pek2.redhat.com [10.72.12.144])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E80E260F80;
        Tue, 23 Jun 2020 07:15:41 +0000 (UTC)
Subject: Re: [PATCH RFC v8 02/11] vhost: use batched get_vq_desc version
To:     Eugenio Perez Martin <eperezma@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
References: <20200611113404.17810-1-mst@redhat.com>
 <20200611113404.17810-3-mst@redhat.com>
 <0332b0cf-cf00-9216-042c-e870efa33626@redhat.com>
 <20200622115946-mutt-send-email-mst@kernel.org>
 <c56cc86d-a420-79ca-8420-e99db91980fa@redhat.com>
 <CAJaqyWc3C_Td_SpV97CuemkQH9vH+EL3sGgeWGE82E5gYxZNCA@mail.gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <6715f515-3db6-1006-09dd-19464e3ff676@redhat.com>
Date:   Tue, 23 Jun 2020 15:15:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAJaqyWc3C_Td_SpV97CuemkQH9vH+EL3sGgeWGE82E5gYxZNCA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/23 下午3:00, Eugenio Perez Martin wrote:
> On Tue, Jun 23, 2020 at 4:51 AM Jason Wang <jasowang@redhat.com> wrote:
>>
>> On 2020/6/23 上午12:00, Michael S. Tsirkin wrote:
>>> On Wed, Jun 17, 2020 at 11:19:26AM +0800, Jason Wang wrote:
>>>> On 2020/6/11 下午7:34, Michael S. Tsirkin wrote:
>>>>>     static void vhost_vq_free_iovecs(struct vhost_virtqueue *vq)
>>>>>     {
>>>>>      kfree(vq->descs);
>>>>> @@ -394,6 +400,9 @@ static long vhost_dev_alloc_iovecs(struct vhost_dev *dev)
>>>>>      for (i = 0; i < dev->nvqs; ++i) {
>>>>>              vq = dev->vqs[i];
>>>>>              vq->max_descs = dev->iov_limit;
>>>>> +           if (vhost_vq_num_batch_descs(vq) < 0) {
>>>>> +                   return -EINVAL;
>>>>> +           }
>>>> This check breaks vdpa which set iov_limit to zero. Consider iov_limit is
>>>> meaningless to vDPA, I wonder we can skip the test when device doesn't use
>>>> worker.
>>>>
>>>> Thanks
>>> It doesn't need iovecs at all, right?
>>>
>>> -- MST
>>
>> Yes, so we may choose to bypass the iovecs as well.
>>
>> Thanks
>>
> I think that the kmalloc_array returns ZERO_SIZE_PTR for all of them
> in that case, so I didn't bother to skip the kmalloc_array parts.
> Would you prefer to skip them all and let them NULL? Or have I
> misunderstood what you mean?


I'm ok with either approach, but my understanding is that Michael wants 
to skip them all.

Thanks


>
> Thanks!
>

