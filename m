Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BB346465F6
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 01:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229818AbiLHAhG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 19:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiLHAg4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 19:36:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1978DBC1
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 16:36:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00B98B8219B
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 00:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2E10C4347C;
        Thu,  8 Dec 2022 00:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670459812;
        bh=k1Fybp5fS5DMy0xXFPou7hNBl89BwJFXjDzF0GOvFQA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=upcPqTnGiuz+CGlkcmGG788sY0lWsoXZQpY8MD2QtZeHDxl693+1DXCG/x9jXAioj
         hzU0OTjA0xQ6yM6PjP4yMP8I7kQ+on7tZp2aKm7Fty70S7YKe2irg9jlFhHWb7Dwga
         ZSjNY/7V7p/kEmRJjmpcW8x16D0yMZNehGl3hEYtgE9VKrtALGQtqIX5m9lMRvFXvL
         ARL5eYWL11BdaOiFZRrjME9C2xM/Hm4wpyi6dsDsSqGaZZm3KNmQ3tiJzcWVWhmMCW
         p0Y+xjXCmqunSdxry0WGnlTiwfB9Ufj3HD5J8DrgoTDCIikV8UYIAm1A9a9YS7rpRu
         g47tDEy/2ERRA==
Date:   Wed, 7 Dec 2022 16:36:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <shannon.nelson@amd.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@nvidia.com
Subject: Re: [PATCH net-next 1/2] devlink: add fw bank select parameter
Message-ID: <20221207163651.37ff316a@kernel.org>
In-Reply-To: <7206bdc8-8d45-5e2d-f84d-d741deb6073e@amd.com>
References: <20221205172627.44943-1-shannon.nelson@amd.com>
        <20221205172627.44943-2-shannon.nelson@amd.com>
        <20221206174136.19af0e7e@kernel.org>
        <7206bdc8-8d45-5e2d-f84d-d741deb6073e@amd.com>
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

On Wed, 7 Dec 2022 11:29:58 -0800 Shannon Nelson wrote:
> On 12/6/22 5:41 PM, Jakub Kicinski wrote:
>  > On Mon, 5 Dec 2022 09:26:26 -0800 Shannon Nelson wrote:  
>  >> Some devices have multiple memory banks that can be used to
>  >> hold various firmware versions that can be chosen for booting.
>  >> This can be used in addition to or along with the FW_LOAD_POLICY
>  >> parameter, depending on the capabilities of the particular
>  >> device.
>  >>
>  >> This is a parameter suggested by Jake in
>  >>   
> https://lore.kernel.org/netdev/CO1PR11MB508942BE965E63893DE9B86AD6129@CO1PR11MB5089.namprd11.prod.outlook.com/
>  >
>  > Can we make this netlink attributes?  
> To be sure, you are talking about defining new values in enum 
> devlink_attr, right?  Perhaps something like
>      DEVLINK_ATTR_INFO_VERSION_BANK   /* u32 */
> to go along with _VERSION_NAME and _VERSION_VALUE for each item under 
> running and stored?

Yes.

> Does u32 make sense here or should it be a string?

