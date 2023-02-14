Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D395E6971B1
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 00:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbjBNXTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 18:19:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjBNXTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 18:19:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CE8421A13
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 15:19:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC0B6B81F53
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 23:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC82C433D2;
        Tue, 14 Feb 2023 23:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676416751;
        bh=YUOgDbTdTd+Zh+H7XAxHe0sh/o60yy4lmu/bhVY7UoI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ek4dAWsQOGkTyVTfEEnovntxmkPv7MrY9bfc4xUSy2UMT7jgAXMpDEkKj3tzTUDk6
         o5epSMLmLN+YhD4wCJQdZ/VkmvpKMYsy4Jm6iejtUlzSqRH4yMcCdJ5tkcH3y1nwjS
         k864ioaAfMIfoqlDPQQgSCo4KB16gEzs78Fzmh4uB8nzrMj5NejwAbjXlk+n0PQcRX
         TX/ocaTFjAYxZyZiE6XUA53jXIuOQhF1aw4AGSea/cRCfr4yIkRSCn8lHFOxc7Z4mN
         19nJjvaWkzC1LentBV0SzYCoa0bl0T4jpzsbp/zqyOvvbdb6+m+sMh4kfSmEimjZH6
         AZ/YjdyIjmkNg==
Date:   Tue, 14 Feb 2023 15:19:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <jiri@nvidia.com>, <idosch@idosch.org>
Subject: Re: [PATCH net-next 0/5][pull request] add v2 FW logging for ice
 driver
Message-ID: <20230214151910.419d72cf@kernel.org>
In-Reply-To: <6198f4e4-51ac-a71a-ba20-b452e42a7b42@intel.com>
References: <20230209190702.3638688-1-anthony.l.nguyen@intel.com>
        <20230210202358.6a2e890b@kernel.org>
        <319b4a93-bdaf-e619-b7ae-2293b2df0cca@intel.com>
        <20230213164034.406c921d@kernel.org>
        <bb0d1ef5-3045-919b-adb9-017c86c862ec@intel.com>
        <6198f4e4-51ac-a71a-ba20-b452e42a7b42@intel.com>
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

On Tue, 14 Feb 2023 14:39:18 -0800 Jacob Keller wrote:
> On 2/14/2023 8:14 AM, Paul M Stillwell Jr wrote:
> >> I believe that's in line with devlink health. The devlink health log
> >> is "formatted" but I really doubt that any user can get far in debugging
> >> without vendor support.
> >>  
> > 
> > I agree, I just don't see what the trigger is in our case for FW logging.
> >   
> 
> Here's the thoughts I had for devlink health:
> 
> 1) support health reporters storing more than a single event. Currently
> all health reporters respond to a single event and then do not allow
> storing new captures until the current one is processed. This breaks for
> our firmware logging because we get separate events from firmware for
> each buffer of messages. We could make this configurable such that we
> limit the total maximum to prevent kernel memory overrun. (and some
> policy for how to discard events when the buffer is full?)

I think the idea is that the system keeps a continuous ring buffer of
logs and dumps it whenever bad events happens. That's in case of logs,
obviously you can expose other types of state with health.

> 2a) add some knobs to enable/disable a health reporter

For ad-hoc collection of the ring buffer there are dump and diagnose
callbacks which can be triggered at any time.

> 2b) add some firmware logging specific knobs as a "build on top of
> health reporters" or by creating a separate firmware logging bit that
> ties into a reporter. These knows would be how to set level, etc.

Right, the level setting is the part that I'm the least sure of.
That sounds like something more fitting to ethtool dumps.

> 3) for ice, once the health reporter is enabled we request the firmware
> to send us logging, then we get our admin queue message and simply copy
> this into the health reporter as a new event
> 
> 4) user space is in charge of monitoring health reports and can decide
> how to copy events out to disk and when to delete the health reports
> from the kernel.

That's also out of what's expected with health reporters. User should
not have to run vendor tools with devlink health. Decoding of the dump
may require vendor tools but checking if system is healthy or something
crashed should happen without any user space involvement.

> Basically: extend health reporters to allow multiple captures and add a
> related module to configure firmware logging via a health reporter,
> where the "event" is just "I have a new blob to store".
> 
> How does this sound?
> 
> For the specifics of 2b) I think we can probably agree that levels is
> fairly generic (i.e. the specifics of what each level are is vendor
> specific but the fact that there are numbers and that higher or lower
> numbers means more severe is fairly standard)
> 
> I know the ice firmware has many such modules we can enable or disable
> and we would ideally be able to set which modules are active or not.
> However all messages come through in the same blobs so we can't separate
> them and report them to individual health reporter events. I think we
> could have modules as a separate option for toggling which ones are on
> or off. I would expect other vendors to have something similar or have
> no modules at all and just an on/off switch?

I bet all vendors at this point have separate modules in the FW.
It's been the case for a while, that's why we have multiple versions
supported in devlink dev info.
