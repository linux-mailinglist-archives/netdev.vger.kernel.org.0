Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2D252BF8B
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 18:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239475AbiERPks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 11:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239419AbiERPkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 11:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 022F2DF85
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 08:40:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 907DA6116A
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 15:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868EBC385A5;
        Wed, 18 May 2022 15:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652888444;
        bh=gohT+zCwwd2u+Mo57y6mQsr97gjXgOYB0TvDgLPd4L8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RkhxjpoWKxMbw6dgFfMv1T1QJgX8h8s6tC72x485eBOUle9jdlYMDlBQBvUVE4GiO
         ipKdO2NtXucAoSvUSMW0EmUgmzzh72prs2cRXt5pDzQY4on39C4CHHz4YEd/lEVFIA
         /uqK+uUUzmdYF3fdKslUcPLEzaj93ERb1xKFdtmEMDSkObiWBfrdYQbDu3E7qg8KF3
         6fpuWRx0RFzj/qTJW1uFD9OQtzSghXJ3xejYA4FqhjBxvdldnZ2YQ6ZgmpFLIK6coz
         5zLEXoigzGWcSTnLpDOIM3NFskfFESm1atF+8AYGCzPmKyLz90tzzaSuZqZPHtYOPv
         aFaTcYDcAvdaA==
Date:   Wed, 18 May 2022 17:40:37 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>
Subject: Re: [PATCH net-next 00/12] mtk_eth_soc phylink updates
Message-ID: <20220518174037.6f1b863e@thinkpad>
In-Reply-To: <YoUIX+BN/ZbyXzTT@shell.armlinux.org.uk>
References: <YoUIX+BN/ZbyXzTT@shell.armlinux.org.uk>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 May 2022 15:53:19 +0100
"Russell King (Oracle)" <linux@armlinux.org.uk> wrote:

> Hi,
>=20
> This series ultimately updates mtk_eth_soc to use phylink_pcs, with some
> fixes along the way.
>=20
> Previous attempts to update this driver (which is now marked as legacy)
> have failed due to lack of testing. I am hoping that this time will be
> different; Marek can test RGMII modes, but not SGMII. So all that we
> know is that this patch series probably doesn't break RGMII.
>=20
> 1) remove unused mac_mode and sgmii flags members from structures.
> 2) remove unnecessary interpretation of speed when configuring 1000
>    and 2500 Base-X
> 3) move configuration of SGMII duplex setting from mac_config() to
>    link_up()
> 4) only pass in interface mode to mtk_sgmii_setup_mode_force()
> 5) move decision about which mtk_sgmii_setup_mode_*() function to call
>    into mtk_sgmii.c
> 6) add a fixme comment for RGMII explaning why the call to
>    mtk_gmac0_rgmii_adjust() is completely wrong - this needs to be
>    addressed by someone who has the hardware and can test an appropriate
>    fix. This fixme means that the driver still can't become non-legacy.
> 7) move gmac setup from mac_config() to mac_finish() - this preserves
>    the order that we write to the hardware when we eventually convert to
>    phylink_pcs()
> 8) move configuration of syscfg0 in SGMII/802.3z mode to mac_finish()
>    for the same reasons as (7).
> 9) convert mtk_sgmii.c code structure and the mtk_sgmii structure to
>    suit conversion to phylink_pcs
> 10) finally convert to phylink_pcs
>=20
> As there has been no feedback from mtk_eth_soc maintainers to my RFC
> on April 6th, not my reminder on April 11th, so it's now time to merge
> this anyway. Mediatek code seems to be submitted to the kernel and
> then the maintainers scarper...
>=20
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 103 +++++++++-------
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h |  40 +++----
>  drivers/net/ethernet/mediatek/mtk_sgmii.c   | 176 ++++++++++++++++------=
------
>  3 files changed, 186 insertions(+), 133 deletions(-)
>=20

Tested-by: Marek Beh=C3=BAn <kabel@kernel.org>