I'd go with u32, I don't think the banks could have any special meaning?
That'd need to be communicated? If so we can add that as a separate
mapping later (so it doesn't have to be repeated for each version).

> Or do we really need another value here, perhaps we should use the 
> existing _VERSION_NAME to display the bank?  This is what is essentially 
> happening in the current ionic and this proposed pds_core output, but 
> without the concept of bank numbers:
>        running:
>          fw 1.58.0-6
>        stored:
>          fw.goldfw 1.51.0-3
>          fw.mainfwa 1.58.0-6
>          fw.mainfwb 1.56.0-47-24-g651edb94cbe

To a human that makes sense but standardizing this naming scheme cross
vendors, and parsing this in code will be much harder than adding the
attr, IMO.

> With (optional?) bank numbers, it might look like
>        running:
>          1 fw 1.58.0-6
>        stored:
>          0 fw.goldfw 1.51.0-3
>          1 fw.mainfwa 1.58.0-6
>          2 fw.mainfwb 1.56.0-47-24-g651edb94cbe
> 
> Is this reasonable?

Well, the point of the multiple versions was that vendors can expose
components. Let's take the simplest example of management FW vs option
rom/UNDI:

	stored:
	  fw		1.2.3
	  fw.bundle	March 123
	  fw.undi	0.5.6

What I had in mind was to add bank'ed sections:

	stored (bank 0, active, current):
	  fw		1.2.3
	  fw.bundle	March 123
	  fw.undi	0.5.6
	stored (bank 1):
	  fw		1.4.0
	  fw.bundle	May 123
	  fw.undi	0.6.0

>  > What is the flow that you have in mind end to end (user actions)?
>  > I think we should document that, by which I mean extend the pseudo
>  > code here:
>  >
>  >   
> https://docs.kernel.org/next/networking/devlink/devlink-flash.html#firmware-version-management
>  >
>  > I expect we need to define the behavior such that the user can ignore
>  > the banks by default and get the right behavior.
>  >
>  > Let's define
>  >   - current bank - the bank from which the currently running image has
>  >     been loaded  
> I'm not sure this is any more information than what we already have as 
> "running" if we add the bank prefix.

Running is what's running, current let's you decide where the next
image will be flash. We can render "next" in the CLI if that's more
intuitive.

>  >   - active bank - the bank selected for next boot  
> Can there be multiple active banks?  I can imagine a device that has FW 
> partitioned into multiple banks, and brings in a small set of them for a 
> full runtime.

I'm not aware of any such cases, but can't prove they don't exist :S

>  >   - next bank - current bank + 1 mod count  
> Next bank for what? 

Flashing, basically.

> This seems easy to confuse between next bank to 
> boot and next bank to flash.  Is this something that needs to be 
> displayed to the user?

It's gonna decide which bank is getting overwrite.
I was just defining the terms for the benefit of the description below,
not much thought went into them. We can put flash-next or write-target
or whatever seems most obvious in CLI.

>  > If we want to keep backward compat - if no bank specified for flashing:
>  >   - we flash to "next bank"
>  >   - if flashing is successful we switch "active bank" to "next bank"
>  > not that multiple flashing operations without activation/reboot will
>  > result in overwriting the same "next bank" preventing us from flashing
>  > multiple banks without trying if they work..  
> I think this is a nice guideline, but I'm not sure all physical devices 
> will work this way.

Shouldn't it be entirely in SW control? (possibly "FW" category of SW)

I think this is important to get right. Once automation gets unleashed
on many machines, rare conditions and endless loops inevitably happen.
The update of stored flash can happen without taking the machine
offline to lower the downtime. If the update daemon runs at a 15min
interval we can write the flash 100 times a day, easily.

>  > "stored" versions in devlink info display the versions for "active bank"
>  > while running display running (i.e. in RAM, not in the banks!)>
>  > In terms of modifications to the algo in documentation:
>  >   - the check for "stored" versions check should be changed to an while
>  >     loop that iterates over all banks
>  >   - flashing can actually depend on the defaults as described above so
>  >     no change
>  >
>  > We can expose the "current" and "active" bank as netlink attrs in dev
>  > info.  
> How about a new info item
>      DEVLINK_ATTR_INFO_ACTIVE_BANK
> which would need a new api function something like
>      devlink_info_active_bank_put()

Yes, definitely. But I think the next-to-write is also needed, because
we will need to use the next-to-write bank to populate the JSON for
stored FW to keep backward compat.

In CLI we can be more loose but the algo in the docs must work and not
risk overwriting all the banks if machine gets multiple update cycles
before getting drained.

> Again, with the existing "running" attribute, maybe we don't need to add 
> a "current"?

Normal NICs have FW on the flash and FW in the RAM. The one in the RAM
is running, the one in the flash is stored. The stored can be updated
back, forth and nothing happens until reboot (or explicit activation
/reset). There is no service impact of updating the stored live.

Also note that running is a category not a version. With the components
I gave above running would be:

	  fw		1.2.3
	  fw.bundle	March 123
	  fw.undi	0.5.6

So all those versions are running...

Current (in my WIP nomenclature) was just to identify the bank that
running was loaded from. But bank is a single u32, and running versions
can be multiple and arbitrary strings.
