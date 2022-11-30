Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FF163DBD2
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 18:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiK3RUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 12:20:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiK3RUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 12:20:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D08C3F588
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 09:20:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E6BE61D21
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 17:20:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E40C433D6;
        Wed, 30 Nov 2022 17:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669828843;
        bh=9KGpYvoGIJaa9zo/krZ2WDKO5Du8MA9N4VD2vGlYnXU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VNn989YnWvnBbrt+zxB7q+u+xCD9HUDcNzYfKZZEC2TVRMMjiDrlOPw1EvwS9WkpO
         APswB7jD4bQ0HGVZ+iaCjkUeD8UpJlNgQog1Rq418kcCR+ocPI1PclD14/MHGLgjY6
         9UK03+/BOFamLNpfJ2OmfExk84KkhpsQREaO8mUnKSPVBboYWD99ZX8fSnbYPOPzaq
         rPJdwhrAvhxaHJ4/NDl46JO9EhEpYWbDZjfa/b0GHVAbqFITPAL15EFVJWtEP/40xg
         6qhx0QEKB6qEiTp2blqlFSKseHeX+1qVHLjqDThi+FfRj9gWFumCrmVO6tecR4guM9
         +fqIsdVFL7ajA==
Date:   Wed, 30 Nov 2022 09:20:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <20221130092042.0c223a8c@kernel.org>
In-Reply-To: <Y4eMFUBWKuLLavGB@nanopsycho>
References: <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com>
        <Y35x9oawn/i+nuV3@shredder>
        <20221123181800.1e41e8c8@kernel.org>
        <Y4R9dT4QXgybUzdO@shredder>
        <Y4SGYr6VBkIMTEpj@nanopsycho>
        <20221128102043.35c1b9c1@kernel.org>
        <Y4XDbEWmLRE3D1Bx@nanopsycho>
        <20221129181826.79cef64c@kernel.org>
        <Y4dBrx3GTl2TLIrJ@nanopsycho>
        <20221130084659.618a8d60@kernel.org>
        <Y4eMFUBWKuLLavGB@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Nov 2022 18:00:05 +0100 Jiri Pirko wrote:
> Wed, Nov 30, 2022 at 05:46:59PM CET, kuba@kernel.org wrote:
> >On Wed, 30 Nov 2022 12:42:39 +0100 Jiri Pirko wrote: =20
> >> **)
> >> I see. With the change I suggest, meaning doing
> >> devlink_port_register/unregister() and netdev_register/unregister only
> >> for registered devlink instance, you don't need this at all. When you
> >> hit this compat callback, the netdevice is there and therefore devlink
> >> instance is registered for sure. =20
> >
> >If you move devlink registration up it has to be under the instance
> >lock, otherwise we're back to reload problems. That implies unregister
> >should be under the lock too. But then we can't wait for refs in
> >unregister. Perhaps I don't understand the suggestion. =20
>=20
> I unlock for register and for the rest of the init I lock again.

The moment you register that instance callbacks can start coming.
Leon move the register call last for a good reason - all drivers
we looked at had bugs in handling init.

We can come up with fixes in the drivers, flags, devlink_set_features()
and all that sort of garbage until the day we die but let's not.
The driver facing API should be simple - hold the lock around entire
init.

> >> What is "half-initialized"? Take devlink reload flow for instance. The=
re
> >> are multiple things removed/readded, like devlink_port and related
> >> netdevice. No problem there. =20
> >
> >Yes, but reload is under the instance lock, so nothing can mess with=20
> >a device in a transitional state. =20
>=20
> Sure, that is what I want to do too. To be under instance lock.

I'm confused, you just said "I unlock for register".

> >> As mentioned above (**), I don't think this is needed. =20
> >
> >But it is, please just let me do it and make the bugs stop =F0=9F=98=AD =
=20
>=20
> Why exactly is it needed? I don't see it, pardon my ignorance :)
>=20
> Let me send the RFC of the change tomorrow, you'll see what I mean.

The way I see it Leon had a stab at it, you did too, now it's my turn..
