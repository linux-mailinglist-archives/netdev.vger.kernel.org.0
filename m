Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14F11666B63
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 08:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236198AbjALHHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 02:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229863AbjALHHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 02:07:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36C391C43D
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 23:07:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B888B61A2A
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 07:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B860C433D2;
        Thu, 12 Jan 2023 07:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673507268;
        bh=k3qNz4dSckAGf4kUY9q2wrYxfoO5bMef01xqEociACk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tPOImOcTsIDII1Ve5+RgVVOqIDgKac/vQl6uIboHEgfNVW3iSfj3lfcm2GJCxnPFf
         UnipHqb+pznY+OwZNMXhUa48xj/CUiodgi1RzBXf7Gt9ZmJOE7i0+KF+SmZOZP2oMR
         arwDGc+3cDFDhp5BMuMVyOk2pxaoDKaCAGxrKewaxUqPWvbCXYEK58s0B8Z5Rg3lj0
         1Tp2bMVSlsB0QKlNQbzTWlHoqO9v7U/zLLr9EMGrmkGSp78nX2cF+lsB6AuYUgPy5i
         wJxpJvSQCVR0tr6XYz4Fk/BzM9e9PP8wqoeAMwZUH4OTEPDWyqnYf60ZacrNOjfAhM
         lu8Ox4W7bGkEQ==
Date:   Thu, 12 Jan 2023 09:07:43 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>,
        davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net-next 7/9] devlink: allow registering parameters after
 the instance
Message-ID: <Y7+xv6gKaU+Horrk@unreal>
References: <20230106063402.485336-1-kuba@kernel.org>
 <20230106063402.485336-8-kuba@kernel.org>
 <Y7gaWTGHTwL5PIWn@nanopsycho>
 <20230106132251.29565214@kernel.org>
 <14cdb494-1823-607a-2952-3c316a9f1212@intel.com>
 <Y72T11cDw7oNwHnQ@nanopsycho>
 <20230110122222.57b0b70e@kernel.org>
 <Y76CHc18xSlcXdWJ@nanopsycho>
 <20230111084549.258b32fb@kernel.org>
 <f5d9201b-fb73-ebfe-3ad3-4172164a33f3@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f5d9201b-fb73-ebfe-3ad3-4172164a33f3@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 01:29:03PM -0800, Jacob Keller wrote:
> 
> 
> On 1/11/2023 8:45 AM, Jakub Kicinski wrote:
> > On Wed, 11 Jan 2023 10:32:13 +0100 Jiri Pirko wrote:
> >>>> I'm confused. You want to register objects after instance register?  
> >>>
> >>> +1, I think it's an anti-pattern.  
> >>
> >> Could you elaborate a bit please?
> > 
> > Mixing registering sub-objects before and after the instance is a bit
> > of an anti-pattern. Easy to introduce bugs during reload and reset /
> > error recovery. I thought that's what you were saying as well.
> 
> I was thinking of a case where an object is dynamic and might get added
> based on events occurring after the devlink was registered.
> 
> But the more I think about it the less that makes sense. What events
> would cause a whole subobject to be registerd which we wouldn't already
> know about during initialization of devlink?
> 
> We do need some dynamic support because situations like "add port" will
> add a port and then the ports subresources after the main devlink, but I
> think that is already supported well and we'd add the port sub-resources
> at the same time as the port.
> 
> But thinking more on this, there isn't really another good example since
> we'd register things like health reporters, regions, resources, etc all
> during initialization. Each of these sub objects may have dynamic
> portions (ex: region captures, health events, etc) but the need for the
> object should be known about during init time if its supported by the
> device driver.

As a user, I don't want to see any late dynamic object addition which is
not triggered by me explicitly. As it doesn't make any sense to add
various delays per-vendor/kernel in configuration scripts just because
not everything is ready. Users need predictability, lazy addition of
objects adds chaos instead.

Agree with Jakub, it is anti-pattern.

Thanks
