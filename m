Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E192C5523BB
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 20:19:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245255AbiFTSTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 14:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238101AbiFTSTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 14:19:20 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F8D31CFDC;
        Mon, 20 Jun 2022 11:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CSF2/zODwo1Na+ao/0ihWv1boJjxEfP5yBIxXEy8mw4=; b=b5yL1nUzpSzvXEKn2wa3M2w74h
        BpHGAASxMRN36cfz3NvkFPQaHR0WhUtB+Pihd7+3IxIpvzkuiRCLKF+rniDZJBroGBx0QXahYSvWM
        hMUgw8Y27j2wTUizfFCWtSv+R2a4zlP2yl7rBGzIOJs43pjrgUkHwMMeOBiPL8j2eXSQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1o3LzW-007dh9-U7; Mon, 20 Jun 2022 20:19:14 +0200
Date:   Mon, 20 Jun 2022 20:19:14 +0200
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
Subject: Re: [net-next: PATCH 09/12] Documentation: ACPI: DSD: introduce DSA
 description
Message-ID: <YrC6Ihd4I13ctL18@lunn.ch>
References: <20220620150225.1307946-1-mw@semihalf.com>
 <20220620150225.1307946-10-mw@semihalf.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620150225.1307946-10-mw@semihalf.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 20, 2022 at 05:02:22PM +0200, Marcin Wojtas wrote:
> Describe the Distributed Switch Architecture (DSA) - compliant
> MDIO devices. In ACPI world they are represented as children
> of the MDIO busses, which are responsible for their enumeration
> based on the standard _ADR fields and description in _DSD objects
> under device properties UUID [1].

I would say this is too limiting. In the DT world, they are not
limited to MDIO children. They can be I2C children, SPI children
etc. There are plenty of I2C switches and SPI switches. This is
actually something we got wrong with the first DT binding. We simply
translated the platform data in DT, and at that time, there was only
MDIO switches supported. That was a real blocker to I2C, SPI and MMIO
devices until we discarded the DT binding and had a second go.

DSA switches are just devices on a bus, any sort of bus.

Look at Documentation/devicetree/binding/net/dsa/dsa.yaml. There is no
reference to MDIO.

I would expect the same with ACPI. Somehow the bus enumerates and
instantiates a device on the bus. The device then registers itself
with the DSA core. The DSA core does not care what sort of bus it is
on, that is the drivers problem.

     Andrew
