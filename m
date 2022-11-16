Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1707262BF73
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 14:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233638AbiKPN2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 08:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbiKPN20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 08:28:26 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA9FB61
        for <netdev@vger.kernel.org>; Wed, 16 Nov 2022 05:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=baAFvsuLRu3L05kHwX+VC7JY3NjygqfNx32ykHoXugY=; b=dMBRzKnmzqY6NptNzMYEtdPE4K
        niynAGB2yLA753JlQUjIzWf180fjGair2vLZMG9fPmNy8U5zJZa7krbOp+k76QB67CTQyz5z225i/
        UYV8r9CnhNg1vrQsCknL5PXRN1y+fHZQzlNCsZxdXDLAZx3DvRAJs6QjU6BNSU/OqNME=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ovISi-002ZNr-Kx; Wed, 16 Nov 2022 14:28:20 +0100
Date:   Wed, 16 Nov 2022 14:28:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net] net: dsa: sja1105: disallow C45 transactions on the
 BASE-TX MDIO bus
Message-ID: <Y3TldORKPxFUgqH/@lunn.ch>
References: <20221116100653.3839654-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221116100653.3839654-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 12:06:53PM +0200, Vladimir Oltean wrote:
> You'd think people know that the internal 100BASE-TX PHY on the SJA1110
> responds only to clause 22 MDIO transactions, but they don't :)
> 
> When a clause 45 transaction is attempted, sja1105_base_tx_mdio_read()
> and sja1105_base_tx_mdio_write() don't expect "reg" to contain bit 30
> set (MII_ADDR_C45) and pack this value into the SPI transaction buffer.

Yep, it is a common problem with MDIO busses. And driver i review now
i asks for EOPNOTSUPP for clauses which are not supported, but there
are old drivers out there missing such checks.

I have a bit rotting patchset which completely separates C22 and C45,
i just spend too much time reviewing other code to get my own merged.

> Fixes: 5a8f09748ee7 ("net: dsa: sja1105: register the MDIO buses for 100base-T1 and 100base-TX")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
