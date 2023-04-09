Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA99A6DBFAD
	for <lists+netdev@lfdr.de>; Sun,  9 Apr 2023 13:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbjDILqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 07:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjDILqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 07:46:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3D1422F
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 04:46:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 570A560B70
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 11:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E214FC433EF;
        Sun,  9 Apr 2023 11:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681040772;
        bh=z9tPuhYZx67JgwwPmEQFZHAmNRIf4514rpD5TH3UCA4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l1eUnVDRMqFhC+oRBKqqUlxafEmOHOZwEL5N9S3Zmq7P2WIkLvMyhO88Hw5A8YLFU
         bsc4nMlu5Q+bga78i/65ruoBPGRvwZ1b6g1NogaNDahXRZW08Ksv2GPJIedoWRpohD
         IPVhTyGoyP69a70K2E/4uihHKW4fZyacB+gPiuza3Z2PQraEkO6vDEyGfpH0tXmGaW
         qc8w86QD4+cyz5DnjzN9Cea2rxd6c+QeGJlYQGOwTS/pKFPGHw5svNXZxUtiLFNztL
         ofw9MfRxJFueC/2XxRwcky8FFV1sPeA2/VDU8qYXUv3XYh1rIrO2cZ0a7ftuRVeunF
         r/kguR5lydvuA==
Date:   Sun, 9 Apr 2023 14:46:08 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 02/14] pds_core: add devcmd device interfaces
Message-ID: <20230409114608.GA182481@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-3-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230406234143.11318-3-shannon.nelson@amd.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 06, 2023 at 04:41:31PM -0700, Shannon Nelson wrote:
> The devcmd interface is the basic connection to the device through the
> PCI BAR for low level identification and command services.  This does
> the early device initialization and finds the identity data, and adds
> devcmd routines to be used by later driver bits.
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/net/ethernet/amd/pds_core/Makefile  |   4 +-
>  drivers/net/ethernet/amd/pds_core/core.c    |  36 ++
>  drivers/net/ethernet/amd/pds_core/core.h    |  52 +++
>  drivers/net/ethernet/amd/pds_core/debugfs.c |  68 ++++
>  drivers/net/ethernet/amd/pds_core/dev.c     | 349 ++++++++++++++++++++
>  drivers/net/ethernet/amd/pds_core/main.c    |  33 +-
>  include/linux/pds/pds_common.h              |  61 ++++
>  include/linux/pds/pds_intr.h                | 163 +++++++++
>  8 files changed, 763 insertions(+), 3 deletions(-)
>  create mode 100644 drivers/net/ethernet/amd/pds_core/core.c
>  create mode 100644 drivers/net/ethernet/amd/pds_core/dev.c
>  create mode 100644 include/linux/pds/pds_intr.h

<...>

> +int pdsc_setup(struct pdsc *pdsc, bool init)
> +{
> +	int err = 0;

You don't need to set value as you overwrite it immediately.

> +
> +	if (init)
> +		err = pdsc_dev_init(pdsc);
> +	else
> +		err = pdsc_dev_reinit(pdsc);
> +	if (err)
> +		return err;
> +
> +	clear_bit(PDSC_S_FW_DEAD, &pdsc->state);
> +	return 0;
> +}

<...>

> +static int irqs_show(struct seq_file *seq, void *v)
> +{
> +	struct pdsc *pdsc = seq->private;
> +	struct pdsc_intr_info *intr_info;
> +	int i;
> +
> +	seq_printf(seq, "index  vector  name (nintrs %d)\n", pdsc->nintrs);
> +
> +	if (!pdsc->intr_info)
> +		return 0;
> +
> +	for (i = 0; i < pdsc->nintrs; i++) {
> +		intr_info = &pdsc->intr_info[i];
> +		if (!intr_info->vector)
> +			continue;
> +
> +		seq_printf(seq, "% 3d    % 3d     %s\n",
> +			   i, intr_info->vector, intr_info->name);
> +	}
> +
> +	return 0;
> +}
> +DEFINE_SHOW_ATTRIBUTE(irqs);

I'm curious why existing IRQ core support is not enough?

> +
> +void pdsc_debugfs_add_irqs(struct pdsc *pdsc)
> +{
> +	debugfs_create_file("irqs", 0400, pdsc->dentry, pdsc, &irqs_fops);
> +}
> +
>  #endif /* CONFIG_DEBUG_FS */
> diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
> new file mode 100644
> index 000000000000..52385a72246d
> --- /dev/null
> +++ b/drivers/net/ethernet/amd/pds_core/dev.c
> @@ -0,0 +1,349 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> +
> +#include <linux/errno.h>
> +#include <linux/pci.h>
> +#include <linux/utsname.h>
> +
> +#include "core.h"
> +
> +int pdsc_err_to_errno(enum pds_core_status_code code)

All users of this function, call to pdsc_devcmd_status() first. Probably
they need to be combined.

