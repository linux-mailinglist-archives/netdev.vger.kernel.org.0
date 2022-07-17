Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94CDD57730C
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 03:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbiGQBjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jul 2022 21:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbiGQBjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jul 2022 21:39:51 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502C61AD9E;
        Sat, 16 Jul 2022 18:39:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=vHboTQVyDPjyOiJ7fhjhnLV2AN9SVlX5UirCaUIKjro=; b=flUpDHGrs8Da2Zxp4G8Z4nuLqx
        AMJ2U5n+ifO9ta3oX36I2yuEzpAXsPxy57F5P6mEA5xWHP8ptjACCyqPr/gYslTtc4GKPRfqnxG/J
        pqY2w6y4HVLV+ta47zE0TKloBZvBSfoDbb72P+MFmdz/Xvu+niBre44yGv8tGHGj15xI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oCtFz-00Aanj-Ju; Sun, 17 Jul 2022 03:39:39 +0200
Date:   Sun, 17 Jul 2022 03:39:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v3 10/47] net: phylink: Adjust link settings
 based on rate adaptation
Message-ID: <YtNoW8bJdWPzX3Cq@lunn.ch>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-11-sean.anderson@seco.com>
 <YtMc2qYWKRn2PxRY@lunn.ch>
 <4172fd87-8e51-e67d-bf86-fdc6829fa9b3@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4172fd87-8e51-e67d-bf86-fdc6829fa9b3@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I would not do this. If the requirements for rate adaptation are not
> > fulfilled, you should turn off rate adaptation.
> > 
> > A MAC which knows rate adaptation is going on can help out, by not
> > advertising 10Half, 100Half etc. Autoneg will then fail for modes
> > where rate adaptation does not work.
> 
> OK, so maybe it is better to phylink_warn here. Something along the
> lines of "phy using pause-based rate adaptation, but duplex is %s".

You say 1/2 duplex simply does not work with rate adaptation. So i
would actually return -EINVAL at the point the MAC indicates what
modes it supports if there is a 1/2 duplex mode in the list.

> 
> > The MAC should also be declaring what sort of pause it supports, so
> > disable rate adaptation if it does not have async pause.
> 
> That's what we do in the previous patch.
> 
> The problem is that rx_pause and tx_pause are resolved based on our
> advertisement and the link partner's advertisement. However, the link
> partner may not support pause frames at all. In that case, we will get
> rx_pause and tx_pause as false. However, we still want to enable rx_pause,
> because we know that the phy will be emitting pause frames. And of course
> the user can always force disable pause frames anyway through ethtool.

Right, so we need a table somewhere in the documentation listing the
different combinations and what should happen.

If the MAC does not support rx_pause, rate adaptation is turned off.
If the negotiation results in no rx_pause, force it on anyway with
Pause based adaptation. If ethtool turns pause off, turn off rate
adaptation.

Does 802.3 say anything about this?

We might also want to add an additional state to the ethtool get for
pause, to indicate rx_pause is enabled because of rate adaptation, not
because of autoneg.

       Andrew
