Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6F7F66BCD1
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 12:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjAPLZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 06:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbjAPLZS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 06:25:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FE81DB99
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 03:25:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B52DB80E59
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 11:25:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE862C433EF;
        Mon, 16 Jan 2023 11:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673868315;
        bh=EiLwQcjX0WGBq7/8/0LFZXRHhMC6vnz9O4+0U2bSa5Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q279AOnC2558QQW7vnUY0XwA1j20PRQR4mds1wxupOCAi1q0s0gmv8iM68gnT4ynp
         eKwhE+0DDfjScuzkHBy0lfQ28XJ0JvD6/iZQIr+CHkqFp9MMLUSeuaB5oRR9uU34m3
         8aR1gOgvtBzlNFRwVpugjAdkPZ0EifaPOvgzM18tNdyvjjsYoFFzWWR1um9u67rMlF
         /HraNrZiv32KIz26GcAW2fGJcNpKYNQb+7Tt6Vay5nz9FgwwatiBuRGTav9fj89xKe
         uJLEdlUUDmiaxlEAsDZHCnAxBJaVdMot4YBl9tLr6fOKGfvURuK/kgowYlL0RVo9xe
         WUlBiVGAIRx7g==
Date:   Mon, 16 Jan 2023 13:25:08 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters after
 the instance
Message-ID: <Y8U0FBgExl2FSVPZ@unreal>
References: <20230110122222.57b0b70e@kernel.org>
 <Y76CHc18xSlcXdWJ@nanopsycho>
 <20230111084549.258b32fb@kernel.org>
 <f5d9201b-fb73-ebfe-3ad3-4172164a33f3@intel.com>
 <Y7+xv6gKaU+Horrk@unreal>
 <Y8AgaVjRGgWtbq5X@nanopsycho>
 <Y8BmgpxAuqJKe8Pc@unreal>
 <Y8ENScADGSf2AUDA@nanopsycho>
 <Y8O67bd/PuxVGTFf@unreal>
 <Y8Un4cJdm/aBcIOK@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8Un4cJdm/aBcIOK@nanopsycho>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 11:33:05AM +0100, Jiri Pirko wrote:
> Sun, Jan 15, 2023 at 09:35:57AM CET, leon@kernel.org wrote:
> >On Fri, Jan 13, 2023 at 08:50:33AM +0100, Jiri Pirko wrote:
> >> Thu, Jan 12, 2023 at 08:58:58PM CET, leon@kernel.org wrote:
> >> >On Thu, Jan 12, 2023 at 03:59:53PM +0100, Jiri Pirko wrote:
> >> >> Thu, Jan 12, 2023 at 08:07:43AM CET, leon@kernel.org wrote:
> >> >> >On Wed, Jan 11, 2023 at 01:29:03PM -0800, Jacob Keller wrote:
> >> >> >> 
> >> >> >> 
> >> >> >> On 1/11/2023 8:45 AM, Jakub Kicinski wrote:
> >> >> >> > On Wed, 11 Jan 2023 10:32:13 +0100 Jiri Pirko wrote:
> >> >> >> >>>> I'm confused. You want to register objects after instance register?  
> >> >> >> >>>
> >> >> >> >>> +1, I think it's an anti-pattern.  
> >> >> >> >>
> >> >> >> >> Could you elaborate a bit please?
> >> >> >> > 
> >> >> >> > Mixing registering sub-objects before and after the instance is a bit
> >> >> >> > of an anti-pattern. Easy to introduce bugs during reload and reset /
> >> >> >> > error recovery. I thought that's what you were saying as well.
> >> >> >> 
> >> >> >> I was thinking of a case where an object is dynamic and might get added
> >> >> >> based on events occurring after the devlink was registered.
> >> >> >> 
> >> >> >> But the more I think about it the less that makes sense. What events
> >> >> >> would cause a whole subobject to be registerd which we wouldn't already
> >> >> >> know about during initialization of devlink?
> >> >> >> 
> >> >> >> We do need some dynamic support because situations like "add port" will
> >> >> >> add a port and then the ports subresources after the main devlink, but I
> >> >> >> think that is already supported well and we'd add the port sub-resources
> >> >> >> at the same time as the port.
> >> >> >> 
> >> >> >> But thinking more on this, there isn't really another good example since
> >> >> >> we'd register things like health reporters, regions, resources, etc all
> >> >> >> during initialization. Each of these sub objects may have dynamic
> >> >> >> portions (ex: region captures, health events, etc) but the need for the
> >> >> >> object should be known about during init time if its supported by the
> >> >> >> device driver.
> >> >> >
> >> >> >As a user, I don't want to see any late dynamic object addition which is
> >> >> >not triggered by me explicitly. As it doesn't make any sense to add
> >> >> >various delays per-vendor/kernel in configuration scripts just because
> >> >> >not everything is ready. Users need predictability, lazy addition of
> >> >> >objects adds chaos instead.
> >> >> >
> >> >> >Agree with Jakub, it is anti-pattern.
> >> >> 
> >> >> Yeah, but, we have reload. And during reload, instance is still
> >> >> registered yet the subobject disappear and reappear. So that would be
> >> >> inconsistent with the init/fini flow.
> >> >> 
> >> >> Perhaps during reload we should emulate complete fini/init notification
> >> >> flow to the user?
> >> >
> >> >"reload" is triggered by me explicitly and I will get success/fail result
> >> >at the end. There is no much meaning in subobject notifications during
> >> >that operation.
> >> 
> >> Definitelly not. User would trigger reload, however another entity
> >> (systemd for example) would listen to the notifications and react
> >> if necessary.
> >
> >Listen yes, however it is not clear if notification sequence should
> >mimic fini/init flow.
> 
> Well, it makes sense to me. Why do you think it should not?

After all this years, I still don't understand the mandate of devlink
reload. It doesn't load/unload driver completely and as such not really
performs probe/remove sequences. There is no requirement from the driver
to do anything even close to fini/init too. 

Sometimes, devlink reload behaves as fini/init, but not always.

This is why I'm not sure.

Thanks

> 
> >
> >Thanks
> >
> >> 
> >> >
> >> >Thanks
