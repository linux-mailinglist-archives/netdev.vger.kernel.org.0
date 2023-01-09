Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD836620C7
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 09:58:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233522AbjAII6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 03:58:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234598AbjAII53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 03:57:29 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29ED3165BB
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 00:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673254182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ikJAS/03LQNDR/1oWZTANb2g+B3V0cTEFzRINzfY4PE=;
        b=MBq29QO7VUySG0TrB40xINVLrDQZYVmvVzXMeiMQ0xhxNfZ+GN9cg0emXJaiGcUIQiKeoN
        r7jGrvrR2GpR7b3vyuQUAw7b0nofZPxot65P1R4w+jcgbccAx/D4QxznkUUBLZH/Kmixif
        aGmY821P4OVTIq5nin1H6ZwEr0CQO9A=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-201-z0fmucEAPYqQtAqA50m5cg-1; Mon, 09 Jan 2023 03:49:40 -0500
X-MC-Unique: z0fmucEAPYqQtAqA50m5cg-1
Received: by mail-oi1-f197.google.com with SMTP id 4-20020aca0b04000000b0035e9d1b2188so2289348oil.17
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 00:49:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ikJAS/03LQNDR/1oWZTANb2g+B3V0cTEFzRINzfY4PE=;
        b=wtW8RZBAtcF3Af+fa8McLL8oFgaWbUjxW1V5DUWb3ZJK4YLG/XVfZK+bhj/qC/+xYH
         Jyhm4GGiQzdE5w8+YqeD8F0t8KzT9wxBY2y3V/FEzCy0mTuQX1GHXR49D5RU25Q24qab
         mC7+fy6/kxBnu+rGp+ACLzQ5hyCl76ZL28PTxVVVLdNbxc173/fObyM+7xRmaRksXTgR
         z+g1Sg8Ul9bIvnSNOhr+YLsVoogLFKZ0vtGYbT8DOJO0ifHEDGoQXk58hNZyuwmKqAng
         v3YyVN+GU7LsFxx/ooBimvjObzm9n1YAYFKS1C9tJtEmBfA7ktLY22p4ekRUECmoTn7W
         /wAg==
X-Gm-Message-State: AFqh2krLb+HE7co82FOdGKaYqiGq+h60yPwetlgjQ1PmDCzCTD79Obs5
        UFrUi0fqSiLUNqkjxp3slRHKWUye2dkuGA0bECsNZChLt3iIllcfIA+YVEekoSdo8v9sESR58I4
        alM2MnhhvGe0JJ5Kqo7TWazat3fH2n/RG
X-Received: by 2002:a05:6808:150f:b0:363:a978:6d41 with SMTP id u15-20020a056808150f00b00363a9786d41mr2172340oiw.280.1673254179323;
        Mon, 09 Jan 2023 00:49:39 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuJxhuVDcQU+j5UxB4N2DtFSXnqkgaz0qOn08xXcyqwtEXi99Ss/E3ECNICrua7+cmiBheigpViQJc0YuNipEE=
X-Received: by 2002:a05:6808:150f:b0:363:a978:6d41 with SMTP id
 u15-20020a056808150f00b00363a9786d41mr2172337oiw.280.1673254178956; Mon, 09
 Jan 2023 00:49:38 -0800 (PST)
MIME-Version: 1.0
References: <20221207145428.31544-1-gautam.dawar@amd.com> <20221207145428.31544-10-gautam.dawar@amd.com>
 <CACGkMEt+euNwg+DEYFMNhJGXm1v2UqiPx622F-=DARFB4CWavQ@mail.gmail.com>
 <6f3eb21d-4f2d-eff3-37d4-9731eacd4af3@amd.com> <CACGkMEtuamSSFvOXf6oBLtZ19sFEsq_2F5hHhOhG8AfOVFnqJQ@mail.gmail.com>
 <819d2d2d-c7de-b788-5de1-6754afb2aeb9@amd.com>
