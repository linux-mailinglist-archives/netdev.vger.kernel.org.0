Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 627B8350013
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 14:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbhCaMTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 08:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbhCaMTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 08:19:32 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7C4C06174A
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 05:19:32 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id z10so19028842qkz.13
        for <netdev@vger.kernel.org>; Wed, 31 Mar 2021 05:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PJyuYOXEPThE2Fv31/yb2A5G05WFpUI9cqxqY5aTGFs=;
        b=lY8FLwMa2kcF/T7oV3kAmGT+GFcjJzTyqpBzA0VBe7KQERhmtwl70OEeapllblGjH/
         /4zrxh0leobwu+cTHedaMGjHtmJjx/0MkqMPf93pxbD7f7z4esKkdxUIK4DEivB3lS3a
         P7q9kBsdvo66lka3YUC3xOk6Vuz0E+Sk85v6ktzK5vrJRJlm+QgxCTkSfCQrTt2EZhN7
         NCP/xox83L2uC+0j0vMhEf4EdwSVvXcpjEZNIm6thm6uNHm1QjkZdLAoI3Z+lve2tCa/
         qtROhBm9fOvvIG7IG1gQuY1ssIzdHesBWb3jKi7webZdFK6jQONMHiZ9CXV9piz8jLi/
         GBfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PJyuYOXEPThE2Fv31/yb2A5G05WFpUI9cqxqY5aTGFs=;
        b=pAwBbMcQbsntG15x/Mtt+SF0llbskLtKDDeaZMEVu09tfwaNWTZaLIcSw7wDAHVNLP
         376Np2YV4vnEroXXVuhl4ysbiAms4AqgKJdvPccULp306wN+Hv/wzsgJaTYfqLwFpyIr
         32h0Y1cEdnneDqKcQZ3G2qvnYfM5MZX0LRhzTz3Y+vsMNunS4d0vLxyvquSx6PbOvJCt
         liPbWYw9L49lOL6E2pdsX1DmV/VN91jtgx9dIHgvpr1FMlg/QcfLyBEOEFVQrEc5BEV6
         qPmB5lqQVa7IN4XJgiNYv5/+MecEgm6dyoXfZjKLFLOZWtEwIbQ4GNRB4o4cQ4yWieA8
         5Lxw==
X-Gm-Message-State: AOAM531ldcMveKlBzRJ8EZcmmxedB53vJ67qm6xC1r1SSWkLPrS93RZ2
        KWOtT/YvNTeYguZJ5eTK88c0PA==
X-Google-Smtp-Source: ABdhPJwkTUWmwjW/6AxVt/xVKUV2IWciFy7YCIjz7ea+0L3y7vHWpvlGHOx2deUuGfkMXIkbZdH3Qw==
X-Received: by 2002:ae9:c011:: with SMTP id u17mr2869066qkk.2.1617193171556;
        Wed, 31 Mar 2021 05:19:31 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-115-133.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.115.133])
        by smtp.gmail.com with ESMTPSA id w5sm1288993qkc.85.2021.03.31.05.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Mar 2021 05:19:30 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1lRZon-006Jwt-R3; Wed, 31 Mar 2021 09:19:29 -0300
Date:   Wed, 31 Mar 2021 09:19:29 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Bjorn Helgaas <helgaas@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Keith Busch <kbusch@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210331121929.GX2710221@ziepe.ca>
References: <20210330194716.GV2710221@ziepe.ca>
 <20210330204141.GA1305530@bjorn-Precision-5520>
 <20210330224341.GW2710221@ziepe.ca>
 <YGQY72LnGB6bfIsI@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGQY72LnGB6bfIsI@kroah.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 08:38:39AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Mar 30, 2021 at 07:43:41PM -0300, Jason Gunthorpe wrote:
> > > With 0000:01:00.0/sriov/BB:DD.F/vf_msix_count, sriov/ will contain
> > > 1 file and 1K subdirectories.
> > 
> > The smallest directory sizes is with the current patch since it
> > re-uses the existing VF directory. Do we care about directory size at
> > the sysfs level?
> 
> No, that should not matter.
> 
> The "issue" here is that you "broke" the device chain here by adding a
> random kobject to the directory tree: "BB:DD.F"
> 
> Again, devices are allowed to have attributes associated with it to be
> _ONE_ subdirectory level deep.
> 
> So, to use your path above, this is allowed:
> 	0000:01:00.0/sriov/vf_msix_count
> 
> as these are sriov attributes for the 0000:01:00.0 device, but this is
> not:
> 	0000:01:00.0/sriov/BB:DD.F/vf_msix_count
> as you "threw" a random kobject called BB:DD.F into the middle.
>
> If you want to have "BB:DD.F" in there, then it needs to be a real
> struct device and _THEN_ it needs to point its parent to "0000:01:00.0",
> another struct device, as "sriov" is NOT ANYTHING in the heirachy here
> at all.

It isn't a struct device object at all though, it just organizing
attributes.

> Does that help?  The rules are:
> 	- Once you use a 'struct device', all subdirs below that device
> 	  are either an attribute group for that device or a child
> 	  device.
> 	- A struct device can NOT have an attribute group as a parent,
> 	  it can ONLY have another struct device as a parent.
> 
> If you break those rules, the kernel has the ability to get really
> confused unless you are very careful, and userspace will be totally lost
> as you can not do anything special there.

The kernel gets confused?

I'm not sure I understand why userspace gets confused. I can guess
udev has some issue, but everything else seems OK, it is just a path.

> > > I'm dense and don't fully understand Greg's subdirectory comment.
> > 
> > I also don't know udev well enough. I've certainly seen drivers
> > creating extra subdirectories using kobjects.
> 
> And those drivers are broken.  Please point them out to me and I will be
> glad to go fix them.  Or tell their authors why they are broken :)

How do you fix them? It is uAPI at this point so we can't change the
directory names. Can't make them struct devices (userspace would get
confused if we add *more* sysfs files)

Grep for kobject_init_and_add() under drivers/ and I think you get a
pretty good overview of the places.

Since it seems like kind of a big problem can we make this allowed
somehow?

> > > But it doesn't seem like that level of control would be in a udev rule
> > > anyway.  A PF udev rule might *start* a program to manage MSI-X
> > > vectors, but such a program should be able to deal with whatever
> > > directory structure we want.
> >
> > Yes, I can't really see this being used from udev either. 
> 
> It doesn't matter if you think it could be used, it _will_ be used as
> you are exposing this stuff to userspace.

Well, from what I understand, it wont be used because udev can't do
three level deep attributes, and if that hasn't been a problem in that
last 10 years for the existing places, it might not ever be needed in
udev at all.

> > I assume there is also the usual race about triggering the uevent
> > before the subdirectories are created, but we have the
> > dev_set_uevent_suppress() thing now for that..
> 
> Unless you are "pci bus code" you shouldn't be using that :)

There are over 40 users now.

Jason
