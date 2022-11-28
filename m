Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B98863B148
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232665AbiK1S2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234301AbiK1S2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:28:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B77E2ED5D
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 10:20:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8359B80F93
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 18:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9F3C433C1;
        Mon, 28 Nov 2022 18:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669659644;
        bh=6NWe//DH5gMILrpdNMRZ55ZhUDROvGwx2g3+voHsX9I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EWcxEm9PfM20Nyd32H7fe+CImzYdw+lqal8skhE22P8ww4wGxOjkbRjd8m6K7kTKr
         acPxohMkVinVnEQNL0M+spQ2Y9iK2nvbImDTTggQqFFWa5jA6vabhmZeY/BRfEOQle
         z6ElYMbCV0gBhIWZ3Qu8gohrsixV1mDWMzdkhtZu4h5awc9SZ+xOxLrR1wQzzYvjEY
         OAa/afslVs+rDnMOmffJkoaCn93kwKenvWg8O1B88hxTc/8KYV1qaboY86uZS5cxFI
         R8HOZAZOKut6ZrVmz/oDoMFNg5bq3eJbCMmpPK50/8MvTnHxZEoZfWfkHuOmOU03gv
         vmLiJZieuqoUA==
Date:   Mon, 28 Nov 2022 10:20:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <20221128102043.35c1b9c1@kernel.org>
In-Reply-To: <Y4SGYr6VBkIMTEpj@nanopsycho>
References: <Y3zdaX1I0Y8rdSLn@unreal>
        <e311b567-8130-15de-8dbb-06878339c523@huawei.com>
        <Y30dPRzO045Od2FA@unreal>
        <20221122122740.4b10d67d@kernel.org>
        <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
        <Y33OpMvLcAcnJ1oj@unreal>
        <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com>
        <Y35x9oawn/i+nuV3@shredder>
        <20221123181800.1e41e8c8@kernel.org>
        <Y4R9dT4QXgybUzdO@shredder>
        <Y4SGYr6VBkIMTEpj@nanopsycho>
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

On Mon, 28 Nov 2022 10:58:58 +0100 Jiri Pirko wrote:
> >Long term, we either need to find a way to make the ethtool compat stuff
> >work correctly or just get rid of it and have affected drivers implement
> >the relevant ethtool operations instead of relying on devlink.
> >
> >[1] https://lore.kernel.org/netdev/20221122121048.776643-1-yangyingliang@huawei.com/  
> 
> I just had a call with Ido. We both think that this might be a good
> solution for -net to avoid the use after free.
> 
> For net-next, we eventually should change driver init flows to register
> devlink instance first and only after that register devlink_port and
> related netdevice. The ordering is important for the userspace app. For
> example the init flow:
> <- RTnetlink new netdev event
> app sees devlink_port handle in IFLA_DEVLINK_PORT
> -> query devlink instance using this handle  
> <- ENODEV
> 
> The instance is not registered yet.
> 
> So we need to make sure all devlink_port_register() calls are happening
> after devlink_register(). This is aligned with the original flow before
> devlink_register() was moved by Leon. Also it is aligned with devlink
> reload and devlink port split flows.

Cool. Do you also agree with doing proper refcounting for the devlink
instance struct and the liveness check after locking the instance?
