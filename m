Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C65B833137C
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 17:33:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhCHQdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 11:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbhCHQdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 11:33:16 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17E3C06174A;
        Mon,  8 Mar 2021 08:33:15 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id 81so10545434iou.11;
        Mon, 08 Mar 2021 08:33:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Dpxk6smN5s9jqDRr6gszhbtGPRhqSGCZqwN880eOGkY=;
        b=kyZMgMDY02446TqbVqNFcOxrq8jy3Mw89TwDgucEfhuSVHic1kyFNXyfmMo7N2qHjT
         XRHfwhgGNNMFqGr5uYM31DcqYH5wv5IoIWKbnxQJKZcrTekqb7ddKsB24i8iVgNdMyox
         AiJBlEgJLhosdb8M5HtwlNLjAB0lFQQJ2vlPk37qY48hHyl1KKc5TtaYx+4KfZq8hFlj
         K3xDLqYSzEN0/f7/ITfMZSil3ZIpZ6XXfOWPLEHs1gIb2Omg/UpEeJajhgU+UYrW/SE9
         oPpZwGnkTv3bN/cJ56iCLdWLGBNUhIeOxR32LyVf7u+4PH6nMp2al835aqY4wAmV0dkW
         Y8xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Dpxk6smN5s9jqDRr6gszhbtGPRhqSGCZqwN880eOGkY=;
        b=Zit/N4qs/QgTWfo34kbWiF+ou9vO4awqkLpgN8KKREpgP1vDSyO1zA2BqrrE2/acyj
         k7V3zHOcV6uxLvjUWSMb/qKuAstwLK1mIqE7nUfSTboKRacoJZ2jUPegJxpWuFIFpALJ
         kTP02bpDS3O3qTTwY96hST2kI6zARWBdFUZCvaW5djPp+aOFB2lTAC7jk3IhbLjevYRf
         FL1uJwMNsvOjzfI7+A5VrN1mGZgVCLvXWKP/jJa+94avtvZpgYp8Ua/FxnXcLobH8cxS
         BUBgZAYw9G6CF0ccQxOFyXWsD10YBIHcIH/c8zrKbW90IYbPaxv7vPM0e0nuNh1fsTiK
         +dnw==
X-Gm-Message-State: AOAM532wRaFca/hLxEyymn29VwEcVOpEuEqvI5P+i0ZPum+4L5Qi+UAu
        LTTqhTDaNrnKze9w03mmAIJfTt0RRYrMryqy66sG5E7i4KM=
X-Google-Smtp-Source: ABdhPJxQp9puHVHLX0mh0tI6TqzlVw+DA4E692ROnUueWsgY9ZUU8Sr9mYDd5sMcMrGom9e5vJDo/B0xt/u1SlxbyUM=
X-Received: by 2002:a05:6638:329e:: with SMTP id f30mr7221139jav.121.1615221195168;
 Mon, 08 Mar 2021 08:33:15 -0800 (PST)
MIME-Version: 1.0
References: <20210301075524.441609-1-leon@kernel.org> <CAKgT0Ue=g+1pZCct8Kd0OnkPEP0qhggBF96s=noDoWHMJTL6FA@mail.gmail.com>
 <YEUnVcW+lIXBlqT1@unreal>
In-Reply-To: <YEUnVcW+lIXBlqT1@unreal>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 8 Mar 2021 08:33:03 -0800
Message-ID: <CAKgT0UdzjeD7fnE6kX2qN6V4ZddSV2ZMnONEwGXhwkSwoUXUug@mail.gmail.com>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
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

On Sun, Mar 7, 2021 at 11:19 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Sun, Mar 07, 2021 at 10:55:24AM -0800, Alexander Duyck wrote:
> > On Sun, Feb 28, 2021 at 11:55 PM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > >
> > > @Alexander Duyck, please update me if I can add your ROB tag again
> > > to the series, because you liked v6 more.
> > >
> > > Thanks
> > >
> > > ---------------------------------------------------------------------------------
> > > Changelog
> > > v7:
> > >  * Rebase on top v5.12-rc1
> > >  * More english fixes
> > >  * Returned to static sysfs creation model as was implemented in v0/v1.
> >
> > Yeah, so I am not a fan of the series. The problem is there is only
> > one driver that supports this, all VFs are going to expose this sysfs,
> > and I don't know how likely it is that any others are going to
> > implement this functionality. I feel like you threw out all the
> > progress from v2-v6.
>
> I'm with you here and tried to present the rationale in v6 when had
> a discussion with Bjorn, so it is unfair to say "you threw out".
>
> Bjorn expressed his preference, and no one came forward to support v6.

Sorry, it wasn't my intention to be accusatory. I'm just not a fan of
going back to where we were with v1.

With that said, if it is what Bjorn wants then you are probably better
off going with that. However if that is the direction we are going in
then you should probably focus on getting his Reviewed-by or Ack since
he will ultimately be the maintainer for the code.

> >
> > I really feel like the big issue is that this model is broken as you
> > have the VFs exposing sysfs interfaces that make use of the PFs to
> > actually implement. Greg's complaint was the PF pushing sysfs onto the
> > VFs. My complaint is VFs sysfs files operating on the PF. The trick is
> > to find a way to address both issues.
>
> It is hard to say something meaningful about Greg's complain, he was
> added in the middle of the discussion without much chances to get full
> picture.

Right, but what I am getting at is that the underlying problem is that
you either have sysfs being pushed onto a remote device, or sysfs that
is having to call into another device. It's not exactly something we
have had precedent for enabling before, and either perspective seems a
bit ugly.

> >
> > Maybe the compromise is to reach down into the IOV code and have it
> > register the sysfs interface at device creation time in something like
> > pci_iov_sysfs_link if the PF has the functionality present to support
> > it.
>
> IMHO, it adds nothing.

My thought was to reduce clutter. As I mentioned before with this
patch set we are enabling sysfs for functionality that is currently
only exposed by one device. I'm not sure it will be used by many
others or not. Having these sysfs interfaces instantiated at probe
time or at creation time in the case of VFs was preferable to me.

> >
> > Also we might want to double check that the PF cannot be unbound while
> > the VF is present. I know for a while there it was possible to remove
> > the PF driver while the VF was present. The Mellanox drivers may not
> > allow it but it might not hurt to look at taking a reference against
> > the PF driver if you are allocating the VF MSI-X configuration sysfs
> > file.
>
> Right now, we always allocate these sysfs without relation if PF
> supports or not. The check is done during write() call to such sysfs
> and at that phase we check the existence of the drivers. It greatly
> simplifies creation phase.

Yeah, I see that. From what I can tell the locking looks correct to
keep things from breaking. For what we have it is probably good enough
to keep things from causing any issues. My concern was more about
preventing the driver from reloading if we only exposed these
interfaces if the PF driver supported them.
