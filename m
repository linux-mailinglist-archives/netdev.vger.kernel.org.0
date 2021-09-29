Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADDC341CFD8
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 01:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347517AbhI2XWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 19:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347505AbhI2XWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 19:22:53 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF54C06176C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 16:21:11 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id dk4so2515643qvb.2
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 16:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vURlTPvciLNHVwm+qpgsVwGxUhwNfUJPxfecQWzYJYA=;
        b=Zj4wWBdj3VdNHSQijjwB6d/B3Z0yaCN8DLkQcxtzl1osWudJFB0cEUVGPKm3xAsaSO
         HAOWJFSL0bavVQUI0mkFRIWZCyMFsO+STG0IJHU/nSxslRhlvXPgAxlcy+Ci6caw+Z6d
         qgJ9x+zAprvCKR0pseEjjuHFnYOORSg847Q4TTGYP+yH+tG3MwHf/9b7whw+grtiqA1M
         znK7SI7VWx2TjKhDixK8WX2KKNeL4YOkI2oMVStoZVnsQm2iJzHjHx8UMmMVmhJTS/Ka
         QqWnrgWcNOccgipN9UllCHzX852wNHqdchB2nxleAJaYT7DDZN85NjS6IiTjaZw5impT
         tdBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vURlTPvciLNHVwm+qpgsVwGxUhwNfUJPxfecQWzYJYA=;
        b=rugzX7onegy4BeDC+ie5rBk4D5LfRoC7pT/ij3eeyNTACBtw++0+9yEk4S9bE7kG4Q
         ZDIwhX7B7gv4TxcS4thSsnCOoTCR1vtOkj0/0ftVw+7gpLoJjDmOt29W0XzocHxImOsm
         Q9rppaGY7uzxJC2eV8nYCFv6bPKVrk/i9JB2Ik1wkpLM9i3BJ0RJZXZt8+6pNYXbqvRJ
         grppTlM7opu2BQouPrkd1l41vw8RLI0p1i/xSjRKlc3kRspHkNEvZ5dKbb28F7iSqmES
         rt47WWR9JRSaZNjhJ1ptDAGkwwOeXCMKoz4iKep9RGhiwna/nUZg/NTUWKfjqRpEyvxo
         9R6w==
X-Gm-Message-State: AOAM533FFT+eLzlliyiKzrd2GxMOpA3vmwavYAV/hMcPoBAJoV/PLH1m
        pAB3W8AkOKMP4roV3V9nWbSxOw==
X-Google-Smtp-Source: ABdhPJwA55qGt9RWeuL6e34LCWU3u3YFVjjxfHPaXpdwUVW8hGe1+xdfhpM0nZTosoDMpP4WenkAkw==
X-Received: by 2002:a0c:c2c4:: with SMTP id c4mr2519771qvi.30.1632957670497;
        Wed, 29 Sep 2021 16:21:10 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id i11sm469774qki.28.2021.09.29.16.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 16:21:10 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mVisv-007ihB-2W; Wed, 29 Sep 2021 20:21:09 -0300
Date:   Wed, 29 Sep 2021 20:21:09 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Max Gurtovoy <mgurtovoy@nvidia.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kirti Wankhede <kwankhede@nvidia.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH mlx5-next 2/7] vfio: Add an API to check migration state
 transition validity
Message-ID: <20210929232109.GC3544071@ziepe.ca>
References: <20210927231239.GE3544071@ziepe.ca>
 <25c97be6-eb4a-fdc8-3ac1-5628073f0214@nvidia.com>
 <20210929063551.47590fbb.alex.williamson@redhat.com>
 <1eba059c-4743-4675-9f72-1a26b8f3c0f6@nvidia.com>
 <20210929075019.48d07deb.alex.williamson@redhat.com>
 <d2e94241-a146-c57d-cf81-8b7d8d00e62d@nvidia.com>
 <20210929091712.6390141c.alex.williamson@redhat.com>
 <e1ba006f-f181-0b89-822d-890396e81c7b@nvidia.com>
 <20210929161433.GA1808627@ziepe.ca>
 <29835bf4-d094-ae6d-1a32-08e65847b52c@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29835bf4-d094-ae6d-1a32-08e65847b52c@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 12:48:55AM +0300, Max Gurtovoy wrote:
> 
> On 9/29/2021 7:14 PM, Jason Gunthorpe wrote:
> > On Wed, Sep 29, 2021 at 06:28:44PM +0300, Max Gurtovoy wrote:
> > 
> > > > So you have a device that's actively modifying its internal state,
> > > > performing I/O, including DMA (thereby dirtying VM memory), all while
> > > > in the _STOP state?  And you don't see this as a problem?
> > > I don't see how is it different from vfio-pci situation.
> > vfio-pci provides no way to observe the migration state. It isn't
> > "000b"
> 
> Alex said that there is a problem of compatibility.

Yes, when a vfio_device first opens it must be running - ie able to do
DMA and otherwise operational.

When we add the migration extension this cannot change, so after
open_device() the device should be operational.

The reported state in the migration region should accurately reflect
what the device is currently doing. If the device is operational then
it must report running, not stopped.

Thus a driver cannot just zero initalize the migration "registers",
they have to be accurate.

> > > Maybe we need to rename STOP state. We can call it READY or LIVE or
> > > NON_MIGRATION_STATE.
> > It was a poor choice to use 000b as stop, but it doesn't really
> > matter. The mlx5 driver should just pre-init this readable to running.
> 
> I guess we can do it for this reason. There is no functional problem nor
> compatibility issue here as was mentioned.
> 
> But still we need the kernel to track transitions. We don't want to allow
> moving from RESUMING to SAVING state for example. How this transition can be
> allowed ?

It seems semantically fine to me, as per Alex's note what will happen
is defined:

driver will see RESUMING toggle off so it will trigger a
de-serialization

driver will see SAVING toggled on so it will serialize the new state
(either the pre-copy state or the post-copy state dpending on the
running bit)

Depending on the running bit the device may or may not be woken up.

If de-serialization fails then the state goes to error and SAVING is
ignored.

The driver logic probably looks something like this:

// Running toggles off
if (oldstate & RUNNING != newstate & RUNNING && oldstate & RUNNING)
    queice
    freeze

// Resuming toggles off
if (oldstate & RESUMING != newstate & RESUMING && oldstate & RESUMING)
   deserialize

// Saving toggles on
if (oldstate & SAVING != newstate & SAVING && newstate & SAVING)
   if (!(newstate & RUNNING))
     serialize post copy

// Running toggles on
if (oldstate & RUNNING != newstate & RUNNING && newstate & RUNNING)
   unfreeze
   unqueice

I'd have to check that carefully against the state chart from my last
email though..

And need to check how the "Stop Active Transactions" bit fits in there

Jason
