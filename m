Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576754E3354
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 23:56:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230017AbiCUWz0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 18:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiCUWzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 18:55:18 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83AA3B584E;
        Mon, 21 Mar 2022 15:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=UBm3ZjytRb4UWe3yTQNc0gsXTg4o3/vjn11r6LYHBUk=; b=EFcWcZxDNpzXTxn6wpCEk3BAeA
        M71XlJmd/7vwPd/eQG7ok/bTqCxOuolRmMsx1YLovGmeg0eatXci8kcHDkY3oDgKXSPu1vCvknY9N
        2tATwn6J2tHYRNrEY6BXsgF7UxN+B4f8Q9EDwmacbY8AiVGU5vb0KsiiyAdNKobXtQ6Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nWQey-00C1zY-4M; Mon, 21 Mar 2022 23:37:56 +0100
Date:   Mon, 21 Mar 2022 23:37:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Clause 45 and Clause 22 PHYs on one MDIO bus
Message-ID: <Yjj+RBI/6H7HMyJk@lunn.ch>
References: <240354b0a54b37e8b5764773711b8aa3@walle.cc>
 <YjjeMo2YjMZkPIYa@lunn.ch>
 <e26585742f492bf03959cfc469d02c52@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e26585742f492bf03959cfc469d02c52@walle.cc>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 21, 2022 at 10:51:29PM +0100, Michael Walle wrote:
> Am 2022-03-21 21:21, schrieb Andrew Lunn:
> > On Mon, Mar 21, 2022 at 12:21:48PM +0100, Michael Walle wrote:
> > > The SoC I'm using is the LAN9668, which uses the mdio-mscc-mdio
> > > driver.
> > > First problem there, it doesn't support C45 (yet) but also doesn't
> > > check
> > > for MII_ADDR_C45 and happily reads/writes bogus registers.
> > 
> > There are many drivers like that :-(
> > 
> > Whenever a new driver is posted, it is one of the things i ask
> > for. But older drivers are missing such checks.
> 
> Should that be a patch for net or net-next? One thing to consider;
> The gpy215 is probing just fine with a c22 only mdio driver which doesn't
> check for c45 accesses. It might read fishy registers during its probe,
> though. After adding the c45 check in the mdio drivers read and write
> it will fail to probe. So depending on the mdio driver it might went
> unnoticed that the phy_get_c45_ids() could fail.
> 
> If it should go via net, then it should probably be accompanied
> by a patch to fix the gpy_probe() (i.e. ignoring -EOPNOTSUPP
> error).

I would suggest net-next first, so it gets some testing. We can then
add it to net later. We just need to keep an eye out for the automagic
bots which magically pick patches to backport. We don't want them to
pickup these patches too soon and only take part of the fix.

       Andrew
