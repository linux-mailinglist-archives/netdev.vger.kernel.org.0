Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 213C26E129B
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 18:44:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229877AbjDMQom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 12:44:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbjDMQol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 12:44:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3DB9019
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 09:44:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A41063FF8
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 16:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18C9C433D2;
        Thu, 13 Apr 2023 16:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681404279;
        bh=qFdcDHvpvGhtecq/isOAVGpp1qUk4AjeLTlHwWTtzAc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dyCB22RXGizRh9wjMvw3MBKWmHf86AIJ6Dh7e/nbX3zux7jecwFidcDPztk8s0b0h
         6WchFok3srxsAKzn1x695oofNVE28M/0qEVC8rvVuZXOt/gdo6DlwIr5jPHzM3JE68
         fGym2cPS289KZkLxKNPNWzn7+xhR7tflUGnImydDLETiJ5Cslm9EfLcZ/IHHjA6jjw
         qhWqtBolVVTrpRICtZpYtY3jNDvR+9JMzAUqPJ+yTpH/rbALLECRsGHTSAWpMHOYCc
         /6ZsHMRivWFGrYCu8kIpH4R2wlUH9GJdETtzaYF8rjOwzJV5ijbI1gSjXTKZGeebed
         W4ZhKdljoF/Dw==
Date:   Thu, 13 Apr 2023 19:44:34 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shannon Nelson <shannon.nelson@amd.com>, brett.creeley@amd.com,
        davem@davemloft.net, netdev@vger.kernel.org, drivers@pensando.io,
        jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 13/14] pds_core: publish events to the clients
Message-ID: <20230413164434.GT17993@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-14-shannon.nelson@amd.com>
 <20230409171143.GH182481@unreal>
 <f5fbc5c7-2329-93e6-044d-7b70d96530be@amd.com>
 <20230413085501.GH17993@unreal>
 <20230413081410.2cbaf2a2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413081410.2cbaf2a2@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 08:14:10AM -0700, Jakub Kicinski wrote:
> On Thu, 13 Apr 2023 11:55:01 +0300 Leon Romanovsky wrote:
> > > > > diff --git a/drivers/net/ethernet/amd/pds_core/adminq.c b/drivers/net/ethernet/amd/pds_core/adminq.c
> > > > > index 25c7dd0d37e5..bb18ac1aabab 100644
> > > > > --- a/drivers/net/ethernet/amd/pds_core/adminq.c
> > > > > +++ b/drivers/net/ethernet/amd/pds_core/adminq.c
> > > > > @@ -27,11 +27,13 @@ static int pdsc_process_notifyq(struct pdsc_qcq *qcq)
> > > > >                case PDS_EVENT_LINK_CHANGE:
> > > > >                        dev_info(pdsc->dev, "NotifyQ LINK_CHANGE ecode %d eid %lld\n",
> > > > >                                 ecode, eid);
> > > > > +                     pdsc_notify(PDS_EVENT_LINK_CHANGE, comp);  
> > > > 
> > > > Aren't you "resending" standard netdev event?
> > > > It will be better to send only custom, specific to pds_core events,
> > > > while leaving general ones to netdev.  
> > > 
> > > We have no netdev in pds_core, so we have to publish this to clients that
> > > might have a netdev or some other need to know.  
> > 
> > I don't know netdev well enough if it is ok or not and maybe netdev will
> > sent this LINK_CHANGE by itself anyway.
> > 
> > Jakub???
> 
> I actually prefer for the driver to distribute the event via its own
> means than some random borderline proprietary stuff outside of netdev
> using netdev events.

ok

> 
> > > > We can argue if clients should get this event. Once reset is detected,
> > > > the pds_core should close devices by deleting aux drivers.  
> > > 
> > > We can get a reset signal from the device when it has done a crash recovery
> > > or when it is preparing to do an update, and this allows clients to quiesce
> > > their operations when reset.state==0 and restart when they see
> > > reset.state==1  
> > 
> > I don't think that it is safe behaviour from user POV. If FW resets
> > itself under the hood, how can client be sure that nothing changes
> > in its operation? Once FW reset occurs, it is much safer for the clients
> > to reconfigure everything.
> 
> What's the argument exactly? We do have async resets including in mlx5,
> grep for enable_remote_dev_reset

I think that it is different. I'm complaining that during FW reset,
auxiliary devices are not recreated and continue to be connected to
physical device with a hope that everything will continue to work from
kernel and FW perspective.

It is different from enable_remote_dev_reset, where someone externally
resets device which will trigger mlx5_device_rescan() routine through
mlx5_unload_one->mlx5_load_one sequence.

Thanks
