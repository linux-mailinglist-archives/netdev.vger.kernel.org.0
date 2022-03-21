Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D068F4E31A8
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 21:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353268AbiCUUWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 16:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353251AbiCUUWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 16:22:35 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CCA78E18C;
        Mon, 21 Mar 2022 13:21:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Uk8HaBOL7P4QfOhIUP9iNl2Dlr9/HuQQ9W6qQrbtWew=; b=3jgl895yz7aW01SrmLfCaEzigE
        6Ghr8BJ/yTtOWwrrOjwyZzJkpabCe8wkAFbsZEyOv7oQXISDqtfeo3y2LplYTIPl9zeoGr3ZqW98R
        3LRBUnUbMLKAlZLCFc4IKJbldxUYVqZGhabI/aMxwETIJQt64x0AaFidZps8fNEUEk+k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nWOWY-00C0u3-C7; Mon, 21 Mar 2022 21:21:06 +0100
Date:   Mon, 21 Mar 2022 21:21:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Clause 45 and Clause 22 PHYs on one MDIO bus
Message-ID: <YjjeMo2YjMZkPIYa@lunn.ch>
References: <240354b0a54b37e8b5764773711b8aa3@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <240354b0a54b37e8b5764773711b8aa3@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 12:21:48PM +0100, Michael Walle wrote:
> Hi,
> 
> I have a board with a c22 phy (microchip lan8814) and a c45 phy
> (intel/maxlinear gyp215) on one bus. If I understand it correctly, both
> accesses should be able to coexist on one bus.

Yes. A C22 PHY should ignore a C45 access and vica versa.

> But the microchip lan8814
> actually has a bug and gets confused by c45 accesses. For example it will
> respond in the middle of another transaction with its own data if it
> decodes it as a read. That is something we can see on a logic analyzer.
> But we also see random register writes on the lan8814 (which you don't see
> on the logic analyzer obviously). Fortunately, the GPY215 supports indirect
> MMD access by the standard c22 registers. Thus as a workaround for the
> problem, we could have a c22 only mdio bus.

That should work, but you loose some performance.

> The SoC I'm using is the LAN9668, which uses the mdio-mscc-mdio driver.
> First problem there, it doesn't support C45 (yet) but also doesn't check
> for MII_ADDR_C45 and happily reads/writes bogus registers.

There are many drivers like that :-(

Whenever a new driver is posted, it is one of the things i ask
for. But older drivers are missing such checks.

> I've looked at the mdio subsystem in linux, there is probe_capabilities
> (MDIOBUS_C45 and friends) but the mxl-gpy.c is using c45 accesses
> nevertheless. I'm not sure if this is a bug or not.

No, that is not a bug. The PHY driver knows the device should be c45
capable. So it will use C45 addresses. The phydev->is_c45 should
indicate if it is possible to perform c45 transactions to the PHY. If
it is not, the core will make use of indirect access via C22,
otherwise the core will perform a direct C45 access.

So it seems like all you need to do is make mdio-mscc-mdio return
-EOPNOTSUPP for C45 and check that phydev->is_c45 is correctly false.

	   Andrew
