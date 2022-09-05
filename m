Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A27F5AD7FA
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 19:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbiIERBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 13:01:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbiIERBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 13:01:32 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F3B5E557
        for <netdev@vger.kernel.org>; Mon,  5 Sep 2022 10:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lBZxinyoQmF5EjXzN62yrc+Tx6T3i3l8nt7JxSW9rCU=; b=ogngQalNOdDqLn05ISPb84kghv
        qoTXUdI4JFHl5CBdZLRdEh6l5f3BFPpLAsXy4njGgGQzEsjLSPfCrAp/zKx5IA3YcicJm0ZsjLJ7x
        ASE3gdZQ/2UJ+oLiZgiAuNd2yqdStb7wTCDW0FCzeDd3yg9VYqwNz2ESgsXzqgRzyjnM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oVFTJ-00FfMK-BV; Mon, 05 Sep 2022 19:01:17 +0200
Date:   Mon, 5 Sep 2022 19:01:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Francois Romieu <romieu@fr.zoreil.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: remove not needed net_ratelimit() check
Message-ID: <YxYrXZXfaPxL8BqX@lunn.ch>
References: <1b1349bd-bb99-de1b-8323-2685d20f0c10@gmail.com>
 <YxNw/6qh5gwWZH7N@electric-eye.fr.zoreil.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxNw/6qh5gwWZH7N@electric-eye.fr.zoreil.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 03, 2022 at 05:21:35PM +0200, Francois Romieu wrote:
> Heiner Kallweit <hkallweit1@gmail.com> :
> > We're not in a hot path and don't want to miss this message,
> > therefore remove the net_ratelimit() check.
> >
> > Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> There had historically been some user push against excess "spam"
> messages, even when systems are able to stand a gazillion of phy
> generated messages - resources constrained systems may not - due
> to dysfunctionning hardware or externally triggered events.

Ethernet PHYs generally take 1 second to report link down. Auto neg
takes a little over 1 second to complete on link up. So i think the
worse case here is probably one message per second. Can a resource
constrained system be DoS at one message a second? If it really can, i
would suggest moving the rate limiting into the phylib helper, so all
devices are protected from this DoS vector.

       Andrew
