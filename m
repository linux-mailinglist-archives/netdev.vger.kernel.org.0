Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78F686E097C
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 10:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjDMI5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 04:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbjDMI5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 04:57:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628DEA261
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 01:55:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95D9663C66
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 08:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9A9C4339B;
        Thu, 13 Apr 2023 08:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681376106;
        bh=ArIxCvU9Gme9Z535tAxvuvR2a3U3b+ElF1hH//yd4oc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fsy444VoEIge8GJS0BFqmlUcsAgc8BevMEdGYt3h8DUzXpPO5/uDcBi5xhCZIobFG
         DOhhQz9lXeLhydfj1RVmtqQU8KQMhSL4WBZB1uYD+kVp/moO20bKGjwAEdo0BFYW41
         DKR1F+/HEpTYKDE7oYfoFKk2Yq+qwXZxT/AY3D+UlzJL/QzjPiPWLdvwSe11oFSllA
         NKvVm7PKJwku2AEDiDFffFDdvmtVsUiZFkgz/NYXx0zr98M8m1KycMOQQ5OSFvYDgs
         pYtYSqsS8ApXRWI0fVyn5IoDGSt1H0n6npN+FHPs3e5//XcT03j70Jl+L51cDP5T+D
         Hoc87rmIXM9tA==
Date:   Thu, 13 Apr 2023 11:55:01 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>, kuba@kernel.org
Cc:     brett.creeley@amd.com, davem@davemloft.net, netdev@vger.kernel.org,
        drivers@pensando.io, jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 13/14] pds_core: publish events to the clients
Message-ID: <20230413085501.GH17993@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-14-shannon.nelson@amd.com>
 <20230409171143.GH182481@unreal>
 <f5fbc5c7-2329-93e6-044d-7b70d96530be@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5fbc5c7-2329-93e6-044d-7b70d96530be@amd.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 02:01:13PM -0700, Shannon Nelson wrote:
> On 4/9/23 10:11 AM, Leon Romanovsky wrote:
> > 
> > On Thu, Apr 06, 2023 at 04:41:42PM -0700, Shannon Nelson wrote:
> > > When the Core device gets an event from the device, or notices
> > > the device FW to be up or down, it needs to send those events
> > > on to the clients that have an event handler.  Add the code to
> > > pass along the events to the clients.
> > > 
> > > The entry points pdsc_register_notify() and pdsc_unregister_notify()
> > > are EXPORTed for other drivers that want to listen for these events.
> > > 
> > > Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
> > > ---
> > >   drivers/net/ethernet/amd/pds_core/adminq.c |  2 ++
> > >   drivers/net/ethernet/amd/pds_core/core.c   | 32 ++++++++++++++++++++++
> > >   drivers/net/ethernet/amd/pds_core/core.h   |  3 ++
> > >   include/linux/pds/pds_common.h             |  2 ++
> > >   4 files changed, 39 insertions(+)
> > > 
> > > diff --git a/drivers/net/ethernet/amd/pds_core/adminq.c b/drivers/net/ethernet/amd/pds_core/adminq.c
> > > index 25c7dd0d37e5..bb18ac1aabab 100644
> > > --- a/drivers/net/ethernet/amd/pds_core/adminq.c
> > > +++ b/drivers/net/ethernet/amd/pds_core/adminq.c
> > > @@ -27,11 +27,13 @@ static int pdsc_process_notifyq(struct pdsc_qcq *qcq)
> > >                case PDS_EVENT_LINK_CHANGE:
> > >                        dev_info(pdsc->dev, "NotifyQ LINK_CHANGE ecode %d eid %lld\n",
> > >                                 ecode, eid);
> > > +                     pdsc_notify(PDS_EVENT_LINK_CHANGE, comp);
> > 
> > Aren't you "resending" standard netdev event?
> > It will be better to send only custom, specific to pds_core events,
> > while leaving general ones to netdev.
> 
> We have no netdev in pds_core, so we have to publish this to clients that
> might have a netdev or some other need to know.

I don't know netdev well enough if it is ok or not and maybe netdev will
sent this LINK_CHANGE by itself anyway.

Jakub???

> 
> > 
> > >                        break;
> > > 
> > >                case PDS_EVENT_RESET:
> > >                        dev_info(pdsc->dev, "NotifyQ RESET ecode %d eid %lld\n",
> > >                                 ecode, eid);
> > > +                     pdsc_notify(PDS_EVENT_RESET, comp);
> > 
> > We can argue if clients should get this event. Once reset is detected,
> > the pds_core should close devices by deleting aux drivers.
> 
> We can get a reset signal from the device when it has done a crash recovery
> or when it is preparing to do an update, and this allows clients to quiesce
> their operations when reset.state==0 and restart when they see
> reset.state==1

I don't think that it is safe behaviour from user POV. If FW resets
itself under the hood, how can client be sure that nothing changes
in its operation? Once FW reset occurs, it is much safer for the clients
to reconfigure everything.

Thanks
