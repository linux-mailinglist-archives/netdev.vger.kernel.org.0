Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0695F4B0236
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 02:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232356AbiBJB2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 20:28:30 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbiBJB2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:28:18 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5EF720197;
        Wed,  9 Feb 2022 17:28:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ULmAtyK6TJjr1QVUNlDS0X1iN3QvREY5ZfYCv9v5FwA=; b=NtqFXUPsUEV5rj6gTA8JTXNQd0
        HwWPACBb9ahCPbRj4DW2eX9HhMpYTDG9fvTyUnciQZ/dSmY6+drRmI7AjXLZxDUsp8QLX0ca5k384
        2N9nzJI6MA6bOU1LGuhw2PcYi8P5dteqquf1DDL+ga6+QOYSv3O+7W0vT6WGsWcKaxUI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nHwwx-005CsL-UU; Thu, 10 Feb 2022 01:04:39 +0100
Date:   Thu, 10 Feb 2022 01:04:39 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Tim Harvey <tharvey@gateworks.com>
Cc:     Martin Schiller <ms@dev.tdt.de>, Hauke Mehrtens <hauke@hauke-m.de>,
        martin.blumenstingl@googlemail.com,
        Florian Fainelli <f.fainelli@gmail.com>, hkallweit1@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v3] net: phy: intel-xway: enable integrated led
 functions
Message-ID: <YgRWl5ykcjPW0xvx@lunn.ch>
References: <20210421055047.22858-1-ms@dev.tdt.de>
 <CAJ+vNU1=4sDmGXEzPwp0SCq4_p0J-odw-GLM=Qyi7zQnVHwQRA@mail.gmail.com>
 <YfspazpWoKuHEwPU@lunn.ch>
 <CAJ+vNU2v9WD2kzB9uTD5j6DqnBBKhv-XOttKLoZ-VzkwdzwjXw@mail.gmail.com>
 <YfwEvgerYddIUp1V@lunn.ch>
 <CAJ+vNU1qY1VJgw1QRsbmED6-TLQP2wwxSYb+bXfqZ3wiObLgHg@mail.gmail.com>
 <YfxtglvVDx2JJM9w@lunn.ch>
 <CAJ+vNU1td9aizbws-uZ-p-fEzsD8rJVS-mZn4TT2YFn9PY2n_w@mail.gmail.com>
 <Yf2usAHGZSUDvLln@lunn.ch>
 <CAJ+vNU3EY0qp-6oQ6Bjd4mZCKv9AeqiaJp=FSrN84P=8atKLrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ+vNU3EY0qp-6oQ6Bjd4mZCKv9AeqiaJp=FSrN84P=8atKLrw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The errata can be summarized as:
> - 1 out of 100 boots or cable plug events RGMII GbE link will end up
> going down and up 3 to 4 times then resort to a 100m link; workaround
> has been found to require a pin level reset

So that sounds like it is downshifting because it thinks there is a
broken pair. Can you disable downshift? Problem is, that might just
result in link down.

> - 1 out of 100 boots or cable plug events (varies per board) SGMII
> will fail link between the MAC and PHY; workaround has been found to
> require a pin level reset

I don't suppose there is a register to restart SGMII sync?  Sometimes
there is.

Anyway, shared reset makes this messy, as you said. Unfortunate
design. But i don't see how you can work around this in the
bootloader, especially the cable plug events.

	Andrew
