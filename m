Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9673235278
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 14:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728995AbgHAM4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 08:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726471AbgHAM4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Aug 2020 08:56:46 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 666AAC06174A;
        Sat,  1 Aug 2020 05:56:46 -0700 (PDT)
Received: from nazgul.tnic (unknown [78.130.214.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id B8CAE1EC02FA;
        Sat,  1 Aug 2020 14:56:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1596286602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=NfmlZOrLaBmBGlzbXE5z6x4RKpqqJJmlzC4+91fmYUA=;
        b=n/7VNWjNwrVYldmM5JNyqQEVZd3Vp3hpjJSMuFhfSkrW8mQhIHtpfasKy9w1BEromsKKyZ
        /CdJ8nlcvZTCqyn05aBVgUH+WGtmqEhe61zMEoDcH8PmujGuHYORgBg9sVbSuZSh5qLljK
        uihuEhdcnAWg6tPbjyrRXoOKhqTEw/0=
Date:   Sat, 1 Aug 2020 14:56:57 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     "Saheed O. Bolarinwa" <refactormyself@gmail.com>
Cc:     helgaas@kernel.org, Kalle Valo <kvalo@codeaurora.org>,
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
Message-ID: <20200801125657.GA25391@nazgul.tnic>
References: <20200801112446.149549-1-refactormyself@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200801112446.149549-1-refactormyself@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 01, 2020 at 01:24:29PM +0200, Saheed O. Bolarinwa wrote:
> The return value of pci_read_config_*() may not indicate a device error.
> However, the value read by these functions is more likely to indicate
> this kind of error. This presents two overlapping ways of reporting
> errors and complicates error checking.

So why isn't the *value check done in the pci_read_config_* functions
instead of touching gazillion callers?

For example, pci_conf{1,2}_read() could check whether the u32 *value it
just read depending on the access method, whether that value is ~0 and
return proper PCIBIOS_ error in that case.

The check you're replicating

	if (val32 == (u32)~0)

everywhere, instead, is just ugly and tests a naked value ~0 which
doesn't mean anything...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
