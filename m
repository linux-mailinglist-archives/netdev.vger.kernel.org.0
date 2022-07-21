Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEA157D361
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 20:36:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiGUSgR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 14:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiGUSgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 14:36:17 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF461D30E;
        Thu, 21 Jul 2022 11:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=IEVV12oaxPOB3Nni9Jn+Mx+aBFkLo64VmwbICLY6Dos=; b=TXA4R+TPCNkcZOV8x8JUcSX+lw
        N9iOWRwc/a18KZwS9fxOnosIu3bnkNdE5Nayg9ufHX8CRPPnyntJycFC07cXLYYUDddh8e+XTXEtS
        67x3YkXM8dGUHUq7Ka2qyPxwx7KOeWzWU+0tL9n788TlvC1wJIJRDAGwjPLVT1hgYURk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oEb1n-00B48G-JJ; Thu, 21 Jul 2022 20:36:03 +0200
Date:   Thu, 21 Jul 2022 20:36:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Sean Anderson <sean.anderson@seco.com>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 08/11] net: phylink: Adjust advertisement based on
 rate adaptation
Message-ID: <YtmckydVRP9Z/Mem@lunn.ch>
References: <20220719235002.1944800-1-sean.anderson@seco.com>
 <20220719235002.1944800-9-sean.anderson@seco.com>
 <Ytep4isHcwFM7Ctc@shell.armlinux.org.uk>
 <3844f2a6-90fb-354e-ce88-0e9ff0a10475@seco.com>
 <YtmVIXYKpCJ2GEwK@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YtmVIXYKpCJ2GEwK@shell.armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I guess it would depend on the structure of the PHY - whether the PHY
> is structured similar to a two port switch internally, having a MAC
> facing the host and another MAC facing the media side. (I believe this
> is exactly how the MACSEC versions of the 88x3310 are structured.)
> 
> If you don't have that kind of structure, then I would guess that doing
> duplex adaption could be problematical.

If you don't have that sort of structure, i think rate adaptation
would have problems in general. Pause is not very fine grained. You
need to somehow buffer packets because what comes from the MAC is
likely to be bursty. And when that buffer overflows, you want to be
selective about what you throw away. You want ARP, OSPF and other
signalling packets to have priority, and user data gets
tossed. Otherwise your network collapses.

	Andrew
