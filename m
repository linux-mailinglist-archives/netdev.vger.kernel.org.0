Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA14863DAF3
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 17:47:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiK3QrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 11:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiK3QrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 11:47:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821E110564
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 08:47:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1AE9B61D09
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 16:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108BBC433D6;
        Wed, 30 Nov 2022 16:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669826821;
        bh=z7fw7tWn4CEMq+p/CXlwiW9bAVKBtt2ONnrQQjYMStE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dsP4LIBPFxw2zul4fbA2H3sJWn0eqfWJDg2FE0t0iw8Jx14DgsnDjiPo7AGB5AD56
         LdT6fpEXYWuJHTyNgk6kf9Ok3UMC/Ot9uXOrHEyGnV9QUduxn2n7i6ezg6GeNDxiGs
         ProFjzwUNeFn5eDBj9W1M7n60T4vGUpC4HVFLKBpcRt52nTJcvlIfWrojplLkaAAZf
         7cL5mIguehMcZZ+r9uyTJYpIRnEezfMMUw9g1umrDWTFTiPoefXwWEj20ZuY8ClPQq
         PvRVZonhPEH8V2Qk/G6yKHlqLUvNwlmdwueGVq8n0TJuQ2GrIHC4fsAuLpWWN2Kv+O
         /whTwVu0q4pdA==
Date:   Wed, 30 Nov 2022 08:46:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <20221130084659.618a8d60@kernel.org>
In-Reply-To: <Y4dBrx3GTl2TLIrJ@nanopsycho>
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
        <Y4dBrx3GTl2TLIrJ@nanopsycho>
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

On Wed, 30 Nov 2022 12:42:39 +0100 Jiri Pirko wrote:
> >Look at the __devlink_free() and changes=20
> >to devlink_compat_flash_update() here:
> >
> >https://lore.kernel.org/netdev/20211030231254.2477599-3-kuba@kernel.org/=
 =20
>=20
> **)
> I see. With the change I suggest, meaning doing
> devlink_port_register/unregister() and netdev_register/unregister only
> for registered devlink instance, you don't need this at all. When you
> hit this compat callback, the netdevice is there and therefore devlink
> instance is registered for sure.

If you move devlink registration up it has to be under the instance
lock, otherwise we're back to reload problems. That implies unregister
should be under the lock too. But then we can't wait for refs in
unregister. Perhaps I don't understand the suggestion.

> >The model I had in mind (a year ago when it all started) was that=20
> >the driver takes the devlink instance lock around its entire init path,
> >including the registration of the instance. This way the devlink
> >instance is never visible "half initialized". I mean - it's "visible"
> >as in you can see a notification over netlink before init is done but
> >you can't access it until the init in the driver is completed and it
> >releases the instance lock. =20
>=20
> What is "half-initialized"? Take devlink reload flow for instance. There
> are multiple things removed/readded, like devlink_port and related
> netdevice. No problem there.

Yes, but reload is under the instance lock, so nothing can mess with=20
a device in a transitional state.

> I think that we really need to go a step back and put the
> devlink_register at the point of init flow where all things that are
> "static" during register lifetime are initialized, the rest would be
> initialized later on. This would make things aligned with
> devlink_reload() and would make possible to share init/fini/reload
> code in drivers.

Yes, I agree that the move should be done but I don't think its
sufficient.

> >For that to work and to avoid ordering issues with netdev we need to
> >allow unregistering a devlink instance before all references are gone. =
=20
>=20
> References of what? devlink instance, put by devlink_put()?

Yes.

> >So we atomically look up and take a reference on a devlink instance.
> >Then take its lock. Then under the instance lock we check if it's still
> >registered. =20
>=20
> As mentioned above (**), I don't think this is needed.

But it is, please just let me do it and make the bugs stop =F0=9F=98=AD
