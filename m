Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C38A6ADBF2
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 11:30:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230225AbjCGKaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 05:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjCGKaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 05:30:21 -0500
Received: from bmailout3.hostsharing.net (bmailout3.hostsharing.net [IPv6:2a01:4f8:150:2161:1:b009:f23e:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E7F241CF;
        Tue,  7 Mar 2023 02:29:33 -0800 (PST)
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "*.hostsharing.net", Issuer "RapidSSL Global TLS RSA4096 SHA256 2022 CA1" (verified OK))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 6FFFF100DEC9C;
        Tue,  7 Mar 2023 11:29:31 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 448163E446; Tue,  7 Mar 2023 11:29:31 +0100 (CET)
Date:   Tue, 7 Mar 2023 11:29:31 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Grant Grundler <grundler@chromium.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Anton Lundin <glance@acc.umu.se>,
        Eizan Miyamoto <eizan@chromium.org>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: asix: fix modprobe "sysfs: cannot create duplicate
 filename"
Message-ID: <20230307102931.GA25631@wunner.de>
References: <20230307005028.2065800-1-grundler@chromium.org>
 <84094771-7f98-0d8d-fe79-7c22e15a602d@gmail.com>
 <CANEJEGvM_xLrSSjrgKLh_xP+BrFFT+afDQhG8BOdgHPf7eR4gQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANEJEGvM_xLrSSjrgKLh_xP+BrFFT+afDQhG8BOdgHPf7eR4gQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 10:10:09PM -0800, Grant Grundler wrote:
> On Mon, Mar 6, 2023 at 7:46???PM Florian Fainelli <f.fainelli@gmail.com> wrote:
> > On 3/6/2023 4:50 PM, Grant Grundler wrote:
> > > +     priv->phydev = mdiobus_get_phy(priv->mdio, priv->phy_addr);
> > > +     if (priv->phydev)
> > > +             return 0;
> >
> > This was in ax88772_init_phy() before, why is this being moved here now?
> 
> Because other drivers I looked at (e.g. tg3 and r8169) do all the mdiobus_*
> calls in one function and I wanted to have some "symmetry"
> with ax88772_release_mdio() function I added below.

I'd suggest moving this cleanup to a separate commit so that you keep
the fix itself as small as possible and thus minimize the potential of
introducing regressions in stable kernels that will receive the fix.

Also, per convention please use the if-clause to catch the error case,
not the success case.  It doesn't matter if you need two or three more
lines, readability is more important IMO.

Thanks,

Lukas