> +{
> +	switch (code) {
> +	case PDS_RC_SUCCESS:
> +		return 0;
> +	case PDS_RC_EVERSION:
> +	case PDS_RC_EQTYPE:
> +	case PDS_RC_EQID:
> +	case PDS_RC_EINVAL:
> +	case PDS_RC_ENOSUPP:
> +		return -EINVAL;
> +	case PDS_RC_EPERM:
> +		return -EPERM;
> +	case PDS_RC_ENOENT:
> +		return -ENOENT;
> +	case PDS_RC_EAGAIN:
> +		return -EAGAIN;
> +	case PDS_RC_ENOMEM:
> +		return -ENOMEM;
> +	case PDS_RC_EFAULT:
> +		return -EFAULT;
> +	case PDS_RC_EBUSY:
> +		return -EBUSY;
> +	case PDS_RC_EEXIST:
> +		return -EEXIST;
> +	case PDS_RC_EVFID:
> +		return -ENODEV;
> +	case PDS_RC_ECLIENT:
> +		return -ECHILD;
> +	case PDS_RC_ENOSPC:
> +		return -ENOSPC;
> +	case PDS_RC_ERANGE:
> +		return -ERANGE;
> +	case PDS_RC_BAD_ADDR:
> +		return -EFAULT;
> +	case PDS_RC_EOPCODE:
> +	case PDS_RC_EINTR:
> +	case PDS_RC_DEV_CMD:
> +	case PDS_RC_ERROR:
> +	case PDS_RC_ERDMA:
> +	case PDS_RC_EIO:
> +	default:
> +		return -EIO;
> +	}
> +}

<...>

> +static u8 pdsc_devcmd_status(struct pdsc *pdsc)
> +{
> +	return ioread8(&pdsc->cmd_regs->comp.status);
> +}

<...>

> +int pdsc_devcmd_init(struct pdsc *pdsc)
> +{
> +	union pds_core_dev_comp comp = { 0 };

There is no need to put 0 while using {} initialization.

> +	union pds_core_dev_cmd cmd = {
> +		.opcode = PDS_CORE_CMD_INIT,
> +	};
> +
> +	return pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
> +}

<...>

> +	/* Get intr_info struct array for tracking */
> +	pdsc->intr_info = kcalloc(nintrs, sizeof(*pdsc->intr_info), GFP_KERNEL);
> +	if (!pdsc->intr_info) {
> +		err = -ENOSPC;

The general convention is to return -ENOMEM for memorly allocation failures.

> +		goto err_out;
> +	}

<...>

> +/*
> + * enum pds_core_status_code - Device command return codes
> + */
> +enum pds_core_status_code {
> +	PDS_RC_SUCCESS	= 0,	/* Success */
> +	PDS_RC_EVERSION	= 1,	/* Incorrect version for request */
> +	PDS_RC_EOPCODE	= 2,	/* Invalid cmd opcode */
> +	PDS_RC_EIO	= 3,	/* I/O error */
> +	PDS_RC_EPERM	= 4,	/* Permission denied */
> +	PDS_RC_EQID	= 5,	/* Bad qid */
> +	PDS_RC_EQTYPE	= 6,	/* Bad qtype */
> +	PDS_RC_ENOENT	= 7,	/* No such element */
> +	PDS_RC_EINTR	= 8,	/* operation interrupted */
> +	PDS_RC_EAGAIN	= 9,	/* Try again */
> +	PDS_RC_ENOMEM	= 10,	/* Out of memory */
> +	PDS_RC_EFAULT	= 11,	/* Bad address */
> +	PDS_RC_EBUSY	= 12,	/* Device or resource busy */
> +	PDS_RC_EEXIST	= 13,	/* object already exists */
> +	PDS_RC_EINVAL	= 14,	/* Invalid argument */
> +	PDS_RC_ENOSPC	= 15,	/* No space left or alloc failure */
> +	PDS_RC_ERANGE	= 16,	/* Parameter out of range */
> +	PDS_RC_BAD_ADDR	= 17,	/* Descriptor contains a bad ptr */
> +	PDS_RC_DEV_CMD	= 18,	/* Device cmd attempted on AdminQ */
> +	PDS_RC_ENOSUPP	= 19,	/* Operation not supported */
> +	PDS_RC_ERROR	= 29,	/* Generic error */
> +	PDS_RC_ERDMA	= 30,	/* Generic RDMA error */
> +	PDS_RC_EVFID	= 31,	/* VF ID does not exist */
> +	PDS_RC_BAD_FW	= 32,	/* FW file is invalid or corrupted */
> +	PDS_RC_ECLIENT	= 33,   /* No such client id */
> +};

We asked from Intel to remove custom error codes and we would like to
ask it here too. Please use standard in-kernel errors.

> +
> +enum pds_core_driver_type {
> +	PDS_DRIVER_LINUX   = 1,

This is only relevant here, everything else is not applicable.

> +	PDS_DRIVER_WIN     = 2,
> +	PDS_DRIVER_DPDK    = 3,
> +	PDS_DRIVER_FREEBSD = 4,
> +	PDS_DRIVER_IPXE    = 5,
> +	PDS_DRIVER_ESXI    = 6,
> +};
> +

Thanks
