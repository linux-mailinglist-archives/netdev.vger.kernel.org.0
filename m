Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D86B31BC33
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 16:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbhBOPXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 10:23:07 -0500
Received: from mo-csw1115.securemx.jp ([210.130.202.157]:47520 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbhBOPWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 10:22:46 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id 11FFKG6n024333; Tue, 16 Feb 2021 00:20:16 +0900
X-Iguazu-Qid: 2wGqn5DuWuqX2Ss3iz
X-Iguazu-QSIG: v=2; s=0; t=1613402415; q=2wGqn5DuWuqX2Ss3iz; m=/wKFgwyBTwVVVznr0ILCXsnu0TO+86riP91KaZy3nkg=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1113) id 11FFKDcG038195;
        Tue, 16 Feb 2021 00:20:14 +0900
Received: from enc01.toshiba.co.jp ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 11FFKD2G008102;
        Tue, 16 Feb 2021 00:20:13 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 11FFKCeJ017228;
        Tue, 16 Feb 2021 00:20:13 +0900
Date:   Tue, 16 Feb 2021 00:20:11 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        DTML <devicetree@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        punit1.agrawal@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] net: stmmac: Add Toshiba Visconti SoCs glue driver
X-TSB-HOP: ON
Message-ID: <20210215152011.5q7eudtfzn7afmfi@toshiba.co.jp>
References: <20210215050655.2532-1-nobuhiro1.iwamatsu@toshiba.co.jp>
 <20210215050655.2532-3-nobuhiro1.iwamatsu@toshiba.co.jp>
 <YCoPmfunGmu0E8IT@unreal>
 <20210215072809.n3r5rdswookzri6j@toshiba.co.jp>
 <YCo9WVvtAeozE42k@unreal>
 <CAK8P3a391547zH=bYXbLzttP9ehFK=OzcM_XkSJs92dA1z4DGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a391547zH=bYXbLzttP9ehFK=OzcM_XkSJs92dA1z4DGQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Feb 15, 2021 at 01:19:18PM +0100, Arnd Bergmann wrote:
> On Mon, Feb 15, 2021 at 10:23 AM Leon Romanovsky <leon@kernel.org> wrote:
> > On Mon, Feb 15, 2021 at 04:28:09PM +0900, Nobuhiro Iwamatsu wrote:
> > >
> > > Sorry, I sent the wrong patchset that didn't fix this point out.
> > >
> > > > I asked it before, but never received an answer.
> > >
> > > I have received your point out and have sent an email with the content
> > > to remove this line. But it may not have arrived yet...
> > >
> > > > Why did you use "def_bool y" and not "default y"? Isn't it supposed to be
> > > > "depends on STMMAC_ETH"? And probably it shouldn't be set as a default as "y".
> > > >
> > >
> > > The reason why "def_bool y" was set is that the wrong fix was left when
> > > debugging. Also, I don't think it is necessary to set "default y".
> > > This is also incorrect because it says "bool" Toshiba Visconti DWMAC
> > > support "". I change it to trustate in the new patch.
> > >
> > > And this driver is enabled when STMMAC_PLATFORM was Y. And STMMAC_PLATFORM
> > > depends on STMMAC_ETH.
> > > So I understand that STMMAC_ETH does not need to be dependents. Is this
> > > understanding wrong?
> >
> > This is correct understanding, just need to clean other entries in that
> > Kconfig that depends on STMMAC_ETH.
> 
> 'tristate' with no default sounds right. I see that some platforms have a
> default according to the platform, which also makes sense but isn't
> required. What I would suggest though is a dependency on the platform,
> to make it easier to disable the front-end based on which platforms
> are enabled. This would end up as
> 
> config DWMAC_VISCONTI
>         tristate "Toshiba Visconti DWMAC support"
>         depends on ARCH_VISCONTI || COMPILE_TEST
>         depends on OF && COMMON_CLK # only add this line if it's
> required for compilation
>         default ARCH_VISCONTI
>

The fix at hand is the same as your suggestion.
Thank you for your comment.

>       Arnd
> 

Best regards,
  Nobuhiro
