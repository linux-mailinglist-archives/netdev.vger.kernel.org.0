Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72D802EF5AC
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 17:23:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbhAHQXS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 11:23:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59647 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727301AbhAHQXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 11:23:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610122911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Q5iauIiBLesdrMgERfUoC3FE4fSfbeB6/yAK1WQKzuI=;
        b=UJWeyQd2+j9LaalOqx/qp4dp/SpH3W9C5VZverA1KBMm6NeEXqSi/5wY7B6Mc/rmbrrYap
        7Z1jEHcilSCReG5Se/eUjJ2OEs/KRmapdDgG8sibb9zrU2Q3QbGyUAL8MVjmhvOjIX5nzk
        Ml4oEnRkuRXWwmQb71e/3LZsVbwzF14=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-56-QXSpSwkqMEe8edh3l2PfcA-1; Fri, 08 Jan 2021 11:21:47 -0500
X-MC-Unique: QXSpSwkqMEe8edh3l2PfcA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4EA2B801817;
        Fri,  8 Jan 2021 16:21:46 +0000 (UTC)
Received: from omen.home (ovpn-112-255.phx2.redhat.com [10.3.112.255])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 829E55D6D1;
        Fri,  8 Jan 2021 16:21:45 +0000 (UTC)
Date:   Fri, 8 Jan 2021 09:21:45 -0700
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Don Dutile <ddutile@redhat.com>,
        Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-pci@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH mlx5-next 1/4] PCI: Configure number of MSI-X vectors
 for SR-IOV VFs
Message-ID: <20210108092145.7c70ff74@omen.home>
In-Reply-To: <20210108072525.GB31158@unreal>
References: <20210108005721.GA1403391@bjorn-Precision-5520>
        <ba1e7c38-2a21-40ba-787f-458b979b938f@redhat.com>
        <20210108072525.GB31158@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 Jan 2021 09:25:25 +0200
Leon Romanovsky <leon@kernel.org> wrote:

> On Thu, Jan 07, 2021 at 10:54:38PM -0500, Don Dutile wrote:
> > On 1/7/21 7:57 PM, Bjorn Helgaas wrote:  
> > > [+cc Alex, Don]  
> 
> <...>
> 
> > > Help me connect the dots here.  Is this required because of something
> > > peculiar to mlx5, or is something like this required for all SR-IOV
> > > devices because of the way the PCIe spec is written?  
> > So, overall, I'm guessing the mlx5 device can have 1000's of MSIX -- say, one per send/receive/completion queue.
> > This device capability may exceed the max number MSIX a VM can have/support (depending on guestos).
> > So, a sysfs tunable is used to set the max MSIX available, and thus, the device puts >1 send/rcv/completion queue intr on a given MSIX.
> >
> > ok, time for Leon to better state what this patch does,
> > and why it's needed on mlx5 (and may be applicable to other/future high-MSIX devices assigned to VMs (NVME?)).
> > Hmmm, now that I said it, why is it SRIOV-centric and not pci-device centric (can pass a PF w/high number of MSIX to a VM).  
> 
> Thanks Don and Bjorn,
> 
> I will answer on all comments a little bit later when I will return
> to the office (Sunday).
> 
> However it is important for me to present the use case.
> 
> Our mlx5 SR-IOV devices were always capable to drive many MSI-X (upto 2K,
> don't catch me on exact number), however when user created VFs, the FW has
> no knowledge of how those VFs will be used. So FW had no choice but statically
> and equally assign same amount of MSI-X to all VFs.
> 
> After SR-IOV VF creation, user will bind those new VFs to the VMs, but
> the VMs have different number of CPUs and despite HW being able to deliver
> all needed number of vectors (in mlx5 netdev world, number of channels == number
> of CPUs == number of vectors), we will be limited by already set low number
> of vectors.
> 
> So it is not for vector reduction, but more for vector re-partition.
> 
> As an example, imagine mlx5 with two VFs. One VF is bounded to VM with 200 CPUs
> and another is bounded to VM with 1 CPU. They need different amount of MSI-X vectors.
> 
> Hope that I succeeded to explain :).

The idea is not unreasonable imo, but without knowing the size of the
vector pool, range available per vf, or ultimately whether the vf
supports this feature before we try to configure it, I don't see how
userspace is expected to make use of this in the general case.  If the
configuration requires such specific vf vector usage and pf driver
specific knowledge, I'm not sure it's fit as a generic pci-sysfs
interface.  Thanks,

Alex

