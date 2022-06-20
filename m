Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4923A552334
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 19:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244653AbiFTRz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 13:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244585AbiFTRzx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 13:55:53 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E60E61ADB0;
        Mon, 20 Jun 2022 10:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=mTj4uZn0PoNW3alCMAhf9oZOxu+TdVk100uI5dBOjiY=; b=EIt3eVchZ8naQ87vKBgaewgOj8
        Ni9RO6XRwdW+XPRTJ71XojD0XnDFuNjeoffidiNkYcEA1q3A4djw6apEH8wllWXTbw+YJss5U9PDk
        fvCPqTCYfzhE84oiGJBlBOApAYdVnpcWHB7SmWb1CDeoLnH4s+DEi9kqeYcueHeWfjXY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o3Lcm-007dY3-5k; Mon, 20 Jun 2022 19:55:44 +0200
Date:   Mon, 20 Jun 2022 19:55:44 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        andriy.shevchenko@linux.intel.com, lenb@kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, hkallweit1@gmail.com,
        gjb@semihalf.com, jaz@semihalf.com, tn@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, upstream@semihalf.com
Subject: Re: [net-next: PATCH 00/12] ACPI support for DSA
Message-ID: <YrC0oKdDSjQTgUtM@lunn.ch>
References: <20220620150225.1307946-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620150225.1307946-1-mw@semihalf.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 05:02:13PM +0200, Marcin Wojtas wrote:
> Hi!
> 
> This patchset introduces the support for DSA in ACPI world. A couple of
> words about the background and motivation behind those changes:
> 
> The DSA code is strictly dependent on the Device Tree and Open Firmware
> (of_*) interface, both in the drivers and the common high-level net/dsa API.
> The only alternative is to pass the information about the topology via
> platform data - a legacy approach used by older systems that compiled the
> board description into the kernel.

Not true. There are deployed x86 systems which do this, and they are
fully up to date, not legacy. There are however limitations in what
you can do. So please drop this wording.

> The above constraint is problematic for the embedded devices based e.g. on
> x86_64 SoCs, which are described by ACPI tables - to use DSA, some tricks
> and workarounds have to be applied.

It would be good to describe the limitations. As i said, there are x86
systems running with marvell 6390 switches.

> It turned out that without much hassle it is possible to describe
> DSA-compliant switches as child devices of the MDIO busses, which are
> responsible for their enumeration based on the standard _ADR fields and
> description in _DSD objects under 'device properties' UUID [1].

No surprises there. That is how the DT binding works. And the current
ACPI concept is basically DT in different words. Maybe the more
important question is, is rewording DT in ACPI the correct approach,
or should you bo doing a more native ACPI implementation? I cannot
answer that, you need to ask the ACPI maintainers.

> Note that for now cascade topology remains unsupported in ACPI world
> (based on "dsa" label and "link" property values). It seems to be feasible,
> but would extend this patchset due to necessity of of_phandle_iterator
> migration to fwnode_. Leave it as a possible future step.

We really do need to ensure this is possible. You are setting an ABI
here, which everybody else in the ACPI world needs to follow. Cascaded
switches is fundamental to DSA, it is the D in DSA. So i would prefer
that you at least define and document the binding for D in DSA and get
it sanity checked by the ACPI people.

   Andrew
