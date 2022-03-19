Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391A84DE4EE
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 01:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241689AbiCSA4N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 20:56:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234268AbiCSA4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 20:56:13 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC1C3076E1
        for <netdev@vger.kernel.org>; Fri, 18 Mar 2022 17:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=xRPjkNA0r69WJ55Ey6a+bSXtPR7Yy9E/dAU6pox7a2U=; b=wY
        3rD68JxRu1oDNvg2mOxG8Mn04KH+InAV3LAT1FaNMg+lbGEONAqaPlKnPfrggemnDVjCBAiWCSzgR
        ++MS/IAf6I3kbkLWXmYvujNrkO4dSNwR9NshtDwRR4nQHS9ZL95TqPxTNgSXowsjv7+mjrR6Btcuv
        iEw1JMPOnaKluJA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nVNMp-00Be81-W1; Sat, 19 Mar 2022 01:54:51 +0100
Date:   Sat, 19 Mar 2022 01:54:51 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Parthiban.Veerasooran@microchip.com
Cc:     netdev@vger.kernel.org, Jan.Huber@microchip.com,
        Thorsten.Kummermehr@microchip.com
Subject: Re: Clarification on user configurable parameters implementation in
 PHY driver
Message-ID: <YjUp2y100f8FA7/A@lunn.ch>
References: <e8521999-7f3a-8aa9-4e63-a81c6175c088@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e8521999-7f3a-8aa9-4e63-a81c6175c088@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 12:30:47PM +0000, Parthiban.Veerasooran@microchip.com wrote:
> Hi All,
> 
> Microchip LAN8670 is a high-performance 10BASE-T1S single-pair Ethernet 
> PHY transceiver for 10 Mbit/s half-duplex networking over a single pair 
> of conductors. The LAN8670 is designed for use in high-reliability cost 
> sensitive industrial, back plane, and building automation 
> sensor/actuator applications.
> 
> Physical Layer Collision Avoidance (PLCA) is one of the features in this 
> PHY which allows for high bandwidth utilization by avoiding collisions 
> on the physical layer and burst mode for transmission of multiple 
> packets for high packet rate latency-sensitive applications. This PLCA 
> feature uses the following user configurable parameters to be configured 
> through PHY driver.
> 
>      1. PLCA node id
>      2. PLCA node count
>      3. PLCA transmit opportunity time
>      4. PLCA max burst count
>      5. PLCA max burst time
>      6. PLCA enable/disable
> 
> In the existing PHY frame work, I don't see any interface to expose the 
> user configurable parameters to user space from PHY driver. I did even 
> refer some PHY drivers in the kernel source and they are hard coded the 
> configurable values in the driver and of course they are not needed to 
> be configured by user.
> 
> But in our case, the above parameters are user configurable for 
> different nodes (Ethernet interfaces) in the network.
> 
> Could you please propose a right approach to implement the above 
> requirement ?

Hi Parthiban

This is part of Clause 148?

Are the parameters you listed part of 148, or are they specific to
your implementation?

Whatever API you define, it needs to be generic to any PHY which
implements clause 148. So ideally you need to look at clause 148, not
what you datasheet says, and define the API around clause 148. It also
sounds like you should be implementing the users space tool, which
might actually be an extension of ethtool. ethtool has been
transitioning to netlink over the last few years, so i would suggest
you define a generic netlink API within the ethtool framework.

    Andrew

