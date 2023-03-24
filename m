Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E0C6C8891
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbjCXWsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbjCXWsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:48:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98553199FF
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679698036;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IAep4zsB8TYNwCqw3Lk1IWlGUAaOVIb9FTzTKApZ2oM=;
        b=U8V3uy7v8Mw3lgcWlbw/FBtRrMCidwW7yo9tYflcUGBwdRFMFgqWYp4dNZIQUaAgmIev9F
        hrniECOdHy9/abZAMQBs+iNFCAemNOGY8DIx4BOY6IocXROxmo6mWF11JVIjc0an0Eyb3J
        G51IkXuAvEUWg2CLTw73blVc9tDCNOE=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-80HvkXNcOyicRLN0eRTj2Q-1; Fri, 24 Mar 2023 18:47:15 -0400
X-MC-Unique: 80HvkXNcOyicRLN0eRTj2Q-1
Received: by mail-io1-f72.google.com with SMTP id 9-20020a5ea509000000b0074ca36737d2so1964659iog.7
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:47:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679698034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IAep4zsB8TYNwCqw3Lk1IWlGUAaOVIb9FTzTKApZ2oM=;
        b=KUK0de+vH8K9j4egWc33GLGbnmKgm9cGw6kM02ayHhDhDO81xd8PZ6dk0vhzOeWcmN
         vLRWSjRP7X2s3hU9E9Z8Ek3CY6MsZaEJLpOAbDOtWR6llsoeHab874tZIQxEhSwW/A2w
         hV53a8GKNPTxLALMVefLJRGoVYitH8Wmfg2VQ6PjdK7nTdIqbktLDMLKkmWBQJ5XaWXN
         iahfJ5pbT9lB+PBsaW3af50nhCvcP0byIf5IwqG+aYpFd3WsG5hcDG6oMuin5/Q6S3KB
         vZXKfTlodPSzrrBPrQuxvmR65mLhxEY/+G1R+UJMb6getm5UOWjWTuYCZXLaNXV9Gsx2
         RGeA==
X-Gm-Message-State: AAQBX9f/Plg67YGhXoJaYGynfDYGLhLMxT2hgah/vtYV5K0L2jMBuM0Q
        XAO5Y+BT5AMt49LmSZy55J5Gu5o5UrrJvJsYHxnni28g0VeBd5orBYQAXU7PexYsMK+VbXBaBVB
        MEbH+KAzWQA5+0MOq
X-Received: by 2002:a92:d58c:0:b0:323:833:91e7 with SMTP id a12-20020a92d58c000000b00323083391e7mr3316174iln.23.1679698033855;
        Fri, 24 Mar 2023 15:47:13 -0700 (PDT)
X-Google-Smtp-Source: AKy350buRN6jrtZ5imHx4hAoUzyDyWxTtauRkK6WIplQNgvoCe6NJFFou9gOhqv62c7sxCqc0Lf+lw==
X-Received: by 2002:a92:d58c:0:b0:323:833:91e7 with SMTP id a12-20020a92d58c000000b00323083391e7mr3316156iln.23.1679698033589;
        Fri, 24 Mar 2023 15:47:13 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id x25-20020a6bda19000000b00758facb11fdsm1441858iob.17.2023.03.24.15.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Mar 2023 15:47:13 -0700 (PDT)
Date:   Fri, 24 Mar 2023 16:47:11 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Brett Creeley <bcreeley@amd.com>
Cc:     Brett Creeley <brett.creeley@amd.com>, kvm@vger.kernel.org,
        netdev@vger.kernel.org, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        shannon.nelson@amd.com, drviers@pensando.io
Subject: Re: [PATCH v5 vfio 3/7] vfio/pds: register with the pds_core PF
Message-ID: <20230324164711.6aeb40b2.alex.williamson@redhat.com>
In-Reply-To: <57f5d678-a3f9-d812-9900-d8435a44eb23@amd.com>
References: <20230322203442.56169-1-brett.creeley@amd.com>
        <20230322203442.56169-4-brett.creeley@amd.com>
        <20230324160251.4014b4e5.alex.williamson@redhat.com>
        <57f5d678-a3f9-d812-9900-d8435a44eb23@amd.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Mar 2023 15:36:57 -0700
