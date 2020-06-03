Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BA061EC99D
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 08:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgFCGg4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 02:36:56 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52504 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725878AbgFCGg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 02:36:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591166214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+HalrrKqGSueBtKvKRmc8aT/zyVC01O0BQfWrn8xLcA=;
        b=cXPSGu7MuhZVSqHUkDhPf7ZumLZNUW41Jg3B+o9oIPWiym44xXAwyUZkhVFhjvMvHMTWi2
        vNaVJ/qo7eeKCZ+n4TpWAzDmKZRktLv3VPoo4WqwdD5qWukHoQt9Kb8OMNAHNTaJ4bX8z5
        v1MIJUrY+Y9Nb/r22nQjSaYvgkGehWw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-gsJph4ZZOvOZ7HA47Jx5pg-1; Wed, 03 Jun 2020 02:36:53 -0400
X-MC-Unique: gsJph4ZZOvOZ7HA47Jx5pg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 286A3107ACF9;
        Wed,  3 Jun 2020 06:36:52 +0000 (UTC)
Received: from [10.72.12.214] (ovpn-12-214.pek2.redhat.com [10.72.12.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 245EE61984;
        Wed,  3 Jun 2020 06:36:47 +0000 (UTC)
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200602084257.134555-1-mst@redhat.com>
 <20200603014815.GR23230@ZenIV.linux.org.uk>
 <3358ae96-abb6-6be9-346a-0e971cb84dcd@redhat.com>
 <20200603041849.GT23230@ZenIV.linux.org.uk>
 <3e723db8-0d55-fae6-288e-9d95905592db@redhat.com>
 <20200603013600-mutt-send-email-mst@kernel.org>
 <b7de29fa-33f2-bbc1-08dc-d73b28e3ded5@redhat.com>
 <20200603022935-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <f0573536-e6cc-3f68-5beb-a53c8e1d0620@redhat.com>
Date:   Wed, 3 Jun 2020 14:36:46 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200603022935-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/3 下午2:30, Michael S. Tsirkin wrote:
> On Wed, Jun 03, 2020 at 02:23:08PM +0800, Jason Wang wrote:
>>> BTW now I re-read it I don't understand __vhost_get_user_slow:
>>>
>>>
>>> static void __user *__vhost_get_user_slow(struct vhost_virtqueue *vq,
>>>                                             void __user *addr, unsigned int size,
>>>                                             int type)
>>> {
>>>           int ret;
>>>
>>>           ret = translate_desc(vq, (u64)(uintptr_t)addr, size, vq->iotlb_iov,
>>>                                ARRAY_SIZE(vq->iotlb_iov),
>>>                                VHOST_ACCESS_RO);
>>>
>>> ..
>>> }
>>>
>>> how does this work? how can we cast a pointer to guest address without
>>> adding any offsets?
>>
>> I'm not sure I get you here. What kind of offset did you mean?
>>
>> Thanks
> OK so points:
>
> 1. type argument seems unused. Right?


Yes, we can remove that.


> 2. Second argument to translate_desc is a GPA, isn't it?


No, it's IOVA, this function will be called only when IOTLB is enabled.

Thanks


>     Here we cast a userspace address to this type. What if it
>     matches a valid GPA by mistake?
>

