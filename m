Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A969F668EB0
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 08:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241216AbjAMHA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 02:00:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240920AbjAMG7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 01:59:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468DC6B1A6
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 22:45:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E06C762253
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 06:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91B4C433D2;
        Fri, 13 Jan 2023 06:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673592351;
        bh=i1a6LjQ/QAOjqaAC2TTmuWaUDHNDk2SxPonHZIhPPjQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Jwby4svs9ygnXnp2e9PuXhggg5KVVZt1awyCX9CA6/JIahArwsNILnc3quysImvb/
         wjKDLk9pKmE1pBMprr4HjKv1j+ecZC/+XZsQpTThNOfSSCL0pSYVE+fxXQfAzaixi0
         wvIrmoriWf1DGD7a/Sv7bzhzQyxmDXI7az3pYtaFAdpNXE2rqK64W01n+rv+GFgj4q
         c9j/YP6UH2iqBg9NsCYmncw1t0TdVTuwW5UC1prn/YdkIA1mGwPSF4oJbWv+/sSUOn
         JVoe/vGB1clVdT6+G/bwxOmAMETIW1yBsCW3zRYJSIrJryynVUjQc3I3liqJFddKoW
         hIAAy4cUHmlQA==
Date:   Fri, 13 Jan 2023 08:45:46 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters after
 the instance
Message-ID: <Y8D+GjYZKvtstIC+@unreal>
References: <14cdb494-1823-607a-2952-3c316a9f1212@intel.com>
 <Y72T11cDw7oNwHnQ@nanopsycho>
 <20230110122222.57b0b70e@kernel.org>
 <Y76CHc18xSlcXdWJ@nanopsycho>
 <20230111084549.258b32fb@kernel.org>
 <f5d9201b-fb73-ebfe-3ad3-4172164a33f3@intel.com>
 <Y7+xv6gKaU+Horrk@unreal>
 <20230112112021.0ff88cdb@kernel.org>
 <Y8Bo7m3zl4WhRBtW@unreal>
 <c712d89c-48ca-920b-627e-93305e281a03@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c712d89c-48ca-920b-627e-93305e281a03@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 02:44:43PM -0800, Jacob Keller wrote:
> 
> 
> On 1/12/2023 12:09 PM, Leon Romanovsky wrote:
> > On Thu, Jan 12, 2023 at 11:20:21AM -0800, Jakub Kicinski wrote:
> >> On Thu, 12 Jan 2023 09:07:43 +0200 Leon Romanovsky wrote:
> >>> As a user, I don't want to see any late dynamic object addition which is
> >>> not triggered by me explicitly. As it doesn't make any sense to add
> >>> various delays per-vendor/kernel in configuration scripts just because
> >>> not everything is ready. Users need predictability, lazy addition of
> >>> objects adds chaos instead.
> >>>
> >>> Agree with Jakub, it is anti-pattern.
> >>
> >> To be clear my preference would be to always construct the three from
> >> the root. Register the main instance, then sub-objects. I mean - you
> >> tried forcing the opposite order and it only succeeded in 90-something
> >> percent of cases. There's always special cases.

Back then, we had only one special case - netdevsim. I still think that
all recent complexity that was brought to the devlink could be avoided
if we would change netdevsim to behave as HW driver (remove sysfs).

> Right. I think its easier to simply require devlink to be registered first.

devlink_register() is no more than a fancy way to say to the world: "I'm
ready to accept commands". Right now, when the need_lock flag is removed
from all devlink commands, we can place devlink_register() at any place.

> 
> >> I don't understand your concern about user experience here. We have
> >> notifications for each sub-object. Plus I think drivers should hold 
> >> the instance lock throughout the probe routine. I don't see a scenario
> >> in which registering the main instance first would lead to retry/sleep
> >> hacks in user space, do you? I'm talking about devlink and the subobjs
> >> we have specifically.
> > 
> > The term "dynamic object addition" means for me what driver authors will
> > be able to add objects anytime in lifetime of the driver. I'm pretty sure
> > that once you allow that, we will see zoo here. Over time, you will get
> > everything from .probe() to workqueues. The latter caused me to write
> > about retry/sleep hacks.
> > 
> > If you success to force everyone to add objects in .probe() only, it
> > will be very close to what I tried to achieve.
> > 
> > Thanks
> 
> Yea. I was initially thinking of something like that, but I've convinced
> myself that its a bad idea. The only "dynamic" objects (added after the
> initialization phase of devlink) should be those which are triggered via
> user space request (i.e. "devlink port add").

Exactly.

> 
> Thanks,
> Jake
