Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0BA143E49D
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbhJ1PLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:11:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59254 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231224AbhJ1PLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 11:11:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635433721;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KGUjOsKlPvctyYo7MwbILT0VMStj53cixSTDxOA1q+Y=;
        b=fzpeW8QS2eqRg6FEq2jwgxUBuL7EIibJElafzgjZRO3R0kRSR9hXDoysuxvN68uhg6Aq20
        RS8TkBB+RDQ99bxCGv0vAqX+kHyQffNvmyLqlHB7AnDuseW5o+oxEgrVl57b/auZ5ud/FH
        R/dRIv8n8qW597/JbgViy6Ly5ZZY9Wg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-569-n-pTxEjBOZScaxp0ncqPDQ-1; Thu, 28 Oct 2021 11:08:35 -0400
X-MC-Unique: n-pTxEjBOZScaxp0ncqPDQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 621AE802682;
        Thu, 28 Oct 2021 15:08:27 +0000 (UTC)
Received: from localhost (unknown [10.39.193.60])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 58A465C1B4;
        Thu, 28 Oct 2021 15:08:13 +0000 (UTC)
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
In-Reply-To: <20211027192345.GJ2744544@nvidia.com>
Organization: Red Hat GmbH
References: <87o87isovr.fsf@redhat.com>
 <20211021154729.0e166e67.alex.williamson@redhat.com>
 <20211025122938.GR2744544@nvidia.com>
 <20211025082857.4baa4794.alex.williamson@redhat.com>
 <20211025145646.GX2744544@nvidia.com>
 <20211026084212.36b0142c.alex.williamson@redhat.com>
 <20211026151851.GW2744544@nvidia.com>
 <20211026135046.5190e103.alex.williamson@redhat.com>
 <20211026234300.GA2744544@nvidia.com>
 <20211027130520.33652a49.alex.williamson@redhat.com>
 <20211027192345.GJ2744544@nvidia.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Thu, 28 Oct 2021 17:08:11 +0200
Message-ID: <87zgqtb31g.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Wed, Oct 27, 2021 at 01:05:20PM -0600, Alex Williamson wrote:

>> We're tossing around solutions that involve extensions, if not
>> changes to the uAPI.  It's Wednesday of rc7.
>
> The P2P issue is seperate, and as I keep saying, unless you want to
> block support for any HW that does not have freeze&queice userspace
> must be aware of this ability and it is logical to design it as an
> extension from where we are now.

I think the very fact that we're still discussing whether something
needs to be changed/documented or not already shows that this is nothing
that should go in right now. Actually, I'd already consider it too late
even if we agreed now; I would expect a change like this to get at least
two weeks in linux-next before the merge window.

>> > The "don't-break-userspace" is not an absolute prohibition, Linus has
>> > been very clear this limitation is about direct, ideally demonstrable,
>> > breakage to actually deployed software.
>> 
>> And if we introduce an open driver that unblocks QEMU support to become
>> non-experimental, I think that's where we stand.
>
> Yes, if qemu becomes deployed, but our testing shows qemu support
> needs a lot of work before it is deployable, so that doesn't seem to
> be an immediate risk.

Do you have any patches/problem reports you can share?

If you already identified that there is work to be done in QEMU, I think
that speaks even more for delaying this. What if we notice that uapi
changes are needed while fixing QEMU?

