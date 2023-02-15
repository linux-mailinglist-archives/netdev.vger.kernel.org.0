Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF49669735A
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 02:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjBOBRN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 20:17:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233325AbjBOBRM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 20:17:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10B7631E29
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 17:16:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7076614AE
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 01:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF98DC433D2;
        Wed, 15 Feb 2023 01:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676423804;
        bh=dsccrIdTgPcoDTUCjpDJzq5lK6CoIHU8EEMhTPCZ44Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RL9dOkY9cb6EOf0CV7quokxJPLLZOzlX7zT0ktBkomJFE+XaoGdw2nOep/e3welPz
         Gx4erIaj7FlYxnp/Gm4gctgAX3CPo16lFYxfLF76ff+aAnxG04dbk3M320yHydQcTG
         IrekELZAuqF9lfqFKVnVJsy9/GmuEWqLvt3EQwgal28nkrSz24WUN8hk1ZzheL8qhi
         9CgYeU/rifF3DD4wYjaZo1bVTfad3r6mqaIabRojCXR3N9a9vt5474paTwSIQaSs8W
         EhlBX5gocyXDHmw4nq5AiWhA3L7gq1IeSVagDfjFQ1hJb92xOsW0kW1dTcnlelUIo2
         PCJWmqlqS/FOQ==
Date:   Tue, 14 Feb 2023 17:16:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <jiri@nvidia.com>, <idosch@idosch.org>
Subject: Re: [PATCH net-next 0/5][pull request] add v2 FW logging for ice
 driver
Message-ID: <20230214171643.10f1590f@kernel.org>
In-Reply-To: <8098982f-1488-8da2-3db1-27eecf9741ce@intel.com>
References: <20230209190702.3638688-1-anthony.l.nguyen@intel.com>
        <20230210202358.6a2e890b@kernel.org>
        <319b4a93-bdaf-e619-b7ae-2293b2df0cca@intel.com>
        <20230213164034.406c921d@kernel.org>
        <bb0d1ef5-3045-919b-adb9-017c86c862ec@intel.com>
        <6198f4e4-51ac-a71a-ba20-b452e42a7b42@intel.com>
        <20230214151910.419d72cf@kernel.org>
        <8098982f-1488-8da2-3db1-27eecf9741ce@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Feb 2023 16:07:04 -0800 Jacob Keller wrote:
> >> 2b) add some firmware logging specific knobs as a "build on top of
> >> health reporters" or by creating a separate firmware logging bit that
> >> ties into a reporter. These knows would be how to set level, etc.  
> > 
> > Right, the level setting is the part that I'm the least sure of.
> > That sounds like something more fitting to ethtool dumps.
> 
> I don't feel like this fits into ethtool at all as its not network
> specific and tying it to a netdev feels weird.

Yes, I know, all NICs are generic IO devices now. While the only
example of what can go wrong we heard so far is a link flap...

Reimplementing a similar API in devlink with a backward compat
is definitely an option.

> >> 3) for ice, once the health reporter is enabled we request the firmware
> >> to send us logging, then we get our admin queue message and simply copy
> >> this into the health reporter as a new event
> >>
> >> 4) user space is in charge of monitoring health reports and can decide
> >> how to copy events out to disk and when to delete the health reports
> >> from the kernel.  
> > 
> > That's also out of what's expected with health reporters. User should
> > not have to run vendor tools with devlink health. Decoding of the dump
> > may require vendor tools but checking if system is healthy or something
> > crashed should happen without any user space involvement.
> 
> So this wasn't about using a specific "vendor" tool, but more that
> devlink health can decide when to delete a given dump?
> 
> Ultimately we have to take the binary data and give it to a vendor
> specific tool to decode (whether I like that or not...). The information
> required to decode the messages is not something we have permission to
> share and code into the driver.
> 
> > I bet all vendors at this point have separate modules in the FW.
> > It's been the case for a while, that's why we have multiple versions
> > supported in devlink dev info.  
> 
> So one key here is that module for us refers to various sub-components
> of our main firmware, and does not tie into the devlink info modules at
> all, nor would that even make sense to us.
> 
> Its more like sections i.e.
> 
> DCB,
> MDIO,
> NVM,
> Scheduler,
> Tx queue management,
> SyncE,
> LLDP,
> Link Management,
> ...
> 
> I believe when a firmware dev adds a log message they choose an
> appropriate section and log level for when it should be reported.
> 
> This makes me think the right approach is to add a new "devlink fwlog"
> section entirely where we can define its semantics. It doesn't quite
> line up with the current intention of health reporters.
> 
> We also considered some sort of extension to devlink regions, where each
> new batch of messages from firmware would be a new snapshot.
> 
> Again this still requires some form of controls for whether to enable
> logging, how many snapshots to store, how to discard old snapshots if we
> run out of space, and what modules and log levels to enable.

Yeah, it doesn't fit into health or regions if there's no signal on 
when things go wrong. If ethtool set_dump / get_dump doesn't fit a new
command may be better.
