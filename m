Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 643EB2EC277
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 18:39:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbhAFRiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 12:38:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:53332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727926AbhAFRiI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 12:38:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 227E020657;
        Wed,  6 Jan 2021 17:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609954647;
        bh=wvCVgOmz5rBzTWJyX2HIEq3vemRTXSP5tILnLdbiAZw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=XgqHOe0d7ap68Z6006lUxnkcWOBj/0K2UTyaLuPru5ONzSPJZfXL+q0+fTFqrIgyD
         QQsSDapc5Qg7l0wd35+8zkewKTj+A4JosJ5vBgW6ggWUHtWJPk9YnB8mMiAbmX5/wo
         smIlQotSwH+mwEbEwER/4UayfFNHYcUSTtRZSAeZEZxmgRbdoumoUd6MGe5BvYNhzd
         ZrcRjKrTRX4845TkN6QU50e/CsHpKXVki3STuroxXWAbVdADv5oRSlHviQFAWMXIXO
         iFriYHv6EQmG1cteXacXLRID4PyaIqay15NDttgMMEKcLbtwncfjnlQ7ExvaOKO95C
         RNnU4KwwFhM2w==
Date:   Wed, 6 Jan 2021 11:37:25 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] ARM: iop32x: improve N2100 PCI broken parity
 quirk'
Message-ID: <20210106173725.GA1316633@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b100322-7a53-8f5e-32f9-a67c3cd2beeb@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 12:05:41PM +0100, Heiner Kallweit wrote:
> Use new PCI core function pci_quirk_broken_parity(), in addition to
> setting broken_parity_status is disables parity checking.

That sentence has a typo or something so it doesn't read quite right.
Maybe:

  Use new PCI core function pci_quirk_broken_parity() to disable
  parity checking.

"broken_parity_status" is basically internal to the PCI core and
doesn't really seem relevant here.  The only uses are the sysfs
store/show functions and edac.

> This allows us to remove a quirk in r8169 driver.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
> v2:
> - remove additional changes from this patch
> ---
>  arch/arm/mach-iop32x/n2100.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-iop32x/n2100.c b/arch/arm/mach-iop32x/n2100.c
> index 78b9a5ee4..9f2aae3cd 100644
> --- a/arch/arm/mach-iop32x/n2100.c
> +++ b/arch/arm/mach-iop32x/n2100.c
> @@ -125,7 +125,7 @@ static void n2100_fixup_r8169(struct pci_dev *dev)
>  	if (dev->bus->number == 0 &&
>  	    (dev->devfn == PCI_DEVFN(1, 0) ||
>  	     dev->devfn == PCI_DEVFN(2, 0)))
> -		dev->broken_parity_status = 1;
> +		pci_quirk_broken_parity(dev);
>  }
>  DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_REALTEK, PCI_ANY_ID, n2100_fixup_r8169);
>  
> -- 
> 2.30.0
> 
> 
