Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7715A1D32
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 01:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244601AbiHYX2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 19:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244703AbiHYX17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 19:27:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01DABC88B7;
        Thu, 25 Aug 2022 16:27:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF497B82EE0;
        Thu, 25 Aug 2022 23:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A62C433D6;
        Thu, 25 Aug 2022 23:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661470026;
        bh=iwe4PDi8sqTcW4V2i+VH0pepNaqCFMSIbXg+/Qi5ZjU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FKaWhZL8HOc7T0koBNWcRQ3KqzDDdaPr90kjmTkRP2xuZRcqp+YgEahqwJgW149BL
         cjZjWxC5uyjYx5SQpDOV2IUeUeT4OK9gNjSQXRJH1UAK4dP5iT8WokAFk1JKK2ns28
         vqTE6DMphV44US2JjrwSWCpfcaFSLIzH9OTPrS70OxAmf4WAQn5AO4JDpHNRkEkhDS
         207SMODNoqiqJL6iD+cnT3IRTD5EGMx5CuYlvGevptgEVU678z2GnGtTSocY+KN6YI
         C81GVJVrmd5vTwX4ELfiYoFvsr3fkMf5vWGWDMqA5hKupic8PCtUgEb5l4kGjjr5Uz
         r+Qvi6FW4froA==
Date:   Fri, 26 Aug 2022 01:26:59 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Marcus Carlberg <marcus.carlberg@axis.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <kernel@axis.com>,
        Pavana Sharma <pavana.sharma@digi.com>,
        Ashkan Boldaji <ashkan.boldaji@digi.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] net: dsa: mv88e6xxx: support RGMII cmode
Message-ID: <20220826012659.32892fef@thinkpad>
In-Reply-To: <20220825155140.038e4d12@kernel.org>
References: <20220822144136.16627-1-marcus.carlberg@axis.com>
        <20220825123807.3a7e37b7@kernel.org>
        <20220826000605.5cff0db8@thinkpad>
        <20220825155140.038e4d12@kernel.org>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Aug 2022 15:51:40 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> On Fri, 26 Aug 2022 00:06:05 +0200 Marek Beh=C3=BAn wrote:
> > > On Mon, 22 Aug 2022 16:41:36 +0200 Marcus Carlberg wrote:   =20
> > > > Since the probe defaults all interfaces to the highest speed possib=
le
> > > > (10GBASE-X in mv88e6393x) before the phy mode configuration from the
> > > > devicetree is considered it is currently impossible to use port 0 in
> > > > RGMII mode.
> > > >=20
> > > > This change will allow RGMII modes to be configurable for port 0
> > > > enabling port 0 to be configured as RGMII as well as serial dependi=
ng
> > > > on configuration.
> > > >=20
> > > > Fixes: de776d0d316f ("net: dsa: mv88e6xxx: add support for mv88e639=
3x family")
> > > > Signed-off-by: Marcus Carlberg <marcus.carlberg@axis.com>     =20
> > >=20
> > > Seems like a new configuration which was not previously supported
> > > rather than a regression, right? If so I'll drop the Fixes tag
> > > when applying.   =20
> >=20
> > Please leave the fixes tag. This configuration should have been
> > supported from the beginning. =20
>=20
> Could you explain why? Is there an upstream-supported platform
> already in Linus's tree which doesn't boot or something?

If you mean whether there is a device-tree of such a device, they I
don't think so, because AFAIK there isn't a device-tree with 6393 in
upstream Linux other than CN9130-CRB.

But it is possible though that there is such a device which has
everything but the switch supported on older kernels, due to this RGMII
bug.

I think RGMII should have been supported on this switch when I send the
patch adding support for it, and it is a bug that it is not, becuase
RGMII is supported for similar switches driven by mv88e6xxx driver
(6390, for example). I don't know why I overlooked it then.

Note that I wouldn't consider adding support for USXGMII a fix, because
although the switch can do it, it was never done with this driver.

But if you think it doesn't apply anyway, remove the Fixes tag. This is
just my opinion that it should stay.

Marek
