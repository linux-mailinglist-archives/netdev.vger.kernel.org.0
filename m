Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C032446803
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 18:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbhKERmc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Nov 2021 13:42:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232041AbhKERmb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Nov 2021 13:42:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EA0360F5A;
        Fri,  5 Nov 2021 17:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636133991;
        bh=XrZbDCF6z0xo/uXRiBkJPgik1oScJ4FKVTH+l+tPXLI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=bg+IHkl6iuE2prqaM6ZoanveKoblpySeInH3DGASZ0ZSmsPae4/4XhL1LivF9QXza
         2DBfsjbTTGr6wFM1/zXj7huhOt731bRE8z7/62hVW8LEVKTkfKrRxtbi5lNF/q5Mcr
         le0rXNLJgd7s2CBfKm/OOi1ogNaEYeAYkBlZjN5s7VZ/kFz1X9MHY3anFGTqkuVqFX
         Xk7IIr91QRqL4+mJ/hal9vpCIbx8ba3mjjMLkMXr7kETV2ouuhkknH806ZUc1CydMH
         ZIF9zEDIpNVkQ3ed16V9Cs77VDu5mr1IfGorw055cO5oZWIcJyomNA81LF3A9C/DB7
         eJ/6nxqRzrIFQ==
Date:   Fri, 5 Nov 2021 12:39:49 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, logang@deltatee.com, leon@kernel.org,
        linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V11 7/8] PCI: Enable 10-Bit Tag support for PCIe Endpoint
 device
Message-ID: <20211105173949.GA932723@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <894a1e8f-cc08-2710-9f56-9dda14e2e617@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 05, 2021 at 04:24:24PM +0800, Dongdong Liu wrote:
> On 2021/11/4 0:02, Bjorn Helgaas wrote:

> > But it does remind me that if the RC doesn't support 10-bit tags, but
> > we use sysfs to enable 10-bit tags for a reqester that intends to use
> > P2PDMA to a peer that *does* support them, I don't think there's
> > any check in the DMA API that prevents the driver from setting up DMA
> > to the RC in addition to the peer.
>
> Current we use sysfs to enable/disable 10-bit tags for a requester also
> depend on the RP support 10-bit tag completer, so it will be ok.

Ah, OK.  So we can never *enable* 10-bit tags unless the Root Port
supports them.

I misunderstood the purpose of this file.  When the Root Port doesn't
support 10-bit tags, we won't enable them during enumeration.  I
though the point was that if we want to do P2PDMA to a peer that
*does* support them, we could use this file to enable them.

But my understanding was wrong -- the real purpose of the file is to
*disable* 10-bit tags for the case when a P2PDMA peer doesn't support
them.

It does support enabling 10-bit tags as well, but that's only because
we need a way to get back to the default "enabled during enumeration"
state without having to reboot.

We might be able to highlight this a little more in the commit log.

> > 10-bit tag support appeared in the spec four years ago (PCIe r4.0, in
> > September, 2017).  Surely there is production hardware that supports
> > this and could demonstrate a benefit from this.
>
> I found the below introduction about "Number of tags needed to achieve
> maximum throughput for PCIe 4.0 and PCIe 5.0 links"
> https://www.synopsys.com/designware-ip/technical-bulletin/accelerating-32gtps-pcie5-designs.html
> 
> It seems pretty clear.

Yes, that's a start.  But we don't really need a white paper to tell
us that more outstanding transactions is better.  That's obvious.  But
this adds risk, and if we can't demonstrate a tangible, measurable
benefit, there's no point in doing it.

Bjorn
