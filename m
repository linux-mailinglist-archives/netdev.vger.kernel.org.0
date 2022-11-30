Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 829B063CD3B
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 03:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiK3CSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 21:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiK3CSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 21:18:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1465217D
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 18:18:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65667B819D3
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 02:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8726C433D6;
        Wed, 30 Nov 2022 02:18:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669774708;
        bh=R/wFzrd5gpVHGaGRLOmOv9pmUGhhrJYLszCRqPW//SY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l+N3hYEnsZ4rFKCzz15YUDv6doUqthK85qoesI10goe/eqNMWuetrdqIz4fzxUnaJ
         /ZVYQ1It1/Y4YTpxoBmA3DdDqnRD65rqW5vsdwitWTStdx9hOmnXcd8TFl1eXENLHl
         oqiy4Fv64qakCtZopkKvEjcBgC+kuBmwVweB9SYB5/JKX4NSj06J3IVq7UMyj8qdOU
         5KGtmUhFmcqboDh+J76Xhn9nep1tRXxrhr2r3PTHrSlXiPySNVjutJFQ9YFijRa1u0
         YV7zNeu+PqrkcI58COcfAWZF4FVmHqtpHdJVPWOj3ap4nwothe+50DF8eStnz16Lds
         PjlLwQPGEd58g==
Date:   Tue, 29 Nov 2022 18:18:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <20221129181826.79cef64c@kernel.org>
In-Reply-To: <Y4XDbEWmLRE3D1Bx@nanopsycho>
References: <Y30dPRzO045Od2FA@unreal>
        <20221122122740.4b10d67d@kernel.org>
        <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
        <Y33OpMvLcAcnJ1oj@unreal>
        <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com>
        <Y35x9oawn/i+nuV3@shredder>
        <20221123181800.1e41e8c8@kernel.org>
        <Y4R9dT4QXgybUzdO@shredder>
        <Y4SGYr6VBkIMTEpj@nanopsycho>
        <20221128102043.35c1b9c1@kernel.org>
        <Y4XDbEWmLRE3D1Bx@nanopsycho>
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

On Tue, 29 Nov 2022 09:31:40 +0100 Jiri Pirko wrote:
> >Cool. Do you also agree with doing proper refcounting for the devlink
> >instance struct and the liveness check after locking the instance?  
> 
> Could you elaborate a bit more? I missed that in the thread and can't
> find it. Why do we need it?

Look at the __devlink_free() and changes 
to devlink_compat_flash_update() here:

https://lore.kernel.org/netdev/20211030231254.2477599-3-kuba@kernel.org/

The model I had in mind (a year ago when it all started) was that 
the driver takes the devlink instance lock around its entire init path,
including the registration of the instance. This way the devlink
instance is never visible "half initialized". I mean - it's "visible"
as in you can see a notification over netlink before init is done but
you can't access it until the init in the driver is completed and it
releases the instance lock.

For that to work and to avoid ordering issues with netdev we need to
allow unregistering a devlink instance before all references are gone.

So we atomically look up and take a reference on a devlink instance.
Then take its lock. Then under the instance lock we check if it's still
registered.

For devlink core that's not a problem it's all hidden in the helpers.
