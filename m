Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9714F63709D
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 03:47:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbiKXCro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 21:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiKXCrm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 21:47:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA34E0A4
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 18:47:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F055061B89
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 02:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA0BEC433C1;
        Thu, 24 Nov 2022 02:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669258060;
        bh=3ATpU8gWJcAA/mOvZ/cFdjwaaZClcDzYbKNBZ9vRjtc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NeJ3rWL5XykabDIr3W8Mv9atzzNxn5KfEGt/7+z7J9i4elicEGHOaJD9fZizCUAz4
         rboTwceSfkpEBf6X8cKuVUGUpRv5rzK5kZI0RuQF3Q/u12PlNNwqXn3BROyT6ac1sr
         /T+bH6UvD71yQJnV2jOMVpxCW3l1C6BMnYdQF1JHytMnPbMipkUGdraDniHOUylBgK
         zROJI72BITCx99qhsHyw0tk8eMJhtWELbe5Z4kyklppjEteE1qISNZXgPUzkyx/j3v
         hly6q7egjPCkHDmMZ1IWme98ndXTfO8MCyM6euDFsf8h6gzmAfaXBCpqZlc3qQouSS
         53Hk0xCQfnWFA==
Date:   Wed, 23 Nov 2022 18:47:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     Leon Romanovsky <leon@kernel.org>, <netdev@vger.kernel.org>,
        <jiri@nvidia.com>, <davem@davemloft.net>, <edumazet@google.com>,
        <pabeni@redhat.com>
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <20221123184738.29718806@kernel.org>
In-Reply-To: <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
References: <20221122121048.776643-1-yangyingliang@huawei.com>
        <Y3zdaX1I0Y8rdSLn@unreal>
        <e311b567-8130-15de-8dbb-06878339c523@huawei.com>
        <Y30dPRzO045Od2FA@unreal>
        <20221122122740.4b10d67d@kernel.org>
        <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
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

On Wed, 23 Nov 2022 14:40:24 +0800 Yang Yingliang wrote:
> > +err_dl_unregister:
> > +	devl_unregister(devlink); =20
> It races with dev_ethtool():
> dev_ethtool
>  =C2=A0 devlink_try_get()
>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=
=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=
=C2=A0 nsim_drv_probe
>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=
=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=
=C2=A0 devl_lock()
>  =C2=A0=C2=A0=C2=A0 devl_lock()
>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=
=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=
=C2=A0 devlink_unregister()
>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=
=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 devlink_put()
>  =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=
=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 wait_for_completion() <- the refcount=20
> is got in dev_ethtool, it causes ABBA deadlock

Yeah.. so my original design for the locking had a "devlink_is_alive()"
check for this exact reason:

https://lore.kernel.org/netdev/20211030231254.2477599-3-kuba@kernel.org/

and the devlink structure was properly refcounted (devlink_put() calls
devlink_free() when the last reference is released).

Pure references then need to check if the instance is still alive
after locking it. Which is fine, it should only happen in core code.

I think we should go back to that idea.

The waiting for references is a nightmare in the netdev code.

