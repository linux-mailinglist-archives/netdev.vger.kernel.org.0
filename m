Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 101304CA434
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 12:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241549AbiCBLwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 06:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238688AbiCBLwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 06:52:42 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0BEC1BA76A
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 03:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646221919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jAXAYjUrgMx+ZFpGkYgayFywUdTmweQrg5kkKs1bAUg=;
        b=aBvus+0Vt+mI3oFLjaZeQ9dc0zvEuLSC44opiGHfKnBW3T8Bzim04fQBFi0f9hcwWzVTlX
        KSLL6ykmxmIxcnuUVIj6DSaG6pG8disKYGuR4IIsub3btD2TKRtQ4A+GG1RefoBJ4xJj85
        HxAolltY8sn0c7uKgdK4yEX1VkNgeks=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-407-YwMkvoEGPAqPN-vx-l5pEQ-1; Wed, 02 Mar 2022 06:51:56 -0500
X-MC-Unique: YwMkvoEGPAqPN-vx-l5pEQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 201641006AA5;
        Wed,  2 Mar 2022 11:51:54 +0000 (UTC)
Received: from localhost (unknown [10.39.194.94])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B981D7C0CC;
        Wed,  2 Mar 2022 11:51:50 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Yishai Hadas <yishaih@nvidia.com>, alex.williamson@redhat.com,
        bhelgaas@google.com, jgg@nvidia.com, saeedm@nvidia.com
Cc:     linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, yishaih@nvidia.com,
        maorg@nvidia.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V9 mlx5-next 10/15] vfio: Extend the device migration
 protocol with RUNNING_P2P
In-Reply-To: <20220224142024.147653-11-yishaih@nvidia.com>
Organization: Red Hat GmbH
References: <20220224142024.147653-1-yishaih@nvidia.com>
 <20220224142024.147653-11-yishaih@nvidia.com>
User-Agent: Notmuch/0.34 (https://notmuchmail.org)
Date:   Wed, 02 Mar 2022 12:51:49 +0100
Message-ID: <87pmn4inca.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24 2022, Yishai Hadas <yishaih@nvidia.com> wrote:

> From: Jason Gunthorpe <jgg@nvidia.com>
>
> The RUNNING_P2P state is designed to support multiple devices in the same
> VM that are doing P2P transactions between themselves. When in RUNNING_P2P
> the device must be able to accept incoming P2P transactions but should not
> generate outgoing P2P transactions.
>
> As an optional extension to the mandatory states it is defined as
> inbetween STOP and RUNNING:
>    STOP -> RUNNING_P2P -> RUNNING -> RUNNING_P2P -> STOP
>
> For drivers that are unable to support RUNNING_P2P the core code
> silently merges RUNNING_P2P and RUNNING together. Unless driver support
> is present, the new state cannot be used in SET_STATE.
> Drivers that support this will be required to implement 4 FSM arcs
> beyond the basic FSM. 2 of the basic FSM arcs become combination
> transitions.
>
> Compared to the v1 clarification, NDMA is redefined into FSM states and is
> described in terms of the desired P2P quiescent behavior, noting that
> halting all DMA is an acceptable implementation.
>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> ---
>  drivers/vfio/vfio.c       | 84 +++++++++++++++++++++++++++++++--------
>  include/linux/vfio.h      |  1 +
>  include/uapi/linux/vfio.h | 36 ++++++++++++++++-
>  3 files changed, 102 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index b37ab27b511f..bdb5205bb358 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1577,39 +1577,55 @@ int vfio_mig_get_next_state(struct vfio_device *device,
>  			    enum vfio_device_mig_state new_fsm,
>  			    enum vfio_device_mig_state *next_fsm)
>  {
> -	enum { VFIO_DEVICE_NUM_STATES = VFIO_DEVICE_STATE_RESUMING + 1 };
> +	enum { VFIO_DEVICE_NUM_STATES = VFIO_DEVICE_STATE_RUNNING_P2P + 1 };
>  	/*
> -	 * The coding in this table requires the driver to implement 6
> +	 * The coding in this table requires the driver to implement
>  	 * FSM arcs:

Nit: this now reads a bit strange; maybe "requires the driver to
implement the following FSM arcs"?

>  	 *         RESUMING -> STOP
> -	 *         RUNNING -> STOP
>  	 *         STOP -> RESUMING
> -	 *         STOP -> RUNNING
>  	 *         STOP -> STOP_COPY
>  	 *         STOP_COPY -> STOP
>  	 *
> -	 * The coding will step through multiple states for these combination
> -	 * transitions:
> -	 *         RESUMING -> STOP -> RUNNING
> +	 * If P2P is supported then the driver must also implement these FSM
> +	 * arcs:
> +	 *         RUNNING -> RUNNING_P2P
> +	 *         RUNNING_P2P -> RUNNING
> +	 *         RUNNING_P2P -> STOP
> +	 *         STOP -> RUNNING_P2P
> +	 * Without P2P the driver must implement:
> +	 *         RUNNING -> STOP
> +	 *         STOP -> RUNNING
> +	 *
> +	 * If all optional features are supported then the coding will step
> +	 * through multiple states for these combination transitions:

Maybe "The coding will step through multiple states for some combination
transitions; if all optional features are supported, this means the
following ones:"?

> +	 *         RESUMING -> STOP -> RUNNING_P2P
> +	 *         RESUMING -> STOP -> RUNNING_P2P -> RUNNING
>  	 *         RESUMING -> STOP -> STOP_COPY
> -	 *         RUNNING -> STOP -> RESUMING
> -	 *         RUNNING -> STOP -> STOP_COPY
> +	 *         RUNNING -> RUNNING_P2P -> STOP
> +	 *         RUNNING -> RUNNING_P2P -> STOP -> RESUMING
> +	 *         RUNNING -> RUNNING_P2P -> STOP -> STOP_COPY
> +	 *         RUNNING_P2P -> STOP -> RESUMING
> +	 *         RUNNING_P2P -> STOP -> STOP_COPY
> +	 *         STOP -> RUNNING_P2P -> RUNNING
>  	 *         STOP_COPY -> STOP -> RESUMING
> -	 *         STOP_COPY -> STOP -> RUNNING
> +	 *         STOP_COPY -> STOP -> RUNNING_P2P
> +	 *         STOP_COPY -> STOP -> RUNNING_P2P -> RUNNING
>  	 */

