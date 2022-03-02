Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403914CA36F
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 12:20:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbiCBLUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 06:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234746AbiCBLUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 06:20:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 807ADDF9C
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 03:19:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646219976;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oU9xsUH3KYvT9qc7F2Zj/zrvWJj+uZjGFINcg4AMqQg=;
        b=FSar0niXUURZekXfNwMOAMb1ue7e4TYS3VZ+nAqF3wAMPaSdmCnRh+2M3eJkrIG8hGAkwt
        /AeLF4oMB7gdkhURKqTEUk41a3XX8tnD/hDR+fTPxciyir0ZNM3mMNAPgHgERDbtMpD52V
        dIEx0mZz85kSXKpH40pzvt5zCV4rl5k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-36-qOQrJP2YOWal2iQgFKzSHw-1; Wed, 02 Mar 2022 06:19:31 -0500
X-MC-Unique: qOQrJP2YOWal2iQgFKzSHw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 990E01006AA5;
        Wed,  2 Mar 2022 11:19:29 +0000 (UTC)
Received: from localhost (unknown [10.39.194.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E6E697554E;
        Wed,  2 Mar 2022 11:19:21 +0000 (UTC)
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
Date:   Wed, 02 Mar 2022 12:19:20 +0100
Message-ID: <87tucgiouf.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
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
>
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 71763e2ac561..b37ab27b511f 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1557,6 +1557,197 @@ static int vfio_device_fops_release(struct inode *inode, struct file *filep)
>  	return 0;
>  }
>  
> +/*
> + * vfio_mig_get_next_state - Compute the next step in the FSM
> + * @cur_fsm - The current state the device is in
> + * @new_fsm - The target state to reach
> + * @next_fsm - Pointer to the next step to get to new_fsm
> + *
> + * Return 0 upon success, otherwise -errno
> + * Upon success the next step in the state progression between cur_fsm and
> + * new_fsm will be set in next_fsm.

What about non-success? Can the caller make any assumption about
next_fsm in that case? Because...

> + *
> + * This breaks down requests for combination transitions into smaller steps and
> + * returns the next step to get to new_fsm. The function may need to be called
> + * multiple times before reaching new_fsm.
> + *
> + */
> +int vfio_mig_get_next_state(struct vfio_device *device,
> +			    enum vfio_device_mig_state cur_fsm,
> +			    enum vfio_device_mig_state new_fsm,
> +			    enum vfio_device_mig_state *next_fsm)
> +{
> +	enum { VFIO_DEVICE_NUM_STATES = VFIO_DEVICE_STATE_RESUMING + 1 };
> +	/*
> +	 * The coding in this table requires the driver to implement 6
> +	 * FSM arcs:
> +	 *         RESUMING -> STOP
> +	 *         RUNNING -> STOP
> +	 *         STOP -> RESUMING
> +	 *         STOP -> RUNNING
> +	 *         STOP -> STOP_COPY
> +	 *         STOP_COPY -> STOP
> +	 *
> +	 * The coding will step through multiple states for these combination
> +	 * transitions:
> +	 *         RESUMING -> STOP -> RUNNING
> +	 *         RESUMING -> STOP -> STOP_COPY
> +	 *         RUNNING -> STOP -> RESUMING
> +	 *         RUNNING -> STOP -> STOP_COPY
> +	 *         STOP_COPY -> STOP -> RESUMING
> +	 *         STOP_COPY -> STOP -> RUNNING
> +	 */
> +	static const u8 vfio_from_fsm_table[VFIO_DEVICE_NUM_STATES][VFIO_DEVICE_NUM_STATES] = {
> +		[VFIO_DEVICE_STATE_STOP] = {
> +			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
> +			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
> +			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RESUMING,
> +			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
> +		},
> +		[VFIO_DEVICE_STATE_RUNNING] = {
> +			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_RUNNING,
> +			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
> +		},
> +		[VFIO_DEVICE_STATE_STOP_COPY] = {
> +			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP_COPY,
> +			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
> +		},
> +		[VFIO_DEVICE_STATE_RESUMING] = {
> +			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_RESUMING,
> +			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
> +		},
> +		[VFIO_DEVICE_STATE_ERROR] = {
> +			[VFIO_DEVICE_STATE_STOP] = VFIO_DEVICE_STATE_ERROR,
> +			[VFIO_DEVICE_STATE_RUNNING] = VFIO_DEVICE_STATE_ERROR,
> +			[VFIO_DEVICE_STATE_STOP_COPY] = VFIO_DEVICE_STATE_ERROR,
> +			[VFIO_DEVICE_STATE_RESUMING] = VFIO_DEVICE_STATE_ERROR,
> +			[VFIO_DEVICE_STATE_ERROR] = VFIO_DEVICE_STATE_ERROR,
> +		},
> +	};
> +
> +	if (WARN_ON(cur_fsm >= ARRAY_SIZE(vfio_from_fsm_table)))
> +		return -EINVAL;
> +
> +	if (new_fsm >= ARRAY_SIZE(vfio_from_fsm_table))
> +		return -EINVAL;
> +
> +	*next_fsm = vfio_from_fsm_table[cur_fsm][new_fsm];
> +	return (*next_fsm != VFIO_DEVICE_STATE_ERROR) ? 0 : -EINVAL;

...next_fsm will contain STATE_ERROR if we try to transition from or to
STATE_ERROR, but it remains unchanged if the input states are out of
range, yet in both cases the return value is -EINVAL. Looking further, ...

> + * any -> ERROR
> + *   ERROR cannot be specified as a device state, however any transition request
> + *   can be failed with an errno return and may then move the device_state into
> + *   ERROR. In this case the device was unable to execute the requested arc and
> + *   was also unable to restore the device to any valid device_state.
> + *   To recover from ERROR VFIO_DEVICE_RESET must be used to return the
> + *   device_state back to RUNNING.

...this seems to indicate that not moving into STATE_ERROR is an
option anyway. Do we need any extra guidance in the description for
vfio_mig_get_next_state()?