Brett Creeley <bcreeley@amd.com> wrote:

> On 3/24/2023 3:02 PM, Alex Williamson wrote:
> > Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> > 
> > 
> > On Wed, 22 Mar 2023 13:34:38 -0700
> > Brett Creeley <brett.creeley@amd.com> wrote:
> >   
> >> The pds_core driver will supply adminq services, so find the PF
> >> and register with the DSC services.
> >>
> >> Use the following commands to enable a VF:
> >> echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
> >>
> >> Signed-off-by: Brett Creeley <brett.creeley@amd.com>
> >> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> >> ---
> >>   drivers/vfio/pci/pds/Makefile   |  1 +
> >>   drivers/vfio/pci/pds/cmds.c     | 67 +++++++++++++++++++++++++++++++++
> >>   drivers/vfio/pci/pds/cmds.h     | 12 ++++++
> >>   drivers/vfio/pci/pds/pci_drv.c  | 16 +++++++-
> >>   drivers/vfio/pci/pds/pci_drv.h  |  9 +++++
> >>   drivers/vfio/pci/pds/vfio_dev.c |  5 +++
> >>   drivers/vfio/pci/pds/vfio_dev.h |  2 +
> >>   include/linux/pds/pds_lm.h      | 12 ++++++
> >>   8 files changed, 123 insertions(+), 1 deletion(-)
> >>   create mode 100644 drivers/vfio/pci/pds/cmds.c
> >>   create mode 100644 drivers/vfio/pci/pds/cmds.h
> >>   create mode 100644 drivers/vfio/pci/pds/pci_drv.h
> >>   create mode 100644 include/linux/pds/pds_lm.h
> >>
> >> diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
> >> index e1a55ae0f079..87581111fa17 100644
> >> --- a/drivers/vfio/pci/pds/Makefile
> >> +++ b/drivers/vfio/pci/pds/Makefile
> >> @@ -4,5 +4,6 @@
> >>   obj-$(CONFIG_PDS_VFIO_PCI) += pds_vfio.o
> >>
> >>   pds_vfio-y := \
> >> +     cmds.o          \
> >>        pci_drv.o       \
> >>        vfio_dev.o
> >> diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
> >> new file mode 100644
> >> index 000000000000..26e383ec4544
> >> --- /dev/null
> >> +++ b/drivers/vfio/pci/pds/cmds.c
> >> @@ -0,0 +1,67 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
> >> +
> >> +#include <linux/io.h>
> >> +#include <linux/types.h>
> >> +
> >> +#include <linux/pds/pds_common.h>
> >> +#include <linux/pds/pds_core_if.h>
> >> +#include <linux/pds/pds_adminq.h>
> >> +#include <linux/pds/pds_lm.h>
> >> +
> >> +#include "vfio_dev.h"
> >> +#include "cmds.h"
> >> +
> >> +int
> >> +pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
> >> +{
> >> +     union pds_core_adminq_comp comp = { 0 };
> >> +     union pds_core_adminq_cmd cmd = { 0 };
> >> +     struct device *dev;
> >> +     int err, id;
> >> +     u16 ci;
> >> +
> >> +     id = PCI_DEVID(pds_vfio->pdev->bus->number,
> >> +                    pci_iov_virtfn_devfn(pds_vfio->pdev, pds_vfio->vf_id));
> >> +
> >> +     dev = &pds_vfio->pdev->dev;
> >> +     cmd.client_reg.opcode = PDS_AQ_CMD_CLIENT_REG;
> >> +     snprintf(cmd.client_reg.devname, sizeof(cmd.client_reg.devname),
> >> +              "%s.%d", PDS_LM_DEV_NAME, id);  
> > 
> > Does this devname need to be unique, and if so should it factor in
> > pci_domain_nr()?  The array seems to be wide enough to easily hold the
> > VF dev_name() but I haven't followed if there are additional
> > constraints.  Thanks,
> > 
> > Alex
> >   
> >> +  
> 
> Hey Alex,
> 
> We used the PCI_DEVID (id) as the suffix, which should be good enough to 
> provide uniqueness for each devname.

But PCI_DEVID is not unique unless this device is guaranteed never to
run on a system with multiple PCI segments, including cases where these
PFs and VFs might be assigned to multi-segment VMs.  Thanks,

Alex

