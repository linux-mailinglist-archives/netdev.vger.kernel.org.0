Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18FCFD2B55
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 15:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388055AbfJJN3x convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Oct 2019 09:29:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:48462 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727489AbfJJN3w (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 09:29:52 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 17B43AC40;
        Thu, 10 Oct 2019 13:29:50 +0000 (UTC)
Date:   Thu, 10 Oct 2019 15:29:49 +0200
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        netdev@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH v8 3/5] mfd: ioc3: Add driver for SGI IOC3 chip
Message-Id: <20191010152949.f5049c2728beffa38f07c924@suse.de>
In-Reply-To: <20191009201714.19296e3f@cakuba.netronome.com>
References: <20191009101713.12238-1-tbogendoerfer@suse.de>
        <20191009101713.12238-4-tbogendoerfer@suse.de>
        <20191009201714.19296e3f@cakuba.netronome.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 9 Oct 2019 20:17:14 -0700
Jakub Kicinski <jakub.kicinski@netronome.com> wrote:

> On Wed,  9 Oct 2019 12:17:10 +0200, Thomas Bogendoerfer wrote:
> [...]
> > +static int ioc3_cad_duo_setup(struct ioc3_priv_data *ipd)
> > +{
> > +	int ret;
> > +
> > +	ret = ioc3_irq_domain_setup(ipd, ipd->pdev->irq);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = ioc3_eth_setup(ipd, true);
> > +	if (ret)
> > +		return ret;
> > +
> > +	return ioc3_kbd_setup(ipd);
> > +}
> 
> None of these setup calls have a "cleanup" or un-setup call. Is this
> really okay? I know nothing about MFD, but does mfd_add_devices() not
> require a remove for example? Doesn't the IRQ handling need cleanup?

good catch, I'll add that.

> > +	ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
> > +	if (ret) {
> > +		dev_warn(&pdev->dev,
> > +			 "Failed to set 64-bit DMA mask, trying 32-bit\n");
> > +		ret = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(32));
> > +		if (ret) {
> > +			dev_err(&pdev->dev, "Can't set DMA mask, aborting\n");
> > +			return ret;
> 
> So failing here we don't care about disabling the pci deivce..

fixed in the next version.

> > +
> > +	/*
> > +	 * Map all IOC3 registers.  These are shared between subdevices
> > +	 * so the main IOC3 module manages them.
> > +	 */
> > +	regs = pci_ioremap_bar(pdev, 0);
> 
> This doesn't seem unmapped on error paths, nor remove?

will fix.

Thank you for the review.

Thomas.

-- 
SUSE Software Solutions Germany GmbH
HRB 247165 (AG München)
Geschäftsführer: Felix Imendörffer