In-Reply-To: <819d2d2d-c7de-b788-5de1-6754afb2aeb9@amd.com>
From:   Jason Wang <jasowang@redhat.com>
Date:   Mon, 9 Jan 2023 16:49:27 +0800
Message-ID: <CACGkMEs78wxUyq4dvELgOxezee+hWdsrn2w0p-0xB3XKaqpRgg@mail.gmail.com>
Subject: Re: [PATCH net-next 09/11] sfc: implement iova rbtree to store dma mappings
To:     Gautam Dawar <gdawar@amd.com>
Cc:     Gautam Dawar <gautam.dawar@amd.com>, linux-net-drivers@amd.com,
        netdev@vger.kernel.org, eperezma@redhat.com, tanuj.kamde@amd.com,
        Koushik.Dutta@amd.com, harpreet.anand@amd.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 5, 2023 at 9:09 PM Gautam Dawar <gdawar@amd.com> wrote:
>
>
> On 12/19/22 11:33, Jason Wang wrote:
> > Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> >
> >
> > On Fri, Dec 16, 2022 at 8:48 PM Gautam Dawar <gdawar@amd.com> wrote:
> >>
> >> On 12/14/22 12:16, Jason Wang wrote:
> >>> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
> >>>
> >>>
> >>> On Wed, Dec 7, 2022 at 10:57 PM Gautam Dawar <gautam.dawar@amd.com> wrote:
> >>>> sfc uses a MCDI DMA buffer that is allocated on the host
> >>>> for communicating with the Firmware. The MCDI buffer IOVA
> >>>> could overlap with the IOVA used by the guest for the
> >>>> virtqueue buffers. To detect such overlap, the DMA mappings
> >>>> from the guest will be stored in a IOVA rbtree and every
> >>>> such mapping will be compared against the MCDI buffer IOVA
> >>>> range. If an overlap is detected, the MCDI buffer will be
> >>>> relocated to a different IOVA.
> >>> I think it can't prevent guests from guessing the MCDI buffer address
> >>> and trying to DMA to/from that buffer.
> >> Yes, if the guest can guess the MCDI buffer address, it could use it to
> >> DMA to/from this buffer.
> >>
> >> However, the guest can modify the buffer contents but can't instruct the
> >> MC to execute the request. To cause any MCDI failure, the request buffer
> >> needs to be updated when host driver is about to execute the request or
> >> response buffer needs to be updated after command execution but before
> >> host driver reads it. This would be a very small time window and hard to
> >> guess for the guest.
> > Not that hard probably, actually, the guest driver don't even need to
> > guess, just leave a small space in its IOVA space then it knows the
> > host driver will use that for MCDI. So this is something we need to
> > address.
> >
> > Any possibility to let the MCDI command run on PF instead of VF?
> We evaluated this approach initially but it needed a communication
> mechanism between the VF and PF drivers and also would have added in a
> lot of complexity in passing MCDI messages back and forth. Hence, MCDI
> over PF isn't possible.

Ok.

> >
> >>> It might work with some co-operation of the NIC who can validate the
> >>> DMA initialized by the virtqueue and forbid the DMA to the MDCI
> >>> buffer.
> >> I think this problem can be solved using PASID which will be supported
> >> by our next hardware version.
> > That one way, another way is to add a check before initiating
> > virtqueue DMA, if it tries to DMA to MCDI, fail. This seems easier.
>
> Can you please elaborate on this? vdpa datapath doesn't involve the
> hypervisor and the host driver as virtqueues terminate between guest
> virtio-net driver and the hardware. Even the doorbell operations are
> memory mapped and IRQ bypass allows interrupts to be delivered directly
> to guest vCPU.
>
> Where exactly are you recommending the address check to be placed?

So what I meant is, is it possible to add the check in the device datapath like:

if DMA is from virtqueue and it tries to DMA to MCDI buffer, fail this request.

This will probably involves some synchronization in the hardware
level, or if this is not possible, another workaround I can think is
to stop the datapath when dealing MCDI buffer by driver:

1) stop the datapath
2) map MCDI buffer
3) send MCDI command
4) unmap MCDI buffer
5) restart the datapath

This will guarantee that no MCDI buffer were mapped during datapath.

Does this work?

Thanks

