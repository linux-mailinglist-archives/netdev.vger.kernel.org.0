Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8076C3F525A
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 22:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbhHWUos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 16:44:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37420 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232237AbhHWUor (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Aug 2021 16:44:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=HnrRRMFf9rYwkdlthq8ooWMSYviV7lDDwzhWgOFlixk=; b=Asi+fyrm2XjeEC4O/G0lYn6jpT
        e9JEKHW+6daJQeErgh6XxK+Wx7/JxBqF95bygCyq1tJdMYsL4OyCrPse1wvwwKcQcQ1OcpXAi+Mdb
        yKsrBVNBh7sGause6z9BkH+azH7CYGRgh2gyr+jeqMX6J+n1Lo2mhnTSIR/cwTDDY+rk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mIGnW-003VvM-6R; Mon, 23 Aug 2021 22:43:58 +0200
Date:   Mon, 23 Aug 2021 22:43:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH net] net: dsa: sja1105: fix use-after-free after calling
 of_find_compatible_node, or worse
Message-ID: <YSQIjtkJPg3lFg7t@lunn.ch>
References: <cd0d9c40-d07b-e2ab-b068-d0bcb4685d09@bang-olufsen.dk>
 <20210817223101.7wbdofi7xkeqa2cp@skbuf>
 <CAGETcx8T-ReJ_Gj-U+nxQyZPsv1v67DRBvpp9hS0fXgGRUQ17w@mail.gmail.com>
 <6b89a9e1-e92e-ca99-9fbd-1d98f6a7864b@bang-olufsen.dk>
 <CAGETcx_uj0V4DChME-gy5HGKTYnxLBX=TH2rag29f_p=UcG+Tg@mail.gmail.com>
 <875f7448-8402-0c93-2a90-e1d83bb7586a@bang-olufsen.dk>
 <CAGETcx_M5pEtpYhuc-Fx6HvC_9KzZnPMYUH_YjcBb4pmq8-ghA@mail.gmail.com>
 <CAGETcx_+=TmMq9hP=95xferAmyA1ZCT3sMRLVnzJ9Or9OnDsDA@mail.gmail.com>
 <14891624-655b-a71d-dc04-24404e0c2e1a@bang-olufsen.dk>
 <CAGETcx-7xgt5y_zNHzSMQf4YFCmWRPfP4_voshbNxKPgQ=b1tA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx-7xgt5y_zNHzSMQf4YFCmWRPfP4_voshbNxKPgQ=b1tA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I thought about this in the background the past few days. I think
> there are a couple of options:
> 1. We (community/Andrew) agree that this driver would only work with
> fw_devlink=on and we can confirm that the other upstream uses of
> "realtek,rtl8366rb" won't have any unprobed consumers problem and
> switch to using my patch. Benefit is that it's a trivial and quick
> change that gets things working again.

I don't think realtek,rtl8366rb is doing anything particularly
unusual. It is not the only switch driver with an MDIO bus driver with
its internal PHYs on it.

> 2. The "realtek,rtl8366rb" driver needs to be fixed to use a
> "component device".

Again, i don't think "realtek,rtl8366rb is doing anything unusual,
compared to the other DSA drivers. If you are suggesting it needs to
make use of the component driver, you might also be suggesting that
all the switch drivers need to be component devices. I don't fully
understand the details here, but it might be, you are also suggesting
some Ethernet drivers need modifying to use the component framework?
And that is not going to fly.

This has all worked until now, things might need a few iterations with
deferral, but we get there in the end. Maybe we need to back out the
phy-handle patch? It does appear to be causing regressions.

	   Andrew
