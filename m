Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC4A435E09
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 11:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231489AbhJUJgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 05:36:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22810 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231446AbhJUJgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 05:36:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634808856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BgYp1wM9v5szx8eQy5srhotQAwAp3AJGV5n1/wdRCz0=;
        b=TwnuhnSoQtn4OmWgHPfjambMExrD53Z1+Tbhj7WBVwPVmX61LWLm8w55O067XKooBGpWDu
        By/+G76Ov2WaxlOdUck54R7docBljGFIL+svNSh7a1PHKxSfM7YWpDbJRgI6tJ5qWgEedd
        ZWaxAnjvtCUCiPTFR8WaAhWWl5fFk+E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-d2QqRd5lNGaafCMkpoMi7A-1; Thu, 21 Oct 2021 05:34:13 -0400
X-MC-Unique: d2QqRd5lNGaafCMkpoMi7A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 466F7362FA;
        Thu, 21 Oct 2021 09:34:11 +0000 (UTC)
Received: from localhost (unknown [10.39.193.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CBD55E2CD;
        Thu, 21 Oct 2021 09:34:02 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
In-Reply-To: <20211020150709.7cff2066.alex.williamson@redhat.com>
Organization: Red Hat GmbH
References: <20211019105838.227569-1-yishaih@nvidia.com>
 <20211019105838.227569-13-yishaih@nvidia.com>
 <20211019124352.74c3b6ba.alex.williamson@redhat.com>
 <20211019192328.GZ2744544@nvidia.com>
 <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
 <20211019230431.GA2744544@nvidia.com>
 <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
 <20211020105230.524e2149.alex.williamson@redhat.com>
 <20211020185919.GH2744544@nvidia.com>
 <20211020150709.7cff2066.alex.williamson@redhat.com>
User-Agent: Notmuch/0.32.1 (https://notmuchmail.org)
Date:   Thu, 21 Oct 2021 11:34:00 +0200
Message-ID: <87o87isovr.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 20 2021, Alex Williamson <alex.williamson@redhat.com> wrote:

> On Wed, 20 Oct 2021 15:59:19 -0300
> Jason Gunthorpe <jgg@nvidia.com> wrote:
>
>> On Wed, Oct 20, 2021 at 10:52:30AM -0600, Alex Williamson wrote:
>> 
>> > I'm wondering if we're imposing extra requirements on the !_RUNNING
>> > state that don't need to be there.  For example, if we can assume that
>> > all devices within a userspace context are !_RUNNING before any of the
>> > devices begin to retrieve final state, then clearing of the _RUNNING
>> > bit becomes the device quiesce point and the beginning of reading
>> > device data is the point at which the device state is frozen and
>> > serialized.  No new states required and essentially works with a slight
>> > rearrangement of the callbacks in this series.  Why can't we do that?  
>> 
>> It sounds worth checking carefully. I didn't come up with a major
>> counter scenario.
>> 
>> We would need to specifically define which user action triggers the
>> device to freeze and serialize. Reading pending_bytes I suppose?
>
> The first read of pending_bytes after clearing the _RUNNING bit would
> be the logical place to do this since that's what we define as the start
> of the cycle for reading the device state.
>
> "Freezing" the device is a valid implementation, but I don't think it's
> strictly required per the uAPI.  For instance there's no requirement
> that pending_bytes is reduced by data_size on each iteratio; we
> specifically only define that the state is complete when the user reads
> a pending_bytes value of zero.  So a driver could restart the device
> state if the device continues to change (though it's debatable whether
> triggering an -errno on the next migration region access might be a
> more supportable approach to enforce that userspace has quiesced
> external access).

Hm, not so sure. From my reading of the uAPI, transitioning from
pre-copy to stop-and-copy (i.e. clearing _RUNNING) implies that we
freeze the device (at least, that's how I interpret "On state transition
from pre-copy to stop-and-copy, the driver must stop the device, save
the device state and send it to the user application through the
migration region.")

Maybe the uAPI is simply not yet clear enough.

