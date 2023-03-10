Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1716B4DA6
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 17:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbjCJQxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 11:53:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbjCJQxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 11:53:03 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F38331314C2
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 08:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=fk8eUHUpP4rATEiPERqsMzQrRrydxsbaKXJ3VW/oOzA=; b=ml
        y/c4YVdVwaaU6ocdhZpBSqKukXOB0EXQUlN0+sL+nnhNyz7ijZYP6oj8RjEacVU66WLOa9wQaq7uM
        ccQIch9+EYDjIK5WM7VQkjOfxPe5dHfdInOlTAcCB48ISBk0OZGxaRGE5dvKjKqhGL1lfJs624QJJ
        qq/A6ExS/iEyW0Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pafwh-006zu8-VA; Fri, 10 Mar 2023 17:50:19 +0100
Date:   Fri, 10 Mar 2023 17:50:19 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Parthiban.Veerasooran@microchip.com
Cc:     netdev@vger.kernel.org, Jan.Huber@microchip.com,
        Thorsten.Kummermehr@microchip.com
Subject: Re: RFC: Adding Microchip's LAN865x 10BASE-T1S MAC-PHY driver
 support to Linux
Message-ID: <b971e2ef-5e4d-4300-b813-97ebd18ba54c@lunn.ch>
References: <076fbcec-27e9-7dc2-14cb-4b0a9331b889@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <076fbcec-27e9-7dc2-14cb-4b0a9331b889@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 11:13:23AM +0000, Parthiban.Veerasooran@microchip.com wrote:
> Hi All,
> 
> I would like to add Microchip's LAN865x 10BASE-T1S MAC-PHY driver 
> support to Linux kernel.
> (Product link: https://www.microchip.com/en-us/product/LAN8650)
> 
> The LAN8650 combines a Media Access Controller (MAC) and an Ethernet PHY 
> to access 10BASE‑T1S networks. The common standard Serial Peripheral 
> Interface (SPI) is used so that the transfer of Ethernet packets and 
> LAN8650 control/status commands are performed over a single, serial 
> interface.
> 
> Ethernet packets are segmented and transferred over the serial interface
> according to the OPEN Alliance 10BASE‑T1x MAC‑PHY Serial Interface 
> specification designed by TC6.
> (link: https://www.opensig.org/Automotive-Ethernet-Specifications/)
> The serial interface protocol can simultaneously transfer both transmit 
> and receive packets between the host and the LAN8650.
> 
> Basically the driver comprises of two parts. One part is to interface 
> with networking subsystem and SPI subsystem. The other part is a TC6 
> state machine which implements the Ethernet packets segmentation 
> according to OPEN Alliance 10BASE‑T1x MAC‑PHY Serial Interface 
> specification.

I only spent about 5 minutes glancing through the standards document,
but i guess i would disagree with this. I would say 90% is shared code
which probably wants to live in net/ethernet, and the remaining 10% is
code for where the silicon vendor has extra registers that need to be
used, workarounds for silicon bugs, etc. I guess hardware statistics
would also be in this part of code, since they don't seem to be in the
standard.

Please also make sure you keep with the Linux network architecture. I
would expect the shared code includes a linux MDIO bus driver, so the
existing PHY drivers can be used. PTP time stamping should be done the
standard Linux way. PLCA is configured using the netlink methods
recently added, etc. And it looks like all this should be in the
shared code, since it is all part of the standard.

	 Andrew

	 
