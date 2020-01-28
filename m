Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D423114B351
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 12:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725974AbgA1LJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 06:09:27 -0500
Received: from foss.arm.com ([217.140.110.172]:55288 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgA1LJ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jan 2020 06:09:27 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 09CAE30E;
        Tue, 28 Jan 2020 03:09:24 -0800 (PST)
Received: from e121166-lin.cambridge.arm.com (e121166-lin.cambridge.arm.com [10.1.196.255])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 147EF3F52E;
        Tue, 28 Jan 2020 03:09:20 -0800 (PST)
Date:   Tue, 28 Jan 2020 11:09:16 +0000
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Makarand Pawagi <makarand.pawagi@nxp.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
        linux@armlinux.org.uk, jon@solid-run.com,
        cristian.sovaiala@nxp.com, laurentiu.tudor@nxp.com,
        ioana.ciornei@nxp.com, V.Sethi@nxp.com, calvin.johnson@nxp.com,
        pankaj.bansal@nxp.com, guohanjun@huawei.com, sudeep.holla@arm.com,
        rjw@rjwysocki.net, lenb@kernel.org, stuyoder@gmail.com,
        tglx@linutronix.de, jason@lakedaemon.net, maz@kernel.org,
        shameerali.kolothum.thodi@huawei.com, will@kernel.org,
        robin.murphy@arm.com, nleeder@codeaurora.org
Subject: Re: [PATCH] bus: fsl-mc: Add ACPI support for fsl-mc
Message-ID: <20200128110916.GA491@e121166-lin.cambridge.arm.com>
References: <1580198925-50411-1-git-send-email-makarand.pawagi@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580198925-50411-1-git-send-email-makarand.pawagi@nxp.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 28, 2020 at 01:38:45PM +0530, Makarand Pawagi wrote:
> ACPI support is added in the fsl-mc driver. Driver will parse
> MC DSDT table to extract memory and other resorces.
> 
> Interrupt (GIC ITS) information will be extracted from MADT table
> by drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c.
> 
> IORT table will be parsed to configure DMA.
> 
> Signed-off-by: Makarand Pawagi <makarand.pawagi@nxp.com>
> ---
>  drivers/acpi/arm64/iort.c                   | 53 +++++++++++++++++++++
>  drivers/bus/fsl-mc/dprc-driver.c            |  3 +-
>  drivers/bus/fsl-mc/fsl-mc-bus.c             | 48 +++++++++++++------
>  drivers/bus/fsl-mc/fsl-mc-msi.c             | 10 +++-
>  drivers/bus/fsl-mc/fsl-mc-private.h         |  4 +-
>  drivers/irqchip/irq-gic-v3-its-fsl-mc-msi.c | 71 ++++++++++++++++++++++++++++-
>  include/linux/acpi_iort.h                   |  5 ++
>  7 files changed, 174 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
> index 33f7198..beb9cd5 100644
> --- a/drivers/acpi/arm64/iort.c
> +++ b/drivers/acpi/arm64/iort.c
> @@ -15,6 +15,7 @@
>  #include <linux/kernel.h>
>  #include <linux/list.h>
>  #include <linux/pci.h>
> +#include <linux/fsl/mc.h>
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
>  
> @@ -622,6 +623,29 @@ static int iort_dev_find_its_id(struct device *dev, u32 req_id,
>  }
>  
>  /**
> + * iort_get_fsl_mc_device_domain() - Find MSI domain related to a device
> + * @dev: The device.
> + * @mc_icid: ICID for the fsl_mc device.
> + *
> + * Returns: the MSI domain for this device, NULL otherwise
> + */
> +struct irq_domain *iort_get_fsl_mc_device_domain(struct device *dev,
> +							u32 mc_icid)
> +{
> +	struct fwnode_handle *handle;
> +	int its_id;
> +
> +	if (iort_dev_find_its_id(dev, mc_icid, 0, &its_id))
> +		return NULL;
> +
> +	handle = iort_find_domain_token(its_id);
> +	if (!handle)
> +		return NULL;
> +
> +	return irq_find_matching_fwnode(handle, DOMAIN_BUS_FSL_MC_MSI);
> +}

NAK

I am not willing to take platform specific code in the generic IORT
layer.

ACPI on ARM64 works on platforms that comply with SBSA/SBBR guidelines:

https://developer.arm.com/architectures/platform-design/server-systems

Deviating from those requires butchering ACPI specifications (ie IORT)
and related kernel code which goes totally against what ACPI is meant
for on ARM64 systems, so there is no upstream pathway for this code
I am afraid.

Thanks,
Lorenzo
