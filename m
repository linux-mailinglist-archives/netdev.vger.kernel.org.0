Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7849934DD8E
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 03:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhC3B34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 21:29:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229555AbhC3B3v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 21:29:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B6B8361601;
        Tue, 30 Mar 2021 01:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617067791;
        bh=FOL/caVD4F/jBznmonolFIU/T5q9WM3HTqqkenGFCD8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=WjuFs13elkNkZd4Oh+RqKnUtLPlM8q1WmvgfuKiozP+azVPfxjEjHTyvbqyRZxyIk
         ke1Yb5mL/4btqeV/nCyt16sVaOE7gT/BVZ7zjSgasVe+19mMCopsTCnglESSYr1eLW
         n9YW5Y6BA8Q80BXmq4/UBNKSQeV/4vP4N1Qk1Jm2GYjdKZDBJwSNF8Z6JA42ApBwQA
         JkzqeiFc7VY+BZqZa4Q9r0OyPw/WcCPnBxk1xSTAO0AajFp+6ehqWEvUql3PCG1L29
         9l/4HjLJolgL6h30/M9A2EE47xd8yVCxGHbVa5140qQkg72mns2csA8xyeLpAzA6An
         5IbkKuNkUkXBw==
Date:   Mon, 29 Mar 2021 20:29:49 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>,
        Keith Busch <kbusch@kernel.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
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
Message-ID: <20210330012949.GA1205505@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210326190148.GN2710221@ziepe.ca>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 04:01:48PM -0300, Jason Gunthorpe wrote:
> On Fri, Mar 26, 2021 at 11:50:44AM -0700, Alexander Duyck wrote:
> 
> > My concern would be that we are defining the user space interface.
> > Once we have this working as a single operation I could see us having
> > to support it that way going forward as somebody will script something
> > not expecting an "offline" sysfs file, and the complaint would be that
> > we are breaking userspace if we require the use of an "offline"
> > file.
> 
> Well, we wouldn't do that. The semantic we define here is that the
> msix_count interface 'auto-offlines' if that is what is required. If
> we add some formal offline someday then 'auto-offline' would be a NOP
> when the device is offline and do the same online/offline sequence as
> today if it isn't.

Alexander, Keith, any more thoughts on this?

I think I misunderstood Greg's subdirectory comment.  We already have
directories like this:

  /sys/bus/pci/devices/0000:01:00.0/link/
  /sys/bus/pci/devices/0000:01:00.0/msi_irqs/
  /sys/bus/pci/devices/0000:01:00.0/power/

and aspm_ctrl_attr_group (for "link") is nicely done with static
attributes.  So I think we could do something like this:

  /sys/bus/pci/devices/0000:01:00.0/   # PF directory
    sriov/                             # SR-IOV related stuff
      vf_total_msix
      vf_msix_count_BB:DD.F        # includes bus/dev/fn of first VF
      ...
      vf_msix_count_BB:DD.F        # includes bus/dev/fn of last VF

And I think this could support the mlx5 model as well as the NVMe
model.

For NVMe, a write to vf_msix_count_* would have to auto-offline the VF
before asking the PF to assign the vectors, as Jason suggests above.
Before VF Enable is set, the vf_msix_count_* files wouldn't exist and
we wouldn't be able to assign vectors to VFs; IIUC that's a difference
from the NVMe interface, but maybe not a terrible one?

I'm not proposing changing nvme-cli to use this, but if the interface
is general enough to support both, that would be a good clue that it
might be able to support future devices with similar functionality.

Bjorn
