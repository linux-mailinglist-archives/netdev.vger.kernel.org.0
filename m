Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5AB34EB66
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 17:03:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232023AbhC3PA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 11:00:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:56962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231933AbhC3PAX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 11:00:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59B0E6192B;
        Tue, 30 Mar 2021 15:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617116420;
        bh=aRtQQ/CWsci/gTHui7huLorPZeb20hNQIruCW4doWMg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=MpR1Evi6HUZB2xwbP3/lpFyXQ7IK7Oga4oxh7vMBpj5US48MA2+nwEBrCWJDd6uH0
         ahhz1fachKuJ4vyna33bLVqxW9auUhiT23l9y/tkbnlEnUBoeIywEC1E7wymxK0Syx
         p3X00eoGP5Jq2Fo1kHfiooJWc9rQ13C+1GJgRQQmnwE/fqZWodnPW0m6oDwDAzk6Fc
         vrqZNzjh6GcDgz4qv5HRBIz4ya9VuEOhxqEZ4un+87b0jUYH2yPm2lLNBtA56d81pX
         j+QMfLlksazs0ZjoXbxDYVHZb1eJZZAZKqGUap7OHazulzUvaXlm0ARvQ4kckNApiA
         YIpXXvrn3j6tg==
Date:   Tue, 30 Mar 2021 10:00:19 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Keith Busch <kbusch@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-rdma@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        Don Dutile <ddutile@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH mlx5-next v7 0/4] Dynamically assign MSI-X vectors count
Message-ID: <20210330150019.GA1270419@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330135738.GU2710221@ziepe.ca>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 30, 2021 at 10:57:38AM -0300, Jason Gunthorpe wrote:
> On Mon, Mar 29, 2021 at 08:29:49PM -0500, Bjorn Helgaas wrote:
> 
> > I think I misunderstood Greg's subdirectory comment.  We already have
> > directories like this:
> 
> Yes, IIRC, Greg's remark applies if you have to start creating
> directories with manual kobjects.
> 
> > and aspm_ctrl_attr_group (for "link") is nicely done with static
> > attributes.  So I think we could do something like this:
> > 
> >   /sys/bus/pci/devices/0000:01:00.0/   # PF directory
> >     sriov/                             # SR-IOV related stuff
> >       vf_total_msix
> >       vf_msix_count_BB:DD.F        # includes bus/dev/fn of first VF
> >       ...
> >       vf_msix_count_BB:DD.F        # includes bus/dev/fn of last VF
> 
> It looks a bit odd that it isn't a subdirectory, but this seems
> reasonable.

Sorry, I missed your point; you'll have to lay it out more explicitly.
I did intend that "sriov" *is* a subdirectory of the 0000:01:00.0
directory.  The full paths would be:

  /sys/bus/pci/devices/0000:01:00.0/sriov/vf_total_msix
  /sys/bus/pci/devices/0000:01:00.0/sriov/vf_msix_count_BB:DD.F
  ...

> > For NVMe, a write to vf_msix_count_* would have to auto-offline the VF
> > before asking the PF to assign the vectors, as Jason suggests above.
> 
> It is also not awful if it returns EBUSY if the admin hasn't done
> some device-specific offline sequence.

Agreed.  The concept of "offline" is not visible in this interface.

> I'm just worried adding the idea of offline here is going to open a
> huge can of worms in terms of defining what it means, and the very
> next ask will be to start all VFs in offline mode. This would be some
> weird overlap with the no-driver-autoprobing sysfs. We've been
> thinking about this alot here and there are not easy answers.

We haven't added any idea of offline in the sysfs interface.  I'm
only trying to figure out whether it would be possible to use this
interface on top of devices with an offline concept, e.g., NVMe.

> mlx5 sort of has an offline concept too, but we have been modeling it
> in devlink, which is kind of like nvme-cli for networking.
> 
> Jason
