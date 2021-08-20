Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A38843F35C0
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 22:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241029AbhHTUvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 16:51:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240757AbhHTUvQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Aug 2021 16:51:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 680FC61042;
        Fri, 20 Aug 2021 20:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629492637;
        bh=acvlAl1v8mDBpIowhQ0R4QANTyQZQe+E9DeC7pzeHUE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=DlPpoQHveSVwPrgdIr3CweEzfkbgiZOqF5IZ1DWGjJVqdR2oZR1yJkdAEppQHgJHU
         K29L8w13nF/v07E5jXxmh61vLD5nkRAXdZww8lwKdSSswNpcA145YM2cxWYozUgHM+
         r853p9BM2Ag8l5uJ+8krgxlvHFctgr4fyg0UFUnFSomj4JvqufFcPol+ZqGn3yAKAr
         /nN1ntrknXUCrQ6RE1gNruxjLN8urENGUyJaz00/zPr1X6zaVK3I0dUpkHFNhxGBtp
         mUzLSG8Mn2jowT10584SxwI/EFWk+MmomHzzrWAD7OcwxuweQNzXkBSUX64pEW64P+
         FWQwquEOAwbCQ==
Date:   Fri, 20 Aug 2021 15:50:36 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 0/8] PCI/VPD: Extend PCI VPD API
Message-ID: <20210820205036.GA3356538@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f693b1ae-447c-0eb1-7a9a-d1aaf9a26641@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 08:58:18PM +0200, Heiner Kallweit wrote:
> This series adds three functions to the PCI VPD API that help to
> simplify driver code. First users are sfc and tg3 drivers because
> I have test hw. The other users of the VPD API will benefit from a
> migration as well.
> I'd propose to apply this series via the PCI tree.
> 
> Added API calls:
> 
> pci_vpd_alloc()
> Dynamically allocates a properly sized buffer and reads the VPD into it.
> 
> pci_vpd_find_ro_info_keyword()
> Locates an info field keyword in the VPD RO section.
> pci_vpd_find_info_keyword() can be removed once all
> users have been migrated.
> 
> pci_vpd_check_csum()
> Check VPD checksum based on algorithm defined in the PCI specification.
> 
> Tested on a SFN6122F and a BCM95719 card.
> 
> Heiner Kallweit (8):
>   PCI/VPD: Add pci_vpd_alloc
>   PCI/VPD: Add pci_vpd_find_ro_info_keyword and pci_vpd_check_csum
>   PCI/VPD: Add missing VPD RO field keywords
>   sfc: Use new function pci_vpd_alloc
>   sfc: Use new VPD API function pci_vpd_find_ro_info_keyword
>   tg3: Use new function pci_vpd_alloc
>   tg3: Use new function pci_vpd_check_csum
>   tg3: Use new function pci_vpd_find_ro_info_keyword
> 
>  drivers/net/ethernet/broadcom/tg3.c | 115 +++++++---------------------
>  drivers/net/ethernet/broadcom/tg3.h |   1 -
>  drivers/net/ethernet/sfc/efx.c      |  78 +++++--------------
>  drivers/pci/vpd.c                   |  82 ++++++++++++++++++++
>  include/linux/pci.h                 |  32 ++++++++
>  5 files changed, 163 insertions(+), 145 deletions(-)

Beautiful!  I applied this with minor tweaks to pci/vpd for v5.15.

I dropped the "add missing keywords" patch because there are no users
of the missing keywords yet.

I would have removed pci_vpd_find_info_keyword() as well, but it looks
like there are stilla few users of it.
