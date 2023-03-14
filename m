Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E11136B939E
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 13:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231946AbjCNMUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 08:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbjCNMUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 08:20:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13337A2275
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 05:16:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C128A6172B
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 12:15:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7BAC433EF;
        Tue, 14 Mar 2023 12:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678796100;
        bh=jkYLyaAc+KE6jZ0wX3UOBpjU63FeEVjJhzt3IG8wLto=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Yw9qJ/x+rbW6Osnw7PQhzSnUvwPspsZM7S+owxHLOjuOVzQ16SXH2NLVtruFS6dVT
         L/QpqgHRSE2+z4fDashhRl11XLGmBdZImDCqYsxVLo563OOtWhGeFHa2igfRPYqmwR
         7Dm+dlOJG0YkbCsgFb1emBDBc219DkwURrlDkN3DhuUs0Dwza1Dg7VWClMayCfCROc
         tQlNFfR7SSTi94Ls4lo6g/mCiCiZhaot4mOw+NVJLhimuwfRqaGEJXzmmfZ/NFfcIY
         4MO0g3h6BCDnKDFFldpygsSnnCw80cadLsXZaL7aQbMH41koa8hJ5uNIK/RchVZgpq
         /c/R9tPZhkk4g==
Date:   Tue, 14 Mar 2023 14:14:52 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH RFC v4 net-next 11/13] pds_core: add the aux client API
Message-ID: <20230314121452.GC36557@unreal>
References: <20230308051310.12544-1-shannon.nelson@amd.com>
 <20230308051310.12544-12-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308051310.12544-12-shannon.nelson@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 09:13:08PM -0800, Shannon Nelson wrote:
> Add the client API operations for registering, unregistering,
> and running adminq commands.  We expect to add additional
> operations for other clients, including requesting additional
> private adminqs and IRQs, but don't have the need yet,
> 
> Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> ---
>  drivers/net/ethernet/amd/pds_core/auxbus.c | 134 ++++++++++++++++++++-
>  include/linux/pds/pds_auxbus.h             |  42 +++++++
>  2 files changed, 174 insertions(+), 2 deletions(-)

<...>

> +static struct pds_core_ops pds_core_ops = {
> +	.register_client = pds_client_register,
> +	.unregister_client = pds_client_unregister,
> +	.adminq_cmd = pds_client_adminq_cmd,
> +};

<...>

> +/*
> + *   ptrs to functions to be used by the client for core services
> + */
> +struct pds_core_ops {
> +	/* .register() - register the client with the device
> +	 * padev:  ptr to the client device info
> +	 * Register the client with the core and with the DSC.  The core
> +	 * will fill in the client padrv->client_id for use in calls
> +	 * to the DSC AdminQ
> +	 */
> +	int (*register_client)(struct pds_auxiliary_dev *padev);
> +
> +	/* .unregister() - disconnect the client from the device
> +	 * padev:  ptr to the client device info
> +	 * Disconnect the client from the core and with the DSC.
> +	 */
> +	int (*unregister_client)(struct pds_auxiliary_dev *padev);
> +
> +	/* .adminq_cmd() - process an adminq request for the client
> +	 * padev:  ptr to the client device
> +	 * req:     ptr to buffer with request
> +	 * req_len: length of actual struct used for request
> +	 * resp:    ptr to buffer where answer is to be copied
> +	 * flags:   optional flags defined by enum pds_core_adminq_flags
> +	 *	    and used for more flexible adminq behvior
> +	 *
> +	 * returns 0 on success, or
> +	 *         negative for error
> +	 * Client sends pointers to request and response buffers
> +	 * Core copies request data into pds_core_client_request_cmd
> +	 * Core sets other fields as needed
> +	 * Core posts to AdminQ
> +	 * Core copies completion data into response buffer
> +	 */
> +	int (*adminq_cmd)(struct pds_auxiliary_dev *padev,
> +			  union pds_core_adminq_cmd *req,
> +			  size_t req_len,
> +			  union pds_core_adminq_comp *resp,
> +			  u64 flags);
> +};

I don't expect to see any register/unregister AUX client code at all.

All clients are registered and unregistered through
auxiliary_driver_register()/auxiliary_driver_unregister() calls and
perform as standalone drivers.

Maybe client, register and unregister words means something else in this
series..

Thanks

>  #endif /* _PDSC_AUXBUS_H_ */
> -- 
> 2.17.1
> 
