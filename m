Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9D6567801
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 21:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiGETtN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 15:49:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiGETtL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 15:49:11 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8021D3;
        Tue,  5 Jul 2022 12:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ONPWuHGAM6kWNFap3DXPBrwE41N3WuQAN/EYPstEIcM=; b=LgkaiVQa6B8YDlpE26jrvbc4Vh
        FPJfILIydT2k1fCP+6v0qOZXrb6dcK6NzD1fDwr0D25lLfApKwXaHg8uJq6Ob3VdK972eJW3UjUuX
        DWcpP+xhZYMxT4pkhBeISJKQ9hyrymziBESry2GIuhi4BM9+ini6zgoeUX4HZipSP8E0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o8oXa-009PZu-CM; Tue, 05 Jul 2022 21:48:58 +0200
Date:   Tue, 5 Jul 2022 21:48:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: Re: [PATCH net-next v2] net: macb: In shared MDIO usecase make MDIO
 producer ethernet node to probe first
Message-ID: <YsSVqknDQxdWqfds@lunn.ch>
References: <1656618906-29881-1-git-send-email-radhey.shyam.pandey@amd.com>
 <Yr66xEMB/ORr0Xcp@lunn.ch>
 <MN0PR12MB59531DFD084FA947084D91B6B7819@MN0PR12MB5953.namprd12.prod.outlook.com>
 <CAGETcx_BUR3EPDLgp9v0Uk9N=8BtYRjFyhpJTQa9kEMHtkgdwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_BUR3EPDLgp9v0Uk9N=8BtYRjFyhpJTQa9kEMHtkgdwQ@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Thanks for the review.  I want to get your thoughts on the outline of
> > the generic solution. Is the current approach fine and we can extend it
> > for all shared MDIO use cases/ or do we see any limitations?
> >
> > a) Figure out if the MDIO bus is shared.  (new binding or reuse existing)
> > b) If the MDIO bus is shared based on DT property then figure out if the
> > MDIO producer platform device is probed. If not, defer MDIO consumer
> > MDIO bus registration.
> 
> Radhey,
> 
> I think Andrew added me because he's pointing you towards fw_devlink.
> 
> Andrew,
> 
> I have intentionally not added phy-handle support to fw_devlink
> because it would also prevent the generic driver from binding/cause
> issues with DSA. I have some high level ideas on fixing that but
> haven't gotten around to it yet.

I took a quick look at macb, and i think it is actually broken in
other ways. If you where to use NFS root, i suspect it would also
fail.

This also has nothing to do with shared MDIO busses as such. All it
requires is some other MDIO bus, not the MACs own MDIO bus.

It is also that we cannot return -EPROBE_DEFER when trying to connect
the PHY, because it is not performed in the context of the probe, but
the open.

fw_dewlink might help solve this, bit it is not going to be easy. We
can also split this into two problems;

1) probe time
2) suspend/resume

macb does seem to probe, for most use cases. So we can probably ignore
that for now. So we can concentrate on suspend/resume. You say
suspend/resume is based on probe order. So it must build some sort of
tree. Can we make phy_attach_direct add an additional link to this
tree when a MAC device is link to a PHY? Is this what
device_link_add() is about?

     Andrew
