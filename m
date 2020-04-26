Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C2311B8D8A
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 09:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbgDZHi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 03:38:58 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41431 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726135AbgDZHi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 03:38:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587886736;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vop1t3sjK9amtXfGYvpa+yLGCJ32ZxdBV2IWmBKObrI=;
        b=U5TpxxzbuSz26MqNxPOch5qQbljCSF+f45tHdmpEYTRyGavEJsN0rwVRz5TuG3dwQYkGYu
        cEH1doMGQot4TU3vjhSr1Fesj54Ptvv+oxur1ZqbIyAXUeSQyLq/muMfyxSEZUhDQx5oBq
        shRvHHQ06eysmUkbH4izmLlTJsAok+k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-gqr-8FTQPiaXw8kYIrJ86A-1; Sun, 26 Apr 2020 03:38:52 -0400
X-MC-Unique: gqr-8FTQPiaXw8kYIrJ86A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E2D6872FE0;
        Sun, 26 Apr 2020 07:38:50 +0000 (UTC)
Received: from [10.72.13.103] (ovpn-13-103.pek2.redhat.com [10.72.13.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FAA960300;
        Sun, 26 Apr 2020 07:38:43 +0000 (UTC)
Subject: Re: [PATCH V2 1/2] vdpa: Support config interrupt in vhost_vdpa
To:     Zhu Lingshan <lingshan.zhu@linux.intel.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>, mst@redhat.com,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     lulu@redhat.com, dan.daly@intel.com, cunming.liang@intel.com
References: <1587881384-2133-1-git-send-email-lingshan.zhu@intel.com>
 <1587881384-2133-2-git-send-email-lingshan.zhu@intel.com>
 <055fb826-895d-881b-719c-228d0cc9a7bf@redhat.com>
 <e345cc85-aa9d-1173-8308-f0a301fca2b2@redhat.com>
 <fb51aa36-9a58-fd50-a4fa-4cc887357367@linux.intel.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <b34df002-344c-f011-dce0-fee882f62af2@redhat.com>
Date:   Sun, 26 Apr 2020 15:38:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <fb51aa36-9a58-fd50-a4fa-4cc887357367@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/4/26 =E4=B8=8B=E5=8D=883:24, Zhu Lingshan wrote:
>
>
> On 4/26/2020 3:03 PM, Jason Wang wrote:
>>
>> On 2020/4/26 =E4=B8=8B=E5=8D=882:58, Jason Wang wrote:
>>>>
>>>> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
>>>> index 1813821..8663139 100644
>>>> --- a/drivers/vhost/vhost.h
>>>> +++ b/drivers/vhost/vhost.h
>>>> @@ -18,6 +18,8 @@
>>>> =C2=A0 typedef void (*vhost_work_fn_t)(struct vhost_work *work);
>>>> =C2=A0 =C2=A0 #define VHOST_WORK_QUEUED 1
>>>> +#define VHOST_FILE_UNBIND -1
>>>
>>>
>>> I think it's better to document this in uapi.=20
>>
>>
>> I meant e.g in vhost_vring_file, we had a comment of unbinding:
>>
>> struct vhost_vring_file {
>> =C2=A0=C2=A0=C2=A0 unsigned int index;
>> =C2=A0=C2=A0=C2=A0 int fd; /* Pass -1 to unbind from file. */
>>
>> };
> I think it is better to use an int fd than vhost_vring_file, to avoid t=
he confusions,
> so if we add#define VHOST_FILE_UNBIND -1 in the uapi header, can it doc=
ument itself?
> Thanks


I think so.

Thanks


>>
>> Thanks
>>

