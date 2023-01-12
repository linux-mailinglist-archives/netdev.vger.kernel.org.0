Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7966B66841E
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 21:40:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239903AbjALUkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 15:40:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbjALUjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 15:39:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EBA755FC
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 12:10:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D1FEB81E63
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 20:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EBEC433F1;
        Thu, 12 Jan 2023 20:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673554163;
        bh=HXbbtE1BU+bRzyX9Z4jq9tQpU7/4qylgKPDSCDfwKsw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mvUzqorcDGDZFA6SBb4SJHLNEvrkUh+MEbLlklqC8jAj5kdYDx1bph7wIF7ubxqnM
         0z/Ic/g6Jk1bVbQMi8BgsvKutZMWeW6f/52UT3bHgLPhztmaW+Hzh4a0OgxlFhtpJC
         oDH0IfMGKaND2HYXarzeSpzAoYQ9A6MhHV52sboTjqun2KuyPE9yHb89YxRSQ0jH7t
         hvX51wTKWtWbotDrlt14kNxv8/0u6MLyKfAykMH8SeeB49URsaAR0w/0AqG7rnKm0d
         9w6KhnMY4dNmNwFSYAQvP/MW3xVTfIhtDUhiYjA+Ru/2jhn4lTjjO/9KZqwuHXpfD3
         nmmLMnF8c7VRA==
Date:   Thu, 12 Jan 2023 22:09:18 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@resnulli.us>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters after
 the instance
Message-ID: <Y8Bo7m3zl4WhRBtW@unreal>
References: <Y7gaWTGHTwL5PIWn@nanopsycho>
 <20230106132251.29565214@kernel.org>
 <14cdb494-1823-607a-2952-3c316a9f1212@intel.com>
 <Y72T11cDw7oNwHnQ@nanopsycho>
 <20230110122222.57b0b70e@kernel.org>
 <Y76CHc18xSlcXdWJ@nanopsycho>
 <20230111084549.258b32fb@kernel.org>
 <f5d9201b-fb73-ebfe-3ad3-4172164a33f3@intel.com>
 <Y7+xv6gKaU+Horrk@unreal>
 <20230112112021.0ff88cdb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112112021.0ff88cdb@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 11:20:21AM -0800, Jakub Kicinski wrote:
> On Thu, 12 Jan 2023 09:07:43 +0200 Leon Romanovsky wrote:
> > As a user, I don't want to see any late dynamic object addition which is
> > not triggered by me explicitly. As it doesn't make any sense to add
> > various delays per-vendor/kernel in configuration scripts just because
> > not everything is ready. Users need predictability, lazy addition of
> > objects adds chaos instead.
> > 
> > Agree with Jakub, it is anti-pattern.
> 
> To be clear my preference would be to always construct the three from
> the root. Register the main instance, then sub-objects. I mean - you
> tried forcing the opposite order and it only succeeded in 90-something
> percent of cases. There's always special cases.
> 
> I don't understand your concern about user experience here. We have
> notifications for each sub-object. Plus I think drivers should hold 
> the instance lock throughout the probe routine. I don't see a scenario
> in which registering the main instance first would lead to retry/sleep
> hacks in user space, do you? I'm talking about devlink and the subobjs
> we have specifically.

The term "dynamic object addition" means for me what driver authors will
be able to add objects anytime in lifetime of the driver. I'm pretty sure
that once you allow that, we will see zoo here. Over time, you will get
everything from .probe() to workqueues. The latter caused me to write
about retry/sleep hacks.

If you success to force everyone to add objects in .probe() only, it
will be very close to what I tried to achieve.

Thanks
