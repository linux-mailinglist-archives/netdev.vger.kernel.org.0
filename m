Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6266E08F8
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 10:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjDMIdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 04:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjDMIdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 04:33:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463E59031
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 01:33:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C927960FB4
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 08:33:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9070C4339B;
        Thu, 13 Apr 2023 08:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681374809;
        bh=OfwPkh4WmuledLaS1eY+ng2MkkKfc8aO2mFrV5eJ5cE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BQ/+jC2dubRHy58jIx9pKG5cycX6GfkaVffcYmrrDQ9MOL3sTqDez78MylU03VTV2
         c6GnhJsz9qxVLN82MrBd6QCNzWht3qwd+IjjrGauvxrIKzLuz8mFjDiuQRPrl95Cp4
         7UxjusoZ3xFodgv8p0sSpkOW2suZ8IYcu05mGZ2h4LAGpXnagHVJd9dhj1TfBJ15Jn
         UZhlAaCJWLJAe1EVecrM+G1DvHFLLyS4VG/Bn314ofTTpw8h0nEDZ2TP/LOsDRfwoU
         BmdzrzGkBSd/IxHjRu//0d7Hr7b/aRweDQkXXU2YlNXTPfU9lxtdR9CdrfU5ElP37/
         sHYUMV88HMsQA==
Date:   Thu, 13 Apr 2023 11:33:25 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 02/14] pds_core: add devcmd device interfaces
Message-ID: <20230413083325.GD17993@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-3-shannon.nelson@amd.com>
 <20230409114608.GA182481@unreal>
 <5394cb12-05fd-dcb9-eea1-6b64ff0232d6@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5394cb12-05fd-dcb9-eea1-6b64ff0232d6@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 12:05:20PM -0700, Shannon Nelson wrote:
> On 4/9/23 4:46 AM, Leon Romanovsky wrote:
> > 
> > On Thu, Apr 06, 2023 at 04:41:31PM -0700, Shannon Nelson wrote:
> > > The devcmd interface is the basic connection to the device through the
> > > PCI BAR for low level identification and command services.  This does
> > > the early device initialization and finds the identity data, and adds
> > > devcmd routines to be used by later driver bits.
> > > 
> > > Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> > > ---
> > >   drivers/net/ethernet/amd/pds_core/Makefile  |   4 +-
> > >   drivers/net/ethernet/amd/pds_core/core.c    |  36 ++
> > >   drivers/net/ethernet/amd/pds_core/core.h    |  52 +++
> > >   drivers/net/ethernet/amd/pds_core/debugfs.c |  68 ++++
> > >   drivers/net/ethernet/amd/pds_core/dev.c     | 349 ++++++++++++++++++++
> > >   drivers/net/ethernet/amd/pds_core/main.c    |  33 +-
> > >   include/linux/pds/pds_common.h              |  61 ++++
> > >   include/linux/pds/pds_intr.h                | 163 +++++++++
> > >   8 files changed, 763 insertions(+), 3 deletions(-)
> > >   create mode 100644 drivers/net/ethernet/amd/pds_core/core.c
> > >   create mode 100644 drivers/net/ethernet/amd/pds_core/dev.c
> > >   create mode 100644 include/linux/pds/pds_intr.h
> > 
> > <...>

<...>

> > >   #endif /* CONFIG_DEBUG_FS */
> > > diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
> > > new file mode 100644
> > > index 000000000000..52385a72246d
> > > --- /dev/null
> > > +++ b/drivers/net/ethernet/amd/pds_core/dev.c
> > > @@ -0,0 +1,349 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > > +/* Copyright(c) 2023 Advanced Micro Devices, Inc */
> > > +
> > > +#include <linux/errno.h>
> > > +#include <linux/pci.h>
> > > +#include <linux/utsname.h>
> > > +
> > > +#include "core.h"
> > > +
> > > +int pdsc_err_to_errno(enum pds_core_status_code code)
> > 
> > All users of this function, call to pdsc_devcmd_status() first. Probably
> > they need to be combined.
> 
> This is also called from pdsc_adminq_post() which doesn't use
> pdsc_devcmd_status().

I probably missed that.

