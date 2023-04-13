Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F87E6E10C0
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 17:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230281AbjDMPOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 11:14:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbjDMPON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 11:14:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 734DC10DF
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 08:14:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00EEF63F7B
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 15:14:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1F7C433EF;
        Thu, 13 Apr 2023 15:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681398851;
        bh=ybJRimPAdUQckJuZ6pbl8y/kCLMHeMwv2A4DjLg9n6Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=N+iw5ZNluSPJVSuuGyhExcH6hDlObv83wUYrh2cmYrpLziJeTas/Lbf4CbOuLSiYM
         YGTMRezwEhshoK4/e4b5ozGLrUFQdDMehxdeJiBv0xNlctmWjk92SXB3vns8LJvqPi
         XFL0mNQ/x0/QODHaz8yQNu9y5RDnno/5IQbAGmRIUpLIgo2zlk+kxu9888Cy8QOPRY
         uUK1kQIscG8wbdEkJzYaBH3Xa5TvISH4fR9SkQSaM0ImPnny3p7OY11ZqYSxsvCOrw
         uKsqIdQKrspDxLN3eA5uk20VRstq+Q9Q62AguKj0iHAHoLruOot4L6mFv3eWeb/y59
         ZXAzX+qmypTVw==
Date:   Thu, 13 Apr 2023 08:14:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Shannon Nelson <shannon.nelson@amd.com>, brett.creeley@amd.com,
        davem@davemloft.net, netdev@vger.kernel.org, drivers@pensando.io,
        jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 13/14] pds_core: publish events to the
 clients
Message-ID: <20230413081410.2cbaf2a2@kernel.org>
In-Reply-To: <20230413085501.GH17993@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
        <20230406234143.11318-14-shannon.nelson@amd.com>
        <20230409171143.GH182481@unreal>
        <f5fbc5c7-2329-93e6-044d-7b70d96530be@amd.com>
        <20230413085501.GH17993@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Apr 2023 11:55:01 +0300 Leon Romanovsky wrote:
> > > > diff --git a/drivers/net/ethernet/amd/pds_core/adminq.c b/drivers/net/ethernet/amd/pds_core/adminq.c
> > > > index 25c7dd0d37e5..bb18ac1aabab 100644
> > > > --- a/drivers/net/ethernet/amd/pds_core/adminq.c
> > > > +++ b/drivers/net/ethernet/amd/pds_core/adminq.c
> > > > @@ -27,11 +27,13 @@ static int pdsc_process_notifyq(struct pdsc_qcq *qcq)
> > > >                case PDS_EVENT_LINK_CHANGE:
> > > >                        dev_info(pdsc->dev, "NotifyQ LINK_CHANGE ecode %d eid %lld\n",
> > > >                                 ecode, eid);
> > > > +                     pdsc_notify(PDS_EVENT_LINK_CHANGE, comp);  
> > > 
> > > Aren't you "resending" standard netdev event?
> > > It will be better to send only custom, specific to pds_core events,
> > > while leaving general ones to netdev.  
> > 
> > We have no netdev in pds_core, so we have to publish this to clients that
> > might have a netdev or some other need to know.  
> 
> I don't know netdev well enough if it is ok or not and maybe netdev will
> sent this LINK_CHANGE by itself anyway.
> 
> Jakub???

I actually prefer for the driver to distribute the event via its own
means than some random borderline proprietary stuff outside of netdev
using netdev events.

> > > We can argue if clients should get this event. Once reset is detected,
> > > the pds_core should close devices by deleting aux drivers.  
> > 
> > We can get a reset signal from the device when it has done a crash recovery
> > or when it is preparing to do an update, and this allows clients to quiesce
> > their operations when reset.state==0 and restart when they see
> > reset.state==1  
> 
> I don't think that it is safe behaviour from user POV. If FW resets
> itself under the hood, how can client be sure that nothing changes
> in its operation? Once FW reset occurs, it is much safer for the clients
> to reconfigure everything.

What's the argument exactly? We do have async resets including in mlx5,
grep for enable_remote_dev_reset
