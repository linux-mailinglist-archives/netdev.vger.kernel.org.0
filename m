Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7F153DDC1
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 20:50:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346862AbiFESuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 14:50:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234938AbiFESuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 14:50:39 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C17A4BFEA;
        Sun,  5 Jun 2022 11:50:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=FkE53r6nZQQnAV4acYE2B3cPYu+99cXnaAWSdrSExB8=; b=nDzEMPr0RF60x3uCg2Aqx/9UxD
        eK61NZQGsDucOJeU2sUyHecLCO8SPGTvk9aocS4yc2APaog33czsdLs+OodyLh+4IyjmHKSBAhEKk
        I6euiO1Aey8i/RghyI0B0SBFO2AbFKvYCq4ScGELVo8D16A0iDP9/nzFI5IUdrqOIeUI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nxvKX-005fbG-CV; Sun, 05 Jun 2022 20:50:29 +0200
Date:   Sun, 5 Jun 2022 20:50:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
Cc:     "kuba@kernel.org" <kuba@kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net-sysfs: allow changing sysfs carrier when interface
 is down
Message-ID: <Ypz69QV6n5mW6Wl4@lunn.ch>
References: <20220602003523.19530-1-joakim.tjernlund@infinera.com>
 <20220601180147.40a6e8ea@kernel.org>
 <4b700cbc93bc087115c1e400449bdff48c37298d.camel@infinera.com>
 <20220602085645.5ecff73f@hermes.local>
 <b4b1b8519ef9bfef0d09aeea7ab8f89e531130c8.camel@infinera.com>
 <20220602095756.764471e8@kernel.org>
 <f22f16c43411aafc0aaddd208e688dec1616e6bb.camel@infinera.com>
 <20220602105215.12aff895@kernel.org>
 <2765ed7299a05d6740ce7040b6ebe724b5979620.camel@infinera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2765ed7299a05d6740ce7040b6ebe724b5979620.camel@infinera.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 02, 2022 at 06:01:08PM +0000, Joakim Tjernlund wrote:
> On Thu, 2022-06-02 at 10:52 -0700, Jakub Kicinski wrote:
> > On Thu, 2 Jun 2022 17:15:13 +0000 Joakim Tjernlund wrote:
> > > > What is "our HW", what kernel driver does it use and why can't the
> > > > kernel driver take care of making sure the device is not accessed
> > > > when it'd crash the system?  
> > > 
> > > It is a custom asic with some homegrown controller. The full config path is too complex for kernel too
> > > know and depends on user input.
> > 
> > We have a long standing tradition of not caring about user space
> > drivers in netdev land. I see no reason to merge this patch upstream.
> 
> This is not a user space driver. View it as a eth controller with a dum PHY
> which cannot convey link status. The kernel driver then needs help with managing carrier.

Please post the MAC driver then. We don't really like changes to the
kernel without a user. You MAC driver would be such a user.

Could you also tell us more about the PHY. What capabilities does it
have? I assume it is not C22 compatible. Does it at least have some
sort of indicator of link? What might make sense is to use the
fixed-link code. You can provide a callback which gives the actual
link status up/down. And the fixed-link driver looks like a real PHY,
so the MAC driver does not need to do anything special.

   Andrew
