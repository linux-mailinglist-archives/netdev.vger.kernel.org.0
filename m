Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FB939C382
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 00:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhFDW3C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 18:29:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhFDW3B (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 18:29:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BD16610E7;
        Fri,  4 Jun 2021 22:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622845634;
        bh=tUbf9MQN8g59+W4Z+HHhyKliaam7TcTVD+M9OX7jZrQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=Qu2Rly5Fi4alkiiwMxGprVxPhWQLMP7W74fZ9g1qsFKwgywT//Zguoj7zoW5pIDTi
         oPhh5IzJWbOlEq0k1ivfbKyvEuHlbnmCXkG2OTQgk+3Yu2hnT+1p3n+xGfn0jP9euZ
         f3TRmzipNnRSp8r/gPDX08SqfpzTxzT3k+Sn0XigQD4HdsNzAjy1IaBkKv1qwVEAXN
         N8fJDr9RXyzpxP4xEMR6JJaZ9EGJV/btd68Ja94+JPqNFJW+d4Y83FwzpxJSKpHXSw
         gsj4tiHBBFdgkjSuMY4r4Gr4dbn6HUIqZC37faoVhCjU2k12vNrVZ3BSs41r7u0IbU
         0DrGn0dJpsb/Q==
Date:   Fri, 4 Jun 2021 17:27:12 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, sasha.neftin@intel.com,
        anthony.l.nguyen@intel.com, linux-pci@vger.kernel.org,
        bhelgaas@google.com, netdev@vger.kernel.org, mlichvar@redhat.com,
        richardcochran@gmail.com, hch@infradead.org
Subject: Re: [PATCH next-queue v4 2/4] PCI: Add pcie_ptm_enabled()
Message-ID: <20210604222712.GA2246328@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604220933.3974558-3-vinicius.gomes@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 04, 2021 at 03:09:31PM -0700, Vinicius Costa Gomes wrote:
> Adds a predicate that returns if PCIe PTM (Precision Time Measurement)
> is enabled.

Ideally, "Add a predicate ..."

> It will only return true if it's enabled in all the ports in the path
> from the device to the root.
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

But either way,

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  drivers/pci/pcie/ptm.c | 9 +++++++++
>  include/linux/pci.h    | 3 +++
>  2 files changed, 12 insertions(+)
> 
> diff --git a/drivers/pci/pcie/ptm.c b/drivers/pci/pcie/ptm.c
> index 95d4eef2c9e8..8a4ad974c5ac 100644
> --- a/drivers/pci/pcie/ptm.c
> +++ b/drivers/pci/pcie/ptm.c
> @@ -204,3 +204,12 @@ int pci_enable_ptm(struct pci_dev *dev, u8 *granularity)
>  	return 0;
>  }
>  EXPORT_SYMBOL(pci_enable_ptm);
> +
> +bool pcie_ptm_enabled(struct pci_dev *dev)
> +{
> +	if (!dev)
> +		return false;
> +
> +	return dev->ptm_enabled;
> +}
> +EXPORT_SYMBOL(pcie_ptm_enabled);
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index a687dda262dd..fe7f264b2b15 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1619,9 +1619,12 @@ bool pci_ats_disabled(void);
>  
>  #ifdef CONFIG_PCIE_PTM
>  int pci_enable_ptm(struct pci_dev *dev, u8 *granularity);
> +bool pcie_ptm_enabled(struct pci_dev *dev);
>  #else
>  static inline int pci_enable_ptm(struct pci_dev *dev, u8 *granularity)
>  { return -EINVAL; }
> +static inline bool pcie_ptm_enabled(struct pci_dev *dev)
> +{ return false; }
>  #endif
>  
>  void pci_cfg_access_lock(struct pci_dev *dev);
> -- 
> 2.31.1
> 
