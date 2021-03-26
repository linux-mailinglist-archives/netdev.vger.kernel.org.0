Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C064134AC25
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 17:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhCZQBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 12:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbhCZQBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 12:01:01 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27F3C0613AA;
        Fri, 26 Mar 2021 09:01:01 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id e8so5886661iok.5;
        Fri, 26 Mar 2021 09:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=E2TCKjuLN/4jPfDhhcTLou03NC73YmegiWP7q9K8hcg=;
        b=Y+IJ6Xq/yNPgybxocBva9vcpVkYhsWOJt9n1A1YhDxQxW6NBJOEOnkphVYLzgddtVc
         O5Nd8Ti9uR0nbqauVqfvnJ4sqb6lermAqvaG8aPqI2UnWLIQHOn2yZUV/EGquTF8cenl
         iaEcgPYof2e7Z0pI2LcI8ftCSX4pFTubIkNMrV3NvJZPxNGQAk+juoPBH/IGjWjnUql9
         9POU1uzA6sVMySIWts1hx2uKRo1H/dXHtHaFjkY7Jb0CmSwo9H4VhnAxppLnsFsCwH5h
         bjtWMVcAPbQSdkrkPYl30oQNpeMl6IDUYlnuLM8iSZwWyY3nE/1RgZbn7Pf9X1pAsdxP
         h2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=E2TCKjuLN/4jPfDhhcTLou03NC73YmegiWP7q9K8hcg=;
        b=rLXKmozGtv3IzL2nJUNgYOC1j50q/CmBpbZFmM2ywTB4n6vO8GW3sHGggsAKfvDJTr
         Nc/LEibv77w76zwnsZcE8M7uXL80bGBNvXYm7pONaQ1zZM6IFRmJtKZhWhm9UeYUC5XX
         TKwZa1emd+4ZB9dI9jLBmmLRFI99NVNrEkNb42Qvi5NkgMnoe1A/uE/ON6JDkIHKZ4qh
         pramZoxDEgVkeKkiMTdbzaiC8tBeoFCoL+Vn8R5+4MB79Ntus7GZFziecpeXOTlKpjg6
         ADTNfBX3xz8hFMng/k3W3VEwkOBItb+83GES0LZ2brhrcX8AxcGrECXZAfnzgZEDYGcC
         Ocig==
X-Gm-Message-State: AOAM530iyEKqvcbOsoPXrDWs4TXDeR6+UDtue7GCpQbDmoYqZK320wXz
        zMltmIlM19QHMEE7naZl4yrCRRPEvRDE3rMnAoE=
X-Google-Smtp-Source: ABdhPJyRd3MP7wD4DOFom9ocMUWul/cWXBG6tuAt4w4gHMPdGF7irW35cgX7ILRnwJalJmiRKnvgMLID91qwuuQhDDY=
X-Received: by 2002:a6b:f909:: with SMTP id j9mr10907076iog.138.1616774461146;
 Fri, 26 Mar 2021 09:01:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210325173646.GG2356281@nvidia.com> <20210325182021.GA795636@bjorn-Precision-5520>
 <20210325182836.GJ2356281@nvidia.com> <YF2CtFmOxL6Noi96@unreal>
In-Reply-To: <YF2CtFmOxL6Noi96@unreal>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Fri, 26 Mar 2021 09:00:50 -0700
Message-ID: <CAKgT0UfK3eTYH+hRRC0FcL0rdncKJi=6h5j6MN0uDA98cHCb9A@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Keith Busch <kbusch@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 11:44 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Thu, Mar 25, 2021 at 03:28:36PM -0300, Jason Gunthorpe wrote:
> > On Thu, Mar 25, 2021 at 01:20:21PM -0500, Bjorn Helgaas wrote:
> > > On Thu, Mar 25, 2021 at 02:36:46PM -0300, Jason Gunthorpe wrote:
> > > > On Thu, Mar 25, 2021 at 12:21:44PM -0500, Bjorn Helgaas wrote:
> > > >
> > > > > NVMe and mlx5 have basically identical functionality in this respect.
> > > > > Other devices and vendors will likely implement similar functionality.
> > > > > It would be ideal if we had an interface generic enough to support
> > > > > them all.
> > > > >
> > > > > Is the mlx5 interface proposed here sufficient to support the NVMe
> > > > > model?  I think it's close, but not quite, because the the NVMe
> > > > > "offline" state isn't explicitly visible in the mlx5 model.
> > > >
> > > > I thought Keith basically said "offline" wasn't really useful as a
> > > > distinct idea. It is an artifact of nvme being a standards body
> > > > divorced from the operating system.
> > > >
> > > > In linux offline and no driver attached are the same thing, you'd
> > > > never want an API to make a nvme device with a driver attached offline
> > > > because it would break the driver.
> > >
> > > I think the sticky part is that Linux driver attach is not visible to
> > > the hardware device, while the NVMe "offline" state *is*.  An NVMe PF
> > > can only assign resources to a VF when the VF is offline, and the VF
> > > is only usable when it is online.
> > >
> > > For NVMe, software must ask the PF to make those online/offline
> > > transitions via Secondary Controller Offline and Secondary Controller
> > > Online commands [1].  How would this be integrated into this sysfs
> > > interface?
> >
> > Either the NVMe PF driver tracks the driver attach state using a bus
> > notifier and mirrors it to the offline state, or it simply
> > offline/onlines as part of the sequence to program the MSI change.
> >
> > I don't see why we need any additional modeling of this behavior.
> >
> > What would be the point of onlining a device without a driver?
>
> Agree, we should remember that we are talking about Linux kernel model
> and implementation, where _no_driver_ means _offline_.

The only means you have of guaranteeing the driver is "offline" is by
holding on the device lock and checking it. So it is only really
useful for one operation and then you have to release the lock. The
idea behind having an "offline" state would be to allow you to
aggregate multiple potential operations into a single change.

For example you would place the device offline, then change
interrupts, and then queues, and then you could online it again. The
kernel code could have something in place to prevent driver load on
"offline" devices. What it gives you is more of a transactional model
versus what you have right now which is more of a concurrent model.
