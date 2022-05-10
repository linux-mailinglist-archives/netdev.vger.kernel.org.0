Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A6A5214EE
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 14:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241576AbiEJMRq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241177AbiEJMRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:17:45 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429A54F45F
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 05:13:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=jYg6hjcXxGtlrCwep9J9XWfjdnaomxhWncqAJZxW8Hs=; b=5dPVxdJJDv/kk3sAFd58KycaHf
        awD3KD7mSBgixCtIW2ZWzlBQsLWKVtwrAvJ0Yra/T2MbmKgjkJoeqHBfGRTeoMiySjFJ3u6VHmD40
        FwIuy0heaWZMYuJufd79/xP7n7hDVHsPYzulhl6pfmdo/fWPYNijFkFEUMC8FIBcwXPQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1noOkI-00282a-39; Tue, 10 May 2022 14:13:42 +0200
Date:   Tue, 10 May 2022 14:13:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Josua Mayer <josua@solid-run.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH RFC] net: sfp: support assigning status LEDs to SFP
 connectors
Message-ID: <YnpW9nSZ2zMAmmq0@lunn.ch>
References: <20220509122938.14651-1-josua@solid-run.com>
 <YnkN954Wb7ioPkru@lunn.ch>
 <1bc46272-f26b-14a5-0139-a987b47a5814@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bc46272-f26b-14a5-0139-a987b47a5814@solid-run.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > As far as i'm aware, the in kernel code always has a netdev for each
> > MAC. Are you talking about the vendor stack?
> The coprocessor can be configured both at boot-time and runtime.
> During runtime there is a vendor tool "restool" which can create and destroy
> network interfaces, which the dpaa2 driver knows to discover and bind to.

There should not be any need to use a vendor tool for mainline. In
fact, that is strongly discouraged, since it leads to fragmentation,
each device doing its own thing, the user needing to read each vendors
user manual, rather than it just being a standard Unix box with
interfaces.

What should happen is that all the front panel interfaces exist from
boot. If you want to add them to a bridge, for example, you do so in
the normal linux way, create a bridge and add an interface to the
bridge. The kernel driver can then talk to the coprocessor and magic
up a dpaa2 bridge object, and add the port to the bridge, but as far
as the user is concerned, it should all be the usual iproute2
commands, nothing more.

	  Andrew
