Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6D6734693E
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 20:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhCWTlV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 15:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:41586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230406AbhCWTks (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 15:40:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C753619C0;
        Tue, 23 Mar 2021 19:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616528447;
        bh=q1wCghXfGtNESfb8LvUFnXA1QaR3P+eV4arU6McLM0A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=G8VU+Ll65u/RCjl+xDTrGiRlOTmvv3rCiZYy9RDnpusNv67T9a42opv6RdicxTTsU
         l81QUHbBXlu8Yc+4knMYqr09XyrMIGbc8+buF26naeGqpdhCoGv70oATXPRzBbSqT7
         rE9c4fiMeUKry6J/Ur4exItOkU3XVYFedGileCPaDK3PZ68uRwz9UII5T28QQgBxTZ
         QqBu+V9JgVvEnU0hbtnsus8m1VdsN8Idh3pOAcbSO011D9bC/H/xDtaneJAqp9Lw37
         Xw3q4p/iBYfS1i41A3OLaffeQ83+0Fx28NRi8L9P4/qYWNx68BmAFoL/gQBgBXHD45
         Qujta7Bgnr6HQ==
Date:   Tue, 23 Mar 2021 14:40:46 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, sasha.neftin@intel.com,
        anthony.l.nguyen@intel.com, linux-pci@vger.kernel.org,
        bhelgaas@google.com, netdev@vger.kernel.org, mlichvar@redhat.com,
        richardcochran@gmail.com
Subject: Re: [PATCH next-queue v3 1/3] Revert "PCI: Make pci_enable_ptm()
 private"
Message-ID: <20210323194046.GA598671@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322161822.1546454-2-vinicius.gomes@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 09:18:20AM -0700, Vinicius Costa Gomes wrote:
> Make pci_enable_ptm() accessible from the drivers.
> 
> Even if PTM still works on the platform I am using without calling
> this function, it might be possible that it's not always the case.

I don't understand the value of this paragraph.  The rest of it makes
good sense (although I think we might want to add a wrapper as I
mentioned elsewhere).

> Exposing this to the driver enables the driver to use the
> 'ptm_enabled' field of 'pci_dev' to check if PTM is enabled or not.
> 
> This reverts commit ac6c26da29c12fa511c877c273ed5c939dc9e96c.
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  drivers/pci/pci.h   | 3 ---
>  include/linux/pci.h | 7 +++++++
>  2 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index ef7c4661314f..2c61557e1cc1 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -599,11 +599,8 @@ static inline void pcie_ecrc_get_policy(char *str) { }
>  
>  #ifdef CONFIG_PCIE_PTM
>  void pci_ptm_init(struct pci_dev *dev);
> -int pci_enable_ptm(struct pci_dev *dev, u8 *granularity);
>  #else
>  static inline void pci_ptm_init(struct pci_dev *dev) { }
> -static inline int pci_enable_ptm(struct pci_dev *dev, u8 *granularity)
> -{ return -EINVAL; }
>  #endif
>  
>  struct pci_dev_reset_methods {
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 86c799c97b77..3d3dc07eac3b 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -1610,6 +1610,13 @@ static inline bool pci_aer_available(void) { return false; }
>  
>  bool pci_ats_disabled(void);
>  
> +#ifdef CONFIG_PCIE_PTM
> +int pci_enable_ptm(struct pci_dev *dev, u8 *granularity);
> +#else
> +static inline int pci_enable_ptm(struct pci_dev *dev, u8 *granularity)
> +{ return -EINVAL; }
> +#endif
> +
>  void pci_cfg_access_lock(struct pci_dev *dev);
>  bool pci_cfg_access_trylock(struct pci_dev *dev);
>  void pci_cfg_access_unlock(struct pci_dev *dev);
> -- 
> 2.31.0
> 
