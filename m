Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16546BAAAA
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbjCOIV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 04:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbjCOIVz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:21:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF05673885
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 01:21:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A4DE61B77
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF15C433EF;
        Wed, 15 Mar 2023 08:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678868486;
        bh=sTRwWeEs5btoevGiSnVNwwwGMz1QvOAL2wijWY95X1Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=C6tM1SnSCMX3Bqm42qQtAFWrGiO/M3YRkLw5Ajd1zgqdpoJOb+krXTtDgdkPSopze
         sm5/Ha/yRw05bohsvyFEb2Tj6FyWjYmMXZ+sMEmMWyobd0xNF4EPoEMr5+s/MQqLHa
         TPcb7kw+z4mPd397Qm28Dv5Z96ZWvudlWBjYONVRnul4rxfpMCIVzACNOYrjjQmBIY
         7dB/RZIOR3XQivhxc4MEq8lbWhtlCk/Q9CMN5eVZiiJoQogC9wKeGMbyKfxjan4Kif
         ocxljh0s3xZV8GOFNjC78wd2EmESnPYdjQpvZE3HSA5bqnhwf/tjH5yCqClpFYi29/
         dUnS7caAbSR9A==
Date:   Wed, 15 Mar 2023 10:21:22 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        kuba@kernel.org, drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH RFC v4 net-next 11/13] pds_core: add the aux client API
Message-ID: <20230315082122.GM36557@unreal>
References: <20230308051310.12544-1-shannon.nelson@amd.com>
 <20230308051310.12544-12-shannon.nelson@amd.com>
 <20230314121452.GC36557@unreal>
 <398bef7a-795b-d105-d8e5-57ef1c39049c@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <398bef7a-795b-d105-d8e5-57ef1c39049c@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 09:53:25AM -0700, Shannon Nelson wrote:
> On 3/14/23 5:14 AM, Leon Romanovsky wrote:
> > On Tue, Mar 07, 2023 at 09:13:08PM -0800, Shannon Nelson wrote:
> > > Add the client API operations for registering, unregistering,
> > > and running adminq commands.  We expect to add additional
> > > operations for other clients, including requesting additional
> > > private adminqs and IRQs, but don't have the need yet,
> > > 
> > > Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> > > ---
> > >   drivers/net/ethernet/amd/pds_core/auxbus.c | 134 ++++++++++++++++++++-
> > >   include/linux/pds/pds_auxbus.h             |  42 +++++++
> > >   2 files changed, 174 insertions(+), 2 deletions(-)
> > 
> > <...>
> > 
> > > +static struct pds_core_ops pds_core_ops = {
> > > +     .register_client = pds_client_register,
> > > +     .unregister_client = pds_client_unregister,
> > > +     .adminq_cmd = pds_client_adminq_cmd,
> > > +};
> > 
> > <...>
> > 
> > > +/*
> > > + *   ptrs to functions to be used by the client for core services
> > > + */
> > > +struct pds_core_ops {
> > > +     /* .register() - register the client with the device
> > > +      * padev:  ptr to the client device info
> > > +      * Register the client with the core and with the DSC.  The core
> > > +      * will fill in the client padrv->client_id for use in calls
> > > +      * to the DSC AdminQ
> > > +      */
> > > +     int (*register_client)(struct pds_auxiliary_dev *padev);
> > > +
> > > +     /* .unregister() - disconnect the client from the device
> > > +      * padev:  ptr to the client device info
> > > +      * Disconnect the client from the core and with the DSC.
> > > +      */
> > > +     int (*unregister_client)(struct pds_auxiliary_dev *padev);
> > > +
> > > +     /* .adminq_cmd() - process an adminq request for the client
> > > +      * padev:  ptr to the client device
> > > +      * req:     ptr to buffer with request
> > > +      * req_len: length of actual struct used for request
> > > +      * resp:    ptr to buffer where answer is to be copied
> > > +      * flags:   optional flags defined by enum pds_core_adminq_flags
> > > +      *          and used for more flexible adminq behvior
> > > +      *
> > > +      * returns 0 on success, or
> > > +      *         negative for error
> > > +      * Client sends pointers to request and response buffers
> > > +      * Core copies request data into pds_core_client_request_cmd
> > > +      * Core sets other fields as needed
> > > +      * Core posts to AdminQ
> > > +      * Core copies completion data into response buffer
> > > +      */
> > > +     int (*adminq_cmd)(struct pds_auxiliary_dev *padev,
> > > +                       union pds_core_adminq_cmd *req,
> > > +                       size_t req_len,
> > > +                       union pds_core_adminq_comp *resp,
> > > +                       u64 flags);
> > > +};
> > 
> > I don't expect to see any register/unregister AUX client code at all.
> > 
> > All clients are registered and unregistered through
> > auxiliary_driver_register()/auxiliary_driver_unregister() calls and
> > perform as standalone drivers.
> > 
> > Maybe client, register and unregister words means something else in this
> > series..
> 
> Yeah, I'm not thrilled with the overlap in nomenclature either.  In this
> case we're talking about the logic in the pds_vdpa module connecting to the
> services needed in the device FW, and getting a client_id from the FW that
> is used for tracking client context in the FW.  Maybe these names can change
> to something like "fw_client_reg" and "fw_client_unreg" - would that make it
> more clear?

I feel that such ops are not needed at all. Once you create aux devices
(vdpa, eth, e.t.c), you would be able to connect only one driver with one
such device. It means context is already known at that point. In addition,
user controls if he/she wants aux specific devices by relevant devlink *_enable
knob.

Thanks

> 
> sln
> 
> 
> > 
> > Thanks
> > 
> > >   #endif /* _PDSC_AUXBUS_H_ */
> > > --
> > > 2.17.1
> > > 
