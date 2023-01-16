Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F8F66D143
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 23:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234562AbjAPWE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 17:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234256AbjAPWEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 17:04:25 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90E9625E03;
        Mon, 16 Jan 2023 14:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=uazCoJXtzlq2kShlcT9rXD6tOctqES9trOINp4voJPQ=; b=HbsVr2uw3QcN5Haiwf2oauolr4
        Q1wpFz/1qvpARLsRMeTnrxxLPykIcbZ9qPZEfg3GdTES4pGeXkHiQulW8KdoyjNHopQX/zxIPm3CA
        jL/pFa/9SFYlHwHsV0jYy94nWtzULKX3+n/jvE9iKcTiehNTI/vG6oVUPJmzCOOgbXP4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pHXaP-002GdJ-Uh; Mon, 16 Jan 2023 23:04:13 +0100
Date:   Mon, 16 Jan 2023 23:04:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, netdev@vger.kernel.org,
        rafael@kernel.org, andriy.shevchenko@linux.intel.com,
        sean.wang@mediatek.com, Landen.Chao@mediatek.com,
        linus.walleij@linaro.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hkallweit1@gmail.com,
        jaz@semihalf.com, tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com
Subject: Re: [net-next: PATCH v4 2/8] net: mdio: switch fixed-link PHYs API
 to fwnode_
Message-ID: <Y8XJ3WoP+YKCjTlF@lunn.ch>
References: <20230116173420.1278704-1-mw@semihalf.com>
 <20230116173420.1278704-3-mw@semihalf.com>
 <Y8WOVVnFInEoXLVX@shell.armlinux.org.uk>
 <20230116181618.2iz54jywj7rqzygu@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116181618.2iz54jywj7rqzygu@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 16, 2023 at 08:16:18PM +0200, Vladimir Oltean wrote:
> On Mon, Jan 16, 2023 at 05:50:13PM +0000, Russell King (Oracle) wrote:
> > On Mon, Jan 16, 2023 at 06:34:14PM +0100, Marcin Wojtas wrote:
> > > fixed-link PHYs API is used by DSA and a number of drivers
> > > and was depending on of_. Switch to fwnode_ so to make it
> > > hardware description agnostic and allow to be used in ACPI
> > > world as well.
> > 
> > Would it be better to let the fixed-link PHY die, and have everyone use
> > the more flexible fixed link implementation in phylink?
> 
> Would it be even better if DSA had some driver-level prerequisites to
> impose for ACPI support - like phylink support rather than adjust_link -
> and we would simply branch off to a dsa_shared_port_link_register_acpi()
> function, leaving the current dsa_shared_port_link_register_of() alone,
> with all its workarounds and hacks? I don't believe that carrying all
> that logic over to a common fwnode based API is the proper way forward.

I agree with you there, here is little attempt to make a clean ACPI
binding. Most of the attempts to add ACPI support seem to try to take
the short cut for just search/replace of_ with fwnode_. And we then
have to push back and say no, and generally it then goes quiet.

Marcin, please approach this from the other end. Please document in
Documentation/firmware-guide/acpi/dsd what a clean binding should look
like, and then try to implement it.

      Andrew
