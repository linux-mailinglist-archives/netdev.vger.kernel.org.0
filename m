Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F8D637053
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 03:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbiKXCSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 21:18:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiKXCSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 21:18:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70AB827FCD
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 18:18:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E937161FB4
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 02:18:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9F70C433D6;
        Thu, 24 Nov 2022 02:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669256282;
        bh=GZIMPMgKek4U5Os1cHwN+430IT6eGX8DmRBB3EWS6LQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mBWS5M1+lyAknQvSIass0n4EPgn+5aSqVkuyyCjux9KigDaeI9uE3W9whVPzpT3p4
         c5DOTb+kk10XxFC7IcRCFjEkhBNennWKP6CK+WpSVmfZBUlwnRPjqNzSRTy/f0fhdL
         bL5h2UWArws/40zxfCV7FNjcGAX/xrQ/KOFMq6Tex5nRl6qpB4TZL0qU9ikD8qRwNp
         5cGwAv6J9FuTp/HxKxzNVIJ8efEOafXr6zkiLt6rBEGWtJRL7DfFVmTQo5D72UJk60
         qOZkd2Dy+qBkEpIWrk8bzCOX+dvFFCdqqfXZ7gmcY+W4LBAJWV0gJUOceaeYxPMAdK
         2f1CSxhXfNOJw==
Date:   Wed, 23 Nov 2022 18:18:00 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <20221123181800.1e41e8c8@kernel.org>
In-Reply-To: <Y35x9oawn/i+nuV3@shredder>
References: <20221122121048.776643-1-yangyingliang@huawei.com>
        <Y3zdaX1I0Y8rdSLn@unreal>
        <e311b567-8130-15de-8dbb-06878339c523@huawei.com>
        <Y30dPRzO045Od2FA@unreal>
        <20221122122740.4b10d67d@kernel.org>
        <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
        <Y33OpMvLcAcnJ1oj@unreal>
        <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com>
        <Y35x9oawn/i+nuV3@shredder>
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

On Wed, 23 Nov 2022 21:18:14 +0200 Ido Schimmel wrote:
> > I used the fix code proposed by Jakub, but it didn't work correctly, so
> > I tried to correct and improve it, and need some devlink helper.
> > 
> > Anyway, it is a nsim problem, if we want fix this without touch devlink,
> > I think we can add a 'registered' field in struct nsim_dev, and it can be
> > checked in nsim_get_devlink_port() like this:  
> 
> I read the discussion and it's not clear to me why this is a netdevsim
> specific problem. The fundamental problem seems to be that it is
> possible to hold a reference on a devlink instance before it's
> registered and that devlink_free() will free the instance regardless of
> its current reference count because it expects devlink_unregister() to
> block. In this case, the instance was never registered, so
> devlink_unregister() is not called.
> 
> ethtool was able to get a reference on the devlink instance before it
> was registered because netdevsim registers its netdevs before
> registering its devlink instance. However, netdevsim is not the only one
> doing this: funeth, ice, prestera, mlx4, mlxsw, nfp and potentially
> others do the same thing.
> 
> When you think about it, it's strange that it's even possible for
> ethtool to reach the driver when the netdev used in the request is long
> gone, but it's not holding a reference on the netdev (it's holding a
> reference on the devlink instance instead) and
> devlink_compat_running_version() is called without RTNL.

Indeed. We did a bit of a flip-flop with the devlink locking rules
and the fact that the instance is reachable before it is registered 
is a leftover from a previous restructuring :(

Hence my preference to get rid of the ordering at the driver level 
than to try to patch it up in the code. Dunno if that's convincing.
