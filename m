Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2AB343F78F
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 08:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbhJ2G75 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 02:59:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24724 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230252AbhJ2G75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 02:59:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635490648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cQF2iybsKe07ABE2xFPcoTYM3asQ9j2T8k98hrrVDhQ=;
        b=dm3+45ATjF1tinzJjww9YBxNLGB/nMWvNiKzyNuOnCEI0ZeiTZ2XsCMa6ybzii1p3LRZiD
        QO/8E+gLpyw0WZAT9IZ2KhyjwUOn3R/L3YVstPIg7iWvEi+hVuy4k/mUHGgw1Li7lcfGel
        vh/Gp9lJFnCz7hcO5ml/rQDBrf8Csxk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-273-58kkhGUmODC_8Ly-J_2RZw-1; Fri, 29 Oct 2021 02:57:24 -0400
X-MC-Unique: 58kkhGUmODC_8Ly-J_2RZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6DEF91926DA0;
        Fri, 29 Oct 2021 06:57:22 +0000 (UTC)
Received: from localhost (unknown [10.39.193.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E00E10016F5;
        Fri, 29 Oct 2021 06:57:18 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
In-Reply-To: <20211028234750.GP2744544@nvidia.com>
Organization: Red Hat GmbH
References: <20211025122938.GR2744544@nvidia.com>
 <20211025082857.4baa4794.alex.williamson@redhat.com>
 <20211025145646.GX2744544@nvidia.com>
 <20211026084212.36b0142c.alex.williamson@redhat.com>
 <20211026151851.GW2744544@nvidia.com>
 <20211026135046.5190e103.alex.williamson@redhat.com>
 <20211026234300.GA2744544@nvidia.com>
 <20211027130520.33652a49.alex.williamson@redhat.com>
 <20211027192345.GJ2744544@nvidia.com>
 <20211028093035.17ecbc5d.alex.williamson@redhat.com>
 <20211028234750.GP2744544@nvidia.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Fri, 29 Oct 2021 08:57:16 +0200
Message-ID: <87wnlwb9o3.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Oct 28, 2021 at 09:30:35AM -0600, Alex Williamson wrote:
>> On Wed, 27 Oct 2021 16:23:45 -0300
>> Jason Gunthorpe <jgg@nvidia.com> wrote:
>> 
>> > On Wed, Oct 27, 2021 at 01:05:20PM -0600, Alex Williamson wrote:
>> > 
>> > > > As far as the actual issue, if you hadn't just discovered it now
>> > > > nobody would have known we have this gap - much like how the very
>> > > > similar reset issue was present in VFIO for so many years until you
>> > > > plugged it.  
>> > > 
>> > > But the fact that we did discover it is hugely important.  We've
>> > > identified that the potential use case is significantly limited and
>> > > that userspace doesn't have a good mechanism to determine when to
>> > > expose that limitation to the user.    
>> > 
>> > Huh?
>> > 
>> > We've identified that, depending on device behavior, the kernel may
>> > need to revoke MMIO access to protect itself from hostile userspace
>> > triggering TLP Errors or something.
>> > 
>> > Well behaved userspace must already stop touching the MMIO on the
>> > device when !RUNNING - I see no compelling argument against that
>> > position.
>> 
>> Not touching MMIO is not specified in our uAPI protocol,
>
> To be frank, not much is specified in the uAPI comment, certainly not
> a detailed meaning of RUNNING.

Yes! And I think that means we need to improve that comment before the
first in-tree driver to use it is merged, just to make sure we all agree
on the protocol, and future drivers can rely on that understanding as
well.

