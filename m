Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EBAF6E0DA8
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 14:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjDMMso (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 08:48:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjDMMsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 08:48:43 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E4C2115;
        Thu, 13 Apr 2023 05:48:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FtBdndZ3097mSvwg5FOFaiH+eLsMC9IFLTN0uxY11Hk=; b=b0F4Mwt0Njh9nMh7X/DOfo3jPT
        uG1loN7ecupHSyBznqMc3ZsMIGSgYdywFIue78i4BY7R0ThXcrkOXtZKy+jN2eQ4obVkbNR0wT3ty
        BVAIU+RTRicvetF9arvDQotBgmDSaqqIeUGu3lufoBbQEXHKfqHeeJTxQHirNSyO+y0E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pmwNK-00ABVl-W0; Thu, 13 Apr 2023 14:48:30 +0200
Date:   Thu, 13 Apr 2023 14:48:30 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Herve Codina <herve.codina@bootlin.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Vinod Koul <vkoul@kernel.org>,
        Kishon Vijay Abraham I <kishon@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-phy@lists.infradead.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [RFC PATCH 0/4] Add support for QMC HDLC and PHY
Message-ID: <885e4f20-614a-4b8e-827e-eb978480af87@lunn.ch>
References: <20230323103154.264546-1-herve.codina@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230323103154.264546-1-herve.codina@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 23, 2023 at 11:31:50AM +0100, Herve Codina wrote:
> Hi,
> 
> I have a system where I need to handle an HDLC interface.
> 
> The HDLC data are transferred using a TDM bus on which a PEF2256 is
> present. The PEF2256 transfers data from/to the TDM bus to/from E1 line.
> This PEF2256 is also connected to a PowerQUICC SoC for the control path
> and the TDM is connected to the SoC (QMC component) for the data path.
> 
> From the HDLC driver, I need to handle data using the QMC and carrier
> detection using the PEF2256 (E1 line carrier).
> 
> The HDLC driver consider the PEF2256 as a generic PHY.
> So, the design is the following:
> 
> +----------+          +-------------+              +---------+
> | HDLC drv | <-data-> | QMC channel | <-- TDM -->  | PEF2256 |
> +----------+          +-------------+              |         | <--> E1
>    ^   +---------+     +---------+                 |         |
>    +-> | Gen PHY | <-> | PEF2256 | <- local bus -> |         |
>        +---------+     | PHY drv |                 +---------+
>                        +---------+

Hi Herver

Sorry, i'm late to the conversation. I'm looking at this from two
different perspectives. I help maintain Ethernet PHYs. And i have
hacked on the IDT 82P2288 E1/T1/J1 framer.

I think there is a block missing from this diagram. There appears to
be an MFD driver for the PEF2256? At least, i see an include for
linux/mfd/pef2256.h.

When i look at the 'phy' driver, i don't see anything a typical PHY
driver used for networking would have. A networking PHY driver often
has the ability to change between modes, like SGMII, QSGMII, 10GBASER.
The equivalent here would be changing between E1, T1 and J1. It has
the ability to change the speed, 1G, 2.5G, 10G etc. This could be
implied via the mode, E1 is 2.048Mbps, T1 1.544Mbps, and i forget what
J1 is. The PEF2256 also seems to support E1/T1/J1. How is its modes
configured?

In fact, this PHY driver does not seem to do any configuration of any
sort on the framer. All it seems to be doing is take notification from
one chain and send them out another chain!

I also wounder if this get_status() call is sufficient. Don't you also
want Red, Yellow and Blue alarms? It is not just the carrier is down,
but why it is down.

Overall, i don't see why you want a PHY. What value does it add?

	 Andrew
