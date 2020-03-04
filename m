Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F773179BE0
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 23:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388410AbgCDWmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 17:42:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:47932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387931AbgCDWmH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 17:42:07 -0500
Received: from localhost (mobile-166-175-186-165.mycingular.net [166.175.186.165])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29E4520716;
        Wed,  4 Mar 2020 22:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583361726;
        bh=vVWl42UrJyKCwvpt0XSfsWqhyM0OXuQwUc19JT3Tmsw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=1p3GOti0Ihtjw+1D7hdmI7sib3LPSqh5A8XcqGhUAP0fxQHB4eJ2GK6pwVHVYai1W
         IHRJGSX9o33kBY+JTRdtZXGm41DwDdBjkV3TARqb+2usum7Dec9VmPhjQupu2hB6JA
         bSvOrvLo2Mt1NTL9g6Cqt251K5HKr8yYWICe3Kc4=
Date:   Wed, 4 Mar 2020 16:42:04 -0600
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     linux-pci@vger.kernel.org, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Michael Chan <michael.chan@broadcom.com>
Subject: Re: [PATCH v2 1/6] PCI: Introduce pci_get_dsn
Message-ID: <20200304224204.GA33207@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303022506.1792776-2-jacob.e.keller@intel.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 02, 2020 at 06:25:00PM -0800, Jacob Keller wrote:
> Several device drivers read their Device Serial Number from the PCIe
> extended config space.
> 
> Introduce a new helper function, pci_get_dsn(). This function reads the
> eight bytes of the DSN and returns them as a u64. If the capability does not
> exist for the device, the function returns 0.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> Cc: Michael Chan <michael.chan@broadcom.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Looks good, thanks!  Feel free to merge this via the net tree.

> ---
>  drivers/pci/pci.c   | 34 ++++++++++++++++++++++++++++++++++
>  include/linux/pci.h |  5 +++++
>  2 files changed, 39 insertions(+)
> 
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index d828ca835a98..03f50e706c0d 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -557,6 +557,40 @@ int pci_find_ext_capability(struct pci_dev *dev, int cap)
>  }
>  EXPORT_SYMBOL_GPL(pci_find_ext_capability);
>  
> +/**
> + * pci_get_dsn - Read and return the 8-byte Device Serial Number
> + * @dev: PCI device to query
> + *
> + * Looks up the PCI_EXT_CAP_ID_DSN and reads the 8 bytes of the Device Serial
> + * Number.
> + *
> + * Returns the DSN, or zero if the capability does not exist.
> + */
> +u64 pci_get_dsn(struct pci_dev *dev)
> +{
> +	u32 dword;
> +	u64 dsn;
> +	int pos;
> +
> +	pos = pci_find_ext_capability(dev, PCI_EXT_CAP_ID_DSN);
> +	if (!pos)
> +		return 0;
> +
> +	/*
> +	 * The Device Serial Number is two dwords offset 4 bytes from the
> +	 * capability position. The specification says that the first dword is
> +	 * the lower half, and the second dword is the upper half.
> +	 */
> +	pos += 4;
> +	pci_read_config_dword(dev, pos, &dword);
> +	dsn = (u64)dword;
> +	pci_read_config_dword(dev, pos + 4, &dword);
> +	dsn |= ((u64)dword) << 32;
> +
> +	return dsn;
> +}
> +EXPORT_SYMBOL_GPL(pci_get_dsn);
> +
>  static int __pci_find_next_ht_cap(struct pci_dev *dev, int pos, int ht_cap)
>  {
>  	int rc, ttl = PCI_FIND_CAP_TTL;
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 3840a541a9de..d92cf2da1ae1 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1045,6 +1045,8 @@ int pci_find_ht_capability(struct pci_dev *dev, int ht_cap);
>  int pci_find_next_ht_capability(struct pci_dev *dev, int pos, int ht_cap);
>  struct pci_bus *pci_find_next_bus(const struct pci_bus *from);
>  
> +u64 pci_get_dsn(struct pci_dev *dev);
> +
>  struct pci_dev *pci_get_device(unsigned int vendor, unsigned int device,
>  			       struct pci_dev *from);
>  struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
> @@ -1699,6 +1701,9 @@ static inline int pci_find_next_capability(struct pci_dev *dev, u8 post,
>  static inline int pci_find_ext_capability(struct pci_dev *dev, int cap)
>  { return 0; }
>  
> +static inline u64 pci_get_dsn(struct pci_dev *dev)
> +{ return 0; }
> +
>  /* Power management related routines */
>  static inline int pci_save_state(struct pci_dev *dev) { return 0; }
>  static inline void pci_restore_state(struct pci_dev *dev) { }
> -- 
> 2.25.0.368.g28a2d05eebfb
> 
