Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D988B647B31
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 02:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiLIBPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 20:15:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiLIBPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 20:15:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3B61A238
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 17:15:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07FCF620E5
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 01:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31727C433F1;
        Fri,  9 Dec 2022 01:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670548541;
        bh=EDVdEPegHWbdO848AgbuDetcpVZU177PIIp4o3rxFvg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WygKUhyiByalzF6cjgMx07ApZ3rx+k8O2QUqyFFEgt/TCIOzMn3xKbRXlc7KoD/bH
         XvBUegAkzetgBmB5k0lif7mA8RLFlvL6kknIPo5c8clzvZTrilxGIb8G7mQIQY2zZl
         s8aQOXxmbB3oNEWFCeEZ1JCGQV70bYccF+7Ru5qfBobRzlBSK+totbAQxE10Ki/Hq3
         DPEGXVNta4uLNVgNyLZiuD19GNuwwzaHdvTDXDmkNswtcXi9XjeT5Tj02chVB2ATjj
         IRd9HiLrUgU8iWOfTovlNvg68SjudF7VZt9oElz8MBZBWefC0Ip8sO/SxvZb7/QQLi
         Nt6gnZAyfb0pA==
Date:   Thu, 8 Dec 2022 17:15:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com
Subject: Re: [PATCH net-next 1/2] devlink: add fw bank select parameter
Message-ID: <20221208171540.17f26cdb@kernel.org>
In-Reply-To: <06865416-5094-e34f-d031-fa7d8b96ed9b@amd.com>
References: <20221205172627.44943-1-shannon.nelson@amd.com>
        <20221205172627.44943-2-shannon.nelson@amd.com>
        <20221206174136.19af0e7e@kernel.org>
        <7206bdc8-8d45-5e2d-f84d-d741deb6073e@amd.com>
        <20221207163651.37ff316a@kernel.org>
        <06865416-5094-e34f-d031-fa7d8b96ed9b@amd.com>
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

On Thu, 8 Dec 2022 10:44:50 -0800 Shannon Nelson wrote:
> >> I think this is a nice guideline, but I'm not sure all physical devices
> >> will work this way.  
> > 
> > Shouldn't it be entirely in SW control? (possibly "FW" category of SW)  
> 
> Sadly, not all HW/FW works the way driver writers would like, nor gives 
> us all the features options we want.  Especially that FW that was built 
> before we driver writers had an opinion about how this should work.
> 
> My comment here mainly is that we need to be able to manage the older FW 
> as well as the newer, and be able to make allowances for FW that doesn't 
> play along as well.

How do we steer new folks towards this design, tho? 

The only idea I have would break backward compat for you - we keep what
I described as default, and for devices which can't do that we require
sort of a manual opt out, for example user must request "don't set to
active" if the driver can't auto-change the active. And explicitly
select the bank if the driver can't provide the stable next-flash
semantics?

IDK what exact pieces of info you're working with and how much of the
semantics you can "fake" in the driver?

> >> How about a new info item
> >>       DEVLINK_ATTR_INFO_ACTIVE_BANK
> >> which would need a new api function something like
> >>       devlink_info_active_bank_put()  
> > 
> > Yes, definitely. But I think the next-to-write is also needed, because
> > we will need to use the next-to-write bank to populate the JSON for
> > stored FW to keep backward compat.
> > 
> > In CLI we can be more loose but the algo in the docs must work and not
> > risk overwriting all the banks if machine gets multiple update cycles
> > before getting drained.  
> 
> If we are going to have multiple "stored" (banks) sections, then we need 
> an api that allows for signifying which stored section are we adding a 
> fw version to, and to be able to add the "active" and "flash-target" and 
> whatever other attributes can get added onto the stored bank.
> 
> One option is to assume a bank context gets set by a call to something 
> like devlink_info_stored_bank_put(), and add a bitmask of attributes 
> (ACTIVE, FLASH_TARGET, CURRENT, ...) that can be added to in the future 
> as needed.
>      int devlink_info_stored_bank_put(struct devlink_info_req *req,
>                                       uint bank_id,
>                                       u32 option_mask)

Yup, that's an option. Dunno if the mask is easier to use than just
separate call per attribute, but I guess you'll be the one to test
this API so you'll find out :)

At the netlink level we'd have a separate nla for active, target,
current banks, so no masks there.. right?
