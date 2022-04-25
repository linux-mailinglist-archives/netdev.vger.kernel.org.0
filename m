Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0898250E9C4
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 21:52:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245051AbiDYTz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 15:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245050AbiDYTz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 15:55:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0C242EED
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 12:52:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B1D5B81A2B
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 19:52:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B80A2C385A4;
        Mon, 25 Apr 2022 19:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650916340;
        bh=h5+2ngXlNqp6Um4QViRFYu7ZYJ8DCjBYHYjs4XJdHb4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QJcvMt+urfLTfgpENBE0A4R1NSZ8qWRTeEulwHE5BoCWHk/oxg8IwsXNfMTdyJYkY
         Cs3YrWJcfIRJ4Q6UEZAmZ5em1M48s9lI6MRDHvVEa/QMqpzOx47MrQ5Bwp/fZxrhNu
         OpmnN9a2RdXCgvCJBpDZLJlpReen+6KdjPBc4cjxYp20xLixPhv6mY6Wgf9X4XBf81
         +PqIV320yAEd7dKmq6/wsPObYNM9MBliA/phA+nnO69zsF3VwURhrHajO6CKcyXW4P
         /6IdMXBRc2fx7XyZ5/+cpm5x6xOvPzbk7Og9TKkfqrvi5dSuNDyLXvpm304/88ktCM
         JNvfN6vNxAEpA==
Date:   Mon, 25 Apr 2022 12:52:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        davem@davemloft.net, pabeni@redhat.com, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, andrew@lunn.ch,
        mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <20220425125218.7caa473f@kernel.org>
In-Reply-To: <Ymb5DQonnrnIBG3c@shredder>
References: <20220425034431.3161260-1-idosch@nvidia.com>
        <20220425090021.32e9a98f@kernel.org>
        <Ymb5DQonnrnIBG3c@shredder>
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

On Mon, 25 Apr 2022 22:39:57 +0300 Ido Schimmel wrote:
> > :/ what is a line card device? You must provide document what you're
> > doing, this:
> > 
> >  .../networking/devlink/devlink-linecard.rst   |   4 +
> > 
> > is not enough.
> > 
> > How many operations and attributes are you going to copy&paste?
> > 
> > Is linking devlink instances into a hierarchy a better approach?  
> 
> In this particular case, these devices are gearboxes. They are running
> their own firmware and we want user space to be able to query and update
> the running firmware version.

Nothing too special, then, we don't create "devices" for every
component of the system which can have a separate FW. That's where
"components" are intended to be used..

> The idea (implemented in the next patchset) is to let these devices
> expose their own "component name", which can then be plugged into the
> existing flash command:
> 
>     $ devlink lc show pci/0000:01:00.0 lc 8
>     pci/0000:01:00.0:
>       lc 8 state active type 16x100G
>         supported_types:
>            16x100G
>         devices:
>           device 0 flashable true component lc8_dev0
>           device 1 flashable false
>           device 2 flashable false
>           device 3 flashable false
>     $ devlink dev flash pci/0000:01:00.0 file some_file.mfa2 component lc8_dev0

IDK if it's just me or this assumes deep knowledge of the system.
I don't understand why we need to list devices 1-3 at all. And they
don't even have names. No information is exposed. 

There are many components on any networking device, including plenty
40G-R4 -> 25G-R1 gearboxes out there.

> Registering a separate devlink instance for these devices sounds like an
> overkill to me. If you are not OK with a separate command (e.g.,
> DEVLINK_CMD_LINECARD_INFO_GET), then extending DEVLINK_CMD_INFO_GET is
> also an option. We discussed this during internal review, but felt that
> the current approach is cleaner.

I don't know what you have queued, so if you don't need a full devlink
instance (IOW line cards won't need more individual config) that's fine.
For just FW flashing you can list many devices and update the
components... no need to introduce new objects or uAPI.

> > Would you mind if I revert this?  
> 
> I can't stop you, but keep in mind that it's already late here and that
> tomorrow I'm AFK (reserve duty) and won't be able to tag it. Jiri should
> be available to continue this discussion tomorrow morning, so probably
> best to wait for his feedback.

Sure, no rush.
