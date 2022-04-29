Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449E15153EB
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 20:45:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378653AbiD2StE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 14:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380129AbiD2Ss7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 14:48:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 466538BE39
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 11:45:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1129B8376E
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 18:45:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B3BC385A7;
        Fri, 29 Apr 2022 18:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651257937;
        bh=UiD3BGhjm6mku8DGeApHhb8T8FV3LjuZcs5nJ2oVkFA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VG3HPrdxy780JL4pQTzyd0M0vGA+5gpp9KV03x9FFYT/usGshy46Azy02e661SxIW
         irq/Xe5gQWHf9tTWwMQm/TyvGfFz8+1018E87HbLBbqIvUutNtcmEvpjd/TkrjmNLN
         1w7a+aWgoM4Fxw8grXhc63JpRov3Q1805Ws0MIEgSXDNGpMrFNL8qubYnQ8u41EahB
         E5Lz6C7ieSJPT64EmJ0EcDHus8o+xMzHt46ghxouKrrqYq5sHjnwqVeLG3pPxzBuyx
         9VRPjt6lE7WjsffnLpl4r2mIBy7K+rAip7I9OeLvqJqm6orh3+EtTRqB5uczWEX4ui
         oCH4ayf8KaxEQ==
Date:   Fri, 29 Apr 2022 11:45:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <20220429114535.64794e94@kernel.org>
In-Reply-To: <YmvRRSFeRqufKbO/@nanopsycho>
References: <20220425034431.3161260-1-idosch@nvidia.com>
        <20220425090021.32e9a98f@kernel.org>
        <Ymb5DQonnrnIBG3c@shredder>
        <20220425125218.7caa473f@kernel.org>
        <YmeXyzumj1oTSX+x@nanopsycho>
        <20220426054130.7d997821@kernel.org>
        <Ymf66h5dMNOLun8k@nanopsycho>
        <20220426075133.53562a2e@kernel.org>
        <YmjyRgYYRU/ZaF9X@nanopsycho>
        <20220427071447.69ec3e6f@kernel.org>
        <YmvRRSFeRqufKbO/@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Apr 2022 13:51:33 +0200 Jiri Pirko wrote:
> >Of the three API levels (SDK, automation, human) I think automation
> >is the only one that's interesting to us in Linux. SDK interfaces are
> >necessarily too low level as they expose too much of internal details
> >to standardize. Humans are good with dealing with uncertainty and
> >diverse so there's no a good benchmark.
> >
> >The benchmark for automation is - can a machine use this API across
> >different vendors to reliably achieve its goals. For FW info/flashing
> >the goal is keeping the FW versions up to date. This is documented:
> >
> >https://www.kernel.org/doc/html/latest/networking/devlink/devlink-flash.html#firmware-version-management
> >
> >What would the pseudo code look like with "line cards" in the picture?
> >Apply RFC1925 truth 12.  
> 
> Something like this:
> 
> $lc_count = array_size(devlink-lc-info[$handle])
> 
> for ($lcnum = 0; $lcnum < $lc_count; lcnum++):
>     $dev_count = array_size(devlink-lc-info[$handle][$lcnum])
> 
>     for ($devnum = 0; $devnum < $dev_count; $devnum++):

Here goes the iteration I complained about in my previous message.
Tracking FW versions makes most sense at the level of a product (as 
in the unit of HW one can purchase from the system vendor). That
integrates well with system tracking HW in the fleet. Product in your
case will be a line card or populated chassis, I believe.

>         # Get unique HW design identifier (gearbox id)
>         $hw_id = devlink-lc-info[$handle][$lcnum][$devnum]['fw.psid']

1) you can't use 'fw.psid' in generic logic, it's a Melvidia's invention
2) looking at your cover letter there's no fw.psid for the device
   reported, the automation will not work, Q.E.D.

>         # Find out which FW flash we want to use for this device
>         $want_flash_vers = some-db-backed.lookup($hw_id, 'flash')
> 
>         # Update flash if necessary
>         if $want_flash_vers != devlink-lc-info[$handle][$lcnum][$devnum]['fw']:
>             $file = some-db-backed.download($hw_id, 'flash')
>             $component = devlink-lc[$handle][$lcnum][$devnum]['component']
>             devlink-dev-flash($handle, $component, $file)
> 
> devlink-reload()
> 
> Clear indexes, not squashed somewhere in middle of string.
> 
> >I thought you said your gearboxes all the the same FW? 
> >Theoretically, yes. Theoretically, I can also have nested "line cards".  
> 
> Well, yeah. I was under impresion that possibility of having multiple
> devices on the same LC is not close to 0. But I get your point.
> 
> Let's try to figure out he iface as you want it:
> We will have devlink dev info extended to be able to provide info
> about the LC/gearbox. Let's work with same prefix "lcX." for all
> info related to line card X.
> 
> First problem is, who is going to enforce this prefix. It is driver's
> responsibility to provide the string which is put out. The solution
> would be to have a helper similar to devlink_info_version_*_put()
> called devlink_info_lc_version_*_put() that would accept lc pointer and
> add the prefix. Does it make sense to you?
> 
> We need 3 things:
> 1) current version of gearbox FW 
>    That is easy, we have it - "versions"
>    (DEVLINK_ATTR_INFO_VERSION_* nested attrs). We can have multiple
>    nests that would carry the versions for individiual line cards.
>    Example:
>        versions:
>            fixed:
>              hw.revision 0
>              lc2.hw.revision a
>              lc8.hw.revision b
>            running:
>              ini.version 4
>              lc2.gearbox.fw.version 1.1.3
>              lc8.gearbox.fw.version 1.2.3
> 2) HW id (as you have it in your pseudocode), it is PSID in case of
>    mlxsw. We already have PSID for ASIC:
>    ....
>    This should be also easy, as this is exposed as "fixed version" in a
>    same way as previous example.
>    Example:
>        versions:
>            fixed:
>              lc2.gearbox.fw.psid XXX
>              lc8.gearbox.fw.psid YYY
> 3) Component name
>    This one is a bit tricky. It is not a version, so put it under
>    "versions" does not make much sense.
>    Also, there are more than one. Looking at how versions are done,
>    multiple nests of attr type DEVLINK_ATTR_INFO_VERSION_* are put to
>    the message. So we can introduce new attr DEVLINK_ATTR_INFO_FLASH_COMPONENT
>    and put one per linecard/gearbox.
>    Here arain we need some kind of helper to driver to call to put this
>    into msg: devlink_info_lc_flash_component_put()
>    Example:
>      pci/0000:01:00.0:
>        driver mlxsw_spectrum3
>        flash_components:
>          lc2.gearbox.fw
>          lc8.gearbox.fw
> 
>     Then the flashing of the gearbox will be done by:
>     # devlink dev flash pci/0000:01:00.0 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2 component lc2.gearbox.fw

The main question to me is whether users will want to flash the entire
device, or update line cards individually.

What's inside mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2? Doesn't
sound like it's FW just for a single gearbox?

> >Really? So we're going to be designing kernel APIs so that each message
> >contains complete information and can't contain references now?  
> 
> Can you give me an exapmple of devlink or any other iproute2 app cmd
> that actually does something similar to this?

Off the top of my head - doesn't ip has some caches for name resolution
etc.? Either way current code in iproute2.git is hardly written on the
stone tablets.
