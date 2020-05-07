Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94EE71C87C0
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 13:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgEGLNP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 07:13:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgEGLNP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 07:13:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF74E208E4;
        Thu,  7 May 2020 11:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588849994;
        bh=JpJwu3HzMRZiNarifyoKzt5DSF15LyA9t4q0RBYx/+Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U0ZIgjbxbrUQp22xHRVXhrRyXYovhO9OcSbJLRCt06RzSv/mH0Mi/xwKnQhuqUAE5
         bq6FwoI59EsiNC3tKiUsGN+5q7sqMFLPCdtlFoH6z0/XtKE9yLiprcbT//sCoJDkbK
         emJbjo8/AvGo/ULzVUqsZa9FJLI8MDche1ilHUnM=
Date:   Thu, 7 May 2020 13:13:12 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux- stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vince Bridgers <vbridger@opensource.altera.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>,
        Claudiu Manoil <claudiu.manoil@freescale.com>,
        Li Yang <leoli@freescale.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <blogic@openwrt.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Lars Persson <lars.persson@axis.com>,
        Mugunthan V N <mugunthanvnm@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Netdev <netdev@vger.kernel.org>,
        nios2-dev@lists.rocketboards.org,
        open list <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org, linux-mediatek@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, lkft-triage@lists.linaro.org
Subject: Re: [PATCH net 11/16] net: ethernet: marvell: mvneta: fix fixed-link
 phydev leaks
Message-ID: <20200507111312.GA1497799@kroah.com>
References: <1480357509-28074-1-git-send-email-johan@kernel.org>
 <1480357509-28074-12-git-send-email-johan@kernel.org>
 <CA+G9fYvBjUVkVhtRHVm6xXcKe2+tZN4rGdB9FzmpcfpaLhY1+g@mail.gmail.com>
 <20200507064412.GL2042@localhost>
 <20200507064734.GA798308@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507064734.GA798308@kroah.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 08:47:34AM +0200, Greg Kroah-Hartman wrote:
> On Thu, May 07, 2020 at 08:44:12AM +0200, Johan Hovold wrote:
> > On Thu, May 07, 2020 at 12:27:53AM +0530, Naresh Kamboju wrote:
> > > On Tue, 29 Nov 2016 at 00:00, Johan Hovold <johan@kernel.org> wrote:
> > > >
> > > > Make sure to deregister and free any fixed-link PHY registered using
> > > > of_phy_register_fixed_link() on probe errors and on driver unbind.
> > > >
> > > > Fixes: 83895bedeee6 ("net: mvneta: add support for fixed links")
> > > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > > ---
> > > >  drivers/net/ethernet/marvell/mvneta.c | 5 +++++
> > > >  1 file changed, 5 insertions(+)
> > > >
> > > > diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> > > > index 0c0a45af950f..707bc4680b9b 100644
> > > > --- a/drivers/net/ethernet/marvell/mvneta.c
> > > > +++ b/drivers/net/ethernet/marvell/mvneta.c
> > > > @@ -4191,6 +4191,8 @@ static int mvneta_probe(struct platform_device *pdev)
> > > >         clk_disable_unprepare(pp->clk);
> > > >  err_put_phy_node:
> > > >         of_node_put(phy_node);
> > > > +       if (of_phy_is_fixed_link(dn))
> > > > +               of_phy_deregister_fixed_link(dn);
> > > 
> > > While building kernel Image for arm architecture on stable-rc 4.4 branch
> > > the following build error found.
> > > 
> > > drivers/net/ethernet/marvell/mvneta.c:3442:3: error: implicit
> > > declaration of function 'of_phy_deregister_fixed_link'; did you mean
> > > 'of_phy_register_fixed_link'? [-Werror=implicit-function-declaration]
> > > |    of_phy_deregister_fixed_link(dn);
> > > |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > |    of_phy_register_fixed_link
> > > 
> > > ref:
> > > https://gitlab.com/Linaro/lkft/kernel-runs/-/jobs/541374729
> > 
> > Greg, 3f65047c853a ("of_mdio: add helper to deregister fixed-link
> > PHYs") needs to be backported as well for these.
> > 
> > Original series can be found here:
> > 
> > 	https://lkml.kernel.org/r/1480357509-28074-1-git-send-email-johan@kernel.org
> 
> Ah, thanks for that, I thought I dropped all of the ones that caused
> build errors, but missed the above one.  I'll go take the whole series
> instead.

This should now all be fixed up, thanks.

greg k-h
