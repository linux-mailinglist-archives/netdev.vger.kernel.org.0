Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD30B63D124
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 09:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbiK3IyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 03:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbiK3IyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 03:54:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A29BA2CDD9
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 00:54:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 410F461A8E
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53AFC433D6;
        Wed, 30 Nov 2022 08:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669798450;
        bh=Rnh812aJCaInYCO4gU0JTj2P6GdiE3IXzN4sjn8AKxc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bRHNcRkycdTaHFT76h+QmKHzN4qBjNxC649+DkestTk7P1Qlssndi2ow+4hz9HDQV
         RWNTHrNWPrbHILx+0VcyFmMlljvMMtK5HkYM0I5lK6aiBjiQwI9erXgfFkn4YtcAB0
         vfGDjdQMNFTDNWe5mpfser8RGHNDZTCPCZ9ENzjKS9p2x4zVJ0ZBKDy95g1FQHwA8G
         NbepeiVXwBzdsM45/9e6rR/D1jUdgSBqdaFXVr3g1NvE3V2+YNPFskVSLgMcUZ0fUK
         vfFEJDsyjRwLstkwqcpOcmc6Ft1GiFL9dfZKmlh+a7q8XSBDxNzEhD3blUWwZsYzNw
         rM8RQ2tzlyfMQ==
Date:   Wed, 30 Nov 2022 10:54:06 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, Ido Schimmel <idosch@idosch.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <Y4caLsLEQFMgz7HV@unreal>
References: <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
 <Y33OpMvLcAcnJ1oj@unreal>
 <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com>
 <Y35x9oawn/i+nuV3@shredder>
 <20221123181800.1e41e8c8@kernel.org>
 <Y4R9dT4QXgybUzdO@shredder>
 <Y4SGYr6VBkIMTEpj@nanopsycho>
 <20221128102043.35c1b9c1@kernel.org>
 <Y4XDbEWmLRE3D1Bx@nanopsycho>
 <20221129181826.79cef64c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221129181826.79cef64c@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 29, 2022 at 06:18:26PM -0800, Jakub Kicinski wrote:
> On Tue, 29 Nov 2022 09:31:40 +0100 Jiri Pirko wrote:
> > >Cool. Do you also agree with doing proper refcounting for the devlink
> > >instance struct and the liveness check after locking the instance?  
> > 
> > Could you elaborate a bit more? I missed that in the thread and can't
> > find it. Why do we need it?
> 
> Look at the __devlink_free() and changes 
> to devlink_compat_flash_update() here:
> 
> https://lore.kernel.org/netdev/20211030231254.2477599-3-kuba@kernel.org/
> 
> The model I had in mind (a year ago when it all started) was that 
> the driver takes the devlink instance lock around its entire init path,
> including the registration of the instance. This way the devlink
> instance is never visible "half initialized". I mean - it's "visible"
> as in you can see a notification over netlink before init is done but
> you can't access it until the init in the driver is completed and it
> releases the instance lock.

In parallel thread, Jiri wanted to avoid this situation of netlink
notifications for not-visible yet object. He gave as an example
devlink_port which is advertised without devlink being ready.

Thanks
