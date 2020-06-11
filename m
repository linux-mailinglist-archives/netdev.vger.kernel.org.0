Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5661F6045
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 05:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgFKDDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 23:03:09 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:27523 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726312AbgFKDDH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 23:03:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591844586;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pW0TC9adqhgXolpM+bqi6ACajbaD8dcdKR1gGXD2XZ8=;
        b=CPVVxfYGOTPOobCZqLEd74yuGdw6YQDaK1zYzktJTUjxQJt3tv5cQKRgTqz9FRRumvwfhr
        n0Rsk3ZSCNCQATWH38EuTLuosjiYYm1mMeO4yfRwvmwqlViu6O7hrZhVFH+LRkJlHpycFA
        wWOQ2Rh9OL9nxkadX+kEbIJ8DG00Wks=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-400-0vO_5UApMFapwqJRy4-PSw-1; Wed, 10 Jun 2020 23:03:04 -0400
X-MC-Unique: 0vO_5UApMFapwqJRy4-PSw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3A5A97BBE;
        Thu, 11 Jun 2020 03:03:03 +0000 (UTC)
Received: from [10.72.12.125] (ovpn-12-125.pek2.redhat.com [10.72.12.125])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9CBBA8929C;
        Thu, 11 Jun 2020 03:02:58 +0000 (UTC)
Subject: Re: [PATCH RFC v6 02/11] vhost: use batched get_vq_desc version
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        eperezma@redhat.com
References: <20200608125238.728563-1-mst@redhat.com>
 <20200608125238.728563-3-mst@redhat.com>
 <81904cc5-b662-028d-3b4a-bdfdbd2deb8c@redhat.com>
 <20200610070259-mutt-send-email-mst@kernel.org>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <76b14132-407a-48bf-c4d5-9d0b2c700bb0@redhat.com>
Date:   Thu, 11 Jun 2020 11:02:57 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200610070259-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/10 下午7:05, Michael S. Tsirkin wrote:
>>> +EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
>>>    /* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
>>>    void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
>>>    {
>>> +	unfetch_descs(vq);
>>>    	vq->last_avail_idx -= n;
>> So unfetch_descs() has decreased last_avail_idx.
>> Can we fix this by letting unfetch_descs() return the number and then we can
>> do:
>>
>> int d = unfetch_descs(vq);
>> vq->last_avail_idx -= (n > d) ? n - d: 0;
>>
>> Thanks
> That's intentional I think - we need both.


Yes, but:


>
> Unfetch_descs drops the descriptors in the cache that were
> *not returned to caller*  through get_vq_desc.
>
> vhost_discard_vq_desc drops the ones that were returned through get_vq_desc.
>
> Did I miss anything?

We could count some descriptors twice, consider the case e.g we only 
cache on descriptor:

fetch_descs()
     fetch_buf()
         last_avail_idx++;

Then we want do discard it:
vhost_discard_avail_buf(1)
     unfetch_descs()
         last_avail_idx--;
     last_avail_idx -= 1;

Thanks

