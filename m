Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E89CB63BBEE
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 09:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbiK2Io7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 03:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiK2Io5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 03:44:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6A412D1C
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 00:44:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB413B811B6
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 08:44:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14D8C433C1;
        Tue, 29 Nov 2022 08:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669711493;
        bh=Ex+zaFM40udXtuDr7TNGhZ2JF9nIeDSoHJSuGx9Pb9M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=QygNV5Tp/0j0iZZNbDKwTAbhamwCHaNKUgF62zwGDxSdQOqPHuCOn/yziunnbGeTL
         Rk7mw+4t3ZJnK1nOWK9wHtoIizduVipq/XDGyC/h52mfgK5Wi2JtJ8lJFD7oZh36Ei
         x89MRyHgOUt3eAduyxsPE5kj/dxOe6Zm2EXYkkQku3ZfFP9FD3NWPFvlDS3R0WHg6v
         4/zhf6oH8qsovhXVY5cOKNPL8bWjlVOTy1/Z5tbSoinHG1W9XQtwiemCxew8KBfSz3
         BH/1pk3ltSIGe13UjEg54pfwSsXYu4pW24XYYeUmR/Poc8IvyyaD5LqqBCkT8zqzfn
         ZQTIZAZy7QyVA==
Date:   Tue, 29 Nov 2022 10:44:48 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, Jakub Kicinski <kuba@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <Y4XGgDweoWOM/Ppy@unreal>
References: <20221122122740.4b10d67d@kernel.org>
 <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
 <Y33OpMvLcAcnJ1oj@unreal>
 <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com>
 <Y35x9oawn/i+nuV3@shredder>
 <20221123181800.1e41e8c8@kernel.org>
 <Y4R9dT4QXgybUzdO@shredder>
 <Y4SGYr6VBkIMTEpj@nanopsycho>
 <Y4Sgd6fqcfL5c/vg@unreal>
 <Y4S7XENL7TgIEtPA@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4S7XENL7TgIEtPA@nanopsycho>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 02:52:00PM +0100, Jiri Pirko wrote:
> Mon, Nov 28, 2022 at 12:50:15PM CET, leon@kernel.org wrote:
> >On Mon, Nov 28, 2022 at 10:58:58AM +0100, Jiri Pirko wrote:
> >> Mon, Nov 28, 2022 at 10:20:53AM CET, idosch@idosch.org wrote:
> >> >On Wed, Nov 23, 2022 at 06:18:00PM -0800, Jakub Kicinski wrote:
> >> >> On Wed, 23 Nov 2022 21:18:14 +0200 Ido Schimmel wrote:
> >> >> > > I used the fix code proposed by Jakub, but it didn't work correctly, so
> >> >> > > I tried to correct and improve it, and need some devlink helper.
> >> >> > > 
> >> >> > > Anyway, it is a nsim problem, if we want fix this without touch devlink,
> >> >> > > I think we can add a 'registered' field in struct nsim_dev, and it can be
> >> >> > > checked in nsim_get_devlink_port() like this:  
> >> >> > 
> >> >> > I read the discussion and it's not clear to me why this is a netdevsim
> >> >> > specific problem. The fundamental problem seems to be that it is
> >> >> > possible to hold a reference on a devlink instance before it's
> >> >> > registered and that devlink_free() will free the instance regardless of
> >> >> > its current reference count because it expects devlink_unregister() to
> >> >> > block. In this case, the instance was never registered, so
> >> >> > devlink_unregister() is not called.
> >> >> > 
> >> >> > ethtool was able to get a reference on the devlink instance before it
> >> >> > was registered because netdevsim registers its netdevs before
> >> >> > registering its devlink instance. However, netdevsim is not the only one
> >> >> > doing this: funeth, ice, prestera, mlx4, mlxsw, nfp and potentially
> >> >> > others do the same thing.
> >> >> > 
> >> >> > When you think about it, it's strange that it's even possible for
> >> >> > ethtool to reach the driver when the netdev used in the request is long
> >> >> > gone, but it's not holding a reference on the netdev (it's holding a
> >> >> > reference on the devlink instance instead) and
> >> >> > devlink_compat_running_version() is called without RTNL.
> >> >> 
> >> >> Indeed. We did a bit of a flip-flop with the devlink locking rules
> >> >> and the fact that the instance is reachable before it is registered 
> >> >> is a leftover from a previous restructuring :(
> >> >> 
> >> >> Hence my preference to get rid of the ordering at the driver level 
> >> >> than to try to patch it up in the code. Dunno if that's convincing.
> >> >
> >> >I don't have a good solution, but changing all the drivers to register
> >> >their netdevs after the devlink instance is going to be quite painful
> >> >and too big for 'net'. I feel like the main motivation for this is the
> >> >ethtool compat stuff, which is not very convincing IMO. I'm quite happy
> >> >with the current flow where drivers call devlink_register() at the end
> >> >of their probe.
> >> >
> >> >Regarding a solution for the current crash, assuming we agree it's not a
> >> >netdevsim specific problem, I think the current fix [1] is OK. Note that
> >> >while it fixes the crash, it potentially creates other (less severe)
> >> >problems. After user space receives RTM_NEWLINK notification it will
> >> >need to wait for a certain period of time before issuing
> >> >'ETHTOOL_GDRVINFO' as otherwise it will not get the firmware version. I
> >> >guess it's not a big deal for drivers that only register one netdev
> >> >since they will very quickly follow with devlink_register(), but the
> >> >race window is larger for drivers that need to register many netdevs,
> >> >for either physical switch or eswitch ports.
> >> >
> >> >Long term, we either need to find a way to make the ethtool compat stuff
> >> >work correctly or just get rid of it and have affected drivers implement
> >> >the relevant ethtool operations instead of relying on devlink.
> >> >
> >> >[1] https://lore.kernel.org/netdev/20221122121048.776643-1-yangyingliang@huawei.com/
> >> 
> >> I just had a call with Ido. We both think that this might be a good
> >> solution for -net to avoid the use after free.
> >> 
> >> For net-next, we eventually should change driver init flows to register
> >> devlink instance first and only after that register devlink_port and
> >> related netdevice. The ordering is important for the userspace app. For
> >> example the init flow:
> >> <- RTnetlink new netdev event
> >> app sees devlink_port handle in IFLA_DEVLINK_PORT
> >> -> query devlink instance using this handle
> >> <- ENODEV
> >> 
> >> The instance is not registered yet.
> >
> >This is supposed to be handled by devlink_notify_register() which sends
> >"delayed" notifications after devlink_register() is called.
> >
> >Unless something is broken, the scenario above shouldn't happen.
> 
> Nope, RTnetlink message for new netdev is not handled by that. It is
> sent right away.

And why don't you fix your new commit dca56c3038c3 ("net: expose devlink port over rtnetlink")
to do not return devlink instance unless it is registered?

Why is it correct to expose devlink port with not ready to use devlink
instance?

Thanks
