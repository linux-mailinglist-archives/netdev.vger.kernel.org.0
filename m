Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 403D36EE9D9
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 23:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbjDYV5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 17:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236217AbjDYV5W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 17:57:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A020BBBE
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 14:57:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 258DA62A11
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 21:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43853C433D2;
        Tue, 25 Apr 2023 21:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682459840;
        bh=PWMy0qhUC/zd0fyiOIWaW3RQPEIwLSEGlvMc92NtfWk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K5oP3BGRJjsmVMpIdQE8wCYo6C4wokQ5pna1NG/MBTLANGFm6qBxUBuHuNMBxYow9
         SrEYnZTV7H+qFi+FogrxQCq9KZTNf1M+F1j/pqN5v1gLshOtMFgRrasiVYIcfq8ATM
         pDVd03+x60gNXyv0eC6z4hwWRX0scHug8AgPSTIQWRRGoz0tr0UdFDgo6MYwJZPYEN
         Ftv8reanxc0b85G87QRsipAu+5Go+aCwb+dr6vMk2D4HVqNok5xJCu0BIIVtmYqIqy
         usXkRxF1H1ooxuIhZDB9Lj5MtHOLcBXBVuHLgts1jE9pvYjHZTivfTRR5bkSqUlqDC
         N+xQI5cyadZmA==
Date:   Tue, 25 Apr 2023 14:57:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Arnd Bergmann" <arnd@arndb.de>
Cc:     "Paolo Abeni" <pabeni@redhat.com>, Netdev <netdev@vger.kernel.org>,
        "Andrew Lunn" <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        "Russell King" <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>
Subject: Re: [PATCH net-next] net: phy: drop PHYLIB_LEDS knob
Message-ID: <20230425145719.621d6568@kernel.org>
In-Reply-To: <dfb47650-549e-4e58-9177-fec6ab95b27c@app.fastmail.com>
References: <c783f6b8d8cc08100b13ce50a1330913dd95dbce.1682457539.git.pabeni@redhat.com>
        <dfb47650-549e-4e58-9177-fec6ab95b27c@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Apr 2023 22:35:46 +0100 Arnd Bergmann wrote:
> > @Andrew, @Arnd: the rationale here is to avoid the new config knob=y,
> > which caused in the past a few complains from Linus. In this case I
> > think the raised exception is not valid, for the reason mentioned above.
> >
> > If you have different preferences or better solutions to address that,
> > please voice them :)  
> 
> I think using IS_REACHABLE() is generally much worse than having another
> explicit option, because it makes it harder for users to figure out why
> something does not work as they had expected it to.
> 
> Note that I'm the one who introduced IS_REACHABLE() to start with,
> but the intention at the time was really to replace open-coded
> logic doing the same thing, not to have it as a generic way to
> hide broken dependencies.

Agreed :( But that kind of presupposed that user knows what they 
are looking for, right?

My thinking was this: using "depends on" instead and preventing
the bad configuration from occurring is a strongly preferred
alternative to IS_REACHABLE(). But an extra third option which will 
be hidden from nconfig will not prevent user from doing LEDS=m PHYS=y.
