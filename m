Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE6664CAAF1
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 17:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243567AbiCBQ6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 11:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243581AbiCBQ6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 11:58:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B2D021E16
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 08:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646240268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tmS5o/o7TOxgF/ChRH9DIbCR+xpKRUvssVTS2w4RtUs=;
        b=COx6V6YMCVLkJKZwhT/8xUFcaKoMsysd7Y6pj0QX6puiOsTMFcHh49CMy6+FeIABk3H9oM
        0kzhBIJVASVfPNBsHdZ5ZE6GFVSPBxOm/J+fSm+232G3iR1fG//GSJPwqfaEelXIZL1rSp
        XjXwrD9wi0ci2FNVGnCiza0PlgTsu08=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-37-dgeZSHUkP-W5PjRyWKQeow-1; Wed, 02 Mar 2022 11:57:41 -0500
X-MC-Unique: dgeZSHUkP-W5PjRyWKQeow-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F3424824FA6;
        Wed,  2 Mar 2022 16:57:38 +0000 (UTC)
Received: from localhost (unknown [10.39.194.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 246F72DE6B;
        Wed,  2 Mar 2022 16:57:26 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, jgg@nvidia.com, saeedm@nvidia.com
Cc:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        maorg@nvidia.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V9 mlx5-next 09/15] vfio: Define device migration
 protocol v2
In-Reply-To: <20220224142024.147653-10-yishaih@nvidia.com>
Organization: Red Hat GmbH
References: <20220224142024.147653-1-yishaih@nvidia.com>
 <20220224142024.147653-10-yishaih@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Wed, 02 Mar 2022 17:57:25 +0100
Message-ID: <87h78gi96y.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24 2022, Yishai Hadas <yishaih@nvidia.com> wrote:

> From: Jason Gunthorpe <jgg@nvidia.com>
>
> Replace the existing region based migration protocol with an ioctl based
> protocol. The two protocols have the same general semantic behaviors, but
> the way the data is transported is changed.
>
> This is the STOP_COPY portion of the new protocol, it defines the 5 states
> for basic stop and copy migration and the protocol to move the migration
> data in/out of the kernel.
>
> Compared to the clarification of the v1 protocol Alex proposed:
>
> https://lore.kernel.org/r/163909282574.728533.7460416142511440919.stgit@omen
>
> This has a few deliberate functional differences:
>
>  - ERROR arcs allow the device function to remain unchanged.
>
>  - The protocol is not required to return to the original state on
>    transition failure. Instead userspace can execute an unwind back to
>    the original state, reset, or do something else without needing kernel
>    support. This simplifies the kernel design and should userspace choose
>    a policy like always reset, avoids doing useless work in the kernel
>    on error handling paths.
>
>  - PRE_COPY is made optional, userspace must discover it before using it.
>    This reflects the fact that the majority of drivers we are aware of
>    right now will not implement PRE_COPY.
>
>  - segmentation is not part of the data stream protocol, the receiver
>    does not have to reproduce the framing boundaries.
>
> The hybrid FSM for the device_state is described as a Mealy machine by
> documenting each of the arcs the driver is required to implement. Defining
> the remaining set of old/new device_state transitions as 'combination
> transitions' which are naturally defined as taking multiple FSM arcs along
> the shortest path within the FSM's digraph allows a complete matrix of
> transitions.
>
> A new VFIO_DEVICE_FEATURE of VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE is
> defined to replace writing to the device_state field in the region. This
> allows returning a brand new FD whenever the requested transition opens
> a data transfer session.
>
> The VFIO core code implements the new feature and provides a helper
> function to the driver. Using the helper the driver only has to
> implement 6 of the FSM arcs and the other combination transitions are
> elaborated consistently from those arcs.
>
> A new VFIO_DEVICE_FEATURE of VFIO_DEVICE_FEATURE_MIGRATION is defined to
> report the capability for migration and indicate which set of states and
> arcs are supported by the device. The FSM provides a lot of flexibility to
> make backwards compatible extensions but the VFIO_DEVICE_FEATURE also
> allows for future breaking extensions for scenarios that cannot support
> even the basic STOP_COPY requirements.
>
> The VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE with the GET option (i.e.
> VFIO_DEVICE_FEATURE_GET) can be used to read the current migration state
> of the VFIO device.
>
> Data transfer sessions are now carried over a file descriptor, instead of
> the region. The FD functions for the lifetime of the data transfer
> session. read() and write() transfer the data with normal Linux stream FD
> semantics. This design allows future expansion to support poll(),
> io_uring, and other performance optimizations.
>
> The complicated mmap mode for data transfer is discarded as current qemu
> doesn't take meaningful advantage of it, and the new qemu implementation
> avoids substantially all the performance penalty of using a read() on the
> region.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/vfio.c       | 199 ++++++++++++++++++++++++++++++++++++++
>  include/linux/vfio.h      |  20 ++++
>  include/uapi/linux/vfio.h | 174 ++++++++++++++++++++++++++++++---
>  3 files changed, 380 insertions(+), 13 deletions(-)

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

