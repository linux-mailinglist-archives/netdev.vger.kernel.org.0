Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5147A2EB6E5
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:29:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbhAFA3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:29:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:47606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726328AbhAFA3P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 19:29:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE04022CE3;
        Wed,  6 Jan 2021 00:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609892915;
        bh=V/ESplGs+J5p3tCKo1dio8HrjKM5HOXa0Nj+i1IkqtA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Y3ttC/6dDKAwlv2MCKl6J9dK2KAZDv5afed69j8x/3CtPCz7CIgWqXtuJsMMWnuLX
         S52GW0H1GvcXeajYX+FhGsw0RL2S/3V2UmZGMj97T3S/vs6iZX6RiciASaykiaoG0Z
         T+BXgAq3LJjAESz7l1rRoBD0ru2qLEFU5OphXfrKj50BeMF9C1nRe+JebNV5ccjDVw
         E5YnZNbf/g5xLnCxg7r8POe8MmnIdhXURY80DrrIOETXqgAOOaD0qqQI++G2wO1had
         CNQ9T2rYvArwJFvQzkPEDZSrOx3BuUDEhaAHhrSPaBNLglzH+HLqLtQmK7Ma24RMWn
         PzguiKsYZpqFQ==
Date:   Tue, 5 Jan 2021 18:28:33 -0600
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
Subject: Re: [PATCH 2/3] ARM: iop32x: improve N2100 PCI broken parity quirk
Message-ID: <20210106002833.GA1286114@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d53b6377-ff2a-3bba-612f-d052ffa81d09@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 05, 2021 at 10:42:31AM +0100, Heiner Kallweit wrote:
> Simplify the quirk by using new PCI core function
> pci_quirk_broken_parity(). In addition make the quirk
> more specific, use device id 0x8169 instead of PCI_ANY_ID.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  arch/arm/mach-iop32x/n2100.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/mach-iop32x/n2100.c b/arch/arm/mach-iop32x/n2100.c
> index 78b9a5ee4..24c3eec46 100644
> --- a/arch/arm/mach-iop32x/n2100.c
> +++ b/arch/arm/mach-iop32x/n2100.c
> @@ -122,12 +122,10 @@ static struct hw_pci n2100_pci __initdata = {
>   */
>  static void n2100_fixup_r8169(struct pci_dev *dev)
>  {
> -	if (dev->bus->number == 0 &&
> -	    (dev->devfn == PCI_DEVFN(1, 0) ||
> -	     dev->devfn == PCI_DEVFN(2, 0)))
> -		dev->broken_parity_status = 1;
> +	if (machine_is_n2100())
> +		pci_quirk_broken_parity(dev);

Whatever "machine_is_n2100()" is (I can't find the definition), it is
surely not equivalent to "00:01.0 || 00:02.0".  That change probably
should be a separate patch with some explanation.

If this makes the quirk safe to use in a generic kernel, that sounds
like a good thing.

I guess a parity problem could be the result of a defect in either the
device (e.g., 0x8169), which would be an issue in *all* platforms, or
a platform-specific issue in the way it's wired up.  I assume it's the
latter because the quirk is not in drivers/pci/quirks.c.

Why is it safe to restrict this to device ID 0x8169?  If this is
platform issue, it might affect any device in the slot.

>  }
> -DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_REALTEK, PCI_ANY_ID, n2100_fixup_r8169);
> +DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_REALTEK, 0x8169, n2100_fixup_r8169);
>  
>  static int __init n2100_pci_init(void)
>  {
> -- 
> 2.30.0
> 
> 
