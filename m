Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A2F4A98FC
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 13:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358557AbiBDMM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 07:12:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:25562 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241446AbiBDMM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 07:12:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643976745;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yZ4sk8q50ZTV8rKcA8E+/BfbQj64WFy5L6RAZRHT8z8=;
        b=OGsBWagfwTx0/wEJOqUzk3gPAOF/2T8wVKNj7HHaG6JQ0w6558IghnfFShtGaSEJzghxND
        CFbM0xchVd35EzZN6Zu/96tSRsCsBGVHI1hlyN2bsxDDU9Uzb07ZO4scaxKNKkfGIpFSRV
        6ecH5Pqz9WVf+zUuOHzRbCMgy6Pyaeo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-7oW6mt6LOG-DK6m5qaL82g-1; Fri, 04 Feb 2022 07:12:22 -0500
X-MC-Unique: 7oW6mt6LOG-DK6m5qaL82g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C169584DA41;
        Fri,  4 Feb 2022 12:12:20 +0000 (UTC)
Received: from localhost (unknown [10.39.194.13])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 63B254F854;
        Fri,  4 Feb 2022 12:12:11 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH V6 mlx5-next 08/15] vfio: Define device migration
 protocol v2
In-Reply-To: <20220202163656.4c0cc386.alex.williamson@redhat.com>
Organization: Red Hat GmbH
References: <20220130160826.32449-1-yishaih@nvidia.com>
 <20220130160826.32449-9-yishaih@nvidia.com>
 <20220131164318.3da9eae5.alex.williamson@redhat.com>
 <20220201003124.GZ1786498@nvidia.com>
 <20220201100408.4a68df09.alex.williamson@redhat.com>
 <20220201183620.GL1786498@nvidia.com>
 <20220201144916.14f75ca5.alex.williamson@redhat.com>
 <20220202002459.GP1786498@nvidia.com>
 <20220202163656.4c0cc386.alex.williamson@redhat.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Fri, 04 Feb 2022 13:12:09 +0100
Message-ID: <87o83mx23q.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 02 2022, Alex Williamson <alex.williamson@redhat.com> wrote:

> On Tue, 1 Feb 2022 20:24:59 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> On Tue, Feb 01, 2022 at 02:49:16PM -0700, Alex Williamson wrote:
>> > On Tue, 1 Feb 2022 14:36:20 -0400
>> > Jason Gunthorpe <jgg@nvidia.com> wrote:

>> > > I don't want to touch capabilities, but we can try to use feature for
>> > > set state. Please confirm this is what you want.  
>> > 
>> > It's a team sport, but to me it seems like it fits well both in my
>> > mental model of interacting with a device feature, without
>> > significantly altering the uAPI you're defining anyway.  
>> 
>> Well, my advice is that ioctls are fine, and a bit easier all around.
>> eg strace and syzkaller are a bit easier if everything neatly maps
>> into one struct per ioctl - their generator tools are optimized for
>> this common case.
>> 
>> Simple multiplexors are next-best-fine, but there should be a clear
>> idea when to use the multiplexer, or not.
>> 
>> Things like the cap chains enter a whole world of adventure for
>> strace/syzkaller :)
>
> vfio's argsz/flags is not only a standard framework, but it's one that
> promotes extensions.  We were able to add capability chains with
> backwards compatibility because of this design.  IMO, that's avoided
> ioctl sprawl; we've been able to maintain a fairly small set of core
> ioctls rather than add add a new ioctl every time we want to describe
> some new property of a device or region or IOMMU.  I think that
> improves the usability of the uAPI.  I certainly wouldn't want to
> program to a uAPI with a million ioctls.  A counter argument is that
> we're making the interface more complex, but at the same time we're
> adding shared infrastructure for dealing with that complexity.
>
> Of course we do continue to add new ioctls as necessary, including this
> FEATURE ioctl, and I recognize that with such a generic multiplexer we
> run the risk of over using it, ie. everything looks like a nail.  You
> initially did not see the fit for setting device state as interacting
> with a device feature, but it doesn't seem like you had a strong
> objection to my explanation of it in that context.
>
> So I think if the FEATURE ioctl has an ongoing place in our uAPI (using
> it to expose migration flags would seem to be a point in that
> direction) and it doesn't require too many contortions to think of the
> operation we're trying to perform on the device as interacting with a
> device FEATURE, and there are no functional or performance implications
> of it, I would think we should use it.  To do otherwise would suggest
> that we should consider the FEATURE ioctl a failed experiment and not
> continue to expand its use.
>
> I'd be interested to hear more input on this from the community.

My personal take would be: a new ioctl is more suitable for things that
may be implemented by different backends, but in a non-generic way, and
for mandatory functionality; the FEATURE ioctl is more suitable for
things that either are very specific to a certain backend (i.e. don't
reserve an ioctl for something that will only ever be used on one
platform), or for things that have a lot of commonality for the backends
that implement them (i.e. you are using a familiar scheme to interact
with them.)

From staring at the code and the discussion here for a bit (I have not
yet made my way through all of this except in a superficial way), I'd
lean more towards using FEATURE here.

