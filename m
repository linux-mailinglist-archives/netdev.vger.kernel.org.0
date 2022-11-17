Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A288E62D635
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239516AbiKQJOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239378AbiKQJOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:14:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17A35419AE;
        Thu, 17 Nov 2022 01:14:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65E1DB81D87;
        Thu, 17 Nov 2022 09:14:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA83C433C1;
        Thu, 17 Nov 2022 09:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668676485;
        bh=uGXucozYbw22itzsE0wlz1O95Zfv9rFrz9VjCU7noRc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=B4lb3rtggfNZ+9amFQU25tWBVXZqnoO4ZhJx9cz/cLvlJxGhq48bwm/b1SNRxuwUz
         RQNwx4llUMRVnnploo7+VOy9yC8TJ29I9Bu8CmrdU+o0X0Clmx8LdAAo5RRmK0+Gsu
         9yabD0egnPj/gq04enlm7g+ejgcaDdLpZYxfZ2D2YLMhBu9w/Cz26XboDPZrUJfBFd
         xKvnSkVUzAu6i8nPlnQwGrSi3QJhxgc6nONge7OcXCPfKfQSc+978wPRHl62YRX4bv
         QGG4CiUt9Mv+JAw5JcXlK5lAhBJQqsONFufjHkZuxf79dgyVl85O7yf3pc3cg+F5b9
         ZdCZS6QvllNyw==
Date:   Thu, 17 Nov 2022 11:14:41 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Dan Carpenter <error27@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: Re: [PATCH] net: ethernet: renesas: rswitch: Fix MAC address info
Message-ID: <Y3X7gWCP3h6OQb47@unreal>
References: <20221115235519.679115-1-yoshihiro.shimoda.uh@renesas.com>
 <Y3XQBYdEG5EQFgQ+@unreal>
 <TYBPR01MB5341160928F54EF8A4814240D8069@TYBPR01MB5341.jpnprd01.prod.outlook.com>
 <CAMuHMdVZDNu7drDS618XG45ua7uASMkMgs0fRzZWv05BH_p_5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdVZDNu7drDS618XG45ua7uASMkMgs0fRzZWv05BH_p_5g@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 09:59:55AM +0100, Geert Uytterhoeven wrote:
> Hi Shimoda-san,
> 
> On Thu, Nov 17, 2022 at 9:58 AM Yoshihiro Shimoda
> <yoshihiro.shimoda.uh@renesas.com> wrote:
> > > From: Leon Romanovsky, Sent: Thursday, November 17, 2022 3:09 PM
> > > On Wed, Nov 16, 2022 at 08:55:19AM +0900, Yoshihiro Shimoda wrote:
> > > > Smatch detected the following warning.
> > > >
> > > >     drivers/net/ethernet/renesas/rswitch.c:1717 rswitch_init() warn:
> > > >     '%pM' cannot be followed by 'n'
> > > >
> > > > The 'n' should be '\n'.
> > > >
> > > > Reported-by: Dan Carpenter <error27@gmail.com>
> > > > Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > > > Fixes: 3590918b5d07 ("net: ethernet: renesas: Add support for "Ethernet Switch"")
> > > > Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
> > > > ---
> > > >  drivers/net/ethernet/renesas/rswitch.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
> > > > index f3d27aef1286..51ce5c26631b 100644
> > > > --- a/drivers/net/ethernet/renesas/rswitch.c
> > > > +++ b/drivers/net/ethernet/renesas/rswitch.c
> > > > @@ -1714,7 +1714,7 @@ static int rswitch_init(struct rswitch_private *priv)
> > > >     }
> > > >
> > > >     for (i = 0; i < RSWITCH_NUM_PORTS; i++)
> > > > -           netdev_info(priv->rdev[i]->ndev, "MAC address %pMn",
> > > > +           netdev_info(priv->rdev[i]->ndev, "MAC address %pM\n",
> > >
> > > You can safely drop '\n' from here. It is not needed while printing one
> > > line.
> >
> > Oh, I didn't know that. I'll remove '\n' from here on v2 patch.
> 
> Please don't remove it.  The convention is to have the newlines.

Can you please explain why?

Thanks

> 
> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
