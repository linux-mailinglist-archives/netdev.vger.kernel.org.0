Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BFAE67B3B3
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 14:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235069AbjAYNxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 08:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbjAYNxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 08:53:02 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5860B11141;
        Wed, 25 Jan 2023 05:53:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dSVTciFgLbCZ2c6aTtmPDjUFg/hiiEjV4tZslEmOumc=; b=gFo0QMptZ34ib8tjonV0JQC6I8
        p9UA7bqZ5dW4UhdMJlomKSmYFUPyPAcd7jnVwknK6rlluXbiRWK2E9d8Y7Cqp9hxz1gXwrQavxZLj
        Qxbw70MjNAIdIkJfwKR9VbXCUf5Lu6nQWAcQq5/3SkOyHE78I5K/tCqK8Kno8iMb/uzU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pKgCh-0038xH-1g; Wed, 25 Jan 2023 14:52:43 +0100
Date:   Wed, 25 Jan 2023 14:52:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Xu Liang <lxu@maxlinear.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/5] net: phy: C45-over-C22 access
Message-ID: <Y9E0K9szL+W4qi2z@lunn.ch>
References: <20230120224011.796097-1-michael@walle.cc>
 <Y87L5r8uzINALLw4@lunn.ch>
 <Y87WR/T395hKmgKm@shell.armlinux.org.uk>
 <dcea8c36e626dc31ee1ddd8c867eb999@walle.cc>
 <Y9BHjEUSvIRI2Mrz@lunn.ch>
 <c7f8d06e5b974b042c9e731c81508c82@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7f8d06e5b974b042c9e731c81508c82@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 24, 2023 at 10:20:33PM +0100, Michael Walle wrote:
> Am 2023-01-24 22:03, schrieb Andrew Lunn:
> > > Btw. for the DT case, it seems we need yet another property
> > > to indicate broken MDIO busses.
> > 
> > I would prefer to avoid that. I would suggest you do what i did for
> > the none DT case. First probe using C22 for all devices known in DT.
> > Then call mdiobus_prevent_c45_scan() which will determine if any of
> > the found devices are FUBAR and will break C45. Then do a second probe
> > using C45 and/or C45 over C22 for those devices in DT with the c45
> > compatible.
> 
> I tried that yesterday. Have a look at of_mdiobus_register() [1].
> There the device tree is walked and each PHY with a reg property
> is probed. Afterwards, if there was a node without a reg property,
> the bus is scanned for the missing PHYs. If we would just probe c22
> first, the order of the auto scanning might change, if there is a
> c45 phy in between two c22 phys. I was thinking to just ignore the
> case that the autoscan would discover a broken PHY.

I think it is pretty rare to not have a reg value. The DT lint tools
will complain about that, etc. So any examples are likely to be old
boards. And old board are a lot less likely to have C45 PHYs. So there
is a corner case left unhandled, but it seems pretty unlikely. So i
agree, lets address it if anybody reports issues. But please mention
it in the commit message, just i can somebody does a git bisect, etc.

   Andrew
 
