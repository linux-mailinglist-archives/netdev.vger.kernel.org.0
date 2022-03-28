Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56BDA4E9744
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 15:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242766AbiC1NFK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 09:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242785AbiC1NFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 09:05:08 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE4C165AC;
        Mon, 28 Mar 2022 06:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=6dOO5q99O9jnBJeksf56yOOYMeJk6f9opXAJEEHgAkk=; b=fk
        O5qE6jq0KMZUWBxWrFlP3+LybsWVkaSjOyy4NsNUe37oHGAKRpfRNmOchCleFNyn2YRPU8JqB6oEm
        6ArvdHRSNXNpSntEiKN1bFVCQEYoRRnjsFz/IbhBblK+t2HKv/ujm9Y11vPVmAEUWanDT0jgxmKG7
        myYTmsxvJBZVLRw=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nYp1g-00D1CB-FB; Mon, 28 Mar 2022 15:03:16 +0200
Date:   Mon, 28 Mar 2022 15:03:16 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?iso-8859-1?Q?Cl=E9ment_L=E9ger?= <clement.leger@bootlin.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Allan Nielsen <allan.nielsen@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next 1/5] net: mdio: fwnode: add fwnode_mdiobus_register()
Message-ID: <YkGyFJuUDS6x4wrC@lunn.ch>
References: <20220325172234.1259667-1-clement.leger@bootlin.com>
 <20220325172234.1259667-2-clement.leger@bootlin.com>
 <Yj4MIIu7Qtvv25Fs@lunn.ch>
 <20220328082642.471281e7@fixe.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220328082642.471281e7@fixe.home>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 28, 2022 at 08:26:42AM +0200, Clément Léger wrote:
> Le Fri, 25 Mar 2022 19:38:24 +0100,
> Andrew Lunn <andrew@lunn.ch> a écrit :
> 
> > On Fri, Mar 25, 2022 at 06:22:30PM +0100, Clément Léger wrote:
> > > In order to support software node description transparently, add fwnode
> > > support with fwnode_mdiobus_register(). This function behaves exactly
> > > like of_mdiobus_register() function but using the fwnode node agnostic
> > > API. This support might also be used to merge ACPI mdiobus support
> > > which is quite similar to the fwnode one.
> > > 
> > > Some part such as the whitelist matching are kept exclusively for OF
> > > nodes since it uses an of_device_id struct and seems tightly coupled
> > > with OF. Other parts are generic and will allow to move the existing
> > > OF support on top of this fwnode version.  
> > 
> > Does fwnode have any documentation? How does a developer know what
> > properties can be passed? Should you be adding a
> > 
> > Documentation/fwnode/bindings/net/mdio.yaml ?
> > 
> > 	Andrew
> 
> Hi Andrew,
> 
> Actually, fwnode is an abstraction for various firmware nodes such as
> ACPI, device-tree and software nodes. It allows to access properties,
> child and other attributes transparently from these various nodes but
> does not actually defines how they should describe the hardware. If
> there is specific hanling to be done, node type can be checked using
> is_acpi_node(), is_of_node() and so on.
> 
> I think it is still needed to document the bindings for each node type.

But you seem to be implementing a subset of what each node type
supports. So maybe it would be good to document which parts of the OF
binding can be used, which parts of the ACPI binding can be used, etc.

	Andrew
