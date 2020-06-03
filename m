Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 598AC1EC8AC
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 07:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725927AbgFCFTE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 01:19:04 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37198 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725792AbgFCFTE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 01:19:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591161543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U4y5ym32341HQo9X5npUFfOgiDvZZD5UKodHu1egMPM=;
        b=fm+zQzqMfl+l/RfKgX1oojkd1a7xulycB6Tt140yYBAMId0WoZt8hygAAFCMoNkhY1QXK1
        T3o1F+P5amKVQjrsbX3o9TDYPxe0yG3wwfsPpmPzTZB7VRNuNphjYvtBLygZ62bacH24Mb
        gOLht/FL9E95M2pmcXToS1dwBlJ/o5U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-43-yh5avZzhNiCbBSHTL9WXfw-1; Wed, 03 Jun 2020 01:19:01 -0400
X-MC-Unique: yh5avZzhNiCbBSHTL9WXfw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B09239347;
        Wed,  3 Jun 2020 05:19:00 +0000 (UTC)
Received: from [10.72.12.214] (ovpn-12-214.pek2.redhat.com [10.72.12.214])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E2B019C4F;
        Wed,  3 Jun 2020 05:18:56 +0000 (UTC)
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <20200602084257.134555-1-mst@redhat.com>
 <20200603014815.GR23230@ZenIV.linux.org.uk>
 <3358ae96-abb6-6be9-346a-0e971cb84dcd@redhat.com>
 <20200603041849.GT23230@ZenIV.linux.org.uk>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <3e723db8-0d55-fae6-288e-9d95905592db@redhat.com>
Date:   Wed, 3 Jun 2020 13:18:54 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200603041849.GT23230@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2020/6/3 下午12:18, Al Viro wrote:
> On Wed, Jun 03, 2020 at 11:57:11AM +0800, Jason Wang wrote:
>
>>> How widely do you hope to stretch the user_access areas, anyway?
>>
>> To have best performance for small packets like 64B, if possible, we want to
>> disable STAC not only for the metadata access done by vhost accessors but
>> also the data access via iov iterator.
> If you want to try and convince Linus to go for that, make sure to Cc
> me on that thread.  Always liked quality flame...
>
> The same goes for interval tree lookups with uaccess allowed.  IOW, I _really_
> doubt that it's a good idea.


I see. We are just seeking an approach to perform better in order to 
compete with userspace dpdk backends.

I tried another approach of using direct mapping + mmu notifier [1] but 
the synchronization with MMU notifier is not easy to perform well.

[1] https://patchwork.kernel.org/patch/11133009/


>
>>> Incidentally, who had come up with the name __vhost_get_user?
>>> Makes for lovey WTF moment for readers - esp. in vhost_put_user()...
>>
>> I think the confusion comes since it does not accept userspace pointer (when
>> IOTLB is enabled).
>>
>> How about renaming it as vhost_read()/vhost_write() ?
> Huh?
>
> __vhost_get_user() is IOTLB remapping of userland pointer.  It does not access
> userland memory.  Neither for read, nor for write.  It is used by vhost_get_user()
> and vhost_put_user().
>
> Why would you want to rename it into vhost_read _or_ vhost_write, and in any case,
> how do you give one function two names?  IDGI...


I get you know, I thought you're concerning the names of 
vhost_get_user()/vhost_put_user() but actually __vhost_get_user().

Maybe something like __vhost_fetch_uaddr() is better.

Thanks


>

