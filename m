Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F299060350E
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 23:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiJRVjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 17:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbiJRVjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 17:39:40 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE681F2DC;
        Tue, 18 Oct 2022 14:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kkMKLBAX6vZe5+FR2sneUyNPLXj5K2NRXGHtjYxoPEQ=; b=gPOzOaSQRy6C01KNcLOtFWyOWi
        bIqQ3X7Ob0FyVjq1di8Zlo/yFj/XUeEMn7UOHdxXE9K2rIURKq/+pOyym8Kf//aImSuYrEuhQFmXM
        cgOWteyLXX56xH9XdMTJVi/3efv8tXEtndSo8Ypnx3fTK6jncvQsoozo3dHYJhi7gdew=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1okuJ6-002OPI-29; Tue, 18 Oct 2022 23:39:28 +0200
Date:   Tue, 18 Oct 2022 23:39:28 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Andrew Davis <afd@ti.com>
Cc:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Camelia Groza <camelia.groza@nxp.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH net] net: fman: Use physical address for userspace
 interfaces
Message-ID: <Y08dECNbfMc3VUcG@lunn.ch>
References: <20221017162807.1692691-1-sean.anderson@seco.com>
 <Y07guYuGySM6F/us@lunn.ch>
 <c409789a-68cb-7aba-af31-31488b16f918@seco.com>
 <97aae18e-a96c-a81b-74b7-03e32131a58f@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <97aae18e-a96c-a81b-74b7-03e32131a58f@ti.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 18, 2022 at 01:33:55PM -0500, Andrew Davis wrote:
> On 10/18/22 12:37 PM, Sean Anderson wrote:
> > Hi Andrew,
> > 
> > On 10/18/22 1:22 PM, Andrew Lunn wrote:
> > > On Mon, Oct 17, 2022 at 12:28:06PM -0400, Sean Anderson wrote:
> > > > For whatever reason, the address of the MAC is exposed to userspace in
> > > > several places. We need to use the physical address for this purpose to
> > > > avoid leaking information about the kernel's memory layout, and to keep
> > > > backwards compatibility.
> > > 
> > > How does this keep backwards compatibility? Whatever is in user space
> > > using this virtual address expects a virtual address. If it now gets a
> > > physical address it will probably do the wrong thing. Unless there is
> > > a one to one mapping, and you are exposing virtual addresses anyway.
> > > 
> > > If you are going to break backwards compatibility Maybe it would be
> > > better to return 0xdeadbeef? Or 0?
> > > 
> > >         Andrew
> > > 
> > 
> > The fixed commit was added in v6.1-rc1 and switched from physical to
> > virtual. So this is effectively a partial revert to the previous
> > behavior (but keeping the other changes). See [1] for discussion.

Please don't assume a reviewer has seen the previous
discussion. Include the background in the commit message to help such
reviewers.

> > 
> > --Sean
> > 
> > [1] https://lore.kernel.org/netdev/20220902215737.981341-1-sean.anderson@seco.com/T/#md5c6b66bc229c09062d205352a7d127c02b8d262
> 
> I see it asked in that thread, but not answered. Why are you exposing
> "physical" addresses to userspace? There should be no reason for that.

I don't see anything about needing physical or virtual address in the
discussion, or i've missed it.

If nobody knows why it is needed, either use an obfusticated value, or
remove it all together. If somebody/something does need it, they will
report the regression.

       Andrew
