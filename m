Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8111766DA
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 23:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgCBWZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 17:25:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:38858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726700AbgCBWZM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 17:25:12 -0500
Received: from localhost (mobile-166-175-186-165.mycingular.net [166.175.186.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B35312465D;
        Mon,  2 Mar 2020 22:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583187912;
        bh=CDhGcUfw787zc0VE8UcGNS8gfPoiSx89SWQtbWtTV2o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=OAbDxpXPHgpYRpR7263JPUcp0o25FZX50iNMrdhav3mWgeA5PqZ8ZAVy4rDm+V98T
         tOdzW/rsq1ZvXHLVfHVlEiLAt/Pra7UNb0TqUeHyvpcM3MWEjiRPCi6NXnF47rs0R5
         IpI1Vt9qmFrrr5wD6NMTGsTio7qssZLWD84tvWS4=
Date:   Mon, 2 Mar 2020 16:25:10 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        QLogic-Storage-Upstream@cavium.com,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH 1/5] pci: introduce pci_get_dsn
Message-ID: <20200302222510.GA172509@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200227223635.1021197-3-jacob.e.keller@intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  PCI: Introduce pci_get_dsn()

I learned this from "git log --oneline drivers/pci/pci.c".  It looks
like the other patches could benefit from this as well.

On Thu, Feb 27, 2020 at 02:36:31PM -0800, Jacob Keller wrote:
> Several device drivers read their Device Serial Number from the PCIe
> extended config space.
> 
> Introduce a new helper function, pci_get_dsn, which will read the
> eight bytes of the DSN into the provided buffer.

"pci_get_dsn()"

> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: QLogic-Storage-Upstream@cavium.com
> Cc: Michael Chan <michael.chan@broadcom.com>
> ---
>  drivers/pci/pci.c   | 33 +++++++++++++++++++++++++++++++++
>  include/linux/pci.h |  5 +++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index d828ca835a98..12d8101724d7 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -33,6 +33,7 @@
>  #include <linux/pci-ats.h>
>  #include <asm/setup.h>
>  #include <asm/dma.h>
> +#include <asm/unaligned.h>
>  #include <linux/aer.h>
>  #include "pci.h"
>  
> @@ -557,6 +558,38 @@ int pci_find_ext_capability(struct pci_dev *dev, int cap)
>  }
>  EXPORT_SYMBOL_GPL(pci_find_ext_capability);
>  
> +/**
> + * pci_get_dsn - Read the 8-byte Device Serial Number
> + * @dev: PCI device to query
> + * @dsn: storage for the DSN. Must be at least 8 bytes
> + *
> + * Looks up the PCI_EXT_CAP_ID_DSN and reads the 8 bytes into the dsn storage.
> + * Returns -EOPNOTSUPP if the device does not have the capability.
> + */
> +int pci_get_dsn(struct pci_dev *dev, u8 dsn[])
> +{
> +	u32 dword;
> +	int pos;
> +
> +
> +	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_DSN);
> +	if (!pos)
> +		return -EOPNOTSUPP;
> +
> +	/*
> +	 * The Device Serial Number is two dwords offset 4 bytes from the
> +	 * capability position.
> +	 */
> +	pos += 4;
> +	pci_read_config_dword(dev, pos, &dword);
> +	put_unaligned_le32(dword, &dsn[0]);
> +	pci_read_config_dword(dev, pos + 4, &dword);
> +	put_unaligned_le32(dword, &dsn[4]);

Since the serial number is a 64-bit value, can we just return a u64
and let the caller worry about any alignment and byte-order issues?

This would be the only use of asm/unaligned.h in driver/pci, and I
don't think DSN should be that special.

I think it's OK if we return 0 if the device doesn't have a DSN
capability.  A DSN that actually contains a zero serial number would
be dubious at best.

> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(pci_get_dsn);
> +
>  static int __pci_find_next_ht_cap(struct pci_dev *dev, int pos, int ht_cap)
>  {
>  	int rc, ttl = PCI_FIND_CAP_TTL;
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 3840a541a9de..883562323df3 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1045,6 +1045,8 @@ int pci_find_ht_capability(struct pci_dev *dev, int ht_cap);
>  int pci_find_next_ht_capability(struct pci_dev *dev, int pos, int ht_cap);
>  struct pci_bus *pci_find_next_bus(const struct pci_bus *from);
>  
> +int pci_get_dsn(struct pci_dev *dev, u8 dsn[]);
> +
>  struct pci_dev *pci_get_device(unsigned int vendor, unsigned int device,
>  			       struct pci_dev *from);
>  struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
> @@ -1699,6 +1701,9 @@ static inline int pci_find_next_capability(struct pci_dev *dev, u8 post,
>  static inline int pci_find_ext_capability(struct pci_dev *dev, int cap)
>  { return 0; }
>  
> +static inline int pci_get_dsn(struct pci_dev *dev, u8 dsn[])
> +{ return -EOPNOTSUPP; }
> +
>  /* Power management related routines */
>  static inline int pci_save_state(struct pci_dev *dev) { return 0; }
>  static inline void pci_restore_state(struct pci_dev *dev) { }
> -- 
> 2.25.0.368.g28a2d05eebfb
> 