>
> Regards,
>
> Gautam
>
> >
> > Thanks
> >
> >>> Thanks
> >>>> Signed-off-by: Gautam Dawar <gautam.dawar@amd.com>
> >>>> ---
> >>>>    drivers/net/ethernet/sfc/Makefile         |   3 +-
> >>>>    drivers/net/ethernet/sfc/ef100_iova.c     | 205 ++++++++++++++++++++++
> >>>>    drivers/net/ethernet/sfc/ef100_iova.h     |  40 +++++
> >>>>    drivers/net/ethernet/sfc/ef100_nic.c      |   1 -
> >>>>    drivers/net/ethernet/sfc/ef100_vdpa.c     |  38 ++++
> >>>>    drivers/net/ethernet/sfc/ef100_vdpa.h     |  15 ++
> >>>>    drivers/net/ethernet/sfc/ef100_vdpa_ops.c |   5 +
> >>>>    drivers/net/ethernet/sfc/mcdi.h           |   3 +
> >>>>    8 files changed, 308 insertions(+), 2 deletions(-)
> >>>>    create mode 100644 drivers/net/ethernet/sfc/ef100_iova.c
> >>>>    create mode 100644 drivers/net/ethernet/sfc/ef100_iova.h
> >>>>
> >>>> diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
> >>>> index a10eac91ab23..85852ff50b7c 100644
> >>>> --- a/drivers/net/ethernet/sfc/Makefile
> >>>> +++ b/drivers/net/ethernet/sfc/Makefile
> >>>> @@ -11,7 +11,8 @@ sfc-$(CONFIG_SFC_MTD) += mtd.o
> >>>>    sfc-$(CONFIG_SFC_SRIOV)        += sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
> >>>>                               mae.o tc.o tc_bindings.o tc_counters.o
> >>>>
> >>>> -sfc-$(CONFIG_SFC_VDPA) += mcdi_vdpa.o ef100_vdpa.o ef100_vdpa_ops.o
> >>>> +sfc-$(CONFIG_SFC_VDPA) += mcdi_vdpa.o ef100_vdpa.o ef100_vdpa_ops.o \
> >>>> +                          ef100_iova.o
> >>>>    obj-$(CONFIG_SFC)      += sfc.o
> >>>>
> >>>>    obj-$(CONFIG_SFC_FALCON) += falcon/
> >>>> diff --git a/drivers/net/ethernet/sfc/ef100_iova.c b/drivers/net/ethernet/sfc/ef100_iova.c
> >>>> new file mode 100644
> >>>> index 000000000000..863314c5b9b5
> >>>> --- /dev/null
> >>>> +++ b/drivers/net/ethernet/sfc/ef100_iova.c
> >>>> @@ -0,0 +1,205 @@
> >>>> +// SPDX-License-Identifier: GPL-2.0
> >>>> +/* Driver for Xilinx network controllers and boards
> >>>> + * Copyright(C) 2020-2022 Xilinx, Inc.
> >>>> + * Copyright(C) 2022 Advanced Micro Devices, Inc.
> >>>> + *
> >>>> + * This program is free software; you can redistribute it and/or modify it
> >>>> + * under the terms of the GNU General Public License version 2 as published
> >>>> + * by the Free Software Foundation, incorporated herein by reference.
> >>>> + */
> >>>> +
> >>>> +#include "ef100_iova.h"
> >>>> +
> >>>> +static void update_free_list_node(struct ef100_vdpa_iova_node *target_node,
> >>>> +                                 struct ef100_vdpa_iova_node *next_node,
> >>>> +                                 struct ef100_vdpa_nic *vdpa_nic)
> >>>> +{
> >>>> +       unsigned long target_node_end;
> >>>> +       unsigned long free_area;
> >>>> +       bool in_list;
> >>>> +
> >>>> +       target_node_end = target_node->iova + target_node->size;
> >>>> +       free_area = next_node->iova - target_node_end;
> >>>> +       in_list = !(list_empty(&target_node->free_node));
> >>>> +
> >>>> +       if (!in_list && free_area >= MCDI_BUF_LEN) {
> >>>> +               list_add(&target_node->free_node,
> >>>> +                        &vdpa_nic->free_list);
> >>>> +       } else if (in_list && free_area < MCDI_BUF_LEN) {
> >>>> +               list_del_init(&target_node->free_node);
> >>>> +       }
> >>>> +}
> >>>> +
> >>>> +static void update_free_list(struct ef100_vdpa_iova_node *iova_node,
> >>>> +                            struct ef100_vdpa_nic *vdpa_nic,
> >>>> +                            bool add_node)
> >>>> +{
> >>>> +       struct ef100_vdpa_iova_node *prev_in = NULL;
> >>>> +       struct ef100_vdpa_iova_node *next_in = NULL;
> >>>> +       struct rb_node *prev_node;
> >>>> +       struct rb_node *next_node;
> >>>> +
> >>>> +       prev_node = rb_prev(&iova_node->node);
> >>>> +       next_node = rb_next(&iova_node->node);
> >>>> +
> >>>> +       if (prev_node)
> >>>> +               prev_in = rb_entry(prev_node,
> >>>> +                                  struct ef100_vdpa_iova_node, node);
> >>>> +       if (next_node)
> >>>> +               next_in = rb_entry(next_node,
> >>>> +                                  struct ef100_vdpa_iova_node, node);
> >>>> +
> >>>> +       if (add_node) {
> >>>> +               if (prev_in)
> >>>> +                       update_free_list_node(prev_in, iova_node, vdpa_nic);
> >>>> +
> >>>> +               if (next_in)
> >>>> +                       update_free_list_node(iova_node, next_in, vdpa_nic);
> >>>> +       } else {
> >>>> +               if (next_in && prev_in)
> >>>> +                       update_free_list_node(prev_in, next_in, vdpa_nic);
> >>>> +               if (!list_empty(&iova_node->free_node))
> >>>> +                       list_del_init(&iova_node->free_node);
> >>>> +       }
> >>>> +}
> >>>> +
> >>>> +int efx_ef100_insert_iova_node(struct ef100_vdpa_nic *vdpa_nic,
> >>>> +                              u64 iova, u64 size)
> >>>> +{
> >>>> +       struct ef100_vdpa_iova_node *iova_node;
> >>>> +       struct ef100_vdpa_iova_node *new_node;
> >>>> +       struct rb_node *parent;
> >>>> +       struct rb_node **link;
> >>>> +       struct rb_root *root;
> >>>> +       int rc = 0;
> >>>> +
> >>>> +       mutex_lock(&vdpa_nic->iova_lock);
> >>>> +
> >>>> +       root = &vdpa_nic->iova_root;
> >>>> +       link = &root->rb_node;
> >>>> +       parent = *link;
> >>>> +       /* Go to the bottom of the tree */
> >>>> +       while (*link) {
> >>>> +               parent = *link;
> >>>> +               iova_node = rb_entry(parent, struct ef100_vdpa_iova_node, node);
> >>>> +
> >>>> +               /* handle duplicate node */
> >>>> +               if (iova_node->iova == iova) {
> >>>> +                       rc = -EEXIST;
> >>>> +                       goto out_unlock;
> >>>> +               }
> >>>> +
> >>>> +               if (iova_node->iova > iova)
> >>>> +                       link = &(*link)->rb_left;
> >>>> +               else
> >>>> +                       link = &(*link)->rb_right;
> >>>> +       }
> >>>> +
> >>>> +       new_node = kzalloc(sizeof(*new_node), GFP_KERNEL);
> >>>> +       if (!new_node) {
> >>>> +               rc = -ENOMEM;
> >>>> +               goto out_unlock;
> >>>> +       }
> >>>> +
> >>>> +       new_node->iova = iova;
> >>>> +       new_node->size = size;
> >>>> +       INIT_LIST_HEAD(&new_node->free_node);
> >>>> +
> >>>> +       /* Put the new node here */
> >>>> +       rb_link_node(&new_node->node, parent, link);
> >>>> +       rb_insert_color(&new_node->node, root);
> >>>> +
> >>>> +       update_free_list(new_node, vdpa_nic, true);
> >>>> +
> >>>> +out_unlock:
> >>>> +       mutex_unlock(&vdpa_nic->iova_lock);
> >>>> +       return rc;
> >>>> +}
> >>>> +
> >>>> +static struct ef100_vdpa_iova_node*
> >>>> +ef100_rbt_search_node(struct ef100_vdpa_nic *vdpa_nic,
> >>>> +                     unsigned long iova)
> >>>> +{
> >>>> +       struct ef100_vdpa_iova_node *iova_node;
> >>>> +       struct rb_node *rb_node;
> >>>> +       struct rb_root *root;
> >>>> +
> >>>> +       root = &vdpa_nic->iova_root;
> >>>> +       if (!root)
> >>>> +               return NULL;
> >>>> +
> >>>> +       rb_node = root->rb_node;
> >>>> +
> >>>> +       while (rb_node) {
> >>>> +               iova_node = rb_entry(rb_node, struct ef100_vdpa_iova_node,
> >>>> +                                    node);
> >>>> +               if (iova_node->iova > iova)
> >>>> +                       rb_node = rb_node->rb_left;
> >>>> +               else if (iova_node->iova < iova)
> >>>> +                       rb_node = rb_node->rb_right;
> >>>> +               else
> >>>> +                       return iova_node;
> >>>> +       }
> >>>> +
> >>>> +       return NULL;
> >>>> +}
> >>>> +
> >>>> +void efx_ef100_remove_iova_node(struct ef100_vdpa_nic *vdpa_nic,
> >>>> +                               unsigned long iova)
> >>>> +{
> >>>> +       struct ef100_vdpa_iova_node *iova_node;
> >>>> +
> >>>> +       mutex_lock(&vdpa_nic->iova_lock);
> >>>> +       iova_node = ef100_rbt_search_node(vdpa_nic, iova);
> >>>> +       if (!iova_node)
> >>>> +               goto out_unlock;
> >>>> +
> >>>> +       update_free_list(iova_node, vdpa_nic, false);
> >>>> +
> >>>> +       rb_erase(&iova_node->node, &vdpa_nic->iova_root);
> >>>> +       kfree(iova_node);
> >>>> +
> >>>> +out_unlock:
> >>>> +       mutex_unlock(&vdpa_nic->iova_lock);
> >>>> +}
> >>>> +
> >>>> +void efx_ef100_delete_iova(struct ef100_vdpa_nic *vdpa_nic)
> >>>> +{
> >>>> +       struct ef100_vdpa_iova_node *iova_node;
> >>>> +       struct rb_root *iova_root;
> >>>> +       struct rb_node *node;
> >>>> +
> >>>> +       mutex_lock(&vdpa_nic->iova_lock);
> >>>> +
> >>>> +       iova_root = &vdpa_nic->iova_root;
> >>>> +       while (!RB_EMPTY_ROOT(iova_root)) {
> >>>> +               node = rb_first(iova_root);
> >>>> +               iova_node = rb_entry(node, struct ef100_vdpa_iova_node, node);
> >>>> +               if (!list_empty(&iova_node->free_node))
> >>>> +                       list_del_init(&iova_node->free_node);
> >>>> +               if (vdpa_nic->domain)
> >>>> +                       iommu_unmap(vdpa_nic->domain, iova_node->iova,
> >>>> +                                   iova_node->size);
> >>>> +               rb_erase(node, iova_root);
> >>>> +               kfree(iova_node);
> >>>> +       }
> >>>> +
> >>>> +       mutex_unlock(&vdpa_nic->iova_lock);
> >>>> +}
> >>>> +
> >>>> +int efx_ef100_find_new_iova(struct ef100_vdpa_nic *vdpa_nic,
> >>>> +                           unsigned int buf_len,
> >>>> +                           u64 *new_iova)
> >>>> +{
> >>>> +       struct ef100_vdpa_iova_node *iova_node;
> >>>> +
> >>>> +       /* pick the first node from freelist */
> >>>> +       iova_node = list_first_entry_or_null(&vdpa_nic->free_list,
> >>>> +                                            struct ef100_vdpa_iova_node,
> >>>> +                                            free_node);
> >>>> +       if (!iova_node)
> >>>> +               return -ENOENT;
> >>>> +
> >>>> +       *new_iova = iova_node->iova + iova_node->size;
> >>>> +       return 0;
> >>>> +}
> >>>> diff --git a/drivers/net/ethernet/sfc/ef100_iova.h b/drivers/net/ethernet/sfc/ef100_iova.h
> >>>> new file mode 100644
> >>>> index 000000000000..68e39c4152c7
> >>>> --- /dev/null
> >>>> +++ b/drivers/net/ethernet/sfc/ef100_iova.h
> >>>> @@ -0,0 +1,40 @@
> >>>> +/* SPDX-License-Identifier: GPL-2.0 */
> >>>> +/* Driver for Xilinx network controllers and boards
> >>>> + * Copyright(C) 2020-2022 Xilinx, Inc.
> >>>> + * Copyright(C) 2022 Advanced Micro Devices, Inc.
> >>>> + *
> >>>> + * This program is free software; you can redistribute it and/or modify it
> >>>> + * under the terms of the GNU General Public License version 2 as published
> >>>> + * by the Free Software Foundation, incorporated herein by reference.
> >>>> + */
> >>>> +#ifndef EFX_EF100_IOVA_H
> >>>> +#define EFX_EF100_IOVA_H
> >>>> +
> >>>> +#include "ef100_nic.h"
> >>>> +#include "ef100_vdpa.h"
> >>>> +
> >>>> +#if defined(CONFIG_SFC_VDPA)
> >>>> +/**
> >>>> + * struct ef100_vdpa_iova_node - guest buffer iova entry
> >>>> + *
> >>>> + * @node: red black tree node
> >>>> + * @iova: mapping's IO virtual address
> >>>> + * @size: length of mapped region in bytes
> >>>> + * @free_node: free list node
> >>>> + */
> >>>> +struct ef100_vdpa_iova_node {
> >>>> +       struct rb_node node;
> >>>> +       unsigned long iova;
> >>>> +       size_t size;
> >>>> +       struct list_head free_node;
> >>>> +};
> >>>> +
> >>>> +int efx_ef100_insert_iova_node(struct ef100_vdpa_nic *vdpa_nic,
> >>>> +                              u64 iova, u64 size);
> >>>> +void efx_ef100_remove_iova_node(struct ef100_vdpa_nic *vdpa_nic,
> >>>> +                               unsigned long iova);
> >>>> +void efx_ef100_delete_iova(struct ef100_vdpa_nic *vdpa_nic);
> >>>> +int efx_ef100_find_new_iova(struct ef100_vdpa_nic *vdpa_nic,
> >>>> +                           unsigned int buf_len, u64 *new_iova);
> >>>> +#endif  /* CONFIG_SFC_VDPA */
> >>>> +#endif /* EFX_EF100_IOVA_H */
> >>>> diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
> >>>> index 41811c519275..72820d2fe19d 100644
> >>>> --- a/drivers/net/ethernet/sfc/ef100_nic.c
> >>>> +++ b/drivers/net/ethernet/sfc/ef100_nic.c
> >>>> @@ -33,7 +33,6 @@
> >>>>
> >>>>    #define EF100_MAX_VIS 4096
> >>>>    #define EF100_NUM_MCDI_BUFFERS 1
> >>>> -#define MCDI_BUF_LEN (8 + MCDI_CTL_SDU_LEN_MAX)
> >>>>
> >>>>    #define EF100_RESET_PORT ((ETH_RESET_MAC | ETH_RESET_PHY) << ETH_RESET_SHARED_SHIFT)
> >>>>
> >>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.c b/drivers/net/ethernet/sfc/ef100_vdpa.c
> >>>> index 80bca281a748..b9368eb1acd5 100644
> >>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.c
> >>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.c
> >>>> @@ -14,6 +14,7 @@
> >>>>    #include <uapi/linux/vdpa.h>
> >>>>    #include "ef100_vdpa.h"
> >>>>    #include "mcdi_vdpa.h"
> >>>> +#include "ef100_iova.h"
> >>>>    #include "mcdi_filters.h"
> >>>>    #include "mcdi_functions.h"
> >>>>    #include "ef100_netdev.h"
> >>>> @@ -280,6 +281,34 @@ static int get_net_config(struct ef100_vdpa_nic *vdpa_nic)
> >>>>           return 0;
> >>>>    }
> >>>>
> >>>> +static int vdpa_update_domain(struct ef100_vdpa_nic *vdpa_nic)
> >>>> +{
> >>>> +       struct vdpa_device *vdpa = &vdpa_nic->vdpa_dev;
> >>>> +       struct iommu_domain_geometry *geo;
> >>>> +       struct device *dma_dev;
> >>>> +
> >>>> +       dma_dev = vdpa_get_dma_dev(vdpa);
> >>>> +       if (!device_iommu_capable(dma_dev, IOMMU_CAP_CACHE_COHERENCY))
> >>>> +               return -EOPNOTSUPP;
> >>>> +
> >>>> +       vdpa_nic->domain = iommu_get_domain_for_dev(dma_dev);
> >>>> +       if (!vdpa_nic->domain)
> >>>> +               return -ENODEV;
> >>>> +
> >>>> +       geo = &vdpa_nic->domain->geometry;
> >>>> +       /* save the geo aperture range for validation in dma_map */
> >>>> +       vdpa_nic->geo_aper_start = geo->aperture_start;
> >>>> +
> >>>> +       /* Handle the boundary case */
> >>>> +       if (geo->aperture_end == ~0ULL)
> >>>> +               geo->aperture_end -= 1;
> >>>> +       vdpa_nic->geo_aper_end = geo->aperture_end;
> >>>> +
> >>>> +       /* insert a sentinel node */
> >>>> +       return efx_ef100_insert_iova_node(vdpa_nic,
> >>>> +                                         vdpa_nic->geo_aper_end + 1, 0);
> >>>> +}
> >>>> +
> >>>>    static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
> >>>>                                                   const char *dev_name,
> >>>>                                                   enum ef100_vdpa_class dev_type,
> >>>> @@ -316,6 +345,7 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
> >>>>           }
> >>>>
> >>>>           mutex_init(&vdpa_nic->lock);
> >>>> +       mutex_init(&vdpa_nic->iova_lock);
> >>>>           dev = &vdpa_nic->vdpa_dev.dev;
> >>>>           efx->vdpa_nic = vdpa_nic;
> >>>>           vdpa_nic->vdpa_dev.dma_dev = &efx->pci_dev->dev;
> >>>> @@ -325,9 +355,11 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
> >>>>           vdpa_nic->pf_index = nic_data->pf_index;
> >>>>           vdpa_nic->vf_index = nic_data->vf_index;
> >>>>           vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
> >>>> +       vdpa_nic->iova_root = RB_ROOT;
> >>>>           vdpa_nic->mac_address = (u8 *)&vdpa_nic->net_config.mac;
> >>>>           ether_addr_copy(vdpa_nic->mac_address, mac);
> >>>>           vdpa_nic->mac_configured = true;
> >>>> +       INIT_LIST_HEAD(&vdpa_nic->free_list);
> >>>>
> >>>>           for (i = 0; i < EF100_VDPA_MAC_FILTER_NTYPES; i++)
> >>>>                   vdpa_nic->filters[i].filter_id = EFX_INVALID_FILTER_ID;
> >>>> @@ -353,6 +385,12 @@ static struct ef100_vdpa_nic *ef100_vdpa_create(struct efx_nic *efx,
> >>>>                   goto err_put_device;
> >>>>           }
> >>>>
> >>>> +       rc = vdpa_update_domain(vdpa_nic);
> >>>> +       if (rc) {
> >>>> +               pci_err(efx->pci_dev, "update_domain failed, err: %d\n", rc);
> >>>> +               goto err_put_device;
> >>>> +       }
> >>>> +
> >>>>           rc = get_net_config(vdpa_nic);
> >>>>           if (rc)
> >>>>                   goto err_put_device;
> >>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa.h b/drivers/net/ethernet/sfc/ef100_vdpa.h
> >>>> index 1b0bbba88154..c3c77029973d 100644
> >>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa.h
> >>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa.h
> >>>> @@ -12,7 +12,9 @@
> >>>>    #define __EF100_VDPA_H__
> >>>>
> >>>>    #include <linux/vdpa.h>
> >>>> +#include <linux/iommu.h>
> >>>>    #include <uapi/linux/virtio_net.h>
> >>>> +#include <linux/rbtree.h>
> >>>>    #include "net_driver.h"
> >>>>    #include "ef100_nic.h"
> >>>>
> >>>> @@ -155,6 +157,12 @@ struct ef100_vdpa_filter {
> >>>>     * @mac_configured: true after MAC address is configured
> >>>>     * @filters: details of all filters created on this vdpa device
> >>>>     * @cfg_cb: callback for config change
> >>>> + * @domain: IOMMU domain
> >>>> + * @iova_root: iova rbtree root
> >>>> + * @iova_lock: lock to synchronize updates to rbtree and freelist
> >>>> + * @free_list: list to store free iova areas of size >= MCDI buffer length
> >>>> + * @geo_aper_start: start of valid IOVA range
> >>>> + * @geo_aper_end: end of valid IOVA range
> >>>>     */
> >>>>    struct ef100_vdpa_nic {
> >>>>           struct vdpa_device vdpa_dev;
> >>>> @@ -174,6 +182,13 @@ struct ef100_vdpa_nic {
> >>>>           bool mac_configured;
> >>>>           struct ef100_vdpa_filter filters[EF100_VDPA_MAC_FILTER_NTYPES];
> >>>>           struct vdpa_callback cfg_cb;
> >>>> +       struct iommu_domain *domain;
> >>>> +       struct rb_root iova_root;
> >>>> +       /* mutex to synchronize rbtree operations */
> >>>> +       struct mutex iova_lock;
> >>>> +       struct list_head free_list;
> >>>> +       u64 geo_aper_start;
> >>>> +       u64 geo_aper_end;
> >>>>    };
> >>>>
> >>>>    int ef100_vdpa_init(struct efx_probe_data *probe_data);
> >>>> diff --git a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> >>>> index 718b67f6da90..8c198d949fdb 100644
> >>>> --- a/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> >>>> +++ b/drivers/net/ethernet/sfc/ef100_vdpa_ops.c
> >>>> @@ -10,6 +10,7 @@
> >>>>
> >>>>    #include <linux/vdpa.h>
> >>>>    #include "ef100_vdpa.h"
> >>>> +#include "ef100_iova.h"
> >>>>    #include "io.h"
> >>>>    #include "mcdi_vdpa.h"
> >>>>
> >>>> @@ -260,6 +261,7 @@ static void ef100_reset_vdpa_device(struct ef100_vdpa_nic *vdpa_nic)
> >>>>           if (!vdpa_nic->status)
> >>>>                   return;
> >>>>
> >>>> +       efx_ef100_delete_iova(vdpa_nic);
> >>>>           vdpa_nic->vdpa_state = EF100_VDPA_STATE_INITIALIZED;
> >>>>           vdpa_nic->status = 0;
> >>>>           vdpa_nic->features = 0;
> >>>> @@ -743,9 +745,12 @@ static void ef100_vdpa_free(struct vdpa_device *vdev)
> >>>>           int i;
> >>>>
> >>>>           if (vdpa_nic) {
> >>>> +               /* clean-up the mappings and iova tree */
> >>>> +               efx_ef100_delete_iova(vdpa_nic);
> >>>>                   for (i = 0; i < (vdpa_nic->max_queue_pairs * 2); i++)
> >>>>                           reset_vring(vdpa_nic, i);
> >>>>                   ef100_vdpa_irq_vectors_free(vdpa_nic->efx->pci_dev);
> >>>> +               mutex_destroy(&vdpa_nic->iova_lock);
> >>>>                   mutex_destroy(&vdpa_nic->lock);
> >>>>                   vdpa_nic->efx->vdpa_nic = NULL;
> >>>>           }
> >>>> diff --git a/drivers/net/ethernet/sfc/mcdi.h b/drivers/net/ethernet/sfc/mcdi.h
> >>>> index db4ca4975ada..7d977a58a0df 100644
> >>>> --- a/drivers/net/ethernet/sfc/mcdi.h
> >>>> +++ b/drivers/net/ethernet/sfc/mcdi.h
> >>>> @@ -7,6 +7,7 @@
> >>>>    #ifndef EFX_MCDI_H
> >>>>    #define EFX_MCDI_H
> >>>>
> >>>> +#include "mcdi_pcol.h"
> >>>>    /**
> >>>>     * enum efx_mcdi_state - MCDI request handling state
> >>>>     * @MCDI_STATE_QUIESCENT: No pending MCDI requests. If the caller holds the
> >>>> @@ -40,6 +41,8 @@ enum efx_mcdi_mode {
> >>>>           MCDI_MODE_FAIL,
> >>>>    };
> >>>>
> >>>> +#define MCDI_BUF_LEN (8 + MCDI_CTL_SDU_LEN_MAX)
> >>>> +
> >>>>    /**
> >>>>     * struct efx_mcdi_iface - MCDI protocol context
> >>>>     * @efx: The associated NIC.
> >>>> --
> >>>> 2.30.1
> >>>>
>

