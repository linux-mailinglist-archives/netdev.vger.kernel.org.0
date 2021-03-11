Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7D2337FE5
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 22:50:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhCKVt5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 16:49:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231241AbhCKVtg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 16:49:36 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E05FC061574;
        Thu, 11 Mar 2021 13:49:36 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id o11so23635372iob.1;
        Thu, 11 Mar 2021 13:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FaW1u4lii1eMOVOjbdqEE3cWWsAzYgJvCw4BFDocnyw=;
        b=M8Nl8ipU93z4L71sKy8NCW61yH5h7J/Pcb+6hLBNRm17Ge5cXYZxVHorvGjuWOKm5R
         G2X0vDdOCiX8qjnxIS47MAeC4eIK5J55G1iKtWTG60A1HPLizB948N2m+wxDX4zmeUGL
         uY/ZVOZ2rN7Clt2z5svzw2hNw+8aA8ovmpqFL1JH41jE2r+kKa/ldeBeyr8JO/DtryPw
         HxXEddW2fDPyDqSPzBdveRMASD4UOKzwPveXw4Yn8Vx5zLNTWyyQflfkuXH7Qx5UOm87
         lT/L6JvLpGlsoRw3mYNwfwgZ4bWubyFpGQRysklRp5N/F8pFGyPglW/Ps3U/LbWd/CPH
         yaxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FaW1u4lii1eMOVOjbdqEE3cWWsAzYgJvCw4BFDocnyw=;
        b=S89hFwa45VJjr5ZrzifU7UNMC0mfphUNw+5DX4G1jDRoP8DkyM+I6bwagF7EzxKHcS
         Kge3VrWul/ArpO6W0ujC0Mk0EJvSpjzX6ZfOCeTJBmm0TBn2C8fYDlxci4gx5EBA3tbO
         6edBpndhSZBfexaTxfSiqycPzIh7qRAq5P2pyqfB78tGOw1U2H836PyC5aeIA4ilhcTM
         QjPziqM7QckiVfjm2fifkaYPgX5kEi6J5iJQ3D24atRVsRIfBsuhCtj6Mkh231r4iRv9
         +6M9YM3DehoXxnZyI0OFgFQe/92HQsaJPAZALOmNFfyZ98P9JNkhVb+YXS7WOuhLFYpZ
         +xSA==
X-Gm-Message-State: AOAM532d/thGm3GtWELVr/zdtMejp/3OmBPKKqSj7NWIqNGC2EJsHwIn
        8Yuyt0GkzGidlos4le37lLjv1ARefdltuzu5b5U=
X-Google-Smtp-Source: ABdhPJzBl3mb1ZzvYcF8nKsXbAVio4pBAzUXtvXwYeDPVZhgxXMkL2s18H4mrAMqBEfYyrPuE6208EldCtjC1Le0b4s=
X-Received: by 2002:a6b:f909:: with SMTP id j9mr7915991iog.138.1615499375774;
 Thu, 11 Mar 2021 13:49:35 -0800 (PST)
MIME-Version: 1.0
References: <CAKgT0UevrCLSQp=dNiHXWFu=10OiPb5PPgP1ZkPN1uKHfD=zBQ@mail.gmail.com>
 <20210311181729.GA2148230@bjorn-Precision-5520> <CAKgT0UeprjR8QCQMCV8Le+Br=bQ7j2tCE6k6gxK4zCZML5woAA@mail.gmail.com>
 <20210311201929.GN2356281@nvidia.com>
In-Reply-To: <20210311201929.GN2356281@nvidia.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 11 Mar 2021 13:49:24 -0800
Message-ID: <CAKgT0Ud1tzpAWO4+5GxiUiHT2wEaLacjC0NEifZ2nfOPPLW0cg@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
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

On Thu, Mar 11, 2021 at 12:19 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
>
> On Thu, Mar 11, 2021 at 11:37:28AM -0800, Alexander Duyck wrote:
>
>
> > Then the flow for this could be changed where we take the VF lock and
> > mark it as "stale" to prevent any driver binding and then we can
> > release the VF lock. Next we would perform the PF operation telling it
> > to update the VF.  Then we spin on the VF waiting for the stale data
> > to be updated and once that happens we can pop the indication that the
> > device is "stale" freeing it for use.
>
> I always get leary when people propose to open code locking constructs
> :\

I'm not suggesting we replace the lock. It is more about essentially
revoking the VF. What we are doing is essentially rewriting the PCIe
config of the VF so in my mind it makes sense to take sort of an RCU
approach where the old one is readable, but not something a new driver
can be bound to.

> There is already an existing lock to prevent probe() it is the
> device_lock() mutex on the VF. With no driver bound there is not much
> issue to hold it over the HW activity.

Yes. But sitting on those locks also has side effects such as
preventing us from taking any other actions such as disabling SR-IOV.
One concern I have is that if somebody else tries to implement this in
the future and they don't have a synchronous setup, or worse yet they
do but it takes a long time to process a request because they have a
slow controller it would be preferable to just have us post the
message to the PF and then have the thread spin and wait on the VF to
be updated rather than block on the PF while sitting on two locks.

> This lock is normally held around the entire probe() and remove()
> function which has huge amounts of HW activity already.

Yes, but usually that activity is time bound. You are usually reading
values and processing them in a timely fashion. In the case of probe
we even have cases where we have to defer because we don't want to
hold these locks for too long.

> We don't need to invent new locks and new complexity for something
> that is trivially solved already.

I am not wanting a new lock. What I am wanting is a way to mark the VF
as being stale/offline while we are performing the update. With that
we would be able to apply similar logic to any changes in the future.
