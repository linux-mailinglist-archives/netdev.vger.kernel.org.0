Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E21C6E9A3F
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 19:05:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjDTRFH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 13:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbjDTRFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 13:05:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C52F8D2
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:05:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 663BD64AD4
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 17:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7091C4339B;
        Thu, 20 Apr 2023 17:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682010299;
        bh=bmUibaaU6qlIf/iawfDye5ptZiaHIlJVT+Yu0a3agxw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LTbcnfL3ySo3+inVR9YWadUua/JBLzKwehoFHba7i4GDKKFi6ZPdXDAgaUYHFTGjD
         MGqgAOhU2XL8KRw0IOky12tHqd/XC3m7V7OLr/DiuSo/m1bTwcH9D5ysvxel39v8XE
         OKCtRsLiyY9z4/QFDwH/A/7vMoDNZ52tPN0asuOpsj2Ufvd3m6AY1Gwa/gvopU6GBj
         Uh1cSRj+O+deIJV4aF9GWnJ6n/grCyDNY3CNbB4ZgnkS6oYpLHVCvwyO9cidkNbp62
         5wuRt+InKvMdXWjyUTbgDK6Fi6ypGhZJ1Z4ic6CZTjdDcUHO60Qv+pMsD+d9gzH7lO
         ltsvaBD5jBgMw==
Date:   Thu, 20 Apr 2023 20:04:47 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH xfrm 1/2] xfrm: release all offloaded policy memory
Message-ID: <20230420170447.GD4423@unreal>
References: <cover.1681906552.git.leon@kernel.org>
 <c84041b660cf6b0f0886488e740cd43b0f21c341.1681906552.git.leon@kernel.org>
 <CANn89i+3SDjwYb=0CAuGgUyGieCqHKso9cHCf=iSKYhV3rdi=Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANn89i+3SDjwYb=0CAuGgUyGieCqHKso9cHCf=iSKYhV3rdi=Q@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 20, 2023 at 06:51:52PM +0200, Eric Dumazet wrote:
> On Wed, Apr 19, 2023 at 2:19 PM Leon Romanovsky <leon@kernel.org> wrote:
> >
> > From: Leon Romanovsky <leonro@nvidia.com>
> >
> > Failure to add offloaded policy will cause to the following
> > error once user will try to reload driver.
> >
> > Unregister_netdevice: waiting for eth3 to become free. Usage count = 2
> >
> > This was caused by xfrm_dev_policy_add() which increments reference
> > to net_device. That reference was supposed to be decremented
> > in xfrm_dev_policy_free(). However the latter wasn't called.
> >
> >  unregister_netdevice: waiting for eth3 to become free. Usage count = 2
> >  leaked reference.
> >   xfrm_dev_policy_add+0xff/0x3d0
> >   xfrm_policy_construct+0x352/0x420
> >   xfrm_add_policy+0x179/0x320
> >   xfrm_user_rcv_msg+0x1d2/0x3d0
> >   netlink_rcv_skb+0xe0/0x210
> >   xfrm_netlink_rcv+0x45/0x50
> >   netlink_unicast+0x346/0x490
> >   netlink_sendmsg+0x3b0/0x6c0
> >   sock_sendmsg+0x73/0xc0
> >   sock_write_iter+0x13b/0x1f0
> >   vfs_write+0x528/0x5d0
> >   ksys_write+0x120/0x150
> >   do_syscall_64+0x3d/0x90
> >   entry_SYSCALL_64_after_hwframe+0x46/0xb0
> >
> > Fixes: 919e43fad516 ("xfrm: add an interface to offload policy")
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> 
> While reviewing this patch, I also saw xfrm_dev_policy_add() could use
> GFP_KERNEL ?

netdev_tracker_alloc(...) line was copied from commit e1b539bd73a7
("xfrm: add net device refcount tracker to struct xfrm_state_offload")

Thanks

> 
> diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
> index bef28c6187ebdd0cfc34c8594aab96ac0b13dd24..508c96c90b3911eb88063ad680c77af2b317c95f
> 100644
> --- a/net/xfrm/xfrm_device.c
> +++ b/net/xfrm/xfrm_device.c
> @@ -363,7 +363,7 @@ int xfrm_dev_policy_add(struct net *net, struct
> xfrm_policy *xp,
>         }
> 
>         xdo->dev = dev;
> -       netdev_tracker_alloc(dev, &xdo->dev_tracker, GFP_ATOMIC);
> +       netdev_tracker_alloc(dev, &xdo->dev_tracker, GFP_KERNEL);
>         xdo->real_dev = dev;
>         xdo->type = XFRM_DEV_OFFLOAD_PACKET;
>         switch (dir) {
