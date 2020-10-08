Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9280E287D36
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 22:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbgJHUcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 16:32:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44773 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730465AbgJHUcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 16:32:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602189152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tpdXmRvgARTnY1If9z6ashQTu7MgRoRzw2/k90YmvbQ=;
        b=NJy2StpKyDQLlHkBZ2gT/KV2Qgk5q7sQXxpsl538I7a5xsY4GxxIbC19w8bbFIDPlLNNJh
        jWB/4K5FGGhMUd8y2gGHCivILJ96Ph3q6Dd7X1YZyIXKDfbNQRpUEli3pwwtOmrJvq+W2D
        5IPIvJ83q935Ia5tLTNv46OLFYib2zk=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-165-jdCbDsWNMAqfvvvEqvXw4Q-1; Thu, 08 Oct 2020 16:32:30 -0400
X-MC-Unique: jdCbDsWNMAqfvvvEqvXw4Q-1
Received: by mail-wr1-f71.google.com with SMTP id n14so836533wrp.1
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 13:32:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tpdXmRvgARTnY1If9z6ashQTu7MgRoRzw2/k90YmvbQ=;
        b=gyw0oFpJg4q3Zxtd/5pSYHx8kmhqZVjCDJDIf4bwkpo6/NPQJlQ7qUjnJ1YZGeqsYw
         KCJdY+U/8IYOrq7l+lnUKsreFiW3aPWIVU7rPWVCTGprUmjs5joSdvKthg7wkJvu9fyW
         Urv6W0/A+s2+/Oij5xTY6usbyRsKXdQPLuXwSSZjvjmAPIJV1cCuQ+iTmg62VfUyMsWr
         pZ9vClkFD1jQlUAeF0K4P0++LmWpvB9q8YzkDB3r7n4aP6zVm20+o/cIWX7Jc/C2yzdl
         ZuV7uYBQR/f0d045kHitNbm0JVEfscVCaqPzaE4lvtVQh0uMmB6bHHI4pRa+ingQSKuc
         2epw==
X-Gm-Message-State: AOAM530msHOMiDkLFyJTwJ1LFBQpEMxb/Y1096lVsiZo89xSK38AyZJo
        gbkQl1nQe30HTR56kC0eqn80hHH8H+M3PaC9rfOHwL/fkoWFsPf/lZMWFupb4hFs7HbooK5PJoS
        H8NV8mzmViy5Jt9bo
X-Received: by 2002:a1c:6457:: with SMTP id y84mr10281552wmb.36.1602189149157;
        Thu, 08 Oct 2020 13:32:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwQUG0KijlK+QL7Ax8XS9d5dAD0ojfOCzcq6UzOONYpRTIZTzyZtNzvqD6dDng76NlJsz1nrg==
X-Received: by 2002:a1c:6457:: with SMTP id y84mr10281528wmb.36.1602189148924;
        Thu, 08 Oct 2020 13:32:28 -0700 (PDT)
Received: from steredhat (host-79-27-201-176.retail.telecomitalia.it. [79.27.201.176])
        by smtp.gmail.com with ESMTPSA id o14sm8603590wmc.36.2020.10.08.13.32.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 13:32:28 -0700 (PDT)
Date:   Thu, 8 Oct 2020 22:32:25 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH] vringh: fix __vringh_iov() when riov and wiov are
 different
Message-ID: <20201008203225.7ndzfnpyxxntthtj@steredhat>
References: <20201008161311.114398-1-sgarzare@redhat.com>
 <20201008160035-mutt-send-email-mst@kernel.org>
 <20201008202436.r33jqbbttqynfvhe@steredhat>
 <20201008162813-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201008162813-mutt-send-email-mst@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 04:28:40PM -0400, Michael S. Tsirkin wrote:
> On Thu, Oct 08, 2020 at 10:24:36PM +0200, Stefano Garzarella wrote:
> > On Thu, Oct 08, 2020 at 04:00:51PM -0400, Michael S. Tsirkin wrote:
> > > On Thu, Oct 08, 2020 at 06:13:11PM +0200, Stefano Garzarella wrote:
> > > > If riov and wiov are both defined and they point to different
> > > > objects, only riov is initialized. If the wiov is not initialized
> > > > by the caller, the function fails returning -EINVAL and printing
> > > > "Readable desc 0x... after writable" error message.
> > > > 
> > > > Let's replace the 'else if' clause with 'if' to initialize both
> > > > riov and wiov if they are not NULL.
> > > > 
> > > > As checkpatch pointed out, we also avoid crashing the kernel
> > > > when riov and wiov are both NULL, replacing BUG() with WARN_ON()
> > > > and returning -EINVAL.
> > > > 
> > > > Fixes: f87d0fbb5798 ("vringh: host-side implementation of virtio rings.")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> > > 
> > > Can you add more detail please? when does this trigger?
> > 
> > I'm developing vdpa_sim_blk and I'm using vringh_getdesc_iotlb()
> > to get readable and writable buffers.
> > 
> > With virtio-blk devices a descriptors has both readable and writable
> > buffers (eg. virtio_blk_outhdr in the readable buffer and status as last byte
> > of writable buffer).
> > So, I'm calling vringh_getdesc_iotlb() one time to get both type of buffer
> > and put them in 2 iovecs:
> > 
> > 	ret = vringh_getdesc_iotlb(&vq->vring, &vq->riov, &vq->wiov,
> > 				   &vq->head, GFP_ATOMIC);
> > 
> > With this patch applied it works well, without the function fails
> > returning -EINVAL and printing "Readable desc 0x... after writable".
> > 
> > Am I using vringh_getdesc_iotlb() in the wrong way?
> > 
> > Thanks,
> > Stefano
> > 
> 
> 
> I think it's ok, this info just needs to be in the commit log ...

Sure, I'll send a v2 adding this info.
Sorry for not adding it earlier!

Thanks,
Stefano

