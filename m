Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25AD326AF1F
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 23:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgIOVEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 17:04:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:54462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727816AbgIOVEn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 17:04:43 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CC2720732;
        Tue, 15 Sep 2020 21:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600203861;
        bh=juX7apZ1AwwxlXqaRlp4XCoAqy31Vj6ful3pNCaYqy0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WLIfCUjtdhxDSazrDuQlCrruDRnzfyHwgyk9AHjKQDEptGaT89l/E0S4aenUbNZXE
         p4qScTvhduz5jpPHtOcX2095R3q1Lp9iCDd/C7o/cV8HQ5Ybzm9selOO00iDX9GtcD
         xIn4yMJcLH1iOpudXoTxXHDgT5ydH46AbZeuIBV8=
Date:   Tue, 15 Sep 2020 14:04:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Oded Gabbay <oded.gabbay@gmail.com>
Cc:     "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, SW_Drivers <SW_Drivers@habana.ai>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
Message-ID: <20200915140418.4afbc1eb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
References: <20200915171022.10561-1-oded.gabbay@gmail.com>
        <20200915133556.21268811@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAFCwf12XZRxLYifSfuB+RGhuiKBytzsUTOnEa6FqfJHYvcVJPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Sep 2020 23:46:58 +0300 Oded Gabbay wrote:
> On Tue, Sep 15, 2020 at 11:35 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 15 Sep 2020 20:10:08 +0300 Oded Gabbay wrote:  
> > > Hello,
> > >
> > > This is the second version of the patch-set to upstream the GAUDI NIC code
> > > into the habanalabs driver.
> > >
> > > The only modification from v2 is in the ethtool patch (patch 12). Details
> > > are in that patch's commit message.  
> >
> > You keep reposting this, yet this SDK shim^W^W driver is still living in
> > drivers/misc. If you want to make it look like a NIC, the code belongs
> > where NIC drivers are.
> >
> > Then again, is it a NIC? Why do you have those custom IOCTLs? That's far
> > from normal.  
> 
> I'm sorry but from your question it seems as if you didn't read my
> cover letter at all, as I took great lengths in explaining exactly
> what our device is and why we use custom IOCTLs.
> TL;DR
> We have an accelerator for deep learning (GAUDI) which uses RDMA as
> infrastructure for communication between multiple accelerators. Same
> as Nvidia uses NVlink, we use RDMA that we have inside our ASIC.
> The RDMA implementation we did does NOT support some basic RDMA
> IBverbs (such as MR and PD) and therefore, we can't use the rdma-core
> library or to connect to the rdma infrastructure in the kernel. We
> wanted to do it but when we analyzed it, we saw we wouldn't be able to
> support basic stuff and therefore we had to revert to our IOCTLs.
> To sum it up, because our NIC is used for intra-communication, we
> don't expose nor intend users to use it as a NIC per-se. However, to
> be able to get statistics and manage them in a standard way, and
> support control plane over Ethernet, we do register each port to the
> net subsystem (i.e. create netdev per port).
> 
> I hope this short summary explains this better.

I read your cover letter. Networking drivers don't get to define random
IOCTLs as they please. You have to take that part out of the "NIC"
driver.

> As per your request that this code lives in the net subsystem, I think
> that will make it only more complicated and hard to upstream and
> maintain.
> I see there are other examples (e.g. sgi-xp) that contain networking
> driver code in misc so I don't understand this objection.

The maintenance structure and CI systems for the kernel depend on the
directory layout. If you don't understand that I don't know how to help
you.

> > Please make sure to CC linux-rdma. You clearly stated that the device
> > does RDMA-like transfers.  
> 
> We don't use the RDMA infrastructure in the kernel and we can't
> connect to it due to the lack of H/W support we have so I don't see
> why we need to CC linux-rdma.

You have it backward. You don't get to pick and choose which parts of
the infrastructure you use, and therefore who reviews your drivers.
The device uses RDMA under the hood so Linux RDMA experts must very
much be okay with it getting merged. That's how we ensure Linux
interfaces are consistent and good quality.
