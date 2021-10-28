Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D96C543E73F
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 19:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbhJ1R0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 13:26:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231167AbhJ1R0w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 13:26:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 47A8160F38;
        Thu, 28 Oct 2021 17:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635441865;
        bh=t7CLM0MPA8ePvHMFN4TyEeOzL9SArjf61qr1p9xC9PI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Gpg+ydi23TUfYLfiq3cUhwoLReFd75f/xfFHF46cGnG8uT24IVyS6jTEaZQJHslfy
         ZVJzjPBUBCjB9Hmy58iK64B0RwbZuPLgfnb9buiSBCMBxCv6BCvoktfIIbJ+RI5XPo
         b8vgw9FWJF/Q0xH/wI2rJs5nT+QHcTKMkN21619cTWcwH9cFl97/NAvF4NPEAlul3G
         uAM9a0baCfNH8H6Sfnl897rQz791eWidIJ7HDEmLiXVM+BLgTkvY2VCqmGsERRA+z5
         8PZjrtv8SCYp9y7Ws/3TjmpZl9b20oCg6uS4IihHjXm6iZsW6MFcQJKDDBtGngTaMA
         nG5Pz7krXzigg==
Date:   Thu, 28 Oct 2021 12:24:23 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, logang@deltatee.com,
        leon@kernel.org, linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V10 4/8] PCI/sysfs: Add a 10-Bit Tag sysfs file PCIe
 Endpoint devices
Message-ID: <20211028172423.GA279833@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29edb35a-4c46-8b5d-26e5-debf6b3a72bc@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 28, 2021 at 03:44:49PM +0800, Dongdong Liu wrote:
> On 2021/10/28 6:28, Bjorn Helgaas wrote:
> > On Sat, Oct 09, 2021 at 06:49:34PM +0800, Dongdong Liu wrote:
> > > PCIe spec 5.0 r1.0 section 2.2.6.2 says:
> > > 
> > >   If an Endpoint supports sending Requests to other Endpoints (as
> > >   opposed to host memory), the Endpoint must not send 10-Bit Tag
> > >   Requests to another given Endpoint unless an implementation-specific
> > >   mechanism determines that the Endpoint supports 10-Bit Tag Completer
> > >   capability.
> > > 
> > > Add a 10bit_tag sysfs file, write 0 to disable 10-Bit Tag Requester
> > > when the driver does not bind the device. The typical use case is for
> > > p2pdma when the peer device does not support 10-Bit Tag Completer.
> > > Write 1 to enable 10-Bit Tag Requester when RC supports 10-Bit Tag
> > > Completer capability. The typical use case is for host memory targeted
> > > by DMA Requests. The 10bit_tag file content indicate current status of
> > > 10-Bit Tag Requester Enable.
> > 
> > Don't we have a hole here?  We're adding knobs to control 10-Bit Tag
> > usage, but don't we have basically the same issues with Extended
> > (8-bit) Tags?
> 
> All PCIe completers are required to support 8-bit tags
> from the "[PATCH] PCI: enable extended tags support for PCIe endpoints"
> (https://patchwork.kernel.org/project/linux-arm-msm/patch/1474769434-5756-1-git-send-email-okaya@codeaurora.org/).
> 
> I ask hardware colleagues, also says all PCIe devices should support
> 8-bit tags completer default, so seems no need to do this for 8-bit tags.

Oh, right, I forgot that, thanks for the reminder!  Let's add a
comment in pci_configure_extended_tags() to that effect so I'll
remember next time.

I think the appropriate reference is PCIe r5.0, sec 2.2.6.2, which
says "Receivers/Completers must handle 8-bit Tag values correctly
regardless of the setting of their Extended Tag Field Enable bit (see
Section 7.5.3.4)."

The Tag field was 8 bits all the way from PCIe r1.0, but until r2.1 it
said that by default, only the lower 5 bits are used.

The text about all Completers explicitly being required to support
8-bit Tags wasn't added until PCIe r3.0, which might explain some
confusion and the presence of the Extended Tag Field Enable bit.

At the same time, can you fold pci_configure_10bit_tags() directly
into pci_configure_extended_tags()?  It's pretty small and I think it
will be easier if it's all in one place.

> > I wonder if we should be adding a more general "tags" file that can
> > manage both 8-bit and 10-bit tag usage.

I'm still thinking that maybe a generic name (without "10") would be
better, even though we don't need it to manage 8-bit tags.  It's
conceivable that there could be even more tag bits in the future, and
it would be nice if we didn't have to add yet another file.

Bjorn
