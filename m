Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 776B8681710
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 17:59:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236531AbjA3Q7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 11:59:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbjA3Q7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 11:59:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DDE3F2B2;
        Mon, 30 Jan 2023 08:59:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F76FB81240;
        Mon, 30 Jan 2023 16:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E40EC433EF;
        Mon, 30 Jan 2023 16:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675097953;
        bh=TEmP3Vf+1ys1XnL6zZZPlJEDD1EREssa1UfjKey0QKs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vrw8qQFUCh+fcTCikMKNUdd5mFjLT16oJV8HLvj5lJgArQEwc0P7/tnjmOZoqEztE
         303uyv7poK0HTdWamkyN12Qn4l5/1JWrzUxl8vzjmo+vs+P2abutwREX6tjsnZLSop
         VDB3ondM+bEzei7zzN4oeq3iwF0ciesk6O3MOhLjkCPTuZrXAEgCmv6UHo1pLNoxiU
         A7U0u9+F0nJ2H9yW4uJfwmET3XgA8Pfuu0VBDY5ic00m0DlPry/vQ46+seOyCfjIUY
         NsgOXwpmgvdspFwChpjqMjgvolvFczQiT9K4fmKn1tMLmd053B8vrlMqoraajRLh02
         NdYqzNZq99hrQ==
Date:   Mon, 30 Jan 2023 17:59:05 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH net-next v4 4/4] net: ethernet: renesas: rswitch: Add
 phy_power_{on,off}() calling
Message-ID: <20230130175905.7d77781d@thinkpad>
In-Reply-To: <Y9f0wm1sV6B1/ymC@shell.armlinux.org.uk>
References: <20230127142621.1761278-1-yoshihiro.shimoda.uh@renesas.com>
        <20230127142621.1761278-5-yoshihiro.shimoda.uh@renesas.com>
        <Y9PrDPPbtIClVtB4@shell.armlinux.org.uk>
        <TYBPR01MB534129FDE16A6DB654486671D8D39@TYBPR01MB5341.jpnprd01.prod.outlook.com>
        <Y9e05RJWrzFO7z4T@shell.armlinux.org.uk>
        <20230130173048.520f3f3e@thinkpad>
        <Y9f0wm1sV6B1/ymC@shell.armlinux.org.uk>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.35; x86_64-pc-linux-gnu)
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

On Mon, 30 Jan 2023 16:48:02 +0000
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> On Mon, Jan 30, 2023 at 05:30:48PM +0100, Marek Beh=C3=BAn wrote:
> > But rswitch already uses phylink, so should Yoshihiro convert it whole
> > back to phylib? (I am not sure how much phylink API is used, maybe it
> > can stay that way and the new phylib function as proposed in Yoshihiro's
> > previous proposal can just be added.) =20
>=20
> In terms of "how much phylink API is used"... well, all the phylink
> ops functions are currently entirely empty. So, phylink in this case
> is just being nothing more than a shim between the driver and the
> corresponding phylib functions.
>=20

Yoshihiro, sorry for this. If not for my complaints, your proposal could
already be merged (maybe). Anyway, I think the best solution would be
to implement phylink properly, even for cases that are not relevant for
your board*, but this would take a non-trivial amount of time, so
I will understand if you want to stick with phylib.

* Altough you don't use fixed-link or SFP on your board, I think it
  should be possible to test it somehow if you implemented it...
  For example, I have tested fixed-link between SOC and switch SerDes
  by configuring it in device-tree on both sides.

Marek
