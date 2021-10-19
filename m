Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D345433B08
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 17:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231888AbhJSPto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 11:49:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:46932 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229774AbhJSPtn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 11:49:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=eCMIR821Ir/fH4hzT4BkFjEc5OrliT5YIEJJG4FQBlc=; b=aXSnLUojGURbEtjpD0kfWiISRg
        7Vcz4+8voOrPpNW9UXPDv+5uuHP2+VwpPur02txJFiIhsZLrsFCwsJJ7tb25o+MomcBQOFg2qt0pn
        ucqs55BZ4vavl2aGFbzjy3Bbejx2YKsslMtqP65nwPRoOk4o5rRpZ15l5+vnEJ8YZynI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcrKq-00B5j3-9Y; Tue, 19 Oct 2021 17:47:28 +0200
Date:   Tue, 19 Oct 2021 17:47:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Kory Maincent <kory.maincent@bootlin.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Adam Ford <aford173@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: Re: [PATCH] net: renesas: Fix rgmii-id delays
Message-ID: <YW7okIGh/6Zjv2p2@lunn.ch>
References: <20211019145719.122751-1-kory.maincent@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211019145719.122751-1-kory.maincent@bootlin.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 19, 2021 at 04:57:17PM +0200, Kory Maincent wrote:
> Invert the configuration of the RGMII delay selected by RGMII_RXID and
> RGMII_TXID.
> 
> The ravb MAC is adding RX delay if RGMII_RXID is selected and TX delay
> if RGMII_TXID but that behavior is wrong.
> Indeed according to the ethernet.txt documentation the ravb configuration
> should be inverted:
>   * "rgmii-rxid" (RGMII with internal RX delay provided by the PHY, the MAC
>      should not add an RX delay in this case)
>   * "rgmii-txid" (RGMII with internal TX delay provided by the PHY, the MAC
>      should not add an TX delay in this case)
> 
> This patch inverts the behavior, i.e adds TX delay when RGMII_RXID is
> selected and RX delay when RGMII_TXID is selected.

This gets messy. As a general rule of thumb, the MAC should not be
adding delays, the PHY should. ravb has historically ignored that, and
it adds delays. It then needs to be careful with what it passes to the
PHY.

So with rgmii-rxid, what is actually passed to the PHY? Is your
problem you get twice the delay in one direction, and no delay in the
other?

	Andrew
