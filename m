Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034E7310B4C
	for <lists+netdev@lfdr.de>; Fri,  5 Feb 2021 13:47:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232307AbhBEMql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Feb 2021 07:46:41 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:40605 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbhBEMnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Feb 2021 07:43:49 -0500
Received: from localhost (kumbhalgarh.blr.asicdesigners.com [10.193.185.255])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 115CgeqE030066;
        Fri, 5 Feb 2021 04:42:41 -0800
Date:   Fri, 5 Feb 2021 18:12:41 +0530
From:   Raju Rangoju <rajur@chelsio.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        rahul.lakkireddy@chelsio.com
Subject: Re: [PATCH net-next 1/4] PCI/VPD: Remove Chelsio T3 quirk
Message-ID: <20210205124236.GA18529@chelsio.com>
References: <b07dc99d-7fd0-48c0-3fc4-89cda90ee5d7@gmail.com>
 <a64e550c-b8d2-889e-1f55-019b10060c1b@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a64e550c-b8d2-889e-1f55-019b10060c1b@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday, February 02/02/21, 2021 at 21:35:55 +0100, Heiner Kallweit wrote:
> cxgb3 driver doesn't use the PCI core code for VPD access, it has its own
> implementation. Therefore we don't need a quirk for it in the core code.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/pci/vpd.c | 13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
> 
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

The above quirk has been added by the following commit to fix VPD access
issue in the guest VM. Wouldn't removing this quirk reopen the original
issue?

----------------------------------------------------------
commit 1c7de2b4ff886a45fbd2f4c3d4627e0f37a9dd77
Author: Alexey Kardashevskiy <aik@ozlabs.ru>
Date:   Mon Oct 24 18:04:17 2016 +1100

PCI: Enable access to non-standard VPD for Chelsio devices (cxgb3)

There is at least one Chelsio 10Gb card which uses VPD area to store 
some non-standard blocks (example below).  However pci_vpd_size() returns the 
length of the first block only assuming that there can be only one VPD "End 
Tag".

Since 4e1a635552d3 ("vfio/pci: Use kernel VPD access functions"), VFIO
blocks access beyond that offset, which prevents the guest "cxgb3" driver
from probing the device.  The host system does not have this problem as its
driver accesses the config space directly without pci_read_vpd().

Add a quirk to override the VPD size to a bigger value.  The maximum size
is taken from EEPROMSIZE in drivers/net/ethernet/chelsio/cxgb3/common.h.
We do not read the tag as the cxgb3 driver does as the driver supports
writing to EEPROM/VPD and when it writes, it only checks for 8192 bytes
boundary.  The quirk is registered for all devices supported by the cxgb3
driver.

This adds a quirk to the PCI layer (not to the cxgb3 driver) as the cxgb3
driver itself accesses VPD directly and the problem only exists with the
vfio-pci driver (when cxgb3 is not running on the host and may not be even
loaded) which blocks accesses beyond the first block of VPD data. However
vfio-pci itself does not have quirks mechanism so we add it to PCI.

This is the controller:
Ethernet controller [0200]: Chelsio Communications Inc T310 10GbE Single
Port Adapter [1425:0030]

This is what I parsed from its VPD:
===
  b'\x82*\x0010 Gigabit Ethernet-SR PCI Express Adapter\x90J\x00EC\x07D76809
  FN\x0746K'

  0000 Large item 42 bytes; name 0x2 Identifier	String
	b'10 Gigabit Ethernet-SR PCI Express Adapter'
    002d Large item 74	bytes; name 0x10
	#00 [EC] len=7:	b'D76809'
	#0a [FN] len=7:	b'46K7897'
	#14 [PN] len=7:	b'46K7897'
	#1e [MN] len=4:	b'1037'
	#25 [FC] len=4:	b'5769'
	#2c [SN] len=12: b'YL102035603V'
	#3b [NA] len=12: b'00145E992ED1'
    007a Small item 1 bytes; name 0xf End Tag
    0c00 Large item 16 bytes; name 0x2 Identifier String
	b'S310E-SR-X      '
    0c13 Large item 234 bytes; name 0x10
	#00 [PN] len=16: b'TBD             '
	#13 [EC] len=16: b'110107730D2     '
	#26 [SN] len=16: b'97YL102035603V  '
	#39 [NA] len=12: b'00145E992ED1'
	#48 [V0] len=6: b'175000'
	#51 [V1] len=6: b'266666'
	#5a [V2] len=6: b'266666'
	#63 [V3] len=6: b'2000  '
	#6c [V4] len=2: b'1 '
	#71 [V5] len=6: b'c2    '
	#7a [V6] len=6: b'0     '
	#83 [V7] len=2: b'1 '
	#88 [V8] len=2: b'0 '
	#8d [V9] len=2: b'0 '
	#92 [VA] len=2: b'0 '
	#97 [RV] len=80:
	b's\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00'...
   0d00 Large item 252 bytes; name 0x11
	#00 [VC] len=16: b'122310_1222 dp  '
	#13 [VD] len=16: b'610-0001-00 H1\x00\x00'
	#26 [VE] len=16: b'122310_1353 fp  '
	#39 [VF] len=16: b'610-0001-00 H1\x00\x00'
	 #4c [RW] len=173:
	 b'\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00'...
   0dff Small item 0 bytes; name 0xf End Tag

   10f3 Large item 13315 bytes; name 0x62
   !!! unknown item name 98:
   b'\xd0\x03\x00@`\x0c\x08\x00\x00\x00\x00\x00\x00\x00\x00\x00'
   ===

   Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
   Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

---------------------------------------------


> -	else if (chip >= 0x4 && func < 0x8)
> +	if (chip >= 0x4 && func < 0x8)
>  		pci_set_vpd_size(dev, 2048);
>  }
>  
> -- 
> 2.30.0
> 
> 
