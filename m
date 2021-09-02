Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E283FEF1C
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 16:05:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345426AbhIBOGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 10:06:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:37766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345414AbhIBOGB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 10:06:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B8DD610CE;
        Thu,  2 Sep 2021 14:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630591502;
        bh=MdV2rCOMxwsCoWOvmZgOQ8ulnT3VaK/62s5XqGADLbo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=LRA9gDnV3TA3bHXwcVoifBp8P7VENm4N2VHzVs0cSLef9b4kM4ACV8mUCy28i1IyE
         7R94w7lLIpw4WUXHKSl14mBleuDPwI51s9FfDHPnUY7LrspTbfpvqvWgb8HEHn897z
         7UAdSvBEwbNBI5rINYmDW6I9S7iJeb5azMzmtC9PWoPVhhqzWj7+f/e39MHFwed8jG
         TqAwy8VB+PLiygJAvpKb6VP3BxyhuUGRELLlME3jKIzWR0iOqlYqERlern7KfbFL1W
         YnrGWnYajH7WWEqOKzll+gLsopY681swdP6cX3aHo1Wxe0Tfrdlqh4xXt7luHvhcCe
         68Wd40Yp/ctUQ==
Date:   Thu, 2 Sep 2021 09:05:00 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Jonas =?iso-8859-1?Q?Dre=DFler?= <verdre@v0yd.nl>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tsuchiya Yuto <kitakar@gmail.com>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        Maximilian Luz <luzmaximilian@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Keith Busch <kbusch@kernel.org>
Subject: Re: [PATCH 1/2] mwifiex: Use non-posted PCI register writes
Message-ID: <20210902140500.GA321043@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210901224154.GA230445@bjorn-Precision-5520>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[+cc Keith]

On Wed, Sep 01, 2021 at 05:41:56PM -0500, Bjorn Helgaas wrote:
> On Wed, Sep 01, 2021 at 07:07:58PM +0200, Johannes Berg wrote:
> > On Wed, 2021-09-01 at 18:51 +0200, Heiner Kallweit wrote:
> > > On 01.09.2021 17:51, Pali Roh·r wrote:
> > > > On Wednesday 01 September 2021 16:01:54 Jonas Dreﬂler wrote:
> > > > > On 8/30/21 2:49 PM, Andy Shevchenko wrote:
> > > > > > On Mon, Aug 30, 2021 at 3:38 PM Jonas Dreﬂler <verdre@v0yd.nl> wrote:
> > > > > > > 
> > > > > > > On the 88W8897 card it's very important the TX ring write pointer is
> > > > > > > updated correctly to its new value before setting the TX ready
> > > > > > > interrupt, otherwise the firmware appears to crash (probably because
> > > > > > > it's trying to DMA-read from the wrong place).
> > > > > > > 
> > > 
> > > This sounds somehow like the typical case where you write DMA descriptors
> > > and then ring the doorbell. This normally requires a dma_wmb().
> > > Maybe something like that is missing here?
> > 
> > But it looks like this "TX ring write pointer" is actually the register?
> > 
> > However, I would agree that doing it in mwifiex_write_reg() is possibly
> > too big a hammer - could be done only for reg->tx_wrptr, not all the
> > registers?
> > 
> > Actually, can two writes actually cross on PCI?
> 
> Per PCIe r5.0, sec 2.4.1,
> 
>   A2a  A Posted Request must not pass another Posted Request unless A2b
>        applies.
> 
>   A2b  A Posted Request with RO Set is permitted to pass another
>        Posted Request.  A Posted Request with IDO Set is permitted to
>        pass another Posted Request if the two Requester IDs are
>        different or if both Requests contain a PASID TLP Prefix and
>        the two PASID values are different.
> 
> A few drivers enable RO (Relaxed Ordering) for their devices, which
> means the *device* is permitted to set the RO bit in transactions it
> initiates.
> 
> BUt IIUC we're talking about MMIO writes initiated by a CPU, and they
> won't have the RO bit set unless the Root Port has Relaxed Ordering
> enabled, and Linux generally does not enable that.  So A2a should
> apply, and writes should be ordered on PCI.
> 
> There are a few wrinkles that I worry about:
> 
>   d1e714db8129 ("mtip32xx: Fix ERO and NoSnoop values in PCIe upstream
>   on AMD systems") [1] turns off RO for some AMD Root Ports, which
>   makes me think BIOS might be enabling RO in these Root Ports.
> 
>   c56d4450eb68 ("PCI: Turn off Request Attributes to avoid Chelsio T5
>   Completion erratum") [2] turns off RO for all Root Ports leading to
>   Chelsio T5 devices, which again makes me think there's firmware that
>   enables RO in Root Ports.  Follow-up [3].
> 
>   77ffc1465cec ("tegra: add PCI Express support") [4] (see
>   tegra_pcie_relax_enable()) enables RO for Tegra Root Ports due to
>   some hardware issue.  I don't whether these Root Ports every
>   actually *set* RO in the PCIe transactions they generate.  Follow-up
>   [5].
> 
> These concern me because I don't think we have a way for drivers to
> specify whether their writes should use strong ordering or relaxed
> ordering, and I think they depend on strong ordering.

Sorry, I was completely wrong about this part.  Keith Busch reminded
me that writel_relaxed() is an obvious way for drivers to specify that
they don't need strong ordering.

I apologize for the distraction.

> If Root Ports have RO enabled, I think we are at risk, so I suspect
> Linux should actively *disable* RO for Root Ports.
> 
> [1] https://git.kernel.org/linus/d1e714db8129
> [2] https://git.kernel.org/linus/c56d4450eb68
> [3] https://lore.kernel.org/r/20210901222353.GA251391@bjorn-Precision-5520
> [4] https://git.kernel.org/linus/77ffc1465cec
> [5] https://lore.kernel.org/r/20210901204045.GA236987@bjorn-Precision-5520
