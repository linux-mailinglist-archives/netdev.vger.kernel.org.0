Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBD01EC823
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 05:57:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726142AbgFCD5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 23:57:23 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42987 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725909AbgFCD5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 23:57:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591156640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UyDIdDugCgBr44CrPYBWsuEUV5F9G8QEY0u0WtGA1tw=;
        b=Fg3Q1c1vRn5bnLpMrv508AArwnE0R8hSupIERvCIKxY+ItqUQ8q/mAgJwkBz3QP6bZxtmi
        Ai0vkQZs01YjXeTNJSmxGNpUAEK9+rB3lJeCisYRSE+cPUqWXCAjJXU0FPqDPnBgZoSdqW
        iNrP+gBmr/5WUVbQD9PP0YPJEXPu0K0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-maRQScxMM7ay19yJgDRIDg-1; Tue, 02 Jun 2020 23:57:18 -0400
X-MC-Unique: maRQScxMM7ay19yJgDRIDg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 14B801800D42;
        Wed,  3 Jun 2020 03:57:17 +0000 (UTC)
Received: from [10.72.12.214] (ovpn-12-214.pek2.redhat.com [10.72.12.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBA9210013C3;
        Wed,  3 Jun 2020 03:57:12 +0000 (UTC)
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
To:     Al Viro <viro@zeniv.linux.org.uk>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20200602084257.134555-1-mst@redhat.com>
 <20200603014815.GR23230@ZenIV.linux.org.uk>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3358ae96-abb6-6be9-346a-0e971cb84dcd@redhat.com>
Date:   Wed, 3 Jun 2020 11:57:11 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200603014815.GR23230@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/3 上午9:48, Al Viro wrote:
> On Tue, Jun 02, 2020 at 04:45:05AM -0400, Michael S. Tsirkin wrote:
>> So vhost needs to poke at userspace *a lot* in a quick succession.  It
>> is thus benefitial to enable userspace access, do our thing, then
>> disable. Except access_ok has already been pre-validated with all the
>> relevant nospec checks, so we don't need that.  Add an API to allow
>> userspace access after access_ok and barrier_nospec are done.
> BTW, what are you going to do about vq->iotlb != NULL case?  Because
> you sure as hell do *NOT* want e.g. translate_desc() under STAC.
> Disable it around the calls of translate_desc()?


translate_desc() itself doesn't do userspace access, so the idea is 
probably disabling STAC around a batch of vhost_get_uesr()/vhost_put_user().


>
> How widely do you hope to stretch the user_access areas, anyway?


To have best performance for small packets like 64B, if possible, we 
want to disable STAC not only for the metadata access done by vhost 
accessors but also the data access via iov iterator.


>
> BTW, speaking of possible annotations: looks like there's a large
> subset of call graph that can be reached only from vhost_worker()
> or from several ioctls, with all uaccess limited to that subgraph
> (thankfully).  Having that explicitly marked might be a good idea...
>
> Unrelated question, while we are at it: is there any point having
> vhost_get_user() a polymorphic macro?  In all callers the third
> argument is __virtio16 __user * and the second one is an explicit
> *<something> where <something> is __virtio16 *.  Similar for
> vhost_put_user(): in all callers the third arugment is
> __virtio16 __user * and the second - cpu_to_vhost16(vq, something).


This is because all virtqueue metadata that needs to be accessed 
atomically is __virtio16 now, but this may not be true for future virtio 
extension.


>
> Incidentally, who had come up with the name __vhost_get_user?
> Makes for lovey WTF moment for readers - esp. in vhost_put_user()...


I think the confusion comes since it does not accept userspace pointer 
(when IOTLB is enabled).

How about renaming it as vhost_read()/vhost_write() ?

Thanks

>

