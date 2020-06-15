Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A51F21F8C50
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 04:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727971AbgFOCn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 22:43:57 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47368 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728156AbgFOCn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Jun 2020 22:43:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592189035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CDf2ubutxAR6PnZDzVX0vkP0DzBLtkr2OZNFYDY7Wa0=;
        b=Lm8sBwmkjyUg7ewEL7lAv8lZvu1jJbblWuMJLPH2f+Z0VzHh0hqlA259BDeiqaOHyMvFku
        LhQJ/Zsg89sDy8zRe1Dy6onUZdM5R6rOYTYZdHH48HUX+IssebQxaaCTcWzLZh6cyDukxb
        7Kbd5w3rbA383VLVYvFeqwvM5eu5dD4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-zrMBqGQyM0aTkj5DQlI_rw-1; Sun, 14 Jun 2020 22:43:51 -0400
X-MC-Unique: zrMBqGQyM0aTkj5DQlI_rw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D412108BD1A;
        Mon, 15 Jun 2020 02:43:50 +0000 (UTC)
Received: from [10.72.13.232] (ovpn-13-232.pek2.redhat.com [10.72.13.232])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 602001A91F;
        Mon, 15 Jun 2020 02:43:44 +0000 (UTC)
Subject: Re: [PATCH RFC v6 02/11] vhost: use batched get_vq_desc version
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        eperezma@redhat.com
References: <20200608125238.728563-1-mst@redhat.com>
 <20200608125238.728563-3-mst@redhat.com>
 <81904cc5-b662-028d-3b4a-bdfdbd2deb8c@redhat.com>
 <20200610070259-mutt-send-email-mst@kernel.org>
 <76b14132-407a-48bf-c4d5-9d0b2c700bb0@redhat.com>
 <20200611050416-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <be533349-817c-925b-43e4-899185d3fb1a@redhat.com>
Date:   Mon, 15 Jun 2020 10:43:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200611050416-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/11 下午5:06, Michael S. Tsirkin wrote:
> On Thu, Jun 11, 2020 at 11:02:57AM +0800, Jason Wang wrote:
>> On 2020/6/10 下午7:05, Michael S. Tsirkin wrote:
>>>>> +EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
>>>>>     /* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
>>>>>     void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
>>>>>     {
>>>>> +	unfetch_descs(vq);
>>>>>     	vq->last_avail_idx -= n;
>>>> So unfetch_descs() has decreased last_avail_idx.
>>>> Can we fix this by letting unfetch_descs() return the number and then we can
>>>> do:
>>>>
>>>> int d = unfetch_descs(vq);
>>>> vq->last_avail_idx -= (n > d) ? n - d: 0;
>>>>
>>>> Thanks
>>> That's intentional I think - we need both.
>>
>> Yes, but:
>>
>>
>>> Unfetch_descs drops the descriptors in the cache that were
>>> *not returned to caller*  through get_vq_desc.
>>>
>>> vhost_discard_vq_desc drops the ones that were returned through get_vq_desc.
>>>
>>> Did I miss anything?
>> We could count some descriptors twice, consider the case e.g we only cache
>> on descriptor:
>>
>> fetch_descs()
>>      fetch_buf()
>>          last_avail_idx++;
>>
>> Then we want do discard it:
>> vhost_discard_avail_buf(1)
>>      unfetch_descs()
>>          last_avail_idx--;
>>      last_avail_idx -= 1;
>>
>> Thanks
>
> I don't think that happens. vhost_discard_avail_buf(1) is only called
> after get vhost_get_avail_buf. vhost_get_avail_buf increments
> first_desc.  unfetch_descs only counts from first_desc to ndescs.
>
> If I'm wrong, could you show values of first_desc and ndescs in this
> scenario?


You're right, fetch_descriptor could not be called directly from the 
device code.

Thanks


>