> 
> > 
> > > +{
> > > +     switch (code) {
> > > +     case PDS_RC_SUCCESS:
> > > +             return 0;
> > > +     case PDS_RC_EVERSION:
> > > +     case PDS_RC_EQTYPE:
> > > +     case PDS_RC_EQID:
> > > +     case PDS_RC_EINVAL:
> > > +     case PDS_RC_ENOSUPP:
> > > +             return -EINVAL;
> > > +     case PDS_RC_EPERM:
> > > +             return -EPERM;
> > > +     case PDS_RC_ENOENT:
> > > +             return -ENOENT;
> > > +     case PDS_RC_EAGAIN:
> > > +             return -EAGAIN;
> > > +     case PDS_RC_ENOMEM:
> > > +             return -ENOMEM;
> > > +     case PDS_RC_EFAULT:
> > > +             return -EFAULT;
> > > +     case PDS_RC_EBUSY:
> > > +             return -EBUSY;
> > > +     case PDS_RC_EEXIST:
> > > +             return -EEXIST;
> > > +     case PDS_RC_EVFID:
> > > +             return -ENODEV;
> > > +     case PDS_RC_ECLIENT:
> > > +             return -ECHILD;
> > > +     case PDS_RC_ENOSPC:
> > > +             return -ENOSPC;
> > > +     case PDS_RC_ERANGE:
> > > +             return -ERANGE;
> > > +     case PDS_RC_BAD_ADDR:
> > > +             return -EFAULT;
> > > +     case PDS_RC_EOPCODE:
> > > +     case PDS_RC_EINTR:
> > > +     case PDS_RC_DEV_CMD:
> > > +     case PDS_RC_ERROR:
> > > +     case PDS_RC_ERDMA:
> > > +     case PDS_RC_EIO:
> > > +     default:
> > > +             return -EIO;
> > > +     }
> > > +}
> > 

<...>

> > > +/*
> > > + * enum pds_core_status_code - Device command return codes
> > > + */
> > > +enum pds_core_status_code {
> > > +     PDS_RC_SUCCESS  = 0,    /* Success */
> > > +     PDS_RC_EVERSION = 1,    /* Incorrect version for request */
> > > +     PDS_RC_EOPCODE  = 2,    /* Invalid cmd opcode */
> > > +     PDS_RC_EIO      = 3,    /* I/O error */
> > > +     PDS_RC_EPERM    = 4,    /* Permission denied */
> > > +     PDS_RC_EQID     = 5,    /* Bad qid */
> > > +     PDS_RC_EQTYPE   = 6,    /* Bad qtype */
> > > +     PDS_RC_ENOENT   = 7,    /* No such element */
> > > +     PDS_RC_EINTR    = 8,    /* operation interrupted */
> > > +     PDS_RC_EAGAIN   = 9,    /* Try again */
> > > +     PDS_RC_ENOMEM   = 10,   /* Out of memory */
> > > +     PDS_RC_EFAULT   = 11,   /* Bad address */
> > > +     PDS_RC_EBUSY    = 12,   /* Device or resource busy */
> > > +     PDS_RC_EEXIST   = 13,   /* object already exists */
> > > +     PDS_RC_EINVAL   = 14,   /* Invalid argument */
> > > +     PDS_RC_ENOSPC   = 15,   /* No space left or alloc failure */
> > > +     PDS_RC_ERANGE   = 16,   /* Parameter out of range */
> > > +     PDS_RC_BAD_ADDR = 17,   /* Descriptor contains a bad ptr */
> > > +     PDS_RC_DEV_CMD  = 18,   /* Device cmd attempted on AdminQ */
> > > +     PDS_RC_ENOSUPP  = 19,   /* Operation not supported */
> > > +     PDS_RC_ERROR    = 29,   /* Generic error */
> > > +     PDS_RC_ERDMA    = 30,   /* Generic RDMA error */
> > > +     PDS_RC_EVFID    = 31,   /* VF ID does not exist */
> > > +     PDS_RC_BAD_FW   = 32,   /* FW file is invalid or corrupted */
> > > +     PDS_RC_ECLIENT  = 33,   /* No such client id */
> > > +};
> > 
> > We asked from Intel to remove custom error codes and we would like to
> > ask it here too. Please use standard in-kernel errors.
> 
> These are part of the device interface defined by the device firmware and
> include some that aren't in the errno set.  This is why we use
> pdsc_err_to_errno() in pdsc_devcmd_wait() and pdsc_adminq_post(), so that we
> can change these status codes that we get from the device into standard
> kernel error codes.  We try to report both in error messages, but only
> return the kernel errno.

You don't really need to create separate enum for that and place
it in include/linux/pds/pds_common.h like you did.

You FW returns u8 status, which you can feed to pdsc_err_to_errno().
In the latter function, you will declare this translation enum.
Such core reorg will esnure that you still have meaningful FW statuses
while keeping them in limited code namespace.

> 
> However, I see in one place in pdsc_devcmd_wait() we're using the status
> codes where we could use the errno, so I'll fix that up.
> 
> 
> > 
> > > +
> > > +enum pds_core_driver_type {
> > > +     PDS_DRIVER_LINUX   = 1,
> > 
> > This is only relevant here, everything else is not applicable.
> > 
> > > +     PDS_DRIVER_WIN     = 2,
> > > +     PDS_DRIVER_DPDK    = 3,
> > > +     PDS_DRIVER_FREEBSD = 4,
> > > +     PDS_DRIVER_IPXE    = 5,
> > > +     PDS_DRIVER_ESXI    = 6,
> > > +};
> 
> Yes, they are rather pointless for the Linux kernel, but it is part of
> documenting the device interface.

It is not used in upstream kernel.

Thanks

> 
> > > +
> > 
> > Thanks
