Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7D83E4ACC
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 19:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234224AbhHIR1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 13:27:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:34584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233919AbhHIR1N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 13:27:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FF0560E76;
        Mon,  9 Aug 2021 17:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628530012;
        bh=buSTqTbG/oBGoxhf5x4r6tPBmWExFvWrwgCPeuyzVRA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=RdXER6CuicO2+Qz3/v5QyKQcchBRfHZUC1NC8bfPRuE8ayJCKOTjkt7BhBFjTy1Zz
         wOqttt3Axc0FMVgPEJEpFT7Swj0jUFY6dXmZVtw8GsO0gX4Y9Bk/vwk5dG5LoMwZu/
         785pGTXVe/Z1Nk6cZ3bpI8PuuAx5zoOY2LOinHQ4kgttGt19xHrtgONTFL09ZpXpK8
         mRUTT9Ck0niVoMSrxHcLUXKmMtMy9oD1FD8K0XtwEUar0hd/ht83glwFY1lBoLf3xe
         6Cz8m8S4Te+ykv8zWxIR83Y22zJ4uvcsNAv5Q0ZM8kNpFlDKhWx2tetlTeqqX/97kd
         or/qqwDAZB9hQ==
Date:   Mon, 9 Aug 2021 12:26:50 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Dongdong Liu <liudongdong3@huawei.com>
Cc:     hch@infradead.org, kw@linux.com, logang@deltatee.com,
        leon@kernel.org, linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl, linux-media@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH V7 6/9] PCI: Enable 10-Bit Tag support for PCIe RP devices
Message-ID: <20210809172650.GA1897893@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2e8b035-42c1-9eb6-986f-1de78cffeef0@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 04:25:23PM +0800, Dongdong Liu wrote:
> On 2021/8/5 7:38, Bjorn Helgaas wrote:
> > On Wed, Aug 04, 2021 at 09:47:05PM +0800, Dongdong Liu wrote:
> > > PCIe spec 5.0r1.0 section 2.2.6.2 implementation note, In configurations
> > > where a Requester with 10-Bit Tag Requester capability needs to target
> > > multiple Completers, one needs to ensure that the Requester sends 10-Bit
> > > Tag Requests only to Completers that have 10-Bit Tag Completer capability.
> > > So we enable 10-Bit Tag Requester for root port only when the devices
> > > under the root port support 10-Bit Tag Completer.
> > 
> > Fix quoting.  I can't tell what is from the spec and what you wrote.
> Will fix.
> > 
> > > Signed-off-by: Dongdong Liu <liudongdong3@huawei.com>
> > > ---
> > >  drivers/pci/pcie/portdrv_pci.c | 69 ++++++++++++++++++++++++++++++++++++++++++
> > >  1 file changed, 69 insertions(+)
> > > 
> > > diff --git a/drivers/pci/pcie/portdrv_pci.c b/drivers/pci/pcie/portdrv_pci.c
> > > index c7ff1ee..2382cd2 100644
> > > --- a/drivers/pci/pcie/portdrv_pci.c
> > > +++ b/drivers/pci/pcie/portdrv_pci.c
> > > @@ -90,6 +90,72 @@ static const struct dev_pm_ops pcie_portdrv_pm_ops = {
> > >  #define PCIE_PORTDRV_PM_OPS	NULL
> > >  #endif /* !PM */
> > > 
> > > +static int pci_10bit_tag_comp_support(struct pci_dev *dev, void *data)
> > > +{
> > > +	bool *support = (bool *)data;
> > > +
> > > +	if (!pci_is_pcie(dev)) {
> > > +		*support = false;
> > > +		return 1;
> > > +	}
> > > +
> > > +	/*
> > > +	 * PCIe spec 5.0r1.0 section 2.2.6.2 implementation note.
> > > +	 * For configurations where a Requester with 10-Bit Tag Requester
> > > +	 * capability targets Completers where some do and some do not have
> > > +	 * 10-Bit Tag Completer capability, how the Requester determines which
> > > +	 * NPRs include 10-Bit Tags is outside the scope of this specification.
> > > +	 * So we do not consider hotplug scenario.
> > > +	 */
> > > +	if (dev->is_hotplug_bridge) {
> > > +		*support = false;
> > > +		return 1;
> > > +	}
> > > +
> > > +	if (!(dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_COMP)) {
> > > +		*support = false;
> > > +		return 1;
> > > +	}
> > > +
> > > +	return 0;
> > > +}
> > > +
> > > +static void pci_configure_rp_10bit_tag(struct pci_dev *dev)
> > > +{
> > > +	bool support = true;
> > > +
> > > +	if (dev->subordinate == NULL)
> > > +		return;
> > > +
> > > +	/* If no devices under the root port, no need to enable 10-Bit Tag. */
> > > +	if (list_empty(&dev->subordinate->devices))
> > > +		return;
> > > +
> > > +	pci_10bit_tag_comp_support(dev, &support);
> > > +	if (!support)
> > > +		return;
> > > +
> > > +	/*
> > > +	 * PCIe spec 5.0r1.0 section 2.2.6.2 implementation note.
> > > +	 * In configurations where a Requester with 10-Bit Tag Requester
> > > +	 * capability needs to target multiple Completers, one needs to ensure
> > > +	 * that the Requester sends 10-Bit Tag Requests only to Completers
> > > +	 * that have 10-Bit Tag Completer capability. So we enable 10-Bit Tag
> > > +	 * Requester for root port only when the devices under the root port
> > > +	 * support 10-Bit Tag Completer.
> > > +	 */
> > > +	pci_walk_bus(dev->subordinate, pci_10bit_tag_comp_support, &support);
> > > +	if (!support)
> > > +		return;
> > > +
> > > +	if (!(dev->pcie_devcap2 & PCI_EXP_DEVCAP2_10BIT_TAG_REQ))
> > > +		return;
> > > +
> > > +	pci_dbg(dev, "enabling 10-Bit Tag Requester\n");
> > > +	pcie_capability_set_word(dev, PCI_EXP_DEVCTL2,
> > > +				 PCI_EXP_DEVCTL2_10BIT_TAG_REQ_EN);
> > > +}
> > > +
> > >  /*
> > >   * pcie_portdrv_probe - Probe PCI-Express port devices
> > >   * @dev: PCI-Express port device being probed
> > > @@ -111,6 +177,9 @@ static int pcie_portdrv_probe(struct pci_dev *dev,
> > >  	     (type != PCI_EXP_TYPE_RC_EC)))
> > >  		return -ENODEV;
> > > 
> > > +	if (type == PCI_EXP_TYPE_ROOT_PORT)
> > > +		pci_configure_rp_10bit_tag(dev);
> > 
> > I don't think this has anything to do with the portdrv, so all this
> > should go somewhere else.
>
> Yes, any suggestion where to put the code?

It seems similar to pci_configure_ltr(), pci_configure_eetlp_prefix(),
and other things in drivers/pci/probe.c, so maybe there?

Or, if this is more of a theoretical advantage than a demonstrated
performance improvement, we could just hold off on doing it until it
becomes important.  I can't tell if you have a scenario that actually
benefits from this yet.

> > Out of curiosity, IIUC this enables 10-bit tags for MMIO transactions
> > from the root port toward the device, i.e., traffic that originates
> > from a CPU.  Is that a significant benefit?  I would expect high-speed
> > devices would primarily operate via DMA with relatively little MMIO
> > traffic.
>
> The benefits of 10-Bit Tag for EP are obvious.
> There are few RP scenarios. Unless there are two:
> 1. RC has its own DMA.
> 2. The P2P tag is replaced at the RP when the P2PDMA go through RP.

