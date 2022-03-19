Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F254DE910
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 16:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243500AbiCSPel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 11:34:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243495AbiCSPek (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 11:34:40 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9F717E02
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 08:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=qmekRe2g7NP2YKVQZqTPyYy2azkn+cf4MKUDstpkU9E=; b=CB
        s9xf7g8NA0VWmOUVQyqx+awTh+YGxmc81VrQdPLrtLJ4Ie9ZJ3k3VtOrJI2l4KcBQL/xGSkr0GaNk
        v57irFSER5z6OPuNn2VhViVkE1GWxEzUYRrR0/Ac6BzOgRGQV7ncraj2y9ULKtUlCmy4FQSzgIB1d
        4B/hnjV6xOLY5kQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nVb4t-00Bic8-C1; Sat, 19 Mar 2022 16:33:15 +0100
Date:   Sat, 19 Mar 2022 16:33:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Parthiban.Veerasooran@microchip.com
Cc:     netdev@vger.kernel.org, Jan.Huber@microchip.com,
        Thorsten.Kummermehr@microchip.com
Subject: Re: Clarification on user configurable parameters implementation in
 PHY driver
Message-ID: <YjX3u7FvPCaVmsmp@lunn.ch>
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

Hi Parthiban

I just had a quick read of 802.3cg.

As far as i see, it does not define the registers used to control
PLCA. So i guess each vendor will define there own registers in the
vendor section of clause 45? This also means there will not be a
shared implementation in linux, so the API you define needs to go all
the way down into the PHY driver.

What is defined are the management objects. Table 30-11, PLCA
capabilities defines:

aPLCAAdminState ATTRIBUTE GET
aPLCAStatus ATTRIBUTE GET
aPLCABurstTimer ATTRIBUTE GET-SET
aPLCALocalNodeID ATTRIBUTE GET-SET
aPLCAMaxBurstCount ATTRIBUTE GET-SET
aPLCANodeCount ATTRIBUTE GET-SET
aPLCATransmitOpportunityTimer ATTRIBUTE GET-SET

This is basically what you listed above. 

So i suggest you define a netlink API around these, as part of the
Ethtool API. You can reference the standard when defining the API, so
making it clear what the netlink attributes mean, what unit they use
etc.

	Andrew
