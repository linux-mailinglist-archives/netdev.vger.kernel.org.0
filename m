Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97C5730EA34
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 03:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234599AbhBDCbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 21:31:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:56308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232762AbhBDCbC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 21:31:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9102F64E40;
        Thu,  4 Feb 2021 02:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612405821;
        bh=j0OujbClPoUn/vlZNPSoRgOEsqBr4udPYGn1KSINzJ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RY+flW0IrzK+PlULRva2VlP7WH3eQhoKUIoi+AUfPk1b7Nc4lYKK1OQQi/uw+JLCL
         0droTZSZyJp8Vzj2Ti+9/D21+9ZJaD/NUXpNvGhNDDtiMrpywers60x7/qH8SODgxf
         45hZqm0p/Qt1om3d3qbay2rJIBWyhhL04uHKckCouiI2K6TniPppYJxk3U3Yj+VZXr
         9+tEtmBsaZnNUidLopxNS6o2oWXHJIyMoJFKjI7xD2fjtRU+rPQm7bHxwjT/eriF5u
         +TliPv2VfEgSqnC7qbdNtF9vZ6ID8Vt4LHWuCl3e7kFCgbCSlQEyW4GTzpmVlTW1W3
         ueA35mTkcujYA==
Date:   Wed, 3 Feb 2021 18:30:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Raju Rangoju <rajur@chelsio.com>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/4] PCI/VPD: Remove Chelsio T3 quirk
Message-ID: <20210203183019.7c9a5004@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a64e550c-b8d2-889e-1f55-019b10060c1b@gmail.com>
References: <b07dc99d-7fd0-48c0-3fc4-89cda90ee5d7@gmail.com>
        <a64e550c-b8d2-889e-1f55-019b10060c1b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Feb 2021 21:35:55 +0100 Heiner Kallweit wrote:
> cxgb3 driver doesn't use the PCI core code for VPD access, it has its own
> implementation. Therefore we don't need a quirk for it in the core code.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Would this not affect the size of the file under sysfs?

> diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
> index 7915d10f9..db86fe226 100644
> --- a/drivers/pci/vpd.c
> +++ b/drivers/pci/vpd.c
> @@ -628,22 +628,17 @@ static void quirk_chelsio_extend_vpd(struct pci_dev *dev)
>  {
>  	int chip = (dev->device & 0xf000) >> 12;
>  	int func = (dev->device & 0x0f00) >>  8;
> -	int prod = (dev->device & 0x00ff) >>  0;
>  
>  	/*
> -	 * If this is a T3-based adapter, there's a 1KB VPD area at offset
> -	 * 0xc00 which contains the preferred VPD values.  If this is a T4 or
> -	 * later based adapter, the special VPD is at offset 0x400 for the
> -	 * Physical Functions (the SR-IOV Virtual Functions have no VPD
> -	 * Capabilities).  The PCI VPD Access core routines will normally
> +	 * If this is a T4 or later based adapter, the special VPD is at offset
> +	 * 0x400 for the Physical Functions (the SR-IOV Virtual Functions have
> +	 * no VPD Capabilities). The PCI VPD Access core routines will normally
>  	 * compute the size of the VPD by parsing the VPD Data Structure at
>  	 * offset 0x000.  This will result in silent failures when attempting
>  	 * to accesses these other VPD areas which are beyond those computed
>  	 * limits.
>  	 */
> -	if (chip == 0x0 && prod >= 0x20)
> -		pci_set_vpd_size(dev, 8192);
> -	else if (chip >= 0x4 && func < 0x8)
> +	if (chip >= 0x4 && func < 0x8)
>  		pci_set_vpd_size(dev, 2048);
>  }
>  

