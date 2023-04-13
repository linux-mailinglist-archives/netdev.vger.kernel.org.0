Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91126E1327
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 19:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjDMRHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 13:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjDMRHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 13:07:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DD961BD
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 10:07:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B03B6403F
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 17:07:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D1CC433EF;
        Thu, 13 Apr 2023 17:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681405629;
        bh=SvkkijJ+ragyWna4cvHik/S29lTKCWcHOnDlQbqH5i0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rsyY/Lh8GbIUJ57IS2WQcgMUFM+eoP/dEoJ5cKKe2ppQkhDqs78YlWb0Za6/rygcT
         8lBiwstRdzq3rLxDKnxERj5vztiN9Vmh45nRiohRvaiHsnD5+6qO7XCGyOUuaUmSmF
         lzVkDmoRjevoSFP6rLFVCUEsD35NIcIITBZHzd9PujMMmwwTI+W1KSyCqs/Ndauq4q
         1DHlJJTwR6DOfYJePqfni+u//h2RKDsRVHONqsZGoMpfbzR5ACY3oufW124Cy5hc6j
         ElVZm/R9wYUSezOd+y4k53E4W+R84+SrOlnd2/Xc8yb5BMQhS6Md5YsfMcVsT/Aip8
         UOaDBocEE/wYw==
Date:   Thu, 13 Apr 2023 20:07:04 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Shannon Nelson <shannon.nelson@amd.com>, brett.creeley@amd.com,
        davem@davemloft.net, netdev@vger.kernel.org, drivers@pensando.io,
        jiri@resnulli.us
Subject: Re: [PATCH v9 net-next 13/14] pds_core: publish events to the clients
Message-ID: <20230413170704.GV17993@unreal>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
 <20230406234143.11318-14-shannon.nelson@amd.com>
 <20230409171143.GH182481@unreal>
 <f5fbc5c7-2329-93e6-044d-7b70d96530be@amd.com>
 <20230413085501.GH17993@unreal>
 <20230413081410.2cbaf2a2@kernel.org>
 <20230413164434.GT17993@unreal>
 <20230413095509.7f15e22c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413095509.7f15e22c@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 09:55:09AM -0700, Jakub Kicinski wrote:
> On Thu, 13 Apr 2023 19:44:34 +0300 Leon Romanovsky wrote:
> > > > I don't think that it is safe behaviour from user POV. If FW resets
> > > > itself under the hood, how can client be sure that nothing changes
> > > > in its operation? Once FW reset occurs, it is much safer for the clients
> > > > to reconfigure everything.  
> > > 
> > > What's the argument exactly? We do have async resets including in mlx5,
> > > grep for enable_remote_dev_reset  
> > 
> > I think that it is different. I'm complaining that during FW reset,
> > auxiliary devices are not recreated and continue to be connected to
> > physical device with a hope that everything will continue to work from
> > kernel and FW perspective.
> > 
> > It is different from enable_remote_dev_reset, where someone externally
> > resets device which will trigger mlx5_device_rescan() routine through
> > mlx5_unload_one->mlx5_load_one sequence.
> 
> Hm, my memory may be incorrect and I didn't look at the code but 
> I thought that knob came from the "hit-less upgrade" effort.
> And for "hit-less upgrade" not respawning the devices was the whole
> point.
> 
> Which is not to disagree with you. What I'm trying to get at is that
> there are different types of reset which deserve different treatment.

I don't disagree with you either, just have a feeling that proposed
behaviour is wrong.

Thanks
