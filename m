Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09D161EDCF5
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 08:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgFDGKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 02:10:42 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:47384 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726683AbgFDGKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 02:10:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591251039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=spuln8OM2+pVMSm6QcNLxZDaud+7HSx0EW1bt/tNWEk=;
        b=MCijP08ima0bYx5d+bBh2AR3YSjBepOxdOX9B5wCWUscALsBlQ1T38vJhbCYWA4IKjdil0
        TMrehH75DzWUnoCVyIFfvLogLodL6znq8+FCX5OgGmTYQK/XGIC6KFqgwZf8WE/X7BV6ly
        Ol7kYt2HfoGPWYfAIXO9tFoZbncm4qY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-346-U7aO9fZrPSCuhDk-WhhKeA-1; Thu, 04 Jun 2020 02:10:38 -0400
X-MC-Unique: U7aO9fZrPSCuhDk-WhhKeA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3AA0B108BD0D;
        Thu,  4 Jun 2020 06:10:37 +0000 (UTC)
Received: from [10.72.13.104] (ovpn-13-104.pek2.redhat.com [10.72.13.104])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5D234DA21;
        Thu,  4 Jun 2020 06:10:28 +0000 (UTC)
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
To:     Al Viro <viro@zeniv.linux.org.uk>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20200602084257.134555-1-mst@redhat.com>
 <20200603014815.GR23230@ZenIV.linux.org.uk>
 <20200603011810-mutt-send-email-mst@kernel.org>
 <20200603165205.GU23230@ZenIV.linux.org.uk>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ec086f7b-be01-5ffd-6fc3-f865d26b0daf@redhat.com>
Date:   Thu, 4 Jun 2020 14:10:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200603165205.GU23230@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/4 上午12:52, Al Viro wrote:
> On Wed, Jun 03, 2020 at 01:29:00AM -0400, Michael S. Tsirkin wrote:
>> On Wed, Jun 03, 2020 at 02:48:15AM +0100, Al Viro wrote:
>>> On Tue, Jun 02, 2020 at 04:45:05AM -0400, Michael S. Tsirkin wrote:
>>>> So vhost needs to poke at userspace *a lot* in a quick succession.  It
>>>> is thus benefitial to enable userspace access, do our thing, then
>>>> disable. Except access_ok has already been pre-validated with all the
>>>> relevant nospec checks, so we don't need that.  Add an API to allow
>>>> userspace access after access_ok and barrier_nospec are done.
>>> BTW, what are you going to do about vq->iotlb != NULL case?  Because
>>> you sure as hell do *NOT* want e.g. translate_desc() under STAC.
>>> Disable it around the calls of translate_desc()?
>>>
>>> How widely do you hope to stretch the user_access areas, anyway?
>> So ATM I'm looking at adding support for the packed ring format.
>> That does something like:
>>
>> get_user(flags, desc->flags)
>> smp_rmb()
>> if (flags & VALID)
>> copy_from_user(&adesc, desc, sizeof adesc);
>>
>> this would be a good candidate I think.
> Perhaps, once we get stac/clac out of raw_copy_from_user() (coming cycle,
> probably).  BTW, how large is the structure and how is it aligned?


Each descriptor is 16 bytes, and 16 bytes aligned.


>
>>> BTW, speaking of possible annotations: looks like there's a large
>>> subset of call graph that can be reached only from vhost_worker()
>>> or from several ioctls, with all uaccess limited to that subgraph
>>> (thankfully).  Having that explicitly marked might be a good idea...
>> Sure. What's a good way to do that though? Any examples to follow?
>> Or do you mean code comments?
> Not sure...  FWIW, the part of call graph from "known to be only
> used by vhost_worker" (->handle_kick/vhost_work_init callback/
> vhost_poll_init callback) and "part of ->ioctl()" to actual uaccess
> primitives is fairly large - the longest chain is
> handle_tx_net ->
>    handle_tx ->
>      handle_tx_zerocopy ->
>        get_tx_bufs ->
> 	vhost_net_tx_get_vq_desc ->
> 	  vhost_tx_batch ->
> 	    vhost_net_signal_used ->
> 	      vhost_add_used_and_signal_n ->
> 		vhost_signal ->
> 		  vhost_notify ->
> 		    vhost_get_avail_flags ->
> 		      vhost_get_avail ->
> 			vhost_get_user ->
> 			  __get_user()
> i.e. 14 levels deep and the graph doesn't factorize well...
>
> Something along the lines of "all callers of thus annotated function
> must be annotated the same way themselves, any implicit conversion
> of pointers to such functions to anything other than boolean yields
> a warning, explicit cast is allowed only with __force", perhaps?
> Then slap such annotations on vhost_{get,put,copy_to,copy_from}_user(),
> on ->handle_kick(), a force-cast in the only caller of ->handle_kick()
> and force-casts in the 3 callers in ->ioctl().
>
> And propagate the annotations until the warnings stop, basically...
>
> Shouldn't be terribly hard to teach sparse that kind of stuff and it
> might be useful elsewhere.  It would act as a qualifier on function
> pointers, with syntax ultimately expanding to __attribute__((something)).
> I'll need to refresh my memories of the parser, but IIRC that shouldn't
> require serious modifications.  Most of the work would be in
> evaluate_call(), just before calling evaluate_symbol_call()...
> I'll look into that; not right now, though.
>
> BTW, __vhost_get_user() might be better off expanded in both callers -
> that would get their structure similar to vhost_copy_{to,from}_user(),
> especially if you expand __vhost_get_user_slow() as well.
>
> Not sure I understand what's going with ->meta_iotlb[] - what are the
> lifetime rules for struct vhost_iotlb_map


It used to cache the translation for virtqueue address which. Vhost will 
try to get those addresses from IOTLB and store them in meta_iotlb, and 
it will be invalidated when userspace update or invalidate a new mapping.


> and what prevents the pointers
> from going stale?
>
>

The vq->mutex is used to synchronize between the invalidation and vhost 
workers.

Thanks


