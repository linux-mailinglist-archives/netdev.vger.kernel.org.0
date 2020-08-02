Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81191235A68
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgHBUSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:18:45 -0400
Received: from mail.skyhub.de ([5.9.137.197]:58748 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725910AbgHBUSo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 16:18:44 -0400
Received: from nazgul.tnic (unknown [78.130.214.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4D2291EC02A8;
        Sun,  2 Aug 2020 22:18:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1596399520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=z0K+vlWV9j7wfXLQcUnvdJhwiVrF38RAZueHzdmaci0=;
        b=IpVr02DQwE3yYwTGqHzkePquczoIuB3CSh4JRazV28rb0yxVyTjgJHeFSYXLscJQCgocj+
        YjGRmfK2vuZ4xdnOu8V6Bj4srNoX1QpTQVYAD0HdeQama4rhKTHzaxEhs3BC4FYYx+fxXN
        dZeZiogCz7IvNzoJKsyyZMEOy76rM2w=
Date:   Sun, 2 Aug 2020 22:18:06 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Saheed Bolarinwa <refactormyself@gmail.com>, trix@redhat.com,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Joerg Roedel <joro@8bytes.org>, bjorn@helgaas.com,
        skhan@linuxfoundation.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-mtd@lists.infradead.org, iommu@lists.linux-foundation.org,
        linux-rdma@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-hwmon@vger.kernel.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        linux-gpio@vger.kernel.org, linux-fpga@vger.kernel.org,
        linux-edac@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net
Subject: Re: [RFC PATCH 00/17] Drop uses of pci_read_config_*() return value
Message-ID: <20200802201806.GA24437@nazgul.tnic>
References: <20200802184648.GA23190@nazgul.tnic>
 <20200802191406.GA248232@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200802191406.GA248232@bjorn-Precision-5520>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 02, 2020 at 02:14:06PM -0500, Bjorn Helgaas wrote:
> Wait, I'm not convinced yet.  I know that if a PCI read fails, you
> normally get ~0 data because the host bridge fabricates it to complete
> the CPU load.
> 
> But what guarantees that a PCI config register cannot contain ~0?

Well, I don't think you can differentiate that case, right?

I guess this is where the driver knowledge comes into play: if the read
returns ~0, the pci_read_config* should probably return in that case
something like:

	PCIBIOS_READ_MAYBE_FAILED

to denote it is all 1s and then the caller should be able to determine,
based on any of domain:bus:slot.func and whatever else the driver knows
about its hardware, whether the 1s are a valid value or an error.
Hopefully.

Or something better of which I cannot think of right now...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
