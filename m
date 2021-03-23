Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97995346911
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 20:30:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbhCWT3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 15:29:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230327AbhCWT3W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 15:29:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4C23619C0;
        Tue, 23 Mar 2021 19:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616527762;
        bh=VFfthgrx5eg5s7ViJTgggc7NvEWm00e/YlW73Py92H8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=E5gLsn81PDKuJBowb2D3xFoo9pj68DMGA5H7CFoXuDyxYPH2V5HoUy86gIhNG8mN6
         MqHwzY85AX8RDp7gQ7zW9P0eTMZWktgz8qLmhXfcB+jJGg2/T02Pp7jGsvS6vwBm+/
         anh+5F+U7FDh4Kr6eZTAJyKcuXTzGBu//Kznz+Jt6BNn5noZq5CxZgJc8c7wH/i/wd
         iwjuCVqfwFVldmvRUt7TI0lPuAukVl5CX95K/Wf9NLbzugO8gN+P8qxxHdoslQKChZ
         zkUzjJYHL3i88qgqhv8TJdnt8YxTf3kIYauCFLTklBV0ekorAiwWYcQvaXO3TIbWmL
         uJtZ8li3WRZxw==
Date:   Tue, 23 Mar 2021 14:29:20 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, sasha.neftin@intel.com,
        anthony.l.nguyen@intel.com, linux-pci@vger.kernel.org,
        bhelgaas@google.com, netdev@vger.kernel.org, mlichvar@redhat.com,
        richardcochran@gmail.com
Subject: Re: [PATCH next-queue v3 2/3] igc: Enable PCIe PTM
Message-ID: <20210323192920.GA597326@bjorn-Precision-5520>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322161822.1546454-3-vinicius.gomes@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 09:18:21AM -0700, Vinicius Costa Gomes wrote:
> In practice, enabling PTM also sets the enabled_ptm flag in the PCI
> device, the flag will be used for detecting if PTM is enabled before
> adding support for the SYSOFFSET_PRECISE ioctl() (which is added by
> implementing the getcrosststamp() PTP function).

I think you're referring to the "pci_dev.ptm_enabled" flag.  I'm not
sure what the connection to this patch is.  The SYSOFFSET_PRECISE
stuff also seems to belong with some other patch.

This patch merely enables PTM if it's supported (might be worth
expanding Precision Time Measurement for context).

> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>  drivers/net/ethernet/intel/igc/igc_main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
> index f77feadde8d2..04319ffae288 100644
> --- a/drivers/net/ethernet/intel/igc/igc_main.c
> +++ b/drivers/net/ethernet/intel/igc/igc_main.c
> @@ -12,6 +12,8 @@
>  #include <net/pkt_sched.h>
>  #include <linux/bpf_trace.h>
>  #include <net/xdp_sock_drv.h>
> +#include <linux/pci.h>
> +
>  #include <net/ipv6.h>
>  
>  #include "igc.h"
> @@ -5792,6 +5794,10 @@ static int igc_probe(struct pci_dev *pdev,
>  
>  	pci_enable_pcie_error_reporting(pdev);
>  
> +	err = pci_enable_ptm(pdev, NULL);
> +	if (err < 0)
> +		dev_err(&pdev->dev, "PTM not supported\n");
> +
>  	pci_set_master(pdev);
>  
>  	err = -ENOMEM;
> -- 
> 2.31.0
> 
