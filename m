Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EBBE563A3E
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 21:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiGATes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 15:34:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiGATeq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 15:34:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 514F71BE84
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 12:34:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E247662101
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 19:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10AE7C3411E;
        Fri,  1 Jul 2022 19:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656704084;
        bh=dEu/u9dgfs1RHHkM0fkOgtAUXU1kmpj5LCeuGMQMttI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jdzO9DswH3WCzTLver5Ukfwgcu1y3kEayD2Udew/YpxLqyMuG4k2AmOajMU5ZhEdr
         4DPH8fYP89C473mASb73jj2AGtVbyT+65zfdfVZIN+zQPw5pNL50WCxTc9e5gbiY7R
         diNX+0lYiYuAaDSJrj7OeFyNvWM4YJ6bDYn9j45g2P0NWEi45kswkf41xp3EoT8VRT
         ikHAgseGyuPYr+gGznoao+WcJDGN39lJCacnrzhVr2AcrlkYUP8A6IKP7sO5hZYzJ7
         B0GzDZZiyWkoiJQhQeozynCH+I4ITfPubb1KENP352K5CjOGH6f1wrsi4vR1w0EvQQ
         rSSCigcEt6dpA==
Date:   Fri, 1 Jul 2022 21:34:35 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "Alvin __ipraga" <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH RFC net-next 5/6] net: dsa: always use phylink for CPU
 and DSA ports
Message-ID: <20220701213435.53ecdd70@thinkpad>
In-Reply-To: <E1o6XAV-004pW2-Ct@rmk-PC.armlinux.org.uk>
References: <YrxKdVmBzeMsVjsH@shell.armlinux.org.uk>
        <E1o6XAV-004pW2-Ct@rmk-PC.armlinux.org.uk>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jun 2022 13:51:43 +0100
"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk> wrote:

> Currently, we only use phylink for CPU and DSA ports if there is a
> fixed-link specification, or a PHY specified. The reason for this
> behaviour is that when neither is specified, there was no way for
> phylink to know the link parameters.
>=20
> Now that we have phylink_set_max_link_speed() (which has become
> possible through the addition of mac_capabilities) we now have the
> ability to know the maximum link speed for a specific link, and can
> now use phylink for this case as well.
>=20
> However, we need DSA drivers to report the interface mode being used
> on these ports so that we can select a maximum speed appropriate for
> the interface mode that hardware may have configured for the port.
>=20
> This is especially important with the conversion of DSA drivers to
> phylink_pcs, as the PCS code only gets called if we are using
> phylink for the port.
>=20
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Marek Beh=C3=BAn <kabel@kernel.org>

So this is the one that may break other drivers?

Marek
